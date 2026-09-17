import 'dart:math' as math;

import '../../core/seeded_random.dart';
import '../../domain/models/chart_series.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/market.dart';

/// Builds deterministic, clearly-labelled *educational* candle series from a
/// [ChartRecipe].
///
/// ## Why the structure is constructed rather than detected
///
/// Every chart exercise needs a provably correct answer. Detecting swings with
/// a heuristic would make answers only as good as the heuristic. Instead the
/// generator starts from a *designed* sequence of swing levels (for example
/// "low, high, higher low, higher high") and then fills candles between those
/// levels under a hard invariant:
///
///   every candle strictly between two swing nodes stays inside the price band
///   bounded by those two nodes.
///
/// That invariant makes each node a genuine local extreme, makes the global
/// highest high exactly the highest designed node, and therefore makes
/// "which point is the Higher Low?" answerable with certainty.
///
/// The data produced here is **synthetic educational data**. It is never
/// presented as real recorded market history.
class SyntheticSeriesGenerator {
  const SyntheticSeriesGenerator._();

  /// Builds the series described by [recipe]. The same recipe always produces
  /// byte-identical candles.
  static GeneratedSeries build(ChartRecipe recipe) {
    final rnd = SeededRandom(
      recipe.seed ^ SeededRandom.stableHash(recipe.pattern.name),
    );
    final asset = recipe.asset;

    final nodes = _buildPath(recipe, rnd);
    final targetCount = math.max(12, recipe.candleCount);
    final indices = _assignIndices(nodes, targetCount, rnd);

    final basePrice = asset.referencePrice * rnd.nextRange(0.82, 1.24);
    final unit =
        basePrice *
        asset.baseVolatility *
        recipe.timeframe.volatilityScale *
        7.0;

    final prices = [for (final n in nodes) basePrice + n.level * unit];

    final closes = _buildCloses(
      nodes: nodes,
      indices: indices,
      prices: prices,
      count: indices.last + 1,
      noise: recipe.difficulty.noise,
      rnd: rnd,
    );

    final builtCandles = _buildCandles(
      closes: closes,
      nodes: nodes,
      indices: indices,
      prices: prices,
      unit: unit,
      recipe: recipe,
      rnd: rnd,
    );

    final zones = <ChartZone>[];
    final candles = _applyPatternDetails(
      recipe: recipe,
      candles: builtCandles,
      nodes: nodes,
      indices: indices,
      prices: prices,
      unit: unit,
      zones: zones,
      rnd: rnd,
    );

    final swings = <SwingPoint>[];
    var order = 0;
    for (var i = 0; i < nodes.length; i++) {
      swings.add(
        SwingPoint(
          index: indices[i],
          price: nodes[i].isHigh
              ? candles[indices[i]].high
              : candles[indices[i]].low,
          isHigh: nodes[i].isHigh,
          label: nodes[i].label,
          order: order++,
        ),
      );
    }

    return GeneratedSeries(
      recipe: recipe,
      candles: List.unmodifiable(candles),
      swings: List.unmodifiable(swings),
      zones: List.unmodifiable(zones),
    );
  }

  // ---------------------------------------------------------------- path ---

  static int _defaultLegs(ChartPattern pattern) => switch (pattern) {
    ChartPattern.uptrend || ChartPattern.downtrend => 3,
    ChartPattern.range || ChartPattern.tightConsolidation => 3,
    ChartPattern.choppyVolatile => 5,
    _ => 2,
  };

  static List<_Node> _buildPath(ChartRecipe recipe, SeededRandom rnd) {
    final legs = math.max(1, recipe.legs ?? _defaultLegs(recipe.pattern));
    return switch (recipe.pattern) {
      ChartPattern.uptrend => _trendPath(rnd, legs, up: true),
      ChartPattern.downtrend => _trendPath(rnd, legs, up: false),
      ChartPattern.uptrendPullback => _trendPath(
        rnd,
        legs,
        up: true,
        endInPullback: true,
      ),
      ChartPattern.downtrendPullback => _trendPath(
        rnd,
        legs,
        up: false,
        endInPullback: true,
      ),
      ChartPattern.range => _rangePath(rnd, legs, amplitude: 1.0),
      ChartPattern.tightConsolidation => _rangePath(
        rnd,
        math.max(3, legs),
        amplitude: 0.30,
      ),
      ChartPattern.breakoutUp => _breakoutPath(rnd, up: true, fails: false),
      ChartPattern.breakoutDown => _breakoutPath(rnd, up: false, fails: false),
      ChartPattern.falseBreakoutUp => _breakoutPath(rnd, up: true, fails: true),
      ChartPattern.falseBreakoutDown => _breakoutPath(
        rnd,
        up: false,
        fails: true,
      ),
      ChartPattern.liquiditySweepHigh => _sweepPath(rnd, high: true),
      ChartPattern.liquiditySweepLow => _sweepPath(rnd, high: false),
      ChartPattern.supportTest => _levelTestPath(rnd, support: true),
      ChartPattern.resistanceTest => _levelTestPath(rnd, support: false),
      ChartPattern.breakOfStructureUp => _bosPath(
        rnd,
        up: true,
        withChoch: false,
      ),
      ChartPattern.breakOfStructureDown => _bosPath(
        rnd,
        up: false,
        withChoch: false,
      ),
      ChartPattern.changeOfCharacterUp => _bosPath(
        rnd,
        up: true,
        withChoch: true,
      ),
      ChartPattern.changeOfCharacterDown => _bosPath(
        rnd,
        up: false,
        withChoch: true,
      ),
      ChartPattern.fairValueGapUp ||
      ChartPattern.orderBlockUp => _trendPath(rnd, math.max(2, legs), up: true),
      ChartPattern.fairValueGapDown || ChartPattern.orderBlockDown =>
        _trendPath(rnd, math.max(2, legs), up: false),
      ChartPattern.choppyVolatile => _choppyPath(rnd, legs),
    };
  }

