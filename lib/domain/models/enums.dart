/// Difficulty drives chart complexity, candle count, noise, distractor
/// similarity and how many concepts an exercise combines — not just a label.
enum Difficulty {
  beginner('Beginner', 1),
  intermediate('Intermediate', 2),
  advanced('Advanced', 3),
  expert('Expert', 4);

  const Difficulty(this.label, this.weight);
  final String label;
  final int weight;

  /// Candles rendered for a chart exercise at this difficulty.
  int get candleCount => switch (this) {
    Difficulty.beginner => 34,
    Difficulty.intermediate => 52,
    Difficulty.advanced => 76,
    Difficulty.expert => 104,
  };

  /// Relative amount of intra-leg noise applied to synthetic series.
  double get noise => switch (this) {
    Difficulty.beginner => 0.22,
    Difficulty.intermediate => 0.42,
    Difficulty.advanced => 0.62,
    Difficulty.expert => 0.82,
  };

  /// How close wrong answers sit to the right one.
  double get distractorSimilarity => switch (this) {
    Difficulty.beginner => 0.25,
    Difficulty.intermediate => 0.5,
    Difficulty.advanced => 0.75,
    Difficulty.expert => 0.92,
  };

  /// Hints available before the answer is locked in.
  int get hintAllowance => switch (this) {
    Difficulty.beginner => 2,
    Difficulty.intermediate => 1,
    Difficulty.advanced => 1,
    Difficulty.expert => 0,
  };

  static Difficulty fromName(
    String? name, {
    Difficulty fallback = Difficulty.beginner,
  }) => Difficulty.values.firstWhere(
    (d) => d.name == name,
    orElse: () => fallback,
  );
}

/// A trade direction. `noTrade` is a first-class, gradable decision: choosing
/// to stay flat is part of the curriculum, not the absence of an answer.
enum TradeDirection {
  long('Long'),
  short('Short'),
  noTrade('No Trade');

  const TradeDirection(this.label);
  final String label;

  static TradeDirection fromName(String? name) => TradeDirection.values
      .firstWhere((d) => d.name == name, orElse: () => TradeDirection.noTrade);
}

/// How a simulated trade finished.
enum TradeOutcome {
  stopHit('Stop loss hit'),
  targetHit('Target hit'),
  timeExit('Closed at end of data'),
  noTrade('No position taken'),
  invalid('Not evaluated');

  const TradeOutcome(this.label);
  final String label;

  static TradeOutcome fromName(String? name) => TradeOutcome.values.firstWhere(
    (o) => o.name == name,
    orElse: () => TradeOutcome.invalid,
  );
}

enum OrderType {
  market('Market', 'Executes immediately at the best available price.'),
  limit(
    'Limit',
    'Rests at a chosen price and only fills at that price or better.',
  ),
  stop('Stop', 'Activates once price trades through a chosen trigger level.');

  const OrderType(this.label, this.description);
  final String label;
  final String description;

  static OrderType fromName(String? name) => OrderType.values.firstWhere(
    (o) => o.name == name,
    orElse: () => OrderType.market,
  );
}

/// Trend classification used by exercises and the scenario classifier.
enum TrendClass {
  bullish('Bullish structure'),
  bearish('Bearish structure'),
  range('Range / unclear');

  const TrendClass(this.label);
  final String label;
}

/// Labels for swing points in market-structure exercises.
enum SwingLabel {
  first('Start', 'The first reference swing in the sequence.'),
  higherHigh('HH', 'Higher High — a swing high above the previous swing high.'),
  higherLow('HL', 'HL — a swing low above the previous swing low.'),
  lowerHigh('LH', 'LH — a swing high below the previous swing high.'),
  lowerLow('LL', 'LL — a swing low below the previous swing low.'),
  equalHigh('EQH', 'Equal High — a high that matches a prior high closely.'),
  equalLow('EQL', 'Equal Low — a low that matches a prior low closely.');

  const SwingLabel(this.short, this.description);
  final String short;
  final String description;

  bool get isHigh =>
      this == SwingLabel.higherHigh ||
      this == SwingLabel.lowerHigh ||
      this == SwingLabel.equalHigh;

  bool get isLow =>
      this == SwingLabel.higherLow ||
      this == SwingLabel.lowerLow ||
      this == SwingLabel.equalLow;

  /// The four labels a learner chooses between in labelling exercises.
  static const List<SwingLabel> structureSet = [
    SwingLabel.higherHigh,
    SwingLabel.higherLow,
    SwingLabel.lowerHigh,
    SwingLabel.lowerLow,
  ];
}

/// The part of a candle referenced by "tap the price point" exercises.
enum PricePart {
  open('Open'),
  high('High'),
  low('Low'),
  close('Close');

  const PricePart(this.label);
  final String label;
}

/// Kinds of highlighted chart area.
enum ZoneKind {
  support('Support zone'),
  resistance('Resistance zone'),
  demand('Demand area'),
  supply('Supply area'),
  rangeHigh('Range high'),
  rangeLow('Range low'),
  fairValueGapUp('Bullish fair value gap'),
  fairValueGapDown('Bearish fair value gap'),
  orderBlockBullish('Bullish order block'),
  orderBlockBearish('Bearish order block'),
  liquidityAbove('Liquidity above highs'),
  liquidityBelow('Liquidity below lows');

  const ZoneKind(this.label);
  final String label;
}

