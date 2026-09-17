import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/formatters.dart';
import '../../design_system/components.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/skill.dart';
import '../../domain/repositories/repositories.dart';
import '../learn/learner_controller.dart';
import 'widgets/equity_curve.dart';

/// Everything the analytics screen needs, computed in one place.
class AnalyticsData {
  const AnalyticsData({
    required this.entries,
    required this.equity,
    required this.account,
    required this.attempts,
  });

  final List<JournalEntry> entries;
  final List<EquityPoint> equity;
  final SimulatorAccount account;
  final List<AttemptRecord> attempts;

  List<JournalEntry> get trades =>
      entries.where((e) => !e.isNoTrade).toList(growable: false);

  int get noTradeCount => entries.where((e) => e.isNoTrade).length;

  double get averageProcessScore => entries.isEmpty
      ? 0
      : entries.map((e) => e.processScore).reduce((a, b) => a + b) /
            entries.length;

  double get averageRiskPercent => trades.isEmpty
      ? 0
      : trades.map((e) => e.riskPercent).reduce((a, b) => a + b) /
            trades.length;

  double get averagePlannedRr => trades.isEmpty
      ? 0
      : trades.map((e) => e.rewardToRisk).reduce((a, b) => a + b) /
            trades.length;

  double get expectancyR => trades.isEmpty
      ? 0
      : trades.map((e) => e.rMultiple).reduce((a, b) => a + b) / trades.length;

  double get winRate {
    if (trades.isEmpty) return 0;
    return trades.where((e) => e.isWin).length / trades.length;
  }

  /// Share of trades that stayed inside the conservative training band.
  double get riskDisciplineRate {
    if (trades.isEmpty) return 0;
    return trades.where((e) => e.riskPercent <= 2).length / trades.length;
  }

  /// Share of trades that closed at their stop or target rather than drifting
  /// to the end of the data — a proxy for following the plan through.
  double get planAdherenceRate {
    if (trades.isEmpty) return 0;
    final followed = trades
        .where(
          (e) =>
              e.outcome == TradeOutcome.stopHit ||
              e.outcome == TradeOutcome.targetHit,
        )
        .length;
    return followed / trades.length;
  }

  double get maxDrawdownFraction {
    if (equity.isEmpty) return 0;
    var peak = equity.first.balance;
    var worst = 0.0;
    for (final point in equity) {
      if (point.balance > peak) peak = point.balance;
      if (peak > 0) {
        final dd = (peak - point.balance) / peak;
        if (dd > worst) worst = dd;
      }
    }
    return worst;
  }

  Map<TradeDirection, ({int count, double totalR})> get byDirection {
    final map = <TradeDirection, ({int count, double totalR})>{};
    for (final e in trades) {
      final current = map[e.direction] ?? (count: 0, totalR: 0.0);
      map[e.direction] = (
        count: current.count + 1,
        totalR: current.totalR + e.rMultiple,
      );
    }
    return map;
  }

  Map<MistakeTag, int> get mistakeCounts {
    final map = <MistakeTag, int>{};
    for (final e in entries) {
      for (final tag in e.mistakeTags) {
        map[tag] = (map[tag] ?? 0) + 1;
      }
    }
    return map;
  }

  ({int answered, int correct}) accuracyIn(String context) {
    var answered = 0;
    var correct = 0;
    for (final a in attempts) {
      if (a.context != context) continue;
      answered++;
      if (a.correct) correct++;
    }
    return (answered: answered, correct: correct);
  }
}

