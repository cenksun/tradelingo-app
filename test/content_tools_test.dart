import 'package:flutter_test/flutter_test.dart';
import 'package:tradepath/core/app_date.dart';
import 'package:tradepath/core/seeded_random.dart';
import 'package:tradepath/data/curriculum/curriculum_source.dart';
import 'package:tradepath/data/market/ohlcv_csv_importer.dart';
import 'package:tradepath/domain/models/challenge.dart';
import 'package:tradepath/domain/models/enums.dart';
import 'package:tradepath/domain/models/market.dart';
import 'package:tradepath/domain/models/review_item.dart';
import 'package:tradepath/domain/models/skill.dart';
import 'package:tradepath/domain/services/challenge_generator.dart';
import 'package:tradepath/domain/services/league_service.dart';
import 'package:tradepath/domain/services/level_system.dart';
import 'package:tradepath/domain/services/mastery_engine.dart';
import 'package:tradepath/domain/services/recommendation_engine.dart';
import 'package:tradepath/domain/services/spaced_repetition.dart';
import 'package:tradepath/domain/services/xp_rules.dart';

void main() {
  group('seeded random', () {
    test('is reproducible and stays in range', () {
      final a = SeededRandom(1234);
      final b = SeededRandom(1234);
      for (var i = 0; i < 500; i++) {
        expect(a.nextRaw(), b.nextRaw());
      }
      final r = SeededRandom(99);
      for (var i = 0; i < 2000; i++) {
        final d = r.nextDouble();
        expect(d, greaterThanOrEqualTo(0));
        expect(d, lessThan(1));
        expect(r.nextInt(7), inInclusiveRange(0, 6));
        expect(r.nextIntRange(3, 9), inInclusiveRange(3, 9));
      }
    });

    test('different seeds diverge', () {
      final a = SeededRandom(1);
      final b = SeededRandom(2);
      var different = 0;
      for (var i = 0; i < 100; i++) {
        if (a.nextRaw() != b.nextRaw()) different++;
      }
      expect(different, greaterThan(95));
    });

    test('stableHash does not depend on Object.hashCode', () {
      expect(
        SeededRandom.stableHash('market_structure'),
        SeededRandom.stableHash('market_structure'),
      );
      expect(
        SeededRandom.stableHash('a') == SeededRandom.stableHash('b'),
        isFalse,
      );
    });
  });

  group('level system', () {
    test('level 1 starts at zero XP', () {
      final p = LevelSystem.progressFor(0);
      expect(p.level, 1);
      expect(p.title, 'Rookie');
      expect(p.xpIntoLevel, 0);
    });

    test('levels rise monotonically with XP', () {
      var previous = 0;
      for (var xp = 0; xp < 400000; xp += 977) {
        final level = LevelSystem.progressFor(xp).level;
        expect(level, greaterThanOrEqualTo(previous));
        previous = level;
      }
    });

    test('each level costs more than the last', () {
      for (var l = 1; l < 40; l++) {
        expect(
          LevelSystem.costOfLevel(l + 1),
          greaterThanOrEqualTo(LevelSystem.costOfLevel(l)),
        );
      }
    });

    test('progress fraction is always a usable 0..1', () {
      for (var xp = 0; xp < 60000; xp += 137) {
        final p = LevelSystem.progressFor(xp);
        expect(p.fraction, inInclusiveRange(0, 1));
        expect(p.fraction.isFinite, isTrue);
        expect(p.xpRemaining, greaterThanOrEqualTo(0));
      }
    });

    test('titles arrive at the documented levels', () {
      expect(LevelSystem.titleForLevel(1), 'Rookie');
      expect(LevelSystem.titleForLevel(5), 'Chart Reader');
      expect(LevelSystem.titleForLevel(10), 'Market Scout');
      expect(LevelSystem.titleForLevel(20), 'Risk Manager');
      expect(LevelSystem.titleForLevel(30), 'Analyst');
      expect(LevelSystem.titleForLevel(40), 'Strategist');
      expect(LevelSystem.titleForLevel(50), 'Market Master');
    });

    test('negative XP cannot break the calculation', () {
      final p = LevelSystem.progressFor(-500);
      expect(p.level, 1);
      expect(p.fraction, inInclusiveRange(0, 1));
    });
  });

  group('xp rules', () {
    test('a perfect lesson earns more than an imperfect one', () {
      final lesson = CurriculumSource.build().allLessons.first;
      final perfect = XpRules.forLessonCompletion(
        lesson: lesson,
        correctCount: 10,
        gradedCount: 10,
        perfect: true,
      );
      final imperfect = XpRules.forLessonCompletion(
        lesson: lesson,
        correctCount: 8,
        gradedCount: 10,
        perfect: false,
      );
      expect(perfect, greaterThan(imperfect));
    });

    test('repeat decay shrinks rewards, bottoming out above zero', () {
      const base = 100;
      expect(XpRules.applyRepeatDecay(base, 0), base);

      var previous = base;
      for (var n = 1; n <= 8; n++) {
        final value = XpRules.applyRepeatDecay(base, n);
        // Never increases, and never drops to nothing: replaying a lesson
        // stays worth a little so review is not actively discouraged.
        expect(value, lessThanOrEqualTo(previous));
        expect(value, greaterThan(0));
        previous = value;
      }
      // The first few replays fall steeply.
      expect(XpRules.applyRepeatDecay(base, 1), lessThan(base));
      expect(
        XpRules.applyRepeatDecay(base, 2),
        lessThan(XpRules.applyRepeatDecay(base, 1)),
      );
      // Beyond the decay window it settles on a small floor.
      expect(
        XpRules.applyRepeatDecay(base, 20),
        XpRules.applyRepeatDecay(base, 6),
      );
    });

    test('the daily cap limits a single award', () {
      expect(
        XpRules.capForToday(proposed: 500, earnedToday: XpRules.dailyCap - 100),
        100,
      );
      expect(
        XpRules.capForToday(proposed: 500, earnedToday: XpRules.dailyCap),
        0,
      );
    });

    test('simulation XP rewards process, not profit', () {
      final good = XpRules.forSimulation(processScore: 90);
      final poor = XpRules.forSimulation(processScore: 20);
      expect(good, greaterThan(poor));
      expect(poor, greaterThan(0));
    });
  });

  group('mastery engine', () {
    test('correct answers raise mastery and wrong answers lower it', () {
      final now = DateTime(2026, 1, 1);
      var m = const SkillMastery(skillId: Skills.candlesticks);
      for (var i = 0; i < 12; i++) {
        m = MasteryEngine.applyAnswer(
          current: m,
          correct: true,
          difficulty: Difficulty.intermediate,
          now: now,
        );
      }
      final high = m.score;
      expect(high, greaterThan(50));

      m = MasteryEngine.applyAnswer(
        current: m,
        correct: false,
        difficulty: Difficulty.advanced,
        now: now,
      );
      expect(m.score, lessThan(high));
    });

    test('mastery stays inside 0..100 under any sequence', () {
      final now = DateTime(2026, 1, 1);
      var m = const SkillMastery(skillId: Skills.riskManagement);
      final rnd = SeededRandom(5);
      for (var i = 0; i < 400; i++) {
        m = MasteryEngine.applyAnswer(
          current: m,
          correct: rnd.nextBool(),
          difficulty: Difficulty.values[rnd.nextInt(4)],
          now: now,
        );
        expect(m.score, inInclusiveRange(0, 100));
        expect(m.score.isFinite, isTrue);
      }
    });

    test('unpractised skills decay towards a floor but never below it', () {
      final start = DateTime(2026, 1, 1);
      var m = const SkillMastery(skillId: Skills.liquidity);
      for (var i = 0; i < 20; i++) {
        m = MasteryEngine.applyAnswer(
          current: m,
          correct: true,
          difficulty: Difficulty.advanced,
          now: start,
        );
      }
      final fresh = m.score;
      final later = MasteryEngine.applyDecay(
        m,
        start.add(const Duration(days: 120)),
      );
      expect(later.score, lessThan(fresh));
      expect(later.score, greaterThanOrEqualTo(MasteryEngine.decayFloor));
    });

    test('mastery is not simply a count of answers', () {
      final now = DateTime(2026, 1, 1);
      var wrong = const SkillMastery(skillId: Skills.orders);
      for (var i = 0; i < 15; i++) {
        wrong = MasteryEngine.applyAnswer(
          current: wrong,
          correct: false,
          difficulty: Difficulty.intermediate,
          now: now,
        );
      }
      expect(wrong.attempts, 15);
      expect(wrong.score, lessThan(15));
    });
  });

  group('spaced repetition', () {
    final now = DateTime(2026, 5, 10, 9);

    test('a first correct answer schedules one day out', () {
      final item = SpacedRepetition.create(
        conceptTag: 'higherLow',
        skillId: Skills.marketStructure,
        now: now,
        correct: true,
      );
      expect(item.repetitions, 1);
      expect(item.intervalDays, 1);
      expect(item.dueAt.isAfter(now), isTrue);
    });

    test('intervals grow while answers stay correct', () {
      var item = SpacedRepetition.create(
        conceptTag: 'c',
        skillId: 's',
        now: now,
        correct: true,
      );
      var previous = item.intervalDays;
      for (var i = 0; i < 6; i++) {
        item = SpacedRepetition.review(item: item, correct: true, now: now);
        expect(item.intervalDays, greaterThanOrEqualTo(previous));
        previous = item.intervalDays;
      }
      expect(
        item.intervalDays,
        lessThanOrEqualTo(SpacedRepetition.maxIntervalDays),
      );
    });

    test('a wrong answer resets the item and lowers its ease', () {
      var item = SpacedRepetition.create(
        conceptTag: 'c',
        skillId: 's',
        now: now,
        correct: true,
      );
      item = SpacedRepetition.review(item: item, correct: true, now: now);
      final easeBefore = item.ease;
      item = SpacedRepetition.review(item: item, correct: false, now: now);
      expect(item.repetitions, 0);
      expect(item.lapses, 1);
      expect(item.ease, lessThan(easeBefore));
      expect(item.isDue(now.add(const Duration(minutes: 30))), isTrue);
    });

    test('ease is bounded', () {
      var item = SpacedRepetition.create(
        conceptTag: 'c',
        skillId: 's',
        now: now,
        correct: false,
      );
      for (var i = 0; i < 40; i++) {
        item = SpacedRepetition.review(item: item, correct: false, now: now);
      }
      expect(item.ease, greaterThanOrEqualTo(SpacedRepetition.minEase));
      for (var i = 0; i < 80; i++) {
        item = SpacedRepetition.review(item: item, correct: true, now: now);
      }
      expect(item.ease, lessThanOrEqualTo(SpacedRepetition.maxEase));
    });

    test('a repeatedly-missed concept outranks a comfortable one', () {
      var weak = SpacedRepetition.create(
        conceptTag: 'lowerHigh',
        skillId: Skills.marketStructure,
        now: now,
        correct: false,
      );
      weak = SpacedRepetition.review(item: weak, correct: true, now: now);
      weak = SpacedRepetition.review(item: weak, correct: false, now: now);

      var strong = SpacedRepetition.create(
        conceptTag: 'higherHigh',
        skillId: Skills.marketStructure,
        now: now,
        correct: true,
      );
      for (var i = 0; i < 4; i++) {
        strong = SpacedRepetition.review(item: strong, correct: true, now: now);
      }

      final ordered = SpacedRepetition.selectForSession(
        items: [strong, weak],
        now: now.add(const Duration(days: 2)),
      );
      expect(ordered.first.conceptTag, 'lowerHigh');
    });

    test('selection is deterministic', () {
      final items = <ReviewItem>[
        for (var i = 0; i < 20; i++)
          SpacedRepetition.create(
            conceptTag: 'concept_$i',
            skillId: Skills.candlesticks,
            now: now,
            correct: i.isEven,
          ),
      ];
      final a = SpacedRepetition.selectForSession(items: items, now: now);
      final b = SpacedRepetition.selectForSession(items: items, now: now);
      expect(a.map((i) => i.conceptTag), b.map((i) => i.conceptTag));
    });
  });

  group('adaptive practice', () {
    final curriculum = CurriculumSource.build();
    final now = DateTime(2026, 6, 1, 10);

    test('draws only from unlocked lessons', () {
      final unlocked = {curriculum.worlds.first.lessons.first.id};
      final session = RecommendationEngine.buildSession(
        curriculum: curriculum,
        reviewItems: const [],
        masteries: const [],
        unlockedLessonIds: unlocked,
        now: now,
        seed: 42,
      );
      expect(session, isNotEmpty);
      for (final item in session) {
        expect(unlocked, contains(item.lessonId));
      }
    });

    test('prioritises a concept the learner keeps missing', () {
      final unlocked = {for (final l in curriculum.allLessons) l.id};
      var missed = SpacedRepetition.create(
        conceptTag: 'lowerHigh',
        skillId: Skills.marketStructure,
        now: now.subtract(const Duration(days: 5)),
        correct: false,
      );
      missed = SpacedRepetition.review(
        item: missed,
        correct: false,
        now: now.subtract(const Duration(days: 3)),
      );

      final session = RecommendationEngine.buildSession(
        curriculum: curriculum,
        reviewItems: [missed],
        masteries: const [],
        unlockedLessonIds: unlocked,
        now: now,
        limit: 10,
        seed: 7,
      );
      expect(
        session.any((i) => i.activity.concept == 'lowerHigh'),
        isTrue,
        reason: 'the repeatedly-missed concept should appear in the session',
      );
    });

    test('focusing on a skill only returns that skill', () {
      final unlocked = {for (final l in curriculum.allLessons) l.id};
      final session = RecommendationEngine.buildSession(
        curriculum: curriculum,
        reviewItems: const [],
        masteries: const [],
        unlockedLessonIds: unlocked,
        now: now,
        focusSkillId: Skills.riskManagement,
        seed: 3,
      );
      expect(session, isNotEmpty);
      for (final item in session) {
        expect(item.activity.skillIds, contains(Skills.riskManagement));
      }
    });

    test('no session repeats one concept more than twice', () {
      final unlocked = {for (final l in curriculum.allLessons) l.id};
      final session = RecommendationEngine.buildSession(
        curriculum: curriculum,
        reviewItems: const [],
        masteries: const [],
        unlockedLessonIds: unlocked,
        now: now,
        limit: 10,
        seed: 11,
      );
      final counts = <String, int>{};
      for (final item in session) {
        counts[item.activity.concept] =
            (counts[item.activity.concept] ?? 0) + 1;
      }
      for (final entry in counts.entries) {
        expect(entry.value, lessThanOrEqualTo(2), reason: entry.key);
      }
    });

    test('returns nothing rather than failing when nothing is unlocked', () {
      expect(
        RecommendationEngine.buildSession(
          curriculum: curriculum,
          reviewItems: const [],
          masteries: const [],
          unlockedLessonIds: const {},
          now: now,
        ),
        isEmpty,
      );
    });
  });

  group('challenges', () {
    final curriculum = CurriculumSource.build();

    test('the daily challenge is identical for the same date', () {
      final date = DateTime(2026, 4, 20, 8);
      final a = ChallengeGenerator.daily(date: date, curriculum: curriculum);
      final b = ChallengeGenerator.daily(
        date: DateTime(2026, 4, 20, 23, 59),
        curriculum: curriculum,
      );
      expect(a.dayKey, b.dayKey);
      expect(a.seed, b.seed);
      expect(
        a.tasks.map((t) => t.reference).toList(),
        b.tasks.map((t) => t.reference).toList(),
      );
    });

    test('different dates give different challenges', () {
      final a = ChallengeGenerator.daily(
        date: DateTime(2026, 4, 20),
        curriculum: curriculum,
      );
      final b = ChallengeGenerator.daily(
        date: DateTime(2026, 4, 21),
        curriculum: curriculum,
      );
      expect(a.seed == b.seed, isFalse);
      expect(
        a.tasks.map((t) => t.reference).join() ==
            b.tasks.map((t) => t.reference).join(),
        isFalse,
      );
    });

    test('every daily challenge is full and references real activities', () {
      for (var day = 1; day <= 60; day++) {
        final date = DateTime(2026, 1, 1).add(Duration(days: day));
        final challenge = ChallengeGenerator.daily(
          date: date,
          curriculum: curriculum,
        );
        expect(
          challenge.tasks.length,
          ChallengeGenerator.dailyTaskCount,
          reason: challenge.dayKey,
        );
        for (final task in challenge.tasks) {
          if (task.kind == ChallengeTaskKind.simulation) {
            expect(int.tryParse(task.reference), isNotNull);
            continue;
          }
          final parts = task.reference.split(':');
          expect(parts.length, 2, reason: task.reference);
          final lesson = curriculum.lessonById(parts[0]);
          expect(lesson, isNotNull, reason: task.reference);
          expect(
            lesson!.activities.any((a) => a.id == parts[1]),
            isTrue,
            reason: task.reference,
          );
        }
      }
    });

    test(
      'weekly challenges are stable within a week and change between weeks',
      () {
        final monday = DateTime(2026, 3, 2);
        final friday = DateTime(2026, 3, 6);
        final nextWeek = DateTime(2026, 3, 9);
        expect(
          ChallengeGenerator.weekly(monday).metric,
          ChallengeGenerator.weekly(friday).metric,
        );
        expect(AppDate.weekKey(monday), AppDate.weekKey(friday));
        expect(AppDate.weekKey(monday) == AppDate.weekKey(nextWeek), isFalse);
      },
    );
  });

  group('offline league', () {
    test('always includes the player and ranks by XP', () {
      final standing = LeagueService.standing(
        tier: LeagueTier.silver,
        now: DateTime(2026, 2, 9),
        weeklyXp: 900,
        playerName: 'Sam',
      );
      expect(standing.entries.length, LeagueService.groupSize);
      expect(standing.entries.where((e) => e.isPlayer).length, 1);
      expect(standing.playerRank, inInclusiveRange(1, LeagueService.groupSize));
      for (var i = 1; i < standing.entries.length; i++) {
        expect(
          standing.entries[i - 1].xp,
          greaterThanOrEqualTo(standing.entries[i].xp),
        );
      }
    });

    test('every competitor is a clearly-labelled sample profile', () {
      final standing = LeagueService.standing(
        tier: LeagueTier.gold,
        now: DateTime(2026, 2, 9),
        weeklyXp: 100,
        playerName: 'Sam',
      );
      for (final entry in standing.entries) {
        if (entry.isPlayer) continue;
        expect(entry.isSample, isTrue);
        expect(entry.name.startsWith('Sample:'), isTrue);
      }
      expect(LeagueService.disclaimer, contains('sample profiles'));
    });

    test('more XP means a better rank', () {
      final low = LeagueService.standing(
        tier: LeagueTier.bronze,
        now: DateTime(2026, 2, 9),
        weeklyXp: 0,
        playerName: 'Sam',
      );
      final high = LeagueService.standing(
        tier: LeagueTier.bronze,
        now: DateTime(2026, 2, 9),
        weeklyXp: 100000,
        playerName: 'Sam',
      );
      expect(high.playerRank, lessThan(low.playerRank));
      expect(high.playerRank, 1);
    });

    test('settling promotes, holds or relegates', () {
      final promoted = LeagueService.standing(
        tier: LeagueTier.bronze,
        now: DateTime(2026, 2, 9),
        weeklyXp: 100000,
        playerName: 'Sam',
      );
      expect(LeagueService.settle(promoted), LeagueTier.silver);

      final relegated = LeagueService.standing(
        tier: LeagueTier.gold,
        now: DateTime(2026, 2, 9),
        weeklyXp: 0,
        playerName: 'Sam',
      );
      expect(LeagueService.settle(relegated), LeagueTier.silver);
    });
  });

  group('csv import', () {
    String csv(List<String> rows) =>
        'timestamp,open,high,low,close,volume\n${rows.join('\n')}';

    test('parses a well-formed file', () {
      final result = OhlcvCsvImporter.parse(
        csv([
          '1609459200000,29000,29200,28900,29100,120',
          '1609462800000,29100,29400,29050,29350,140',
        ]),
      );
      expect(result.candles.length, 2);
      expect(result.issues, isEmpty);
      expect(result.candles.first.open, 29000);
      expect(result.candles.last.close, 29350);
    });

    test('rejects rows that would draw an impossible candle', () {
      final result = OhlcvCsvImporter.parse(
        csv([
          '1609459200000,100,90,110,105,10',
          '1609462800000,100,120,90,110,10',
        ]),
      );
      expect(result.candles.length, 1);
      expect(result.issues.length, 1);
      expect(result.issues.first.reason, contains('impossible OHLC'));
    });

    test('reports unreadable timestamps and non-numeric prices', () {
      final result = OhlcvCsvImporter.parse(
        csv(['nope,1,2,0.5,1.5,3', '1609459200000,a,b,c,d,e']),
      );
      expect(result.candles, isEmpty);
      expect(result.issues.length, 2);
    });

    test('accepts any column order and common header names', () {
      final result = OhlcvCsvImporter.parse(
        'Close,Open Time,High,Low,Open,Volume\n'
        '29100,1609459200000,29200,28900,29000,120',
      );
      expect(result.candles.length, 1);
      expect(result.candles.first.open, 29000);
      expect(result.candles.first.close, 29100);
      expect(result.candles.first.high, 29200);
    });

    test('accepts ISO timestamps and files with no header', () {
      final iso = OhlcvCsvImporter.parse(
        'timestamp,open,high,low,close\n2021-01-01T00:00:00Z,10,12,9,11',
      );
      expect(iso.candles.length, 1);

      final headerless = OhlcvCsvImporter.parse(
        '1609459200000,10,12,9,11,5\n1609462800000,11,13,10,12,6',
      );
      expect(headerless.candles.length, 2);
    });

    test('sorts by time and drops duplicate timestamps', () {
      final result = OhlcvCsvImporter.parse(
        csv([
          '1609462800000,11,13,10,12,6',
          '1609459200000,10,12,9,11,5',
          '1609459200000,10,12,9,11,5',
        ]),
      );
      expect(result.candles.length, 2);
      expect(
        result.candles.first.timestamp.isBefore(result.candles.last.timestamp),
        isTrue,
      );
    });

    test('round-trips through the dataset format', () {
      final result = OhlcvCsvImporter.parse(
        csv(['1609459200000,29000,29200,28900,29100,120']),
      );
      final json = OhlcvCsvImporter.toDataset(
        symbol: 'BTC/USDT',
        timeframe: Timeframe.h1,
        assetClass: AssetClass.crypto,
        candles: result.candles,
      );
      final back = OhlcvCsvImporter.fromDataset(json);
      expect(back.length, 1);
      expect(back.first.close, 29100);
      expect(json['symbol'], 'BTC/USDT');
      expect(json['count'], 1);
    });

    test('an empty file is handled without throwing', () {
      final result = OhlcvCsvImporter.parse('');
      expect(result.isEmpty, isTrue);
      expect(result.totalRows, 0);
    });
  });
}
