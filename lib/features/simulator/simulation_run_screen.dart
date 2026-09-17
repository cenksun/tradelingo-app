import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/formatters.dart';
import '../../core/seeded_random.dart';
import '../../data/repositories/local_repositories.dart';
import '../../data/scenarios/difficulty_scorer.dart';
import '../../data/scenarios/feature_detector.dart';
import '../../data/scenarios/scenario_generator.dart';
import '../../design_system/components.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/scenario.dart';
import '../../domain/models/trade.dart';
import '../../domain/services/coach_service.dart';
import '../../domain/services/risk_calculator.dart';
import '../../domain/services/simulation_session.dart';
import '../../shared/chart/candle_chart.dart';
import '../../shared/chart/chart_models.dart';
import '../learn/learner_controller.dart';
import 'simulator_hub_screen.dart';
import 'widgets/simulation_review.dart';
import 'widgets/trade_builder.dart';

/// Runs one full simulation: read the chart, decide, build, replay, review.
class SimulationRunScreen extends ConsumerStatefulWidget {
  const SimulationRunScreen({super.key, required this.options});

  final SimulatorLaunchOptions options;

  @override
  ConsumerState<SimulationRunScreen> createState() =>
      _SimulationRunScreenState();
}

class _SimulationRunScreenState extends ConsumerState<SimulationRunScreen> {
  SimulationSession? _session;
  String? _error;
  bool _saving = false;
  bool _saved = false;
  Timer? _timer;
  int _speed = 1;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _load() {
    final state = ref.read(learnerControllerProvider).value;
    final balance = state?.account.balance ?? 10000;
    final query = widget.options.toQuery();

    // Seeded from the clock so each run is a new scenario, while any single
    // scenario stays perfectly reproducible from its index.
    final now = ref.read(clockProvider)();
    final seed = SeededRandom(now.microsecondsSinceEpoch & 0x7FFFFFFF);
    var index = ScenarioGenerator.indexForSeed(seed.nextRaw());

    final matched = ScenarioGenerator.findMatching(
      query: query,
      startIndex: index,
    );
    if (matched == null) {
      setState(() {
        _error =
            'No scenario matched those filters. Try relaxing one of them — for '
            'example, leave the market condition unset.';
      });
      return;
    }
    index = matched;

    final scenario = ScenarioGenerator.byIndex(index);
    final bundle = ScenarioGenerator.load(scenario);
    if (!bundle.isUsable) {
      setState(() => _error = 'That scenario could not be loaded. Try again.');
      return;
    }
    setState(() {
      _session = SimulationSession(
        bundle: bundle,
        startingBalance: balance <= 0 ? 10000 : balance,
      );
      _error = null;
    });
  }

