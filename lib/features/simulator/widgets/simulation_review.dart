import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/formatters.dart';
import '../../../design_system/components.dart';
import '../../../domain/services/process_score.dart';
import '../../../domain/services/simulation_session.dart';
import '../../../shared/chart/candle_chart.dart';
import '../../../shared/chart/chart_models.dart';
import '../simulation_run_screen.dart';

/// The post-simulation review: result, process score and coaching.
class SimulationReview extends ConsumerWidget {
  const SimulationReview({
    super.key,
    required this.session,
    required this.saving,
    required this.saved,
    required this.onSave,
    required this.onDone,
    required this.onAnother,
  });

  final SimulationSession session;
  final bool saving;
  final bool saved;
  final VoidCallback onSave;
  final VoidCallback onDone;
  final VoidCallback onAnother;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.tp;
    final plan = session.plan!;
    final result = session.result!;
    final score = session.processScore!;
    final coach = buildCoachMessage(ref, session);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, Gap.lg),
            children: [
              // --- Process score is first, deliberately -------------------
              TpCard(
                raised: true,
                accent: _scoreColor(context, score.total),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TpRingProgress(
                          value: score.total / 100,
                          size: 72,
                          strokeWidth: 7,
                          color: _scoreColor(context, score.total),
                          child: Text(
                            score.total.round().toString(),
                            style: context.texts.titleLarge,
                          ),
                        ),
                        const HGap(Gap.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PROCESS SCORE',
                                style: context.texts.labelSmall,
                              ),
                              const VGap(Gap.xxs),
                              Text(
                                score.band,
                                style: context.texts.titleMedium,
                              ),
                              const VGap(Gap.xs),
                              Text(
                                'Scored on how the decision was made, not on '
                                'whether it made money.',
                                style: context.texts.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const VGap(Gap.lg),

              // --- Outcome ------------------------------------------------
              TpCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Result', style: context.texts.titleSmall),
                    const VGap(Gap.md),
                    Row(
                      children: [
                        Expanded(
                          child: TpStatTile(
                            label: 'Outcome',
                            value: result.outcome.label,
                            compact: true,
                          ),
                        ),
                        Expanded(
                          child: TpStatTile(
                            label: 'R multiple',
                            value: plan.isNoTrade
                                ? '—'
                                : Fmt.rMultiple(result.rMultiple),
                            compact: true,
                            valueColor: result.rMultiple > 0
                                ? c.bullish
                                : result.rMultiple < 0
                                ? c.bearish
                                : null,
                          ),
                        ),
                        Expanded(
                          child: TpStatTile(
                            label: 'Virtual P&L',
                            value: plan.isNoTrade
                                ? '—'
                                : Fmt.signedMoney(result.profitLoss),
                            compact: true,
                            valueColor: result.profitLoss > 0
                                ? c.bullish
                                : result.profitLoss < 0
                                ? c.bearish
                                : null,
                          ),
                        ),
                      ],
                    ),
                    if (!plan.isNoTrade) ...[
                      const Divider(height: Gap.xl),
                      Row(
                        children: [
                          Expanded(
                            child: TpStatTile(
                              label: 'Risk used',
                              value: Fmt.percent(plan.riskPercent, decimals: 2),
                              compact: true,
                            ),
                          ),
                          Expanded(
                            child: TpStatTile(
                              label: 'Planned R:R',
                              value: Fmt.ratio(plan.rewardToRisk),
                              compact: true,
                            ),
                          ),
                          Expanded(
                            child: TpStatTile(
                              label: 'Balance',
                              value: Fmt.money(session.endingBalance),
                              compact: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (result.ambiguousCandle) ...[
                      const VGap(Gap.md),
                      const TpCallout(
                        tone: TpCalloutTone.warning,
                        icon: Icons.help_outline_rounded,
                        title: 'Ambiguous candle',
                        message:
                            'Your stop and target both sat inside one candle, and a candle does '
                            'not record which was reached first. The simulator applied its '
                            'conservative rule and treated the stop as hit.',
                      ),
                    ],
                  ],
                ),
              ),
              const VGap(Gap.lg),

              // --- The full chart, now revealed ---------------------------
              Text('What happened next', style: context.texts.titleSmall),
              const VGap(Gap.md),
              SizedBox(
                height: 260,
                child: CandleChart(
                  candles: session.chartCandles,
                  interactive: true,
                  priceDecimals: session.scenario.asset.priceDecimals,
                  dimAfterIndex: session.decisionIndexInChart,
                  priceLines: plan.isNoTrade
                      ? const []
                      : [
                          ChartPriceLine(
                            price: plan.entry,
                            color: c.entryLine,
                            label: 'Entry',
                            dashed: false,
                          ),
                          ChartPriceLine(
                            price: plan.stopLoss,
                            color: c.stopLine,
                            label: 'Stop',
                          ),
                          ChartPriceLine(
                            price: plan.takeProfit,
                            color: c.targetLine,
                            label: 'Target',
                          ),
                        ],
                ),
              ),
              const VGap(Gap.sm),
              Text(
                'Candles left of the divider were visible when you decided. '
                '${describeConditions(session.bundle)}',
                style: context.texts.bodySmall,
              ),

              // --- Component breakdown -----------------------------------
              const TpSectionHeader(title: 'Score breakdown'),
              TpCard(
                child: Column(
                  children: [
                    for (var i = 0; i < score.components.length; i++) ...[
                      _ComponentRow(component: score.components[i]),
                      if (i != score.components.length - 1)
                        const Divider(height: Gap.xl),
                    ],
                  ],
                ),
              ),

              // --- Coach --------------------------------------------------
              const TpSectionHeader(
                title: 'Coach',
                subtitle: 'Generated on this device from your trade metrics.',
              ),
              TpCard(
                raised: true,
                accent: c.info,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(coach.headline, style: context.texts.titleMedium),
                    const VGap(Gap.sm),
                    Text(coach.body, style: context.texts.bodyMedium),
                    if (coach.suggestions.isNotEmpty) ...[
                      const VGap(Gap.md),
                      for (final s in coach.suggestions)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Gap.sm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.arrow_right_rounded,
                                size: 18,
                                color: c.info,
                              ),
                              const HGap(Gap.xs),
                              Expanded(
                                child: Text(s, style: context.texts.bodySmall),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ],
                ),
              ),

              if (score.strengths.isNotEmpty) ...[
                const TpSectionHeader(title: 'What went well'),
                for (final s in score.strengths)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.sm),
                    child: _Bullet(
                      text: s,
                      color: c.bullish,
                      icon: Icons.check_rounded,
                    ),
                  ),
              ],
              if (score.improvements.isNotEmpty) ...[
                const TpSectionHeader(title: 'What to work on'),
                for (final s in score.improvements)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Gap.sm),
                    child: _Bullet(
                      text: s,
                      color: c.warning,
                      icon: Icons.trending_up_rounded,
                    ),
                  ),
              ],
              if (score.mistakes.isNotEmpty) ...[
                const TpSectionHeader(title: 'Tagged for your journal'),
                Wrap(
                  spacing: Gap.sm,
                  runSpacing: Gap.sm,
                  children: [
                    for (final m in score.mistakes)
                      TpBadge(label: m.label, color: c.bearish, dense: true),
                  ],
                ),
              ],
              const VGap(Gap.xxl),
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
            child: Column(
              children: [
                if (!saved)
                  TpButton.primary(
                    label: 'Save to journal',
                    icon: Icons.bookmark_add_rounded,
                    size: TpButtonSize.large,
                    busy: saving,
                    onPressed: onSave,
                  )
                else
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: c.bullish,
                        size: 18,
                      ),
                      const HGap(Gap.sm),
                      Expanded(
                        child: Text(
                          'Saved to your journal and virtual account.',
                          style: context.texts.bodySmall,
                        ),
                      ),
                    ],
                  ),
                const VGap(Gap.sm),
                Row(
                  children: [
                    Expanded(
                      child: TpButton.secondary(
                        label: 'Done',
                        expand: true,
                        onPressed: onDone,
                      ),
                    ),
                    const HGap(Gap.sm),
                    Expanded(
                      child: TpButton.secondary(
                        label: 'Another',
                        expand: true,
                        onPressed: saved ? onAnother : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _scoreColor(BuildContext context, double score) {
    final c = context.tp;
    if (score >= 75) return c.bullish;
    if (score >= 50) return c.warning;
    return c.bearish;
  }
}

class _ComponentRow extends StatelessWidget {
  const _ComponentRow({required this.component});
  final ProcessComponent component;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final color = component.score >= 75
        ? c.bullish
        : component.score >= 50
        ? c.warning
        : c.bearish;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      component.label,
                      style: context.texts.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (component.subjective) ...[
                    const HGap(Gap.sm),
                    TpBadge(
                      label: 'judgement',
                      dense: true,
                      color: c.textTertiary,
                    ),
                  ],
                ],
              ),
            ),
            Text(
              '${component.score.round()}',
              style: context.texts.titleMedium?.copyWith(color: color),
            ),
            Text(
              ' /100 · ${component.weight.round()}%',
              style: context.texts.labelSmall,
            ),
          ],
        ),
        const VGap(Gap.sm),
        TpProgressBar(
          value: component.score / 100,
          color: color,
          height: 6,
          label: component.label,
        ),
        const VGap(Gap.sm),
        Text(component.comment, style: context.texts.bodySmall),
      ],
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.color, required this.icon});

  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const HGap(Gap.sm),
        Expanded(child: Text(text, style: context.texts.bodyMedium)),
      ],
    );
  }
}
