import '../models/enums.dart';
import '../models/lesson.dart';

/// Every XP value in the app comes from here.
///
/// Centralising them keeps progression tunable and prevents magic numbers from
/// spreading through the UI. The daily cap and the per-lesson repeat decay are
/// what stop XP being farmed by replaying the same easy lesson.
class XpRules {
  const XpRules._();

  static const int correctAnswer = 4;
  static const int correctAnswerHard = 6;
  static const int lessonComplete = 20;
  static const int perfectLessonBonus = 15;
  static const int bossComplete = 60;
  static const int bossPerfectBonus = 25;
  static const int simulationComplete = 25;
  static const int simulationHighProcessBonus = 20;
  static const int reviewItemCleared = 3;
  static const int reviewSessionComplete = 15;
  static const int dailyChallengeComplete = 50;
  static const int weeklyChallengeComplete = 120;
  static const int practiceSessionComplete = 12;
  static const int streakMilestone = 30;
  static const int heartsPracticeComplete = 8;

  /// Ceiling on XP earned in one calendar day, to keep progression meaningful.
  static const int dailyCap = 1200;

  /// A high process score is what earns the simulation bonus.
  static const double processBonusThreshold = 75;

  static int forCorrectAnswer(Difficulty difficulty) =>
      difficulty.weight >= Difficulty.advanced.weight
      ? correctAnswerHard
      : correctAnswer;

  /// XP for finishing a lesson, before the repeat multiplier.
  static int forLessonCompletion({
    required Lesson lesson,
    required int correctCount,
    required int gradedCount,
    required bool perfect,
  }) {
    final base = lesson.isBoss ? bossComplete : lessonComplete;
    final answers = correctCount * forCorrectAnswer(lesson.difficulty);
    final bonus = perfect
        ? (lesson.isBoss ? bossPerfectBonus : perfectLessonBonus)
        : 0;
    return base + answers + bonus;
  }

  /// Repeating a lesson still earns XP, but progressively less, so grinding
  /// lesson 1 is never an efficient route.
  ///
  /// First completion is full value; each later attempt is worth a quarter of
  /// the previous one, with a floor so a replay is never worth nothing.
  static int applyRepeatDecay(int baseXp, int previousCompletions) {
    if (previousCompletions <= 0) return baseXp;
    var value = baseXp.toDouble();
    for (var i = 0; i < previousCompletions && i < 4; i++) {
      value *= 0.25;
    }
    final floor = baseXp >= 8 ? 2 : 1;
    final result = value.round();
    return result < floor ? floor : result;
  }

  /// XP for a finished simulation, scaled by process quality rather than by
  /// simulated profit.
  static int forSimulation({required double processScore}) {
    final base = simulationComplete;
    if (processScore >= processBonusThreshold) {
      return base + simulationHighProcessBonus;
    }
    // Below the threshold the reward tapers rather than dropping to nothing:
    // a poor trade that was completed and reviewed still taught something.
    final ratio = (processScore / processBonusThreshold).clamp(0.0, 1.0);
    return base + (simulationHighProcessBonus * ratio * 0.5).round();
  }

  static int forReviewSession(int itemsCleared) =>
      reviewSessionComplete + itemsCleared * reviewItemCleared;

  /// Applies the daily ceiling to a proposed award.
  static int capForToday({required int proposed, required int earnedToday}) {
    if (earnedToday >= dailyCap) return 0;
    final remaining = dailyCap - earnedToday;
    return proposed <= remaining ? proposed : remaining;
  }
}

/// Where a single XP award came from. Stored with each event so the profile
/// can show a breakdown and so farming is auditable.
enum XpSource {
  lesson('Lesson'),
  boss('Boss challenge'),
  simulation('Simulation'),
  review('Review'),
  practice('Practice'),
  dailyChallenge('Daily challenge'),
  weeklyChallenge('Weekly challenge'),
  streak('Streak milestone'),
  hearts('Practice for hearts');

  const XpSource(this.label);
  final String label;

  static XpSource fromName(String? name) => XpSource.values.firstWhere(
    (s) => s.name == name,
    orElse: () => XpSource.lesson,
  );
}