  static List<_Node> _trendPath(
    SeededRandom rnd,
    int legs, {
    required bool up,
    bool endInPullback = false,
  }) {
    final nodes = <_Node>[];
    if (up) {
      var low = 0.0;
      var high = rnd.nextRange(0.85, 1.15);
      nodes.add(_Node(isHigh: false, level: low, label: SwingLabel.first));
      nodes.add(_Node(isHigh: true, level: high, label: SwingLabel.first));
      for (var i = 0; i < legs; i++) {
        final retrace = rnd.nextRange(0.34, 0.62);
        final newLow = high - retrace * (high - low);
        nodes.add(
          _Node(isHigh: false, level: newLow, label: SwingLabel.higherLow),
        );
        final advance = rnd.nextRange(0.85, 1.45);
        final newHigh = high + advance * (high - newLow) * 0.75;
        final isLast = i == legs - 1;
        if (isLast && endInPullback) {
          low = newLow;
          break;
        }
        nodes.add(
          _Node(isHigh: true, level: newHigh, label: SwingLabel.higherHigh),
        );
        low = newLow;
        high = newHigh;
      }
    } else {
      var high = rnd.nextRange(0.85, 1.15);
      var low = 0.0;
      nodes.add(_Node(isHigh: true, level: high, label: SwingLabel.first));
      nodes.add(_Node(isHigh: false, level: low, label: SwingLabel.first));
      for (var i = 0; i < legs; i++) {
        final retrace = rnd.nextRange(0.34, 0.62);
        final newHigh = low + retrace * (high - low);
        nodes.add(
          _Node(isHigh: true, level: newHigh, label: SwingLabel.lowerHigh),
        );
        final advance = rnd.nextRange(0.85, 1.45);
        final newLow = low - advance * (newHigh - low) * 0.75;
        final isLast = i == legs - 1;
        if (isLast && endInPullback) {
          high = newHigh;
          break;
        }
        nodes.add(
          _Node(isHigh: false, level: newLow, label: SwingLabel.lowerLow),
        );
        high = newHigh;
        low = newLow;
      }
    }
    return nodes;
  }

  static List<_Node> _rangePath(
    SeededRandom rnd,
    int touches, {
    required double amplitude,
  }) {
    final nodes = <_Node>[];
    final jitter = amplitude * 0.045;
    nodes.add(_Node(isHigh: false, level: 0, label: SwingLabel.first));
    nodes.add(_Node(isHigh: true, level: amplitude, label: SwingLabel.first));
    for (var i = 0; i < touches; i++) {
      nodes.add(
        _Node(
          isHigh: false,
          level: rnd.nextRange(-jitter, jitter),
          label: SwingLabel.equalLow,
        ),
      );
      nodes.add(
        _Node(
          isHigh: true,
          level: amplitude + rnd.nextRange(-jitter, jitter),
          label: SwingLabel.equalHigh,
        ),
      );
    }
    return nodes;
  }

