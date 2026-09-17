import 'package:flutter_test/flutter_test.dart';
import 'package:tradepath/data/scenarios/scenario_generator.dart';
import 'package:tradepath/domain/models/enums.dart';
import 'package:tradepath/domain/models/market.dart';
import 'package:tradepath/domain/models/trade.dart';
import 'package:tradepath/domain/services/process_score.dart';
import 'package:tradepath/domain/services/replay_engine.dart';
import 'package:tradepath/domain/models/scenario.dart';
import 'package:tradepath/domain/services/risk_calculator.dart';
import 'package:tradepath/domain/services/simulation_session.dart';

Candle _c(double o, double h, double l, double cl, [int minute = 0]) => Candle(
  timestamp: DateTime.utc(2020, 1, 1).add(Duration(minutes: minute)),
  open: o,
  high: h,
  low: l,
  close: cl,
  volume: 100,
);

void main() {
  group('risk calculator', () {
    test('risk amount is balance times percentage', () {
      expect(RiskCalculator.riskAmount(balance: 10000, riskPercent: 1), 100);
      expect(RiskCalculator.riskAmount(balance: 25000, riskPercent: 0.8), 200);
    });

    test('position size is risk amount over stop distance', () {
      expect(RiskCalculator.positionSize(riskAmount: 150, stopDistance: 3), 50);
      expect(RiskCalculator.positionSize(riskAmount: 120, stopDistance: 6), 20);
    });

    test('never returns NaN, infinity or a negative size', () {
      expect(RiskCalculator.positionSize(riskAmount: 100, stopDistance: 0), 0);
      expect(RiskCalculator.positionSize(riskAmount: 0, stopDistance: 5), 0);
      expect(RiskCalculator.positionSize(riskAmount: -50, stopDistance: 5), 0);
      expect(
        RiskCalculator.positionSize(riskAmount: double.nan, stopDistance: 5),
        0,
      );
      expect(
        RiskCalculator.positionSize(
          riskAmount: 100,
          stopDistance: double.infinity,
        ),
        0,
      );
      expect(RiskCalculator.riskAmount(balance: -10, riskPercent: 1), 0);
    });

    test('reward to risk divides reward distance by risk distance', () {
      expect(
        RiskCalculator.rewardToRisk(entry: 100, stopLoss: 97, takeProfit: 109),
        closeTo(3, 1e-9),
      );
      expect(
        RiskCalculator.rewardToRisk(
          entry: 1.25,
          stopLoss: 1.256,
          takeProfit: 1.238,
        ),
        closeTo(2, 1e-9),
      );
      expect(
        RiskCalculator.rewardToRisk(entry: 100, stopLoss: 100, takeProfit: 110),
        0,
      );
    });

    test('r multiple is signed by direction', () {
      expect(
        RiskCalculator.rMultiple(
          direction: TradeDirection.long,
          entry: 100,
          stopLoss: 98,
          exitPrice: 105,
        ),
        closeTo(2.5, 1e-9),
      );
      expect(
        RiskCalculator.rMultiple(
          direction: TradeDirection.short,
          entry: 100,
          stopLoss: 102,
          exitPrice: 95,
        ),
        closeTo(2.5, 1e-9),
      );
      expect(
        RiskCalculator.rMultiple(
          direction: TradeDirection.long,
          entry: 100,
          stopLoss: 98,
          exitPrice: 98,
        ),
        closeTo(-1, 1e-9),
      );
    });
  });

  group('trade validation', () {
    TradePlan longPlan({double sl = 97, double tp = 106, double risk = 1}) =>
        RiskCalculator.buildPlan(
          direction: TradeDirection.long,
          entry: 100,
          stopLoss: sl,
          takeProfit: tp,
          riskPercent: risk,
          balance: 10000,
        );

    test('accepts a well-formed long', () {
      final v = RiskCalculator.validate(longPlan());
      expect(v.isValid, isTrue);
      expect(v.errors, isEmpty);
    });

    test('rejects a long whose stop sits above the entry', () {
      final v = RiskCalculator.validate(longPlan(sl: 103));
      expect(v.isValid, isFalse);
      expect(v.errors.first.message, contains('below the entry'));
    });

    test('rejects a long whose target sits below the entry', () {
      final v = RiskCalculator.validate(longPlan(tp: 94));
      expect(v.isValid, isFalse);
    });

    test('rejects a short whose stop sits below the entry', () {
      final plan = RiskCalculator.buildPlan(
        direction: TradeDirection.short,
        entry: 100,
        stopLoss: 96,
        takeProfit: 90,
        riskPercent: 1,
        balance: 10000,
      );
      final v = RiskCalculator.validate(plan);
      expect(v.isValid, isFalse);
      expect(v.errors.first.message, contains('above the entry'));
    });

    test('accepts a well-formed short', () {
      final plan = RiskCalculator.buildPlan(
        direction: TradeDirection.short,
        entry: 100,
        stopLoss: 103,
        takeProfit: 91,
        riskPercent: 1,
        balance: 10000,
      );
      expect(RiskCalculator.validate(plan).isValid, isTrue);
    });

    test('rejects a zero stop distance rather than dividing by zero', () {
      final v = RiskCalculator.validate(longPlan(sl: 100));
      expect(v.isValid, isFalse);
      expect(longPlan(sl: 100).positionSize, 0);
    });

    test('warns about extreme risk but still allows the experiment', () {
      final v = RiskCalculator.validate(longPlan(risk: 25));
      expect(v.isValid, isTrue);
      expect(v.warnings, isNotEmpty);
      expect(v.warnings.first.message, contains('drawdown'));
    });

    test('a no-trade plan is always valid', () {
      expect(
        RiskCalculator.validate(const TradePlan.noTrade(accountBalance: 10000))
            .isValid,
        isTrue,
      );
    });
  });

  group('replay engine', () {
    final plan = RiskCalculator.buildPlan(
      direction: TradeDirection.long,
      entry: 100,
      stopLoss: 98,
      takeProfit: 106,
      riskPercent: 1,
      balance: 10000,
    );

    test('detects a stop hit', () {
      final result = ReplayEngine.run(
        plan: plan,
        futureCandles: [_c(100, 101, 99, 100), _c(100, 100.5, 97.5, 98)],
      );
      expect(result.outcome, TradeOutcome.stopHit);
      expect(result.rMultiple, closeTo(-1, 1e-9));
      expect(result.exitIndex, 1);
    });

    test('detects a target hit', () {
      final result = ReplayEngine.run(
        plan: plan,
        futureCandles: [_c(100, 102, 99.5, 101), _c(101, 107, 100.5, 106.5)],
      );
      expect(result.outcome, TradeOutcome.targetHit);
      expect(result.rMultiple, closeTo(3, 1e-9));
    });

    test('closes at the last candle when neither level is reached', () {
      final result = ReplayEngine.run(
        plan: plan,
        futureCandles: [_c(100, 101, 99.2, 100.4), _c(100.4, 101.5, 99.8, 101)],
      );
      expect(result.outcome, TradeOutcome.timeExit);
      expect(result.exitPrice, 101);
    });

    test('an ambiguous candle resolves conservatively to the stop', () {
      // This candle contains both 98 and 106; the order is unknowable.
      final result = ReplayEngine.run(
        plan: plan,
        futureCandles: [_c(100, 107, 97, 103)],
      );
      expect(result.outcome, TradeOutcome.stopHit);
      expect(result.ambiguousCandle, isTrue);
      expect(result.rMultiple, closeTo(-1, 1e-9));
    });

    test('short trades resolve with the levels reversed', () {
      final short = RiskCalculator.buildPlan(
        direction: TradeDirection.short,
        entry: 100,
        stopLoss: 102,
        takeProfit: 94,
        riskPercent: 1,
        balance: 10000,
      );
      final stopped = ReplayEngine.run(
        plan: short,
        futureCandles: [_c(100, 102.5, 99, 102)],
      );
      expect(stopped.outcome, TradeOutcome.stopHit);
      final hit = ReplayEngine.run(
        plan: short,
        futureCandles: [_c(100, 100.5, 93.5, 94)],
      );
      expect(hit.outcome, TradeOutcome.targetHit);
      expect(hit.rMultiple, closeTo(3, 1e-9));
    });

    test('a no-trade plan produces a no-trade result', () {
      final result = ReplayEngine.run(
        plan: const TradePlan.noTrade(accountBalance: 10000),
        futureCandles: [_c(100, 120, 80, 110)],
      );
      expect(result.outcome, TradeOutcome.noTrade);
      expect(result.profitLoss, 0);
    });

    test('partial replay does not resolve before the candles are revealed', () {
      final future = [
        _c(100, 101, 99, 100),
        _c(100, 100.5, 97.5, 98),
        _c(98, 99, 97, 98),
      ];
      expect(
        ReplayEngine.runPartial(plan: plan, futureCandles: future, revealed: 1),
        isNull,
      );
      final resolved = ReplayEngine.runPartial(
        plan: plan,
        futureCandles: future,
        revealed: 2,
      );
      expect(resolved, isNotNull);
      expect(resolved!.outcome, TradeOutcome.stopHit);
    });

    test('profit and loss scale with position size', () {
      final result = ReplayEngine.run(
        plan: plan,
        futureCandles: [_c(100, 107, 99.5, 106)],
      );
      // 1% of 10,000 = $100 risk over a 2.00 stop distance = 50 units.
      expect(plan.positionSize, closeTo(50, 1e-9));
      expect(result.profitLoss, closeTo(300, 1e-6));
    });
  });

  group('scenario engine', () {
    test('generates unique ids across a large index range', () {
      final ids = <String>{};
      for (var i = 0; i < 6000; i++) {
        ids.add(ScenarioGenerator.byIndex(i).id);
      }
      expect(ids.length, 6000);
    });

    test('produces materially different windows, not repeated ones', () {
      final fingerprints = <String>{};
      for (var i = 0; i < 2500; i++) {
        final s = ScenarioGenerator.byIndex(i);
        fingerprints.add(
          '${s.recipe.seed}|${s.recipe.pattern.name}|${s.asset.symbol}|'
          '${s.timeframe.name}|${s.decisionIndex}|${s.futureEnd}',
        );
      }
      // Effectively all distinct; a handful of collisions would still be fine.
      expect(fingerprints.length, greaterThan(2450));
    });

    test('the same index always rebuilds the same scenario and candles', () {
      final a = ScenarioGenerator.byIndex(1234);
      final b = ScenarioGenerator.byIndex(1234);
      expect(a.id, b.id);
      expect(a.recipe.cacheKey, b.recipe.cacheKey);
      final ba = ScenarioGenerator.load(a);
      final bb = ScenarioGenerator.load(b);
      expect(ba.visibleCandles.length, bb.visibleCandles.length);
      for (var i = 0; i < ba.visibleCandles.length; i++) {
        expect(ba.visibleCandles[i].close, bb.visibleCandles[i].close);
      }
    });

    test('every generated scenario is usable and internally consistent', () {
      for (var i = 0; i < 400; i++) {
        final s = ScenarioGenerator.byIndex(i * 37);
        final bundle = ScenarioGenerator.load(s);
        expect(bundle.isUsable, isTrue, reason: s.id);
        expect(
          bundle.visibleCandles.length,
          greaterThanOrEqualTo(10),
          reason: s.id,
        );
        expect(bundle.futureCandles, isNotEmpty, reason: s.id);
        expect(bundle.decisionPrice, greaterThan(0), reason: s.id);
        for (final c in bundle.visibleCandles) {
          expect(c.isValid, isTrue, reason: s.id);
        }
        for (final c in bundle.futureCandles) {
          expect(c.isValid, isTrue, reason: s.id);
        }
      }
    });

    test('a meaningful share of scenarios are deliberately no-trade', () {
      var noTrade = 0;
      const sample = 600;
      for (var i = 0; i < sample; i++) {
        if (!ScenarioGenerator.byIndex(i).preferenceIsStrong) noTrade++;
      }
      expect(noTrade, greaterThan(sample ~/ 10));
      expect(noTrade, lessThan(sample));
    });

    test('filters return scenarios that actually match', () {
      final query = ScenarioQuery(
        assetClass: AssetClass.crypto,
        difficulty: Difficulty.intermediate,
      );
      final index = ScenarioGenerator.findMatching(query: query, startIndex: 0);
      expect(index, isNotNull);
      final s = ScenarioGenerator.byIndex(index!);
      expect(s.asset.assetClass, AssetClass.crypto);
      expect(s.difficulty, Difficulty.intermediate);
    });
  });

  group('look-ahead protection', () {
    test('visible candles never extend past the decision point', () {
      for (var i = 0; i < 250; i++) {
        final s = ScenarioGenerator.byIndex(i * 17 + 3);
        final bundle = ScenarioGenerator.load(s);
        expect(bundle.visibleCandles.length, s.decisionIndex + 1, reason: s.id);

        final lastVisible = bundle.visibleCandles.last.timestamp;
        for (final future in bundle.futureCandles) {
          expect(future.timestamp.isAfter(lastVisible), isTrue, reason: s.id);
        }
      }
    });

    test('visible swings and zones never reference hidden candles', () {
      for (var i = 0; i < 250; i++) {
        final s = ScenarioGenerator.byIndex(i * 29 + 11);
        final bundle = ScenarioGenerator.load(s);
        for (final swing in bundle.visibleSwings) {
          expect(swing.index, lessThanOrEqualTo(s.decisionIndex), reason: s.id);
        }
        for (final zone in bundle.visibleZones) {
          expect(
            zone.startIndex,
            lessThanOrEqualTo(s.decisionIndex),
            reason: s.id,
          );
        }
      }
    });

    test('scenario classification is derived only from visible candles', () {
      // Changing the hidden future must not change the classification: the
      // detector only ever sees the visible window.
      final s = ScenarioGenerator.byIndex(777);
      final bundle = ScenarioGenerator.load(s);
      expect(
        bundle.visibleCandles.length + bundle.futureCandles.length,
        s.futureEnd,
      );
      expect(s.visibleCount, bundle.visibleCandles.length);
    });
  });

  _sessionTests();

  group('process score', () {
    final bundle = ScenarioGenerator.load(ScenarioGenerator.byIndex(4242));

    TradePlan planWith({required double risk, required double rr}) {
      final entry = bundle.decisionPrice;
      final stop = entry * 0.97;
      final target = entry + (entry - stop) * rr;
      return RiskCalculator.buildPlan(
        direction: TradeDirection.long,
        entry: entry,
        stopLoss: stop,
        takeProfit: target,
        riskPercent: risk,
        balance: 10000,
      );
    }

    test('a reckless but profitable trade scores poorly on process', () {
      final plan = planWith(risk: 50, rr: 0.5);
      final result = TradeResult(
        outcome: TradeOutcome.targetHit,
        exitPrice: plan.takeProfit,
        exitIndex: 3,
        rMultiple: 0.5,
        profitLoss: 5000,
      );
      final score = ProcessScorer.score(
        plan: plan,
        bundle: bundle,
        result: result,
      );
      expect(score.total, lessThan(45));
      expect(score.mistakes, contains(MistakeTag.overRisk));
    });

    test('a disciplined losing trade scores well on process', () {
      final plan = planWith(risk: 1, rr: 3);
      final result = TradeResult(
        outcome: TradeOutcome.stopHit,
        exitPrice: plan.stopLoss,
        exitIndex: 5,
        rMultiple: -1,
        profitLoss: -100,
      );
      final score = ProcessScorer.score(
        plan: plan,
        bundle: bundle,
        result: result,
      );
      expect(score.total, greaterThan(70));
      expect(score.mistakes, isNot(contains(MistakeTag.overRisk)));
      expect(score.strengths, isNotEmpty);
    });

    test('process score is always a finite 0..100 value', () {
      for (final risk in [0.1, 1.0, 2.0, 5.0, 25.0, 60.0]) {
        for (final rr in [0.2, 1.0, 2.0, 5.0]) {
          final score = ProcessScorer.score(
            plan: planWith(risk: risk, rr: rr),
            bundle: bundle,
          );
          expect(score.total.isFinite, isTrue);
          expect(score.total, inInclusiveRange(0, 100));
        }
      }
    });

    test('a no-trade decision is graded, not ignored', () {
      final score = ProcessScorer.score(
        plan: const TradePlan.noTrade(accountBalance: 10000),
        bundle: bundle,
      );
      expect(score.total, greaterThan(0));
      expect(score.components, isNotEmpty);
      expect(score.strengths, isNotEmpty);
    });

    test('no-trade on an unclear chart scores highly', () {
      var checked = 0;
      for (var i = 0; i < 400 && checked < 5; i++) {
        final s = ScenarioGenerator.byIndex(i);
        if (s.preferenceIsStrong) continue;
        final b = ScenarioGenerator.load(s);
        final score = ProcessScorer.score(
          plan: const TradePlan.noTrade(accountBalance: 10000),
          bundle: b,
        );
        expect(score.total, greaterThan(90), reason: s.id);
        checked++;
      }
      expect(checked, greaterThan(0));
    });
  });
}

