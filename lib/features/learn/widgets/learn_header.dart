import 'package:flutter/material.dart';

import '../../../core/formatters.dart';
import '../../../design_system/components.dart';
import '../../../domain/models/user_profile.dart';
import '../learner_state.dart';

/// The compact status strip at the top of the Learn tab: streak, hearts, XP
/// and level, plus today's goal.
class LearnHeader extends StatelessWidget {
  const LearnHeader({super.key, required this.state, this.onHeartsTap});

  final LearnerState state;
  final VoidCallback? onHeartsTap;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final level = state.level;
    final streak = state.displayedStreak;

    return TpCard(
      padding: const EdgeInsets.all(Gap.lg),
      child: Column(
        children: [
          Row(
            children: [
              _Pill(
                icon: Icons.local_fire_department_rounded,
                value: '$streak',
                label: streak == 1 ? 'day' : 'days',
                color: streak > 0 ? c.streak : c.textTertiary,
                semantics: '$streak day streak',
              ),
              const HGap(Gap.sm),
              _Pill(
                icon: Icons.favorite_rounded,
                value: '${state.profile.hearts}',
                label: 'of ${UserProfile.maxHearts}',
                color: state.profile.hearts > 0 ? c.heart : c.textTertiary,
                semantics: '${state.profile.hearts} hearts remaining',
                onTap: onHeartsTap,
              ),
              const HGap(Gap.sm),
              _Pill(
                icon: Icons.bolt_rounded,
                value: Fmt.compact(state.profile.totalXp),
                label: 'XP',
                color: c.xp,
                semantics: '${state.profile.totalXp} total XP',
              ),
            ],
          ),
          const VGap(Gap.lg),
          Row(
            children: [
              TpRingProgress(
                value: level.fraction,
                size: 52,
                strokeWidth: 5,
                color: c.xp,
                child: Text(
                  '${level.level}',
                  style: context.texts.titleMedium?.copyWith(color: c.xp),
                ),
              ),
              const HGap(Gap.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Level ${level.level} · ${level.title}',
                            style: context.texts.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          level.isMaxLevel
                              ? 'Max'
                              : '${level.xpRemaining} XP to go',
                          style: context.texts.bodySmall,
                        ),
                      ],
                    ),
                    const VGap(Gap.sm),
                    TpProgressBar(
                      value: level.fraction,
                      color: c.xp,
                      label: 'Level progress',
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const VGap(Gap.md),
          Row(
            children: [
              Icon(Icons.flag_rounded, size: 14, color: c.textTertiary),
              const HGap(Gap.xs),
              Expanded(
                child: Text(
                  state.dailyGoalFraction >= 1
                      ? 'Daily goal reached'
                      : 'Daily goal · ${state.profile.dailyGoalMinutes} min',
                  style: context.texts.bodySmall,
                ),
              ),
              SizedBox(
                width: 90,
                child: TpProgressBar(
                  value: state.dailyGoalFraction,
                  height: 6,
                  color: c.accent,
                  label: 'Daily goal progress',
                ),
              ),
            ],
          ),
          if (state.streakAtRisk && streak > 0) ...[
            const VGap(Gap.md),
            TpCallout(
              tone: TpCalloutTone.warning,
              icon: Icons.schedule_rounded,
              message:
                  'Your $streak day streak needs a lesson, practice or simulation today to '
                  'continue.',
            ),
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.semantics,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final String semantics;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Expanded(
      child: Semantics(
        label: semantics,
        button: onTap != null,
        child: Material(
          color: c.surfaceSunken,
          borderRadius: BorderRadius.circular(Radii.md),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Radii.md),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: Gap.sm,
                horizontal: Gap.sm,
              ),
              child: Column(
                children: [
                  Icon(icon, size: 18, color: color),
                  const VGap(Gap.xs),
                  Text(
                    value,
                    style: context.texts.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: context.texts.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
