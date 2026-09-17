import 'dart:math' as math;

import 'package:meta/meta.dart';

import '../../core/formatters.dart';
import '../models/chart_series.dart';
import '../models/enums.dart';
import '../models/market.dart';
import '../models/scenario.dart';
import '../models/trade.dart';
import 'risk_calculator.dart';

/// One graded dimension of a decision.
@immutable
class ProcessComponent {
  const ProcessComponent({
    required this.label,
    required this.score,
    required this.weight,
    required this.comment,
    this.subjective = false,
  });

  final String label;

  /// 0..100.
  final double score;
  final double weight;
  final String comment;

  /// True when the dimension involves judgement rather than arithmetic; the UI
  /// phrases these as opinions rather than corrections.
  final bool subjective;
}

/// The result of grading one simulated decision.
@immutable
class ProcessScore {
  const ProcessScore({
    required this.total,
    required this.components,
    required this.strengths,
    required this.improvements,
    required this.mistakes,
  });

  /// 0..100.
  final double total;
  final List<ProcessComponent> components;
  final List<String> strengths;
  final List<String> improvements;
  final List<MistakeTag> mistakes;

  String get band {
    if (total >= 85) return 'Excellent process';
    if (total >= 70) return 'Solid process';
    if (total >= 50) return 'Mixed process';
    if (total >= 30) return 'Weak process';
    return 'Poor process';
  }
}

/// Grades *how a decision was made*, not whether it made money.
///
/// This is the most important scoring decision in the app. A reckless trade
/// that happened to win scores badly; a disciplined trade that lost scores
/// well. Grading outcomes would teach exactly the habit that ruins accounts.
///
/// Where a dimension genuinely involves judgement — which direction to take on
/// a readable chart — it is marked [ProcessComponent.subjective] and the
/// feedback is phrased as a view rather than a correction.
class ProcessScorer {
  const ProcessScorer._();

  static ProcessScore score({
    required TradePlan plan,
    required ScenarioBundle bundle,
    TradeResult? result,
  }) {
    return plan.isNoTrade
        ? _scoreNoTrade(plan: plan, bundle: bundle)
        : _scoreTrade(plan: plan, bundle: bundle, result: result);
  }

  // ------------------------------------------------------------ no trade ---

  static ProcessScore _scoreNoTrade({
    required TradePlan plan,
    required ScenarioBundle bundle,
  }) {
    final scenario = bundle.scenario;
    final wasUnclear =
        !scenario.preferenceIsStrong ||
        scenario.educationallyPreferred == TradeDirection.noTrade;

    final components = <ProcessComponent>[
      const ProcessComponent(
        label: 'Capital protection',
        score: 100,
        weight: 30,
        comment:
            'Nothing was risked, so nothing could be lost on this scenario.',
      ),
      ProcessComponent(
        label: 'Reading the conditions',
        score: wasUnclear ? 100 : 58,
        weight: 45,
        subjective: true,
        comment: wasUnclear
            ? 'The structure here was mixed or the volatility was high, so standing aside fits '
                  'the framework this app teaches.'
            : 'The structure on this chart was readable and there was room to a prior swing, so '
                  'a position was available. Passing is defensible — being selective costs '
                  'nothing — but it is worth checking whether you passed on the chart or on the '
                  'discomfort.',
      ),
      const ProcessComponent(
        label: 'Decision discipline',
        score: 100,
        weight: 25,
        comment: 'Choosing not to act is a decision, and recording it keeps your sample honest.',
      ),
    ];

    final strengths = <String>[
      'You made a deliberate no-trade decision rather than forcing a position.',
      if (wasUnclear)
        'This chart did not offer a clear invalidation level, which is exactly when standing '
            'aside is worth the most.',
    ];
    final improvements = <String>[
      if (!wasUnclear)
        'The structure here was readable. Try writing down the level that would have '
            'invalidated a position — if you can name one, a trade was available.',
      if (wasUnclear)
        'Nothing to change here. Charts like this one are the majority, and passing on them is '
            'the habit that keeps costs down.',
    ];

    return ProcessScore(
      total: _weighted(components),
      components: components,
      strengths: strengths,
      improvements: improvements,
      mistakes: wasUnclear ? const [] : const [MistakeTag.hesitation],
    );
  }

