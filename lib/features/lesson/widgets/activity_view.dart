import 'package:flutter/material.dart';

import '../../../design_system/components.dart';
import '../../../domain/models/activity.dart';
import '../../../domain/models/enums.dart';
import 'chart_activity_views.dart';
import 'simple_activity_views.dart';

/// Renders any [Activity].
///
/// Adding a new activity type means adding one case here and one renderer.
/// Nothing else in the player changes.
class ActivityView extends StatelessWidget {
  const ActivityView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final Activity activity;
  final ResponseChanged onChanged;

  @override
  Widget build(BuildContext context) {
    // A key per activity resets renderer state between questions.
    final key = ValueKey(activity.id);

    switch (activity) {
      case ExplanationActivity():
        return ExplanationView(
          key: key,
          activity: activity as ExplanationActivity,
          onChanged: onChanged,
        );
      case MultipleChoiceActivity():
        return MultipleChoiceView(
          key: key,
          activity: activity as MultipleChoiceActivity,
          onChanged: onChanged,
        );
      case TrueFalseActivity():
        return TrueFalseView(
          key: key,
          activity: activity as TrueFalseActivity,
          onChanged: onChanged,
        );
      case TapCandleActivity():
        return TapCandleView(
          key: key,
          activity: activity as TapCandleActivity,
          onChanged: onChanged,
        );
      case TapPricePointActivity():
        return TapPricePointView(
          key: key,
          activity: activity as TapPricePointActivity,
          onChanged: onChanged,
        );
      case IdentifyStructureActivity():
        return IdentifyStructureView(
          key: key,
          activity: activity as IdentifyStructureActivity,
          onChanged: onChanged,
        );
      case LabelStructureActivity():
        return LabelStructureView(
          key: key,
          activity: activity as LabelStructureActivity,
          onChanged: onChanged,
        );
      case TrendClassificationActivity():
        return TrendClassificationView(
          key: key,
          activity: activity as TrendClassificationActivity,
          onChanged: onChanged,
        );
      case DirectionDecisionActivity():
        return DirectionDecisionView(
          key: key,
          activity: activity,
          onChanged: onChanged,
        );
      case DragStopLossActivity():
        final a = activity as DragStopLossActivity;
        return LevelPlacementView(
          key: key,
          activity: a,
          onChanged: onChanged,
          recipe: a.chartRecipe,
          lineLabel: 'Stop',
          lineColor: (ctx) => ctx.tp.stopLine,
          direction: a.direction,
          responseBuilder: PriceLevelResponse.new,
        );
      case DragTakeProfitActivity():
        final a = activity as DragTakeProfitActivity;
        return LevelPlacementView(
          key: key,
          activity: a,
          onChanged: onChanged,
          recipe: a.chartRecipe,
          lineLabel: 'Target',
          lineColor: (ctx) => ctx.tp.targetLine,
          direction: a.direction,
          responseBuilder: PriceLevelResponse.new,
        );
      case BuildTradeActivity():
        return BuildTradeView(
          key: key,
          activity: activity as BuildTradeActivity,
          onChanged: onChanged,
        );
      case RiskCalculationActivity():
        final a = activity as RiskCalculationActivity;
        return NumericAnswerView(
          key: key,
          activity: a,
          onChanged: onChanged,
          suffix: a.unitLabel == r'$' ? null : a.unitLabel,
          helper: 'Work it through, then enter the figure.',
        );
      case RiskRewardActivity():
        return NumericAnswerView(
          key: key,
          activity: activity,
          onChanged: onChanged,
          helper:
              'Enter the ratio as a single number — 3 means the target is three '
              'times as far as the stop.',
        );
      case OrderTypeActivity():
        return OrderTypeView(
          key: key,
          activity: activity as OrderTypeActivity,
          onChanged: onChanged,
        );
      case SequenceOrderingActivity():
        return SequenceOrderingView(
          key: key,
          activity: activity as SequenceOrderingActivity,
          onChanged: onChanged,
        );
      case SpotMistakeActivity():
        return SpotMistakeView(
          key: key,
          activity: activity as SpotMistakeActivity,
          onChanged: onChanged,
        );
      case MatchingActivity():
        return MatchingView(
          key: key,
          activity: activity as MatchingActivity,
          onChanged: onChanged,
        );
      case ZoneSelectionActivity():
        final a = activity as ZoneSelectionActivity;
        return LevelPlacementView(
          key: key,
          activity: a,
          onChanged: onChanged,
          recipe: a.chartRecipe,
          lineLabel: 'Selection',
          lineColor: (ctx) => ctx.tp.accent,
          showEntry: false,
          direction: TradeDirection.noTrade,
          instruction: 'Move the selector onto the area the question describes, then check.',
          responseBuilder: ZoneResponse.new,
        );
      case MiniSimulationActivity():
        return MiniSimulationView(
          key: key,
          activity: activity as MiniSimulationActivity,
          onChanged: onChanged,
        );
    }
  }
}
