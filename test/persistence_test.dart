import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradepath/app/providers.dart';
import 'package:tradepath/data/db/app_database.dart';
import 'package:tradepath/domain/models/enums.dart';
import 'package:tradepath/domain/models/journal_entry.dart';
import 'package:tradepath/domain/models/lesson.dart';
import 'package:tradepath/domain/models/skill.dart';
import 'package:tradepath/domain/models/user_profile.dart';
import 'package:tradepath/domain/services/streak_service.dart';
import 'package:tradepath/domain/services/xp_rules.dart';
import 'package:tradepath/features/learn/learner_controller.dart';
import 'package:tradepath/features/learn/learner_state.dart';

class _Clock {
  _Clock(this.now);
  DateTime now;
  DateTime call() => now;
}

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late _Clock clock;

  Future<LearnerState> read() async =>
      container.read(learnerControllerProvider.future);

  LearnerController controller() =>
      container.read(learnerControllerProvider.notifier);

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    clock = _Clock(DateTime(2026, 3, 2, 10));
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(clock.call),
      ],
    );
    await read();
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Lesson firstLesson() =>
      container.read(curriculumProvider).worlds.first.lessons.first;

  test(
    'a fresh install starts unonboarded with full hearts and no progress',
    () async {
      final state = await read();
      expect(state.profile.onboardingComplete, isFalse);
      expect(state.profile.hearts, UserProfile.maxHearts);
      expect(state.profile.totalXp, 0);
      expect(state.level.level, 1);
      expect(state.level.title, 'Rookie');
      expect(state.displayedStreak, 0);
      expect(state.stats.lessonsCompleted, 0);
      expect(state.account.balance, 10000);
    },
  );

  test('onboarding persists the learner profile', () async {
    await controller().completeOnboarding(
      username: 'Sam',
      level: ExperienceLevel.beginner,
      dailyGoalMinutes: 10,
      avatarId: 'avatar_03',
    );
    final state = await read();
    expect(state.profile.onboardingComplete, isTrue);
    expect(state.profile.username, 'Sam');
    expect(state.profile.dailyGoalMinutes, 10);
    expect(state.settings.dailyGoalMinutes, 10);
  });

  test('only the first lesson of world 1 is unlocked at the start', () async {
    final state = await read();
    final curriculum = container.read(curriculumProvider);
    final w1 = curriculum.worlds.first;
    expect(state.isLessonUnlocked(w1.lessons[0]), isTrue);
    expect(state.isLessonUnlocked(w1.lessons[1]), isFalse);
    expect(state.isLessonUnlocked(w1.boss!), isFalse);
    expect(state.isWorldUnlocked(curriculum, curriculum.worlds[1]), isFalse);
  });

  test('answering records mastery, an attempt and a review item', () async {
    final lesson = firstLesson();
    final activity = lesson.gradedActivities.first;
    final deltas = await controller().recordAnswer(
      activity: activity,
      lessonId: lesson.id,
      correct: true,
    );
    expect(deltas[activity.skillIds.first], greaterThan(0));

    await controller().refresh();
    final state = await read();
    final mastery = state.masteryFor(activity.skillIds.first);
    expect(mastery.attempts, 1);
    expect(mastery.correct, 1);
    expect(mastery.score, greaterThan(0));
    expect(
      state.reviewItems.any((r) => r.conceptTag == activity.concept),
      isTrue,
    );
  });

  test(
    'a wrong answer lowers mastery and schedules the concept sooner',
    () async {
      final lesson = firstLesson();
      final activity = lesson.gradedActivities.first;
      await controller().recordAnswer(
        activity: activity,
        lessonId: lesson.id,
        correct: true,
      );
      await controller().refresh();
      final afterCorrect = (await read())
          .masteryFor(activity.skillIds.first)
          .score;

      await controller().recordAnswer(
        activity: activity,
        lessonId: lesson.id,
        correct: false,
      );
      await controller().refresh();
      final state = await read();
      expect(
        state.masteryFor(activity.skillIds.first).score,
        lessThan(afterCorrect),
      );
      final item = state.reviewItems.firstWhere(
        (r) => r.conceptTag == activity.concept,
      );
      expect(item.repetitions, 0);
      expect(item.totalAttempts, 2);
    },
  );

  test('losing a heart persists and hearts regenerate over time', () async {
    await controller().loseHeart();
    await controller().loseHeart();
    expect((await read()).profile.hearts, 3);

    // Reopen the app 60 minutes later: two hearts should have returned.
    clock.now = clock.now.add(const Duration(minutes: 60));
    await controller().refresh();
    expect((await read()).profile.hearts, 5);
  });

  test('hearts never fall below zero or exceed the maximum', () async {
    for (var i = 0; i < 10; i++) {
      await controller().loseHeart();
    }
    expect((await read()).profile.hearts, 0);
    await controller().gainHearts(20);
    expect((await read()).profile.hearts, UserProfile.maxHearts);
  });

  test(
    'completing a lesson awards XP, unlocks the next one and starts a streak',
    () async {
      final lesson = firstLesson();
      final outcome = await controller().completeLesson(
        lesson: lesson,
        correctCount: lesson.gradedCount,
        gradedCount: lesson.gradedCount,
        masteryChanges: const {},
        weakConcepts: const [],
      );

      expect(outcome.passed, isTrue);
      expect(outcome.perfect, isTrue);
      expect(outcome.xpAwarded, greaterThan(0));

      final state = await read();
      expect(state.profile.totalXp, outcome.xpAwarded);
      expect(state.isLessonCompleted(lesson.id), isTrue);
      expect(state.displayedStreak, 1);
      expect(state.stats.lessonsCompleted, 1);
      expect(state.stats.perfectLessons, 1);

      final curriculum = container.read(curriculumProvider);
      expect(
        state.isLessonUnlocked(curriculum.worlds.first.lessons[1]),
        isTrue,
      );
    },
  );

  test('progress survives a full restart of the app', () async {
    final lesson = firstLesson();
    await controller().completeLesson(
      lesson: lesson,
      correctCount: lesson.gradedCount - 1,
      gradedCount: lesson.gradedCount,
      masteryChanges: const {},
      weakConcepts: const [],
    );
    final xpBefore = (await read()).profile.totalXp;

    // Simulate a restart: a brand new container over the same database.
    container.dispose();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(clock.call),
      ],
    );
    final restored = await read();

    expect(restored.profile.totalXp, xpBefore);
    expect(restored.isLessonCompleted(lesson.id), isTrue);
    expect(restored.displayedStreak, 1);
    expect(restored.stats.lessonsCompleted, 1);
  });

  test('a failed boss does not count as completed', () async {
    final boss = container.read(curriculumProvider).worlds.first.boss!;
    final outcome = await controller().completeLesson(
      lesson: boss,
      correctCount: 1,
      gradedCount: 10,
      masteryChanges: const {},
      weakConcepts: const ['higherLow'],
    );
    expect(outcome.passed, isFalse);
    expect(outcome.xpAwarded, 0);
    expect((await read()).isLessonCompleted(boss.id), isFalse);
  });

  test('passing a boss unlocks the next world', () async {
    final curriculum = container.read(curriculumProvider);
    final w1 = curriculum.worlds.first;
    for (final lesson in w1.lessons) {
      await controller().completeLesson(
        lesson: lesson,
        correctCount: lesson.gradedCount,
        gradedCount: lesson.gradedCount,
        masteryChanges: const {},
        weakConcepts: const [],
      );
    }
    final state = await read();
    expect(state.isWorldComplete(w1), isTrue);
    expect(state.isWorldUnlocked(curriculum, curriculum.worlds[1]), isTrue);
    expect(state.stats.bossesPassed, 1);
    expect(state.stats.worldsCompleted, 1);
  });

  test('replaying a lesson earns progressively less XP', () async {
    final lesson = firstLesson();
    final first = await controller().completeLesson(
      lesson: lesson,
      correctCount: lesson.gradedCount,
      gradedCount: lesson.gradedCount,
      masteryChanges: const {},
      weakConcepts: const [],
    );
    final second = await controller().completeLesson(
      lesson: lesson,
      correctCount: lesson.gradedCount,
      gradedCount: lesson.gradedCount,
      masteryChanges: const {},
      weakConcepts: const [],
    );
    expect(second.xpAwarded, lessThan(first.xpAwarded));
    expect(second.xpAwarded, greaterThan(0));
  });

  test('the daily XP cap holds', () async {
    final repo = container.read(profileRepositoryProvider);
    var total = 0;
    for (var i = 0; i < 60; i++) {
      total += await repo.addXp(
        amount: 100,
        source: XpSource.lesson,
        at: clock.now,
      );
    }
    expect(total, XpRules.dailyCap);
    expect(await repo.xpEarnedOn(clock.now), XpRules.dailyCap);
  });

  test('a streak extends on consecutive days and resets after a gap', () async {
    final curriculum = container.read(curriculumProvider);
    final lessons = curriculum.worlds.first.lessons;

    await controller().completeLesson(
      lesson: lessons[0],
      correctCount: 5,
      gradedCount: 5,
      masteryChanges: const {},
      weakConcepts: const [],
    );
    expect((await read()).displayedStreak, 1);

    clock.now = clock.now.add(const Duration(days: 1));
    await controller().completeLesson(
      lesson: lessons[1],
      correctCount: 5,
      gradedCount: 5,
      masteryChanges: const {},
      weakConcepts: const [],
    );
    expect((await read()).displayedStreak, 2);

    // Skip two days: the displayed streak drops to zero.
    clock.now = clock.now.add(const Duration(days: 3));
    await controller().refresh();
    expect((await read()).displayedStreak, 0);

    await controller().completeLesson(
      lesson: lessons[2],
      correctCount: 5,
      gradedCount: 5,
      masteryChanges: const {},
      weakConcepts: const [],
    );
    final state = await read();
    expect(state.displayedStreak, 1);
    expect(state.streak.longest, 2);
  });

  test('achievements unlock and persist', () async {
    final lesson = firstLesson();
    final outcome = await controller().completeLesson(
      lesson: lesson,
      correctCount: lesson.gradedCount,
      gradedCount: lesson.gradedCount,
      masteryChanges: const {},
      weakConcepts: const [],
    );
    expect(
      outcome.unlockedAchievements.map((a) => a.id),
      contains('first_lesson'),
    );
    expect((await read()).unlockedAchievements, contains('first_lesson'));

    // Unlocking is idempotent.
    await controller().completeLesson(
      lesson: lesson,
      correctCount: lesson.gradedCount,
      gradedCount: lesson.gradedCount,
      masteryChanges: const {},
      weakConcepts: const [],
    );
    final state = await read();
    expect(
      state.unlockedAchievements.where((id) => id == 'first_lesson').length,
      1,
    );
  });

  test(
    'a simulation writes a journal entry and moves the virtual account',
    () async {
      final entry = JournalEntry(
        id: 'sim-1',
        scenarioId: 'sc-000001',
        completedAt: clock.now,
        assetSymbol: 'Educational dataset',
        timeframeName: '1h',
        direction: TradeDirection.long,
        entry: 100,
        stopLoss: 98,
        takeProfit: 106,
        riskPercent: 1,
        positionSize: 50,
        rewardToRisk: 3,
        outcome: TradeOutcome.targetHit,
        rMultiple: 3,
        profitLoss: 300,
        processScore: 88,
        difficulty: Difficulty.intermediate,
      );
      await controller().completeSimulation(entry: entry, processScore: 88);

      final state = await read();
      expect(state.account.balance, 10300);
      expect(state.account.peakBalance, 10300);
      expect(state.account.tradeCount, 1);
      expect(state.profile.totalXp, greaterThan(0));
      expect(state.displayedStreak, 1);

      final entries = await container
          .read(journalRepositoryProvider)
          .loadEntries();
      expect(entries.length, 1);
      expect(entries.first.id, 'sim-1');

      final curve = await container
          .read(journalRepositoryProvider)
          .loadEquityCurve();
      expect(curve.length, 1);
      expect(curve.first.balance, 10300);
    },
  );

  test('resetting the simulator leaves learning progress intact', () async {
    final lesson = firstLesson();
    await controller().completeLesson(
      lesson: lesson,
      correctCount: lesson.gradedCount,
      gradedCount: lesson.gradedCount,
      masteryChanges: const {},
      weakConcepts: const [],
    );
    await controller().completeSimulation(
      entry: JournalEntry(
        id: 'sim-2',
        scenarioId: 'sc-000002',
        completedAt: clock.now,
        assetSymbol: 'Educational dataset',
        timeframeName: '1h',
        direction: TradeDirection.short,
        entry: 100,
        stopLoss: 102,
        takeProfit: 94,
        riskPercent: 1,
        positionSize: 50,
        rewardToRisk: 3,
        outcome: TradeOutcome.stopHit,
        rMultiple: -1,
        profitLoss: -100,
        processScore: 80,
        difficulty: Difficulty.beginner,
      ),
      processScore: 80,
    );
    expect((await read()).account.balance, 9900);

    await controller().resetSimulator();
    final state = await read();
    expect(state.account.balance, 10000);
    expect(state.account.tradeCount, 0);
    // Learning is untouched.
    expect(state.isLessonCompleted(lesson.id), isTrue);
    expect(state.profile.totalXp, greaterThan(0));
    expect(
      (await container.read(journalRepositoryProvider).loadEntries()),
      isEmpty,
    );
  });

  test(
    'resetting learning progress leaves settings and simulator alone',
    () async {
      final lesson = firstLesson();
      await controller().completeLesson(
        lesson: lesson,
        correctCount: lesson.gradedCount,
        gradedCount: lesson.gradedCount,
        masteryChanges: const {},
        weakConcepts: const [],
      );
      await controller().updateSettings(
        (await read()).settings.copyWith(soundEnabled: false),
      );

      await controller().resetLearningProgress();
      final state = await read();
      expect(state.profile.totalXp, 0);
      expect(state.isLessonCompleted(lesson.id), isFalse);
      expect(state.displayedStreak, 0);
      expect(state.settings.soundEnabled, isFalse);
      expect(state.account.balance, 10000);
    },
  );

  test('mastery is tracked separately from XP', () async {
    final lesson = firstLesson();
    final activity = lesson.gradedActivities.first;
    // Lots of wrong answers: XP still rises with lesson completion, mastery falls.
    for (var i = 0; i < 6; i++) {
      await controller().recordAnswer(
        activity: activity,
        lessonId: lesson.id,
        correct: false,
      );
    }
    await controller().completeLesson(
      lesson: lesson,
      correctCount: 0,
      gradedCount: lesson.gradedCount,
      masteryChanges: const {},
      weakConcepts: const [],
    );
    final state = await read();
    expect(state.profile.totalXp, greaterThan(0));
    expect(state.masteryFor(activity.skillIds.first).score, lessThan(20));
    expect(
      state.masteryFor(Skills.riskManagement).score,
      0,
      reason: 'untouched skills stay at zero',
    );
  });

  test('streak service does not count merely opening the app', () async {
    final before = await read();
    await controller().refresh();
    await controller().refresh();
    final after = await read();
    expect(after.displayedStreak, before.displayedStreak);
    expect(after.streak.totalActiveDays, 0);
  });

  test('streak state transitions are correct in isolation', () {
    const start = StreakState();
    final day1 = StreakService.recordActivity(start, DateTime(2026, 1, 1));
    expect(day1.current, 1);
    final sameDay = StreakService.recordActivity(
      day1,
      DateTime(2026, 1, 1, 22),
    );
    expect(sameDay.current, 1);
    final day2 = StreakService.recordActivity(day1, DateTime(2026, 1, 2));
    expect(day2.current, 2);
    final afterGap = StreakService.recordActivity(day2, DateTime(2026, 1, 6));
    expect(afterGap.current, 1);
    expect(afterGap.longest, 2);
  });
}
