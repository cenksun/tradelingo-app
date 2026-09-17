import '../../core/seeded_random.dart';
import '../../domain/models/activity.dart';
import '../../domain/models/chart_series.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/market.dart';
import '../market/synthetic_series_generator.dart';
import 'lesson_spec.dart';

/// Turns a [ChartTaskSpec] into a finished [Activity].
///
/// This is the content generation system: one template plus one chart shape
/// plus a seed yields a complete exercise — prompt, chart, correct answer,
/// plausible alternatives and specific feedback. A single template therefore
/// produces a different exercise for every seed, which is how the curriculum
/// stays varied without hand-writing every question.
class ChartActivityFactory {
  const ChartActivityFactory._();

  /// Instruments used for chart exercises. Rotating them keeps learners
  /// reading structure rather than memorising one instrument's look.
  static const List<String> _exerciseAssets = [
    'BTC/USDT',
    'ETH/USDT',
    'SOL/USDT',
    'EUR/USD',
    'XAU/USD',
    'MNQ',
    'AAPL',
  ];

  static const List<Timeframe> _exerciseTimeframes = [
    Timeframe.m15,
    Timeframe.h1,
    Timeframe.h4,
    Timeframe.d1,
  ];

  static ChartRecipe recipeFor(
    ChartTaskSpec spec,
    Difficulty lessonDifficulty,
  ) {
    final rnd = SeededRandom(spec.seed ^ 0x5F3A21);
    return ChartRecipe(
      seed: spec.seed,
      pattern: spec.pattern,
      difficulty: spec.difficulty ?? lessonDifficulty,
      assetSymbol: _exerciseAssets[rnd.nextInt(_exerciseAssets.length)],
      timeframe: _exerciseTimeframes[rnd.nextInt(_exerciseTimeframes.length)],
      anonymized: spec.anonymized,
    );
  }

