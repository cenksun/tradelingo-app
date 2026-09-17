import 'package:meta/meta.dart';

import '../models/enums.dart';
import '../models/trade.dart';

/// Severity of a validation message.
enum IssueLevel { error, warning, info }

@immutable
class TradeIssue {
  const TradeIssue(this.level, this.message, {this.field});

  final IssueLevel level;
  final String message;

  /// Which input the message refers to: `entry`, `stop`, `target`, `risk`.
  final String? field;

  bool get isError => level == IssueLevel.error;
}

@immutable
class TradeValidation {
  const TradeValidation(this.issues);

  final List<TradeIssue> issues;

  bool get isValid => !issues.any((i) => i.isError);
  List<TradeIssue> get errors => issues.where((i) => i.isError).toList();
  List<TradeIssue> get warnings =>
      issues.where((i) => i.level == IssueLevel.warning).toList();
}

/// All position-sizing and reward-to-risk arithmetic.
///
/// Every method is defensive: a zero stop distance, a negative balance or a
/// non-finite input returns a safe value rather than `NaN` or `Infinity`, so
/// the UI can never render one.
class RiskCalculator {
  const RiskCalculator._();

  /// Risk levels above this are allowed but flagged as an experiment.
  static const double highRiskThreshold = 3.0;

  /// Risk levels above this trigger the strongest educational warning.
  static const double extremeRiskThreshold = 10.0;

  /// The band considered good practice by the training scoring.
  static const double conservativeRiskCeiling = 2.0;

  static double riskAmount({
    required double balance,
    required double riskPercent,
  }) {
    if (!balance.isFinite || !riskPercent.isFinite) return 0;
    if (balance <= 0 || riskPercent <= 0) return 0;
    return balance * (riskPercent / 100);
  }

  /// Position size = risk amount ÷ stop distance.
  ///
  /// Returns 0 when the stop distance is zero or the inputs are unusable,
  /// which is what stops a division by zero reaching the UI.
  static double positionSize({
    required double riskAmount,
    required double stopDistance,
  }) {
    if (!riskAmount.isFinite || !stopDistance.isFinite) return 0;
    if (riskAmount <= 0 || stopDistance <= 0) return 0;
    final size = riskAmount / stopDistance;
    if (!size.isFinite || size <= 0) return 0;
    return size;
  }

  static double rewardToRisk({
    required double entry,
    required double stopLoss,
    required double takeProfit,
  }) {
    if (!entry.isFinite || !stopLoss.isFinite || !takeProfit.isFinite) return 0;
    final risk = (entry - stopLoss).abs();
    if (risk <= 0) return 0;
    final reward = (takeProfit - entry).abs();
    final rr = reward / risk;
    return rr.isFinite ? rr : 0;
  }

  /// R multiple of a closed trade.
  static double rMultiple({
    required TradeDirection direction,
    required double entry,
    required double stopLoss,
    required double exitPrice,
  }) {
    if (direction == TradeDirection.noTrade) return 0;
    if (!entry.isFinite || !stopLoss.isFinite || !exitPrice.isFinite) return 0;
    final risk = (entry - stopLoss).abs();
    if (risk <= 0) return 0;
    final move = direction == TradeDirection.long
        ? exitPrice - entry
        : entry - exitPrice;
    final r = move / risk;
    return r.isFinite ? r : 0;
  }

  static double profitLoss({
    required TradeDirection direction,
    required double entry,
    required double exitPrice,
    required double positionSize,
  }) {
    if (direction == TradeDirection.noTrade) return 0;
    if (!entry.isFinite || !exitPrice.isFinite || !positionSize.isFinite) {
      return 0;
    }
    final move = direction == TradeDirection.long
        ? exitPrice - entry
        : entry - exitPrice;
    final pl = move * positionSize;
    return pl.isFinite ? pl : 0;
  }

  /// Builds a complete plan from the inputs a learner supplies, deriving
  /// position size rather than accepting it.
  static TradePlan buildPlan({
    required TradeDirection direction,
    required double entry,
    required double stopLoss,
    required double takeProfit,
    required double riskPercent,
    required double balance,
    String? note,
  }) {
    if (direction == TradeDirection.noTrade) {
      return TradePlan.noTrade(accountBalance: balance, note: note);
    }
    final amount = riskAmount(balance: balance, riskPercent: riskPercent);
    final distance = (entry - stopLoss).abs();
    final size = positionSize(riskAmount: amount, stopDistance: distance);
    return TradePlan(
      direction: direction,
      entry: entry,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      riskPercent: riskPercent,
      accountBalance: balance,
      positionSize: size,
      note: note,
    );
  }

