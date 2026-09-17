import 'package:meta/meta.dart';

/// A trainable skill. Mastery is tracked per skill and is deliberately
/// separate from account XP: XP measures how much you have done, mastery
/// measures how well you currently do it.
@immutable
class Skill {
  const Skill({
    required this.id,
    required this.name,
    required this.shortName,
    required this.description,
  });

  final String id;
  final String name;
  final String shortName;
  final String description;
}

/// The skill catalogue. World N teaches skill N as its primary skill, though
/// later worlds reinforce earlier skills too.
class Skills {
  const Skills._();

  static const String marketBasics = 'market_basics';
  static const String candlesticks = 'candlesticks';
  static const String marketStructure = 'market_structure';
  static const String trendReading = 'trend_reading';
  static const String longShort = 'long_short';
  static const String orders = 'orders';
  static const String stopLoss = 'stop_loss';
  static const String riskManagement = 'risk_management';
  static const String supportResistance = 'support_resistance';
  static const String liquidity = 'liquidity';
  static const String priceAction = 'price_action';
  static const String tradePlanning = 'trade_planning';

  static const List<Skill> all = [
    Skill(
      id: marketBasics,
      name: 'Market Basics',
      shortName: 'Basics',
      description:
          'What a market is, who trades in it and what a price represents.',
    ),
    Skill(
      id: candlesticks,
      name: 'Candlesticks',
      shortName: 'Candles',
      description: 'Reading open, high, low and close on a single bar.',
    ),
    Skill(
      id: marketStructure,
      name: 'Market Structure',
      shortName: 'Structure',
      description: 'Swing points and the sequences they form.',
    ),
    Skill(
      id: trendReading,
      name: 'Trend Reading',
      shortName: 'Trends',
      description: 'Telling continuation, pullback and range apart.',
    ),
    Skill(
      id: longShort,
      name: 'Long & Short',
      shortName: 'Direction',
      description: 'Both directions, plus the decision not to trade.',
    ),
    Skill(
      id: orders,
      name: 'Order Types',
      shortName: 'Orders',
      description: 'Market, limit and stop orders, and when each fits.',
    ),
    Skill(
      id: stopLoss,
      name: 'Stops & Targets',
      shortName: 'Stops',
      description: 'Defining invalidation and where a trade is finished.',
    ),
    Skill(
      id: riskManagement,
      name: 'Risk Management',
      shortName: 'Risk',
      description: 'Position sizing, R multiples and drawdown.',
    ),
    Skill(
      id: supportResistance,
      name: 'Support & Resistance',
      shortName: 'Levels',
      description: 'Areas price has repeatedly reacted to.',
    ),
    Skill(
      id: liquidity,
      name: 'Breakouts & Liquidity',
      shortName: 'Liquidity',
      description: 'Breaks, failed breaks and clustered orders.',
    ),
    Skill(
      id: priceAction,
      name: 'Advanced Price Action',
      shortName: 'Price action',
      description:
          'BOS, CHoCH, fair value gaps and order blocks as frameworks.',
    ),
    Skill(
      id: tradePlanning,
      name: 'Trading Process',
      shortName: 'Process',
      description: 'Plans, checklists, journaling and review.',
    ),
  ];

  static final Map<String, Skill> _byId = {for (final s in all) s.id: s};

  static Skill? tryById(String id) => _byId[id];

  static Skill byId(String id) => _byId[id] ?? all.first;

  static String nameOf(String id) => _byId[id]?.name ?? id;

  static List<String> get ids => all.map((s) => s.id).toList(growable: false);
}

/// A learner's current mastery of one skill.
@immutable
class SkillMastery {
  const SkillMastery({
    required this.skillId,
    this.score = 0,
    this.attempts = 0,
    this.correct = 0,
    this.lastPracticed,
  });

  final String skillId;

  /// 0..100.
  final double score;
  final int attempts;
  final int correct;
  final DateTime? lastPracticed;

  double get accuracy => attempts == 0 ? 0 : correct / attempts;

  MasteryBand get band {
    if (attempts < 5) return MasteryBand.untested;
    if (score >= 85) return MasteryBand.strong;
    if (score >= 65) return MasteryBand.solid;
    if (score >= 40) return MasteryBand.developing;
    return MasteryBand.weak;
  }

  SkillMastery copyWith({
    double? score,
    int? attempts,
    int? correct,
    DateTime? lastPracticed,
  }) => SkillMastery(
    skillId: skillId,
    score: score ?? this.score,
    attempts: attempts ?? this.attempts,
    correct: correct ?? this.correct,
    lastPracticed: lastPracticed ?? this.lastPracticed,
  );
}

enum MasteryBand {
  untested('Not yet tested'),
  weak('Needs work'),
  developing('Developing'),
  solid('Solid'),
  strong('Strong');

  const MasteryBand(this.label);
  final String label;
}