  static List<_Node> _breakoutPath(
    SeededRandom rnd, {
    required bool up,
    required bool fails,
  }) {
    final nodes = _rangePath(rnd, 2, amplitude: 1.0);
    final jitter = 0.045;
    if (up) {
      nodes.add(
        _Node(
          isHigh: false,
          level: rnd.nextRange(0.18, 0.34),
          label: SwingLabel.higherLow,
        ),
      );
      nodes.add(
        _Node(
          isHigh: true,
          level: fails ? rnd.nextRange(1.05, 1.12) : rnd.nextRange(1.45, 1.75),
          label: SwingLabel.higherHigh,
        ),
      );
      if (fails) {
        nodes.add(
          _Node(
            isHigh: false,
            level: rnd.nextRange(-0.22, -0.06),
            label: SwingLabel.lowerLow,
          ),
        );
      } else {
        nodes.add(
          _Node(
            isHigh: false,
            level: rnd.nextRange(1.06, 1.18),
            label: SwingLabel.higherLow,
          ),
        );
      }
    } else {
      // The range ends on a high, so the break itself is the next low.
      nodes.add(
        _Node(
          isHigh: false,
          level: fails
              ? rnd.nextRange(-0.12, -0.05)
              : rnd.nextRange(-0.75, -0.45),
          label: SwingLabel.lowerLow,
        ),
      );
      if (fails) {
        // Price reclaims the range and runs to the opposite side.
        nodes.add(
          _Node(
            isHigh: true,
            level: rnd.nextRange(1.06, 1.22),
            label: SwingLabel.higherHigh,
          ),
        );
      } else {
        // A lower high forms under the broken boundary.
        nodes.add(
          _Node(
            isHigh: true,
            level: rnd.nextRange(-0.18, -0.06) + jitter,
            label: SwingLabel.lowerHigh,
          ),
        );
      }
    }
    return nodes;
  }

  static List<_Node> _sweepPath(SeededRandom rnd, {required bool high}) {
    final nodes = <_Node>[];
    if (high) {
      const firstHigh = 1.0;
      nodes.add(_Node(isHigh: false, level: 0, label: SwingLabel.first));
      nodes.add(_Node(isHigh: true, level: firstHigh, label: SwingLabel.first));
      final hl1 = rnd.nextRange(0.28, 0.40);
      nodes.add(_Node(isHigh: false, level: hl1, label: SwingLabel.higherLow));
      final eqh = firstHigh + rnd.nextRange(-0.015, 0.012);
      nodes.add(_Node(isHigh: true, level: eqh, label: SwingLabel.equalHigh));
      final hl2 = hl1 + rnd.nextRange(0.04, 0.14);
      nodes.add(_Node(isHigh: false, level: hl2, label: SwingLabel.higherLow));
      // The sweep: a shallow poke above the matched highs.
      final sweep = math.max(firstHigh, eqh) + rnd.nextRange(0.035, 0.075);
      nodes.add(
        _Node(isHigh: true, level: sweep, label: SwingLabel.higherHigh),
      );
      // Then price trades back through the structure that built the highs.
      nodes.add(
        _Node(
          isHigh: false,
          level: rnd.nextRange(-0.30, -0.12),
          label: SwingLabel.lowerLow,
        ),
      );
    } else {
      const firstLow = 0.0;
      nodes.add(_Node(isHigh: true, level: 1.0, label: SwingLabel.first));
      nodes.add(_Node(isHigh: false, level: firstLow, label: SwingLabel.first));
      final lh1 = rnd.nextRange(0.56, 0.68);
      nodes.add(_Node(isHigh: true, level: lh1, label: SwingLabel.lowerHigh));
      final eql = firstLow + rnd.nextRange(-0.015, 0.012);
      nodes.add(_Node(isHigh: false, level: eql, label: SwingLabel.equalLow));
      final lh2 = lh1 - rnd.nextRange(0.04, 0.14);
      nodes.add(_Node(isHigh: true, level: lh2, label: SwingLabel.lowerHigh));
      final sweep = math.min(firstLow, eql) - rnd.nextRange(0.035, 0.075);
      nodes.add(_Node(isHigh: false, level: sweep, label: SwingLabel.lowerLow));
      nodes.add(
        _Node(
          isHigh: true,
          level: rnd.nextRange(1.12, 1.30),
          label: SwingLabel.higherHigh,
        ),
      );
    }
    return nodes;
  }

  static List<_Node> _levelTestPath(SeededRandom rnd, {required bool support}) {
    final nodes = <_Node>[];
    if (support) {
      nodes.add(_Node(isHigh: true, level: 1.2, label: SwingLabel.first));
      nodes.add(_Node(isHigh: false, level: 0, label: SwingLabel.first));
      final lh = rnd.nextRange(0.55, 0.75);
      nodes.add(_Node(isHigh: true, level: lh, label: SwingLabel.lowerHigh));
      final eql1 = rnd.nextRange(0.008, 0.045);
      nodes.add(_Node(isHigh: false, level: eql1, label: SwingLabel.equalLow));
      nodes.add(
        _Node(
          isHigh: true,
          level: lh + rnd.nextRange(0.06, 0.2),
          label: SwingLabel.higherHigh,
        ),
      );
      nodes.add(
        _Node(
          isHigh: false,
          level: eql1 + rnd.nextRange(-0.02, 0.03),
          label: SwingLabel.equalLow,
        ),
      );
    } else {
      nodes.add(_Node(isHigh: false, level: -0.2, label: SwingLabel.first));
      nodes.add(_Node(isHigh: true, level: 1.0, label: SwingLabel.first));
      final hl = rnd.nextRange(0.25, 0.45);
      nodes.add(_Node(isHigh: false, level: hl, label: SwingLabel.higherLow));
      final eqh1 = rnd.nextRange(0.955, 0.992);
      nodes.add(_Node(isHigh: true, level: eqh1, label: SwingLabel.equalHigh));
      nodes.add(
        _Node(
          isHigh: false,
          level: hl - rnd.nextRange(0.06, 0.2),
          label: SwingLabel.lowerLow,
        ),
      );
      nodes.add(
        _Node(
          isHigh: true,
          level: eqh1 + rnd.nextRange(-0.03, 0.02),
          label: SwingLabel.equalHigh,
        ),
      );
    }
    return nodes;
  }