  static Activity build({
    required String id,
    required ChartTaskSpec spec,
    required List<String> skillIds,
    required Difficulty lessonDifficulty,
  }) {
    final recipe = recipeFor(spec, lessonDifficulty);
    final difficulty = recipe.difficulty;
    final note = spec.note == null ? '' : ' ${spec.note}';

    switch (spec.task) {
      case ChartTask.tapHighestHigh:
        return TapCandleActivity(
          id: id,
          prompt: 'Tap the candle that made the highest high in this window.',
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          target: const ExtremeCandleTarget(ExtremeKind.highestHigh),
          conceptTag: 'read_extremes',
          hint: 'The highest high is the top of the tallest wick, not the tallest body.',
          explanation:
              'The highest high is the single highest price traded in the window — the top of '
              'the highest wick. Bodies show where the candle opened and closed; wicks show how '
              'far price actually went.$note',
        );
      case ChartTask.tapLowestLow:
        return TapCandleActivity(
          id: id,
          prompt: 'Tap the candle that made the lowest low in this window.',
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          target: const ExtremeCandleTarget(ExtremeKind.lowestLow),
          conceptTag: 'read_extremes',
          hint:
              'Look at the bottom of the wicks, not the bottom of the bodies.',
          explanation:
              'The lowest low is the lowest price traded in the window — the bottom of the '
              'lowest wick.$note',
        );
      case ChartTask.tapLargestBody:
        return TapCandleActivity(
          id: id,
          prompt: 'Tap the candle with the largest body.',
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          target: const ExtremeCandleTarget(ExtremeKind.largestBody),
          conceptTag: 'candle_anatomy',
          hint: 'The body is the distance between the open and the close.',
          explanation:
              'The body is the distance between open and close. A large body means price '
              'finished the period far from where it started.$note',
        );
      case ChartTask.tapWidestRange:
        return TapCandleActivity(
          id: id,
          prompt: 'Tap the candle with the widest high-to-low range.',
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          target: const ExtremeCandleTarget(ExtremeKind.largestRange),
          conceptTag: 'candle_anatomy',
          hint: 'Range is measured wick-tip to wick-tip, so a small body can still be wide.',
          explanation:
              'Range is the full distance from low to high, wicks included. A candle can have a '
              'small body and still cover a lot of ground.$note',
        );
      case ChartTask.tapSwingHigh:
        return TapCandleActivity(
          id: id,
          prompt: 'Tap the most recent swing high.',
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          target: const SwingCandleTarget(SwingLabel.higherHigh, ordinal: -1),
          tolerance: 1,
          conceptTag: 'swing_high',
          hint: 'A swing high is a turning point with lower highs on both sides of it.',
          explanation:
              'A swing high is a candle whose high stands above the candles either side of it — '
              'a turning point where buying stopped pushing price up.$note',
        );
      case ChartTask.tapSwingLow:
        return TapCandleActivity(
          id: id,
          prompt: 'Tap the most recent swing low.',
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          target: const SwingCandleTarget(SwingLabel.higherLow, ordinal: -1),
          tolerance: 1,
          conceptTag: 'swing_low',
          hint: 'A swing low is a turning point with higher lows on both sides of it.',
          explanation:
              'A swing low is a candle whose low sits below the candles either side of it — a '
              'turning point where selling stopped pushing price down.$note',
        );
      case ChartTask.tapOpen:
      case ChartTask.tapHigh:
      case ChartTask.tapLow:
      case ChartTask.tapClose:
        final part = switch (spec.task) {
          ChartTask.tapOpen => PricePart.open,
          ChartTask.tapHigh => PricePart.high,
          ChartTask.tapLow => PricePart.low,
          _ => PricePart.close,
        };
        final target = _pricePointTarget(spec.seed);
        return TapPricePointActivity(
          id: id,
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          candleTarget: target,
          part: part,
          prompt:
              'Tap the ${part.label.toUpperCase()} of ${target.describe()}.',
          conceptTag: 'ohlc_${part.name}',
          hint: _pricePartHint(part),
          explanation: _pricePartExplanation(part) + note,
        );
      case ChartTask.identifyHigherHigh:
        return _structureActivity(
          id,
          recipe,
          skillIds,
          difficulty,
          SwingLabel.higherHigh,
          note,
        );
      case ChartTask.identifyHigherLow:
        return _structureActivity(
          id,
          recipe,
          skillIds,
          difficulty,
          SwingLabel.higherLow,
          note,
        );
      case ChartTask.identifyLowerHigh:
        return _structureActivity(
          id,
          recipe,
          skillIds,
          difficulty,
          SwingLabel.lowerHigh,
          note,
        );
      case ChartTask.identifyLowerLow:
        return _structureActivity(
          id,
          recipe,
          skillIds,
          difficulty,
          SwingLabel.lowerLow,
          note,
        );
      case ChartTask.labelStructure:
        final series = SyntheticSeriesGenerator.build(recipe);
        final orders = series.swings
            .where((s) => SwingLabel.structureSet.contains(s.label))
            .map((s) => s.order)
            .take(4)
            .toList(growable: false);
        return LabelStructureActivity(
          id: id,
          prompt: 'Label each marked swing point.',
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          swingOrders: orders,
          conceptTag: 'label_structure',
          hint: 'Compare each high with the previous high, and each low with the previous low.',
          explanation:
              'Every label is a comparison with the previous swing of the same type. A high '
              'above the last high is a Higher High; a low above the last low is a Higher Low, '
              'and so on.$note',
        );
      case ChartTask.classifyTrend:
        return TrendClassificationActivity(
          id: id,
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          correct: spec.pattern.trendClass,
          conceptTag: 'trend_classification',
          hint: 'Read the sequence of swings, not the last candle.',
          explanation: _trendExplanation(spec.pattern) + note,
        );
      case ChartTask.decideDirection:
        final preferred = spec.preferred ?? _defaultDirection(spec.pattern);
        return DirectionDecisionActivity(
          id: id,
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          preferred: preferred,
          acceptable: spec.acceptable,
          conceptTag: 'direction_decision',
          hint: 'If the structure is unclear, standing aside is a real answer.',
          explanation: _directionExplanation(spec.pattern, preferred) + note,
        );
      case ChartTask.placeStopLong:
      case ChartTask.placeStopShort:
        final dir = spec.task == ChartTask.placeStopLong
            ? TradeDirection.long
            : TradeDirection.short;
        return DragStopLossActivity(
          id: id,
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          direction: dir,
          conceptTag: 'stop_placement',
          hint: dir == TradeDirection.long
              ? 'Ask where price would have to trade for the bullish idea to be wrong.'
              : 'Ask where price would have to trade for the bearish idea to be wrong.',
          explanation:
              'A stop marks the price at which the reason for the trade no longer holds. '
              'Placing it just beyond the swing that defines the idea keeps ordinary noise out '
              'while still capping the loss.$note',
        );
      case ChartTask.placeTargetLong:
      case ChartTask.placeTargetShort:
        final dir = spec.task == ChartTask.placeTargetLong
            ? TradeDirection.long
            : TradeDirection.short;
        return DragTakeProfitActivity(
          id: id,
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          direction: dir,
          conceptTag: 'target_placement',
          hint: 'Aim at structure that is already on the chart.',
          explanation:
              'A target needs two things: somewhere plausible for price to reach, and enough '
              'distance to be worth the risk being taken.$note',
        );
      case ChartTask.buildTradeLong:
      case ChartTask.buildTradeShort:
        final dir = spec.task == ChartTask.buildTradeLong
            ? TradeDirection.long
            : TradeDirection.short;
        return BuildTradeActivity(
          id: id,
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          direction: dir,
          conceptTag: 'trade_construction',
          hint: 'Set the stop first — it defines the risk everything else is measured against.',
          explanation:
              'A complete idea has all three levels: where you get in, where the idea is proven '
              'wrong, and where you are finished. The stop comes first because it sets the unit '
              'of risk.$note',
        );
      case ChartTask.selectSupport:
      case ChartTask.selectResistance:
      case ChartTask.selectRangeHigh:
      case ChartTask.selectRangeLow:
      case ChartTask.selectFairValueGapUp:
      case ChartTask.selectFairValueGapDown:
      case ChartTask.selectOrderBlockUp:
      case ChartTask.selectLiquidityAbove:
      case ChartTask.selectLiquidityBelow:
        final kind = switch (spec.task) {
          ChartTask.selectSupport => ZoneKind.support,
          ChartTask.selectResistance => ZoneKind.resistance,
          ChartTask.selectRangeHigh => ZoneKind.rangeHigh,
          ChartTask.selectRangeLow => ZoneKind.rangeLow,
          ChartTask.selectFairValueGapUp => ZoneKind.fairValueGapUp,
          ChartTask.selectFairValueGapDown => ZoneKind.fairValueGapDown,
          ChartTask.selectOrderBlockUp => ZoneKind.orderBlockBullish,
          ChartTask.selectLiquidityAbove => ZoneKind.liquidityAbove,
          _ => ZoneKind.liquidityBelow,
        };
        return ZoneSelectionActivity(
          id: id,
          prompt:
              'Drag the selector to the ${kind.label.toLowerCase()} on this chart.',
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          zoneKind: kind,
          conceptTag: kind.name,
          hint: _zoneHint(kind),
          explanation: _zoneExplanation(kind) + note,
        );
      case ChartTask.miniSimulation:
        final preferred = spec.preferred ?? _defaultDirection(spec.pattern);
        final visible = (recipe.candleCount * 0.62).round();
        return MiniSimulationActivity(
          id: id,
          skillIds: skillIds,
          difficulty: difficulty,
          chartRecipe: recipe,
          visibleCandles: visible,
          preferred: preferred,
          acceptable: spec.acceptable,
          conceptTag: 'mini_simulation',
          hint: 'Decide from what is on screen. The rest of the chart stays hidden until you do.',
          explanation:
              'Decisions get made with part of the picture. What matters is whether the reasoning '
              'was sound at the time, not whether this particular replay went your way.$note',
        );
    }
  }

