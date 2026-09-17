import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/formatters.dart';
import '../../../design_system/components.dart';
import '../../../domain/models/enums.dart';
import '../../../domain/models/trade.dart';
import '../../../domain/services/coach_service.dart';
import '../../../domain/services/risk_calculator.dart';
import '../../../domain/services/simulation_session.dart';
import '../../../shared/chart/candle_chart.dart';
import '../../../shared/chart/chart_models.dart';
import '../simulation_run_screen.dart';

/// Configure entry, stop, target and risk before committing a simulated trade.
class TradeBuilder extends StatefulWidget {
  const TradeBuilder({
    super.key,
    required this.session,
    required this.defaultRiskPercent,
    required this.onBack,
    required this.onCommit,
  });

  final SimulationSession session;
  final double defaultRiskPercent;
  final VoidCallback onBack;
  final ValueChanged<TradePlan> onCommit;

  @override
  State<TradeBuilder> createState() => _TradeBuilderState();
}

class _TradeBuilderState extends State<TradeBuilder> {
  late double _entry;
  late double _stop;
  late double _target;
  late double _risk;
  late double _min;
  late double _max;
  String _active = 'stop';

  @override
  void initState() {
    super.initState();
    final session = widget.session;
    final bundle = session.bundle;
    final isLong = session.direction == TradeDirection.long;

    _entry = session.decisionPrice;
    final distance = suggestStopDistance(bundle);
    _stop = isLong ? _entry - distance : _entry + distance;
    _target = isLong ? _entry + distance * 2 : _entry - distance * 2;
    _risk = widget.defaultRiskPercent <= 0 ? 1.0 : widget.defaultRiskPercent;

    final high = bundle.visibleCandles
        .map((c) => c.high)
        .reduce((a, b) => a > b ? a : b);
    final low = bundle.visibleCandles
        .map((c) => c.low)
        .reduce((a, b) => a < b ? a : b);
    final span = math.max(high - low, _entry * 0.01);
    _min = low - span * 0.6;
    _max = high + span * 0.6;
  }

  TradePlan get _plan => RiskCalculator.buildPlan(
    direction: widget.session.direction ?? TradeDirection.long,
    entry: _entry,
    stopLoss: _stop,
    takeProfit: _target,
    riskPercent: _risk,
    balance: widget.session.startingBalance,
  );

  double get _current => switch (_active) {
    'entry' => _entry,
    'stop' => _stop,
    _ => _target,
  };

