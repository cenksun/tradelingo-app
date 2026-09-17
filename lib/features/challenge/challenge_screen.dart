import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/app_date.dart';
import '../../design_system/components.dart';
import '../../domain/models/challenge.dart';
import '../../domain/services/challenge_generator.dart';
import '../../domain/services/league_service.dart';
import '../learn/learner_controller.dart';

/// Today's challenge, this week's goal, and the offline league.
class ChallengeState {
  const ChallengeState({
    required this.daily,
    required this.weekly,
    required this.standing,
  });

  final DailyChallenge daily;
  final WeeklyChallenge weekly;
  final LeagueStanding standing;
}

final challengeStateProvider = FutureProvider.autoDispose<ChallengeState>((
  ref,
) async {
  final learner = ref.watch(learnerControllerProvider).value;
  final now = ref.watch(clockProvider)();
  final curriculum = ref.watch(curriculumProvider);
  final repo = ref.watch(challengeRepositoryProvider);

  final dayKey = AppDate.dayKey(now);
  final generated = ChallengeGenerator.daily(date: now, curriculum: curriculum);
  final stored = await repo.loadDaily(dayKey);
  final daily = stored == null
      ? generated
      : generated.copyWith(
          completedTaskCount: stored.completedTaskCount,
          completed: stored.completed,
        );
  if (stored == null) await repo.saveDaily(daily);

  final weekKey = AppDate.weekKey(now);
  final weeklyTemplate = ChallengeGenerator.weekly(now);
  final storedWeekly = await repo.loadWeekly(weekKey);
  final weekly = storedWeekly == null
      ? weeklyTemplate
      : weeklyTemplate.copyWith(
          progress: storedWeekly.progress,
          completed: storedWeekly.completed,
        );
  if (storedWeekly == null) await repo.saveWeekly(weekly);

  final league = await repo.loadLeague();
  final standing = LeagueService.standing(
    tier: league.tier,
    now: now,
    weeklyXp: league.weekKey == weekKey ? league.weeklyXp : 0,
    playerName: learner?.profile.username ?? 'You',
  );

  return ChallengeState(daily: daily, weekly: weekly, standing: standing);
});

