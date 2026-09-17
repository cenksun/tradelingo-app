import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/formatters.dart';
import '../../design_system/components.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/journal_entry.dart';
import '../learn/learner_controller.dart';

final journalEntriesProvider = FutureProvider.autoDispose<List<JournalEntry>>((
  ref,
) async {
  // Rebuild whenever learner state changes, so a new simulation appears here.
  ref.watch(learnerControllerProvider);
  return ref.watch(journalRepositoryProvider).loadEntries();
});

final journalFilterProvider =
    NotifierProvider<JournalFilterNotifier, JournalFilter>(
      JournalFilterNotifier.new,
    );

class JournalFilterNotifier extends Notifier<JournalFilter> {
  @override
  JournalFilter build() => const JournalFilter();

  void set(JournalFilter filter) => state = filter;
  void clear() => state = const JournalFilter();
}

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalEntriesProvider);
    final filter = ref.watch(journalFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [
          TpIconButton(
            icon: Icons.insights_rounded,
            tooltip: 'Analytics',
            onPressed: () => context.push('/analytics'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: entriesAsync.when(
          loading: () => const TpLoadingState(),
          error: (e, _) => TpErrorState(
            message: 'Your journal could not be loaded.',
            hint: '$e',
            onRetry: () => ref.invalidate(journalEntriesProvider),
          ),
          data: (all) {
            final entries = all.where(filter.matches).toList(growable: false);
            return Column(
              children: [
                _FilterBar(
                  filter: filter,
                  total: all.length,
                  shown: entries.length,
                ),
                Expanded(
                  child: all.isEmpty
                      ? TpEmptyState(
                          icon: Icons.menu_book_rounded,
                          title: 'No entries yet',
                          message:
                              'Every simulation you complete is written here '
                              'automatically, with its levels, risk, result and '
                              'process score.',
                          actionLabel: 'Run a simulation',
                          onAction: () => context.push('/simulate/run'),
                        )
                      : entries.isEmpty
                      ? TpEmptyState(
                          icon: Icons.filter_alt_off_rounded,
                          title: 'Nothing matches',
                          message: 'No entries match the filters you have set.',
                          actionLabel: 'Clear filters',
                          onAction: () =>
                              ref.read(journalFilterProvider.notifier).clear(),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            Gap.lg,
                            Gap.sm,
                            Gap.lg,
                            Gap.huge,
                          ),
                          itemCount: entries.length,
                          itemBuilder: (context, i) => Padding(
                            padding: const EdgeInsets.only(bottom: Gap.md),
                            child: JournalTile(entry: entries[i]),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar({
    required this.filter,
    required this.total,
    required this.shown,
  });

  final JournalFilter filter;
  final int total;
  final int shown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(journalFilterProvider.notifier);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Gap.lg, 0, Gap.lg, Gap.sm),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search notes, tags and instruments',
              prefixIcon: Icon(Icons.search_rounded),
              isDense: true,
            ),
            onChanged: (v) => notifier.set(filter.copyWith(search: v)),
          ),
        ),
        SizedBox(
          height: 46,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Gap.lg),
            children: [
              TpFilterChip(
                label: 'Long',
                selected: filter.direction == TradeDirection.long,
                onTap: () => notifier.set(
                  filter.direction == TradeDirection.long
                      ? filter.copyWith(clearDirection: true)
                      : filter.copyWith(direction: TradeDirection.long),
                ),
              ),
              const HGap(Gap.sm),
              TpFilterChip(
                label: 'Short',
                selected: filter.direction == TradeDirection.short,
                onTap: () => notifier.set(
                  filter.direction == TradeDirection.short
                      ? filter.copyWith(clearDirection: true)
                      : filter.copyWith(direction: TradeDirection.short),
                ),
              ),
              const HGap(Gap.sm),
              for (final r in JournalResultFilter.values) ...[
                TpFilterChip(
                  label: r.label,
                  selected: filter.result == r,
                  onTap: () => notifier.set(
                    filter.result == r
                        ? filter.copyWith(clearResult: true)
                        : filter.copyWith(result: r),
                  ),
                ),
                const HGap(Gap.sm),
              ],
              TpFilterChip(
                label: 'Favourites',
                icon: Icons.star_outline_rounded,
                selected: filter.favouritesOnly,
                onTap: () => notifier.set(
                  filter.copyWith(favouritesOnly: !filter.favouritesOnly),
                ),
              ),
              const HGap(Gap.sm),
              for (final d in Difficulty.values) ...[
                TpFilterChip(
                  label: d.label,
                  selected: filter.difficulty == d,
                  onTap: () => notifier.set(
                    filter.difficulty == d
                        ? filter.copyWith(clearDifficulty: true)
                        : filter.copyWith(difficulty: d),
                  ),
                ),
                const HGap(Gap.sm),
              ],
              for (final tag in MistakeTag.values) ...[
                TpFilterChip(
                  label: tag.label,
                  selected: filter.mistakeTag == tag,
                  onTap: () => notifier.set(
                    filter.mistakeTag == tag
                        ? filter.copyWith(clearMistake: true)
                        : filter.copyWith(mistakeTag: tag),
                  ),
                ),
                const HGap(Gap.sm),
              ],
            ],
          ),
        ),
        if (!filter.isEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.xs, Gap.lg, Gap.xs),
            child: Row(
              children: [
                Text(
                  'Showing $shown of $total',
                  style: context.texts.labelSmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: notifier.clear,
                  child: const Text('Clear filters'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class JournalTile extends StatelessWidget {
  const JournalTile({super.key, required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final resultColor = entry.isNoTrade
        ? c.neutralTrend
        : entry.isWin
        ? c.bullish
        : c.bearish;

    return TpCard(
      onTap: () => context.push('/journal/${entry.id}'),
      accent: resultColor,
      semanticLabel:
          '${entry.direction.label} on ${entry.assetSymbol}, '
          '${entry.outcome.label}, process score ${entry.processScore.round()}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                entry.isNoTrade
                    ? Icons.pause_rounded
                    : entry.direction == TradeDirection.long
                    ? Icons.north_east_rounded
                    : Icons.south_east_rounded,
                size: 16,
                color: resultColor,
              ),
              const HGap(Gap.sm),
              Text(entry.direction.label, style: context.texts.titleSmall),
              const HGap(Gap.sm),
              Expanded(
                child: Text(
                  '${entry.assetSymbol} · ${entry.timeframeName}',
                  style: context.texts.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (entry.favourite)
                Icon(Icons.star_rounded, size: 16, color: c.warning),
            ],
          ),
          const VGap(Gap.md),
          Row(
            children: [
              Expanded(
                child: TpStatTile(
                  label: 'Result',
                  value: entry.isNoTrade
                      ? 'No trade'
                      : Fmt.rMultiple(entry.rMultiple),
                  compact: true,
                  valueColor: resultColor,
                ),
              ),
              Expanded(
                child: TpStatTile(
                  label: 'Process',
                  value: '${entry.processScore.round()}',
                  compact: true,
                  valueColor: entry.processScore >= 75
                      ? c.bullish
                      : entry.processScore >= 50
                      ? c.warning
                      : c.bearish,
                ),
              ),
              Expanded(
                child: TpStatTile(
                  label: 'Risk',
                  value: entry.isNoTrade
                      ? '—'
                      : Fmt.percent(entry.riskPercent, decimals: 1),
                  compact: true,
                ),
              ),
              Expanded(
                child: TpStatTile(
                  label: 'R:R',
                  value: entry.isNoTrade ? '—' : Fmt.ratio(entry.rewardToRisk),
                  compact: true,
                ),
              ),
            ],
          ),
          if (entry.mistakeTags.isNotEmpty) ...[
            const VGap(Gap.md),
            Wrap(
              spacing: Gap.xs,
              runSpacing: Gap.xs,
              children: [
                for (final tag in entry.mistakeTags)
                  TpBadge(label: tag.label, dense: true, color: c.bearish),
              ],
            ),
          ],
          const VGap(Gap.sm),
          Row(
            children: [
              Text(
                Fmt.dateTime(entry.completedAt),
                style: context.texts.labelSmall,
              ),
              const Spacer(),
              if (entry.note.trim().isNotEmpty)
                Icon(
                  Icons.sticky_note_2_rounded,
                  size: 14,
                  color: c.textTertiary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