  static Activity _structureActivity(
    String id,
    ChartRecipe recipe,
    List<String> skillIds,
    Difficulty difficulty,
    SwingLabel label,
    String note,
  ) {
    return IdentifyStructureActivity(
      id: id,
      prompt: 'Tap the ${label.short} (${_labelWords(label)}) on this chart.',
      skillIds: skillIds,
      difficulty: difficulty,
      chartRecipe: recipe,
      targetLabel: label,
      conceptTag: label.name,
      hint: label.isHigh
          ? 'Compare this swing high with the swing high before it.'
          : 'Compare this swing low with the swing low before it.',
      explanation:
          '${label.description} Labels always come from a comparison with the previous swing of '
          'the same kind, never from where the point sits on the screen.$note',
    );
  }

  static String _labelWords(SwingLabel label) => switch (label) {
    SwingLabel.higherHigh => 'higher high',
    SwingLabel.higherLow => 'higher low',
    SwingLabel.lowerHigh => 'lower high',
    SwingLabel.lowerLow => 'lower low',
    SwingLabel.equalHigh => 'equal high',
    SwingLabel.equalLow => 'equal low',
    SwingLabel.first => 'first swing',
  };

  static CandleTarget _pricePointTarget(int seed) {
    final rnd = SeededRandom(seed ^ 0x77AA11);
    return switch (rnd.nextInt(4)) {
      0 => const ExtremeCandleTarget(ExtremeKind.highestHigh),
      1 => const ExtremeCandleTarget(ExtremeKind.lowestLow),
      2 => const ExtremeCandleTarget(ExtremeKind.largestBody),
      _ => const ExtremeCandleTarget(ExtremeKind.largestRange),
    };
  }

  static String _pricePartHint(PricePart part) => switch (part) {
    PricePart.open =>
      'The open is where the candle started, on its left-hand edge.',
    PricePart.high => 'The high is the very top of the upper wick.',
    PricePart.low => 'The low is the very bottom of the lower wick.',
    PricePart.close =>
      'The close is where the candle finished, on its right-hand edge.',
  };