  void _togglePlay() {
    final session = _session;
    if (session == null) return;
    if (_playing) {
      _timer?.cancel();
      setState(() => _playing = false);
      return;
    }
    setState(() => _playing = true);
    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: (700 / _speed).round()), (
      _,
    ) {
      if (!mounted) return;
      final more = session.revealNext();
      setState(() {});
      if (!more || session.phase == SimulationPhase.review) {
        _timer?.cancel();
        setState(() => _playing = false);
      }
    });
  }

  void _setSpeed(int speed) {
    setState(() => _speed = speed);
    if (_playing) {
      _togglePlay();
      _togglePlay();
    }
  }

  Future<void> _save() async {
    final session = _session;
    if (session == null || _saving || _saved) return;
    final plan = session.plan;
    final result = session.result;
    final score = session.processScore;
    if (plan == null || result == null || score == null) return;

    setState(() => _saving = true);
    final now = ref.read(clockProvider)();
    final entry = buildJournalEntry(
      id: '${session.scenario.id}-${now.microsecondsSinceEpoch}',
      bundle: session.bundle,
      plan: plan,
      result: result,
      processScore: score.total,
      mistakes: score.mistakes,
      at: now,
    );
    await ref
        .read(learnerControllerProvider.notifier)
        .completeSimulation(entry: entry, processScore: score.total);
    if (!mounted) return;
    setState(() {
      _saving = false;
      _saved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final error = _error;
    if (error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Simulation')),
        body: TpErrorState(
          title: 'No scenario available',
          message: error,
          onRetry: () {
            setState(() => _error = null);
            _load();
          },
        ),
      );
    }

    final session = _session;
    if (session == null) {
      return const Scaffold(
        body: TpLoadingState(message: 'Preparing an unseen chart…'),
      );
    }

    return PopScope(
      canPop: session.phase == SimulationPhase.review,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Leave this simulation?'),
            content: const Text(
              'The scenario will be discarded and nothing will be recorded.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Stay'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Leave'),
              ),
            ],
          ),
        );
        if (leave == true && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(switch (session.phase) {
            SimulationPhase.decision => 'Read the chart',
            SimulationPhase.building => 'Build the trade',
            SimulationPhase.replay => 'Replay',
            SimulationPhase.review => 'Review',
          }),
        ),
        body: SafeArea(
          top: false,
          child: switch (session.phase) {
            SimulationPhase.decision => _DecisionPhase(
              session: session,
              onDirection: (d) {
                setState(() => session.chooseDirection(d));
                if (d == TradeDirection.noTrade) _confirmNoTrade(session);
              },
            ),
            SimulationPhase.building => TradeBuilder(
              session: session,
              defaultRiskPercent:
                  ref
                      .watch(learnerControllerProvider)
                      .value
                      ?.settings
                      .defaultRiskPercent ??
                  1.0,
              onBack: () => setState(session.backToDecision),
              onCommit: (plan) => setState(() => session.commit(plan)),
            ),
            SimulationPhase.replay => _ReplayPhase(
              session: session,
              playing: _playing,
              speed: _speed,
              onPlayPause: _togglePlay,
              onNext: () => setState(session.revealNext),
              onSkip: () {
                _timer?.cancel();
                setState(() {
                  _playing = false;
                  session.finishNow();
                });
              },
              onSpeed: _setSpeed,
            ),
            SimulationPhase.review => SimulationReview(
              session: session,
              saving: _saving,
              saved: _saved,
              onSave: _save,
              onDone: () => context.pop(),
              onAnother: () {
                setState(() {
                  _session = null;
                  _saved = false;
                  _revealReset();
                });
                _load();
              },
            ),
          },
        ),
      ),
    );
  }

  void _revealReset() {
    _timer?.cancel();
    _playing = false;
    _speed = 1;
  }

  Future<void> _confirmNoTrade(SimulationSession session) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record a no-trade decision?'),
        content: const Text(
          'This is graded like any other decision. The rest of the chart will '
          'then be revealed so you can see what happened.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Back to the chart'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Record it'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed == true) {
      setState(() {
        session.commit(
          TradePlan.noTrade(accountBalance: session.startingBalance),
        );
      });
    } else {
      setState(session.backToDecision);
    }
  }
}

// ---------------------------------------------------------------------------
// Decision phase
// ---------------------------------------------------------------------------

class _DecisionPhase extends StatelessWidget {
  const _DecisionPhase({required this.session, required this.onDirection});

