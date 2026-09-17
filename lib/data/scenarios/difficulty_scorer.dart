import 'dart:math' as math;

import '../../domain/models/chart_series.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/market.dart';
import '../../domain/models/scenario.dart';
import 'feature_detector.dart';

/// Scores how hard a scenario window is to read.
///
/// Difficulty is derived from the chart itself rather than assigned, so it
/// stays meaningful for imported data as well as generated data. It moves on
/// four axes: how clean the structure is, how noisy the candles are, how many
/// concepts overlap, and how much is going on at once.
class DifficultyScorer {
  const DifficultyScorer._();

  /// Returns a 0..1 hardness score.
  static double score({
    required List<Candle> candles,
    required List<SwingPoint> swings,
    required Set<ScenarioFeature> features,
  }) {
    if (candles.isEmpty) return 0.5;

    // 1. Structural clarity: a consistent label sequence is easier to read.
    final clarity = _structuralClarity(swings);

    // 2. Noise: how much of each candle's range is wick rather than body.
    var wickShare = 0.0;
    for (final c in candles) {
      if (c.range <= 0) continue;
      wickShare += (c.upperWick + c.lowerWick) / c.range;
    }
    final noise = (wickShare / candles.length).clamp(0.0, 1.0);

    // 3. Concept load: more overlapping features means more to weigh up.
    final load = (features.length / 9).clamp(0.0, 1.0);

    // 4. Volatility relative to the window.
    final volatility = switch (FeatureDetector.classifyVolatility(candles)) {
      VolatilityClass.calm => 0.15,
      VolatilityClass.normal => 0.35,
      VolatilityClass.elevated => 0.7,
      VolatilityClass.wild => 1.0,
    };

    // 5. Window length: more candles to scan is mildly harder.
    final length = ((candles.length - 30) / 120).clamp(0.0, 1.0);

    final raw =
        (1 - clarity) * 0.36 +
        noise * 0.22 +
        load * 0.18 +
        volatility * 0.16 +
        length * 0.08;
    return raw.clamp(0.0, 1.0);
  }

  static Difficulty bucket(double score) {
    if (score < 0.32) return Difficulty.beginner;
    if (score < 0.5) return Difficulty.intermediate;
    if (score < 0.68) return Difficulty.advanced;
    return Difficulty.expert;
  }

  /// 1.0 when every swing follows the same directional pattern, 0 when the
  /// sequence is completely mixed.
  static double _structuralClarity(List<SwingPoint> swings) {
    if (swings.length < 3) return 0.2;
    var bull = 0;
    var bear = 0;
    var neutral = 0;
    for (final s in swings) {
      switch (s.label) {
        case SwingLabel.higherHigh:
        case SwingLabel.higherLow:
          bull++;
        case SwingLabel.lowerHigh:
        case SwingLabel.lowerLow:
          bear++;
        case SwingLabel.equalHigh:
        case SwingLabel.equalLow:
        case SwingLabel.first:
          neutral++;
      }
    }
    final total = bull + bear + neutral;
    if (total == 0) return 0.2;
    final dominant = math.max(bull, bear);
    // Equal highs/lows are their own kind of clarity (a clean range), so they
    // count towards the dominant reading rather than against it.
    return ((dominant + neutral * 0.55) / total).clamp(0.0, 1.0);
  }

  /// A short explanation of why a scenario rated the way it did, shown in the
  /// simulator so difficulty is never an unexplained label.
  static String explain({
    required List<Candle> candles,
    required List<SwingPoint> swings,
    required Set<ScenarioFeature> features,
  }) {
    final clarity = _structuralClarity(swings);
    final parts = <String>[];
    if (clarity > 0.75) {
      parts.add('the swing sequence is consistent');
    } else if (clarity > 0.5) {
      parts.add('the swing sequence is mostly consistent');
    } else {
      parts.add('the swing sequence is mixed');
    }
    final vol = FeatureDetector.classifyVolatility(candles);
    parts.add('volatility is ${vol.label.toLowerCase()}');
    if (features.length >= 5) {
      parts.add('several concepts overlap here');
    }
    return '${parts.join(', ')}.';
  }
}
