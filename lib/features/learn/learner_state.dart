import 'package:meta/meta.dart';

import '../../domain/models/achievement.dart';
import '../../domain/models/lesson.dart';
import '../../domain/models/review_item.dart';
import '../../domain/models/skill.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/level_system.dart';
import '../../domain/services/streak_service.dart';

/// Everything the learn, profile and practice screens read from.
///
/// Held as one immutable object so progression, hearts, streak and mastery can
/// never be shown out of step with one another.
@immutable
class LearnerState {
  const LearnerState({
    required this.profile,
    required this.settings,
    required this.streak,
    required this.lessonProgress,
    required this.mastery,
    required this.reviewItems,
    required this.unlockedAchievements,
    required this.account,
    required this.xpToday,
    required this.stats,
    required this.now,
    this.disciplinedTrades = 0,
    this.noTradeDecisions = 0,
    this.journalNotes = 0,
    this.dailyChallengesCompleted = 0,
  });

  final UserProfile profile;
  final AppSettings settings;
  final StreakState streak;
  final Map<String, LessonProgress> lessonProgress;
  final Map<String, SkillMastery> mastery;
  final List<ReviewItem> reviewItems;
  final Set<String> unlockedAchievements;
  final SimulatorAccount account;
  final int xpToday;
  final ProgressStats stats;
  final DateTime now;

  /// Counters derived from the journal and challenge tables, supplied by the
  /// controller so the achievement engine has a single input object.
  final int disciplinedTrades;
  final int noTradeDecisions;
  final int journalNotes;
  final int dailyChallengesCompleted;

  LevelProgress get level => LevelSystem.progressFor(profile.totalXp);

  int get displayedStreak => StreakService.displayedStreak(streak, now);

  bool get streakAtRisk => StreakService.atRisk(streak, now);

  /// Minutes-of-goal progress is approximated from XP earned today against the
  /// learner's daily goal, since the app does not track wall-clock study time.
  double get dailyGoalFraction {
    final target = profile.dailyGoalMinutes * 12;
    if (target <= 0) return 0;
    return (xpToday / target).clamp(0.0, 1.0);
  }

  bool isLessonCompleted(String lessonId) =>
      lessonProgress[lessonId]?.isCompleted ?? false;

  /// A lesson is available once every prerequisite is completed.
  bool isLessonUnlocked(Lesson lesson) {
    for (final id in lesson.prerequisiteLessonIds) {
      if (!isLessonCompleted(id)) return false;
    }
    return true;
  }

  /// The set of unlocked lesson ids, used by practice so it never draws from
  /// material the learner has not reached.
  Set<String> unlockedLessonIds(Curriculum curriculum) => {
    for (final lesson in curriculum.allLessons)
      if (isLessonUnlocked(lesson)) lesson.id,
  };

  bool isWorldUnlocked(Curriculum curriculum, World world) {
    if (world.lessons.isEmpty) return true;
    return isLessonUnlocked(world.lessons.first);
  }

  int completedLessonsIn(World world) =>
      world.lessons.where((l) => isLessonCompleted(l.id)).length;

  double worldProgress(World world) {
    if (world.lessons.isEmpty) return 0;
    return completedLessonsIn(world) / world.lessons.length;
  }

  bool isWorldComplete(World world) =>
      world.lessons.isNotEmpty &&
      world.lessons.every((l) => isLessonCompleted(l.id));

  /// The next lesson the learner should open.
  Lesson? nextLesson(Curriculum curriculum) {
    for (final world in curriculum.worlds) {
      for (final lesson in world.lessons) {
        if (!isLessonCompleted(lesson.id) && isLessonUnlocked(lesson)) {
          return lesson;
        }
      }
    }
    return null;
  }

  SkillMastery masteryFor(String skillId) =>
      mastery[skillId] ?? SkillMastery(skillId: skillId);

  int get dueReviewCount {
    var count = 0;
    for (final item in reviewItems) {
      if (item.isDue(now)) count++;
    }
    return count;
  }

  AchievementStats get achievementStats => AchievementStats(
    lessonsCompleted: stats.lessonsCompleted,
    perfectLessons: stats.perfectLessons,
    questionsAnswered: stats.questionsAnswered,
    correctAnswers: stats.correctAnswers,
    simulationsCompleted: account.tradeCount,
    currentStreak: displayedStreak,
    bossesPassed: stats.bossesPassed,
    reviewSessions: stats.reviewSessions,
    disciplinedTrades: disciplinedTrades,
    structureMastery: masteryFor(Skills.marketStructure).score.round(),
    noTradeDecisions: noTradeDecisions,
    journalNotes: journalNotes,
    worldsCompleted: stats.worldsCompleted,
    dailyChallenges: dailyChallengesCompleted,
  );

  LearnerState copyWith({
    UserProfile? profile,
    AppSettings? settings,
    StreakState? streak,
    Map<String, LessonProgress>? lessonProgress,
    Map<String, SkillMastery>? mastery,
    List<ReviewItem>? reviewItems,
    Set<String>? unlockedAchievements,
    SimulatorAccount? account,
    int? xpToday,
    ProgressStats? stats,
    DateTime? now,
    int? disciplinedTrades,
    int? noTradeDecisions,
    int? journalNotes,
    int? dailyChallengesCompleted,
  }) => LearnerState(
    profile: profile ?? this.profile,
    settings: settings ?? this.settings,
    streak: streak ?? this.streak,
    lessonProgress: lessonProgress ?? this.lessonProgress,
    mastery: mastery ?? this.mastery,
    reviewItems: reviewItems ?? this.reviewItems,
    unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
    account: account ?? this.account,
    xpToday: xpToday ?? this.xpToday,
    stats: stats ?? this.stats,
    now: now ?? this.now,
    disciplinedTrades: disciplinedTrades ?? this.disciplinedTrades,
    noTradeDecisions: noTradeDecisions ?? this.noTradeDecisions,
    journalNotes: journalNotes ?? this.journalNotes,
    dailyChallengesCompleted:
        dailyChallengesCompleted ?? this.dailyChallengesCompleted,
  );
}