  /// Checks a plan and explains anything wrong with it.
  ///
  /// Errors block the simulation; warnings do not. Extreme risk is a warning
  /// rather than an error on purpose — the simulator lets a learner run the
  /// experiment and then shows what it did to the process score.
  static TradeValidation validate(TradePlan plan) {
    final issues = <TradeIssue>[];

    if (plan.isNoTrade) {
      return const TradeValidation([]);
    }

    if (!plan.entry.isFinite || plan.entry <= 0) {
      issues.add(
        const TradeIssue(
          IssueLevel.error,
          'Entry price must be a positive number.',
          field: 'entry',
        ),
      );
    }
    if (!plan.stopLoss.isFinite || plan.stopLoss <= 0) {
      issues.add(
        const TradeIssue(
          IssueLevel.error,
          'Stop loss must be a positive number.',
          field: 'stop',
        ),
      );
    }
    if (!plan.takeProfit.isFinite || plan.takeProfit <= 0) {
      issues.add(
        const TradeIssue(
          IssueLevel.error,
          'Take profit must be a positive number.',
          field: 'target',
        ),
      );
    }
    if (issues.isNotEmpty) return TradeValidation(issues);

    if (plan.isLong) {
      if (plan.stopLoss >= plan.entry) {
        issues.add(
          const TradeIssue(
            IssueLevel.error,
            'For a long, the stop belongs below the entry. Placed above it, the order would '
            'close the position the moment it opened.',
            field: 'stop',
          ),
        );
      }
      if (plan.takeProfit <= plan.entry) {
        issues.add(
          const TradeIssue(
            IssueLevel.error,
            'For a long, the target belongs above the entry.',
            field: 'target',
          ),
        );
      }
    } else {
      if (plan.stopLoss <= plan.entry) {
        issues.add(
          const TradeIssue(
            IssueLevel.error,
            'For a short, the stop belongs above the entry. Placed below it, the order would '
            'close the position the moment it opened.',
            field: 'stop',
          ),
        );
      }
      if (plan.takeProfit >= plan.entry) {
        issues.add(
          const TradeIssue(
            IssueLevel.error,
            'For a short, the target belongs below the entry.',
            field: 'target',
          ),
        );
      }
    }

    if (plan.stopDistance <= 0) {
      issues.add(
        const TradeIssue(
          IssueLevel.error,
          'Entry and stop are at the same price, so there is no risk distance to size from.',
          field: 'stop',
        ),
      );
    }

    if (plan.riskPercent <= 0) {
      issues.add(
        const TradeIssue(
          IssueLevel.error,
          'Choose a risk percentage greater than zero.',
          field: 'risk',
        ),
      );
    }

    if (plan.positionSize <= 0 &&
        plan.stopDistance > 0 &&
        plan.riskPercent > 0) {
      issues.add(
        const TradeIssue(
          IssueLevel.error,
          'The calculated position size came out at zero. Check the balance and the stop distance.',
          field: 'risk',
        ),
      );
    }

    // Educational warnings — these never block the trade.
    if (plan.riskPercent > extremeRiskThreshold) {
      issues.add(
        TradeIssue(
          IssueLevel.warning,
          'Risking ${plan.riskPercent.toStringAsFixed(1)}% of an account on one position can '
          'produce very large drawdowns, and a short run of losses at this level is difficult '
          'to recover from. This simulator will run the experiment, and it will lower your '
          'Risk Discipline score.',
          field: 'risk',
        ),
      );
    } else if (plan.riskPercent > highRiskThreshold) {
      issues.add(
        TradeIssue(
          IssueLevel.warning,
          'Risking ${plan.riskPercent.toStringAsFixed(1)}% per trade is well above the '
          'conservative training band used for scoring here. The trade is allowed; your Risk '
          'Discipline score will reflect it.',
          field: 'risk',
        ),
      );
    }

    final rr = plan.rewardToRisk;
    if (rr > 0 && rr < 1) {
      issues.add(
        TradeIssue(
          IssueLevel.warning,
          'Reward-to-risk is ${rr.toStringAsFixed(2)}, so this plan risks more than it stands to '
          'make. That needs a high hit rate to break even.',
          field: 'target',
        ),
      );
    }

    if (plan.accountBalance > 0 &&
        plan.positionSize * plan.entry > plan.accountBalance * 20) {
      issues.add(
        const TradeIssue(
          IssueLevel.warning,
          'This position is very large relative to the account, which implies substantial '
          'leverage. The stop may be unusually tight for this instrument.',
          field: 'stop',
        ),
      );
    }

    return TradeValidation(issues);
  }
}
