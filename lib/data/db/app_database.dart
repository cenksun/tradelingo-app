import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// The local SQLite database.
///
/// Everything in TradePath persists here: progress, mastery, the review queue,
/// the journal, the virtual account and the challenge state. There is no
/// network component and no account.
@DriftDatabase(
  tables: [
    ProfileTable,
    SettingsTable,
    LessonProgressTable,
    SkillMasteryTable,
    ReviewItemTable,
    StreakTable,
    UnlockedAchievementTable,
    JournalEntryTable,
    SimulatorAccountTable,
    EquityPointTable,
    XpEventTable,
    ActivityAttemptTable,
    DailyChallengeTable,
    WeeklyChallengeTable,
    LeagueStateTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'tradepath'));

  /// In-memory instance for tests.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedSingletons();
    },
    onUpgrade: (m, from, to) async {
      // Future schema versions are handled here. Each step is additive so a
      // learner never loses progress on an update.
      //
      // Example for the next release:
      //   if (from < 2) await m.addColumn(profileTable, profileTable.newColumn);
      await customStatement('PRAGMA foreign_keys = ON');
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated) return;
      // A database created by an older build, or one interrupted mid-write,
      // may be missing its singleton rows. Repair rather than fail to start.
      await _seedSingletons();
    },
  );

  Future<void> _seedSingletons() async {
    await into(profileTable).insertOnConflictUpdate(
      ProfileTableCompanion.insert(
        id: const Value(1),
        createdAt: Value(DateTime.now()),
      ),
    );
    await into(settingsTable).insert(
      SettingsTableCompanion.insert(id: const Value(1)),
      mode: InsertMode.insertOrIgnore,
    );
    await into(streakTable).insert(
      StreakTableCompanion.insert(id: const Value(1)),
      mode: InsertMode.insertOrIgnore,
    );
    await into(simulatorAccountTable).insert(
      SimulatorAccountTableCompanion.insert(id: const Value(1)),
      mode: InsertMode.insertOrIgnore,
    );
    await into(leagueStateTable).insert(
      LeagueStateTableCompanion.insert(id: const Value(1)),
      mode: InsertMode.insertOrIgnore,
    );
  }

  /// Wipes learning progress while leaving settings alone.
  Future<void> resetLearningProgress() async {
    await transaction(() async {
      await delete(lessonProgressTable).go();
      await delete(skillMasteryTable).go();
      await delete(reviewItemTable).go();
      await delete(unlockedAchievementTable).go();
      await delete(xpEventTable).go();
      await delete(activityAttemptTable).go();
      await delete(dailyChallengeTable).go();
      await delete(weeklyChallengeTable).go();
      await (update(profileTable)..where((t) => t.id.equals(1))).write(
        const ProfileTableCompanion(
          totalXp: Value(0),
          hearts: Value(5),
          onboardingComplete: Value(true),
        ),
      );
      await (update(streakTable)..where((t) => t.id.equals(1))).write(
        const StreakTableCompanion(
          current: Value(0),
          longest: Value(0),
          lastActiveDay: Value(null),
          totalActiveDays: Value(0),
        ),
      );
      await (update(leagueStateTable)..where((t) => t.id.equals(1))).write(
        const LeagueStateTableCompanion(
          tier: Value('bronze'),
          weeklyXp: Value(0),
        ),
      );
    });
  }

  /// Wipes the simulator account, its equity history and the journal, while
  /// leaving every piece of learning progress intact.
  Future<void> resetSimulator({required double startingBalance}) async {
    await transaction(() async {
      await delete(journalEntryTable).go();
      await delete(equityPointTable).go();
      await (update(simulatorAccountTable)..where((t) => t.id.equals(1))).write(
        SimulatorAccountTableCompanion(
          startingBalance: Value(startingBalance),
          balance: Value(startingBalance),
          peakBalance: Value(startingBalance),
          tradeCount: const Value(0),
          resetAt: Value(DateTime.now()),
        ),
      );
    });
  }

  /// Wipes everything, returning the app to a first-run state.
  Future<void> resetEverything({required double startingBalance}) async {
    await transaction(() async {
      await resetLearningProgress();
      await resetSimulator(startingBalance: startingBalance);
      await (update(profileTable)..where((t) => t.id.equals(1))).write(
        const ProfileTableCompanion(onboardingComplete: Value(false)),
      );
    });
  }
}
