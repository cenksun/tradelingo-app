import 'package:flutter_test/flutter_test.dart';
import 'package:tradepath/data/market/synthetic_series_generator.dart';
import 'package:tradepath/domain/models/chart_series.dart';
import 'package:tradepath/domain/models/enums.dart';

void main() {
  test('all patterns produce valid candles and true local swing extremes', () {
    for (final pattern in ChartPattern.values) {
      for (final d in Difficulty.values) {
        for (var seed = 1; seed <= 10; seed++) {
          final recipe = ChartRecipe(
            seed: seed * 7919,
            pattern: pattern,
            difficulty: d,
          );
          final s = SyntheticSeriesGenerator.build(recipe);
          final tag = '$pattern/$d/seed$seed';

          expect(s.candles.length, greaterThanOrEqualTo(12), reason: tag);
          for (var i = 0; i < s.candles.length; i++) {
            expect(s.candles[i].isValid, isTrue, reason: '$tag candle $i');
          }
          expect(s.swings.length, greaterThanOrEqualTo(3), reason: tag);

          // Each swing is the strict extreme between its neighbouring swings.
          for (var k = 0; k < s.swings.length; k++) {
            final sw = s.swings[k];
            final from = k == 0 ? 0 : s.swings[k - 1].index;
            final to = k == s.swings.length - 1
                ? s.candles.length - 1
                : s.swings[k + 1].index;
            for (var i = from; i <= to; i++) {
              if (i == sw.index) continue;
              if (sw.isHigh) {
                expect(
                  s.candles[i].high,
                  lessThan(sw.price + 1e-6),
                  reason: '$tag: candle $i exceeds swing high at ${sw.index}',
                );
              } else {
                expect(
                  s.candles[i].low,
                  greaterThan(sw.price - 1e-6),
                  reason: '$tag: candle $i below swing low at ${sw.index}',
                );
              }
            }
          }

          // Global extremes coincide with designed swing extremes.
          final highs = s.swings.where((w) => w.isHigh).map((w) => w.price);
          final lows = s.swings.where((w) => !w.isHigh).map((w) => w.price);
          if (highs.isNotEmpty) {
            expect(
              s.highestPrice,
              closeTo(highs.reduce((a, b) => a > b ? a : b), 1e-6),
              reason: tag,
            );
          }
          if (lows.isNotEmpty) {
            expect(
              s.lowestPrice,
              closeTo(lows.reduce((a, b) => a < b ? a : b), 1e-6),
              reason: tag,
            );
          }
        }
      }
    }
  });

  test('structure labels match the numeric relationship they claim', () {
    for (final pattern in ChartPattern.values) {
      for (var seed = 1; seed <= 25; seed++) {
        final s = SyntheticSeriesGenerator.build(
          ChartRecipe(seed: seed * 104729, pattern: pattern),
        );
        double? lastHigh;
        double? lastLow;
        for (final sw in s.swings) {
          final tag = '$pattern/seed$seed/${sw.label}@${sw.index}';
          if (sw.isHigh) {
            if (lastHigh != null) {
              switch (sw.label) {
                case SwingLabel.higherHigh:
                  expect(sw.price, greaterThan(lastHigh), reason: tag);
                case SwingLabel.lowerHigh:
                  expect(sw.price, lessThan(lastHigh), reason: tag);
                case SwingLabel.equalHigh:
                  expect(
                    (sw.price - lastHigh).abs() / lastHigh,
                    lessThan(0.05),
                    reason: tag,
                  );
                default:
                  break;
              }
            }
            lastHigh = sw.price;
          } else {
            if (lastLow != null) {
              switch (sw.label) {
                case SwingLabel.higherLow:
                  expect(sw.price, greaterThan(lastLow), reason: tag);
                case SwingLabel.lowerLow:
                  expect(sw.price, lessThan(lastLow), reason: tag);
                case SwingLabel.equalLow:
                  expect(
                    (sw.price - lastLow).abs() / lastLow,
                    lessThan(0.05),
                    reason: tag,
                  );
                default:
                  break;
              }
            }
            lastLow = sw.price;
          }
        }
      }
    }
  });

  test('same recipe rebuilds byte-identical candles', () {
    const r = ChartRecipe(seed: 42, pattern: ChartPattern.uptrend);
    final a = SyntheticSeriesGenerator.build(r);
    final b = SyntheticSeriesGenerator.build(r);
    expect(a.candles.length, b.candles.length);
    for (var i = 0; i < a.candles.length; i++) {
      expect(a.candles[i].open, b.candles[i].open);
      expect(a.candles[i].high, b.candles[i].high);
      expect(a.candles[i].low, b.candles[i].low);
      expect(a.candles[i].close, b.candles[i].close);
      expect(a.candles[i].volume, b.candles[i].volume);
    }
  });

  test('pattern-specific zones are produced where the lesson needs them', () {
    ChartZone? zoneOf(ChartPattern p, ZoneKind kind) {
      for (var seed = 1; seed < 40; seed++) {
        final s = SyntheticSeriesGenerator.build(
          ChartRecipe(
            seed: seed * 31,
            pattern: p,
            difficulty: Difficulty.intermediate,
          ),
        );
        final z = s.zonesOfKind(kind);
        if (z.isNotEmpty) return z.first;
      }
      return null;
    }

    expect(zoneOf(ChartPattern.supportTest, ZoneKind.support), isNotNull);
    expect(zoneOf(ChartPattern.resistanceTest, ZoneKind.resistance), isNotNull);
    expect(
      zoneOf(ChartPattern.fairValueGapUp, ZoneKind.fairValueGapUp),
      isNotNull,
    );
    expect(
      zoneOf(ChartPattern.fairValueGapDown, ZoneKind.fairValueGapDown),
      isNotNull,
    );
    expect(
      zoneOf(ChartPattern.orderBlockUp, ZoneKind.orderBlockBullish),
      isNotNull,
    );
    expect(
      zoneOf(ChartPattern.liquiditySweepHigh, ZoneKind.liquidityAbove),
      isNotNull,
    );
    expect(zoneOf(ChartPattern.range, ZoneKind.rangeHigh), isNotNull);
  });
}
