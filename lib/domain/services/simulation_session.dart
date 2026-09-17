import '../models/enums.dart';
import '../models/market.dart';
import '../models/scenario.dart';
import '../models/trade.dart';
import 'process_score.dart';
import 'replay_engine.dart';

enum SimulationPhase {
  /// Reading the chart, before any decision.
  decision,

  /// Configuring entry, stop, target and risk.
  building,

  /// Revealing future candles one at a time.
  replay,

  /// Finished: result and process score available.
  review,
}

/// Drives one simulation from decision through replay to review.
///
/// ## Look-ahead protection
///
/// The future candles live in a private field. [chartCandles] — the only list
/// the UI ever renders — returns the visible window plus exactly the candles
/// that have been revealed, and nothing is revealed before a decision has been
/// committed. There is no code path that hands an un-revealed candle to a
/// widget, which is what makes the protection structural rather than a matter
/// of remembering to hide something.
class SimulationSession {
  SimulationSession({required this.bundle, required this.startingBalance});

  final ScenarioBundle bundle;
  final double startingBalance;

  SimulationPhase _phase = SimulationPhase.decision;
  TradeDirection? _direction;
  TradePlan? _plan;
  TradeResult? _result;
  ProcessScore? _score;
  int _revealed = 0;
  bool _committed = false;

  SimulationPhase get phase => _phase;
  TradeDirection? get direction => _direction;

  /// The plan exactly as it was committed. The replay can never change it.
  TradePlan? get plan => _plan;
  TradeResult? get result => _result;
  ProcessScore? get processScore => _score;
  int get revealed => _revealed;
  bool get isCommitted => _committed;

  Scenario get scenario => bundle.scenario;

  int get futureCount => bundle.futureCandles.length;
  bool get hasMoreToReveal => _revealed < futureCount;

  /// The candles the UI may draw. Never includes an unrevealed future candle.
  List<Candle> get chartCandles {
    if (!_committed || _revealed <= 0) return bundle.visibleCandles;
    final take = _revealed.clamp(0, bundle.futureCandles.length);
    return [...bundle.visibleCandles, ...bundle.futureCandles.take(take)];
  }

  /// Index of the last pre-decision candle within [chartCandles].
  int get decisionIndexInChart => bundle.visibleCandles.length - 1;

  double get decisionPrice => bundle.decisionPrice;

  /// Chooses a direction and moves to the builder (or straight to review for a
  /// no-trade decision).
  void chooseDirection(TradeDirection direction) {
    if (_committed) return;
    _direction = direction;
    _phase = direction == TradeDirection.noTrade
        ? SimulationPhase.decision
        : SimulationPhase.building;
  }

  void backToDecision() {
    if (_committed) return;
    _direction = null;
    _phase = SimulationPhase.decision;
  }

  /// Commits the plan. After this the plan is frozen and the replay may begin.
  void commit(TradePlan plan) {
    if (_committed) return;
    _plan = plan;
    _committed = true;
    if (plan.isNoTrade) {
      // A no-trade decision still reveals what happened, for the lesson, but
      // there is no position to resolve.
      _result = const TradeResult.noTrade();
      _phase = SimulationPhase.replay;
    } else {
      _phase = SimulationPhase.replay;
    }
  }

  /// Reveals the next future candle. Returns false when there are none left.
  bool revealNext() {
    if (!_committed || !hasMoreToReveal) return false;
    _revealed++;
    _evaluate();
    return true;
  }

  /// Reveals everything that remains, used by "skip to the end".
  void revealAll() {
    if (!_committed) return;
    _revealed = futureCount;
    _evaluate();
  }

  /// Unrealised result at the current point of the replay.
  double get unrealisedProfit {
    final plan = _plan;
    if (plan == null || plan.isNoTrade) return 0;
    if (_result != null && _result!.outcome != TradeOutcome.invalid) {
      return _result!.profitLoss;
    }
    return ReplayEngine.unrealisedProfit(
      plan: plan,
      futureCandles: bundle.futureCandles,
      revealed: _revealed,
    );
  }

  void _evaluate() {
    final plan = _plan;
    if (plan == null) return;
    if (plan.isNoTrade) {
      if (!hasMoreToReveal) _finish(const TradeResult.noTrade());
      return;
    }
    final partial = ReplayEngine.runPartial(
      plan: plan,
      futureCandles: bundle.futureCandles,
      revealed: _revealed,
    );
    if (partial != null) {
      _finish(partial);
      return;
    }
    if (!hasMoreToReveal) {
      _finish(
        ReplayEngine.run(plan: plan, futureCandles: bundle.futureCandles),
      );
    }
  }

  void _finish(TradeResult result) {
    _result = result;
    _score = ProcessScorer.score(plan: _plan!, bundle: bundle, result: result);
    _phase = SimulationPhase.review;
  }

  /// Ends the replay early, scoring what happened up to this point.
  void finishNow() {
    if (!_committed || _phase == SimulationPhase.review) return;
    revealAll();
    if (_phase != SimulationPhase.review) {
      _finish(
        _plan!.isNoTrade
            ? const TradeResult.noTrade()
            : ReplayEngine.run(
                plan: _plan!,
                futureCandles: bundle.futureCandles,
              ),
      );
    }
  }

  /// Virtual balance after this trade.
  double get endingBalance {
    final r = _result;
    if (r == null) return startingBalance;
    final next = startingBalance + r.profitLoss;
    return next.isFinite ? next : startingBalance;
  }
}
