import 'package:flutter/material.dart';

import '../../core/formatters.dart';
import '../../design_system/components.dart';
import '../../domain/models/skill.dart';
import '../learn/learner_controller.dart';

/// The end-of-lesson screen: accuracy, XP, hearts, mastery changes and what to
/// do next.
class LessonCompleteScreen extends StatefulWidget {
  const LessonCompleteScreen({
    super.key,
    required this.outcome,
    required this.onContinue,
    this.onReviewMistakes,
    this.onRetry,
  });

  final LessonOutcome outcome;
  final VoidCallback onContinue;
  final VoidCallback? onReviewMistakes;
  final VoidCallback? onRetry;

  @override
  State<LessonCompleteScreen> createState() => _LessonCompleteScreenState();
}

class _LessonCompleteScreenState extends State<LessonCompleteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Motion.celebrate,
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final o = widget.outcome;
    final passed = o.passed;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Gap.lg),
                child: TpPageBody(
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const VGap(Gap.xl),
                      ScaleTransition(
                        scale: CurvedAnimation(
                          parent: _controller,
                          curve: Motion.emphasis,
                        ),
                        child: Center(
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: passed
                                  ? c.accentSoft
                                  : c.warning.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              passed
                                  ? (o.perfect
                                        ? Icons.star_rounded
                                        : Icons.check_rounded)
                                  : Icons.refresh_rounded,
                              size: 46,
                              color: passed ? c.accent : c.warning,
                            ),
                          ),
                        ),
                      ),
                      const VGap(Gap.xl),
                      Text(
                        passed
                            ? (o.perfect ? 'Perfect lesson' : 'Lesson complete')
                            : 'Not passed yet',
                        style: context.texts.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const VGap(Gap.sm),
                      Text(
                        passed
                            ? o.lesson.title
                            : 'You need ${(o.lesson.passThreshold * 100).round()}% to pass this '
                                  'boss challenge. Nothing is lost — the answers you gave still '
                                  'count towards your skills and review queue.',
                        style: context.texts.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const VGap(Gap.xxl),
                      TpCard(
                        raised: true,
                        child: Row(
                          children: [
                            Expanded(
                              child: TpStatTile(
                                label: 'Accuracy',
                                value: Fmt.percentOfRatio(o.accuracy),
                                icon: Icons.track_changes_rounded,
                                valueColor: o.accuracy >= 0.8
                                    ? c.bullish
                                    : o.accuracy >= 0.5
                                    ? c.warning
                                    : c.bearish,
                              ),
                            ),
                            Expanded(
                              child: TpStatTile(
                                label: 'XP earned',
                                value: '+${o.xpAwarded}',
                                icon: Icons.bolt_rounded,
                                valueColor: c.xp,
                              ),
                            ),
                            Expanded(
                              child: TpStatTile(
                                label: 'Hearts',
                                value: '${o.heartsRemaining}',
                                icon: Icons.favorite_rounded,
                                valueColor: o.heartsRemaining > 0
                                    ? c.heart
                                    : c.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (o.leveledUp) ...[
                        const VGap(Gap.lg),
                        TpCallout(
                          tone: TpCalloutTone.success,
                          icon: Icons.arrow_upward_rounded,
                          title: 'Level ${o.newLevel}',
                          message:
                              'You reached a new level. Titles in TradePath mark progress through '
                              'the app — they are not a qualification.',
                        ),
                      ],
                      if (o.correct < o.total) ...[
                        const VGap(Gap.lg),
                        TpCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Missed ${o.total - o.correct} of ${o.total}',
                                style: context.texts.titleSmall,
                              ),
                              const VGap(Gap.sm),
                              Text(
                                'These concepts have been added to your review queue and will '
                                'come back spaced out over the next few days.',
                                style: context.texts.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (o.masteryChanges.isNotEmpty) ...[
                        const VGap(Gap.lg),
                        TpCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Skill mastery',
                                style: context.texts.titleSmall,
                              ),
                              const VGap(Gap.md),
                              for (final entry in o.masteryChanges.entries)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: Gap.sm,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          Skills.nameOf(entry.key),
                                          style: context.texts.bodyMedium,
                                        ),
                                      ),
                                      Text(
                                        '${entry.value >= 0 ? '+' : ''}'
                                        '${entry.value.toStringAsFixed(1)}',
                                        style: context.texts.titleSmall
                                            ?.copyWith(
                                              color: entry.value >= 0
                                                  ? c.bullish
                                                  : c.bearish,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                      if (o.unlockedAchievements.isNotEmpty) ...[
                        const VGap(Gap.lg),
                        for (final a in o.unlockedAchievements)
                          Padding(
                            padding: const EdgeInsets.only(bottom: Gap.sm),
                            child: TpCallout(
                              tone: TpCalloutTone.success,
                              icon: Icons.emoji_events_rounded,
                              title: 'Achievement unlocked · ${a.title}',
                              message: a.description,
                            ),
                          ),
                      ],
                      const VGap(Gap.xxl),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(Gap.lg),
              decoration: BoxDecoration(
                color: c.surface,
                border: Border(top: BorderSide(color: c.border)),
              ),
              child: Column(
                children: [
                  if (widget.onRetry != null) ...[
                    TpButton.primary(
                      label: 'Try the challenge again',
                      size: TpButtonSize.large,
                      onPressed: widget.onRetry,
                    ),
                    const VGap(Gap.sm),
                  ],
                  if (widget.onReviewMistakes != null) ...[
                    TpButton.secondary(
                      label: 'Review what you missed',
                      expand: true,
                      onPressed: widget.onReviewMistakes,
                    ),
                    const VGap(Gap.sm),
                  ],
                  TpButton(
                    label: 'Continue',
                    expand: true,
                    size: TpButtonSize.large,
                    variant: widget.onRetry == null
                        ? TpButtonVariant.primary
                        : TpButtonVariant.ghost,
                    onPressed: widget.onContinue,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
