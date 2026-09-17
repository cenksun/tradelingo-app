import 'dart:math' as math;

import 'package:meta/meta.dart';

/// Account levels derived from cumulative XP.
///
/// The curve is generated rather than hard-coded: each level costs a little
/// more than the last, so the table can extend indefinitely without new
/// constants. Titles are **gamification labels only** — they describe progress
/// through this app and say nothing about real-world trading competence.
class LevelSystem {
  const LevelSystem._();

  static const int maxLevel = 100;
  static const int _baseCost = 120;
  static const double _growth = 1.115;

  /// XP needed to go from [level] to `level + 1`.
  static int costOfLevel(int level) {
    if (level < 1) return _baseCost;
    final raw = _baseCost * math.pow(_growth, level - 1);
    // Round to a readable multiple so the UI shows tidy numbers.
    return (raw / 10).round() * 10;
  }

  /// Total XP required to reach [level] from zero.
  static int totalXpForLevel(int level) {
    var total = 0;
    for (var l = 1; l < level; l++) {
      total += costOfLevel(l);
    }
    return total;
  }

  static LevelProgress progressFor(int totalXp) {
    final xp = totalXp < 0 ? 0 : totalXp;
    var level = 1;
    var consumed = 0;
    while (level < maxLevel) {
      final cost = costOfLevel(level);
      if (xp - consumed < cost) break;
      consumed += cost;
      level++;
    }
    final intoLevel = xp - consumed;
    final needed = level >= maxLevel ? 0 : costOfLevel(level);
    return LevelProgress(
      level: level,
      title: titleForLevel(level),
      totalXp: xp,
      xpIntoLevel: intoLevel,
      xpForNextLevel: needed,
    );
  }

  /// Gamification titles. These are progress labels inside TradePath and are
  /// not a qualification, certification or statement of trading ability.
  static String titleForLevel(int level) {
    if (level >= 50) return 'Market Master';
    if (level >= 40) return 'Strategist';
    if (level >= 30) return 'Analyst';
    if (level >= 25) return 'Risk Veteran';
    if (level >= 20) return 'Risk Manager';
    if (level >= 15) return 'Structure Reader';
    if (level >= 10) return 'Market Scout';
    if (level >= 7) return 'Chart Student';
    if (level >= 5) return 'Chart Reader';
    if (level >= 3) return 'Apprentice';
    return 'Rookie';
  }

  /// The next title a learner will unlock, if any.
  static ({int level, String title})? nextTitle(int level) {
    const milestones = [3, 5, 7, 10, 15, 20, 25, 30, 40, 50];
    for (final m in milestones) {
      if (m > level) return (level: m, title: titleForLevel(m));
    }
    return null;
  }
}

@immutable
class LevelProgress {
  const LevelProgress({
    required this.level,
    required this.title,
    required this.totalXp,
    required this.xpIntoLevel,
    required this.xpForNextLevel,
  });

  final int level;
  final String title;
  final int totalXp;
  final int xpIntoLevel;

  /// 0 when the maximum level has been reached.
  final int xpForNextLevel;

  bool get isMaxLevel => xpForNextLevel == 0;

  int get xpRemaining =>
      isMaxLevel ? 0 : math.max(0, xpForNextLevel - xpIntoLevel);

  double get fraction {
    if (isMaxLevel) return 1;
    if (xpForNextLevel <= 0) return 0;
    return (xpIntoLevel / xpForNextLevel).clamp(0.0, 1.0);
  }
}
