import 'package:meta/meta.dart';

/// What a challenge step asks the learner to do.
enum ChallengeTaskKind {
  lessonActivity('Exercise'),
  simulation('Simulation'),
  review('Review'),
  structureQuestion('Structure question'),
  riskQuestion('Risk question');

  const ChallengeTaskKind(this.label);
  final String label;
}

/// One step of a daily challenge.
@immutable
class ChallengeTask {
  const ChallengeTask({
    required this.kind,
    required this.reference,
    required this.label,
  });

  final ChallengeTaskKind kind;

  /// Activity id, scenario index or concept tag, depending on [kind].
  final String reference;
  final String label;
}

/// A generated daily challenge.
@immutable
class DailyChallenge {
  const DailyChallenge({
    required this.dayKey,
    required this.seed,
    required this.tasks,
    required this.xpReward,
    this.completedTaskCount = 0,
    this.completed = false,
  });

  final String dayKey;
  final int seed;
  final List<ChallengeTask> tasks;
  final int xpReward;
  final int completedTaskCount;
  final bool completed;

  double get progress =>
      tasks.isEmpty ? 0 : (completedTaskCount / tasks.length).clamp(0.0, 1.0);

  DailyChallenge copyWith({int? completedTaskCount, bool? completed}) =>
      DailyChallenge(
        dayKey: dayKey,
        seed: seed,
        tasks: tasks,
        xpReward: xpReward,
        completedTaskCount: completedTaskCount ?? this.completedTaskCount,
        completed: completed ?? this.completed,
      );
}

/// What a weekly goal counts.
enum WeeklyGoalMetric {
  structureQuestions('structure questions answered correctly'),
  simulations('simulations completed'),
  disciplinedSimulations('simulations kept inside the conservative risk band'),
  lessons('lessons completed'),
  reviewItems('review items cleared'),
  noTradeDecisions('deliberate no-trade decisions');

  const WeeklyGoalMetric(this.description);
  final String description;
}

/// A weekly educational goal. No money targets, by design.
@immutable
class WeeklyChallenge {
  const WeeklyChallenge({
    required this.weekKey,
    required this.metric,
    required this.target,
    required this.xpReward,
    required this.title,
    this.progress = 0,
    this.completed = false,
  });

  final String weekKey;
  final WeeklyGoalMetric metric;
  final int target;
  final int xpReward;
  final String title;
  final int progress;
  final bool completed;

  double get fraction => target <= 0 ? 0 : (progress / target).clamp(0.0, 1.0);

  WeeklyChallenge copyWith({int? progress, bool? completed}) => WeeklyChallenge(
    weekKey: weekKey,
    metric: metric,
    target: target,
    xpReward: xpReward,
    title: title,
    progress: progress ?? this.progress,
    completed: completed ?? this.completed,
  );
}