  static List<_Node> _bosPath(
    SeededRandom rnd, {
    required bool up,
    required bool withChoch,
  }) {
    final nodes = <_Node>[];
    if (up) {
      // Prior bearish structure: LH then LL.
      nodes.add(_Node(isHigh: true, level: 1.3, label: SwingLabel.first));
      nodes.add(_Node(isHigh: false, level: 0.2, label: SwingLabel.first));
      nodes.add(
        _Node(
          isHigh: true,
          level: rnd.nextRange(0.8, 0.95),
          label: SwingLabel.lowerHigh,
        ),
      );
      nodes.add(_Node(isHigh: false, level: 0, label: SwingLabel.lowerLow));
      if (withChoch) {
        // A higher low appears first — the character of the move changes
        // before the break happens.
        nodes.add(
          _Node(
            isHigh: true,
            level: rnd.nextRange(0.55, 0.7),
            label: SwingLabel.lowerHigh,
          ),
        );
        nodes.add(
          _Node(
            isHigh: false,
            level: rnd.nextRange(0.2, 0.34),
            label: SwingLabel.higherLow,
          ),
        );
      }
      // The break: price trades above the most recent lower high.
      nodes.add(
        _Node(
          isHigh: true,
          level: rnd.nextRange(1.05, 1.25),
          label: SwingLabel.higherHigh,
        ),
      );
      nodes.add(
        _Node(
          isHigh: false,
          level: rnd.nextRange(0.62, 0.78),
          label: SwingLabel.higherLow,
        ),
      );
    } else {
      nodes.add(_Node(isHigh: false, level: -0.3, label: SwingLabel.first));
      nodes.add(_Node(isHigh: true, level: 0.8, label: SwingLabel.first));
      nodes.add(
        _Node(
          isHigh: false,
          level: rnd.nextRange(0.05, 0.2),
          label: SwingLabel.higherLow,
        ),
      );
      nodes.add(_Node(isHigh: true, level: 1.0, label: SwingLabel.higherHigh));
      if (withChoch) {
        nodes.add(
          _Node(
            isHigh: false,
            level: rnd.nextRange(0.3, 0.45),
            label: SwingLabel.higherLow,
          ),
        );
        nodes.add(
          _Node(
            isHigh: true,
            level: rnd.nextRange(0.66, 0.8),
            label: SwingLabel.lowerHigh,
          ),
        );
      }
      nodes.add(
        _Node(
          isHigh: false,
          level: rnd.nextRange(-0.25, -0.05),
          label: SwingLabel.lowerLow,
        ),
      );
      nodes.add(
        _Node(
          isHigh: true,
          level: rnd.nextRange(0.2, 0.38),
          label: SwingLabel.lowerHigh,
        ),
      );
    }
    return nodes;
  }

  static List<_Node> _choppyPath(SeededRandom rnd, int legs) {
    final nodes = <_Node>[];
    var isHigh = rnd.nextBool();
    final total = legs * 2 + 2;
    for (var i = 0; i < total; i++) {
      // Highs and lows are drawn from non-overlapping bands so that a "high"
      // is always above its neighbouring lows, while the sequence itself has
      // no consistent direction — which is the point of a choppy chart.
      nodes.add(
        _Node(
          isHigh: isHigh,
          level: isHigh
              ? rnd.nextRange(0.62, 1.05)
              : rnd.nextRange(-0.05, 0.38),
          label: SwingLabel.first,
        ),
      );
      isHigh = !isHigh;
    }
    return _autoLabel(nodes);
  }

  /// Derives HH/HL/LH/LL labels by comparing each swing to the previous swing
  /// of the same kind. Used for shapes with no designed label sequence.
  static List<_Node> _autoLabel(List<_Node> nodes) {
    double? lastHigh;
    double? lastLow;
    final out = <_Node>[];
    for (final n in nodes) {
      var label = SwingLabel.first;
      if (n.isHigh) {
        if (lastHigh != null) {
          label = n.level == lastHigh
              ? SwingLabel.equalHigh
              : (n.level > lastHigh
                    ? SwingLabel.higherHigh
                    : SwingLabel.lowerHigh);
        }
        lastHigh = n.level;
      } else {
        if (lastLow != null) {
          label = n.level == lastLow
              ? SwingLabel.equalLow
              : (n.level > lastLow
                    ? SwingLabel.higherLow
                    : SwingLabel.lowerLow);
        }
        lastLow = n.level;
      }
      out.add(_Node(isHigh: n.isHigh, level: n.level, label: label));
    }
    return out;
  }

