import 'package:meta/meta.dart';

/// What an achievement counts.
enum AchievementMetric {
  lessonsCompleted,
  perfectLessons,
  questionsAnswered,
  correctAnswers,
  simulationsCompleted,
  currentStreak,
  bossesPassed,
  reviewSessions,
  disciplinedTrades,
  structureAccuracy,
  noTradeDecisions,
  journalNotes,
  worldsCompleted,
  dailyChallenges,
}

/// A reusable achievement definition.
@immutable
class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.metric,
    required this.target,
    this.hidden = false,
  });

  final String id;
  final String title;
  final String description;
  final AchievementMetric metric;
  final int target;
  final bool hidden;

  double progressFraction(int value) {
    if (target <= 0) return 1;
    return (value / target).clamp(0.0, 1.0);
  }
}

/// The achievement catalogue.
class Achievements {
  const Achievements._();

  static const List<Achievement> all = [
    Achievement(
      id: 'first_lesson',
      title: 'First Lesson',
      description: 'Complete your first lesson.',
      metric: AchievementMetric.lessonsCompleted,
      target: 1,
    ),
    Achievement(
      id: 'ten_lessons',
      title: 'Getting Started',
      description: 'Complete 10 lessons.',
      metric: AchievementMetric.lessonsCompleted,
      target: 10,
    ),
    Achievement(
      id: 'fifty_lessons',
      title: 'Steady Student',
      description: 'Complete 50 lessons.',
      metric: AchievementMetric.lessonsCompleted,
      target: 50,
    ),
    Achievement(
      id: 'hundred_lessons',
      title: 'Course Veteran',
      description: 'Complete 100 lessons.',
      metric: AchievementMetric.lessonsCompleted,
      target: 100,
    ),
    Achievement(
      id: 'ten_perfect',
      title: '10 Perfect Lessons',
      description: 'Finish 10 lessons without a single wrong answer.',
      metric: AchievementMetric.perfectLessons,
      target: 10,
    ),
    Achievement(
      id: 'first_simulation',
      title: 'First Simulation',
      description: 'Complete your first simulation.',
      metric: AchievementMetric.simulationsCompleted,
      target: 1,
    ),
    Achievement(
      id: 'hundred_simulations',
      title: '100 Simulations',
      description: 'Complete 100 simulations.',
      metric: AchievementMetric.simulationsCompleted,
      target: 100,
    ),
    Achievement(
      id: 'five_hundred_simulations',
      title: '500 Simulations',
      description: 'Complete 500 simulations.',
      metric: AchievementMetric.simulationsCompleted,
      target: 500,
    ),
    Achievement(
      id: 'streak_7',
      title: '7 Day Streak',
      description: 'Study on seven consecutive days.',
      metric: AchievementMetric.currentStreak,
      target: 7,
    ),
    Achievement(
      id: 'streak_30',
      title: '30 Day Streak',
      description: 'Study on thirty consecutive days.',
      metric: AchievementMetric.currentStreak,
      target: 30,
    ),
    Achievement(
      id: 'streak_100',
      title: '100 Day Streak',
      description: 'Study on one hundred consecutive days.',
      metric: AchievementMetric.currentStreak,
      target: 100,
    ),
    Achievement(
      id: 'questions_100',
      title: '100 Questions',
      description: 'Answer 100 exercises.',
      metric: AchievementMetric.questionsAnswered,
      target: 100,
    ),
    Achievement(
      id: 'questions_1000',
      title: '1,000 Questions',
      description: 'Answer 1,000 exercises.',
      metric: AchievementMetric.questionsAnswered,
      target: 1000,
    ),
    Achievement(
      id: 'risk_guardian',
      title: 'Risk Guardian',
      description:
          'Complete 25 simulations keeping risk inside the conservative band.',
      metric: AchievementMetric.disciplinedTrades,
      target: 25,
    ),
    Achievement(
      id: 'structure_specialist',
      title: 'Structure Specialist',
      description: 'Reach 80 mastery in Market Structure.',
      metric: AchievementMetric.structureAccuracy,
      target: 80,
    ),
    Achievement(
      id: 'review_master',
      title: 'Review Master',
      description: 'Complete 30 review sessions.',
      metric: AchievementMetric.reviewSessions,
      target: 30,
    ),
    Achievement(
      id: 'patience',
      title: 'The Patient Trader',
      description: 'Record 25 deliberate no-trade decisions.',
      metric: AchievementMetric.noTradeDecisions,
      target: 25,
    ),
    Achievement(
      id: 'boss_slayer',
      title: 'Challenge Taker',
      description: 'Pass 6 boss challenges.',
      metric: AchievementMetric.bossesPassed,
      target: 6,
    ),
    Achievement(
      id: 'all_worlds',
      title: 'Full Course',
      description: 'Complete all 12 worlds.',
      metric: AchievementMetric.worldsCompleted,
      target: 12,
    ),
    Achievement(
      id: 'journalist',
      title: 'Journal Keeper',
      description: 'Add notes to 20 journal entries.',
      metric: AchievementMetric.journalNotes,
      target: 20,
    ),
    Achievement(
      id: 'daily_10',
      title: 'Daily Habit',
      description: 'Complete 10 daily challenges.',
      metric: AchievementMetric.dailyChallenges,
      target: 10,
    ),
  ];