/// Structural shapes the synthetic generator can build and the scenario
/// classifier can detect. These are educational classifications of what price
/// has already done — they are not predictions.
enum ChartPattern {
  uptrend('Uptrend'),
  downtrend('Downtrend'),
  range('Range'),
  uptrendPullback('Uptrend pullback'),
  downtrendPullback('Downtrend pullback'),
  breakoutUp('Upside breakout'),
  breakoutDown('Downside breakout'),
  falseBreakoutUp('Failed upside breakout'),
  falseBreakoutDown('Failed downside breakout'),
  liquiditySweepHigh('Sweep of equal highs'),
  liquiditySweepLow('Sweep of equal lows'),
  supportTest('Support retest'),
  resistanceTest('Resistance retest'),
  breakOfStructureUp('Bullish break of structure'),
  breakOfStructureDown('Bearish break of structure'),
  changeOfCharacterUp('Bullish change of character'),
  changeOfCharacterDown('Bearish change of character'),
  fairValueGapUp('Bullish fair value gap'),
  fairValueGapDown('Bearish fair value gap'),
  orderBlockUp('Bullish order block'),
  orderBlockDown('Bearish order block'),
  choppyVolatile('Choppy / high volatility'),
  tightConsolidation('Tight consolidation');

  const ChartPattern(this.label);
  final String label;

  /// The trend a learner should classify this shape as.
  TrendClass get trendClass => switch (this) {
    ChartPattern.uptrend ||
    ChartPattern.uptrendPullback ||
    ChartPattern.breakoutUp ||
    ChartPattern.breakOfStructureUp ||
    ChartPattern.fairValueGapUp ||
    ChartPattern.orderBlockUp ||
    ChartPattern.supportTest => TrendClass.bullish,
    ChartPattern.downtrend ||
    ChartPattern.downtrendPullback ||
    ChartPattern.breakoutDown ||
    ChartPattern.breakOfStructureDown ||
    ChartPattern.fairValueGapDown ||
    ChartPattern.orderBlockDown ||
    ChartPattern.resistanceTest => TrendClass.bearish,
    _ => TrendClass.range,
  };

  bool get isBullishShape => trendClass == TrendClass.bullish;
  bool get isBearishShape => trendClass == TrendClass.bearish;

  static ChartPattern fromName(String? name) => ChartPattern.values.firstWhere(
    (p) => p.name == name,
    orElse: () => ChartPattern.range,
  );
}

/// Volatility bucket attached to generated scenarios.
enum VolatilityClass {
  calm('Calm'),
  normal('Normal'),
  elevated('Elevated'),
  wild('Wild');

  const VolatilityClass(this.label);
  final String label;
}

/// Standardised mistake tags, shared by the journal, adaptive practice and the
/// coach so that all three speak the same language.
enum MistakeTag {
  stopTooTight(
    'Stop too tight',
    'The stop sat inside normal noise for this chart.',
  ),
  stopTooWide(
    'Stop too wide',
    'The stop was far beyond the level that would invalidate the idea.',
  ),
  overRisk(
    'Over-risked',
    'Risk per trade was well above a conservative training limit.',
  ),
  poorRr(
    'Weak reward-to-risk',
    'The target was small relative to the distance risked.',
  ),
  structureMisread(
    'Structure misread',
    'The swing sequence was read the wrong way round.',
  ),
  trendMisread(
    'Trend misread',
    'The direction chosen conflicted with the structure on screen.',
  ),
  wrongOrderType(
    'Wrong order type',
    'The order type did not match the execution intent.',
  ),
  lateEntry('Late entry', 'Entry was taken far into an extended move.'),
  impulsiveTrade(
    'Traded an unclear chart',
    'A position was taken where structure was ambiguous.',
  ),
  ignoredInvalidation(
    'Ignored invalidation',
    'The stop did not sit beyond the level that invalidates the idea.',
  ),
  noStop('No protective stop', 'No invalidation level was defined.'),
  sizingError(
    'Position sizing error',
    'Position size did not follow from balance, risk and stop distance.',
  ),
  missedNoTrade(
    'Missed a no-trade',
    'A position was taken where standing aside was the stronger choice.',
  ),
  hesitation(
    'Skipped a clear setup',
    'No trade was taken on a chart with clear structure and room to target.',
  );

  const MistakeTag(this.label, this.description);
  final String label;
  final String description;

  static MistakeTag? fromName(String? name) {
    if (name == null) return null;
    for (final tag in MistakeTag.values) {
      if (tag.name == name) return tag;
    }
    return null;
  }
}

/// Offline demo league tiers. Competitors are clearly labelled sample profiles.
enum LeagueTier {
  bronze('Bronze', 0),
  silver('Silver', 1),
  gold('Gold', 2),
  platinum('Platinum', 3),
  diamond('Diamond', 4);

  const LeagueTier(this.label, this.rank);
  final String label;
  final int rank;

  LeagueTier get next =>
      rank >= LeagueTier.diamond.rank ? this : LeagueTier.values[rank + 1];
  LeagueTier get previous => rank <= 0 ? this : LeagueTier.values[rank - 1];

  static LeagueTier fromName(String? name) => LeagueTier.values.firstWhere(
    (t) => t.name == name,
    orElse: () => LeagueTier.bronze,
  );
}

enum ExperienceLevel {
  beginner('Complete beginner', 'Start from what a market actually is.'),
  basics(
    'Know the basics',
    'Skip nothing, but move faster through the first worlds.',
  ),
  intermediate('Intermediate', 'You have traded or studied charts before.');

  const ExperienceLevel(this.label, this.description);
  final String label;
  final String description;

  static ExperienceLevel fromName(String? name) =>
      ExperienceLevel.values.firstWhere(
        (e) => e.name == name,
        orElse: () => ExperienceLevel.beginner,
      );
}

enum ThemeChoice {
  system('Match system'),
  dark('Dark'),
  light('Light');

  const ThemeChoice(this.label);
  final String label;

  static ThemeChoice fromName(String? name) => ThemeChoice.values.firstWhere(
    (t) => t.name == name,
    orElse: () => ThemeChoice.dark,
  );
}