  // ------------------------------------------------------------- indices ---

  static List<int> _assignIndices(
    List<_Node> nodes,
    int targetCount,
    SeededRandom rnd,
  ) {
    final segments = nodes.length - 1;
    const minPerSegment = 3;
    final needed = segments * minPerSegment + 1;
    final count = math.max(targetCount, needed);

    final weights = <double>[];
    for (var i = 0; i < segments; i++) {
      final delta = (nodes[i + 1].level - nodes[i].level).abs();
      weights.add(math.max(0.25, delta) * rnd.nextRange(0.85, 1.2));
    }
    final total = weights.fold<double>(0, (a, b) => a + b);
    final spare = count - 1 - segments * minPerSegment;

    final lengths = <int>[];
    var used = 0;
    for (var i = 0; i < segments; i++) {
      final extra = total <= 0 ? 0 : ((weights[i] / total) * spare).floor();
      lengths.add(minPerSegment + extra);
      used += minPerSegment + extra;
    }
    var remainder = (count - 1) - used;
    var i = 0;
    while (remainder > 0 && segments > 0) {
      lengths[i % segments] += 1;
      remainder--;
      i++;
    }

    final indices = <int>[0];
    var cursor = 0;
    for (final len in lengths) {
      cursor += len;
      indices.add(cursor);
    }
    return indices;
  }

  // -------------------------------------------------------------- render ---

  static List<double> _buildCloses({
    required List<_Node> nodes,
    required List<int> indices,
    required List<double> prices,
    required int count,
    required double noise,
    required SeededRandom rnd,
  }) {
    final closes = List<double>.filled(count, prices.first);

    for (var s = 0; s < nodes.length - 1; s++) {
      final ia = indices[s];
      final ib = indices[s + 1];
      final pa = prices[s];
      final pb = prices[s + 1];
      final lo = math.min(pa, pb);
      final hi = math.max(pa, pb);
      final amp = (hi - lo).abs();
      final margin = math.max(amp * 0.06, amp * 0.02 + 1e-9);
      final span = ib - ia;

      // Where the first candle of the run starts.
      if (s == 0) {
        closes[ia] = nodes[0].isHigh ? pa - margin * 1.4 : pa + margin * 1.4;
        closes[ia] = closes[ia].clamp(lo + margin, hi - margin).toDouble();
      }

      for (var j = 1; j <= span; j++) {
        final t = j / span;
        // Slightly eased interpolation keeps legs from looking like rulers.
        final eased = t * t * (3 - 2 * t) * 0.55 + t * 0.45;
        var value = pa + (pb - pa) * eased;
        value += rnd.nextGaussian(deviation: amp * noise * 0.16);
        if (j == span) {
          // The node candle closes just inside its own extreme.
          value = nodes[s + 1].isHigh
              ? pb - amp * rnd.nextRange(0.06, 0.2)
              : pb + amp * rnd.nextRange(0.06, 0.2);
        }
        closes[ia + j] = value.clamp(lo + margin, hi - margin).toDouble();
      }
    }
    return closes;
  }

