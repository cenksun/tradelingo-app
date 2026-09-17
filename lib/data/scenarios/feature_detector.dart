import 'dart:math' as math;

import '../../domain/models/chart_series.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/market.dart';
import '../../domain/models/scenario.dart';

/// Classifies an arbitrary window of candles.
///
/// Synthetic series carry ground-truth structure, but imported OHLCV does not,
/// so the pipeline needs a detector that works from candles alone. This is that
/// detector: it finds swing points with a fractal rule, labels them, and
/// derives educational features from the labelled sequence.
///
/// It classifies what has already happened. It does not forecast.
class FeatureDetector {
  const FeatureDetector._();

  /// Candles either side required for a swing to count.
  static const int swingLookaround = 2;

  /// Two swings within this fraction of each other count as "equal".
  static const double equalTolerance = 0.0035;

  /// Finds swing points using a symmetric fractal rule.
  static List<SwingPoint> detectSwings(
    List<Candle> candles, {
    int lookaround = swingLookaround,
  }) {
    final raw = <({int index, double price, bool isHigh})>[];
    for (var i = lookaround; i < candles.length - lookaround; i++) {
      var isHigh = true;
      var isLow = true;
      for (var j = i - lookaround; j <= i + lookaround; j++) {
        if (j == i) continue;
        if (candles[j].high >= candles[i].high) isHigh = false;
        if (candles[j].low <= candles[i].low) isLow = false;
      }
      if (isHigh) raw.add((index: i, price: candles[i].high, isHigh: true));
      if (isLow) raw.add((index: i, price: candles[i].low, isHigh: false));
    }
    raw.sort((a, b) => a.index.compareTo(b.index));

    // Collapse consecutive swings of the same kind, keeping the extreme one, so
    // the sequence alternates high/low the way structure labelling expects.
    final alternating = <({int index, double price, bool isHigh})>[];
    for (final s in raw) {
      if (alternating.isEmpty) {
        alternating.add(s);
        continue;
      }
      final last = alternating.last;
      if (last.isHigh == s.isHigh) {
        final replace = s.isHigh ? s.price > last.price : s.price < last.price;
        if (replace) alternating[alternating.length - 1] = s;
      } else {
        alternating.add(s);
      }
    }

    final out = <SwingPoint>[];
    double? lastHigh;
    double? lastLow;
    var order = 0;
    for (final s in alternating) {
      var label = SwingLabel.first;
      if (s.isHigh) {
        if (lastHigh != null) {
          label = _compare(s.price, lastHigh, high: true);
        }
        lastHigh = s.price;
      } else {
        if (lastLow != null) {
          label = _compare(s.price, lastLow, high: false);
        }
        lastLow = s.price;
      }
      out.add(
        SwingPoint(
          index: s.index,
          price: s.price,
          isHigh: s.isHigh,
          label: label,
          order: order++,
        ),
      );
    }
    return out;
  }

  static SwingLabel _compare(
    double value,
    double previous, {
    required bool high,
  }) {
    if (previous == 0) return SwingLabel.first;
    final diff = (value - previous).abs() / previous;
    if (diff <= equalTolerance) {
      return high ? SwingLabel.equalHigh : SwingLabel.equalLow;
    }
    if (high) {
      return value > previous ? SwingLabel.higherHigh : SwingLabel.lowerHigh;
    }
    return value > previous ? SwingLabel.higherLow : SwingLabel.lowerLow;
  }

  /// Classifies the trend from a labelled swing sequence.
  static TrendClass classifyTrend(List<SwingPoint> swings) {
    final recent = swings.length > 6
        ? swings.sublist(swings.length - 6)
        : swings;
    var bull = 0;
    var bear = 0;
    for (final s in recent) {
      switch (s.label) {
        case SwingLabel.higherHigh:
        case SwingLabel.higherLow:
          bull++;
        case SwingLabel.lowerHigh:
        case SwingLabel.lowerLow:
          bear++;
        default:
          break;
      }
    }
    if (bull >= 3 && bull > bear + 1) return TrendClass.bullish;
    if (bear >= 3 && bear > bull + 1) return TrendClass.bearish;
    return TrendClass.range;
  }

