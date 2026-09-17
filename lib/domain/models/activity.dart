import 'dart:math' as math;

import 'package:meta/meta.dart';

import '../../core/formatters.dart';
import 'chart_series.dart';
import 'enums.dart';

/// The activity types the lesson engine can render.
///
/// The engine is open: adding a type means adding a value here, a subclass of
/// [Activity] and one renderer. Nothing else in the app needs to change.
enum ActivityKind {
  explanation('Concept'),
  multipleChoice('Multiple choice'),
  trueFalse('True or false'),
  tapCandle('Tap the candle'),
  tapPricePoint('Tap the price point'),
  identifyStructure('Identify structure'),
  labelStructure('Label the structure'),
  trendClassification('Classify the trend'),
  directionDecision('Long, short or no trade'),
  dragStopLoss('Place the stop'),
  dragTakeProfit('Place the target'),
  buildTrade('Build the trade'),
  riskCalculation('Risk calculation'),
  riskReward('Reward-to-risk'),
  orderType('Choose the order type'),
  sequenceOrdering('Put it in order'),
  spotMistake('Spot the mistake'),
  matching('Match the terms'),
  zoneSelection('Select the zone'),
  miniSimulation('Mini simulation');

  const ActivityKind(this.label);
  final String label;

  /// Chart-backed activities need a [GeneratedSeries] to be evaluated.
  bool get usesChart => const {
    ActivityKind.tapCandle,
    ActivityKind.tapPricePoint,
    ActivityKind.identifyStructure,
    ActivityKind.labelStructure,
    ActivityKind.trendClassification,
    ActivityKind.directionDecision,
    ActivityKind.dragStopLoss,
    ActivityKind.dragTakeProfit,
    ActivityKind.buildTrade,
    ActivityKind.zoneSelection,
    ActivityKind.miniSimulation,
  }.contains(this);
}

/// The outcome of grading one answer.
@immutable
class ActivityEvaluation {
  const ActivityEvaluation({
    required this.correct,
    required this.feedback,
    this.mistakes = const [],
    this.partialCredit = 0,
  });

  const ActivityEvaluation.right(this.feedback)
    : correct = true,
      mistakes = const [],
      partialCredit = 1;

  final bool correct;

  /// Always explains *why*, never just "wrong".
  final String feedback;
  final List<MistakeTag> mistakes;

  /// 0..1 — used by activities that can be partly right (labelling, matching).
  final double partialCredit;
}

/// Base type for a learner's answer.
@immutable
sealed class ActivityResponse {
  const ActivityResponse();
}

class AcknowledgeResponse extends ActivityResponse {
  const AcknowledgeResponse();
}

class ChoiceResponse extends ActivityResponse {
  const ChoiceResponse(this.index);
  final int index;
}

class BoolResponse extends ActivityResponse {
  const BoolResponse(this.value);
  final bool value;
}

class CandleIndexResponse extends ActivityResponse {
  const CandleIndexResponse(this.index);
  final int index;
}

class PricePointResponse extends ActivityResponse {
  const PricePointResponse(this.candleIndex, this.part);
  final int candleIndex;
  final PricePart part;
}

class PriceLevelResponse extends ActivityResponse {
  const PriceLevelResponse(this.price);
  final double price;
}

class TradeSetupResponse extends ActivityResponse {
  const TradeSetupResponse({
    required this.entry,
    required this.stopLoss,
    required this.takeProfit,
  });
  final double entry;
  final double stopLoss;
  final double takeProfit;
}

class NumericResponse extends ActivityResponse {
  const NumericResponse(this.value);
  final double value;
}

class SequenceResponse extends ActivityResponse {
  const SequenceResponse(this.order);

  /// The original item indices, in the order the learner arranged them.
  final List<int> order;
}

class MatchResponse extends ActivityResponse {
  const MatchResponse(this.pairs);

  /// term index -> definition index
  final Map<int, int> pairs;
}

class LabelSetResponse extends ActivityResponse {
  const LabelSetResponse(this.labels);

  /// swing order -> chosen label
  final Map<int, SwingLabel> labels;
}

class DirectionResponse extends ActivityResponse {
  const DirectionResponse(this.direction);
  final TradeDirection direction;
}

class TrendResponse extends ActivityResponse {
  const TrendResponse(this.trend);
  final TrendClass trend;
}

class OrderTypeResponse extends ActivityResponse {
  const OrderTypeResponse(this.type);
  final OrderType type;
}

class ZoneResponse extends ActivityResponse {
  const ZoneResponse(this.price);

  /// The price the learner selected on the chart.
  final double price;
}

/// How an exercise identifies a particular candle.
@immutable
sealed class CandleTarget {
  const CandleTarget();

  /// Resolves to a candle index, or `null` when the series cannot satisfy it.
  int? resolve(GeneratedSeries series);

  /// A human description used in feedback.
  String describe();
}

class SwingCandleTarget extends CandleTarget {
  const SwingCandleTarget(this.label, {this.ordinal = 0});
  final SwingLabel label;

  /// Which occurrence; negative counts from the end.
  final int ordinal;

  @override
  int? resolve(GeneratedSeries series) {
    final matches = series.swingsWithLabel(label);
    if (matches.isEmpty) return null;
    final i = ordinal < 0 ? matches.length + ordinal : ordinal;
    if (i < 0 || i >= matches.length) return matches.last.index;
    return matches[i].index;
  }

