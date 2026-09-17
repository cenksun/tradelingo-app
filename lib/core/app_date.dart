/// Calendar helpers used by streaks, the daily challenge and analytics.
///
/// Everything in TradePath works on *local calendar days*: a streak is kept by
/// studying on consecutive local days, not by 24 hour windows.
class AppDate {
  const AppDate._();

  /// Strips the time component from [value].
  static DateTime dayOf(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  /// `yyyy-MM-dd` key used for storage and for seeding daily content.
  static String dayKey(DateTime value) {
    final d = dayOf(value);
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  /// Parses a [dayKey]. Returns `null` when the key is malformed so callers can
  /// fall back to a safe default instead of throwing.
  static DateTime? tryParseDayKey(String? key) {
    if (key == null || key.length != 10) return null;
    final parts = key.split('-');
    if (parts.length != 3) return null;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return null;
    if (m < 1 || m > 12 || d < 1 || d > 31) return null;
    return DateTime(y, m, d);
  }

  /// Whole calendar days between two instants (`b - a`).
  static int daysBetween(DateTime a, DateTime b) =>
      dayOf(b).difference(dayOf(a)).inDays;

  static bool isSameDay(DateTime a, DateTime b) => daysBetween(a, b) == 0;

  /// Monday of the ISO week containing [value].
  static DateTime startOfWeek(DateTime value) {
    final d = dayOf(value);
    return d.subtract(Duration(days: d.weekday - DateTime.monday));
  }

  /// `yyyy-Www` key identifying the ISO-ish week used by weekly challenges.
  static String weekKey(DateTime value) {
    final monday = startOfWeek(value);
    final firstMonday = startOfWeek(DateTime(monday.year, 1, 4));
    final week = (daysBetween(firstMonday, monday) ~/ 7) + 1;
    return '${monday.year}-W${week.toString().padLeft(2, '0')}';
  }

  /// Stable integer seed derived from a calendar day, used to generate the
  /// daily challenge identically on every device.
  static int daySeed(DateTime value, [String namespace = '']) {
    final d = dayOf(value);
    var seed = d.year * 10000 + d.month * 100 + d.day;
    for (var i = 0; i < namespace.length; i++) {
      seed = seed * 31 + namespace.codeUnitAt(i);
    }
    return seed & 0x7FFFFFFF;
  }
}
