import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/formatters.dart';
import '../../design_system/components.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/skill.dart';
import '../../domain/services/recommendation_engine.dart';
import '../learn/learner_controller.dart';
import '../lesson/activity_player.dart';

/// Runs a practice, review or hearts session.
///
/// `mode` is one of: `review`, `hearts`, `mistakes`, `weak`, `random`, or
/// `skill-<skillId>`.
class PracticeSessionScreen extends ConsumerStatefulWidget {
  const PracticeSessionScreen({super.key, required this.mode});

  final String mode;

  @override
  ConsumerState<PracticeSessionScreen> createState() =>
      _PracticeSessionScreenState();
}

class _PracticeSessionScreenState extends ConsumerState<PracticeSessionScreen> {
  PlayerResult? _result;
  int _xpAwarded = 0;
  bool _finishing = false;

  bool get _isHearts => widget.mode == 'hearts';

  String get _title => switch (widget.mode) {
    'review' => 'Review',
    'hearts' => 'Practice for hearts',
    'mistakes' => 'Your mistakes',
    'weak' => 'Weak skills',
    'random' => 'Random review',
    _ => Skills.tryById(_skillId ?? '')?.name ?? 'Practice',
  };

  String? get _skillId =>
      widget.mode.startsWith('skill-') ? widget.mode.substring(6) : null;

  Future<void> _finish(PlayerResult result) async {
    if (result.abandoned) {
      if (mounted) context.pop();
      return;
    }
    setState(() => _finishing = true);
    final xp = await ref
        .read(learnerControllerProvider.notifier)
        .completePracticeSession(
          itemsCleared: result.correct,
          forHearts: _isHearts,
        );
    if (!mounted) return;
    setState(() {
      _result = result;
      _xpAwarded = xp;
      _finishing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final state = ref.watch(learnerControllerProvider).value;
    final curriculum = ref.watch(curriculumProvider);

    if (state == null || _finishing) {
      return const Scaffold(body: TpLoadingState());
    }

    final result = _result;
    if (result != null) {
      return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(Gap.lg),
                  children: [
                    const VGap(Gap.xl),
                    Center(
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: c.accentSoft,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isHearts
                              ? Icons.favorite_rounded
                              : Icons.check_rounded,
                          size: 40,
                          color: _isHearts ? c.heart : c.accent,
                        ),
                      ),
                    ),
                    const VGap(Gap.xl),
                    Text(
                      'Session complete',
                      style: context.texts.headlineMedium,
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
                              value: Fmt.percentOfRatio(result.accuracy),
                              icon: Icons.track_changes_rounded,
                            ),
                          ),
                          Expanded(
                            child: TpStatTile(
                              label: 'Answered',
                              value: '${result.correct}/${result.total}',
                              icon: Icons.checklist_rounded,
                            ),
                          ),
                          Expanded(
                            child: TpStatTile(
                              label: 'XP',
                              value: '+$_xpAwarded',
                              icon: Icons.bolt_rounded,
                              valueColor: c.xp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isHearts) ...[
                      const VGap(Gap.lg),
                      TpCallout(
                        tone: TpCalloutTone.success,
                        icon: Icons.favorite_rounded,
                        message:
                            'Hearts restored. You now have '
                            '${state.profile.hearts} of 5.',
                      ),
                    ],
                    const VGap(Gap.lg),
                    const TpCallout(
                      icon: Icons.schedule_rounded,
                      message:
                          'Anything you missed has been rescheduled. It will come '
                          'back sooner than the concepts you got right.',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Gap.lg),
                child: TpButton.primary(
                  label: 'Done',
                  size: TpButtonSize.large,
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final unlocked = state.unlockedLessonIds(curriculum);
    final now = state.now;

    final items = RecommendationEngine.buildSession(
      curriculum: curriculum,
      reviewItems: switch (widget.mode) {
        'review' ||
        'hearts' => state.reviewItems.where((r) => r.isDue(now)).toList(),
        'mistakes' => state.reviewItems.where((r) => r.lapses > 0).toList(),
        _ => state.reviewItems,
      },
      masteries: state.mastery.values.toList(),
      unlockedLessonIds: unlocked,
      now: now,
      focusSkillId:
          _skillId ??
          (widget.mode == 'weak'
              ? RecommendationEngine.weakestSkills(
                  state.mastery.values.toList(),
                  limit: 1,
                ).firstOrNull?.skillId
              : null),
      recentMistakes: widget.mode == 'mistakes' ? MistakeTag.values : const [],
      limit: _isHearts ? 5 : 10,
      seed: now.millisecondsSinceEpoch ~/ 30000,
    );

    return ActivityPlayer(
      title: _title,
      items: [
        for (final item in items)
          PlayableActivity(
            activity: item.activity,
            lessonId: item.lessonId,
            reason: item.reason,
          ),
      ],
      heartsEnabled: !_isHearts,
      context: widget.mode == 'review' ? 'review' : 'practice',
      onFinished: _finish,
    );
  }
}