  @override
  String describe() => label.description;
}

enum ExtremeKind { highestHigh, lowestLow, largestBody, largestRange }

class ExtremeCandleTarget extends CandleTarget {
  const ExtremeCandleTarget(this.kind);
  final ExtremeKind kind;

  @override
  int? resolve(GeneratedSeries series) {
    if (series.candles.isEmpty) return null;
    var best = 0;
    for (var i = 1; i < series.candles.length; i++) {
      final c = series.candles[i];
      final b = series.candles[best];
      final better = switch (kind) {
        ExtremeKind.highestHigh => c.high > b.high,
        ExtremeKind.lowestLow => c.low < b.low,
        ExtremeKind.largestBody => c.body > b.body,
        ExtremeKind.largestRange => c.range > b.range,
      };
      if (better) best = i;
    }
    return best;
  }

  @override
  String describe() => switch (kind) {
    ExtremeKind.highestHigh => 'the highest high in the visible window',
    ExtremeKind.lowestLow => 'the lowest low in the visible window',
    ExtremeKind.largestBody => 'the candle with the largest body',
    ExtremeKind.largestRange => 'the candle with the largest high-to-low range',
  };
}

class IndexCandleTarget extends CandleTarget {
  const IndexCandleTarget(this.index);
  final int index;

  @override
  int? resolve(GeneratedSeries series) =>
      series.candles.isEmpty ? null : index.clamp(0, series.candles.length - 1);

  @override
  String describe() => 'candle $index';
}

/// Base class for everything the lesson player can render.
@immutable
sealed class Activity {
  const Activity({
    required this.id,
    required this.prompt,
    required this.skillIds,
    required this.explanation,
    this.difficulty = Difficulty.beginner,
    this.hint,
    this.conceptTag,
  });

  final String id;
  final String prompt;
  final List<String> skillIds;

  /// Shown after answering, whether right or wrong.
  final String explanation;
  final Difficulty difficulty;
  final String? hint;

  /// Key used by spaced repetition to track a specific idea, e.g.
  /// `lower_high`. Defaults to the first skill when omitted.
  final String? conceptTag;

  ActivityKind get kind;

  /// The prompt the UI shows. Types whose wording depends on their own
  /// configuration override this; everything else uses [prompt] directly.
  String get displayPrompt => prompt;

  /// Whether a wrong answer should cost a heart and affect mastery.
  bool get isGraded => true;

  /// The chart this activity is drawn on, if any.
  ChartRecipe? get recipe => null;

  String get concept =>
      conceptTag ?? (skillIds.isEmpty ? 'general' : skillIds.first);

  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  });

  ActivityEvaluation _unanswerable() => const ActivityEvaluation(
    correct: false,
    feedback: 'That answer could not be read. Please try the exercise again.',
  );
}

// ---------------------------------------------------------------------------
// 1. Explanation
// ---------------------------------------------------------------------------

class ExplanationActivity extends Activity {
  const ExplanationActivity({
    required super.id,
    required super.skillIds,
    required this.title,
    required this.body,
    this.bullets = const [],
    this.chartRecipe,
    super.difficulty,
    super.conceptTag,
  }) : super(prompt: title, explanation: body);

  final String title;
  final String body;
  final List<String> bullets;
  final ChartRecipe? chartRecipe;

  @override
  ActivityKind get kind => ActivityKind.explanation;

  @override
  bool get isGraded => false;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) => const ActivityEvaluation.right('');
}

// ---------------------------------------------------------------------------
// 2. Multiple choice
// ---------------------------------------------------------------------------

class MultipleChoiceActivity extends Activity {
  const MultipleChoiceActivity({
    required super.id,
    required super.prompt,
    required super.skillIds,
    required super.explanation,
    required this.options,
    required this.correctIndex,
    this.optionFeedback = const {},
    this.chartRecipe,
    this.mistakeOnWrong,
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final List<String> options;
  final int correctIndex;

  /// Optional per-option explanation, so a wrong answer is addressed directly.
  final Map<int, String> optionFeedback;
  final ChartRecipe? chartRecipe;
  final MistakeTag? mistakeOnWrong;

  @override
  ActivityKind get kind => ActivityKind.multipleChoice;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! ChoiceResponse) return _unanswerable();
    if (response.index == correctIndex) {
      return ActivityEvaluation.right(explanation);
    }
    final specific = optionFeedback[response.index];
    return ActivityEvaluation(
      correct: false,
      feedback: specific == null
          ? 'Not quite. The answer is "${options[correctIndex.clamp(0, options.length - 1)]}". $explanation'
          : '$specific\n\n$explanation',
      mistakes: mistakeOnWrong == null ? const [] : [mistakeOnWrong!],
    );
  }
}

// ---------------------------------------------------------------------------
// 3. True / false
// ---------------------------------------------------------------------------

class TrueFalseActivity extends Activity {
  const TrueFalseActivity({
    required super.id,
    required this.statement,
    required this.answer,
    required super.skillIds,
    required super.explanation,
    super.difficulty,
    super.hint,
    super.conceptTag,
  }) : super(prompt: statement);

  final String statement;
  final bool answer;

