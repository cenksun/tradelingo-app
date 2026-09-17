import 'package:meta/meta.dart';

import '../../core/app_date.dart';

/// Daily learning streak state.
@immutable
class StreakState {
  const StreakState({
    this.current = 0,
    this.longest = 0,
    this.lastActiveDay,
    this.totalActiveDays = 0,
  });

  final int current;
  final int longest;

  /// Date-only value of the last day with a qualifying activity.
  final DateTime? lastActiveDay;
  final int totalActiveDays;

  StreakState copyWith({
    int? current,
    int? longest,
    DateTime? lastActiveDay,
    int? totalActiveDays,
  }) => StreakState(
    current: current ?? this.current,
    longest: longest ?? this.longest,
    lastActiveDay: lastActiveDay ?? this.lastActiveDay,
    totalActiveDays: totalActiveDays ?? this.totalActiveDays,
  );
}

/// Maintains the daily streak.
///
/// A streak is only extended by *meaningful learning activity* — finishing a
/// lesson, a practice or review session, a simulation or a challenge. Opening
/// the app does nothing, which is deliberate: the streak should measure study,
/// not attendance.
class StreakService {
  const StreakService._();

  /// Records a qualifying activity on [now].
  static StreakState recordActivity(StreakState state, DateTime now) {
    final today = AppDate.dayOf(now);
    final last = state.lastActiveDay;

    if (last == null) {
      return StreakState(
        current: 1,
        longest: state.longest < 1 ? 1 : state.longest,
        lastActiveDay: today,
        totalActiveDays: state.totalActiveDays + 1,
      );
    }

    final gap = AppDate.daysBetween(last, today);
    if (gap <= 0) {
      // Already counted today; nothing changes.
      return state;
    }
    final next = gap == 1 ? state.current + 1 : 1;
    return StreakState(
      current: next,
      longest: next > state.longest ? next : state.longest,
      lastActiveDay: today,
      totalActiveDays: state.totalActiveDays + 1,
    );
  }

  /// The streak as it should be *displayed* on [now], without recording
  /// anything. A streak survives until the end of the following day.
  static int displayedStreak(StreakState state, DateTime now) {
    final last = state.lastActiveDay;
    if (last == null) return 0;
    final gap = AppDate.daysBetween(last, now);
    if (gap <= 0) return state.current;
    if (gap == 1) return state.current;
    return 0;
  }

  /// Whether today still needs activity to keep the streak alive.
  static bool needsActivityToday(StreakState state, DateTime now) {
    final last = state.lastActiveDay;
    if (last == null) return true;
    return AppDate.daysBetween(last, now) != 0;
  }

  /// Whether the streak will be lost if nothing happens today.
  static bool atRisk(StreakState state, DateTime now) {
    final last = state.lastActiveDay;
    if (last == null || state.current == 0) return false;
    return AppDate.daysBetween(last, now) == 1;
  }

  /// Streak lengths that award bonus XP.
  static const List<int> milestones = [3, 7, 14, 30, 60, 100, 180, 365];

  static bool isMilestone(int streak) => milestones.contains(streak);

  static int? nextMilestone(int streak) {
    for (final m in milestones) {
      if (m > streak) return m;
    }
    return null;
  }
}