  /// Derives the educational feature set for a window.
  static Set<ScenarioFeature> detectFeatures(
    List<Candle> candles,
    List<SwingPoint> swings,
  ) {
    final features = <ScenarioFeature>{};
    if (candles.isEmpty) return features;

    for (final s in swings) {
      switch (s.label) {
        case SwingLabel.higherHigh:
          features.add(ScenarioFeature.higherHigh);
        case SwingLabel.higherLow:
          features.add(ScenarioFeature.higherLow);
        case SwingLabel.lowerHigh:
          features.add(ScenarioFeature.lowerHigh);
        case SwingLabel.lowerLow:
          features.add(ScenarioFeature.lowerLow);
        case SwingLabel.equalHigh:
          features.add(ScenarioFeature.equalHighs);
        case SwingLabel.equalLow:
          features.add(ScenarioFeature.equalLows);
        case SwingLabel.first:
          break;
      }
    }

    final trend = classifyTrend(swings);
    switch (trend) {
      case TrendClass.bullish:
        features.add(ScenarioFeature.bullishStructure);
      case TrendClass.bearish:
        features.add(ScenarioFeature.bearishStructure);
      case TrendClass.range:
        features.add(ScenarioFeature.rangeBound);
    }

    // A pullback: the last swing runs against the prevailing structure.
    if (swings.length >= 3) {
      final last = swings.last;
      if (trend == TrendClass.bullish && !last.isHigh) {
        features.add(ScenarioFeature.pullback);
      }
      if (trend == TrendClass.bearish && last.isHigh) {
        features.add(ScenarioFeature.pullback);
      }
    }

    // Break of structure / change of character, read from the label sequence.
    if (swings.length >= 4) {
      final tail = swings.sublist(swings.length - 4);
      final labels = tail.map((s) => s.label).toList();
      final hadBear =
          labels.contains(SwingLabel.lowerHigh) ||
          labels.contains(SwingLabel.lowerLow);
      final hadBull =
          labels.contains(SwingLabel.higherHigh) ||
          labels.contains(SwingLabel.higherLow);
      if (hadBear && hadBull) {
        features.add(ScenarioFeature.changeOfCharacter);
      } else if (hadBull || hadBear) {
        features.add(ScenarioFeature.breakOfStructure);
      }
    }

    // Sweep: a marginal new extreme that was immediately given back.
    if (swings.length >= 3) {
      for (var i = 1; i < swings.length - 1; i++) {
        final prev = swings[i - 1];
        final s = swings[i];
        final next = swings[i + 1];
        if (s.isHigh != prev.isHigh) continue;
        final overshoot =
            (s.price - prev.price).abs() / math.max(prev.price, 1e-9);
        if (overshoot > 0 && overshoot < 0.012) {
          final reversed = s.isHigh
              ? next.price < prev.price
              : next.price > prev.price;
          if (reversed) features.add(ScenarioFeature.liquiditySweep);
        }
      }
    }

    // Level tests: two or more reactions in the same area.
    final highs = swings.where((s) => s.isHigh).map((s) => s.price).toList();
    final lows = swings.where((s) => !s.isHigh).map((s) => s.price).toList();
    if (_hasCluster(highs)) features.add(ScenarioFeature.resistanceTest);
    if (_hasCluster(lows)) features.add(ScenarioFeature.supportTest);

    // Range extent relative to typical candle range.
    final atr = averageTrueRange(candles);
    final high = candles.map((c) => c.high).reduce(math.max);
    final low = candles.map((c) => c.low).reduce(math.min);
    final span = high - low;
    if (atr > 0) {
      if (span / atr < 6) features.add(ScenarioFeature.tightRange);
      if (span / atr > 26 && trend == TrendClass.range) {
        features.add(ScenarioFeature.choppy);
      }
    }

    // Displacement and fair value gaps.
    if (_hasDisplacement(candles, atr)) {
      features.add(ScenarioFeature.displacement);
      features.add(ScenarioFeature.orderBlock);
    }
    if (_hasFairValueGap(candles)) features.add(ScenarioFeature.fairValueGap);

    // Breakouts, judged against the earlier part of the window.
    final breakoutState = _breakoutState(candles);
    if (breakoutState == _Breakout.held) features.add(ScenarioFeature.breakout);
    if (breakoutState == _Breakout.failed) {
      features.add(ScenarioFeature.falseBreakout);
    }

    return features;
  }