  @override
  ActivityKind get kind => ActivityKind.trueFalse;

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! BoolResponse) return _unanswerable();
    if (response.value == answer) return ActivityEvaluation.right(explanation);
    return ActivityEvaluation(
      correct: false,
      feedback:
          'That statement is actually ${answer ? 'true' : 'false'}. $explanation',
    );
  }
}

// ---------------------------------------------------------------------------
// 4 & 5. Tap the candle / tap the price point
// ---------------------------------------------------------------------------

class TapCandleActivity extends Activity {
  const TapCandleActivity({
    required super.id,
    required super.prompt,
    required super.skillIds,
    required super.explanation,
    required this.chartRecipe,
    required this.target,
    this.tolerance = 0,
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final ChartRecipe chartRecipe;
  final CandleTarget target;

  /// How many candles either side still count as correct.
  final int tolerance;

  @override
  ActivityKind get kind => ActivityKind.tapCandle;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! CandleIndexResponse || series == null) {
      return _unanswerable();
    }
    final answer = target.resolve(series);
    if (answer == null) {
      return const ActivityEvaluation(
        correct: false,
        feedback: 'This chart could not be read. Skip ahead and try another exercise.',
      );
    }
    final distance = (response.index - answer).abs();
    if (distance <= tolerance) return ActivityEvaluation.right(explanation);
    return ActivityEvaluation(
      correct: false,
      feedback:
          'Not that one. You picked candle ${response.index + 1}; the exercise was looking for '
          'candle ${answer + 1} — ${target.describe()} $explanation',
    );
  }
}

class TapPricePointActivity extends Activity {
  const TapPricePointActivity({
    required super.id,
    required super.skillIds,
    required super.explanation,
    required this.chartRecipe,
    required this.candleTarget,
    required this.part,
    super.prompt = '',
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final ChartRecipe chartRecipe;
  final CandleTarget candleTarget;
  final PricePart part;

  @override
  ActivityKind get kind => ActivityKind.tapPricePoint;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  String get displayPrompt => prompt.isNotEmpty
      ? prompt
      : 'Tap the ${part.label.toUpperCase()} of the highlighted candle.';

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! PricePointResponse || series == null) {
      return _unanswerable();
    }
    final index = candleTarget.resolve(series);
    if (index == null) return _unanswerable();
    if (response.candleIndex != index) {
      return ActivityEvaluation(
        correct: false,
        feedback:
            'That is a different candle. The exercise asked about ${candleTarget.describe()}. '
            '$explanation',
      );
    }
    if (response.part == part) return ActivityEvaluation.right(explanation);
    final candle = series.candles[index];
    final chosen = switch (response.part) {
      PricePart.open => candle.open,
      PricePart.high => candle.high,
      PricePart.low => candle.low,
      PricePart.close => candle.close,
    };
    return ActivityEvaluation(
      correct: false,
      feedback:
          'You tapped the ${response.part.label.toLowerCase()} (${Fmt.price(chosen)}). '
          'The ${part.label.toLowerCase()} is the point this exercise asked for. $explanation',
    );
  }
}

// ---------------------------------------------------------------------------
// 6 & 7. Market structure
// ---------------------------------------------------------------------------

class IdentifyStructureActivity extends Activity {
  const IdentifyStructureActivity({
    required super.id,
    required super.prompt,
    required super.skillIds,
    required super.explanation,
    required this.chartRecipe,
    required this.targetLabel,
    this.ordinal = -1,
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final ChartRecipe chartRecipe;
  final SwingLabel targetLabel;
  final int ordinal;

  @override
  ActivityKind get kind => ActivityKind.identifyStructure;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  String get concept => conceptTag ?? targetLabel.name;

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! CandleIndexResponse || series == null) {
      return _unanswerable();
    }
    final matches = series.swingsWithLabel(targetLabel);
    if (matches.isEmpty) {
      return const ActivityEvaluation(
        correct: false,
        feedback: 'This chart does not contain that structure point.',
      );
    }
    final i = ordinal < 0 ? matches.length + ordinal : ordinal;
    final target = (i >= 0 && i < matches.length) ? matches[i] : matches.last;
    if (response.index == target.index) {
      return ActivityEvaluation.right(explanation);
    }

    // Explain what the learner actually picked, rather than just saying no.
    final picked = series.swings
        .where((s) => s.index == response.index)
        .toList(growable: false);
    if (picked.isEmpty) {
      return ActivityEvaluation(
        correct: false,
        feedback:
            'That candle is not one of the swing points in this sequence. '
            'A swing point is a turning point with lower highs either side of it (for a high), '
            'or higher lows either side (for a low). $explanation',
        mistakes: const [MistakeTag.structureMisread],
      );
    }
    final p = picked.first;
    return ActivityEvaluation(
      correct: false,
      feedback:
          'Close. That point is a ${p.label.short} — ${p.label.description} '
          'You were asked for the ${targetLabel.short}: ${targetLabel.description} $explanation',
      mistakes: const [MistakeTag.structureMisread],
    );
  }
}