  static List<Candle> _buildCandles({
    required List<double> closes,
    required List<_Node> nodes,
    required List<int> indices,
    required List<double> prices,
    required double unit,
    required ChartRecipe recipe,
    required SeededRandom rnd,
  }) {
    final count = closes.length;
    final start = _startTime(recipe);
    final step = recipe.timeframe.duration;
    final wickBase = unit * 0.05 * (0.6 + recipe.difficulty.noise);

    // Segment bounds per candle index, used to keep interior candles inside
    // the band defined by their two surrounding swing nodes.
    final loBound = List<double>.filled(count, double.negativeInfinity);
    final hiBound = List<double>.filled(count, double.infinity);
    final marginAt = List<double>.filled(count, 0);
    for (var s = 0; s < nodes.length - 1; s++) {
      final ia = indices[s];
      final ib = indices[s + 1];
      final lo = math.min(prices[s], prices[s + 1]);
      final hi = math.max(prices[s], prices[s + 1]);
      final margin = math.max((hi - lo) * 0.05, unit * 0.004);
      for (var i = ia; i <= ib && i < count; i++) {
        loBound[i] = math.max(loBound[i], lo);
        hiBound[i] = math.min(hiBound[i], hi);
        marginAt[i] = math.max(marginAt[i], margin);
      }
    }

    final nodeIndex = <int, int>{};
    for (var i = 0; i < nodes.length; i++) {
      nodeIndex[indices[i]] = i;
    }

    final candles = <Candle>[];
    for (var i = 0; i < count; i++) {
      final close = closes[i];
      final open = i == 0
          ? close - rnd.nextGaussian(deviation: unit * 0.02)
          : closes[i - 1];
      final bodyHigh = math.max(open, close);
      final bodyLow = math.min(open, close);
      var high = bodyHigh + wickBase * rnd.nextRange(0.05, 1.3);
      var low = bodyLow - wickBase * rnd.nextRange(0.05, 1.3);

      final maxHigh = hiBound[i] - marginAt[i] * 0.35;
      final minLow = loBound[i] + marginAt[i] * 0.35;
      final node = nodeIndex[i];
      if (node != null) {
        // The node candle owns its own extreme exactly, but its *other* side
        // still has to respect the neighbouring swings — otherwise a long wick
        // on a swing high could dip under the swing low next to it and break
        // the invariant the exercises rely on.
        if (nodes[node].isHigh) {
          high = prices[node];
          if (minLow.isFinite && low < minLow) low = minLow;
        } else {
          low = prices[node];
          if (maxHigh.isFinite && high > maxHigh) high = maxHigh;
        }
      } else {
        if (maxHigh.isFinite && high > maxHigh) high = maxHigh;
        if (minLow.isFinite && low < minLow) low = minLow;
      }

      // Keep the OHLC invariant after clamping.
      var o = open.clamp(math.min(low, high), math.max(low, high)).toDouble();
      var c = close.clamp(math.min(low, high), math.max(low, high)).toDouble();
      if (low > high) {
        final mid = (low + high) / 2;
        low = mid;
        high = mid;
        o = mid;
        c = mid;
      }
      if (o > high) o = high;
      if (o < low) o = low;
      if (c > high) c = high;
      if (c < low) c = low;

      final volume = _volume(recipe, (c - o).abs(), high - low, unit, rnd);

      candles.add(
        Candle(
          timestamp: start.add(step * i),
          open: o,
          high: high,
          low: low,
          close: c,
          volume: volume,
        ),
      );
    }
    return candles;
  }

  static double _volume(
    ChartRecipe recipe,
    double body,
    double range,
    double unit,
    SeededRandom rnd,
  ) {
    final base = switch (recipe.asset.assetClass) {
      AssetClass.crypto => 1800.0,
      AssetClass.stocks => 42000.0,
      AssetClass.forex => 9500.0,
      AssetClass.futures => 6400.0,
      AssetClass.commodities => 3100.0,
    };
    final activity = unit <= 0
        ? 1.0
        : 0.55 + (range / unit) * 2.4 + (body / unit) * 1.6;
    return (base * activity * rnd.nextRange(0.7, 1.35)).roundToDouble();
  }

  static DateTime _startTime(ChartRecipe recipe) {
    // A deterministic, clearly synthetic epoch. The simulator hides these
    // timestamps entirely when a recipe is anonymised.
    final rnd = SeededRandom(recipe.seed);
    final base = DateTime.utc(2019, 1, 1);
    return base.add(
      Duration(minutes: recipe.timeframe.minutes * rnd.nextInt(90000)),
    );
  }

  // ------------------------------------------------------ pattern details ---