  static Achievement? byId(String id) {
    for (final a in all) {
      if (a.id == id) return a;
    }
    return null;
  }
}

/// A snapshot of the counters achievements are measured against.
@immutable
class AchievementStats {
  const AchievementStats({
    this.lessonsCompleted = 0,
    this.perfectLessons = 0,
    this.questionsAnswered = 0,
    this.correctAnswers = 0,
    this.simulationsCompleted = 0,
    this.currentStreak = 0,
    this.bossesPassed = 0,
    this.reviewSessions = 0,
    this.disciplinedTrades = 0,
    this.structureMastery = 0,
    this.noTradeDecisions = 0,
    this.journalNotes = 0,
    this.worldsCompleted = 0,
    this.dailyChallenges = 0,
  });

  final int lessonsCompleted;
  final int perfectLessons;
  final int questionsAnswered;
  final int correctAnswers;
  final int simulationsCompleted;
  final int currentStreak;
  final int bossesPassed;
  final int reviewSessions;
  final int disciplinedTrades;
  final int structureMastery;
  final int noTradeDecisions;
  final int journalNotes;
  final int worldsCompleted;
  final int dailyChallenges;

  int valueFor(AchievementMetric metric) => switch (metric) {
    AchievementMetric.lessonsCompleted => lessonsCompleted,
    AchievementMetric.perfectLessons => perfectLessons,
    AchievementMetric.questionsAnswered => questionsAnswered,
    AchievementMetric.correctAnswers => correctAnswers,
    AchievementMetric.simulationsCompleted => simulationsCompleted,
    AchievementMetric.currentStreak => currentStreak,
    AchievementMetric.bossesPassed => bossesPassed,
    AchievementMetric.reviewSessions => reviewSessions,
    AchievementMetric.disciplinedTrades => disciplinedTrades,
    AchievementMetric.structureAccuracy => structureMastery,
    AchievementMetric.noTradeDecisions => noTradeDecisions,
    AchievementMetric.journalNotes => journalNotes,
    AchievementMetric.worldsCompleted => worldsCompleted,
    AchievementMetric.dailyChallenges => dailyChallenges,
  };
}

/// Evaluates which achievements are now unlocked.
class AchievementEngine {
  const AchievementEngine._();

  /// Returns the ids that are satisfied by [stats] but not already in
  /// [unlocked].
  static List<Achievement> newlyUnlocked({
    required AchievementStats stats,
    required Set<String> unlocked,
  }) {
    final out = <Achievement>[];
    for (final a in Achievements.all) {
      if (unlocked.contains(a.id)) continue;
      if (stats.valueFor(a.metric) >= a.target) out.add(a);
    }
    return out;
  }

  static double progress(Achievement a, AchievementStats stats) =>
      a.progressFraction(stats.valueFor(a.metric));
}