  // --------------------------------------------------------------- trade ---

  static ProcessScore _scoreTrade({
    required TradePlan plan,
    required ScenarioBundle bundle,
    TradeResult? result,
  }) {
    final components = <ProcessComponent>[];
    final strengths = <String>[];
    final improvements = <String>[];
    final mistakes = <MistakeTag>[];

    // 1. Risk discipline -----------------------------------------------------
    final riskPct = plan.riskPercent;
    final (double riskScore, String riskComment) = _gradeRisk(riskPct);
    components.add(
      ProcessComponent(
        label: 'Risk discipline',
        score: riskScore,
        weight: 30,
        comment: riskComment,
      ),
    );
    if (riskScore >= 85) {
      strengths.add(
        'Your risk stayed within the conservative training band '
        '(${Fmt.percent(riskPct, decimals: 2)} of the virtual account).',
      );
    } else {
      improvements.add(
        'Risking ${Fmt.percent(riskPct, decimals: 2)} per trade compounds quickly across a '
        'losing run. A smaller fixed percentage is what makes a streak survivable.',
      );
      mistakes.add(MistakeTag.overRisk);
    }

    // 2. Invalidation logic --------------------------------------------------
    final protective = _protectiveSwing(bundle, plan.direction);
    if (protective == null) {
      components.add(
        const ProcessComponent(
          label: 'Invalidation logic',
          score: 60,
          weight: 22,
          subjective: true,
          comment:
              'There was no clean swing in the visible window to measure the stop against, '
              'so this dimension could not be graded strictly.',
        ),
      );
    } else {
      final beyond = plan.isLong
          ? plan.stopLoss < protective.price
          : plan.stopLoss > protective.price;
      final distanceBeyond = (plan.stopLoss - protective.price).abs();
      final entryToSwing = (plan.entry - protective.price).abs();
      final overshoot = entryToSwing <= 0 ? 0.0 : distanceBeyond / entryToSwing;

      double score;
      String comment;
      if (!beyond) {
        score = 22;
        comment =
            'Your stop sat inside the recent swing at ${Fmt.price(protective.price)}, so ordinary '
            'movement around that swing could take the position out before the idea had actually '
            'been proven wrong.';
        mistakes.add(MistakeTag.stopTooTight);
        improvements.add(
          'Place the stop just beyond the swing that defines the idea, then reduce position size '
          'so the money risked stays the same.',
        );
      } else if (overshoot > 1.4) {
        score = 45;
        comment =
            'Your stop sat a long way past the swing at ${Fmt.price(protective.price)}. That keeps '
            'the position alive after the reason for it has gone, and it costs size.';
        mistakes.add(MistakeTag.stopTooWide);
        improvements.add(
          'A stop much further than the invalidation swing means a smaller position for the same '
          'risk, and a larger loss when it is reached.',
        );
      } else {
        score = 96;
        comment =
            'Your stop sat just beyond the swing at ${Fmt.price(protective.price)} — the level that '
            'would make this idea wrong.';
        strengths.add(
          'Your stop was placed against structure rather than against a round number or a '
          'comfortable loss size.',
        );
      }
      components.add(
        ProcessComponent(
          label: 'Invalidation logic',
          score: score,
          weight: 22,
          comment: comment,
        ),
      );
    }

    // 3. Reward quality ------------------------------------------------------
    final rr = plan.rewardToRisk;
    final (double rrScore, String rrComment) = _gradeRewardToRisk(rr);
    components.add(
      ProcessComponent(
        label: 'Reward-to-risk',
        score: rrScore,
        weight: 20,
        comment: rrComment,
      ),
    );
    if (rr >= 2) {
      strengths.add(
        'Planned reward-to-risk of ${Fmt.ratio(rr)} leaves room to be wrong more often than you '
        'are right.',
      );
    } else if (rr < 1) {
      mistakes.add(MistakeTag.poorRr);
      improvements.add(
        'At ${Fmt.ratio(rr)} this plan risks more than it stands to make, which needs a high hit '
        'rate just to break even.',
      );
    }

    // 4. Stop distance against normal movement ------------------------------
    final atr = _atr(bundle.visibleCandles);
    if (atr > 0 && plan.stopDistance > 0) {
      final multiple = plan.stopDistance / atr;
      double score;
      String comment;
      if (multiple < 0.55) {
        score = 34;
        comment =
            'Your stop was ${multiple.toStringAsFixed(2)}× the average candle range on this chart. '
            'That sits inside ordinary movement for this instrument.';
        if (!mistakes.contains(MistakeTag.stopTooTight)) {
          mistakes.add(MistakeTag.stopTooTight);
        }
      } else if (multiple > 7) {
        score = 44;
        comment =
            'Your stop was ${multiple.toStringAsFixed(1)}× the average candle range. A stop that '
            'wide needs a much larger move to be worth the risk taken.';
        if (!mistakes.contains(MistakeTag.stopTooWide)) {
          mistakes.add(MistakeTag.stopTooWide);
        }
      } else {
        score = 92;
        comment =
            'Your stop was ${multiple.toStringAsFixed(1)}× the average candle range — outside the '
            'noise, without being so wide that the trade needs an outsized move.';
      }
      components.add(
        ProcessComponent(
          label: 'Stop vs normal movement',
          score: score,
          weight: 13,
          comment: comment,
        ),
      );
    }

    // 5. Direction reasoning (only where the chart supports a firm view) -----
    final scenario = bundle.scenario;
    if (scenario.preferenceIsStrong &&
        scenario.educationallyPreferred != TradeDirection.noTrade) {
      final aligned = plan.direction == scenario.educationallyPreferred;
      components.add(
        ProcessComponent(
          label: 'Direction reasoning',
          score: aligned ? 94 : 46,
          weight: 15,
          subjective: true,
          comment: aligned
              ? 'Your direction matched the structure visible at the decision point.'
              : 'The visible structure read as '
                    '${scenario.educationallyPreferred.label.toLowerCase()} within this app\'s '
                    'framework. Counter-structure trades are not wrong in principle, but they '
                    'need a clearer reason and usually more room.',
        ),
      );
      if (!aligned) {
        mistakes.add(MistakeTag.trendMisread);
        improvements.add(
          'Before choosing a direction, label the swings left to right. The sequence here read '
          'as ${scenario.educationallyPreferred.label.toLowerCase()}.',
        );
      } else {
        strengths.add('Your direction followed the structure on the chart.');
      }
    } else {
      components.add(
        const ProcessComponent(
          label: 'Direction reasoning',
          score: 70,
          weight: 15,
          subjective: true,
          comment:
              'The structure here was mixed, so there is no single correct direction to '
              'grade against. On charts like this, standing aside is also a strong answer.',
        ),
      );
      if (scenario.educationallyPreferred == TradeDirection.noTrade) {
        mistakes.add(MistakeTag.missedNoTrade);
        improvements.add(
          'This chart had no clear structure or invalidation level. Passing on charts like this '
          'is what keeps costs down over a long run of trades.',
        );
      }
    }

    // Outcome is deliberately excluded from the score, but it is worth saying
    // so out loud in the feedback.
    if (result != null && !result.isNoTrade) {
      if (result.isWin && _weighted(components) < 55) {
        improvements.add(
          'This trade finished at ${Fmt.rMultiple(result.rMultiple)}, but the plan behind it had '
          'real problems. Repeated often, a process like this loses regardless of how this one '
          'turned out.',
        );
      } else if (result.isLoss && _weighted(components) >= 75) {
        strengths.add(
          'This trade lost, and the plan behind it was sound. Losses like this are the expected '
          'cost of trading a sound process.',
        );
      }
      if (result.ambiguousCandle) {
        improvements.add(
          'Your stop and target both sat inside a single candle, so the simulator applied its '
          'conservative rule and treated the stop as hit first. Levels that close together are '
          'worth avoiding for exactly this reason.',
        );
      }
    }

    return ProcessScore(
      total: _weighted(components),
      components: components,
      strengths: strengths,
      improvements: improvements,
      mistakes: mistakes.toSet().toList(growable: false),
    );
  }

