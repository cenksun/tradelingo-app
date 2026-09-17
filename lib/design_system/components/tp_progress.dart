import 'package:flutter/material.dart';

import '../../core/formatters.dart';
import '../palette.dart';
import '../tokens.dart';

/// Animated horizontal progress bar with an accessible text description.
class TpProgressBar extends StatelessWidget {
  const TpProgressBar({
    super.key,
    required this.value,
    this.color,
    this.trackColor,
    this.height = 10,
    this.label,
    this.animate = true,
  });

  /// 0..1. Non-finite values are clamped so the bar can never break layout.
  final double value;
  final Color? color;
  final Color? trackColor;
  final double height;
  final String? label;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final v = safeDouble(value, min: 0, max: 1);
    final bar = LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * v;
        final fill = Container(
          width: width.isFinite ? width : 0,
          height: height,
          decoration: BoxDecoration(
            color: color ?? c.accent,
            borderRadius: BorderRadius.circular(Radii.pill),
          ),
        );
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: trackColor ?? c.surfaceSunken,
            borderRadius: BorderRadius.circular(Radii.pill),
          ),
          alignment: Alignment.centerLeft,
          child: animate
              ? AnimatedContainer(
                  duration: Motion.slow,
                  curve: Motion.enter,
                  width: width.isFinite ? width : 0,
                  height: height,
                  decoration: BoxDecoration(
                    color: color ?? c.accent,
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                )
              : fill,
        );
      },
    );

    return Semantics(
      label: label ?? 'Progress',
      value: Fmt.percentOfRatio(v),
      child: bar,
    );
  }
}

/// Circular ring progress used on the profile and world headers.
class TpRingProgress extends StatelessWidget {
  const TpRingProgress({
    super.key,
    required this.value,
    required this.size,
    this.strokeWidth = 6,
    this.color,
    this.trackColor,
    this.child,
  });

  final double value;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? trackColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final v = safeDouble(value, min: 0, max: 1);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: v,
              strokeWidth: strokeWidth,
              strokeCap: StrokeCap.round,
              color: color ?? c.accent,
              backgroundColor: trackColor ?? c.surfaceSunken,
            ),
          ),
          ?child,
        ],
      ),
    );
  }
}

/// Segmented step indicator used at the top of a lesson.
class TpStepBar extends StatelessWidget {
  const TpStepBar({
    super.key,
    required this.total,
    required this.completed,
    this.height = 6,
  });

  final int total;
  final int completed;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    if (total <= 0) return SizedBox(height: height);
    return Semantics(
      label: 'Lesson progress',
      value: '$completed of $total',
      child: Row(
        children: List.generate(total, (i) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == total - 1 ? 0 : 3),
              child: AnimatedContainer(
                duration: Motion.normal,
                height: height,
                decoration: BoxDecoration(
                  color: i < completed ? c.accent : c.surfaceSunken,
                  borderRadius: BorderRadius.circular(Radii.pill),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