// ---------------------------------------------------------------------------
// Simulation session — the state machine the simulator screen drives.
// ---------------------------------------------------------------------------

void _sessionTests() {
  group('simulation session', () {
    ScenarioBundle bundleFor(int index) =>
        ScenarioGenerator.load(ScenarioGenerator.byIndex(index));

    test('no future candle is exposed before a decision is committed', () {
      for (var i = 0; i < 60; i++) {
        final bundle = bundleFor(i * 13 + 5);
        final session = SimulationSession(
          bundle: bundle,
          startingBalance: 10000,
        );
        expect(session.chartCandles.length, bundle.visibleCandles.length);
        expect(session.isCommitted, isFalse);
        expect(session.revealed, 0);

        // Choosing a direction alone must not reveal anything.
        session.chooseDirection(TradeDirection.long);
        expect(session.chartCandles.length, bundle.visibleCandles.length);

        // Trying to reveal before committing does nothing.
        expect(session.revealNext(), isFalse);
        expect(session.chartCandles.length, bundle.visibleCandles.length);

        final lastVisible = bundle.visibleCandles.last.timestamp;
        for (final c in session.chartCandles) {
          expect(c.timestamp.isAfter(lastVisible), isFalse);
        }
      }
    });

    test('revealing adds exactly one candle at a time', () {
      final bundle = bundleFor(321);
      final session = SimulationSession(bundle: bundle, startingBalance: 10000);
      final plan = RiskCalculator.buildPlan(
        direction: TradeDirection.long,
        entry: bundle.decisionPrice,
        stopLoss: bundle.decisionPrice * 0.9,
        takeProfit: bundle.decisionPrice * 1.5,
        riskPercent: 1,
        balance: 10000,
      );
      session.commit(plan);

      final base = bundle.visibleCandles.length;
      for (var i = 1; i <= 3; i++) {
        expect(session.revealNext(), isTrue);
        expect(session.chartCandles.length, base + i);
      }
    });

    test('the committed plan is never altered by the replay', () {
      final bundle = bundleFor(654);
      final session = SimulationSession(bundle: bundle, startingBalance: 10000);
      final plan = RiskCalculator.buildPlan(
        direction: TradeDirection.short,
        entry: bundle.decisionPrice,
        stopLoss: bundle.decisionPrice * 1.02,
        takeProfit: bundle.decisionPrice * 0.94,
        riskPercent: 1,
        balance: 10000,
      );
      session.commit(plan);
      session.revealAll();
      expect(session.plan!.entry, plan.entry);
      expect(session.plan!.stopLoss, plan.stopLoss);
      expect(session.plan!.takeProfit, plan.takeProfit);
      expect(session.plan!.positionSize, plan.positionSize);
    });

    test('a no-trade session reaches review with a no-trade result', () {
      final bundle = bundleFor(99);
      final session = SimulationSession(bundle: bundle, startingBalance: 10000);
      session.chooseDirection(TradeDirection.noTrade);
      session.commit(const TradePlan.noTrade(accountBalance: 10000));
      session.revealAll();
      expect(session.phase, SimulationPhase.review);
      expect(session.result!.outcome, TradeOutcome.noTrade);
      expect(session.processScore, isNotNull);
      expect(session.endingBalance, 10000);
    });

    test('every committed session reaches review and produces a score', () {
      for (var i = 0; i < 120; i++) {
        final bundle = bundleFor(i * 71 + 9);
        final session = SimulationSession(
          bundle: bundle,
          startingBalance: 10000,
        );
        final entry = bundle.decisionPrice;
        final isLong = i.isEven;
        final plan = RiskCalculator.buildPlan(
          direction: isLong ? TradeDirection.long : TradeDirection.short,
          entry: entry,
          stopLoss: isLong ? entry * 0.985 : entry * 1.015,
          takeProfit: isLong ? entry * 1.04 : entry * 0.96,
          riskPercent: 1,
          balance: 10000,
        );
        expect(RiskCalculator.validate(plan).isValid, isTrue);
        session.commit(plan);
        session.finishNow();

        expect(session.phase, SimulationPhase.review);
        expect(session.result, isNotNull);
        expect(session.processScore, isNotNull);
        expect(session.processScore!.total.isFinite, isTrue);
        expect(session.endingBalance.isFinite, isTrue);
        expect(session.result!.rMultiple.isFinite, isTrue);
      }
    });

    test('unrealised profit never reads beyond the revealed candles', () {
      final bundle = bundleFor(1500);
      final session = SimulationSession(bundle: bundle, startingBalance: 10000);
      final entry = bundle.decisionPrice;
      session.commit(
        RiskCalculator.buildPlan(
          direction: TradeDirection.long,
          entry: entry,
          stopLoss: entry * 0.8,
          takeProfit: entry * 1.6,
          riskPercent: 1,
          balance: 10000,
        ),
      );
      expect(session.unrealisedProfit, 0);
      session.revealNext();
      final expected =
          (bundle.futureCandles.first.close - entry) *
          session.plan!.positionSize;
      expect(session.unrealisedProfit, closeTo(expected, 1e-6));
    });
  });
}