  // ------------------------------------------------------------- helpers ---

  static (double, String) _gradeRisk(double riskPercent) {
    if (riskPercent <= 0) {
      return (0, 'No risk percentage was set for this plan.');
    }
    if (riskPercent <= RiskCalculator.conservativeRiskCeiling) {
      return (
        98,
        'Risk of ${Fmt.percent(riskPercent, decimals: 2)} sits inside the conservative training '
            'band, which is what makes a run of losses survivable.',
      );
    }
    if (riskPercent <= RiskCalculator.highRiskThreshold) {
      return (
        74,
        'Risk of ${Fmt.percent(riskPercent, decimals: 2)} is a little above the conservative band '
            'used for scoring here.',
      );
    }
    if (riskPercent <= RiskCalculator.extremeRiskThreshold) {
      return (
        34,
        'Risk of ${Fmt.percent(riskPercent, decimals: 2)} per trade means a handful of losses in a '
            'row would cut the account substantially.',
      );
    }
    // Scales down towards zero as risk climbs, rather than stopping at a floor.
    final over = (riskPercent - RiskCalculator.extremeRiskThreshold) / 40;
    final score = math.max(0.0, 18 - over * 18);
    return (
      score,
      'Risk of ${Fmt.percent(riskPercent, decimals: 2)} on one position produces very large '
          'drawdowns when it goes wrong. The simulator allowed the experiment; this is what it '
          'costs in process terms.',
    );
  }