  final SimulationSession session;
  final ValueChanged<TradeDirection> onDirection;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final scenario = session.scenario;
    final bundle = session.bundle;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, Gap.lg),
            children: [
              _ScenarioHeader(scenario: scenario, bundle: bundle),
              const VGap(Gap.md),
              SizedBox(
                height: 330,
                child: CandleChart(
                  candles: session.chartCandles,
                  priceDecimals: scenario.asset.priceDecimals,
                  showVolume: true,
                  semanticLabel:
                      'Simulation chart. ${bundle.visibleCandles.length} candles are '
                      'visible; the rest are hidden until you decide.',
                ),
              ),
              const VGap(Gap.md),
              TpCallout(
                icon: Icons.visibility_off_rounded,
                message:
                    'Everything after candle ${bundle.visibleCandles.length} is hidden. '
                    'Pinch to zoom, drag to pan, long-press for a crosshair.',
              ),
              const VGap(Gap.lg),
              Text('What is your decision?', style: context.texts.titleMedium),
              const VGap(Gap.sm),
              Text(
                'Standing aside is a real answer and is scored like any other.',
                style: context.texts.bodySmall,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(Gap.lg),
          decoration: BoxDecoration(
            color: c.surface,
            border: Border(top: BorderSide(color: c.border)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: TpButton(
                    label: 'Long',
                    icon: Icons.north_east_rounded,
                    variant: TpButtonVariant.success,
                    size: TpButtonSize.large,
                    expand: true,
                    onPressed: () => onDirection(TradeDirection.long),
                  ),
                ),
                const HGap(Gap.sm),
                Expanded(
                  child: TpButton(
                    label: 'Short',
                    icon: Icons.south_east_rounded,
                    variant: TpButtonVariant.danger,
                    size: TpButtonSize.large,
                    expand: true,
                    onPressed: () => onDirection(TradeDirection.short),
                  ),
                ),
                const HGap(Gap.sm),
                Expanded(
                  child: TpButton(
                    label: 'No trade',
                    variant: TpButtonVariant.secondary,
                    size: TpButtonSize.large,
                    expand: true,
                    onPressed: () => onDirection(TradeDirection.noTrade),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ScenarioHeader extends StatelessWidget {
  const _ScenarioHeader({required this.scenario, required this.bundle});

  final Scenario scenario;
  final ScenarioBundle bundle;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return TpCard(
      raised: true,
      padding: const EdgeInsets.all(Gap.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TpBadge(
                label: scenario.recipe.anonymized
                    ? 'Educational dataset'
                    : scenario.asset.symbol,
                icon: Icons.dataset_rounded,
                dense: true,
                color: c.textSecondary,
              ),
              const HGap(Gap.sm),
              TpBadge(
                label: scenario.timeframe.label,
                dense: true,
                color: c.textTertiary,
              ),
              const Spacer(),
              TpBadge(
                label: scenario.difficulty.label,
                dense: true,
                color: switch (scenario.difficulty) {
                  Difficulty.beginner => c.bullish,
                  Difficulty.intermediate => c.info,
                  Difficulty.advanced => c.warning,
                  Difficulty.expert => c.bearish,
                },
              ),
            ],
          ),
          const VGap(Gap.sm),
          Text(
            DifficultyScorer.explain(
              candles: bundle.visibleCandles,
              swings: bundle.visibleSwings,
              features: scenario.features,
            ),
            style: context.texts.bodySmall,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Replay phase
// ---------------------------------------------------------------------------

class _ReplayPhase extends StatelessWidget {
  const _ReplayPhase({
    required this.session,
    required this.playing,
    required this.speed,
    required this.onPlayPause,
    required this.onNext,
    required this.onSkip,
    required this.onSpeed,
  });

  final SimulationSession session;
  final bool playing;
  final int speed;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final ValueChanged<int> onSpeed;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final plan = session.plan!;
    final unrealised = session.unrealisedProfit;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(Gap.lg, Gap.md, Gap.lg, Gap.lg),
            children: [
              SizedBox(
                height: 330,
                child: CandleChart(
                  candles: session.chartCandles,
                  followLatest: true,
                  priceDecimals: session.scenario.asset.priceDecimals,
                  dimAfterIndex: session.decisionIndexInChart,
                  priceLines: plan.isNoTrade
                      ? const []
                      : [
                          ChartPriceLine(
                            price: plan.entry,
                            color: c.entryLine,
                            label: 'Entry',
                            dashed: false,
                          ),
                          ChartPriceLine(
                            price: plan.stopLoss,
                            color: c.stopLine,
                            label: 'Stop',
                          ),
                          ChartPriceLine(
                            price: plan.takeProfit,
                            color: c.targetLine,
                            label: 'Target',
                          ),
                        ],
                ),
              ),
              const VGap(Gap.md),
              TpCard(
                raised: true,
                child: Row(
                  children: [
                    Expanded(
                      child: TpStatTile(
                        label: 'Revealed',
                        value: '${session.revealed} / ${session.futureCount}',
                        compact: true,
                      ),
                    ),
                    if (!plan.isNoTrade)
                      Expanded(
                        child: TpStatTile(
                          label: 'Open result',
                          value: Fmt.signedMoney(unrealised),
                          compact: true,
                          valueColor: unrealised >= 0 ? c.bullish : c.bearish,
                        ),
                      ),
                    Expanded(
                      child: TpStatTile(
                        label: 'Position',
                        value: plan.isNoTrade ? 'Flat' : plan.direction.label,
                        compact: true,
                      ),
                    ),
                  ],
                ),
              ),
              if (plan.isNoTrade) ...[
                const VGap(Gap.md),
                const TpCallout(
                  message:
                      'You stood aside, so there is no position to resolve. The '
                      'replay is here to show what the chart did next.',
                  icon: Icons.pause_rounded,
                ),
              ],
              const VGap(Gap.md),
              TpCallout(
                icon: Icons.lock_rounded,
                tone: TpCalloutTone.neutral,
                message:
                    'Your plan is locked. Rewinding would change what you decided '
                    'with, so the replay only moves forward.',
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(Gap.lg),
          decoration: BoxDecoration(
            color: c.surface,
            border: Border(top: BorderSide(color: c.border)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final s in const [1, 2, 5])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Gap.xs),
                        child: TpFilterChip(
                          label: '${s}x',
                          selected: speed == s,
                          onTap: () => onSpeed(s),
                        ),
                      ),
                  ],
                ),
                const VGap(Gap.md),
                Row(
                  children: [
                    Expanded(
                      child: TpButton(
                        label: playing ? 'Pause' : 'Play',
                        icon: playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: TpButtonSize.large,
                        expand: true,
                        onPressed: session.hasMoreToReveal ? onPlayPause : null,
                      ),
                    ),
                    const HGap(Gap.sm),
                    Expanded(
                      child: TpButton.secondary(
                        label: 'Next',
                        icon: Icons.skip_next_rounded,
                        size: TpButtonSize.large,
                        expand: true,
                        onPressed: session.hasMoreToReveal && !playing
                            ? onNext
                            : null,
                      ),
                    ),
                    const HGap(Gap.sm),
                    Expanded(
                      child: TpButton.ghost(
                        label: 'Finish',
                        size: TpButtonSize.large,
                        expand: true,
                        onPressed: onSkip,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Small helper shared by the review screen.
String describeConditions(ScenarioBundle bundle) {
  final atr = FeatureDetector.averageTrueRange(bundle.visibleCandles);
  final reference = bundle.decisionPrice;
  if (reference <= 0 || atr <= 0) return '';
  final pct = (atr / reference) * 100;
  return 'Average candle range was about ${pct.toStringAsFixed(2)}% of price '
      '(${Fmt.price(atr)}).';
}

/// Suggests a sensible default stop distance from recent volatility.
double suggestStopDistance(ScenarioBundle bundle) {
  final atr = FeatureDetector.averageTrueRange(bundle.visibleCandles);
  if (atr <= 0) return math.max(bundle.decisionPrice * 0.01, 0.01);
  return atr * 1.6;
}

/// The coach used by the review screen.
CoachMessage buildCoachMessage(WidgetRef ref, SimulationSession session) {
  final coach = ref.read(coachServiceProvider);
  final state = ref.read(learnerControllerProvider).value;
  return coach.reviewTrade(
    CoachContext(
      plan: session.plan!,
      score: session.processScore!,
      result: session.result,
      bundle: session.bundle,
      weakSkills: state == null
          ? const []
          : state.mastery.values.where((m) => m.attempts >= 3).toList(),
      recentMistakes: session.processScore!.mistakes,
    ),
  );
}

/// Validation helper re-exported for the builder widget.
TradeValidation validatePlan(TradePlan plan) => RiskCalculator.validate(plan);
