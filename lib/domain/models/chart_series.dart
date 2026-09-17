import 'package:meta/meta.dart';

import '../../core/seeded_random.dart';
import 'enums.dart';
import 'market.dart';

/// A structurally significant high or low in a series.
@immutable
class SwingPoint {
  const SwingPoint({
    required this.index,
    required this.price,
    required this.isHigh,
    required this.label,
    required this.order,
  });

  /// Candle index this swing sits on.
  final int index;
  final double price;
  final bool isHigh;
  final SwingLabel label;

  /// Position in the swing sequence (0 = first).
  final int order;

  @override
  String toString() => 'Swing(${label.short}@$index, $price)';
}

/// A highlighted horizontal area on the chart.
@immutable
class ChartZone {
  const ChartZone({
    required this.id,
    required this.startIndex,
    required this.endIndex,
    required this.lowPrice,
    required this.highPrice,
    required this.kind,
    this.description = '',
  });

  final String id;
  final int startIndex;
  final int endIndex;
  final double lowPrice;
  final double highPrice;
  final ZoneKind kind;
  final String description;

  double get midPrice => (lowPrice + highPrice) / 2;
  bool containsPrice(double price) => price >= lowPrice && price <= highPrice;
}

/// A compact, serialisable description of a chart.
///
/// Recipes are what the curriculum stores: a handful of integers instead of an
/// array of candles. The candles are rebuilt deterministically at render time,
/// which keeps the app binary small while still producing thousands of
/// distinct charts.
@immutable
class ChartRecipe {
  const ChartRecipe({
    required this.seed,
    required this.pattern,
    this.difficulty = Difficulty.beginner,
    this.assetSymbol = 'BTC/USDT',
    this.timeframe = Timeframe.h1,
    this.legs,
    this.anonymized = false,
    this.candleCountOverride,
  });

  final int seed;
  final ChartPattern pattern;
  final Difficulty difficulty;
  final String assetSymbol;
  final Timeframe timeframe;

  /// Number of swing legs. Defaults to a value appropriate for the pattern.
  final int? legs;

  /// Hides the instrument name and dates so a learner cannot recognise a
  /// famous move instead of reading the structure.
  final bool anonymized;
  final int? candleCountOverride;

  MarketAsset get asset => AssetCatalog.bySymbol(assetSymbol);

  int get candleCount => candleCountOverride ?? difficulty.candleCount;

  ChartRecipe copyWith({
    int? seed,
    ChartPattern? pattern,
    Difficulty? difficulty,
    String? assetSymbol,
    Timeframe? timeframe,
    int? legs,
    bool? anonymized,
    int? candleCountOverride,
  }) => ChartRecipe(
    seed: seed ?? this.seed,
    pattern: pattern ?? this.pattern,
    difficulty: difficulty ?? this.difficulty,
    assetSymbol: assetSymbol ?? this.assetSymbol,
    timeframe: timeframe ?? this.timeframe,
    legs: legs ?? this.legs,
    anonymized: anonymized ?? this.anonymized,
    candleCountOverride: candleCountOverride ?? this.candleCountOverride,
  );

  /// Stable identity used for caching generated series.
  String get cacheKey =>
      '$seed|${pattern.name}|${difficulty.name}|$assetSymbol|'
      '${timeframe.name}|${legs ?? -1}|${candleCountOverride ?? -1}';

  Map<String, Object?> toJson() => {
    'seed': seed,
    'pattern': pattern.name,
    'difficulty': difficulty.name,
    'asset': assetSymbol,
    'timeframe': timeframe.name,
    'legs': legs,
    'anonymized': anonymized,
    'candles': candleCountOverride,
  };

  static ChartRecipe fromJson(Map<String, Object?> json) => ChartRecipe(
    seed: (json['seed'] as num?)?.toInt() ?? 1,
    pattern: ChartPattern.fromName(json['pattern'] as String?),
    difficulty: Difficulty.fromName(json['difficulty'] as String?),
    assetSymbol: (json['asset'] as String?) ?? 'BTC/USDT',
    timeframe: Timeframe.fromName(json['timeframe'] as String?),
    legs: (json['legs'] as num?)?.toInt(),
    anonymized: json['anonymized'] as bool? ?? false,
    candleCountOverride: (json['candles'] as num?)?.toInt(),
  );