  static List<Candle> _applyPatternDetails({
    required ChartRecipe recipe,
    required List<Candle> candles,
    required List<_Node> nodes,
    required List<int> indices,
    required List<double> prices,
    required double unit,
    required List<ChartZone> zones,
    required SeededRandom rnd,
  }) {
    final out = List<Candle>.of(candles);
    final band = unit * 0.075;

    void addLevelZone(
      ZoneKind kind,
      double level,
      int from,
      int to,
      String description,
    ) {
      zones.add(
        ChartZone(
          id: '${kind.name}_${from}_${zones.length}',
          startIndex: from.clamp(0, out.length - 1),
          endIndex: to.clamp(0, out.length - 1),
          lowPrice: level - band,
          highPrice: level + band,
          kind: kind,
          description: description,
        ),
      );
    }

    switch (recipe.pattern) {
      case ChartPattern.supportTest:
        final lows = [
          for (var i = 0; i < nodes.length; i++)
            if (!nodes[i].isHigh) prices[i],
        ];
        if (lows.isNotEmpty) {
          final level = lows.reduce((a, b) => a + b) / lows.length;
          addLevelZone(
            ZoneKind.support,
            level,
            0,
            out.length - 1,
            'Price has turned up from this area more than once in the visible window.',
          );
        }
      case ChartPattern.resistanceTest:
        final highs = [
          for (var i = 0; i < nodes.length; i++)
            if (nodes[i].isHigh) prices[i],
        ];
        if (highs.isNotEmpty) {
          final level = highs.reduce((a, b) => a + b) / highs.length;
          addLevelZone(
            ZoneKind.resistance,
            level,
            0,
            out.length - 1,
            'Sellers have appeared around this area more than once in the visible window.',
          );
        }
      case ChartPattern.range:
      case ChartPattern.tightConsolidation:
        final highs = [
          for (var i = 0; i < nodes.length; i++)
            if (nodes[i].isHigh) prices[i],
        ];
        final lows = [
          for (var i = 0; i < nodes.length; i++)
            if (!nodes[i].isHigh) prices[i],
        ];
        if (highs.isNotEmpty) {
          addLevelZone(
            ZoneKind.rangeHigh,
            highs.reduce(math.max),
            0,
            out.length - 1,
            'Upper boundary of the range.',
          );
        }
        if (lows.isNotEmpty) {
          addLevelZone(
            ZoneKind.rangeLow,
            lows.reduce(math.min),
            0,
            out.length - 1,
            'Lower boundary of the range.',
          );
        }
      case ChartPattern.breakoutUp:
      case ChartPattern.falseBreakoutUp:
        final rangeHigh = _rangeBoundary(nodes, prices, high: true, limit: 4);
        final heldUp = recipe.pattern == ChartPattern.breakoutUp;
        addLevelZone(
          ZoneKind.resistance,
          rangeHigh,
          0,
          out.length - 1,
          heldUp ? 'Price traded decisively above this boundary and held.' : 'Price traded above this boundary and then closed back inside the range.',
        );
        if (heldUp) {
          // Role reversal: once the boundary breaks and holds, price meets the
          // same area from above, so it is also marked as support.
          addLevelZone(
            ZoneKind.support,
            rangeHigh,
            0,
            out.length - 1,
            'This area capped price before the break. With price now trading above it, the same '
            'area is watched from the other side. That flip is a tendency, not a rule.',
          );
        }
      case ChartPattern.breakoutDown:
      case ChartPattern.falseBreakoutDown:
        final rangeLow = _rangeBoundary(nodes, prices, high: false, limit: 4);
        final heldDown = recipe.pattern == ChartPattern.breakoutDown;
        addLevelZone(
          ZoneKind.support,
          rangeLow,
          0,
          out.length - 1,
          heldDown ? 'Price traded decisively below this boundary and held.' : 'Price traded below this boundary and then closed back inside the range.',
        );
        if (heldDown) {
          // Role reversal in the other direction.
          addLevelZone(
            ZoneKind.resistance,
            rangeLow,
            0,
            out.length - 1,
            'This area held price up before the break. With price now trading below it, the same '
            'area is watched from the other side. That flip is a tendency, not a rule.',
          );
        }
      case ChartPattern.liquiditySweepHigh:
        final eq = _firstNodeWithLabel(
          nodes,
          indices,
          prices,
          SwingLabel.equalHigh,
        );
        if (eq != null) {
          addLevelZone(
            ZoneKind.liquidityAbove,
            eq.$2,
            0,
            out.length - 1,
            'Stop orders from short positions and breakout buy orders tend to cluster above matched highs. '
            'This is a structural observation, not a prediction.',
          );
        }
      case ChartPattern.liquiditySweepLow:
        final eq = _firstNodeWithLabel(
          nodes,
          indices,
          prices,
          SwingLabel.equalLow,
        );
        if (eq != null) {
          addLevelZone(
            ZoneKind.liquidityBelow,
            eq.$2,
            0,
            out.length - 1,
            'Stop orders from long positions and breakout sell orders tend to cluster below matched lows. '
            'This is a structural observation, not a prediction.',
          );
        }
      case ChartPattern.fairValueGapUp:
        _injectFairValueGap(
          out,
          zones,
          up: true,
          unit: unit,
          protected: indices.toSet(),
        );
      case ChartPattern.fairValueGapDown:
        _injectFairValueGap(
          out,
          zones,
          up: false,
          unit: unit,
          protected: indices.toSet(),
        );
      case ChartPattern.orderBlockUp:
        _markOrderBlock(out, zones, bullish: true);
      case ChartPattern.orderBlockDown:
        _markOrderBlock(out, zones, bullish: false);
      default:
        break;
    }
    return out;
  }

  static double _rangeBoundary(
    List<_Node> nodes,
    List<double> prices, {
    required bool high,
    required int limit,
  }) {
    final values = <double>[];
    for (var i = 0; i < nodes.length && i < limit; i++) {
      if (nodes[i].isHigh == high) values.add(prices[i]);
    }
    if (values.isEmpty) return prices.first;
    return high ? values.reduce(math.max) : values.reduce(math.min);
  }