  static (double, String) _gradeRewardToRisk(double rr) {
    if (rr <= 0) {
      return (
        0,
        'No target was set, so there is no reward to measure against the risk.',
      );
    }
    if (rr >= 3) {
      return (
        98,
        'Planned reward-to-risk of ${Fmt.ratio(rr)} — one win covers three losses of the same '
            'size.',
      );
    }
    if (rr >= 2) {
      return (
        90,
        'Planned reward-to-risk of ${Fmt.ratio(rr)} gives room to be wrong regularly.',
      );
    }
    if (rr >= 1.5) {
      return (
        74,
        'Planned reward-to-risk of ${Fmt.ratio(rr)} is workable, though it needs a reasonable hit '
            'rate.',
      );
    }
    if (rr >= 1) {
      return (
        52,
        'Planned reward-to-risk of ${Fmt.ratio(rr)} means you need to win more than half the time '
            'just to cover costs.',
      );
    }
    return (
      20,
      'Planned reward-to-risk of ${Fmt.ratio(rr)} risks more than the trade stands to make.',
    );
  }

  /// The swing the stop should sit beyond, taken from the visible window only.
  static SwingPoint? _protectiveSwing(
    ScenarioBundle bundle,
    TradeDirection direction,
  ) {
    final wantHigh = direction == TradeDirection.short;
    final candidates = bundle.visibleSwings
        .where((s) => s.isHigh == wantHigh)
        .toList();
    if (candidates.isEmpty) return null;
    return candidates.last;
  }

  static double _atr(List<Candle> candles, {int period = 14}) {
    if (candles.length < 2) return 0;
    final start = math.max(1, candles.length - period);
    var sum = 0.0;
    var count = 0;
    for (var i = start; i < candles.length; i++) {
      final c = candles[i];
      final prevClose = candles[i - 1].close;
      final tr = [
        c.high - c.low,
        (c.high - prevClose).abs(),
        (c.low - prevClose).abs(),
      ].reduce(math.max);
      sum += tr;
      count++;
    }
    return count == 0 ? 0 : sum / count;
  }

  static double _weighted(List<ProcessComponent> components) {
    if (components.isEmpty) return 0;
    var weighted = 0.0;
    var total = 0.0;
    for (final c in components) {
      weighted += c.score * c.weight;
      total += c.weight;
    }
    if (total <= 0) return 0;
    final value = weighted / total;
    return value.isFinite ? value.clamp(0.0, 100.0) : 0;
  }
}
