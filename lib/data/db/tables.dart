import 'package:drift/drift.dart';

/// Single-row table holding the local learner profile.
@DataClassName('ProfileRow')
class ProfileTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get username => text().withDefault(const Constant('Trader'))();
  TextColumn get avatarId => text().withDefault(const Constant('avatar_01'))();
  TextColumn get experienceLevel =>
      text().withDefault(const Constant('beginner'))();
  IntColumn get dailyGoalMinutes => integer().withDefault(const Constant(10))();
  IntColumn get totalXp => integer().withDefault(const Constant(0))();
  IntColumn get hearts => integer().withDefault(const Constant(5))();
  DateTimeColumn get heartsUpdatedAt => dateTime().nullable()();
  BoolColumn get onboardingComplete =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Single-row table holding app settings.
@DataClassName('SettingsRow')
class SettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get theme => text().withDefault(const Constant('dark'))();
  BoolColumn get soundEnabled => boolean().withDefault(const Constant(true))();
  BoolColumn get hapticsEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get dailyGoalMinutes => integer().withDefault(const Constant(10))();
  BoolColumn get reduceMotion => boolean().withDefault(const Constant(false))();
  BoolColumn get showVolume => boolean().withDefault(const Constant(true))();
  RealColumn get defaultRiskPercent =>
      real().withDefault(const Constant(1.0))();
  RealColumn get simulatorStartingBalance =>
      real().withDefault(const Constant(10000.0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LessonProgressRow')
class LessonProgressTable extends Table {
  TextColumn get lessonId => text()();
  IntColumn get completions => integer().withDefault(const Constant(0))();
  RealColumn get bestAccuracy => real().withDefault(const Constant(0))();
  RealColumn get lastAccuracy => real().withDefault(const Constant(0))();
  BoolColumn get perfect => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastCompletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {lessonId};
}

@DataClassName('SkillMasteryRow')
class SkillMasteryTable extends Table {
  TextColumn get skillId => text()();
  RealColumn get score => real().withDefault(const Constant(0))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  IntColumn get correct => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPracticed => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {skillId};
}

@DataClassName('ReviewItemRow')
class ReviewItemTable extends Table {
  TextColumn get conceptTag => text()();
  TextColumn get skillId => text()();
  DateTimeColumn get dueAt => dateTime()();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  RealColumn get ease => real().withDefault(const Constant(2.3))();
  IntColumn get repetitions => integer().withDefault(const Constant(0))();
  IntColumn get lapses => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewed => dateTime().nullable()();
  TextColumn get lastDifficulty =>
      text().withDefault(const Constant('beginner'))();
  IntColumn get totalAttempts => integer().withDefault(const Constant(0))();
  IntColumn get totalCorrect => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {conceptTag};
}

/// Single-row streak state.
@DataClassName('StreakRow')
class StreakTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  IntColumn get current => integer().withDefault(const Constant(0))();
  IntColumn get longest => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActiveDay => dateTime().nullable()();
  IntColumn get totalActiveDays => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UnlockedAchievementRow')
class UnlockedAchievementTable extends Table {
  TextColumn get achievementId => text()();
  DateTimeColumn get unlockedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {achievementId};
}

@DataClassName('JournalEntryRow')
class JournalEntryTable extends Table {
  TextColumn get id => text()();
  TextColumn get scenarioId => text()();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get assetSymbol => text()();
  TextColumn get timeframeName => text()();
  TextColumn get direction => text()();
  RealColumn get entry => real()();
  RealColumn get stopLoss => real()();
  RealColumn get takeProfit => real()();
  RealColumn get riskPercent => real()();
  RealColumn get positionSize => real()();
  RealColumn get rewardToRisk => real()();
  TextColumn get outcome => text()();
  RealColumn get rMultiple => real()();
  RealColumn get profitLoss => real()();
  RealColumn get processScore => real()();
  TextColumn get difficulty => text()();

  /// Comma-separated mistake tag names.
  TextColumn get mistakeTags => text().withDefault(const Constant(''))();

  /// Comma-separated scenario feature names.
  TextColumn get features => text().withDefault(const Constant(''))();
  TextColumn get note => text().withDefault(const Constant(''))();
  BoolColumn get favourite => boolean().withDefault(const Constant(false))();
  BoolColumn get ambiguousClose =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Single-row virtual simulator account.
@DataClassName('SimulatorAccountRow')
class SimulatorAccountTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  RealColumn get startingBalance =>
      real().withDefault(const Constant(10000.0))();
  RealColumn get balance => real().withDefault(const Constant(10000.0))();
  RealColumn get peakBalance => real().withDefault(const Constant(10000.0))();
  IntColumn get tradeCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get resetAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One point on the virtual equity curve.
@DataClassName('EquityPointRow')
class EquityPointTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime()();
  RealColumn get balance => real()();
  RealColumn get rMultiple => real().withDefault(const Constant(0))();
  TextColumn get journalEntryId => text().nullable()();
}

@DataClassName('XpEventRow')
class XpEventTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime()();
  IntColumn get amount => integer()();
  TextColumn get source => text()();
  TextColumn get reference => text().nullable()();
}

/// Records every graded answer, which is what analytics and adaptive practice
/// are built from.
@DataClassName('ActivityAttemptRow')
class ActivityAttemptTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get at => dateTime()();
  TextColumn get lessonId => text()();
  TextColumn get activityId => text()();
  TextColumn get activityKind => text()();
  TextColumn get skillId => text()();
  TextColumn get conceptTag => text()();
  TextColumn get difficulty => text()();
  BoolColumn get correct => boolean()();
  TextColumn get context => text().withDefault(const Constant('lesson'))();
}

@DataClassName('DailyChallengeRow')
class DailyChallengeTable extends Table {
  TextColumn get dayKey => text()();
  IntColumn get seed => integer()();
  IntColumn get completedTaskCount =>
      integer().withDefault(const Constant(0))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {dayKey};
}

@DataClassName('WeeklyChallengeRow')
class WeeklyChallengeTable extends Table {
  TextColumn get weekKey => text()();
  TextColumn get metric => text()();
  IntColumn get target => integer()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {weekKey};
}

/// Single-row offline league state.
@DataClassName('LeagueStateRow')
class LeagueStateTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get tier => text().withDefault(const Constant('bronze'))();
  TextColumn get weekKey => text().withDefault(const Constant(''))();
  IntColumn get weeklyXp => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