class LabelStructureActivity extends Activity {
  const LabelStructureActivity({
    required super.id,
    required super.prompt,
    required super.skillIds,
    required super.explanation,
    required this.chartRecipe,
    required this.swingOrders,
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final ChartRecipe chartRecipe;

  /// Which swing points (by order in the sequence) must be labelled.
  final List<int> swingOrders;

  @override
  ActivityKind get kind => ActivityKind.labelStructure;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! LabelSetResponse || series == null) return _unanswerable();
    var right = 0;
    final wrong = <String>[];
    for (final order in swingOrders) {
      final swing = series.swings.firstWhere(
        (s) => s.order == order,
        orElse: () => series.swings.last,
      );
      final given = response.labels[order];
      if (given == swing.label) {
        right++;
      } else {
        wrong.add(
          'Point ${order + 1} is a ${swing.label.short}'
          '${given == null ? '' : ', not a ${given.short}'} — ${swing.label.description}',
        );
      }
    }
    final ratio = swingOrders.isEmpty ? 1.0 : right / swingOrders.length;
    if (wrong.isEmpty) return ActivityEvaluation.right(explanation);
    return ActivityEvaluation(
      correct: false,
      feedback: '${wrong.join('\n')}\n\n$explanation',
      partialCredit: ratio,
      mistakes: const [MistakeTag.structureMisread],
    );
  }
}

// ---------------------------------------------------------------------------
// 8. Trend classification
// ---------------------------------------------------------------------------

class TrendClassificationActivity extends Activity {
  const TrendClassificationActivity({
    required super.id,
    required super.skillIds,
    required super.explanation,
    required this.chartRecipe,
    required this.correct,
    super.prompt = 'How would you classify the structure on this chart?',
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final ChartRecipe chartRecipe;
  final TrendClass correct;

  @override
  ActivityKind get kind => ActivityKind.trendClassification;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  String get concept => conceptTag ?? 'trend_classification';

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! TrendResponse) return _unanswerable();
    if (response.trend == correct) return ActivityEvaluation.right(explanation);
    return ActivityEvaluation(
      correct: false,
      feedback:
          'You read this as ${response.trend.label.toLowerCase()}. Within the framework taught in '
          'this lesson the sequence of swings here reads as ${correct.label.toLowerCase()}. '
          '$explanation',
      mistakes: const [MistakeTag.trendMisread],
    );
  }
}

// ---------------------------------------------------------------------------
// 9. Long / short / no trade
// ---------------------------------------------------------------------------

class DirectionDecisionActivity extends Activity {
  const DirectionDecisionActivity({
    required super.id,
    required super.skillIds,
    required super.explanation,
    required this.chartRecipe,
    required this.preferred,
    this.acceptable = const [],
    super.prompt = 'Based only on the structure shown, which decision fits the framework in this lesson?',
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final ChartRecipe chartRecipe;

  /// The decision the lesson's framework supports.
  final TradeDirection preferred;

  /// Other decisions that are defensible and are not penalised.
  final List<TradeDirection> acceptable;

  @override
  ActivityKind get kind => ActivityKind.directionDecision;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  String get concept => conceptTag ?? 'direction_decision';

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! DirectionResponse) return _unanswerable();
    if (response.direction == preferred) {
      return ActivityEvaluation.right(explanation);
    }
    if (acceptable.contains(response.direction)) {
      return ActivityEvaluation(
        correct: true,
        feedback:
            'That is defensible. This chart supports more than one reading; the lesson leans '
            'towards ${preferred.label.toLowerCase()}. $explanation',
        partialCredit: 1,
      );
    }
    final mistake = preferred == TradeDirection.noTrade
        ? MistakeTag.missedNoTrade
        : (response.direction == TradeDirection.noTrade
              ? MistakeTag.hesitation
              : MistakeTag.trendMisread);
    return ActivityEvaluation(
      correct: false,
      feedback:
          'The lesson framework points to ${preferred.label.toLowerCase()} here. $explanation',
      mistakes: [mistake],
    );
  }
}

// ---------------------------------------------------------------------------
// 10 & 11. Placing a stop or a target on the chart
// ---------------------------------------------------------------------------

/// Shared geometry for stop/target exercises, derived from the chart itself.
class LevelExerciseGeometry {
  const LevelExerciseGeometry({
    required this.entry,
    required this.protectiveLevel,
    required this.maxDistance,
  });

  /// The price the exercise treats as the entry (the last close).
  final double entry;

  /// The swing the stop must sit beyond, or the swing the target aims at.
  final double protectiveLevel;
  final double maxDistance;

  static LevelExerciseGeometry? forStop(
    GeneratedSeries series,
    TradeDirection direction,
  ) {
    if (series.candles.isEmpty || series.swings.isEmpty) return null;
    final entry = series.candles.last.close;
    final relevant = series.swings
        .where((s) => direction == TradeDirection.long ? !s.isHigh : s.isHigh)
        .toList(growable: false);
    if (relevant.isEmpty) return null;
    final swing = relevant.last;
    final distance = (entry - swing.price).abs();
    if (distance <= 0) return null;
    return LevelExerciseGeometry(
      entry: entry,
      protectiveLevel: swing.price,
      maxDistance: distance * 2.2,
    );
  }

