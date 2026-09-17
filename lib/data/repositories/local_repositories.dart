import 'package:drift/drift.dart';

import '../../core/app_date.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/review_item.dart';
import '../../domain/models/scenario.dart';
import '../../domain/models/trade.dart';
import '../../domain/models/skill.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/services/streak_service.dart';
import '../../domain/services/xp_rules.dart';
import '../../domain/models/challenge.dart';
import '../db/app_database.dart';

/// Local SQLite implementation of [ProfileRepository].
class LocalProfileRepository implements ProfileRepository {
  LocalProfileRepository(this._db);

  final AppDatabase _db;

  @override
  Future<UserProfile> loadProfile() async {
    final row = await (_db.select(
      _db.profileTable,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) return const UserProfile();
    return UserProfile(
      username: row.username,
      avatarId: row.avatarId,
      experienceLevel: ExperienceLevel.fromName(row.experienceLevel),
      dailyGoalMinutes: row.dailyGoalMinutes,
      totalXp: row.totalXp,
      hearts: row.hearts,
      heartsUpdatedAt: row.heartsUpdatedAt,
      onboardingComplete: row.onboardingComplete,
      createdAt: row.createdAt,
    );
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _db
        .into(_db.profileTable)
        .insertOnConflictUpdate(
          ProfileTableCompanion.insert(
            id: const Value(1),
            username: Value(profile.username),
            avatarId: Value(profile.avatarId),
            experienceLevel: Value(profile.experienceLevel.name),
            dailyGoalMinutes: Value(profile.dailyGoalMinutes),
            totalXp: Value(profile.totalXp),
            hearts: Value(profile.hearts),
            heartsUpdatedAt: Value(profile.heartsUpdatedAt),
            onboardingComplete: Value(profile.onboardingComplete),
            createdAt: Value(profile.createdAt ?? DateTime.now()),
          ),
        );
  }

  @override
  Future<AppSettings> loadSettings() async {
    final row = await (_db.select(
      _db.settingsTable,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) return const AppSettings();
    return AppSettings(
      theme: ThemeChoice.fromName(row.theme),
      soundEnabled: row.soundEnabled,
      hapticsEnabled: row.hapticsEnabled,
      dailyGoalMinutes: row.dailyGoalMinutes,
      reduceMotion: row.reduceMotion,
      showVolume: row.showVolume,
      defaultRiskPercent: row.defaultRiskPercent,
      simulatorStartingBalance: row.simulatorStartingBalance,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _db
        .into(_db.settingsTable)
        .insertOnConflictUpdate(
          SettingsTableCompanion.insert(
            id: const Value(1),
            theme: Value(settings.theme.name),
            soundEnabled: Value(settings.soundEnabled),
            hapticsEnabled: Value(settings.hapticsEnabled),
            dailyGoalMinutes: Value(settings.dailyGoalMinutes),
            reduceMotion: Value(settings.reduceMotion),
            showVolume: Value(settings.showVolume),
            defaultRiskPercent: Value(settings.defaultRiskPercent),
            simulatorStartingBalance: Value(settings.simulatorStartingBalance),
          ),
        );
  }

  @override
  Future<StreakState> loadStreak() async {
    final row = await (_db.select(
      _db.streakTable,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) return const StreakState();
    return StreakState(
      current: row.current,
      longest: row.longest,
      lastActiveDay: row.lastActiveDay,
      totalActiveDays: row.totalActiveDays,
    );
  }

  @override
  Future<void> saveStreak(StreakState streak) async {
    await _db
        .into(_db.streakTable)
        .insertOnConflictUpdate(
          StreakTableCompanion.insert(
            id: const Value(1),
            current: Value(streak.current),
            longest: Value(streak.longest),
            lastActiveDay: Value(streak.lastActiveDay),
            totalActiveDays: Value(streak.totalActiveDays),
          ),
        );
  }

  @override
  Future<int> addXp({
    required int amount,
    required XpSource source,
    String? reference,
    DateTime? at,
  }) async {
    if (amount <= 0) return 0;
    final when = at ?? DateTime.now();
    final earnedToday = await xpEarnedOn(when);
    final granted = XpRules.capForToday(
      proposed: amount,
      earnedToday: earnedToday,
    );
    if (granted <= 0) return 0;

    await _db.transaction(() async {
      await _db
          .into(_db.xpEventTable)
          .insert(
            XpEventTableCompanion.insert(
              at: when,
              amount: granted,
              source: source.name,
              reference: Value(reference),
            ),
          );
      final profile = await (_db.select(
        _db.profileTable,
      )..where((t) => t.id.equals(1))).getSingleOrNull();
      final total = (profile?.totalXp ?? 0) + granted;
      await (_db.update(_db.profileTable)..where((t) => t.id.equals(1))).write(
        ProfileTableCompanion(totalXp: Value(total)),
      );
      // League XP tracks the current week only.
      final weekKey = AppDate.weekKey(when);
      final league = await (_db.select(
        _db.leagueStateTable,
      )..where((t) => t.id.equals(1))).getSingleOrNull();
      final sameWeek = league?.weekKey == weekKey;
      await (_db.update(
        _db.leagueStateTable,
      )..where((t) => t.id.equals(1))).write(
        LeagueStateTableCompanion(
          weekKey: Value(weekKey),
          weeklyXp: Value((sameWeek ? (league?.weeklyXp ?? 0) : 0) + granted),
        ),
      );
    });
    return granted;
  }

  @override
  Future<int> xpEarnedOn(DateTime day) async {
    final start = AppDate.dayOf(day);
    final end = start.add(const Duration(days: 1));
    final query = _db.selectOnly(_db.xpEventTable)
      ..addColumns([_db.xpEventTable.amount.sum()])
      ..where(
        _db.xpEventTable.at.isBiggerOrEqualValue(start) &
            _db.xpEventTable.at.isSmallerThanValue(end),
      );
    final row = await query.getSingleOrNull();
    return row?.read(_db.xpEventTable.amount.sum()) ?? 0;
  }

  @override
  Future<int> xpEarnedSince(DateTime from) async {
    final query = _db.selectOnly(_db.xpEventTable)
      ..addColumns([_db.xpEventTable.amount.sum()])
      ..where(_db.xpEventTable.at.isBiggerOrEqualValue(from));
    final row = await query.getSingleOrNull();
    return row?.read(_db.xpEventTable.amount.sum()) ?? 0;
  }

  @override
  Future<List<({DateTime at, int amount, XpSource source})>> recentXpEvents({
    int limit = 30,
  }) async {
    final rows =
        await (_db.select(_db.xpEventTable)
              ..orderBy([(t) => OrderingTerm.desc(t.at)])
              ..limit(limit))
            .get();
    return [
      for (final r in rows)
        (at: r.at, amount: r.amount, source: XpSource.fromName(r.source)),
    ];
  }
}

/// Local SQLite implementation of [ProgressRepository].
class LocalProgressRepository implements ProgressRepository {
  LocalProgressRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Map<String, LessonProgress>> loadLessonProgress() async {
    final rows = await _db.select(_db.lessonProgressTable).get();
    return {
      for (final r in rows)
        r.lessonId: LessonProgress(
          lessonId: r.lessonId,
          completions: r.completions,
          bestAccuracy: r.bestAccuracy,
          lastAccuracy: r.lastAccuracy,
          perfect: r.perfect,
          lastCompletedAt: r.lastCompletedAt,
        ),
    };
  }

  @override
  Future<void> saveLessonProgress(LessonProgress progress) async {
    await _db
        .into(_db.lessonProgressTable)
        .insertOnConflictUpdate(
          LessonProgressTableCompanion.insert(
            lessonId: progress.lessonId,
            completions: Value(progress.completions),
            bestAccuracy: Value(progress.bestAccuracy),
            lastAccuracy: Value(progress.lastAccuracy),
            perfect: Value(progress.perfect),
            lastCompletedAt: Value(progress.lastCompletedAt),
          ),
        );
  }

  @override
  Future<Map<String, SkillMastery>> loadMastery() async {
    final rows = await _db.select(_db.skillMasteryTable).get();
    final map = {
      for (final r in rows)
        r.skillId: SkillMastery(
          skillId: r.skillId,
          score: r.score,
          attempts: r.attempts,
          correct: r.correct,
          lastPracticed: r.lastPracticed,
        ),
    };
    // Every catalogue skill always has an entry, so the UI never has to handle
    // a missing one.
    for (final skill in Skills.all) {
      map.putIfAbsent(skill.id, () => SkillMastery(skillId: skill.id));
    }
    return map;
  }

  @override
  Future<void> saveMastery(SkillMastery mastery) async {
    await _db
        .into(_db.skillMasteryTable)
        .insertOnConflictUpdate(
          SkillMasteryTableCompanion.insert(
            skillId: mastery.skillId,
            score: Value(mastery.score),
            attempts: Value(mastery.attempts),
            correct: Value(mastery.correct),
            lastPracticed: Value(mastery.lastPracticed),
          ),
        );
  }

  @override
  Future<List<ReviewItem>> loadReviewItems() async {
    final rows = await _db.select(_db.reviewItemTable).get();
    return [for (final r in rows) _toReviewItem(r)];
  }

  @override
  Future<ReviewItem?> loadReviewItem(String conceptTag) async {
    final row = await (_db.select(
      _db.reviewItemTable,
    )..where((t) => t.conceptTag.equals(conceptTag))).getSingleOrNull();
    return row == null ? null : _toReviewItem(row);
  }

  ReviewItem _toReviewItem(ReviewItemRow r) => ReviewItem(
    conceptTag: r.conceptTag,
    skillId: r.skillId,
    dueAt: r.dueAt,
    intervalDays: r.intervalDays,
    ease: r.ease,
    repetitions: r.repetitions,
    lapses: r.lapses,
    lastReviewed: r.lastReviewed,
    lastDifficulty: Difficulty.fromName(r.lastDifficulty),
    totalAttempts: r.totalAttempts,
    totalCorrect: r.totalCorrect,
  );

  @override
  Future<void> saveReviewItem(ReviewItem item) async {
    await _db
        .into(_db.reviewItemTable)
        .insertOnConflictUpdate(
          ReviewItemTableCompanion.insert(
            conceptTag: item.conceptTag,
            skillId: item.skillId,
            dueAt: item.dueAt,
            intervalDays: Value(item.intervalDays),
            ease: Value(item.ease),
            repetitions: Value(item.repetitions),
            lapses: Value(item.lapses),
            lastReviewed: Value(item.lastReviewed),
            lastDifficulty: Value(item.lastDifficulty.name),
            totalAttempts: Value(item.totalAttempts),
            totalCorrect: Value(item.totalCorrect),
          ),
        );
  }

  @override
  Future<void> recordAttempt(AttemptRecord attempt) async {
    await _db
        .into(_db.activityAttemptTable)
        .insert(
          ActivityAttemptTableCompanion.insert(
            at: attempt.at,
            lessonId: attempt.lessonId,
            activityId: attempt.activityId,
            activityKind: attempt.activityKind,
            skillId: attempt.skillId,
            conceptTag: attempt.conceptTag,
            difficulty: attempt.difficulty.name,
            correct: attempt.correct,
            context: Value(attempt.context),
          ),
        );
  }

  @override
  Future<List<AttemptRecord>> recentAttempts({int limit = 200}) async {
    final rows =
        await (_db.select(_db.activityAttemptTable)
              ..orderBy([(t) => OrderingTerm.desc(t.at)])
              ..limit(limit))
            .get();
    return [
      for (final r in rows)
        AttemptRecord(
          at: r.at,
          lessonId: r.lessonId,
          activityId: r.activityId,
          activityKind: r.activityKind,
          skillId: r.skillId,
          conceptTag: r.conceptTag,
          difficulty: Difficulty.fromName(r.difficulty),
          correct: r.correct,
          context: r.context,
        ),
    ];
  }

  @override
  Future<int> countAttempts({bool? correctOnly}) async {
    final count = _db.activityAttemptTable.id.count();
    final query = _db.selectOnly(_db.activityAttemptTable)..addColumns([count]);
    if (correctOnly != null) {
      query.where(_db.activityAttemptTable.correct.equals(correctOnly));
    }
    final row = await query.getSingleOrNull();
    return row?.read(count) ?? 0;
  }

  @override
  Future<Set<String>> loadUnlockedAchievements() async {
    final rows = await _db.select(_db.unlockedAchievementTable).get();
    return {for (final r in rows) r.achievementId};
  }

  @override
  Future<void> unlockAchievement(String id, DateTime at) async {
    await _db
        .into(_db.unlockedAchievementTable)
        .insert(
          UnlockedAchievementTableCompanion.insert(
            achievementId: id,
            unlockedAt: at,
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }
}

/// Local SQLite implementation of [JournalRepository].
class LocalJournalRepository implements JournalRepository {
  LocalJournalRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<JournalEntry>> loadEntries({int limit = 500}) async {
    final rows =
        await (_db.select(_db.journalEntryTable)
              ..orderBy([(t) => OrderingTerm.desc(t.completedAt)])
              ..limit(limit))
            .get();
    return [for (final r in rows) _toEntry(r)];
  }

  @override
  Future<JournalEntry?> entryById(String id) async {
    final row = await (_db.select(
      _db.journalEntryTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toEntry(row);
  }

  JournalEntry _toEntry(JournalEntryRow r) => JournalEntry(
    id: r.id,
    scenarioId: r.scenarioId,
    completedAt: r.completedAt,
    assetSymbol: r.assetSymbol,
    timeframeName: r.timeframeName,
    direction: TradeDirection.fromName(r.direction),
    entry: r.entry,
    stopLoss: r.stopLoss,
    takeProfit: r.takeProfit,
    riskPercent: r.riskPercent,
    positionSize: r.positionSize,
    rewardToRisk: r.rewardToRisk,
    outcome: TradeOutcome.fromName(r.outcome),
    rMultiple: r.rMultiple,
    profitLoss: r.profitLoss,
    processScore: r.processScore,
    difficulty: Difficulty.fromName(r.difficulty),
    mistakeTags: _decodeTags(r.mistakeTags),
    features: _decodeList(r.features),
    note: r.note,
    favourite: r.favourite,
    ambiguousClose: r.ambiguousClose,
  );

  static List<MistakeTag> _decodeTags(String raw) => [
    for (final part in _decodeList(raw))
      if (MistakeTag.fromName(part) != null) MistakeTag.fromName(part)!,
  ];

  static List<String> _decodeList(String raw) => raw.isEmpty
      ? const []
      : raw.split(',').where((s) => s.isNotEmpty).toList(growable: false);

  JournalEntryTableCompanion _toCompanion(JournalEntry e) =>
      JournalEntryTableCompanion.insert(
        id: e.id,
        scenarioId: e.scenarioId,
        completedAt: e.completedAt,
        assetSymbol: e.assetSymbol,
        timeframeName: e.timeframeName,
        direction: e.direction.name,
        entry: e.entry,
        stopLoss: e.stopLoss,
        takeProfit: e.takeProfit,
        riskPercent: e.riskPercent,
        positionSize: e.positionSize,
        rewardToRisk: e.rewardToRisk,
        outcome: e.outcome.name,
        rMultiple: e.rMultiple,
        profitLoss: e.profitLoss,
        processScore: e.processScore,
        difficulty: e.difficulty.name,
        mistakeTags: Value(e.mistakeTags.map((t) => t.name).join(',')),
        features: Value(e.features.join(',')),
        note: Value(e.note),
        favourite: Value(e.favourite),
        ambiguousClose: Value(e.ambiguousClose),
      );

  @override
  Future<void> addEntry(JournalEntry entry) async {
    await _db
        .into(_db.journalEntryTable)
        .insertOnConflictUpdate(_toCompanion(entry));
  }

  @override
  Future<void> updateEntry(JournalEntry entry) async {
    await _db
        .into(_db.journalEntryTable)
        .insertOnConflictUpdate(_toCompanion(entry));
  }

  @override
  Future<SimulatorAccount> loadAccount() async {
    final row = await (_db.select(
      _db.simulatorAccountTable,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    if (row == null) {
      return const SimulatorAccount(
        startingBalance: 10000,
        balance: 10000,
        peakBalance: 10000,
        tradeCount: 0,
      );
    }
    return SimulatorAccount(
      startingBalance: row.startingBalance,
      balance: row.balance,
      peakBalance: row.peakBalance,
      tradeCount: row.tradeCount,
      resetAt: row.resetAt,
    );
  }

  @override
  Future<void> applyTradeResult({
    required double profitLoss,
    required double rMultiple,
    required String journalEntryId,
    required DateTime at,
  }) async {
    await _db.transaction(() async {
      final row = await (_db.select(
        _db.simulatorAccountTable,
      )..where((t) => t.id.equals(1))).getSingleOrNull();
      final current = row?.balance ?? 10000;
      final safeDelta = profitLoss.isFinite ? profitLoss : 0.0;
      final next = current + safeDelta;
      final peak = (row?.peakBalance ?? current);
      await (_db.update(
        _db.simulatorAccountTable,
      )..where((t) => t.id.equals(1))).write(
        SimulatorAccountTableCompanion(
          balance: Value(next),
          peakBalance: Value(next > peak ? next : peak),
          tradeCount: Value((row?.tradeCount ?? 0) + 1),
        ),
      );
      await _db
          .into(_db.equityPointTable)
          .insert(
            EquityPointTableCompanion.insert(
              at: at,
              balance: next,
              rMultiple: Value(rMultiple.isFinite ? rMultiple : 0),
              journalEntryId: Value(journalEntryId),
            ),
          );
    });
  }

  @override
  Future<List<EquityPoint>> loadEquityCurve({int limit = 500}) async {
    final rows =
        await (_db.select(_db.equityPointTable)
              ..orderBy([(t) => OrderingTerm.asc(t.at)])
              ..limit(limit))
            .get();
    return [
      for (final r in rows)
        EquityPoint(
          at: r.at,
          balance: r.balance,
          rMultiple: r.rMultiple,
          journalEntryId: r.journalEntryId,
        ),
    ];
  }

  @override
  Future<void> resetSimulator({required double startingBalance}) =>
      _db.resetSimulator(startingBalance: startingBalance);
}

/// Local SQLite implementation of [ChallengeRepository].
class LocalChallengeRepository implements ChallengeRepository {
  LocalChallengeRepository(this._db);

  final AppDatabase _db;

  @override
  Future<DailyChallenge?> loadDaily(String dayKey) async {
    final row = await (_db.select(
      _db.dailyChallengeTable,
    )..where((t) => t.dayKey.equals(dayKey))).getSingleOrNull();
    if (row == null) return null;
    // Tasks are regenerated from the seed rather than stored, which keeps the
    // table tiny and guarantees the two can never disagree.
    return DailyChallenge(
      dayKey: row.dayKey,
      seed: row.seed,
      tasks: const [],
      xpReward: XpRules.dailyChallengeComplete,
      completedTaskCount: row.completedTaskCount,
      completed: row.completed,
    );
  }

  @override
  Future<void> saveDaily(DailyChallenge challenge) async {
    await _db
        .into(_db.dailyChallengeTable)
        .insertOnConflictUpdate(
          DailyChallengeTableCompanion.insert(
            dayKey: challenge.dayKey,
            seed: challenge.seed,
            completedTaskCount: Value(challenge.completedTaskCount),
            completed: Value(challenge.completed),
            completedAt: Value(challenge.completed ? DateTime.now() : null),
          ),
        );
  }

  @override
  Future<int> countCompletedDailies() async {
    final count = _db.dailyChallengeTable.dayKey.count();
    final query = _db.selectOnly(_db.dailyChallengeTable)
      ..addColumns([count])
      ..where(_db.dailyChallengeTable.completed.equals(true));
    final row = await query.getSingleOrNull();
    return row?.read(count) ?? 0;
  }

  @override
  Future<WeeklyChallenge?> loadWeekly(String weekKey) async {
    final row = await (_db.select(
      _db.weeklyChallengeTable,
    )..where((t) => t.weekKey.equals(weekKey))).getSingleOrNull();
    if (row == null) return null;
    return WeeklyChallenge(
      weekKey: row.weekKey,
      metric: WeeklyGoalMetric.values.firstWhere(
        (m) => m.name == row.metric,
        orElse: () => WeeklyGoalMetric.lessons,
      ),
      target: row.target,
      xpReward: XpRules.weeklyChallengeComplete,
      title: '',
      progress: row.progress,
      completed: row.completed,
    );
  }

  @override
  Future<void> saveWeekly(WeeklyChallenge challenge) async {
    await _db
        .into(_db.weeklyChallengeTable)
        .insertOnConflictUpdate(
          WeeklyChallengeTableCompanion.insert(
            weekKey: challenge.weekKey,
            metric: challenge.metric.name,
            target: challenge.target,
            progress: Value(challenge.progress),
            completed: Value(challenge.completed),
          ),
        );
  }

  @override
  Future<({LeagueTier tier, String weekKey, int weeklyXp})> loadLeague() async {
    final row = await (_db.select(
      _db.leagueStateTable,
    )..where((t) => t.id.equals(1))).getSingleOrNull();
    return (
      tier: LeagueTier.fromName(row?.tier),
      weekKey: row?.weekKey ?? '',
      weeklyXp: row?.weeklyXp ?? 0,
    );
  }

  @override
  Future<void> saveLeague({
    required LeagueTier tier,
    required String weekKey,
    required int weeklyXp,
  }) async {
    await _db
        .into(_db.leagueStateTable)
        .insertOnConflictUpdate(
          LeagueStateTableCompanion.insert(
            id: const Value(1),
            tier: Value(tier.name),
            weekKey: Value(weekKey),
            weeklyXp: Value(weeklyXp),
          ),
        );
  }
}

/// Builds a [JournalEntry] from a finished simulation.
JournalEntry buildJournalEntry({
  required String id,
  required ScenarioBundle bundle,
  required TradePlan plan,
  required TradeResult result,
  required double processScore,
  required List<MistakeTag> mistakes,
  required DateTime at,
}) {
  final scenario = bundle.scenario;
  return JournalEntry(
    id: id,
    scenarioId: scenario.id,
    completedAt: at,
    // Anonymised scenarios keep the instrument hidden in the journal too, so a
    // learner cannot look up what "really" happened instead of reading the
    // chart.
    assetSymbol: scenario.recipe.anonymized
        ? 'Educational dataset'
        : scenario.asset.symbol,
    timeframeName: scenario.timeframe.label,
    direction: plan.direction,
    entry: plan.entry,
    stopLoss: plan.stopLoss,
    takeProfit: plan.takeProfit,
    riskPercent: plan.riskPercent,
    positionSize: plan.positionSize,
    rewardToRisk: plan.rewardToRisk,
    outcome: result.outcome,
    rMultiple: result.rMultiple,
    profitLoss: result.profitLoss,
    processScore: processScore,
    difficulty: scenario.difficulty,
    mistakeTags: mistakes,
    features: scenario.features.map((f) => f.name).toList(growable: false),
    ambiguousClose: result.ambiguousCandle,
  );
}
