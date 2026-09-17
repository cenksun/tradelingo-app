import 'package:flutter/material.dart';

import '../../../design_system/components.dart';
import '../../../domain/models/lesson.dart';

enum LessonNodeStatus { locked, available, completed, perfect }

/// One circular node on the learning path.
class LessonNode extends StatelessWidget {
  const LessonNode({
    super.key,
    required this.lesson,
    required this.status,
    required this.accent,
    required this.onTap,
    this.isNext = false,
  });

  final Lesson lesson;
  final LessonNodeStatus status;
  final Color accent;
  final VoidCallback? onTap;

  /// The single node the learner should open next, given a subtle emphasis.
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final locked = status == LessonNodeStatus.locked;
    final done =
        status == LessonNodeStatus.completed ||
        status == LessonNodeStatus.perfect;

    final background = locked
        ? c.surfaceSunken
        : done
        ? accent.withValues(alpha: 0.18)
        : accent;
    final foreground = locked
        ? c.locked
        : done
        ? accent
        : c.onAccent;

    final icon = switch (status) {
      LessonNodeStatus.locked => Icons.lock_rounded,
      LessonNodeStatus.completed => Icons.check_rounded,
      LessonNodeStatus.perfect => Icons.star_rounded,
      LessonNodeStatus.available =>
        lesson.isBoss ? Icons.military_tech_rounded : Icons.play_arrow_rounded,
    };

    final size = lesson.isBoss ? 76.0 : 64.0;

    return Semantics(
      button: !locked,
      enabled: !locked,
      label:
          '${lesson.isBoss ? 'Boss challenge' : 'Lesson ${lesson.index}'}: ${lesson.title}. '
          '${switch (status) {
            LessonNodeStatus.locked => 'Locked',
            LessonNodeStatus.available => 'Available',
            LessonNodeStatus.completed => 'Completed',
            LessonNodeStatus.perfect => 'Completed perfectly',
          }}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Motion.normal,
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
              border: Border.all(
                color: locked
                    ? c.border
                    : isNext
                    ? c.accent
                    : accent.withValues(alpha: 0.6),
                width: isNext ? 3 : 2,
              ),
              boxShadow: isNext
                  ? [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.35),
                        blurRadius: 18,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: locked ? null : onTap,
                child: Icon(
                  icon,
                  color: foreground,
                  size: lesson.isBoss ? 32 : 26,
                ),
              ),
            ),
          ),
          const VGap(Gap.sm),
          SizedBox(
            width: 120,
            child: Text(
              lesson.isBoss ? 'Boss Challenge' : lesson.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.texts.labelSmall?.copyWith(
                color: locked ? c.textTertiary : c.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