  void _setActive(double value) {
    final v = value.clamp(_min, _max);
    setState(() {
      switch (_active) {
        case 'entry':
          _entry = v;
        case 'stop':
          _stop = v;
        default:
          _target = v;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final session = widget.session;
    final plan = _plan;
    final validation = validatePlan(plan);
    final guardrail = RiskGuardrails.messageFor(_risk);
    final step = (_max - _min) / 240;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, Gap.lg),
            children: [
              SizedBox(
                height: 290,
                child: CandleChart(
                  candles: session.chartCandles,
                  priceDecimals: session.scenario.asset.priceDecimals,
                  priceLines: [
                    ChartPriceLine(
                      price: _entry,
                      color: c.entryLine,
                      label: 'Entry',
                      dashed: false,
                      draggable: _active == 'entry',
                    ),
                    ChartPriceLine(
                      price: _stop,
                      color: c.stopLine,
                      label: 'Stop',
                      draggable: _active == 'stop',
                    ),
                    ChartPriceLine(
                      price: _target,
                      color: c.targetLine,
                      label: 'Target',
                      draggable: _active == 'target',
                    ),
                  ],
                  markers: [
                    for (final s in session.bundle.visibleSwings.reversed.take(
                      3,
                    ))
                      ChartMarker(
                        candleIndex: s.index,
                        price: s.price,
                        label: s.label.short,
                        above: s.isHigh,
                        color: c.textTertiary,
                      ),
                  ],
                  onLevelDrag: _setActive,
                ),
              ),
              const VGap(Gap.md),
              Row(
                children: [
                  for (final entry in const [
                    ('entry', 'Entry'),
                    ('stop', 'Stop'),
                    ('target', 'Target'),
                  ])
                    Padding(
                      padding: const EdgeInsets.only(right: Gap.sm),
                      child: TpFilterChip(
                        label: entry.$2,
                        selected: _active == entry.$1,
                        onTap: () => setState(() => _active = entry.$1),
                      ),
                    ),
                ],
              ),
              const VGap(Gap.md),
              TpCard(
                raised: true,
                child: Column(
                  children: [
                    Row(
                      children: [
                        TpIconButton(
                          icon: Icons.remove_rounded,
                          tooltip: 'Lower the $_active',
                          background: c.surfaceSunken,
                          onPressed: () => _setActive(_current - step * 3),
                        ),
                        Expanded(
                          child: Semantics(
                            label: '$_active price',
                            value: Fmt.price(_current),
                            slider: true,
                            child: Slider(
                              value: _current.clamp(_min, _max),
                              min: _min,
                              max: _max,
                              onChanged: _setActive,
                            ),
                          ),
                        ),
                        TpIconButton(
                          icon: Icons.add_rounded,
                          tooltip: 'Raise the $_active',
                          background: c.surfaceSunken,
                          onPressed: () => _setActive(_current + step * 3),
                        ),
                      ],
                    ),
                    Text(
                      '${_active[0].toUpperCase()}${_active.substring(1)}: '
                      '${Fmt.price(_current)}',
                      style: context.texts.titleSmall,
                    ),
                  ],
                ),
              ),
              const TpSectionHeader(
                title: 'Risk',
                subtitle:
                    'Position size follows from this and the stop distance.',
              ),
              TpCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Risk per trade',
                            style: context.texts.bodyMedium,
                          ),
                        ),
                        Text(
                          Fmt.percent(_risk, decimals: 2),
                          style: context.texts.titleMedium?.copyWith(
                            color: _risk > RiskCalculator.highRiskThreshold
                                ? c.warning
                                : c.accent,
                          ),
                        ),
                      ],
                    ),
                    Semantics(
                      label: 'Risk percentage',
                      value: Fmt.percent(_risk, decimals: 2),
                      slider: true,
                      child: Slider(
                        value: _risk.clamp(0.1, 50),
                        min: 0.1,
                        max: 50,
                        divisions: 499,
                        onChanged: (v) => setState(() => _risk = v),
                      ),
                    ),
                    Row(
                      children: [
                        for (final preset in const [0.5, 1.0, 2.0, 5.0])
                          Padding(
                            padding: const EdgeInsets.only(right: Gap.sm),
                            child: TpFilterChip(
                              label: '$preset%',
                              selected: (_risk - preset).abs() < 0.01,
                              onTap: () => setState(() => _risk = preset),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (guardrail != null) ...[
                const VGap(Gap.md),
                TpCallout(
                  tone: _risk > RiskCalculator.extremeRiskThreshold
                      ? TpCalloutTone.danger
                      : TpCalloutTone.warning,
                  icon: Icons.warning_amber_rounded,
                  title: 'Risk guardrail',
                  message: guardrail,
                ),
              ],
              const TpSectionHeader(title: 'This plan'),
              TpCard(
                raised: true,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TpStatTile(
                            label: 'Stop distance',
                            value: Fmt.price(plan.stopDistance),
                            compact: true,
                          ),
                        ),
                        Expanded(
                          child: TpStatTile(
                            label: 'Target distance',
                            value: Fmt.price(plan.targetDistance),
                            compact: true,
                          ),
                        ),
                        Expanded(
                          child: TpStatTile(
                            label: 'R:R',
                            value: Fmt.ratio(plan.rewardToRisk),
                            compact: true,
                            valueColor: plan.rewardToRisk >= 2
                                ? c.bullish
                                : plan.rewardToRisk < 1
                                ? c.bearish
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: Gap.xl),
                    Row(
                      children: [
                        Expanded(
                          child: TpStatTile(
                            label: 'Risk amount',
                            value: Fmt.money(plan.riskAmount),
                            compact: true,
                            caption: 'virtual',
                          ),
                        ),
                        Expanded(
                          child: TpStatTile(
                            label: 'Position size',
                            value: plan.positionSize > 0
                                ? plan.positionSize.toStringAsFixed(4)
                                : '—',
                            compact: true,
                            caption: 'units',
                          ),
                        ),
                        Expanded(
                          child: TpStatTile(
                            label: 'If stopped',
                            value: Fmt.signedMoney(-plan.riskAmount),
                            compact: true,
                            valueColor: c.bearish,
                          ),
                        ),
                      ],
                    ),
                    const VGap(Gap.md),
                    Text(
                      'Balance ${Fmt.money(session.startingBalance)} × '
                      '${Fmt.percent(_risk, decimals: 2)} = '
                      '${Fmt.money(plan.riskAmount)}, ÷ stop distance '
                      '${Fmt.price(plan.stopDistance)} = '
                      '${plan.positionSize > 0 ? plan.positionSize.toStringAsFixed(4) : '—'} units.',
                      style: context.texts.bodySmall,
                    ),
                  ],
                ),
              ),
              for (final issue in validation.issues) ...[
                const VGap(Gap.md),
                TpCallout(
                  tone: issue.isError
                      ? TpCalloutTone.danger
                      : TpCalloutTone.warning,
                  icon: issue.isError
                      ? Icons.error_outline_rounded
                      : Icons.info_outline_rounded,
                  message: issue.message,
                ),
              ],
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(Gap.lg),
          decoration: BoxDecoration(
            color: c.surface,
            border: Border(top: BorderSide(color: c.border)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TpButton.secondary(
                    label: 'Back',
                    size: TpButtonSize.large,
                    expand: true,
                    onPressed: widget.onBack,
                  ),
                ),
                const HGap(Gap.sm),
                Expanded(
                  flex: 2,
                  child: TpButton.primary(
                    label: 'Commit and reveal',
                    size: TpButtonSize.large,
                    onPressed: validation.isValid
                        ? () => widget.onCommit(plan)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
