import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design_system/components.dart';
import '../../domain/models/skill.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/services/recommendation_engine.dart';
import '../../app/providers.dart';
import '../../shared/icon_catalog.dart';
import '../learn/learner_controller.dart';

class PracticeHubScreen extends ConsumerWidget {
  const PracticeHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.tp;
    final state = ref.watch(learnerControllerProvider).value;
    final coach = ref.watch(coachServiceProvider);

    if (state == null) {
      return const Scaffold(body: TpLoadingState());
    }

    final due = state.dueReviewCount;
    final weakest = RecommendationEngine.weakestSkills(
      state.mastery.values.toList(),
      limit: 3,
    );
    final suggestion = coach.practiceSuggestion(
      masteries: state.mastery.values.toList(),
      recentMistakes: const [],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, Gap.huge),
          children: [
            TpCard(
              raised: true,
              accent: c.info,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.psychology_rounded, color: c.info, size: 18),
                      const HGap(Gap.sm),
                      Text(
                        suggestion.headline,
                        style: context.texts.titleSmall,
                      ),
                    ],
                  ),
                  const VGap(Gap.sm),
                  Text(suggestion.body, style: context.texts.bodySmall),
                ],
              ),
            ),
            if (state.profile.hearts < UserProfile.maxHearts) ...[
              const VGap(Gap.lg),
              _PracticeCard(
                icon: Icons.favorite_rounded,
                color: c.heart,
                title: 'Practice for hearts',
                body:
                    'Answer a short set of review questions to get hearts back. '
                    'Wrong answers here do not cost anything.',
                badge: '${state.profile.hearts}/${UserProfile.maxHearts}',
                onTap: () => context.push('/practice/hearts'),
              ),
            ],
            const TpSectionHeader(
              title: 'Targeted practice',
              subtitle: 'Each mode draws from your weakest concepts first.',
            ),
            _PracticeCard(
              icon: Icons.replay_rounded,
              color: c.progress,
              title: 'Review queue',
              body: due == 0
                  ? 'Nothing is due right now. This fills up as you answer '
                        'questions and get some wrong.'
                  : '$due ${due == 1 ? 'concept is' : 'concepts are'} scheduled '
                        'for today.',
              badge: due == 0 ? null : '$due',
              onTap: () => context.push('/practice/review'),
            ),
            const VGap(Gap.md),
            _PracticeCard(
              icon: Icons.error_outline_rounded,
              color: c.bearish,
              title: 'Your mistakes',
              body: 'Questions on the exact concepts you have been getting wrong.',
              onTap: () => context.push('/practice/mistakes'),
            ),
            const VGap(Gap.md),
            _PracticeCard(
              icon: Icons.trending_down_rounded,
              color: c.warning,
              title: 'Weak skills',
              body: weakest.isEmpty
                  ? 'Answer a few more questions and this will target something '
                        'specific.'
                  : 'Currently focused on ${Skills.byId(weakest.first.skillId).name}.',
              onTap: () => context.push('/practice/weak'),
            ),
            const VGap(Gap.md),
            _PracticeCard(
              icon: Icons.shuffle_rounded,
              color: c.accent,
              title: 'Random review',
              body: 'A mixed set drawn from everything you have unlocked.',
              onTap: () => context.push('/practice/random'),
            ),
            const TpSectionHeader(
              title: 'By skill',
              subtitle: 'Drill one area at a time.',
            ),
            for (final skill in Skills.all)
              Padding(
                padding: const EdgeInsets.only(bottom: Gap.md),
                child: _SkillPracticeTile(
                  skill: skill,
                  mastery: state.masteryFor(skill.id),
                  onTap: () => context.push('/practice/skill-${skill.id}'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PracticeCard extends StatelessWidget {
  const _PracticeCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.onTap,
    this.badge,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return TpCard(
      onTap: onTap,
      accent: color,
      semanticLabel: title,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const HGap(Gap.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.texts.titleMedium),
                const VGap(Gap.xxs),
                Text(body, style: context.texts.bodySmall),
              ],
            ),
          ),
          if (badge != null) ...[
            const HGap(Gap.sm),
            TpBadge(label: badge!, color: color, dense: true),
          ],
          Icon(Icons.chevron_right_rounded, color: c.textTertiary),
        ],
      ),
    );
  }
}

class _SkillPracticeTile extends StatelessWidget {
  const _SkillPracticeTile({
    required this.skill,
    required this.mastery,
    required this.onTap,
  });

  final Skill skill;
  final SkillMastery mastery;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return TpCard(
      onTap: onTap,
      padding: const EdgeInsets.all(Gap.md),
      semanticLabel:
          '${skill.name}, mastery ${mastery.score.round()} out of 100',
      child: Row(
        children: [
          Icon(
            IconCatalog.forSkill(skill.id),
            size: 20,
            color: c.textSecondary,
          ),
          const HGap(Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(skill.name, style: context.texts.titleSmall),
                const VGap(Gap.xs),
                TpProgressBar(
                  value: mastery.score / 100,
                  height: 5,
                  color: mastery.score >= 65 ? c.bullish : c.progress,
                  label: skill.name,
                ),
              ],
            ),
          ),
          const HGap(Gap.md),
          Text(
            mastery.attempts == 0 ? '—' : '${mastery.score.round()}',
            style: context.texts.titleSmall,
          ),
        ],
      ),
    );
  }
}
