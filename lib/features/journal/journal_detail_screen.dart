import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/formatters.dart';
import '../../design_system/components.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/scenario.dart';
import '../learn/learner_controller.dart';

final journalEntryProvider = FutureProvider.autoDispose
    .family<JournalEntry?, String>((ref, id) async {
      ref.watch(learnerControllerProvider);
      return ref.watch(journalRepositoryProvider).entryById(id);
    });

class JournalDetailScreen extends ConsumerStatefulWidget {
  const JournalDetailScreen({super.key, required this.entryId});

  final String entryId;

  @override
  ConsumerState<JournalDetailScreen> createState() =>
      _JournalDetailScreenState();
}

class _JournalDetailScreenState extends ConsumerState<JournalDetailScreen> {
  final _noteController = TextEditingController();
  bool _initialised = false;
  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save(JournalEntry entry, {bool? favourite}) async {
    setState(() => _saving = true);
    await ref
        .read(learnerControllerProvider.notifier)
        .addJournalNote(
          entry.copyWith(
            note: _noteController.text,
            favourite: favourite ?? entry.favourite,
          ),
        );
    ref.invalidate(journalEntryProvider(widget.entryId));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Journal entry saved.')));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final async = ref.watch(journalEntryProvider(widget.entryId));

    return Scaffold(
      appBar: AppBar(title: const Text('Trade detail')),
      body: SafeArea(
        top: false,
        child: async.when(
          loading: () => const TpLoadingState(),
          error: (e, _) => TpErrorState(
            message: 'This entry could not be loaded.',
            hint: '$e',
            onRetry: () => ref.invalidate(journalEntryProvider(widget.entryId)),
          ),
          data: (entry) {
            if (entry == null) {
              return TpEmptyState(
                icon: Icons.search_off_rounded,
                title: 'Entry not found',
                message: 'This journal entry no longer exists.',
                actionLabel: 'Back to journal',
                onAction: () => context.pop(),
              );
            }
            if (!_initialised) {
              _noteController.text = entry.note;
              _initialised = true;
            }

            final resultColor = entry.isNoTrade
                ? c.neutralTrend
                : entry.isWin
                ? c.bullish
                : c.bearish;

            return ListView(
              padding: const EdgeInsets.fromLTRB(
                Gap.lg,
                Gap.md,
                Gap.lg,
                Gap.huge,
              ),
              children: [
                TpCard(
                  raised: true,
                  accent: resultColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            entry.direction.label,
                            style: context.texts.headlineSmall,
                          ),
                          const HGap(Gap.md),
                          TpBadge(
                            label: entry.outcome.label,
                            color: resultColor,
                            dense: true,
                          ),
                          const Spacer(),
                          TpIconButton(
                            icon: entry.favourite
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            tooltip: entry.favourite
                                ? 'Remove bookmark'
                                : 'Bookmark this trade',
                            color: entry.favourite ? c.warning : null,
                            onPressed: () =>
                                _save(entry, favourite: !entry.favourite),
                          ),
                        ],
                      ),
                      const VGap(Gap.xs),
                      Text(
                        '${entry.assetSymbol} · ${entry.timeframeName} · '
                        '${entry.difficulty.label}',
                        style: context.texts.bodySmall,
                      ),
                      const VGap(Gap.xs),
                      Text(
                        'Scenario ${entry.scenarioId} · '
                        '${Fmt.dateTime(entry.completedAt)}',
                        style: context.texts.labelSmall,
                      ),
                    ],
                  ),
                ),
                const TpSectionHeader(title: 'The plan'),
                TpCard(
                  child: Column(
                    children: [
                      TpDetailRow(
                        label: 'Entry',
                        value: entry.isNoTrade ? '—' : Fmt.price(entry.entry),
                      ),
                      TpDetailRow(
                        label: 'Stop loss',
                        value: entry.isNoTrade
                            ? '—'
                            : Fmt.price(entry.stopLoss),
                        valueColor: c.stopLine,
                      ),
                      TpDetailRow(
                        label: 'Take profit',
                        value: entry.isNoTrade
                            ? '—'
                            : Fmt.price(entry.takeProfit),
                        valueColor: c.targetLine,
                      ),
                      TpDetailRow(
                        label: 'Planned risk',
                        value: entry.isNoTrade
                            ? '—'
                            : Fmt.percent(entry.riskPercent, decimals: 2),
                      ),
                      TpDetailRow(
                        label: 'Position size',
                        value: entry.isNoTrade
                            ? '—'
                            : '${entry.positionSize.toStringAsFixed(4)} units',
                      ),
                      TpDetailRow(
                        label: 'Planned reward-to-risk',
                        value: entry.isNoTrade
                            ? '—'
                            : Fmt.ratio(entry.rewardToRisk),
                      ),
                    ],
                  ),
                ),
                const TpSectionHeader(title: 'The result'),
                TpCard(
                  child: Column(
                    children: [
                      TpDetailRow(label: 'Outcome', value: entry.outcome.label),
                      TpDetailRow(
                        label: 'R multiple',
                        value: entry.isNoTrade
                            ? '—'
                            : Fmt.rMultiple(entry.rMultiple),
                        valueColor: resultColor,
                      ),
                      TpDetailRow(
                        label: 'Virtual P&L',
                        value: entry.isNoTrade
                            ? '—'
                            : Fmt.signedMoney(entry.profitLoss),
                        valueColor: resultColor,
                      ),
                      TpDetailRow(
                        label: 'Process score',
                        value: '${entry.processScore.round()} / 100',
                        valueColor: entry.processScore >= 75
                            ? c.bullish
                            : entry.processScore >= 50
                            ? c.warning
                            : c.bearish,
                      ),
                      if (entry.ambiguousClose)
                        const TpDetailRow(
                          label: 'Close',
                          value: 'Ambiguous candle — stop applied',
                        ),
                    ],
                  ),
                ),
                if (entry.mistakeTags.isNotEmpty) ...[
                  const TpSectionHeader(title: 'Tags'),
                  Wrap(
                    spacing: Gap.sm,
                    runSpacing: Gap.sm,
                    children: [
                      for (final tag in entry.mistakeTags)
                        TpBadge(
                          label: tag.label,
                          color: c.bearish,
                          dense: true,
                        ),
                    ],
                  ),
                  const VGap(Gap.md),
                  for (final tag in entry.mistakeTags)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Gap.sm),
                      child: Text(
                        '${tag.label}: ${tag.description}',
                        style: context.texts.bodySmall,
                      ),
                    ),
                ],
                if (entry.features.isNotEmpty) ...[
                  const TpSectionHeader(
                    title: 'Chart features',
                    subtitle:
                        'Classifications of what the chart had already done.',
                  ),
                  Wrap(
                    spacing: Gap.sm,
                    runSpacing: Gap.sm,
                    children: [
                      for (final f in entry.features)
                        TpBadge(
                          label: ScenarioFeatureLabel.of(f),
                          dense: true,
                          color: c.textTertiary,
                        ),
                    ],
                  ),
                ],
                const TpSectionHeader(
                  title: 'Your notes',
                  subtitle: 'The part a machine cannot fill in: what you were thinking.',
                ),
                TextField(
                  controller: _noteController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    hintText:
                        'Why did you take this? What would you do differently?',
                    alignLabelWithHint: true,
                  ),
                ),
                const VGap(Gap.md),
                TpButton.primary(
                  label: 'Save note',
                  busy: _saving,
                  onPressed: () => _save(entry),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Turns a stored feature name back into a readable label.
class ScenarioFeatureLabel {
  const ScenarioFeatureLabel._();

  static String of(String name) {
    final feature = ScenarioFeature.fromName(name);
    return feature?.label ?? name;
  }
}
