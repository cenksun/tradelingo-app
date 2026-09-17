import '../models/enums.dart';
import '../models/market.dart';
import '../models/trade.dart';
import 'risk_calculator.dart';

/// Runs a [TradePlan] forward through candles and decides how it finished.
///
/// ## The ambiguous-candle rule
///
/// A candle records open, high, low and close but **not the order in which the
/// high and the low were reached**. When a single candle contains both the stop
/// and the target, there is genuinely no way to know from that candle which was
/// touched first.
///
/// This engine resolves that case with one fixed, conservative rule:
///
/// > **If both the stop loss and the take profit lie within the same candle's
/// > range, the stop is treated as having been hit first.**
///
/// The rule is conservative by design. A simulator that resolved ties in the
/// learner's favour would inflate every result and teach the wrong lesson about
/// how often a plan actually works. Ambiguous closes are flagged on the result
/// so the review screen can say so explicitly rather than hiding it.
///
/// An entry gap is handled the same way: if the very first future candle
/// already contains both levels, the stop still wins.
class ReplayEngine {
  const ReplayEngine._();

  /// Evaluates [plan] against [futureCandles], which must start at the first
  /// candle *after* the decision point.
  static TradeResult run({
    required TradePlan plan,
    required List<Candle> futureCandles,
  }) {
    if (plan.isNoTrade) return const TradeResult.noTrade();
    if (futureCandles.isEmpty) {
      return const TradeResult(
        outcome: TradeOutcome.invalid,
        exitPrice: 0,
        exitIndex: -1,
        rMultiple: 0,
        profitLoss: 0,
      );
    }
    if (plan.stopDistance <= 0 || plan.positionSize <= 0) {
      return const TradeResult(
        outcome: TradeOutcome.invalid,
        exitPrice: 0,
        exitIndex: -1,
        rMultiple: 0,
        profitLoss: 0,
      );
    }

    final isLong = plan.isLong;

    for (var i = 0; i < futureCandles.length; i++) {
      final c = futureCandles[i];
      if (!c.isValid) continue;

      final stopTouched = isLong
          ? c.low <= plan.stopLoss
          : c.high >= plan.stopLoss;
      final targetTouched = isLong
          ? c.high >= plan.takeProfit
          : c.low <= plan.takeProfit;

      if (stopTouched && targetTouched) {
        // Ambiguous: resolve conservatively in favour of the stop.
        return _close(
          plan: plan,
          exitPrice: plan.stopLoss,
          index: i,
          outcome: TradeOutcome.stopHit,
          ambiguous: true,
        );
      }
      if (stopTouched) {
        return _close(
          plan: plan,
          exitPrice: plan.stopLoss,
          index: i,
          outcome: TradeOutcome.stopHit,
        );
      }
      if (targetTouched) {
        return _close(
          plan: plan,
          exitPrice: plan.takeProfit,
          index: i,
          outcome: TradeOutcome.targetHit,
        );
      }
    }

    // Neither level was reached before the data ran out.
    final last = futureCandles.last;
    return _close(
      plan: plan,
      exitPrice: last.close,
      index: futureCandles.length - 1,
      outcome: TradeOutcome.timeExit,
    );
  }

  /// Evaluates the plan against only the first [revealed] future candles.
  ///
  /// Used by the step-by-step replay so the UI can show the position closing at
  /// the right moment without ever reading candles the learner has not seen.
  static TradeResult? runPartial({
    required TradePlan plan,
    required List<Candle> futureCandles,
    required int revealed,
  }) {
    if (plan.isNoTrade) return const TradeResult.noTrade();
    if (revealed <= 0) return null;
    final slice = futureCandles.take(revealed).toList(growable: false);
    final result = run(plan: plan, futureCandles: slice);
    if (result.outcome == TradeOutcome.timeExit &&
        revealed < futureCandles.length) {
      // Still open — the data simply has not been revealed yet.
      return null;
    }
    return result;
  }

  /// Unrealised result at a given point in the replay, for the running P&L
  /// display. Never reads beyond [revealed].
  static double unrealisedProfit({
    required TradePlan plan,
    required List<Candle> futureCandles,
    required int revealed,
  }) {
    if (plan.isNoTrade || revealed <= 0 || futureCandles.isEmpty) return 0;
    final index = (revealed - 1).clamp(0, futureCandles.length - 1);
    return RiskCalculator.profitLoss(
      direction: plan.direction,
      entry: plan.entry,
      exitPrice: futureCandles[index].close,
      positionSize: plan.positionSize,
    );
  }

  static TradeResult _close({
    required TradePlan plan,
    required double exitPrice,
    required int index,
    required TradeOutcome outcome,
    bool ambiguous = false,
  }) {
    final r = RiskCalculator.rMultiple(
      direction: plan.direction,
      entry: plan.entry,
      stopLoss: plan.stopLoss,
      exitPrice: exitPrice,
    );
    final pl = RiskCalculator.profitLoss(
      direction: plan.direction,
      entry: plan.entry,
      exitPrice: exitPrice,
      positionSize: plan.positionSize,
    );
    return TradeResult(
      outcome: outcome,
      exitPrice: exitPrice,
      exitIndex: index,
      rMultiple: r,
      profitLoss: pl,
      ambiguousCandle: ambiguous,
    );
  }
}
