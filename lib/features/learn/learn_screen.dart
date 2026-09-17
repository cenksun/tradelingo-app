import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../design_system/components.dart';
import '../../domain/models/lesson.dart';
import '../../domain/models/skill.dart';
import 'learner_controller.dart';
import 'learner_state.dart';
import 'widgets/learn_header.dart';
import 'widgets/lesson_node.dart';

/// The Learn tab: status header followed by the vertical learning path.
class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(learnerControllerProvider);
    final curriculum = ref.watch(curriculumProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: async.when(
          loading: () =>
              const TpLoadingState(message: 'Loading your progress…'),
          error: (error, _) => TpErrorState(
            message: 'Your progress could not be loaded.',
            hint: '$error',
            onRetry: () =>
                ref.read(learnerControllerProvider.notifier).refresh(),
          ),
          data: (state) => _LearnBody(state: state, curriculum: curriculum),
        ),
      ),
    );
  }
}

class _LearnBody extends ConsumerWidget {
  const _LearnBody({required this.state, required this.curriculum});

  final LearnerState state;
  final Curriculum curriculum;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = state.nextLesson(curriculum);

    return RefreshIndicator(
      onRefresh: () => ref.read(learnerControllerProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.only(bottom: Gap.huge),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, 0),
            child: LearnHeader(
              state: state,
              onHeartsTap: () => context.push('/practice/hearts'),
            ),
          ),
          if (next != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.lg, Gap.lg, 0),
              child: _ContinueCard(lesson: next, curriculum: curriculum),
            ),
          if (state.dueReviewCount > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, 0),
              child: _ReviewCard(count: state.dueReviewCount),
            ),
          for (final world in curriculum.worlds)
            _WorldSection(world: world, state: state, nextLessonId: next?.id),
        ],
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({required this.lesson, required this.curriculum});

  final Lesson lesson;
  final Curriculum curriculum;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final world = curriculum.worldOfLesson(lesson.id);
    return TpCard(
      accent: c.accent,
      onTap: () => context.push('/lesson/${lesson.id}'),
      semanticLabel: 'Continue with ${lesson.title}',
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.isBoss ? 'NEXT UP · BOSS CHALLENGE' : 'NEXT UP',
                  style: context.texts.labelSmall?.copyWith(color: c.accent),
                ),
                const VGap(Gap.xs),
                Text(lesson.title, style: context.texts.titleMedium),
                const VGap(Gap.xxs),
                Text(
                  '${world?.title ?? ''} · ${lesson.estimatedMinutes} min · '
                  '${lesson.gradedCount} exercises',
                  style: context.texts.bodySmall,
                ),
              ],
            ),
          ),
          const HGap(Gap.md),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: c.accent, shape: BoxShape.circle),
            child: Icon(Icons.play_arrow_rounded, color: c.onAccent),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return TpCard(
      accent: c.progress,
      onTap: () => context.push('/practice/review'),
      semanticLabel: '$count concepts due for review',
      child: Row(
        children: [
          Icon(Icons.replay_rounded, color: c.progress),
          const HGap(Gap.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count due for review', style: context.texts.titleSmall),
                const VGap(Gap.xxs),
                Text(
                  'Concepts you have seen before, scheduled to come back today.',
                  style: context.texts.bodySmall,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: c.textTertiary),
        ],
      ),
    );
  }
}

class _WorldSection extends StatelessWidget {
  const _WorldSection({
    required this.world,
    required this.state,
    required this.nextLessonId,
  });

  final World world;
  final LearnerState state;
  final String? nextLessonId;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final accent = Color(world.accentColor);
    final unlocked = state.isLessonUnlocked(world.lessons.first);
    final completed = state.completedLessonsIn(world);
    final progress = state.worldProgress(world);

    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.xxl, Gap.lg, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TpCard(
            raised: true,
            accent: unlocked ? accent : c.locked,
            padding: const EdgeInsets.all(Gap.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: unlocked
                            ? accent.withValues(alpha: 0.18)
                            : c.surfaceSunken,
                        borderRadius: BorderRadius.circular(Radii.sm),
                      ),
                      child: Text(
                        '${world.index}',
                        style: context.texts.titleSmall?.copyWith(
                          color: unlocked ? accent : c.textTertiary,
                        ),
                      ),
                    ),
                    const HGap(Gap.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(world.title, style: context.texts.titleMedium),
                          Text(world.subtitle, style: context.texts.bodySmall),
                        ],
                      ),
                    ),
                    if (!unlocked)
                      Icon(Icons.lock_rounded, size: 18, color: c.locked)
                    else
                      TpBadge(
                        label: '$completed/${world.lessons.length}',
                        color: accent,
                        dense: true,
                      ),
                  ],
                ),
                const VGap(Gap.md),
                TpProgressBar(
                  value: progress,
                  color: accent,
                  height: 7,
                  label: '${world.title} progress',
                ),
                if (!unlocked) ...[
                  const VGap(Gap.md),
                  Text(
                    'Pass the previous world\'s boss challenge to unlock this.',
                    style: context.texts.bodySmall,
                  ),
                ] else ...[
                  const VGap(Gap.sm),
                  Text(world.description, style: context.texts.bodySmall),
                  const VGap(Gap.xs),
                  Text(
                    'Trains ${Skills.nameOf(world.primarySkillId)}',
                    style: context.texts.labelSmall,
                  ),
                ],
              ],
            ),
          ),
          const VGap(Gap.xl),
          _LessonPath(
            world: world,
            state: state,
            accent: accent,
            nextLessonId: nextLessonId,
          ),
        ],
      ),
    );
  }
}

/// Lays the lesson nodes out in a gentle zig-zag so the path reads as a
/// journey rather than a list.
class _LessonPath extends StatelessWidget {
  const _LessonPath({
    required this.world,
    required this.state,
    required this.accent,
    required this.nextLessonId,
  });

  final World world;
  final LearnerState state;
  final Color accent;
  final String? nextLessonId;

  static const List<double> _offsets = [
    0,
    0.42,
    0.62,
    0.42,
    0,
    -0.42,
    -0.62,
    -0.42,
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final amplitude = (width / 2 - 70).clamp(0.0, 90.0);
        return Column(
          children: [
            for (var i = 0; i < world.lessons.length; i++) ...[
              Align(
                alignment: Alignment(
                  (_offsets[i % _offsets.length]) * (amplitude / (width / 2)),
                  0,
                ),
                child: LessonNode(
                  lesson: world.lessons[i],
                  accent: accent,
                  isNext: world.lessons[i].id == nextLessonId,
                  status: _statusFor(world.lessons[i]),
                  onTap: () => context.push('/lesson/${world.lessons[i].id}'),
                ),
              ),
              if (i != world.lessons.length - 1)
                Container(
                  width: 3,
                  height: 22,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: state.isLessonCompleted(world.lessons[i].id)
                        ? accent.withValues(alpha: 0.5)
                        : c.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }

  LessonNodeStatus _statusFor(Lesson lesson) {
    if (!state.isLessonUnlocked(lesson)) return LessonNodeStatus.locked;
    final progress = state.lessonProgress[lesson.id];
    if (progress == null || !progress.isCompleted) {
      return LessonNodeStatus.available;
    }
    return progress.perfect
        ? LessonNodeStatus.perfect
        : LessonNodeStatus.completed;
  }
}
