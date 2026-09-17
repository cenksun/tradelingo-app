import 'package:meta/meta.dart';

import 'chart_series.dart';
import 'enums.dart';
import 'market.dart';

/// Educational classifications a scenario window can carry.
///
/// These describe structure that is already present in the visible candles.
/// None of them is a prediction, and the app never presents them as one.
enum ScenarioFeature {
  bullishStructure('Bullish structure'),
  bearishStructure('Bearish structure'),
  rangeBound('Range bound'),
  higherHigh('Higher high'),
  higherLow('Higher low'),
  lowerHigh('Lower high'),
  lowerLow('Lower low'),
  pullback('Pullback'),
  breakout('Breakout'),
  falseBreakout('Failed breakout'),
  supportTest('Support test'),
  resistanceTest('Resistance test'),
  liquiditySweep('Liquidity sweep'),
  equalHighs('Equal highs'),
  equalLows('Equal lows'),
  breakOfStructure('Break of structure'),
  changeOfCharacter('Change of character'),
  fairValueGap('Fair value gap'),
  orderBlock('Order block'),
  displacement('Displacement'),
  tightRange('Tight range'),
  choppy('Choppy');

  const ScenarioFeature(this.label);
  final String label;

  static ScenarioFeature? fromName(String name) {
    for (final f in ScenarioFeature.values) {
      if (f.name == name) return f;
    }
    return null;
  }
}

/// Broad condition of the visible window, used for filtering.
enum MarketCondition {
  trendingUp('Trending up'),
  trendingDown('Trending down'),
  ranging('Ranging'),
  volatile('Volatile'),
  transitioning('Transitioning');

  const MarketCondition(this.label);
  final String label;

  static MarketCondition fromName(String? name) => MarketCondition.values
      .firstWhere((c) => c.name == name, orElse: () => MarketCondition.ranging);
}

/// A simulation window: which chart, how much of it is visible, and where the
/// decision is made.
///
/// A scenario is *compact by design*. It stores a seed and a few indices rather
/// than candle arrays, which is what allows hundreds of thousands of distinct
/// scenarios to exist without any of them being stored.
@immutable
class Scenario {
  const Scenario({
    required this.id,
    required this.recipe,
    required this.visibleStart,
    required this.decisionIndex,
    required this.futureEnd,
    required this.difficulty,
    required this.features,
    required this.marketCondition,
    required this.volatility,
    this.educationallyPreferred = TradeDirection.noTrade,
    this.preferenceIsStrong = false,
  });

  final String id;
  final ChartRecipe recipe;

  /// First candle index shown to the learner.
  final int visibleStart;

  /// Last visible candle index. Everything after this is hidden until replay.
  final int decisionIndex;

  /// Exclusive end of the future window used for the replay.
  final int futureEnd;

  final Difficulty difficulty;
  final Set<ScenarioFeature> features;
  final MarketCondition marketCondition;
  final VolatilityClass volatility;

  /// The direction the teaching framework leans towards, used only for
  /// feedback — never presented as the correct answer to a market question.
  final TradeDirection educationallyPreferred;

  /// True when the structure is clear enough for the preference to be worth
  /// stating firmly. When false, feedback stays explicitly non-committal.
  final bool preferenceIsStrong;

  MarketAsset get asset => recipe.asset;
  Timeframe get timeframe => recipe.timeframe;
  int get visibleCount => decisionIndex - visibleStart + 1;
  int get futureCount => futureEnd - decisionIndex - 1;

  bool hasFeature(ScenarioFeature f) => features.contains(f);

  String get featureSummary => features.isEmpty
      ? 'No standout structure'
      : features.map((f) => f.label).join(' · ');
}

/// A scenario with its candles materialised, split so that future candles are
/// never handed to the UI by accident.
@immutable
class ScenarioBundle {
  const ScenarioBundle({
    required this.scenario,
    required this.visibleCandles,
    required this.futureCandles,
    required this.visibleSwings,
    required this.visibleZones,
  });

  final Scenario scenario;

  /// Candles up to and including the decision point.
  final List<Candle> visibleCandles;

  /// Candles after the decision point. Only the simulation session reveals
  /// these, one at a time, and only after a decision has been committed.
  final List<Candle> futureCandles;

  final List<SwingPoint> visibleSwings;
  final List<ChartZone> visibleZones;

  /// The price a market entry would be filled at, at the decision point.
  double get decisionPrice =>
      visibleCandles.isEmpty ? 0 : visibleCandles.last.close;

  bool get isUsable => visibleCandles.length >= 10 && futureCandles.isNotEmpty;
}
