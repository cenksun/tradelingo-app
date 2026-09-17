import 'dart:math' as math;

/// A small, dependency-free, fully deterministic pseudo random number
/// generator.
///
/// Determinism matters a lot in TradePath: the daily challenge, every chart
/// exercise and every simulator scenario is rebuilt from a seed rather than
/// stored, so the same seed must always produce the same content on every
/// device and in every test run. [math.Random] does not guarantee a stable
/// algorithm across Dart versions, so we implement a fixed one (xorshift128)
/// here instead.
class SeededRandom {
  SeededRandom(int seed)
    : _s0 = _mix(seed ^ 0x9E3779B9),
      _s1 = _mix(seed * 2 + 0x85EBCA6B),
      _s2 = _mix(seed * 3 + 0xC2B2AE35),
      _s3 = _mix(seed * 5 + 0x27D4EB2F);

  /// Builds a generator from an arbitrary string (for example a lesson id).
  factory SeededRandom.fromString(String value, [int salt = 0]) =>
      SeededRandom(stableHash(value) ^ (salt * 0x9E3779B9));

  int _s0;
  int _s1;
  int _s2;
  int _s3;

  static const int _mask32 = 0xFFFFFFFF;

  static int _mix(int value) {
    var x = value & _mask32;
    if (x == 0) x = 0x1A2B3C4D;
    x = (x ^ (x >> 16)) & _mask32;
    x = (x * 0x7FEB352D) & _mask32;
    x = (x ^ (x >> 15)) & _mask32;
    x = (x * 0x846CA68B) & _mask32;
    x = (x ^ (x >> 16)) & _mask32;
    return x == 0 ? 0x1A2B3C4D : x;
  }

  /// A stable 32 bit hash of [value]. Unlike [Object.hashCode] this is
  /// guaranteed not to change between runs or platforms.
  static int stableHash(String value) {
    var hash = 0x811C9DC5;
    for (var i = 0; i < value.length; i++) {
      hash = (hash ^ value.codeUnitAt(i)) & _mask32;
      hash = (hash * 0x01000193) & _mask32;
    }
    return hash;
  }

  /// Returns the next raw 32 bit value.
  int nextRaw() {
    final t = (_s1 << 9) & _mask32;
    _s2 ^= _s0;
    _s3 ^= _s1;
    _s1 ^= _s2;
    _s0 ^= _s3;
    _s2 ^= t;
    _s3 = ((_s3 << 11) | (_s3 >> 21)) & _mask32;
    return _s0 & _mask32;
  }

  /// Uniform integer in `[0, max)`.
  int nextInt(int max) {
    if (max <= 0) return 0;
    return nextRaw() % max;
  }

  /// Uniform integer in `[min, max]` inclusive.
  int nextIntRange(int min, int max) {
    if (max <= min) return min;
    return min + nextInt(max - min + 1);
  }

  /// Uniform double in `[0, 1)`.
  double nextDouble() => nextRaw() / 4294967296.0;

  /// Uniform double in `[min, max)`.
  double nextRange(double min, double max) => min + nextDouble() * (max - min);

  bool nextBool([double trueProbability = 0.5]) =>
      nextDouble() < trueProbability;

  /// Approximately normally distributed value using the sum of uniforms.
  /// Cheap, stable and good enough for synthetic price noise.
  double nextGaussian({double mean = 0, double deviation = 1}) {
    final sum = nextDouble() + nextDouble() + nextDouble() - 1.5;
    return mean + sum * 1.4142135 * deviation;
  }

  T pick<T>(List<T> items) => items[nextInt(items.length)];

  /// Returns a new shuffled copy of [items].
  List<T> shuffled<T>(List<T> items) {
    final copy = List<T>.of(items);
    for (var i = copy.length - 1; i > 0; i--) {
      final j = nextInt(i + 1);
      final tmp = copy[i];
      copy[i] = copy[j];
      copy[j] = tmp;
    }
    return copy;
  }
}
