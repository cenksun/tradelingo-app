import 'dart:math' as math;

import '../models/enums.dart';
import '../models/review_item.dart';

/// Local spaced repetition scheduler.
///
/// The approach is the familiar one — correct answers push the next review
/// further out, wrong answers pull it back to the start — with two adjustments
/// that suit chart exercises rather than flashcards:
///
///  * intervals are capped well below a year, because market-reading skills
///    lose their edge faster than vocabulary does;
///  * a wrong answer on a previously-solid item lowers its ease sharply, so a
///    concept a learner *thought* they had is re-drilled aggressively.
///
/// Nothing here clones a specific proprietary implementation.
class SpacedRepetition {
  const SpacedRepetition._();

  static const double minEase = 1.4;
  static const double maxEase = 2.9;
  static const int maxIntervalDays = 120;

  /// The first few intervals, in days, before ease-based growth takes over.
  static const List<int> _ladder = [1, 3, 7];

  /// Creates an item for a concept seen for the first time.
  static ReviewItem create({
    required String conceptTag,
    required String skillId,
    required DateTime now,
    required bool correct,
    Difficulty difficulty = Difficulty.beginner,
  }) {
    final seed = ReviewItem(
      conceptTag: conceptTag,
      skillId: skillId,
      dueAt: now,
      lastDifficulty: difficulty,
    );
    return review(
      item: seed,
      correct: correct,
      now: now,
      difficulty: difficulty,
    );
  }

  /// Applies one answer and schedules the next review.
  static ReviewItem review({
    required ReviewItem item,
    required bool correct,
    required DateTime now,
    Difficulty difficulty = Difficulty.beginner,
    double partialCredit = 0,
  }) {
    var ease = item.ease;
    int interval;
    int repetitions;
    var lapses = item.lapses;

    if (correct) {
      repetitions = item.repetitions + 1;
      // Harder questions answered correctly earn a slightly larger ease bump.
      ease = math.min(maxEase, ease + 0.05 + difficulty.weight * 0.015);
      if (repetitions <= _ladder.length) {
        interval = _ladder[repetitions - 1];
      } else {
        interval = math.max(1, (item.intervalDays * ease).round());
      }
      interval = math.min(maxIntervalDays, interval);
    } else {
      repetitions = 0;
      if (item.repetitions > 0) {
        lapses += 1;
        // A concept that was solid and then failed drops sharply: it is the
        // most valuable thing to re-drill.
        ease = math.max(minEase, ease - 0.28);
      } else {
        ease = math.max(minEase, ease - 0.16);
      }
      // Partly-correct answers come back the next day rather than immediately.
      interval = partialCredit >= 0.5 ? 1 : 0;
    }

    return item.copyWith(
      dueAt: _addDays(now, interval),
      intervalDays: interval,
      ease: ease,
      repetitions: repetitions,
      lapses: lapses,
      lastReviewed: now,
      lastDifficulty: difficulty,
      totalAttempts: item.totalAttempts + 1,
      totalCorrect: item.totalCorrect + (correct ? 1 : 0),
    );
  }

  /// Ranks items for a review session.
  ///
  /// Priority favours items that are overdue, have lapsed before, have a low
  /// ease, and have poor accuracy. The ordering is fully deterministic, which
  /// keeps it testable.
  static List<ReviewItem> selectForSession({
    required List<ReviewItem> items,
    required DateTime now,
    int limit = 10,
  }) {
    final scored = <(double, ReviewItem)>[];
    for (final item in items) {
      scored.add((priority(item, now), item));
    }
    scored.sort((a, b) {
      final cmp = b.$1.compareTo(a.$1);
      if (cmp != 0) return cmp;
      return a.$2.conceptTag.compareTo(b.$2.conceptTag);
    });
    return [for (final entry in scored.take(limit)) entry.$2];
  }

  /// Higher means more worth reviewing now.
  static double priority(ReviewItem item, DateTime now) {
    final overdue = item.daysOverdue(now);
    // Not yet due items are still eligible when the queue is thin, but rank
    // far below due ones.
    final dueScore = overdue >= 0
        ? 40.0 + math.min(overdue, 30) * 2.0
        : overdue * 1.5;
    final lapseScore = item.lapses * 9.0;
    final easeScore = (maxEase - item.ease) * 14.0;
    final accuracyScore = item.totalAttempts == 0
        ? 8.0
        : (1 - item.accuracy) * 22.0;
    final difficultyScore = item.lastDifficulty.weight * 1.5;
    return dueScore + lapseScore + easeScore + accuracyScore + difficultyScore;
  }

  static DateTime _addDays(DateTime from, int days) {
    if (days <= 0) {
      // Same-session retry: due again in ten minutes so it can reappear later
      // in the same practice run without blocking it.
      return from.add(const Duration(minutes: 10));
    }
    return DateTime(from.year, from.month, from.day + days, 9);
  }
}
