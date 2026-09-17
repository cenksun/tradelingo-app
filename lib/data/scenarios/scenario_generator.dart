import 'dart:math' as math;

import '../../core/seeded_random.dart';
import '../../domain/models/chart_series.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/market.dart';
import '../../domain/models/scenario.dart';
import '../market/synthetic_series_generator.dart';
import 'difficulty_scorer.dart';
import 'feature_detector.dart';

/// Filters a learner can apply when requesting a scenario.
class ScenarioQuery {
  const ScenarioQuery({
    this.assetClass,
    this.assetSymbol,
    this.timeframe,
    this.difficulty,
    this.marketCondition,
    this.requiredFeatures = const {},
    this.anonymize = true,
  });

  final AssetClass? assetClass;
  final String? assetSymbol;
  final Timeframe? timeframe;
  final Difficulty? difficulty;
  final MarketCondition? marketCondition;
  final Set<ScenarioFeature> requiredFeatures;

  /// Hides the instrument name and dates so a learner reads structure rather
  /// than recognising a familiar move.
  final bool anonymize;

  bool get isUnconstrained =>
      assetClass == null &&
      assetSymbol == null &&
      timeframe == null &&
      difficulty == null &&
      marketCondition == null &&
      requiredFeatures.isEmpty;
}

/// Builds simulation scenarios procedurally.
///
/// ## Why this is an index, not a database
///
/// Every scenario is defined entirely by its ordinal. [byIndex] maps an integer
/// to a fully-specified window — instrument, timeframe, chart shape, seed,
/// visible range and decision point — and the candles are then rebuilt on
/// demand. That makes the scenario space effectively unbounded while the app
/// ships no scenario data at all, and it means scenario 91,203 is identical on
/// every device and in every test run.
class ScenarioGenerator {
  const ScenarioGenerator._();

  /// The size of the addressable scenario space in the offline build.
  ///
  /// This is a bound on the index, not a stored collection: none of these
  /// exist until asked for.
  static const int scenarioSpace = 250000;

  static const List<ChartPattern> _patterns = ChartPattern.values;

  /// Builds the scenario at [index].
  static Scenario byIndex(int index, {bool anonymize = true}) {
    final ordinal = index.abs() % scenarioSpace;
    final rnd = SeededRandom(ordinal * 2654435761 + 0x5BF03635);

    final asset = AssetCatalog.all[rnd.nextInt(AssetCatalog.all.length)];
    final timeframes = asset.availableTimeframes;
    final timeframe = timeframes[rnd.nextInt(timeframes.length)];
    final pattern = _patterns[rnd.nextInt(_patterns.length)];

    // A longer series than a lesson chart: the visible window plus a future
    // window long enough for a trade to resolve.
    final visibleCount = rnd.nextIntRange(46, 96);
    final futureCount = rnd.nextIntRange(26, 60);
    final total = visibleCount + futureCount;

    final recipe = ChartRecipe(
      seed: ordinal * 7919 + rnd.nextInt(4096),
      pattern: pattern,
      difficulty: Difficulty.values[rnd.nextInt(Difficulty.values.length)],
      assetSymbol: asset.symbol,
      timeframe: timeframe,
      anonymized: anonymize,
      candleCountOverride: total,
    );

    final series = SyntheticSeriesGenerator.build(recipe);
    final length = series.candles.length;
    // The generator may lengthen the series to fit its swing path; keep the
    // future window proportional so the decision never lands at the very end.
    final decisionIndex = math.min(
      length - 12,
      math.max(24, (length * rnd.nextRange(0.58, 0.74)).round()),
    );

    final visible = series.candles.sublist(0, decisionIndex + 1);
    final swings = FeatureDetector.detectSwings(visible);
    final features = FeatureDetector.detectFeatures(visible, swings);
    final volatility = FeatureDetector.classifyVolatility(visible);
    final condition = FeatureDetector.classifyCondition(
      swings,
      volatility,
      features,
    );
    final hardness = DifficultyScorer.score(
      candles: visible,
      swings: swings,
      features: features,
    );
    final difficulty = DifficultyScorer.bucket(hardness);

    final trend = FeatureDetector.classifyTrend(swings);
    final strong = _preferenceIsStrong(features, volatility, trend);
    final preferred = !strong
        ? TradeDirection.noTrade
        : switch (trend) {
            TrendClass.bullish => TradeDirection.long,
            TrendClass.bearish => TradeDirection.short,
            TrendClass.range => TradeDirection.noTrade,
          };

    return Scenario(
      id: 'sc-${ordinal.toString().padLeft(6, '0')}',
      recipe: recipe,
      visibleStart: 0,
      decisionIndex: decisionIndex,
      futureEnd: length,
      difficulty: difficulty,
      features: features,
      marketCondition: condition,
      volatility: volatility,
      educationallyPreferred: preferred,
      preferenceIsStrong: strong,
    );
  }

