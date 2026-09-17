import 'dart:math' as math;

import '../models/enums.dart';
import '../models/skill.dart';

/// Updates skill mastery from answer outcomes.
///
/// Mastery is deliberately *not* a copy of XP. XP only ever increases and
/// measures activity; mastery moves in both directions and measures current
/// competence. It is driven by four things: whether the answer was right, how
/// hard the question was, how much evidence already exists, and how long it
/// has been since the skill was last practised.
class MasteryEngine {
  const MasteryEngine._();

  /// Mastery decays towards this floor when a skill is left alone.
  static const double decayFloor = 25;

  /// Points of mastery lost per week of not practising, once past the grace
  /// period.
  static const double decayPerWeek = 3.5;
  static const int decayGraceDays = 10;

  /// Applies one answer to a skill's mastery.
  static SkillMastery applyAnswer({
    required SkillMastery current,
    required bool correct,
    required Difficulty difficulty,
    required DateTime now,
    double partialCredit = 0,
  }) {
    final decayed = applyDecay(current, now);

    // Harder questions move mastery further in both directions.
    final weight = 0.75 + difficulty.weight * 0.35;

    // Early answers move mastery quickly; later ones refine it. This keeps a
    // single lucky answer from producing a "strong" rating.
    final evidence = decayed.attempts;
    final responsiveness = 14.0 / (1.0 + evidence * 0.22);

    final score = decayed.score;
    double delta;
    if (correct) {
      // Gains shrink as mastery approaches 100, so the top of the scale has to
      // be earned across many questions.
      final headroom = (100 - score) / 100;
      delta = responsiveness * weight * (0.35 + headroom * 0.85);
    } else {
      // Losses grow with how confident the rating was, so a high rating is
      // genuinely at risk from a wrong answer.
      final confidence = score / 100;
      delta = -responsiveness * weight * (0.45 + confidence * 0.95);
      // Partly-correct answers (labelling, matching) soften the loss.
      delta *= (1 - partialCredit.clamp(0.0, 1.0) * 0.7);
    }

    final next = (score + delta).clamp(0.0, 100.0);
    return decayed.copyWith(
      score: next,
      attempts: decayed.attempts + 1,
      correct: decayed.correct + (correct ? 1 : 0),
      lastPracticed: now,
    );
  }

  /// Reduces mastery for skills that have not been practised recently.
  ///
  /// Applied lazily whenever a skill is read or written, so there is no
  /// background job and the result is identical regardless of when the app was
  /// last opened.
  static SkillMastery applyDecay(SkillMastery current, DateTime now) {
    final last = current.lastPracticed;
    if (last == null || current.attempts == 0) return current;
    final days = now.difference(last).inDays;
    if (days <= decayGraceDays) return current;
    if (current.score <= decayFloor) return current;

    final weeks = (days - decayGraceDays) / 7.0;
    final decayed = current.score - weeks * decayPerWeek;
    return current.copyWith(score: math.max(decayFloor, decayed));
  }

  /// A short, non-numeric description of where a skill stands.
  static String describe(SkillMastery mastery) {
    if (mastery.attempts < 5) {
      return 'Not enough answers yet to judge this.';
    }
    return switch (mastery.band) {
      MasteryBand.strong =>
        'Consistently right, including on harder questions.',
      MasteryBand.solid =>
        'Reliable, with occasional slips on harder questions.',
      MasteryBand.developing =>
        'Coming along — worth a few more review sessions.',
      MasteryBand.weak =>
        'Missing more often than not. Practice will target this.',
      MasteryBand.untested => 'Not enough answers yet to judge this.',
    };
  }
}