  static (int, double)? _firstNodeWithLabel(
    List<_Node> nodes,
    List<int> indices,
    List<double> prices,
    SwingLabel label,
  ) {
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i].label == label) return (indices[i], prices[i]);
    }
    return null;
  }

  /// Creates a genuine three-candle imbalance: the middle candle travels far
  /// enough that candle 1 and candle 3 do not overlap in price.
  ///
  /// Both edits are safe with respect to the band invariant: lowering a high
  /// and raising a low can never push a candle outside its segment bounds.
  static void _injectFairValueGap(
    List<Candle> candles,
    List<ChartZone> zones, {
    required bool up,
    required double unit,
    required Set<int> protected,
  }) {
    if (candles.length < 5) return;
    var best = -1;
    var bestBody = 0.0;
    for (var i = 2; i < candles.length - 2; i++) {
      // Never reshape a swing-node candle: its high/low is the ground truth an
      // exercise answer is derived from.
      if (protected.contains(i - 1) ||
          protected.contains(i) ||
          protected.contains(i + 1)) {
        continue;
      }
      final c = candles[i];
      final directional = up ? c.isBullish : c.isBearish;
      if (!directional) continue;
      if (c.body > bestBody) {
        bestBody = c.body;
        best = i;
      }
    }
    if (best < 0) return;

    final mid = candles[best];
    final prev = candles[best - 1];
    final next = candles[best + 1];

    if (up) {
      final newPrevHigh = math.min(prev.high, mid.open + unit * 0.004);
      final nextBodyLow = math.min(next.open, next.close);
      if (nextBodyLow <= newPrevHigh) return;
      final newNextLow = math.max(
        next.low,
        newPrevHigh + (nextBodyLow - newPrevHigh) * 0.35,
      );
      candles[best - 1] = prev.copyWith(
        high: math.max(newPrevHigh, math.max(prev.open, prev.close)),
      );
      candles[best + 1] = next.copyWith(low: math.min(newNextLow, nextBodyLow));
      final gapLow = candles[best - 1].high;
      final gapHigh = candles[best + 1].low;
      if (gapHigh <= gapLow) return;
      zones.add(
        ChartZone(
          id: 'fvg_up_$best',
          startIndex: best - 1,
          endIndex: math.min(candles.length - 1, best + 6),
          lowPrice: gapLow,
          highPrice: gapHigh,
          kind: ZoneKind.fairValueGapUp,
          description:
              'Candle ${best - 1} and candle ${best + 1} do not overlap: the move through this '
              'area happened in one direction with no two-sided trade. In this lesson framework '
              'that area is called a fair value gap.',
        ),
      );
    } else {
      final newPrevLow = math.max(prev.low, mid.open - unit * 0.004);
      final nextBodyHigh = math.max(next.open, next.close);
      if (nextBodyHigh >= newPrevLow) return;
      final newNextHigh = math.min(
        next.high,
        newPrevLow - (newPrevLow - nextBodyHigh) * 0.35,
      );
      candles[best - 1] = prev.copyWith(
        low: math.min(newPrevLow, math.min(prev.open, prev.close)),
      );
      candles[best + 1] = next.copyWith(
        high: math.max(newNextHigh, nextBodyHigh),
      );
      final gapHigh = candles[best - 1].low;
      final gapLow = candles[best + 1].high;
      if (gapHigh <= gapLow) return;
      zones.add(
        ChartZone(
          id: 'fvg_down_$best',
          startIndex: best - 1,
          endIndex: math.min(candles.length - 1, best + 6),
          lowPrice: gapLow,
          highPrice: gapHigh,
          kind: ZoneKind.fairValueGapDown,
          description:
              'Candle ${best - 1} and candle ${best + 1} do not overlap: price moved through this '
              'area in one direction. In this lesson framework that area is called a fair value gap.',
        ),
      );
    }
  }

  /// Marks the final opposite-direction candle before the strongest impulse.
  static void _markOrderBlock(
    List<Candle> candles,
    List<ChartZone> zones, {
    required bool bullish,
  }) {
    if (candles.length < 5) return;
    var impulse = -1;
    var bestBody = 0.0;
    for (var i = 2; i < candles.length - 1; i++) {
      final c = candles[i];
      if (bullish ? !c.isBullish : !c.isBearish) continue;
      if (c.body > bestBody) {
        bestBody = c.body;
        impulse = i;
      }
    }
    if (impulse < 1) return;

    var block = impulse - 1;
    for (var i = impulse - 1; i >= math.max(0, impulse - 4); i--) {
      if (bullish ? candles[i].isBearish : candles[i].isBullish) {
        block = i;
        break;
      }
    }
    final c = candles[block];
    zones.add(
      ChartZone(
        id: 'ob_$block',
        startIndex: block,
        endIndex: math.min(candles.length - 1, impulse + 8),
        lowPrice: c.low,
        highPrice: c.high,
        kind: bullish ? ZoneKind.orderBlockBullish : ZoneKind.orderBlockBearish,
        description:
            'The last ${bullish ? 'down' : 'up'} candle before the strong move at candle $impulse. '
            'Some frameworks watch this area on a return. It marks where the impulse began; it does '
            'not guarantee a reaction.',
      ),
    );
  }
}

class _Node {
  const _Node({required this.isHigh, required this.level, required this.label});

  final bool isHigh;
  final double level;
  final SwingLabel label;
}
