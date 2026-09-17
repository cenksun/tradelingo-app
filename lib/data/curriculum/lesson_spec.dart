import '../../domain/models/enums.dart';

/// Compact authoring types for the curriculum.
///
/// The curriculum is written as *specs*, not as finished activity objects. A
/// spec carries the teaching content — the concepts, the questions, which
/// chart shapes to drill — and [LessonAssembler] expands it into the 8–15
/// activities a lesson actually runs. That keeps 120 lessons authorable and
/// keeps the expansion rules in one testable place.

/// One idea taught in a lesson.
class ConceptSpec {
  const ConceptSpec(
    this.term,
    this.oneLiner,
    this.detail, {
    this.bullets = const [],
  });

  final String term;

  /// A single-sentence definition, also reused by matching exercises.
  final String oneLiner;

  /// The explanation card body.
  final String detail;
  final List<String> bullets;
}

/// A multiple-choice question.
class QuizSpec {
  const QuizSpec(
    this.prompt,
    this.options,
    this.correctIndex,
    this.why, {
    this.optionFeedback = const {},
    this.concept,
    this.mistake,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String why;
  final Map<int, String> optionFeedback;
  final String? concept;
  final MistakeTag? mistake;
}

/// A true/false statement.
class FactSpec {
  const FactSpec(this.statement, this.isTrue, this.why, {this.concept});

  final String statement;
  final bool isTrue;
  final String why;
  final String? concept;
}

/// The chart exercise templates. One template plus one chart shape plus a seed
/// produces a complete exercise: prompt, chart, correct answer and feedback.
enum ChartTask {
  tapHighestHigh,
  tapLowestLow,
  tapLargestBody,
  tapWidestRange,
  tapSwingHigh,
  tapSwingLow,
  tapOpen,
  tapHigh,
  tapLow,
  tapClose,
  identifyHigherHigh,
  identifyHigherLow,
  identifyLowerHigh,
  identifyLowerLow,
  labelStructure,
  classifyTrend,
  decideDirection,
  placeStopLong,
  placeStopShort,
  placeTargetLong,
  placeTargetShort,
  buildTradeLong,
  buildTradeShort,
  selectSupport,
  selectResistance,
  selectRangeHigh,
  selectRangeLow,
  selectFairValueGapUp,
  selectFairValueGapDown,
  selectOrderBlockUp,
  selectLiquidityAbove,
  selectLiquidityBelow,
  miniSimulation,
}

/// A chart exercise to generate.
class ChartTaskSpec {
  const ChartTaskSpec(
    this.task,
    this.pattern,
    this.seed, {
    this.difficulty,
    this.note,
    this.preferred,
    this.acceptable = const [],
    this.anonymized = false,
  });

  final ChartTask task;
  final ChartPattern pattern;
  final int seed;
  final Difficulty? difficulty;

  /// Extra sentence appended to the generated explanation.
  final String? note;

  /// For direction/mini-simulation tasks. Defaults to the pattern's own bias.
  final TradeDirection? preferred;
  final List<TradeDirection> acceptable;
  final bool anonymized;
}

/// Non-chart exercises that do not fit the quiz/fact shape.
sealed class ExtraSpec {
  const ExtraSpec();
}

class RiskCalcSpec extends ExtraSpec {
  const RiskCalcSpec(this.prompt, this.expected, this.why, {this.concept});
  final String prompt;
  final double expected;
  final String why;
  final String? concept;
}

class RiskRewardSpec extends ExtraSpec {
  const RiskRewardSpec(
    this.prompt,
    this.entry,
    this.stopLoss,
    this.takeProfit,
    this.direction,
    this.why, {
    this.concept,
  });
  final String prompt;
  final double entry;
  final double stopLoss;
  final double takeProfit;
  final TradeDirection direction;
  final String why;
  final String? concept;
}

class OrderTypeSpec extends ExtraSpec {
  const OrderTypeSpec(this.scenario, this.correct, this.why);
  final String scenario;
  final OrderType correct;
  final String why;
}

class SequenceSpec extends ExtraSpec {
  const SequenceSpec(this.prompt, this.stepsInOrder, this.why, {this.concept});
  final String prompt;
  final List<String> stepsInOrder;
  final String why;
  final String? concept;
}

class SpotMistakeSpec extends ExtraSpec {
  const SpotMistakeSpec(
    this.scenario,
    this.options,
    this.correctIndex,
    this.tag,
    this.why,
  );
  final String scenario;
  final List<String> options;
  final int correctIndex;
  final MistakeTag tag;
  final String why;
}

/// Everything needed to build one lesson.
class LessonSpec {
  const LessonSpec({
    required this.title,
    required this.subtitle,
    required this.intro,
    required this.concepts,
    this.quizzes = const [],
    this.facts = const [],
    this.charts = const [],
    this.extras = const [],
    this.skills = const [],
    this.difficulty = Difficulty.beginner,
    this.minutes = 4,
    this.recap,
    this.includeMatching = true,
  });

  final String title;
  final String subtitle;
  final String intro;
  final List<ConceptSpec> concepts;
  final List<QuizSpec> quizzes;
  final List<FactSpec> facts;
  final List<ChartTaskSpec> charts;
  final List<ExtraSpec> extras;
  final List<String> skills;
  final Difficulty difficulty;
  final int minutes;
  final String? recap;
  final bool includeMatching;
}

/// A world's closing challenge: a wider mix drawn from everything it taught.
class BossSpec {
  const BossSpec({
    required this.title,
    required this.subtitle,
    required this.intro,
    this.quizzes = const [],
    this.facts = const [],
    this.charts = const [],
    this.extras = const [],
    this.skills = const [],
    this.difficulty = Difficulty.intermediate,
    this.passThreshold = 0.8,
    this.minutes = 8,
  });

  final String title;
  final String subtitle;
  final String intro;
  final List<QuizSpec> quizzes;
  final List<FactSpec> facts;
  final List<ChartTaskSpec> charts;
  final List<ExtraSpec> extras;
  final List<String> skills;
  final Difficulty difficulty;
  final double passThreshold;
  final int minutes;
}

/// A world plus the lessons it contains.
class WorldSpec {
  const WorldSpec({
    required this.id,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.primarySkillId,
    required this.accentColor,
    required this.lessons,
    required this.boss,
  });

  final String id;
  final int index;
  final String title;
  final String subtitle;
  final String description;
  final String primarySkillId;
  final int accentColor;
  final List<LessonSpec> lessons;
  final BossSpec boss;
}
