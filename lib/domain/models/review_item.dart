import 'package:meta/meta.dart';

import 'enums.dart';

/// One tracked idea in the spaced repetition queue.
///
/// An item is keyed by *concept*, not by question, so a learner who keeps
/// missing "lower high" gets more lower-high exercises drawn from any chart,
/// rather than the same question repeated.
@immutable
class ReviewItem {
  const ReviewItem({
    required this.conceptTag,
    required this.skillId,
    required this.dueAt,
    this.intervalDays = 0,
    this.ease = 2.3,
    this.repetitions = 0,
    this.lapses = 0,
    this.lastReviewed,
    this.lastDifficulty = Difficulty.beginner,
    this.totalAttempts = 0,
    this.totalCorrect = 0,
  });

  final String conceptTag;
  final String skillId;
  final DateTime dueAt;

  /// Days until the next review after the last one.
  final int intervalDays;

  /// How quickly intervals grow for this item. Lower means seen more often.
  final double ease;

  /// Consecutive correct answers.
  final int repetitions;

  /// Times this item was answered wrong after previously being correct.
  final int lapses;
  final DateTime? lastReviewed;
  final Difficulty lastDifficulty;
  final int totalAttempts;
  final int totalCorrect;

  double get accuracy => totalAttempts == 0 ? 0 : totalCorrect / totalAttempts;

  bool isDue(DateTime now) => !dueAt.isAfter(now);

  /// How overdue the item is, in days. Negative means not yet due.
  int daysOverdue(DateTime now) => now.difference(dueAt).inDays;

  ReviewItem copyWith({
    DateTime? dueAt,
    int? intervalDays,
    double? ease,
    int? repetitions,
    int? lapses,
    DateTime? lastReviewed,
    Difficulty? lastDifficulty,
    int? totalAttempts,
    int? totalCorrect,
  }) => ReviewItem(
    conceptTag: conceptTag,
    skillId: skillId,
    dueAt: dueAt ?? this.dueAt,
    intervalDays: intervalDays ?? this.intervalDays,
    ease: ease ?? this.ease,
    repetitions: repetitions ?? this.repetitions,
    lapses: lapses ?? this.lapses,
    lastReviewed: lastReviewed ?? this.lastReviewed,
    lastDifficulty: lastDifficulty ?? this.lastDifficulty,
    totalAttempts: totalAttempts ?? this.totalAttempts,
    totalCorrect: totalCorrect ?? this.totalCorrect,
  );
}
