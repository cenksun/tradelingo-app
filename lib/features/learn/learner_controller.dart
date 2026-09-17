import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../domain/models/achievement.dart';
import '../../domain/models/activity.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/lesson.dart';
import '../../domain/models/review_item.dart';
import '../../domain/models/skill.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/achievement_unlock.dart';
import '../../domain/services/mastery_engine.dart';
import '../../domain/services/spaced_repetition.dart';
import '../../domain/services/streak_service.dart';
import '../../domain/services/xp_rules.dart';
import 'learner_state.dart';

/// Result of finishing a lesson, used to drive the completion screen.
class LessonOutcome {
  const LessonOutcome({
    required this.lesson,
    required this.correct,
    required this.total,
    required this.xpAwarded,
    required this.perfect,
    required this.passed,
    required this.heartsRemaining,
    required this.masteryChanges,
    required this.weakConcepts,
    required this.unlockedAchievements,
    required this.leveledUp,
    required this.newLevel,
  });

  final Lesson lesson;
  final int correct;
  final int total;
  final int xpAwarded;
  final bool perfect;
  final bool passed;
  final int heartsRemaining;

  /// Skill id to mastery delta.
  final Map<String, double> masteryChanges;
  final List<String> weakConcepts;
  final List<Achievement> unlockedAchievements;
  final bool leveledUp;
  final int newLevel;

  double get accuracy => total == 0 ? 1 : correct / total;
}

/// Central controller for learning progress.
class LearnerController extends AsyncNotifier<LearnerState> {
  /// One heart returns after this long, up to the maximum.
  static const Duration heartRegenInterval = Duration(minutes: 25);

  DateTime get _now => ref.read(clockProvider)();

  ProfileRepository get _profiles => ref.read(profileRepositoryProvider);
  ProgressRepository get _progress => ref.read(progressRepositoryProvider);
  JournalRepository get _journal => ref.read(journalRepositoryProvider);
  ChallengeRepository get _challenges => ref.read(challengeRepositoryProvider);
  Curriculum get _curriculum => ref.read(curriculumProvider);

  @override
  Future<LearnerState> build() => _load();

  Future<LearnerState> _load() async {
    final now = _now;
    var profile = await _profiles.loadProfile();
    profile = _applyHeartRegen(profile, now);

    final settings = await _profiles.loadSettings();
    final streak = await _profiles.loadStreak();
    final lessonProgress = await _progress.loadLessonProgress();
    final mastery = await _progress.loadMastery();
    final reviewItems = await _progress.loadReviewItems();
    final unlocked = await _progress.loadUnlockedAchievements();
    final account = await _journal.loadAccount();
    final xpToday = await _profiles.xpEarnedOn(now);
    final entries = await _journal.loadEntries(limit: 1000);
    final dailies = await _challenges.countCompletedDailies();

    final stats = _computeStats(lessonProgress, mastery, reviewItems);

    return LearnerState(
      profile: profile,
      settings: settings,
      streak: streak,
      lessonProgress: lessonProgress,
      mastery: mastery,
      reviewItems: reviewItems,
      unlockedAchievements: unlocked,
      account: account,
      xpToday: xpToday,
      stats: stats,
      now: now,
      disciplinedTrades: entries
          .where((e) => !e.isNoTrade && e.riskPercent > 0 && e.riskPercent <= 2)
          .length,
      noTradeDecisions: entries.where((e) => e.isNoTrade).length,
      journalNotes: entries.where((e) => e.note.trim().isNotEmpty).length,
      dailyChallengesCompleted: dailies,
    );
  }