  static LevelExerciseGeometry? forTarget(
    GeneratedSeries series,
    TradeDirection direction,
  ) {
    if (series.candles.isEmpty || series.swings.isEmpty) return null;
    final entry = series.candles.last.close;
    final relevant = series.swings
        .where((s) => direction == TradeDirection.long ? s.isHigh : !s.isHigh)
        .toList(growable: false);
    if (relevant.isEmpty) return null;
    final swing = direction == TradeDirection.long
        ? relevant.reduce((a, b) => a.price > b.price ? a : b)
        : relevant.reduce((a, b) => a.price < b.price ? a : b);
    final distance = (swing.price - entry).abs();
    if (distance <= 0) return null;
    return LevelExerciseGeometry(
      entry: entry,
      protectiveLevel: swing.price,
      maxDistance: distance * 1.6,
    );
  }
}

class DragStopLossActivity extends Activity {
  const DragStopLossActivity({
    required super.id,
    required super.skillIds,
    required super.explanation,
    required this.chartRecipe,
    required this.direction,
    super.prompt = '',
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final ChartRecipe chartRecipe;
  final TradeDirection direction;

  @override
  ActivityKind get kind => ActivityKind.dragStopLoss;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  String get concept => conceptTag ?? 'stop_placement';

  @override
  String get displayPrompt => prompt.isNotEmpty
      ? prompt
      : 'Place a stop loss for this ${direction.label.toLowerCase()} idea. '
            'It should sit beyond the swing that would invalidate it.';

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! PriceLevelResponse || series == null) {
      return _unanswerable();
    }
    final geo = LevelExerciseGeometry.forStop(series, direction);
    if (geo == null) return _unanswerable();
    final price = response.price;
    if (!price.isFinite) return _unanswerable();

    final isLong = direction == TradeDirection.long;
    // A stop on the wrong side of the entry is not a stop at all.
    if (isLong && price >= geo.entry) {
      return const ActivityEvaluation(
        correct: false,
        feedback:
            'A stop for a long has to sit below the entry. Placed above it, the order would '
            'trigger immediately and it would not protect the position.',
        mistakes: [MistakeTag.ignoredInvalidation],
      );
    }
    if (!isLong && price <= geo.entry) {
      return const ActivityEvaluation(
        correct: false,
        feedback:
            'A stop for a short has to sit above the entry. Placed below it, the order would '
            'trigger immediately and it would not protect the position.',
        mistakes: [MistakeTag.ignoredInvalidation],
      );
    }

    final beyondSwing = isLong
        ? price < geo.protectiveLevel
        : price > geo.protectiveLevel;
    final distance = (geo.entry - price).abs();

    if (!beyondSwing) {
      return ActivityEvaluation(
        correct: false,
        feedback:
            'That stop sits inside the recent swing at ${Fmt.price(geo.protectiveLevel)}. '
            'Ordinary movement around that swing would take the position out before the idea '
            'itself had actually been proven wrong. $explanation',
        mistakes: const [MistakeTag.stopTooTight],
      );
    }
    if (distance > geo.maxDistance) {
      return ActivityEvaluation(
        correct: false,
        feedback:
            'That stop is a long way past the level that invalidates the idea. A wider stop means '
            'a smaller position for the same risk, and it keeps the trade alive after the reason '
            'for taking it has gone. $explanation',
        mistakes: const [MistakeTag.stopTooWide],
      );
    }
    return ActivityEvaluation.right(
      'Your stop sits just beyond the swing at ${Fmt.price(geo.protectiveLevel)}, which is the '
      'level that would make this idea wrong. $explanation',
    );
  }
}

class DragTakeProfitActivity extends Activity {
  const DragTakeProfitActivity({
    required super.id,
    required super.skillIds,
    required super.explanation,
    required this.chartRecipe,
    required this.direction,
    this.minRewardToRisk = 1.5,
    super.prompt = '',
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final ChartRecipe chartRecipe;
  final TradeDirection direction;
  final double minRewardToRisk;

  @override
  ActivityKind get kind => ActivityKind.dragTakeProfit;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  String get concept => conceptTag ?? 'target_placement';

  @override
  String get displayPrompt => prompt.isNotEmpty
      ? prompt
      : 'Place a take profit for this ${direction.label.toLowerCase()} idea, '
            'using the structure on the chart.';

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! PriceLevelResponse || series == null) {
      return _unanswerable();
    }
    final target = LevelExerciseGeometry.forTarget(series, direction);
    final stop = LevelExerciseGeometry.forStop(series, direction);
    if (target == null || stop == null) return _unanswerable();
    final price = response.price;
    if (!price.isFinite) return _unanswerable();

    final isLong = direction == TradeDirection.long;
    if (isLong && price <= target.entry) {
      return const ActivityEvaluation(
        correct: false,
        feedback:
            'A target for a long sits above the entry. Below it, the order would close the '
            'position at a loss the moment it was placed.',
        mistakes: [MistakeTag.poorRr],
      );
    }
    if (!isLong && price >= target.entry) {
      return const ActivityEvaluation(
        correct: false,
        feedback:
            'A target for a short sits below the entry. Above it, the order would close the '
            'position at a loss the moment it was placed.',
        mistakes: [MistakeTag.poorRr],
      );
    }

    final riskDistance = (target.entry - stop.protectiveLevel).abs();
    final rewardDistance = (price - target.entry).abs();
    if (riskDistance <= 0) return _unanswerable();
    final rr = rewardDistance / riskDistance;

    if (rr < minRewardToRisk) {
      return ActivityEvaluation(
        correct: false,
        feedback:
            'That target gives roughly ${Fmt.ratio(rr)} reward-to-risk. This exercise is looking '
            'for at least ${Fmt.ratio(minRewardToRisk)}, measured against a stop beyond the swing '
            'at ${Fmt.price(stop.protectiveLevel)}. $explanation',
        mistakes: const [MistakeTag.poorRr],
      );
    }
    final beyondStructure = isLong
        ? price > target.protectiveLevel * 1.02
        : price < target.protectiveLevel * 0.98;
    if (beyondStructure) {
      return ActivityEvaluation(
        correct: false,
        feedback:
            'That target sits well past the structure visible on the chart '
            '(${Fmt.price(target.protectiveLevel)}). A target needs somewhere plausible for price '
            'to reach, not just a large number. $explanation',
        mistakes: const [MistakeTag.poorRr],
      );
    }
    return ActivityEvaluation.right(
      'That target gives about ${Fmt.ratio(rr)} reward-to-risk and aims at structure already '
      'visible on the chart. $explanation',
    );
  }
}

