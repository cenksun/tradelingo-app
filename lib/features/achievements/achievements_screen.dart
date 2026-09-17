import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/components.dart';
import '../../shared/icon_catalog.dart';
import '../learn/learner_controller.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.tp;
    final items = ref.watch(achievementProgressProvider);
    final unlocked = items.where((a) => a.unlocked).toList();
    final locked = items.where((a) => !a.unlocked).toList()
      ..sort((a, b) => b.fraction.compareTo(a.fraction));

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: SafeArea(
        top: false,
        child: items.isEmpty
            ? const TpLoadingState()
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  Gap.lg,
                  Gap.md,
                  Gap.lg,
                  Gap.huge,
                ),
                children: [
                  TpCard(
                    raised: true,
                    child: Row(
                      children: [
                        TpRingProgress(
                          value: unlocked.length / items.length,
                          size: 56,
                          strokeWidth: 6,
                          color: c.warning,
                          child: Text(
                            '${unlocked.length}',
                            style: context.texts.titleMedium,
                          ),
                        ),
                        const HGap(Gap.lg),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${unlocked.length} of ${items.length} unlocked',
                                style: context.texts.titleMedium,
                              ),
                              const VGap(Gap.xxs),
                              Text(
                                'Achievements track study habits — consistency, '
                                'review and risk discipline.',
                                style: context.texts.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (unlocked.isNotEmpty) ...[
                    const TpSectionHeader(title: 'Unlocked'),
                    for (final a in unlocked)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Gap.md),
                        child: _AchievementTile(item: a),
                      ),
                  ],
                  const TpSectionHeader(title: 'In progress'),
                  for (final a in locked)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Gap.md),
                      child: _AchievementTile(item: a),
                    ),
                ],
              ),
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final unlocked = item.unlocked as bool;
    final achievement = item.achievement;

    return TpCard(
      accent: unlocked ? c.warning : null,
      semanticLabel:
          '${achievement.title}. ${unlocked ? 'Unlocked' : 'Progress ${item.progressLabel}'}',
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: unlocked
                  ? c.warning.withValues(alpha: 0.16)
                  : c.surfaceSunken,
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Icon(
              unlocked
                  ? IconCatalog.forAchievement(achievement)
                  : Icons.lock_outline_rounded,
              color: unlocked ? c.warning : c.textTertiary,
              size: 22,
            ),
          ),
          const HGap(Gap.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title as String,
                  style: context.texts.titleSmall?.copyWith(
                    color: unlocked ? c.textPrimary : c.textSecondary,
                  ),
                ),
                const VGap(Gap.xxs),
                Text(
                  achievement.description as String,
                  style: context.texts.bodySmall,
                ),
                if (!unlocked) ...[
                  const VGap(Gap.sm),
                  TpProgressBar(
                    value: item.fraction as double,
                    height: 5,
                    label: achievement.title as String,
                  ),
                  const VGap(Gap.xs),
                  Text(
                    item.progressLabel as String,
                    style: context.texts.labelSmall,
                  ),
                ],
              ],
            ),
          ),
          if (unlocked) Icon(Icons.check_circle_rounded, color: c.warning),
        ],
      ),
    );
  }
}
