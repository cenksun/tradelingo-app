import 'package:meta/meta.dart';

import 'enums.dart';

/// The local learning profile. No account, no server, no credentials.
@immutable
class UserProfile {
  const UserProfile({
    this.username = 'Trader',
    this.avatarId = 'avatar_01',
    this.experienceLevel = ExperienceLevel.beginner,
    this.dailyGoalMinutes = 10,
    this.totalXp = 0,
    this.hearts = maxHearts,
    this.heartsUpdatedAt,
    this.onboardingComplete = false,
    this.createdAt,
  });

  static const int maxHearts = 5;

  final String username;
  final String avatarId;
  final ExperienceLevel experienceLevel;
  final int dailyGoalMinutes;
  final int totalXp;
  final int hearts;
  final DateTime? heartsUpdatedAt;
  final bool onboardingComplete;
  final DateTime? createdAt;

  bool get hasHearts => hearts > 0;

  UserProfile copyWith({
    String? username,
    String? avatarId,
    ExperienceLevel? experienceLevel,
    int? dailyGoalMinutes,
    int? totalXp,
    int? hearts,
    DateTime? heartsUpdatedAt,
    bool? onboardingComplete,
    DateTime? createdAt,
  }) => UserProfile(
    username: username ?? this.username,
    avatarId: avatarId ?? this.avatarId,
    experienceLevel: experienceLevel ?? this.experienceLevel,
    dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
    totalXp: totalXp ?? this.totalXp,
    hearts: hearts ?? this.hearts,
    heartsUpdatedAt: heartsUpdatedAt ?? this.heartsUpdatedAt,
    onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    createdAt: createdAt ?? this.createdAt,
  );
}

/// Local app settings.
@immutable
class AppSettings {
  const AppSettings({
    this.theme = ThemeChoice.dark,
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.dailyGoalMinutes = 10,
    this.reduceMotion = false,
    this.showVolume = true,
    this.defaultRiskPercent = 1.0,
    this.simulatorStartingBalance = 10000,
  });

  final ThemeChoice theme;
  final bool soundEnabled;
  final bool hapticsEnabled;
  final int dailyGoalMinutes;
  final bool reduceMotion;
  final bool showVolume;
  final double defaultRiskPercent;
  final double simulatorStartingBalance;

  AppSettings copyWith({
    ThemeChoice? theme,
    bool? soundEnabled,
    bool? hapticsEnabled,
    int? dailyGoalMinutes,
    bool? reduceMotion,
    bool? showVolume,
    double? defaultRiskPercent,
    double? simulatorStartingBalance,
  }) => AppSettings(
    theme: theme ?? this.theme,
    soundEnabled: soundEnabled ?? this.soundEnabled,
    hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    showVolume: showVolume ?? this.showVolume,
    defaultRiskPercent: defaultRiskPercent ?? this.defaultRiskPercent,
    simulatorStartingBalance:
        simulatorStartingBalance ?? this.simulatorStartingBalance,
  );
}

/// Per-lesson progress.
@immutable
class LessonProgress {
  const LessonProgress({
    required this.lessonId,
    this.completions = 0,
    this.bestAccuracy = 0,
    this.lastAccuracy = 0,
    this.perfect = false,
    this.lastCompletedAt,
  });

  final String lessonId;
  final int completions;
  final double bestAccuracy;
  final double lastAccuracy;
  final bool perfect;
  final DateTime? lastCompletedAt;

  bool get isCompleted => completions > 0;

  LessonProgress copyWith({
    int? completions,
    double? bestAccuracy,
    double? lastAccuracy,
    bool? perfect,
    DateTime? lastCompletedAt,
  }) => LessonProgress(
    lessonId: lessonId,
    completions: completions ?? this.completions,
    bestAccuracy: bestAccuracy ?? this.bestAccuracy,
    lastAccuracy: lastAccuracy ?? this.lastAccuracy,
    perfect: perfect ?? this.perfect,
    lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
  );
}
