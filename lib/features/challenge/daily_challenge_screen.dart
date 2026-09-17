import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/app_date.dart';
import '../../design_system/components.dart';
import '../../domain/models/challenge.dart';
import '../../domain/services/challenge_generator.dart';
import '../../domain/services/xp_rules.dart';
import '../learn/learner_controller.dart';
import '../lesson/activity_player.dart';
import 'challenge_screen.dart';

/// Plays today's daily challenge.
class DailyChallengeScreen extends ConsumerStatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  ConsumerState<DailyChallengeScreen> createState() =>
      _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends ConsumerState<DailyChallengeScreen> {
  PlayerResult? _result;
  int _xp = 0;
  bool _finishing = false;

  Future<void> _finish(DailyChallenge challenge, PlayerResult result) async {
    if (result.abandoned) {
      if (mounted) context.pop();
      return;
    }
    setState(() => _finishing = true);
    final repo = ref.read(challengeRepositoryProvider);
    await repo.saveDaily(
      challenge.copyWith(
        completedTaskCount: challenge.tasks.length,
        completed: true,
      ),
    );
    final xp = await ref
        .read(learnerControllerProvider.notifier)
        .awardChallengeXp(
          amount: XpRules.dailyChallengeComplete,
          source: XpSource.dailyChallenge,
          reference: challenge.dayKey,
        );
    ref.invalidate(challengeStateProvider);
    if (!mounted) return;
    setState(() {
      _result = result;
      _xp = xp;
      _finishing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final now = ref.watch(clockProvider)();
    final curriculum = ref.watch(curriculumProvider);
    final challenge = ChallengeGenerator.daily(
      date: now,
      curriculum: curriculum,
    );

    if (_finishing) {
      return const Scaffold(body: TpLoadingState());
    }

    final result = _result;
    if (result != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daily challenge')),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(Gap.lg),
                  children: [
                    const VGap(Gap.xxl),
                    Center(
                      child: Icon(
                        Icons.emoji_events_rounded,
                        size: 72,
                        color: c.warning,
                      ),
                    ),
                    const VGap(Gap.xl),
                    Text(
                      'Daily challenge complete',
                      style: context.texts.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const VGap(Gap.sm),
                    Text(
                      AppDate.dayKey(now),
                      style: context.texts.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const VGap(Gap.xxl),
                    TpCard(
                      raised: true,
                      child: Row(
                        children: [
                          Expanded(
                            child: TpStatTile(
                              label: 'Correct',
                              value: '${result.correct}/${result.total}',
                              icon: Icons.checklist_rounded,
                            ),
                          ),
                          Expanded(
                            child: TpStatTile(
                              label: 'XP earned',
                              value: '+$_xp',
                              icon: Icons.bolt_rounded,
                              valueColor: c.xp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VGap(Gap.lg),
                    const TpCallout(
                      icon: Icons.schedule_rounded,
                      message:
                          'A new challenge is generated from tomorrow\'s date. '
                          'It is the same set for everyone, with no server involved.',
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

    // Resolve the referenced activities. The simulation task is presented as a
    // link rather than played inline, so the challenge stays short.
    final items = <PlayableActivity>[];
    for (final task in challenge.tasks) {
      if (task.kind == ChallengeTaskKind.simulation) continue;
      final parts = task.reference.split(':');
      if (parts.length != 2) continue;
      final lesson = curriculum.lessonById(parts[0]);
      if (lesson == null) continue;
      final activity = lesson.activities
          .where((a) => a.id == parts[1])
          .firstOrNull;
      if (activity == null) continue;
      items.add(
        PlayableActivity(
          activity: activity,
          lessonId: lesson.id,
          reason: task.label,
        ),
      );
    }

    if (items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Daily challenge')),
        body: TpErrorState(
          title: 'Challenge unavailable',
          message:
              'Today\'s challenge could not be assembled from the curriculum.',
          onRetry: () => context.pop(),
        ),
      );
    }

    return ActivityPlayer(
      title: 'Daily challenge',
      items: items,
      context: 'challenge',
      onFinished: (result) => _finish(challenge, result),
    );
  }
}