  ProgressStats _computeStats(
    Map<String, LessonProgress> lessonProgress,
    Map<String, SkillMastery> mastery,
    List<ReviewItem> reviewItems,
  ) {
    var lessons = 0;
    var perfect = 0;
    var bosses = 0;
    for (final world in _curriculum.worlds) {
      for (final lesson in world.lessons) {
        final p = lessonProgress[lesson.id];
        if (p == null || !p.isCompleted) continue;
        lessons++;
        if (p.perfect) perfect++;
        if (lesson.isBoss) bosses++;
      }
    }
    final worldsComplete = _curriculum.worlds
        .where(
          (w) => w.lessons.every(
            (l) => lessonProgress[l.id]?.isCompleted ?? false,
          ),
        )
        .length;

    var attempts = 0;
    var correct = 0;
    for (final m in mastery.values) {
      attempts += m.attempts;
      correct += m.correct;
    }
    final reviewSessions = reviewItems.fold<int>(
      0,
      (sum, item) => sum + item.repetitions,
    );

    return ProgressStats(
      lessonsCompleted: lessons,
      perfectLessons: perfect,
      bossesPassed: bosses,
      worldsCompleted: worldsComplete,
      questionsAnswered: attempts,
      correctAnswers: correct,
      reviewSessions: reviewSessions ~/ 5,
    );
  }

  /// Hearts refill gradually, so running out is never a dead end even without
  /// a practice session.
  UserProfile _applyHeartRegen(UserProfile profile, DateTime now) {
    if (profile.hearts >= UserProfile.maxHearts) return profile;
    final last = profile.heartsUpdatedAt;
    if (last == null) {
      return profile.copyWith(heartsUpdatedAt: now);
    }
    final elapsed = now.difference(last);
    if (elapsed.isNegative) return profile;
    final regained = elapsed.inMinutes ~/ heartRegenInterval.inMinutes;
    if (regained <= 0) return profile;
    final hearts = math.min(UserProfile.maxHearts, profile.hearts + regained);
    return profile.copyWith(
      hearts: hearts,
      heartsUpdatedAt: hearts >= UserProfile.maxHearts
          ? now
          : last.add(heartRegenInterval * regained),
    );
  }

  Future<void> refresh() async {
    state = AsyncData(await _load());
  }

  // ------------------------------------------------------------ profile ---

  Future<void> completeOnboarding({
    required String username,
    required ExperienceLevel level,
    required int dailyGoalMinutes,
    required String avatarId,
  }) async {
    final current = state.value?.profile ?? const UserProfile();
    final profile = current.copyWith(
      username: username.trim().isEmpty ? 'Trader' : username.trim(),
      experienceLevel: level,
      dailyGoalMinutes: dailyGoalMinutes,
      avatarId: avatarId,
      onboardingComplete: true,
      createdAt: current.createdAt ?? _now,
    );
    await _profiles.saveProfile(profile);
    final settings = state.value?.settings ?? const AppSettings();
    await _profiles.saveSettings(
      settings.copyWith(dailyGoalMinutes: dailyGoalMinutes),
    );
    await refresh();
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _profiles.saveProfile(profile);
    await refresh();
  }

