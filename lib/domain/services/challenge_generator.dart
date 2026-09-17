import '../../core/app_date.dart';
import '../../core/seeded_random.dart';
import '../models/challenge.dart';
import '../models/lesson.dart';
import '../models/skill.dart';
import '../services/xp_rules.dart';
import '../../data/scenarios/scenario_generator.dart';

/// Builds the daily and weekly challenges.
///
/// Both are generated from a date-derived seed, so every device produces the
/// same challenge for the same day without any server involvement — and a test
/// can assert exactly what tomorrow's challenge will be.
class ChallengeGenerator {
  const ChallengeGenerator._();

  static const int dailyTaskCount = 5;

  static DailyChallenge daily({
    required DateTime date,
    required Curriculum curriculum,
  }) {
    final dayKey = AppDate.dayKey(date);
    final seed = AppDate.daySeed(date, 'daily-challenge');
    final rnd = SeededRandom(seed);

    final lessons = curriculum.allLessons
        .where((l) => !l.isBoss)
        .toList(growable: false);

    final tasks = <ChallengeTask>[];

    // Two exercises drawn from anywhere in the curriculum.
    for (var i = 0; i < 2 && lessons.isNotEmpty; i++) {
      final lesson = lessons[rnd.nextInt(lessons.length)];
      final graded = lesson.gradedActivities;
      if (graded.isEmpty) continue;
      final activity = graded[rnd.nextInt(graded.length)];
      tasks.add(
        ChallengeTask(
          kind: ChallengeTaskKind.lessonActivity,
          reference: '${lesson.id}:${activity.id}',
          label: '${activity.kind.label} · ${lesson.title}',
        ),
      );
    }

    // One structure question and one risk question, for coverage.
    final structureLessons = curriculum
        .lessonsForSkill(Skills.marketStructure)
        .where((l) => !l.isBoss)
        .toList(growable: false);
    if (structureLessons.isNotEmpty) {
      final lesson = structureLessons[rnd.nextInt(structureLessons.length)];
      final graded = lesson.gradedActivities;
      if (graded.isNotEmpty) {
        final activity = graded[rnd.nextInt(graded.length)];
        tasks.add(
          ChallengeTask(
            kind: ChallengeTaskKind.structureQuestion,
            reference: '${lesson.id}:${activity.id}',
            label: 'Structure · ${lesson.title}',
          ),
        );
      }
    }

    final riskLessons = curriculum
        .lessonsForSkill(Skills.riskManagement)
        .where((l) => !l.isBoss)
        .toList(growable: false);
    if (riskLessons.isNotEmpty) {
      final lesson = riskLessons[rnd.nextInt(riskLessons.length)];
      final graded = lesson.gradedActivities;
      if (graded.isNotEmpty) {
        final activity = graded[rnd.nextInt(graded.length)];
        tasks.add(
          ChallengeTask(
            kind: ChallengeTaskKind.riskQuestion,
            reference: '${lesson.id}:${activity.id}',
            label: 'Risk · ${lesson.title}',
          ),
        );
      }
    }

    // One simulation, chosen deterministically from the scenario space.
    final scenarioIndex = ScenarioGenerator.indexForSeed(seed * 31 + 7);
    tasks.add(
      ChallengeTask(
        kind: ChallengeTaskKind.simulation,
        reference: '$scenarioIndex',
        label: 'Simulation · unseen chart',
      ),
    );

    // Top up if any lookup came back empty, so the challenge is always full.
    while (tasks.length < dailyTaskCount && lessons.isNotEmpty) {
      final lesson = lessons[rnd.nextInt(lessons.length)];
      final graded = lesson.gradedActivities;
      if (graded.isEmpty) continue;
      final activity = graded[rnd.nextInt(graded.length)];
      final reference = '${lesson.id}:${activity.id}';
      if (tasks.any((t) => t.reference == reference)) continue;
      tasks.add(
        ChallengeTask(
          kind: ChallengeTaskKind.lessonActivity,
          reference: reference,
          label: '${activity.kind.label} · ${lesson.title}',
        ),
      );
    }

    return DailyChallenge(
      dayKey: dayKey,
      seed: seed,
      tasks: List.unmodifiable(tasks.take(dailyTaskCount).toList()),
      xpReward: XpRules.dailyChallengeComplete,
    );
  }

  static const List<({WeeklyGoalMetric metric, int target, String title})>
  _weeklyTemplates = [
    (
      metric: WeeklyGoalMetric.structureQuestions,
      target: 20,
      title: 'Structure Week',
    ),
    (
      metric: WeeklyGoalMetric.simulations,
      target: 10,
      title: 'Ten Simulations',
    ),
    (
      metric: WeeklyGoalMetric.disciplinedSimulations,
      target: 5,
      title: 'Risk Discipline',
    ),
    (metric: WeeklyGoalMetric.lessons, target: 8, title: 'Eight Lessons'),
    (metric: WeeklyGoalMetric.reviewItems, target: 25, title: 'Review Sprint'),
    (
      metric: WeeklyGoalMetric.noTradeDecisions,
      target: 6,
      title: 'The Patience Goal',
    ),
  ];

  static WeeklyChallenge weekly(DateTime date) {
    final weekKey = AppDate.weekKey(date);
    final rnd = SeededRandom.fromString(weekKey, 991);
    final template = _weeklyTemplates[rnd.nextInt(_weeklyTemplates.length)];
    return WeeklyChallenge(
      weekKey: weekKey,
      metric: template.metric,
      target: template.target,
      xpReward: XpRules.weeklyChallengeComplete,
      title: template.title,
    );
  }
}
