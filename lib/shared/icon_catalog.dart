import 'package:flutter/material.dart';

import '../domain/models/achievement.dart';
import '../domain/models/skill.dart';

/// Maps domain identifiers to icons.
///
/// The icons live here rather than in the domain models for two reasons: the
/// domain layer stays free of Flutter imports, and every [IconData] stays a
/// compile-time constant so icon tree-shaking keeps working.
class IconCatalog {
  const IconCatalog._();

  static const Map<String, IconData> _skills = {
    Skills.marketBasics: Icons.public_rounded,
    Skills.candlesticks: Icons.candlestick_chart_rounded,
    Skills.marketStructure: Icons.timeline_rounded,
    Skills.trendReading: Icons.trending_up_rounded,
    Skills.longShort: Icons.swap_vert_rounded,
    Skills.orders: Icons.receipt_long_rounded,
    Skills.stopLoss: Icons.shield_rounded,
    Skills.riskManagement: Icons.balance_rounded,
    Skills.supportResistance: Icons.layers_rounded,
    Skills.liquidity: Icons.waves_rounded,
    Skills.priceAction: Icons.insights_rounded,
    Skills.tradePlanning: Icons.assignment_rounded,
  };

  static IconData forSkill(String skillId) =>
      _skills[skillId] ?? Icons.school_rounded;

  static const Map<AchievementMetric, IconData> _metrics = {
    AchievementMetric.lessonsCompleted: Icons.menu_book_rounded,
    AchievementMetric.perfectLessons: Icons.star_rounded,
    AchievementMetric.questionsAnswered: Icons.quiz_rounded,
    AchievementMetric.correctAnswers: Icons.check_circle_rounded,
    AchievementMetric.simulationsCompleted: Icons.candlestick_chart_rounded,
    AchievementMetric.currentStreak: Icons.local_fire_department_rounded,
    AchievementMetric.bossesPassed: Icons.military_tech_rounded,
    AchievementMetric.reviewSessions: Icons.replay_rounded,
    AchievementMetric.disciplinedTrades: Icons.shield_rounded,
    AchievementMetric.structureAccuracy: Icons.timeline_rounded,
    AchievementMetric.noTradeDecisions: Icons.pause_circle_rounded,
    AchievementMetric.journalNotes: Icons.edit_note_rounded,
    AchievementMetric.worldsCompleted: Icons.emoji_events_rounded,
    AchievementMetric.dailyChallenges: Icons.today_rounded,
  };

  static IconData forAchievement(Achievement achievement) =>
      _metrics[achievement.metric] ?? Icons.emoji_events_rounded;
}