final analyticsProvider = FutureProvider.autoDispose<AnalyticsData>((
  ref,
) async {
  ref.watch(learnerControllerProvider);
  final journal = ref.watch(journalRepositoryProvider);
  final progress = ref.watch(progressRepositoryProvider);
  return AnalyticsData(
    entries: await journal.loadEntries(limit: 1000),
    equity: await journal.loadEquityCurve(limit: 1000),
    account: await journal.loadAccount(),
    attempts: await progress.recentAttempts(limit: 2000),
  );
});

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.tp;
    final async = ref.watch(analyticsProvider);
    final learner = ref.watch(learnerControllerProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: SafeArea(
        top: false,
        child: async.when(
          loading: () => const TpLoadingState(),
          error: (e, _) => TpErrorState(
            message: 'Analytics could not be calculated.',
            hint: '$e',
            onRetry: () => ref.invalidate(analyticsProvider),
          ),
          data: (data) {
            if (data.entries.isEmpty) {
              return const TpEmptyState(
                icon: Icons.insights_rounded,
                title: 'Nothing to analyse yet',
                message:
                    'Complete a few simulations and this screen fills with your '
                    'risk, reward-to-risk, process scores and equity curve.',
              );
            }

            final lesson = data.accuracyIn('lesson');
            final review = data.accuracyIn('review');
            final practice = data.accuracyIn('practice');

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                Gap.lg,
                Gap.md,
                Gap.lg,
                Gap.huge,
              ),
              children: [
                const TpCallout(
                  icon: Icons.school_rounded,
                  message:
                      'These figures describe your practice in this app using virtual money. '
                      'They are a study record, not a performance claim.',
                ),
                const TpSectionHeader(
                  title: 'Process',
                  subtitle: 'The measures this app treats as most important.',
                ),
                TpCard(
                  raised: true,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TpStatTile(
                              label: 'Avg process score',
                              value: data.averageProcessScore
                                  .round()
                                  .toString(),
                              icon: Icons.verified_rounded,
                              valueColor: data.averageProcessScore >= 75
                                  ? c.bullish
                                  : data.averageProcessScore >= 50
                                  ? c.warning
                                  : c.bearish,
                            ),
                          ),
                          Expanded(
                            child: TpStatTile(
                              label: 'Risk discipline',
                              value: Fmt.percentOfRatio(
                                data.riskDisciplineRate,
                              ),
                              icon: Icons.shield_rounded,
                              caption: 'trades at or under 2%',
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: Gap.xl),
                      Row(
                        children: [
                          Expanded(
                            child: TpStatTile(
                              label: 'Plan adherence',
                              value: Fmt.percentOfRatio(data.planAdherenceRate),
                              icon: Icons.checklist_rounded,
                              caption: 'closed at stop or target',
                            ),
                          ),
                          Expanded(
                            child: TpStatTile(
                              label: 'No-trade calls',
                              value: '${data.noTradeCount}',
                              icon: Icons.pause_rounded,
                              caption: 'deliberate passes',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const TpSectionHeader(
                  title: 'Virtual equity',
                  subtitle: 'Simulated balance over your completed trades.',
                ),
                TpCard(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 160,
                        child: EquityCurveChart(
                          points: data.equity,
                          startingBalance: data.account.startingBalance,
                        ),
                      ),
                      const VGap(Gap.lg),
                      Row(
                        children: [
                          Expanded(
                            child: TpStatTile(
                              label: 'Balance',
                              value: Fmt.money(data.account.balance),
                              compact: true,
                            ),
                          ),
                          Expanded(
                            child: TpStatTile(
                              label: 'Peak',
                              value: Fmt.money(data.account.peakBalance),
                              compact: true,
                            ),
                          ),
                          Expanded(
                            child: TpStatTile(
                              label: 'Max drawdown',
                              value: Fmt.percentOfRatio(
                                data.maxDrawdownFraction,
                                decimals: 1,
                              ),
                              compact: true,
                              valueColor: data.maxDrawdownFraction > 0.2
                                  ? c.bearish
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const TpSectionHeader(title: 'Trade statistics'),
                TpCard(
                  child: Column(
                    children: [
                      TpDetailRow(
                        label: 'Simulations completed',
                        value: '${data.entries.length}',
                      ),
                      TpDetailRow(
                        label: 'Average planned risk',
                        value: Fmt.percent(
                          data.averageRiskPercent,
                          decimals: 2,
                        ),
                      ),
                      TpDetailRow(
                        label: 'Average planned R:R',
                        value: Fmt.ratio(data.averagePlannedRr),
                      ),
                      TpDetailRow(
                        label: 'Expectancy',
                        value:
                            '${data.expectancyR >= 0 ? '+' : ''}'
                            '${data.expectancyR.toStringAsFixed(2)}R per trade',
                        valueColor: data.expectancyR >= 0
                            ? c.bullish
                            : c.bearish,
                      ),
                      TpDetailRow(
                        label: 'Win rate',
                        value: Fmt.percentOfRatio(data.winRate),
                      ),
                    ],
                  ),
                ),
                const VGap(Gap.sm),
                Text(
                  'Win rate is shown last on purpose: a high win rate with small wins and large '
                  'losses still loses money. Expectancy in R is the number that matters.',
                  style: context.texts.bodySmall,
                ),
                const TpSectionHeader(title: 'Long versus short'),
                TpCard(
                  child: Column(
                    children: [
                      for (final direction in [
                        TradeDirection.long,
                        TradeDirection.short,
                      ])
                        _DirectionRow(
                          direction: direction,
                          stats: data.byDirection[direction],
                        ),
                    ],
                  ),
                ),
                if (data.mistakeCounts.isNotEmpty) ...[
                  const TpSectionHeader(
                    title: 'Most common mistakes',
                    subtitle: 'Grouped so they can actually be worked on.',
                  ),
                  TpCard(child: _MistakeBars(counts: data.mistakeCounts)),
                ],
                const TpSectionHeader(title: 'Learning accuracy'),
                TpCard(
                  child: Column(
                    children: [
                      _AccuracyRow(label: 'Lessons', stats: lesson),
                      _AccuracyRow(label: 'Review', stats: review),
                      _AccuracyRow(label: 'Practice', stats: practice),
                    ],
                  ),
                ),
                if (learner != null) ...[
                  const TpSectionHeader(title: 'Skill accuracy'),
                  TpCard(
                    child: Column(
                      children: [
                        for (final skill in Skills.all)
                          _SkillRow(mastery: learner.masteryFor(skill.id)),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DirectionRow extends StatelessWidget {
  const _DirectionRow({required this.direction, required this.stats});

  final TradeDirection direction;
  final ({int count, double totalR})? stats;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final count = stats?.count ?? 0;
    final avg = (stats == null || stats!.count == 0)
        ? 0.0
        : stats!.totalR / stats!.count;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Gap.sm),
      child: Row(
        children: [
          Icon(
            direction == TradeDirection.long
                ? Icons.north_east_rounded
                : Icons.south_east_rounded,
            size: 16,
            color: direction == TradeDirection.long ? c.bullish : c.bearish,
          ),
          const HGap(Gap.md),
          Expanded(
            child: Text(direction.label, style: context.texts.bodyMedium),
          ),
          Text('$count trades', style: context.texts.bodySmall),
          const HGap(Gap.md),
          SizedBox(
            width: 74,
            child: Text(
              count == 0
                  ? '—'
                  : '${avg >= 0 ? '+' : ''}${avg.toStringAsFixed(2)}R avg',
              textAlign: TextAlign.right,
              style: context.texts.titleSmall?.copyWith(
                color: count == 0
                    ? c.textTertiary
                    : avg >= 0
                    ? c.bullish
                    : c.bearish,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MistakeBars extends StatelessWidget {
  const _MistakeBars({required this.counts});
  final Map<MistakeTag, int> counts;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final sorted = counts.entries.toList()
      ..sort((a, b) {
        final cmp = b.value.compareTo(a.value);
        return cmp != 0 ? cmp : a.key.name.compareTo(b.key.name);
      });
    final max = sorted.isEmpty
        ? 1
        : sorted.map((e) => e.value).reduce(math.max);

    return Column(
      children: [
        for (final entry in sorted.take(6))
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key.label,
                        style: context.texts.bodyMedium,
                      ),
                    ),
                    Text('${entry.value}', style: context.texts.titleSmall),
                  ],
                ),
                const VGap(Gap.xs),
                TpProgressBar(
                  value: entry.value / max,
                  color: c.bearish,
                  height: 6,
                  label: entry.key.label,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AccuracyRow extends StatelessWidget {
  const _AccuracyRow({required this.label, required this.stats});

  final String label;
  final ({int answered, int correct}) stats;

  @override
  Widget build(BuildContext context) {
    final ratio = stats.answered == 0 ? 0.0 : stats.correct / stats.answered;
    return TpDetailRow(
      label: label,
      value: stats.answered == 0
          ? 'No answers yet'
          : '${Fmt.percentOfRatio(ratio)} of ${stats.answered}',
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({required this.mastery});
  final SkillMastery mastery;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final skill = Skills.byId(mastery.skillId);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Gap.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(skill.name, style: context.texts.bodyMedium),
              ),
              Text(
                mastery.attempts == 0
                    ? 'Not started'
                    : '${mastery.score.round()} · ${Fmt.percentOfRatio(mastery.accuracy)}',
                style: context.texts.labelMedium,
              ),
            ],
          ),
          const VGap(Gap.xs),
          TpProgressBar(
            value: mastery.score / 100,
            height: 5,
            color: mastery.score >= 65 ? c.bullish : c.progress,
            label: skill.name,
          ),
        ],
      ),
    );
  }
}
