import '../models/achievement.dart';
import '../models/challenge.dart';
import '../models/enums.dart';
import '../models/journal_entry.dart';
import '../models/review_item.dart';
import '../models/skill.dart';
import '../models/user_profile.dart';
import '../services/streak_service.dart';
import '../services/xp_rules.dart';

/// One recorded answer, used by analytics and adaptive practice.
class AttemptRecord {
  const AttemptRecord({
    required this.at,
    required this.lessonId,
    required this.activityId,
    required this.activityKind,
    required this.skillId,
    required this.conceptTag,
    required this.difficulty,
    required this.correct,
    this.context = 'lesson',
  });

  final DateTime at;
  final String lessonId;
  final String activityId;
  final String activityKind;
  final String skillId;
  final String conceptTag;
  final Difficulty difficulty;
  final bool correct;

  /// `lesson`, `practice`, `review`, `boss` or `challenge`.
  final String context;
}

/// The virtual simulator account.
class SimulatorAccount {
  const SimulatorAccount({
    required this.startingBalance,
    required this.balance,
    required this.peakBalance,
    required this.tradeCount,
    this.resetAt,
  });

  final double startingBalance;
  final double balance;
  final double peakBalance;
  final int tradeCount;
  final DateTime? resetAt;

  /// Current drawdown from the peak, as a 0..1 fraction.
  double get drawdownFraction {
    if (peakBalance <= 0) return 0;
    final dd = (peakBalance - balance) / peakBalance;
    return dd.isFinite ? dd.clamp(0.0, 1.0) : 0;
  }
}

class EquityPoint {
  const EquityPoint({
    required this.at,
    required this.balance,
    required this.rMultiple,
    this.journalEntryId,
  });

  final DateTime at;
  final double balance;
  final double rMultiple;
  final String? journalEntryId;
}

/// Profile, settings, hearts, XP and streak.
///
/// V1 is backed by local SQLite. A future cloud-sync implementation would
/// replace this class without any screen changing.
abstract class ProfileRepository {
  Future<UserProfile> loadProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<AppSettings> loadSettings();
  Future<void> saveSettings(AppSettings settings);
  Future<StreakState> loadStreak();
  Future<void> saveStreak(StreakState streak);

  /// Adds XP, applying the daily cap, and returns the amount actually awarded.
  Future<int> addXp({
    required int amount,
    required XpSource source,
    String? reference,
    DateTime? at,
  });

  Future<int> xpEarnedOn(DateTime day);
  Future<int> xpEarnedSince(DateTime from);
  Future<List<({DateTime at, int amount, XpSource source})>> recentXpEvents({
    int limit = 30,
  });
}

/// Lesson progress, skill mastery, the review queue and achievements.
abstract class ProgressRepository {
  Future<Map<String, LessonProgress>> loadLessonProgress();
  Future<void> saveLessonProgress(LessonProgress progress);

  Future<Map<String, SkillMastery>> loadMastery();
  Future<void> saveMastery(SkillMastery mastery);

  Future<List<ReviewItem>> loadReviewItems();
  Future<ReviewItem?> loadReviewItem(String conceptTag);
  Future<void> saveReviewItem(ReviewItem item);

  Future<void> recordAttempt(AttemptRecord attempt);
  Future<List<AttemptRecord>> recentAttempts({int limit = 200});
  Future<int> countAttempts({bool? correctOnly});

  Future<Set<String>> loadUnlockedAchievements();
  Future<void> unlockAchievement(String id, DateTime at);
}

/// The trading journal and the virtual account.
abstract class JournalRepository {
  Future<List<JournalEntry>> loadEntries({int limit = 500});
  Future<JournalEntry?> entryById(String id);
  Future<void> addEntry(JournalEntry entry);
  Future<void> updateEntry(JournalEntry entry);
  Future<SimulatorAccount> loadAccount();
  Future<void> applyTradeResult({
    required double profitLoss,
    required double rMultiple,
    required String journalEntryId,
    required DateTime at,
  });
  Future<List<EquityPoint>> loadEquityCurve({int limit = 500});
  Future<void> resetSimulator({required double startingBalance});
}

/// Daily and weekly challenges plus the offline league.
abstract class ChallengeRepository {
  Future<DailyChallenge?> loadDaily(String dayKey);
  Future<void> saveDaily(DailyChallenge challenge);
  Future<int> countCompletedDailies();

  Future<WeeklyChallenge?> loadWeekly(String weekKey);
  Future<void> saveWeekly(WeeklyChallenge challenge);

  Future<({LeagueTier tier, String weekKey, int weeklyXp})> loadLeague();
  Future<void> saveLeague({
    required LeagueTier tier,
    required String weekKey,
    required int weeklyXp,
  });
}

/// Aggregated counters for achievements and the profile screen.
class ProgressStats {
  const ProgressStats({
    required this.lessonsCompleted,
    required this.perfectLessons,
    required this.bossesPassed,
    required this.worldsCompleted,
    required this.questionsAnswered,
    required this.correctAnswers,
    required this.reviewSessions,
  });

  final int lessonsCompleted;
  final int perfectLessons;
  final int bossesPassed;
  final int worldsCompleted;
  final int questionsAnswered;
  final int correctAnswers;
  final int reviewSessions;

  double get accuracy =>
      questionsAnswered == 0 ? 0 : correctAnswers / questionsAnswered;
}

/// Convenience bundle so the achievement engine has one place to read from.
class AchievementInputs {
  const AchievementInputs({required this.stats, required this.unlocked});

  final AchievementStats stats;
  final Set<String> unlocked;
}