  Future<void> updateSettings(AppSettings settings) async {
    await _profiles.saveSettings(settings);
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(settings: settings));
    }
    await refresh();
  }

  // ------------------------------------------------------------- hearts ---

  Future<void> loseHeart() async {
    final current = state.value;
    if (current == null) return;
    final hearts = math.max(0, current.profile.hearts - 1);
    final profile = current.profile.copyWith(
      hearts: hearts,
      heartsUpdatedAt: _now,
    );
    await _profiles.saveProfile(profile);
    state = AsyncData(current.copyWith(profile: profile));
  }

  Future<void> gainHearts(int count) async {
    final current = state.value;
    if (current == null || count <= 0) return;
    final hearts = math.min(
      UserProfile.maxHearts,
      current.profile.hearts + count,
    );
    final profile = current.profile.copyWith(
      hearts: hearts,
      heartsUpdatedAt: _now,
    );
    await _profiles.saveProfile(profile);
    state = AsyncData(current.copyWith(profile: profile));
  }

  // ------------------------------------------------------------ answers ---

  /// Records one graded answer: attempt log, skill mastery and review queue.
  Future<Map<String, double>> recordAnswer({
    required Activity activity,
    required String lessonId,
    required bool correct,
    double partialCredit = 0,
    String context = 'lesson',
  }) async {
    final now = _now;
    final deltas = <String, double>{};

    await _progress.recordAttempt(
      AttemptRecord(
        at: now,
        lessonId: lessonId,
        activityId: activity.id,
        activityKind: activity.kind.name,
        skillId: activity.skillIds.first,
        conceptTag: activity.concept,
        difficulty: activity.difficulty,
        correct: correct,
        context: context,
      ),
    );

    final masteryMap = state.value?.mastery ?? await _progress.loadMastery();
    for (final skillId in activity.skillIds) {
      final before = masteryMap[skillId] ?? SkillMastery(skillId: skillId);
      final after = MasteryEngine.applyAnswer(
        current: before,
        correct: correct,
        difficulty: activity.difficulty,
        now: now,
        partialCredit: partialCredit,
      );
      await _progress.saveMastery(after);
      deltas[skillId] = after.score - before.score;
    }

    final existing = await _progress.loadReviewItem(activity.concept);
    final item = existing == null
        ? SpacedRepetition.create(
            conceptTag: activity.concept,
            skillId: activity.skillIds.first,
            now: now,
            correct: correct,
            difficulty: activity.difficulty,
          )
        : SpacedRepetition.review(
            item: existing,
            correct: correct,
            now: now,
            difficulty: activity.difficulty,
            partialCredit: partialCredit,
          );
    await _progress.saveReviewItem(item);

    return deltas;
  }

  // ------------------------------------------------------------ lessons ---

  Future<LessonOutcome> completeLesson({
    required Lesson lesson,
    required int correctCount,
    required int gradedCount,
    required Map<String, double> masteryChanges,
    required List<String> weakConcepts,
  }) async {
    final now = _now;
    final accuracy = gradedCount == 0 ? 1.0 : correctCount / gradedCount;
    final perfect = gradedCount > 0 && correctCount == gradedCount;
    final passed = !lesson.isBoss || accuracy >= lesson.passThreshold;

    final before = state.value;
    final levelBefore = before?.level.level ?? 1;

    var awarded = 0;
    if (passed) {
      final existing = before?.lessonProgress[lesson.id];
      final previousCompletions = existing?.completions ?? 0;
      final baseXp = XpRules.forLessonCompletion(
        lesson: lesson,
        correctCount: correctCount,
        gradedCount: gradedCount,
        perfect: perfect,
      );
      final decayed = XpRules.applyRepeatDecay(baseXp, previousCompletions);
      awarded = await _profiles.addXp(
        amount: decayed,
        source: lesson.isBoss ? XpSource.boss : XpSource.lesson,
        reference: lesson.id,
        at: now,
      );

      await _progress.saveLessonProgress(
        LessonProgress(
          lessonId: lesson.id,
          completions: previousCompletions + 1,
          bestAccuracy: math.max(existing?.bestAccuracy ?? 0, accuracy),
          lastAccuracy: accuracy,
          perfect: (existing?.perfect ?? false) || perfect,
          lastCompletedAt: now,
        ),
      );

      await _recordMeaningfulActivity(now);
    }

    final unlocked = await _syncAchievements();
    await refresh();
    final after = state.value;

    return LessonOutcome(
      lesson: lesson,
      correct: correctCount,
      total: gradedCount,
      xpAwarded: awarded,
      perfect: perfect,
      passed: passed,
      heartsRemaining: after?.profile.hearts ?? 0,
      masteryChanges: masteryChanges,
      weakConcepts: weakConcepts,
      unlockedAchievements: unlocked,
      leveledUp: (after?.level.level ?? 1) > levelBefore,
      newLevel: after?.level.level ?? levelBefore,
    );
  }

  // -------------------------------------------------------- simulations ---

  /// Records a finished simulation: journal entry, virtual account, XP.
  Future<List<Achievement>> completeSimulation({
    required JournalEntry entry,
    required double processScore,
  }) async {
    final now = _now;
    await _journal.addEntry(entry);
    await _journal.applyTradeResult(
      profitLoss: entry.profitLoss,
      rMultiple: entry.rMultiple,
      journalEntryId: entry.id,
      at: now,
    );
    await _profiles.addXp(
      amount: XpRules.forSimulation(processScore: processScore),
      source: XpSource.simulation,
      reference: entry.scenarioId,
      at: now,
    );
    await _recordMeaningfulActivity(now);
    final unlocked = await _syncAchievements();
    await refresh();
    return unlocked;
  }

  Future<void> addJournalNote(JournalEntry entry) async {
    await _journal.updateEntry(entry);
    await refresh();
  }

  // ------------------------------------------------------------ practice ---

  Future<int> completePracticeSession({
    required int itemsCleared,
    required bool forHearts,
  }) async {
    final now = _now;
    final xp = forHearts
        ? XpRules.heartsPracticeComplete
        : XpRules.forReviewSession(itemsCleared);
    final awarded = await _profiles.addXp(
      amount: xp,
      source: forHearts ? XpSource.hearts : XpSource.review,
      at: now,
    );
    if (forHearts) {
      await gainHearts(2);
    }
    await _recordMeaningfulActivity(now);
    await _syncAchievements();
    await refresh();
    return awarded;
  }

  Future<int> awardChallengeXp({
    required int amount,
    required XpSource source,
    String? reference,
  }) async {
    final now = _now;
    final awarded = await _profiles.addXp(
      amount: amount,
      source: source,
      reference: reference,
      at: now,
    );
    await _recordMeaningfulActivity(now);
    await _syncAchievements();
    await refresh();
    return awarded;
  }

  // -------------------------------------------------------------- resets ---

  Future<void> resetLearningProgress() async {
    await ref.read(appDatabaseProvider).resetLearningProgress();
    await refresh();
  }

  Future<void> resetSimulator() async {
    final settings = state.value?.settings ?? const AppSettings();
    await _journal.resetSimulator(
      startingBalance: settings.simulatorStartingBalance,
    );
    await refresh();
  }

  Future<void> resetEverything() async {
    final settings = state.value?.settings ?? const AppSettings();
    await ref
        .read(appDatabaseProvider)
        .resetEverything(startingBalance: settings.simulatorStartingBalance);
    await refresh();
  }

  // ------------------------------------------------------------- helpers ---

  /// Extends the streak and awards a milestone bonus where one is reached.
  ///
  /// Only called from genuine learning activity — never from opening the app.
  Future<void> _recordMeaningfulActivity(DateTime now) async {
    final streak = await _profiles.loadStreak();
    final next = StreakService.recordActivity(streak, now);
    if (next.current == streak.current &&
        next.lastActiveDay == streak.lastActiveDay) {
      return;
    }
    await _profiles.saveStreak(next);
    if (StreakService.isMilestone(next.current)) {
      await _profiles.addXp(
        amount: XpRules.streakMilestone,
        source: XpSource.streak,
        reference: '${next.current}-day',
        at: now,
      );
    }
  }

  Future<List<Achievement>> _syncAchievements() async {
    final fresh = await _load();
    final unlocked = await _progress.loadUnlockedAchievements();
    final newly = AchievementEngine.newlyUnlocked(
      stats: fresh.achievementStats,
      unlocked: unlocked,
    );
    for (final a in newly) {
      await _progress.unlockAchievement(a.id, _now);
    }
    return newly;
  }
}

final learnerControllerProvider =
    AsyncNotifierProvider<LearnerController, LearnerState>(
      LearnerController.new,
    );

/// Convenience: the achievements that are currently unlocked, with progress.
final achievementProgressProvider = Provider<List<AchievementProgress>>((ref) {
  final state = ref.watch(learnerControllerProvider).value;
  if (state == null) return const [];
  final stats = state.achievementStats;
  return [
    for (final a in Achievements.all)
      AchievementProgress(
        achievement: a,
        unlocked: state.unlockedAchievements.contains(a.id),
        value: stats.valueFor(a.metric),
      ),
  ];
});
