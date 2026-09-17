import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../design_system/components.dart';
import '../../domain/models/lesson.dart';
import '../learn/learner_controller.dart';
import 'activity_player.dart';
import 'lesson_complete_screen.dart';

/// Runs one lesson or boss challenge end to end.
class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  LessonOutcome? _outcome;
  bool _finishing = false;

  Future<void> _finish(Lesson lesson, PlayerResult result) async {
    if (result.abandoned) {
      if (mounted) context.pop();
      return;
    }
    setState(() => _finishing = true);
    final outcome = await ref
        .read(learnerControllerProvider.notifier)
        .completeLesson(
          lesson: lesson,
          correctCount: result.correct,
          gradedCount: result.total,
          masteryChanges: result.masteryChanges,
          weakConcepts: result.weakConcepts,
        );
    if (!mounted) return;
    setState(() {
      _outcome = outcome;
      _finishing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final curriculum = ref.watch(curriculumProvider);
    final lesson = curriculum.lessonById(widget.lessonId);

    if (lesson == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Lesson')),
        body: TpErrorState(
          title: 'Lesson not found',
          message: 'This lesson is no longer part of the curriculum.',
          onRetry: () => context.pop(),
        ),
      );
    }

    final state = ref.watch(learnerControllerProvider).value;
    if (state != null && !state.isLessonUnlocked(lesson)) {
      return Scaffold(
        appBar: AppBar(title: Text(lesson.title)),
        body: TpEmptyState(
          icon: Icons.lock_rounded,
          title: 'Not unlocked yet',
          message:
              'Finish the lessons before this one to open it. Progress through a '
              'world in order, then pass its boss challenge.',
          actionLabel: 'Back to the path',
          onAction: () => context.pop(),
        ),
      );
    }

    if (_finishing) {
      return const Scaffold(
        body: TpLoadingState(message: 'Saving your progress…'),
      );
    }

    final outcome = _outcome;
    if (outcome != null) {
      return LessonCompleteScreen(
        outcome: outcome,
        onContinue: () => context.pop(),
        onReviewMistakes: outcome.weakConcepts.isEmpty
            ? null
            : () => context.pushReplacement('/practice/review'),
        onRetry: outcome.passed ? null : () => setState(() => _outcome = null),
      );
    }

    return ActivityPlayer(
      title: lesson.title,
      subtitle: lesson.subtitle,
      context: lesson.isBoss ? 'boss' : 'lesson',
      items: [
        for (final activity in lesson.activities)
          PlayableActivity(activity: activity, lessonId: lesson.id),
      ],
      onFinished: (result) => _finish(lesson, result),
    );
  }
}