  static String _pricePartExplanation(PricePart part) => switch (part) {
    PricePart.open =>
      'The open is the first traded price of the period. On a rising candle it is the bottom '
          'of the body; on a falling candle it is the top of the body.',
    PricePart.high =>
      'The high is the highest price traded during the period — the tip of the upper wick, '
          'not the top of the body.',
    PricePart.low =>
      'The low is the lowest price traded during the period — the tip of the lower wick, '
          'not the bottom of the body.',
    PricePart.close =>
      'The close is the last traded price of the period. It is the single most watched of the '
          'four values because it shows who finished the period in control.',
  };

  static String _trendExplanation(
    ChartPattern pattern,
  ) => switch (pattern.trendClass) {
    TrendClass.bullish =>
      'The swing highs and swing lows are both stepping upwards, which the lesson framework '
          'calls bullish structure. It describes what price has done, not what it will do next.',
    TrendClass.bearish =>
      'The swing highs and swing lows are both stepping downwards, which the lesson framework '
          'calls bearish structure. It describes what price has done, not what it will do next.',
    TrendClass.range =>
      'Highs and lows are not making consistent progress in either direction, so this reads as '
          'a range. Ranges are common and are not a failure to find a trend.',
  };

  static TradeDirection _defaultDirection(ChartPattern pattern) =>
      switch (pattern.trendClass) {
        TrendClass.bullish => TradeDirection.long,
        TrendClass.bearish => TradeDirection.short,
        TrendClass.range => TradeDirection.noTrade,
      };

  static String _directionExplanation(
    ChartPattern pattern,
    TradeDirection preferred,
  ) {
    if (preferred == TradeDirection.noTrade) {
      return 'Nothing here gives a clear invalidation level or a sensible place to aim for. '
          'Standing aside is a decision, and on charts like this one it is usually the better '
          'one.';
    }
    final side = preferred == TradeDirection.long ? 'bullish' : 'bearish';
    return 'The structure reads as $side within the framework this lesson uses, so a '
        '${preferred.label.toLowerCase()} is the idea that follows from it. That is a reading of '
        'the chart, not a forecast — plenty of charts that look like this go the other way.';
  }

  static String _zoneHint(ZoneKind kind) => switch (kind) {
    ZoneKind.support =>
      'Look for the area price has turned up from more than once.',
    ZoneKind.resistance =>
      'Look for the area price has turned down from more than once.',
    ZoneKind.rangeHigh => 'The upper boundary of the sideways area.',
    ZoneKind.rangeLow => 'The lower boundary of the sideways area.',
    ZoneKind.fairValueGapUp || ZoneKind.fairValueGapDown =>
      'Look for three candles where the first and third do not overlap.',
    ZoneKind.orderBlockBullish || ZoneKind.orderBlockBearish =>
      'Look just before the strongest move on the chart.',
    ZoneKind.liquidityAbove =>
      'Look for two or more highs that finish at almost the same price.',
    ZoneKind.liquidityBelow =>
      'Look for two or more lows that finish at almost the same price.',
    _ => 'Look for the area the lesson described.',
  };

  static String _zoneExplanation(ZoneKind kind) => switch (kind) {
    ZoneKind.support =>
      'Support is an area where buying has previously been strong enough to turn price up. It is '
          'an area rather than a line, and it holds until it does not.',
    ZoneKind.resistance =>
      'Resistance is an area where selling has previously been strong enough to turn price down. '
          'It is an area rather than a line, and it holds until it does not.',
    ZoneKind.rangeHigh => 'The range high is the upper boundary price has repeatedly failed to hold above.',
    ZoneKind.rangeLow => 'The range low is the lower boundary price has repeatedly failed to hold below.',
    ZoneKind.fairValueGapUp || ZoneKind.fairValueGapDown =>
      'Three candles where the first and third do not overlap mark an area price passed through '
          'in one direction. Some frameworks watch these areas on a return; that is a convention, '
          'not a rule the market has to follow.',
    ZoneKind.orderBlockBullish || ZoneKind.orderBlockBearish =>
      'The last opposite-direction candle before a strong move marks where the move began. Some '
          'frameworks watch this area on a return; it is a way of organising a chart, not a '
          'guarantee of a reaction.',
    ZoneKind.liquidityAbove =>
      'When several highs finish at almost the same price, protective orders from short '
          'positions and breakout orders both tend to sit just above them. That concentration is '
          'why price often reacts sharply there — it is an observation about order placement, '
          'not a prediction.',
    ZoneKind.liquidityBelow =>
      'When several lows finish at almost the same price, protective orders from long positions '
          'and breakout orders both tend to sit just below them. That concentration is why price '
          'often reacts sharply there — it is an observation about order placement, not a '
          'prediction.',
    _ => 'This is the area the lesson described.',
  };
}