// ---------------------------------------------------------------------------
// 12. Build a trade
// ---------------------------------------------------------------------------

class BuildTradeActivity extends Activity {
  const BuildTradeActivity({
    required super.id,
    required super.skillIds,
    required super.explanation,
    required this.chartRecipe,
    required this.direction,
    this.minRewardToRisk = 1.8,
    super.prompt = 'Build a complete trade idea: entry, stop and target.',
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final ChartRecipe chartRecipe;
  final TradeDirection direction;
  final double minRewardToRisk;

  @override
  ActivityKind get kind => ActivityKind.buildTrade;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  String get concept => conceptTag ?? 'trade_construction';

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! TradeSetupResponse || series == null) {
      return _unanswerable();
    }
    final geo = LevelExerciseGeometry.forStop(series, direction);
    if (geo == null) return _unanswerable();
    final isLong = direction == TradeDirection.long;
    final entry = response.entry;
    final sl = response.stopLoss;
    final tp = response.takeProfit;
    if (!entry.isFinite || !sl.isFinite || !tp.isFinite) return _unanswerable();

    if (isLong && sl >= entry) {
      return const ActivityEvaluation(
        correct: false,
        feedback:
            'For a long, the stop belongs below the entry. As set up here the position would be '
            'stopped out the instant it opened.',
        mistakes: [MistakeTag.ignoredInvalidation],
      );
    }
    if (!isLong && sl <= entry) {
      return const ActivityEvaluation(
        correct: false,
        feedback:
            'For a short, the stop belongs above the entry. As set up here the position would be '
            'stopped out the instant it opened.',
        mistakes: [MistakeTag.ignoredInvalidation],
      );
    }
    if (isLong && tp <= entry) {
      return const ActivityEvaluation(
        correct: false,
        feedback: 'For a long, the target belongs above the entry.',
        mistakes: [MistakeTag.poorRr],
      );
    }
    if (!isLong && tp >= entry) {
      return const ActivityEvaluation(
        correct: false,
        feedback: 'For a short, the target belongs below the entry.',
        mistakes: [MistakeTag.poorRr],
      );
    }

    final risk = (entry - sl).abs();
    final reward = (tp - entry).abs();
    if (risk <= 0) {
      return const ActivityEvaluation(
        correct: false,
        feedback: 'Entry and stop are at the same price, so there is no defined risk to size from.',
        mistakes: [MistakeTag.sizingError],
      );
    }
    final rr = reward / risk;
    final protectedSide = isLong
        ? sl < geo.protectiveLevel
        : sl > geo.protectiveLevel;

    final issues = <String>[];
    final mistakes = <MistakeTag>[];
    if (!protectedSide) {
      issues.add(
        'the stop sits inside the swing at ${Fmt.price(geo.protectiveLevel)} rather than beyond it',
      );
      mistakes.add(MistakeTag.stopTooTight);
    }
    if (rr < minRewardToRisk) {
      issues.add(
        'reward-to-risk is ${Fmt.ratio(rr)}, below the ${Fmt.ratio(minRewardToRisk)} this exercise asks for',
      );
      mistakes.add(MistakeTag.poorRr);
    }
    if (issues.isEmpty) {
      return ActivityEvaluation.right(
        'Stop beyond the invalidation swing and ${Fmt.ratio(rr)} reward-to-risk. $explanation',
      );
    }
    return ActivityEvaluation(
      correct: false,
      feedback:
          'The structure of the idea is there, but ${issues.join(', and ')}. $explanation',
      mistakes: mistakes,
      partialCredit: issues.length == 1 ? 0.5 : 0,
    );
  }
}

// ---------------------------------------------------------------------------
// 13 & 14. Calculations
// ---------------------------------------------------------------------------