  /// Derives a related recipe — same shape, different chart. Used by practice
  /// and review so a learner never repeats the identical picture.
  ChartRecipe variant(int salt) =>
      copyWith(seed: seed ^ (salt * 0x9E3779B9 + 17));
}

/// A fully materialised chart: candles plus the structure that was designed
/// into them.
///
/// Because the structure is *constructed* rather than detected, exercise
/// answers are ground truth, not the output of a heuristic.
@immutable
class GeneratedSeries {
  const GeneratedSeries({
    required this.recipe,
    required this.candles,
    required this.swings,
    required this.zones,
  });

  final ChartRecipe recipe;
  final List<Candle> candles;
  final List<SwingPoint> swings;
  final List<ChartZone> zones;

  MarketAsset get asset => recipe.asset;
  Timeframe get timeframe => recipe.timeframe;
  ChartPattern get pattern => recipe.pattern;
  int get length => candles.length;
  bool get isEmpty => candles.isEmpty;

  double get highestPrice => candles.isEmpty
      ? 0
      : candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);

  double get lowestPrice => candles.isEmpty
      ? 0
      : candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);

  /// Index of the highest high in the whole series.
  int get highestHighIndex {
    var best = 0;
    for (var i = 1; i < candles.length; i++) {
      if (candles[i].high > candles[best].high) best = i;
    }
    return best;
  }

  int get lowestLowIndex {
    var best = 0;
    for (var i = 1; i < candles.length; i++) {
      if (candles[i].low < candles[best].low) best = i;
    }
    return best;
  }

  List<SwingPoint> swingsWithLabel(SwingLabel label) =>
      swings.where((s) => s.label == label).toList(growable: false);

  SwingPoint? swingWithLabel(SwingLabel label, {int ordinal = 0}) {
    final matches = swingsWithLabel(label);
    if (ordinal < 0 || ordinal >= matches.length) {
      return matches.isEmpty ? null : matches.last;
    }
    return matches[ordinal];
  }

  SwingPoint? get lastSwing => swings.isEmpty ? null : swings.last;

  List<ChartZone> zonesOfKind(ZoneKind kind) =>
      zones.where((z) => z.kind == kind).toList(growable: false);

  /// A window of the series. Used by the simulator to hide future candles.
  List<Candle> window(int start, int end) {
    if (candles.isEmpty) return const [];
    final s = start.clamp(0, candles.length);
    final e = end.clamp(s, candles.length);
    return candles.sublist(s, e);
  }

  /// Realised volatility bucket, computed from average true range relative to
  /// price.
  VolatilityClass get volatilityClass {
    if (candles.length < 3) return VolatilityClass.normal;
    var sum = 0.0;
    for (var i = 1; i < candles.length; i++) {
      final c = candles[i];
      final prevClose = candles[i - 1].close;
      final tr = [
        c.high - c.low,
        (c.high - prevClose).abs(),
        (c.low - prevClose).abs(),
      ].reduce((a, b) => a > b ? a : b);
      sum += tr;
    }
    final avg = sum / (candles.length - 1);
    final reference = candles.last.close;
    if (reference <= 0) return VolatilityClass.normal;
    final ratio = avg / reference;
    if (ratio < 0.004) return VolatilityClass.calm;
    if (ratio < 0.009) return VolatilityClass.normal;
    if (ratio < 0.018) return VolatilityClass.elevated;
    return VolatilityClass.wild;
  }

  /// A short, seed-derived pseudonym used when [ChartRecipe.anonymized] is set,
  /// so learners read structure instead of recognising an instrument.
  String get anonymousName {
    const names = [
      'Series Alpha',
      'Series Bravo',
      'Series Charlie',
      'Series Delta',
      'Series Echo',
      'Series Foxtrot',
      'Series Golf',
      'Series Hotel',
      'Series India',
      'Series Juliet',
      'Series Kilo',
      'Series Lima',
    ];
    return names[SeededRandom(recipe.seed).nextInt(names.length)];
  }

  String get displayName => recipe.anonymized ? anonymousName : asset.symbol;
}