class ChallengeScreen extends ConsumerWidget {
  const ChallengeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.tp;
    final async = ref.watch(challengeStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Challenge')),
      body: SafeArea(
        top: false,
        child: async.when(
          loading: () => const TpLoadingState(),
          error: (e, _) => TpErrorState(
            message: 'Challenges could not be prepared.',
            hint: '$e',
            onRetry: () => ref.invalidate(challengeStateProvider),
          ),
          data: (state) => ListView(
            padding: const EdgeInsets.fromLTRB(
              Gap.lg,
              Gap.md,
              Gap.lg,
              Gap.huge,
            ),
            children: [
              TpCard(
                raised: true,
                accent: state.daily.completed ? c.bullish : c.accent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          state.daily.completed
                              ? Icons.check_circle_rounded
                              : Icons.today_rounded,
                          color: state.daily.completed ? c.bullish : c.accent,
                        ),
                        const HGap(Gap.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daily challenge',
                                style: context.texts.titleMedium,
                              ),
                              Text(
                                state.daily.dayKey,
                                style: context.texts.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        TpBadge(
                          label: '+${state.daily.xpReward} XP',
                          color: c.xp,
                          dense: true,
                        ),
                      ],
                    ),
                    const VGap(Gap.md),
                    Text(
                      '${state.daily.tasks.length} mixed exercises drawn from the '
                      'whole curriculum, plus one simulation. The set is the same '
                      'on every device today.',
                      style: context.texts.bodySmall,
                    ),
                    const VGap(Gap.md),
                    for (final task in state.daily.tasks)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Gap.sm),
                        child: Row(
                          children: [
                            Icon(
                              switch (task.kind) {
                                ChallengeTaskKind.simulation =>
                                  Icons.candlestick_chart_rounded,
                                ChallengeTaskKind.structureQuestion =>
                                  Icons.timeline_rounded,
                                ChallengeTaskKind.riskQuestion =>
                                  Icons.balance_rounded,
                                _ => Icons.quiz_rounded,
                              },
                              size: 15,
                              color: c.textTertiary,
                            ),
                            const HGap(Gap.sm),
                            Expanded(
                              child: Text(
                                task.label,
                                style: context.texts.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const VGap(Gap.md),
                    if (state.daily.completed)
                      Row(
                        children: [
                          Icon(Icons.check_rounded, size: 16, color: c.bullish),
                          const HGap(Gap.sm),
                          Text(
                            'Completed today. Come back tomorrow for a new set.',
                            style: context.texts.bodySmall,
                          ),
                        ],
                      )
                    else
                      TpButton.primary(
                        label: 'Start daily challenge',
                        onPressed: () => context.push('/challenge/daily'),
                      ),
                  ],
                ),
              ),
              const TpSectionHeader(title: 'This week'),
              TpCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            state.weekly.title.isEmpty
                                ? 'Weekly goal'
                                : state.weekly.title,
                            style: context.texts.titleMedium,
                          ),
                        ),
                        TpBadge(
                          label: '+${state.weekly.xpReward} XP',
                          color: c.xp,
                          dense: true,
                        ),
                      ],
                    ),
                    const VGap(Gap.sm),
                    Text(
                      '${state.weekly.target} ${state.weekly.metric.description}',
                      style: context.texts.bodyMedium,
                    ),
                    const VGap(Gap.md),
                    TpProgressBar(
                      value: state.weekly.fraction,
                      color: c.progress,
                      label: 'Weekly goal progress',
                    ),
                    const VGap(Gap.sm),
                    Text(
                      '${state.weekly.progress} of ${state.weekly.target}',
                      style: context.texts.labelSmall,
                    ),
                  ],
                ),
              ),
              const TpSectionHeader(
                title: 'League',
                subtitle: 'Ranked by learning XP, not by simulated profit.',
              ),
              _LeagueCard(standing: state.standing),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeagueCard extends StatelessWidget {
  const _LeagueCard({required this.standing});

  final LeagueStanding standing;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return TpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_rounded, color: c.accent),
              const HGap(Gap.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${standing.tier.label} league',
                      style: context.texts.titleMedium,
                    ),
                    Text(
                      'Week ${standing.weekKey} · rank ${standing.playerRank} of '
                      '${standing.entries.length}',
                      style: context.texts.bodySmall,
                    ),
                  ],
                ),
              ),
              if (standing.inPromotionZone)
                TpBadge(label: 'Promotion', color: c.bullish, dense: true)
              else if (standing.inRelegationZone)
                TpBadge(label: 'Relegation', color: c.bearish, dense: true),
            ],
          ),
          const VGap(Gap.lg),
          for (var i = 0; i < standing.entries.length; i++)
            _LeagueRow(
              rank: i + 1,
              entry: standing.entries[i],
              promotion: i + 1 <= standing.promotionRank,
              relegation: i + 1 >= standing.relegationRank,
            ),
          const VGap(Gap.lg),
          TpCallout(
            icon: Icons.info_outline_rounded,
            tone: TpCalloutTone.neutral,
            message: LeagueService.disclaimer,
          ),
        ],
      ),
    );
  }
}

class _LeagueRow extends StatelessWidget {
  const _LeagueRow({
    required this.rank,
    required this.entry,
    required this.promotion,
    required this.relegation,
  });

  final int rank;
  final LeagueEntry entry;
  final bool promotion;
  final bool relegation;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Container(
      margin: const EdgeInsets.only(bottom: Gap.xs),
      padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: Gap.sm),
      decoration: BoxDecoration(
        color: entry.isPlayer ? c.accentSoft : Colors.transparent,
        borderRadius: BorderRadius.circular(Radii.sm),
        border: Border.all(
          color: entry.isPlayer ? c.accent : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$rank',
              style: context.texts.labelMedium?.copyWith(
                color: promotion
                    ? c.bullish
                    : relegation
                    ? c.bearish
                    : c.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              entry.name,
              style: entry.isPlayer
                  ? context.texts.titleSmall
                  : context.texts.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text('${entry.xp} XP', style: context.texts.labelMedium),
        ],
      ),
    );
  }
}