  /// Whether the window is clear enough to lean towards a direction at all.
  ///
  /// Deliberately strict: on an unclear or wild chart the framework's answer is
  /// "stand aside", and a large share of generated scenarios fall into that
  /// group on purpose.
  static bool _preferenceIsStrong(
    Set<ScenarioFeature> features,
    VolatilityClass volatility,
    TrendClass trend,
  ) {
    if (trend == TrendClass.range) return false;
    if (volatility == VolatilityClass.wild) return false;
    if (features.contains(ScenarioFeature.choppy)) return false;
    if (features.contains(ScenarioFeature.tightRange)) return false;
    final structural =
        features.contains(ScenarioFeature.bullishStructure) ||
        features.contains(ScenarioFeature.bearishStructure);
    return structural;
  }

  /// Finds the next scenario index at or after [startIndex] matching [query].
  ///
  /// Returns `null` if nothing matches within [budget] attempts, which lets the
  /// UI fall back to a relaxed query instead of hanging.
  static int? findMatching({
    required ScenarioQuery query,
    required int startIndex,
    int budget = 400,
  }) {
    if (query.isUnconstrained) return startIndex % scenarioSpace;
    for (var i = 0; i < budget; i++) {
      final index = (startIndex + i) % scenarioSpace;
      final scenario = byIndex(index, anonymize: query.anonymize);
      if (matches(scenario, query)) return index;
    }
    return null;
  }

  static bool matches(Scenario scenario, ScenarioQuery query) {
    if (query.assetSymbol != null &&
        scenario.asset.symbol != query.assetSymbol) {
      return false;
    }
    if (query.assetClass != null &&
        scenario.asset.assetClass != query.assetClass) {
      return false;
    }
    if (query.timeframe != null && scenario.timeframe != query.timeframe) {
      return false;
    }
    if (query.difficulty != null && scenario.difficulty != query.difficulty) {
      return false;
    }
    if (query.marketCondition != null &&
        scenario.marketCondition != query.marketCondition) {
      return false;
    }
    for (final f in query.requiredFeatures) {
      if (!scenario.features.contains(f)) return false;
    }
    return true;
  }

  /// Materialises a scenario's candles, split into visible and future.
  static ScenarioBundle load(Scenario scenario) {
    final series = SyntheticSeriesGenerator.build(scenario.recipe);
    final length = series.candles.length;
    final decision = scenario.decisionIndex.clamp(1, length - 2);

    final visible = series.candles.sublist(0, decision + 1);
    final future = series.candles.sublist(decision + 1, length);

    return ScenarioBundle(
      scenario: scenario,
      visibleCandles: List.unmodifiable(visible),
      futureCandles: List.unmodifiable(future),
      visibleSwings: List.unmodifiable(
        series.swings.where((s) => s.index <= decision).toList(),
      ),
      visibleZones: List.unmodifiable(
        series.zones.where((z) => z.startIndex <= decision).toList(),
      ),
    );
  }

  /// A deterministic scenario index for a given day, used by the daily
  /// challenge so every device generates the same one.
  static int indexForSeed(int seed) => seed.abs() % scenarioSpace;
}
