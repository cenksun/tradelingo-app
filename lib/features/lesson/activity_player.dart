import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../design_system/components.dart';
import '../../domain/models/activity.dart';
import '../../domain/models/chart_series.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/user_profile.dart';
import '../learn/learner_controller.dart';
import 'widgets/activity_view.dart';
import 'widgets/chart_activity_views.dart';

/// One activity queued for play, with the lesson it came from.
class PlayableActivity {
  const PlayableActivity({
    required this.activity,
    required this.lessonId,
    this.reason,
  });

  final Activity activity;
  final String lessonId;

  /// Why this item is in the session, shown in practice and review runs.
  final String? reason;
}

/// The outcome of a completed run.
class PlayerResult {
  const PlayerResult({
    required this.correct,
    required this.total,
    required this.masteryChanges,
    required this.weakConcepts,
    required this.mistakes,
    required this.abandoned,
  });

  final int correct;
  final int total;
  final Map<String, double> masteryChanges;
  final List<String> weakConcepts;
  final List<MistakeTag> mistakes;
  final bool abandoned;

  double get accuracy => total == 0 ? 1 : correct / total;
  bool get perfect => total > 0 && correct == total;
}

/// Plays a list of activities: prompt, answer, feedback, next.
///
/// Used by lessons, boss challenges, practice sessions, review sessions and
/// the daily challenge, so the answering experience is identical everywhere.
class ActivityPlayer extends ConsumerStatefulWidget {
  const ActivityPlayer({
    super.key,
    required this.title,
    required this.items,
    required this.onFinished,
    this.heartsEnabled = true,
    this.context = 'lesson',
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<PlayableActivity> items;
  final ValueChanged<PlayerResult> onFinished;

  /// When false (practice for hearts), wrong answers do not cost a heart.
  final bool heartsEnabled;

  /// Recorded with each attempt: `lesson`, `boss`, `practice`, `review`,
  /// `challenge`.
  final String context;

  @override
  ConsumerState<ActivityPlayer> createState() => _ActivityPlayerState();
}

class _ActivityPlayerState extends ConsumerState<ActivityPlayer> {
  int _index = 0;
  ActivityResponse? _response;
  ActivityEvaluation? _evaluation;
  bool _checking = false;

  int _correct = 0;
  int _graded = 0;
  final Map<String, double> _masteryChanges = {};
  final List<String> _weakConcepts = [];
  final List<MistakeTag> _mistakes = [];

  PlayableActivity get _item => widget.items[_index];
  Activity get _activity => _item.activity;
  bool get _isLast => _index >= widget.items.length - 1;

  Future<void> _check() async {
    final response = _response;
    if (response == null || _checking) return;
    setState(() => _checking = true);

    GeneratedSeries? series;
    final recipe = _activity.recipe;
    if (recipe != null) series = SeriesCache.instance.of(recipe);

    final evaluation = _activity.evaluate(response, series: series);
    final controller = ref.read(learnerControllerProvider.notifier);

    if (_activity.isGraded) {
      _graded++;
      if (evaluation.correct) {
        _correct++;
      } else {
        _weakConcepts.add(_activity.concept);
        _mistakes.addAll(evaluation.mistakes);
      }

      final deltas = await controller.recordAnswer(
        activity: _activity,
        lessonId: _item.lessonId,
        correct: evaluation.correct,
        partialCredit: evaluation.partialCredit,
        context: widget.context,
      );
      for (final entry in deltas.entries) {
        _masteryChanges[entry.key] =
            (_masteryChanges[entry.key] ?? 0) + entry.value;
      }

      if (!evaluation.correct && widget.heartsEnabled) {
        await controller.loseHeart();
      }
      // Fire and forget: haptics are a nicety, and a platform channel that
      // never answers must not be able to freeze the lesson.
      unawaited(_feedbackHaptic(evaluation.correct));
    }

    if (!mounted) return;
    setState(() {
      _evaluation = evaluation;
      _checking = false;
    });
  }

  Future<void> _feedbackHaptic(bool correct) async {
    if (!mounted) return;
    final settings = ref.read(learnerControllerProvider).value?.settings;
    if (settings?.hapticsEnabled != true) return;
    try {
      if (correct) {
        await HapticFeedback.lightImpact();
      } else {
        await HapticFeedback.mediumImpact();
      }
    } catch (_) {
      // A device without a vibrator, or a platform that rejects the call, is
      // not a reason to interrupt the lesson.
    }
  }

  void _advance() {
    if (_isLast) {
      widget.onFinished(
        PlayerResult(
          correct: _correct,
          total: _graded,
          masteryChanges: Map.of(_masteryChanges),
          weakConcepts: List.of(_weakConcepts),
          mistakes: List.of(_mistakes),
          abandoned: false,
        ),
      );
      return;
    }
    setState(() {
      _index++;
      _response = null;
      _evaluation = null;
    });
  }

  Future<void> _confirmQuit() async {
    final quit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave this session?'),
        content: const Text(
          'Your answers so far are already recorded, but the session will not '
          'count as completed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep going'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (quit == true && mounted) {
      widget.onFinished(
        PlayerResult(
          correct: _correct,
          total: _graded,
          masteryChanges: Map.of(_masteryChanges),
          weakConcepts: List.of(_weakConcepts),
          mistakes: List.of(_mistakes),
          abandoned: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final hearts =
        ref.watch(learnerControllerProvider).value?.profile.hearts ??
        UserProfile.maxHearts;
    final evaluation = _evaluation;

    if (widget.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: TpEmptyState(
          icon: Icons.inbox_rounded,
          title: 'Nothing to practise yet',
          message:
              'Complete a few lessons first and this session will fill up with '
              'the concepts you need most.',
          actionLabel: 'Back',
          onAction: () => Navigator.of(context).maybePop(),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmQuit();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Gap.sm,
                  Gap.sm,
                  Gap.lg,
                  Gap.sm,
                ),
                child: Row(
                  children: [
                    TpIconButton(
                      icon: Icons.close_rounded,
                      tooltip: 'Leave session',
                      onPressed: _confirmQuit,
                    ),
                    Expanded(
                      child: TpStepBar(
                        total: widget.items.length,
                        completed: _index + (evaluation != null ? 1 : 0),
                      ),
                    ),
                    const HGap(Gap.md),
                    if (widget.heartsEnabled)
                      Semantics(
                        label: '$hearts hearts remaining',
                        child: Row(
                          children: [
                            Icon(
                              hearts > 0
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: hearts > 0 ? c.heart : c.textTertiary,
                              size: 18,
                            ),
                            const HGap(Gap.xs),
                            Text('$hearts', style: context.texts.titleSmall),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (_item.reason != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(Gap.lg, 0, Gap.lg, Gap.sm),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 13,
                        color: c.textTertiary,
                      ),
                      const HGap(Gap.xs),
                      Expanded(
                        child: Text(
                          _item.reason!,
                          style: context.texts.labelSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: Motion.fast,
                  child: ActivityView(
                    key: ValueKey(_activity.id),
                    activity: _activity,
                    onChanged: (r) {
                      if (_evaluation != null) return;
                      setState(() => _response = r);
                    },
                  ),
                ),
              ),
              _FeedbackBar(
                evaluation: evaluation,
                graded: _activity.isGraded,
                canCheck: _response != null,
                busy: _checking,
                isLast: _isLast,
                onCheck: _check,
                onContinue: _advance,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The bottom bar: check button before answering, explanation afterwards.
class _FeedbackBar extends StatelessWidget {
  const _FeedbackBar({
    required this.evaluation,
    required this.graded,
    required this.canCheck,
    required this.busy,
    required this.isLast,
    required this.onCheck,
    required this.onContinue,
  });

  final ActivityEvaluation? evaluation;
  final bool graded;
  final bool canCheck;
  final bool busy;
  final bool isLast;
  final VoidCallback onCheck;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;

    if (evaluation == null) {
      return Container(
        padding: const EdgeInsets.all(Gap.lg),
        decoration: BoxDecoration(
          color: c.surface,
          border: Border(top: BorderSide(color: c.border)),
        ),
        child: SafeArea(
          top: false,
          child: TpButton.primary(
            label: graded ? 'Check' : 'Continue',
            size: TpButtonSize.large,
            busy: busy,
            onPressed: canCheck ? onCheck : null,
          ),
        ),
      );
    }

    final correct = evaluation!.correct;
    final partial = !correct && evaluation!.partialCredit > 0;
    final tone = correct ? c.bullish : c.bearish;

    return AnimatedContainer(
      duration: Motion.fast,
      padding: const EdgeInsets.all(Gap.lg),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.10),
        border: Border(top: BorderSide(color: tone.withValues(alpha: 0.4))),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  correct ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: tone,
                ),
                const HGap(Gap.sm),
                Expanded(
                  child: Text(
                    correct
                        ? 'Correct'
                        : partial
                        ? 'Partly right'
                        : 'Not quite',
                    style: context.texts.titleMedium?.copyWith(color: tone),
                  ),
                ),
              ],
            ),
            if (evaluation!.feedback.trim().isNotEmpty) ...[
              const VGap(Gap.sm),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 190),
                child: SingleChildScrollView(
                  child: Text(
                    evaluation!.feedback,
                    style: context.texts.bodyMedium?.copyWith(
                      color: c.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
            const VGap(Gap.lg),
            TpButton(
              label: isLast ? 'Finish' : 'Continue',
              size: TpButtonSize.large,
              expand: true,
              variant: correct
                  ? TpButtonVariant.success
                  : TpButtonVariant.primary,
              onPressed: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}