class RiskCalculationActivity extends Activity {
  const RiskCalculationActivity({
    required super.id,
    required super.prompt,
    required super.skillIds,
    required super.explanation,
    required this.expected,
    this.unitLabel = r'$',
    this.tolerance = 0.01,
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final double expected;
  final String unitLabel;

  /// Relative tolerance, so rounding never marks a right answer wrong.
  final double tolerance;

  @override
  ActivityKind get kind => ActivityKind.riskCalculation;

  @override
  String get concept => conceptTag ?? 'risk_amount';

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! NumericResponse) return _unanswerable();
    final value = response.value;
    if (!value.isFinite) {
      return const ActivityEvaluation(
        correct: false,
        feedback: 'That is not a number this exercise can check. Enter a plain amount.',
      );
    }
    final allowed = math.max(expected.abs() * tolerance, 0.005);
    if ((value - expected).abs() <= allowed) {
      return ActivityEvaluation.right(explanation);
    }
    return ActivityEvaluation(
      correct: false,
      feedback:
          'You answered ${Fmt.price(value)}. The figure works out to '
          '${Fmt.price(expected)}. $explanation',
      mistakes: const [MistakeTag.sizingError],
    );
  }
}

class RiskRewardActivity extends Activity {
  const RiskRewardActivity({
    required super.id,
    required super.prompt,
    required super.skillIds,
    required super.explanation,
    required this.entry,
    required this.stopLoss,
    required this.takeProfit,
    required this.direction,
    this.tolerance = 0.05,
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final double entry;
  final double stopLoss;
  final double takeProfit;
  final TradeDirection direction;
  final double tolerance;

  double get expectedRatio {
    final risk = (entry - stopLoss).abs();
    if (risk <= 0) return 0;
    return (takeProfit - entry).abs() / risk;
  }

  @override
  ActivityKind get kind => ActivityKind.riskReward;

  @override
  String get concept => conceptTag ?? 'risk_reward';

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! NumericResponse) return _unanswerable();
    final value = response.value;
    if (!value.isFinite) {
      return const ActivityEvaluation(
        correct: false,
        feedback: 'That is not a number this exercise can check.',
      );
    }
    final expected = expectedRatio;
    if ((value - expected).abs() <= math.max(expected * tolerance, 0.02)) {
      return ActivityEvaluation.right(explanation);
    }
    final risk = (entry - stopLoss).abs();
    final reward = (takeProfit - entry).abs();
    return ActivityEvaluation(
      correct: false,
      feedback:
          'Risk is ${Fmt.price(risk)} per unit (entry ${Fmt.price(entry)} to stop '
          '${Fmt.price(stopLoss)}) and reward is ${Fmt.price(reward)} (entry to target '
          '${Fmt.price(takeProfit)}). ${Fmt.price(reward)} ÷ ${Fmt.price(risk)} = '
          '${expected.toStringAsFixed(2)}. $explanation',
      mistakes: const [MistakeTag.poorRr],
    );
  }
}

// ---------------------------------------------------------------------------
// 15. Order type
// ---------------------------------------------------------------------------

class OrderTypeActivity extends Activity {
  const OrderTypeActivity({
    required super.id,
    required super.prompt,
    required super.skillIds,
    required super.explanation,
    required this.correct,
    this.scenario = '',
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final OrderType correct;
  final String scenario;

  @override
  ActivityKind get kind => ActivityKind.orderType;

  @override
  String get concept => conceptTag ?? 'order_types';

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! OrderTypeResponse) return _unanswerable();
    if (response.type == correct) return ActivityEvaluation.right(explanation);
    return ActivityEvaluation(
      correct: false,
      feedback:
          'A ${response.type.label.toLowerCase()} order ${response.type.description.toLowerCase()} '
          'For what this scenario describes, a ${correct.label.toLowerCase()} order is the fit: '
          '${correct.description.toLowerCase()} $explanation',
      mistakes: const [MistakeTag.wrongOrderType],
    );
  }
}

// ---------------------------------------------------------------------------
// 16. Sequence ordering
// ---------------------------------------------------------------------------

class SequenceOrderingActivity extends Activity {
  const SequenceOrderingActivity({
    required super.id,
    required super.prompt,
    required super.skillIds,
    required super.explanation,
    required this.stepsInOrder,
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  /// Items written in their correct order; the UI shuffles them.
  final List<String> stepsInOrder;

  @override
  ActivityKind get kind => ActivityKind.sequenceOrdering;

  @override
  String get concept => conceptTag ?? 'process_sequence';

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! SequenceResponse) return _unanswerable();
    final expected = List.generate(stepsInOrder.length, (i) => i);
    if (response.order.length != expected.length) return _unanswerable();
    var right = 0;
    for (var i = 0; i < expected.length; i++) {
      if (response.order[i] == expected[i]) right++;
    }
    if (right == expected.length) return ActivityEvaluation.right(explanation);
    final correctOrder = [
      for (var i = 0; i < stepsInOrder.length; i++)
        '${i + 1}. ${stepsInOrder[i]}',
    ].join('\n');
    return ActivityEvaluation(
      correct: false,
      feedback: 'The order that works is:\n$correctOrder\n\n$explanation',
      partialCredit: expected.isEmpty ? 1 : right / expected.length,
    );
  }
}

// ---------------------------------------------------------------------------
// 17. Spot the mistake
// ---------------------------------------------------------------------------

