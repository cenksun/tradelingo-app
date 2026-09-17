import 'package:meta/meta.dart';

import '../../core/formatters.dart';
import 'enums.dart';

/// A trade as it was planned, before any candles were revealed.
///
/// The plan is stored separately from anything that happens afterwards, so the
/// replay can never quietly rewrite the decision that was actually made.
@immutable
class TradePlan {
  const TradePlan({
    required this.direction,
    required this.entry,
    required this.stopLoss,
    required this.takeProfit,
    required this.riskPercent,
    required this.accountBalance,
    required this.positionSize,
    this.note,
  });

  /// The "no trade" plan: a real decision with no levels.
  const TradePlan.noTrade({required this.accountBalance, this.note})
    : direction = TradeDirection.noTrade,
      entry = 0,
      stopLoss = 0,
      takeProfit = 0,
      riskPercent = 0,
      positionSize = 0;

  final TradeDirection direction;
  final double entry;
  final double stopLoss;
  final double takeProfit;

  /// Percentage of the virtual balance risked, e.g. 1.0 for 1%.
  final double riskPercent;
  final double accountBalance;
  final double positionSize;
  final String? note;

  bool get isNoTrade => direction == TradeDirection.noTrade;
  bool get isLong => direction == TradeDirection.long;

  /// Price distance from entry to stop. Zero for a no-trade plan.
  double get stopDistance => isNoTrade ? 0 : (entry - stopLoss).abs();

  double get targetDistance => isNoTrade ? 0 : (takeProfit - entry).abs();

  /// Money at risk if the stop fills exactly at its level.
  double get riskAmount => isNoTrade ? 0 : stopDistance * positionSize;

  /// Planned reward-to-risk. Returns 0 when there is no defined risk.
  double get rewardToRisk {
    if (isNoTrade || stopDistance <= 0) return 0;
    return targetDistance / stopDistance;
  }

  double get plannedRiskFraction =>
      accountBalance <= 0 ? 0 : riskAmount / accountBalance;

  TradePlan copyWith({
    TradeDirection? direction,
    double? entry,
    double? stopLoss,
    double? takeProfit,
    double? riskPercent,
    double? accountBalance,
    double? positionSize,
    String? note,
  }) => TradePlan(
    direction: direction ?? this.direction,
    entry: entry ?? this.entry,
    stopLoss: stopLoss ?? this.stopLoss,
    takeProfit: takeProfit ?? this.takeProfit,
    riskPercent: riskPercent ?? this.riskPercent,
    accountBalance: accountBalance ?? this.accountBalance,
    positionSize: positionSize ?? this.positionSize,
    note: note ?? this.note,
  );

  @override
  String toString() => isNoTrade
      ? 'TradePlan(no trade)'
      : 'TradePlan(${direction.name} ${Fmt.price(entry)} '
            'SL ${Fmt.price(stopLoss)} TP ${Fmt.price(takeProfit)})';
}

/// The outcome of running a plan forward through candles.
@immutable
class TradeResult {
  const TradeResult({
    required this.outcome,
    required this.exitPrice,
    required this.exitIndex,
    required this.rMultiple,
    required this.profitLoss,
    this.ambiguousCandle = false,
  });

  const TradeResult.noTrade()
    : outcome = TradeOutcome.noTrade,
      exitPrice = 0,
      exitIndex = -1,
      rMultiple = 0,
      profitLoss = 0,
      ambiguousCandle = false;

  final TradeOutcome outcome;
  final double exitPrice;

  /// Index into the future candles where the trade closed.
  final int exitIndex;
  final double rMultiple;
  final double profitLoss;

  /// True when stop and target both sat inside the closing candle and the
  /// conservative rule had to decide.
  final bool ambiguousCandle;

  bool get isWin => profitLoss > 0;
  bool get isLoss => profitLoss < 0;
  bool get isNoTrade => outcome == TradeOutcome.noTrade;
}
