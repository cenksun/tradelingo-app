import 'package:intl/intl.dart';

/// Formatting helpers that are hardened against `NaN`, `Infinity` and `null`.
///
/// The app must never render a raw `NaN` to the user, so every numeric
/// formatter funnels through [_guard].
class Fmt {
  const Fmt._();

  static final NumberFormat _money = NumberFormat.currency(
    symbol: r'$',
    decimalDigits: 2,
  );
  static final NumberFormat _compact = NumberFormat.compact();
  static final NumberFormat _int = NumberFormat.decimalPattern();
  static final DateFormat _date = DateFormat('d MMM yyyy');
  static final DateFormat _dateTime = DateFormat('d MMM yyyy · HH:mm');

  static bool isUsable(num? value) =>
      value != null && value.isFinite && !value.isNaN;

  static String _guard(
    num? value,
    String Function(num) format,
    String fallback,
  ) {
    if (!isUsable(value)) return fallback;
    return format(value!);
  }

  /// Virtual currency. Always paired with a "virtual" label in the UI.
  static String money(num? value, {String fallback = '—'}) =>
      _guard(value, (v) => _money.format(v), fallback);

  static String signedMoney(num? value, {String fallback = '—'}) {
    if (!isUsable(value)) return fallback;
    final sign = value! >= 0 ? '+' : '-';
    return '$sign${_money.format(value.abs())}';
  }

  static String integer(num? value, {String fallback = '—'}) =>
      _guard(value, (v) => _int.format(v.round()), fallback);

  static String compact(num? value, {String fallback = '—'}) =>
      _guard(value, (v) => _compact.format(v), fallback);

  /// Percentage from a 0..1 ratio.
  static String percentOfRatio(
    num? ratio, {
    int decimals = 0,
    String fallback = '—',
  }) =>
      _guard(ratio, (v) => '${(v * 100).toStringAsFixed(decimals)}%', fallback);

  /// Percentage from an already-scaled value (1.5 -> "1.5%").
  static String percent(
    num? value, {
    int decimals = 2,
    String fallback = '—',
  }) => _guard(
    value,
    (v) => '${_trimZeros(v.toStringAsFixed(decimals))}%',
    fallback,
  );

  static String rMultiple(num? value, {String fallback = '—'}) {
    if (!isUsable(value)) return fallback;
    final sign = value! >= 0 ? '+' : '-';
    return '$sign${value.abs().toStringAsFixed(2)}R';
  }

  static String ratio(num? value, {String fallback = '—'}) {
    if (!isUsable(value) || value! <= 0) return fallback;
    return '1:${value.toStringAsFixed(2)}';
  }

  /// Price formatting that adapts the number of decimals to the magnitude, so
  /// a \$0.42 asset and a \$68,000 asset both read naturally.
  static String price(num? value, {String fallback = '—'}) {
    if (!isUsable(value)) return fallback;
    final v = value!.abs();
    final decimals = v >= 1000
        ? 2
        : v >= 100
        ? 2
        : v >= 1
        ? 3
        : 5;
    return value.toStringAsFixed(decimals);
  }

  static String date(DateTime? value, {String fallback = '—'}) =>
      value == null ? fallback : _date.format(value);

  static String dateTime(DateTime? value, {String fallback = '—'}) =>
      value == null ? fallback : _dateTime.format(value);

  static String duration(Duration? value, {String fallback = '—'}) {
    if (value == null) return fallback;
    final m = value.inMinutes;
    if (m < 60) return '${m}m';
    return '${m ~/ 60}h ${m % 60}m';
  }

  static String _trimZeros(String value) {
    if (!value.contains('.')) return value;
    var out = value;
    while (out.endsWith('0')) {
      out = out.substring(0, out.length - 1);
    }
    if (out.endsWith('.')) out = out.substring(0, out.length - 1);
    return out;
  }
}

/// Clamps a double into a finite range, mapping non-finite input to [fallback].
double safeDouble(
  double? value, {
  double fallback = 0,
  double? min,
  double? max,
}) {
  var v = (value == null || value.isNaN || !value.isFinite) ? fallback : value;
  if (min != null && v < min) v = min;
  if (max != null && v > max) v = max;
  return v;
}