class SpotMistakeActivity extends Activity {
  const SpotMistakeActivity({
    required super.id,
    required super.skillIds,
    required super.explanation,
    required this.scenario,
    required this.options,
    required this.correctIndex,
    required this.tag,
    this.chartRecipe,
    super.prompt = 'What is the main problem with this plan?',
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final String scenario;
  final List<String> options;
  final int correctIndex;
  final MistakeTag tag;
  final ChartRecipe? chartRecipe;

  @override
  ActivityKind get kind => ActivityKind.spotMistake;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  String get concept => conceptTag ?? tag.name;

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! ChoiceResponse) return _unanswerable();
    if (response.index == correctIndex) {
      return ActivityEvaluation.right(explanation);
    }
    return ActivityEvaluation(
      correct: false,
      feedback:
          'The bigger problem here is "${options[correctIndex.clamp(0, options.length - 1)]}" — '
          '${tag.description} $explanation',
      mistakes: [tag],
    );
  }
}

// ---------------------------------------------------------------------------
// 18. Matching
// ---------------------------------------------------------------------------

class MatchingActivity extends Activity {
  const MatchingActivity({
    required super.id,
    required super.skillIds,
    required super.explanation,
    required this.terms,
    required this.definitions,
    super.prompt = 'Match each term to its definition.',
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  /// `terms[i]` matches `definitions[i]`.
  final List<String> terms;
  final List<String> definitions;

  @override
  ActivityKind get kind => ActivityKind.matching;

  @override
  String get concept => conceptTag ?? 'terminology';

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! MatchResponse) return _unanswerable();
    var right = 0;
    final wrong = <String>[];
    for (var i = 0; i < terms.length; i++) {
      if (response.pairs[i] == i) {
        right++;
      } else {
        wrong.add('${terms[i]} — ${definitions[i]}');
      }
    }
    if (wrong.isEmpty) return ActivityEvaluation.right(explanation);
    return ActivityEvaluation(
      correct: false,
      feedback:
          'These are the pairs that did not match:\n${wrong.join('\n')}\n\n$explanation',
      partialCredit: terms.isEmpty ? 1 : right / terms.length,
    );
  }
}

// ---------------------------------------------------------------------------
// 19. Chart zone selection
// ---------------------------------------------------------------------------

class ZoneSelectionActivity extends Activity {
  const ZoneSelectionActivity({
    required super.id,
    required super.prompt,
    required super.skillIds,
    required super.explanation,
    required this.chartRecipe,
    required this.zoneKind,
    this.toleranceFactor = 1.8,
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final ChartRecipe chartRecipe;
  final ZoneKind zoneKind;

  /// How far outside the zone still counts, as a multiple of the zone height.
  final double toleranceFactor;

  @override
  ActivityKind get kind => ActivityKind.zoneSelection;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  String get concept => conceptTag ?? zoneKind.name;

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! ZoneResponse || series == null) return _unanswerable();
    final zones = series.zonesOfKind(zoneKind);
    if (zones.isEmpty) {
      return const ActivityEvaluation(
        correct: false,
        feedback: 'This chart does not contain that zone. Skip ahead and try another exercise.',
      );
    }
    final zone = zones.first;
    final height = (zone.highPrice - zone.lowPrice).abs();
    final tolerance = math.max(height * toleranceFactor, height);
    if (response.price >= zone.lowPrice - tolerance &&
        response.price <= zone.highPrice + tolerance) {
      return ActivityEvaluation.right('${zone.description} $explanation');
    }
    final direction = response.price > zone.highPrice ? 'above' : 'below';
    return ActivityEvaluation(
      correct: false,
      feedback:
          'Your selection sits $direction the area this exercise was looking for. The '
          '${zoneKind.label.toLowerCase()} runs from ${Fmt.price(zone.lowPrice)} to '
          '${Fmt.price(zone.highPrice)}. ${zone.description} $explanation',
    );
  }
}

// ---------------------------------------------------------------------------
// 20. Mini simulation
// ---------------------------------------------------------------------------

class MiniSimulationActivity extends Activity {
  const MiniSimulationActivity({
    required super.id,
    required super.skillIds,
    required super.explanation,
    required this.chartRecipe,
    required this.visibleCandles,
    required this.preferred,
    this.acceptable = const [],
    super.prompt =
        'Only part of this chart is visible. Decide before the rest plays out.',
    super.difficulty,
    super.hint,
    super.conceptTag,
  });

  final ChartRecipe chartRecipe;

  /// Candles shown before the decision. The rest stay hidden until the replay.
  final int visibleCandles;
  final TradeDirection preferred;
  final List<TradeDirection> acceptable;

  @override
  ActivityKind get kind => ActivityKind.miniSimulation;

  @override
  ChartRecipe? get recipe => chartRecipe;

  @override
  String get concept => conceptTag ?? 'mini_simulation';

  @override
  ActivityEvaluation evaluate(
    ActivityResponse response, {
    GeneratedSeries? series,
  }) {
    if (response is! DirectionResponse) return _unanswerable();
    if (response.direction == preferred ||
        acceptable.contains(response.direction)) {
      return ActivityEvaluation.right(explanation);
    }
    return ActivityEvaluation(
      correct: false,
      feedback:
          'Reading only the candles that were visible, the framework in this lesson points to '
          '${preferred.label.toLowerCase()}. What happens next in the replay is one outcome, not '
          'proof — the decision is graded on the reasoning available at the time. $explanation',
      mistakes: preferred == TradeDirection.noTrade
          ? const [MistakeTag.missedNoTrade]
          : const [MistakeTag.trendMisread],
    );
  }
}
