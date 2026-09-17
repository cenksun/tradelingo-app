import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/formatters.dart';
import '../../design_system/components.dart';
import '../../domain/models/skill.dart';
import '../../domain/services/mastery_engine.dart';
import '../../shared/avatars.dart';
import '../../shared/icon_catalog.dart';
import '../learn/learner_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.tp;
    final state = ref.watch(learnerControllerProvider).value;
    final curriculum = ref.watch(curriculumProvider);

    if (state == null) return const Scaffold(body: TpLoadingState());

    final level = state.level;
    final achievements = ref.watch(achievementProgressProvider);
    final unlocked = achievements.where((a) => a.unlocked).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          TpIconButton(
            icon: Icons.settings_rounded,
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, Gap.huge),
          children: [
            TpCard(
              raised: true,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: c.accentSoft,
                          shape: BoxShape.circle,
                          border: Border.all(color: c.accent, width: 2),
                        ),
                        child: Icon(
                          Avatars.iconFor(state.profile.avatarId),
                          color: c.accent,
                          size: 30,
                        ),
                      ),
                      const HGap(Gap.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.profile.username,
                              style: context.texts.headlineSmall,
                            ),
                            const VGap(Gap.xxs),
                            Text(
                              'Level ${level.level} · ${level.title}',
                              style: context.texts.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      TpIconButton(
                        icon: Icons.edit_rounded,
                        tooltip: 'Edit profile',
                        onPressed: () => _editProfile(context, ref, state),
                      ),
                    ],
                  ),
                  const VGap(Gap.lg),
                  TpProgressBar(
                    value: level.fraction,
                    color: c.xp,
                    label: 'Level progress',
                  ),
                  const VGap(Gap.sm),
                  Row(
                    children: [
                      Text(
                        '${state.profile.totalXp} XP total',
                        style: context.texts.bodySmall,
                      ),
                      const Spacer(),
                      Text(
                        level.isMaxLevel
                            ? 'Maximum level'
                            : '${level.xpRemaining} XP to level ${level.level + 1}',
                        style: context.texts.bodySmall,
                      ),
                    ],
                  ),
                  const VGap(Gap.xs),
                  Text(
                    'Titles are progress labels inside TradePath. They are not a '
                    'qualification or a statement of trading ability.',
                    style: context.texts.labelSmall,
                  ),
                ],
              ),
            ),
            const VGap(Gap.lg),
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    icon: Icons.local_fire_department_rounded,
                    color: c.streak,
                    value: '${state.displayedStreak}',
                    label: 'Day streak',
                  ),
                ),
                const HGap(Gap.md),
                Expanded(
                  child: _MiniStat(
                    icon: Icons.emoji_events_rounded,
                    color: c.warning,
                    value: '${state.streak.longest}',
                    label: 'Longest',
                  ),
                ),
                const HGap(Gap.md),
                Expanded(
                  child: _MiniStat(
                    icon: Icons.calendar_month_rounded,
                    color: c.info,
                    value: '${state.streak.totalActiveDays}',
                    label: 'Active days',
                  ),
                ),
              ],
            ),
            const TpSectionHeader(title: 'Learning'),
            TpCard(
              child: Column(
                children: [
                  TpDetailRow(
                    label: 'Lessons completed',
                    value:
                        '${state.stats.lessonsCompleted} of ${curriculum.lessonCount}',
                  ),
                  TpDetailRow(
                    label: 'Perfect lessons',
                    value: '${state.stats.perfectLessons}',
                  ),
                  TpDetailRow(
                    label: 'Boss challenges passed',
                    value:
                        '${state.stats.bossesPassed} of ${curriculum.worlds.length}',
                  ),
                  TpDetailRow(
                    label: 'Worlds completed',
                    value:
                        '${state.stats.worldsCompleted} of ${curriculum.worlds.length}',
                  ),
                  TpDetailRow(
                    label: 'Questions answered',
                    value: '${state.stats.questionsAnswered}',
                  ),
                  TpDetailRow(
                    label: 'Overall accuracy',
                    value: state.stats.questionsAnswered == 0
                        ? '—'
                        : Fmt.percentOfRatio(state.stats.accuracy),
                  ),
                  TpDetailRow(
                    label: 'Concepts in review',
                    value: '${state.reviewItems.length}',
                  ),
                ],
              ),
            ),
            const TpSectionHeader(title: 'Simulator'),
            TpCard(
              child: Column(
                children: [
                  TpDetailRow(
                    label: 'Simulations completed',
                    value: '${state.account.tradeCount}',
                  ),
                  TpDetailRow(
                    label: 'Virtual balance',
                    value: Fmt.money(state.account.balance),
                  ),
                  TpDetailRow(
                    label: 'No-trade decisions',
                    value: '${state.noTradeDecisions}',
                  ),
                  TpDetailRow(
                    label: 'Disciplined trades',
                    value: '${state.disciplinedTrades}',
                  ),
                  TpDetailRow(
                    label: 'Journal notes written',
                    value: '${state.journalNotes}',
                  ),
                ],
              ),
            ),
            TpSectionHeader(
              title: 'Skill mastery',
              subtitle: 'Separate from XP: this moves down as well as up.',
              trailing: TextButton(
                onPressed: () => context.push('/practice'),
                child: const Text('Practise'),
              ),
            ),
            TpCard(
              child: Column(
                children: [
                  for (final skill in Skills.all)
                    _MasteryRow(
                      skill: skill,
                      mastery: state.masteryFor(skill.id),
                    ),
                ],
              ),
            ),
            TpSectionHeader(
              title: 'Achievements',
              subtitle: '$unlocked of ${achievements.length} unlocked',
              trailing: TextButton(
                onPressed: () => context.push('/achievements'),
                child: const Text('See all'),
              ),
            ),
            Wrap(
              spacing: Gap.sm,
              runSpacing: Gap.sm,
              children: [
                for (final a in achievements.where((a) => a.unlocked).take(8))
                  TpBadge(
                    label: a.achievement.title,
                    icon: IconCatalog.forAchievement(a.achievement),
                    color: c.warning,
                  ),
                if (unlocked == 0)
                  Text(
                    'None yet — the first one arrives after your first lesson.',
                    style: context.texts.bodySmall,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editProfile(
    BuildContext context,
    WidgetRef ref,
    dynamic state,
  ) async {
    final controller = TextEditingController(text: state.profile.username);
    var avatar = state.profile.avatarId as String;

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.fromLTRB(
            Gap.lg,
            Gap.lg,
            Gap.lg,
            MediaQuery.viewInsetsOf(context).bottom + Gap.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Edit profile', style: context.texts.titleLarge),
              const VGap(Gap.lg),
              TextField(
                controller: controller,
                maxLength: 20,
                decoration: const InputDecoration(
                  labelText: 'Display name',
                  counterText: '',
                ),
              ),
              const VGap(Gap.lg),
              Wrap(
                spacing: Gap.md,
                runSpacing: Gap.md,
                children: [
                  for (final entry in Avatars.all)
                    InkWell(
                      onTap: () => setState(() => avatar = entry.$1),
                      borderRadius: BorderRadius.circular(Radii.pill),
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: avatar == entry.$1
                              ? context.tp.accentSoft
                              : context.tp.surfaceSunken,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: avatar == entry.$1
                                ? context.tp.accent
                                : context.tp.border,
                          ),
                        ),
                        child: Icon(
                          entry.$2,
                          color: avatar == entry.$1
                              ? context.tp.accent
                              : context.tp.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
              const VGap(Gap.xl),
              TpButton.primary(
                label: 'Save',
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ),
      ),
    );

    if (saved == true) {
      await ref
          .read(learnerControllerProvider.notifier)
          .updateProfile(
            state.profile.copyWith(
              username: controller.text.trim().isEmpty
                  ? 'Trader'
                  : controller.text.trim(),
              avatarId: avatar,
            ),
          );
    }
    controller.dispose();
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TpCard(
      padding: const EdgeInsets.symmetric(vertical: Gap.md),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const VGap(Gap.xs),
          Text(value, style: context.texts.titleLarge),
          Text(
            label,
            style: context.texts.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MasteryRow extends StatelessWidget {
  const _MasteryRow({required this.skill, required this.mastery});

  final Skill skill;
  final SkillMastery mastery;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Gap.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                IconCatalog.forSkill(skill.id),
                size: 16,
                color: c.textTertiary,
              ),
              const HGap(Gap.sm),
              Expanded(
                child: Text(skill.name, style: context.texts.bodyMedium),
              ),
              TpBadge(
                label: mastery.band.label,
                dense: true,
                color: switch (mastery.score) {
                  >= 85 => c.bullish,
                  >= 65 => c.accent,
                  >= 40 => c.warning,
                  _ => c.textTertiary,
                },
              ),
            ],
          ),
          const VGap(Gap.xs),
          TpProgressBar(
            value: mastery.score / 100,
            height: 6,
            color: mastery.score >= 65 ? c.bullish : c.progress,
            label: skill.name,
          ),
          const VGap(Gap.xs),
          Text(
            MasteryEngine.describe(mastery),
            style: context.texts.labelSmall,
          ),
        ],
      ),
    );
  }
}