  static bool _hasCluster(List<double> prices) {
    for (var i = 0; i < prices.length; i++) {
      for (var j = i + 1; j < prices.length; j++) {
        final base = math.max(prices[i].abs(), 1e-9);
        if ((prices[i] - prices[j]).abs() / base < 0.006) return true;
      }
    }
    return false;
  }

  static bool _hasDisplacement(List<Candle> candles, double atr) {
    if (atr <= 0) return false;
    for (final c in candles) {
      if (c.body > atr * 2.2) return true;
    }
    return false;
  }

  static bool _hasFairValueGap(List<Candle> candles) {
    for (var i = 1; i < candles.length - 1; i++) {
      if (candles[i - 1].high < candles[i + 1].low) return true;
      if (candles[i - 1].low > candles[i + 1].high) return true;
    }
    return false;
  }

  static _Breakout _breakoutState(List<Candle> candles) {
    if (candles.length < 20) return _Breakout.none;
    final split = (candles.length * 0.7).floor();
    final base = candles.sublist(0, split);
    final recent = candles.sublist(split);
    final baseHigh = base.map((c) => c.high).reduce(math.max);
    final baseLow = base.map((c) => c.low).reduce(math.min);
    final recentHigh = recent.map((c) => c.high).reduce(math.max);
    final recentLow = recent.map((c) => c.low).reduce(math.min);
    final close = candles.last.close;

    if (recentHigh > baseHigh) {
      return close > baseHigh ? _Breakout.held : _Breakout.failed;
    }
    if (recentLow < baseLow) {
      return close < baseLow ? _Breakout.held : _Breakout.failed;
    }
    return _Breakout.none;
  }

  /// Average true range — the standard measure of typical candle movement.
  static double averageTrueRange(List<Candle> candles, {int period = 14}) {
    if (candles.length < 2) return 0;
    final start = math.max(1, candles.length - period);
    var sum = 0.0;
    var count = 0;
    for (var i = start; i < candles.length; i++) {
      final c = candles[i];
      final prevClose = candles[i - 1].close;
      final tr = [
        c.high - c.low,
        (c.high - prevClose).abs(),
        (c.low - prevClose).abs(),
      ].reduce(math.max);
      sum += tr;
      count++;
    }
    return count == 0 ? 0 : sum / count;
  }

  static VolatilityClass classifyVolatility(List<Candle> candles) {
    if (candles.isEmpty) return VolatilityClass.normal;
    final atr = averageTrueRange(candles);
    final reference = candles.last.close;
    if (reference <= 0 || atr <= 0) return VolatilityClass.normal;
    final ratio = atr / reference;
    if (ratio < 0.004) return VolatilityClass.calm;
    if (ratio < 0.009) return VolatilityClass.normal;
    if (ratio < 0.018) return VolatilityClass.elevated;
    return VolatilityClass.wild;
  }

  static MarketCondition classifyCondition(
    List<SwingPoint> swings,
    VolatilityClass volatility,
    Set<ScenarioFeature> features,
  ) {
    if (volatility == VolatilityClass.wild) return MarketCondition.volatile;
    if (features.contains(ScenarioFeature.changeOfCharacter)) {
      return MarketCondition.transitioning;
    }
    return switch (classifyTrend(swings)) {
      TrendClass.bullish => MarketCondition.trendingUp,
      TrendClass.bearish => MarketCondition.trendingDown,
      TrendClass.range => MarketCondition.ranging,
    };
  }
}

enum _Breakout { none, held, failed }
