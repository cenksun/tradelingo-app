import '../../../domain/models/enums.dart';
import '../../../domain/models/skill.dart';
import '../lesson_spec.dart';

/// World 4 — Trends. Turning structure labels into a reading of direction.
const WorldSpec world04Trends = WorldSpec(
  id: 'w04',
  index: 4,
  title: 'Trends',
  subtitle: 'Continuation, pullback and range',
  description:
      'Using structure to describe direction: what a trend is, what a pullback is, and why '
      '"range" is an answer rather than a failure.',
  primarySkillId: Skills.trendReading,
  accentColor: 0xFF2FD383,
  lessons: [
    LessonSpec(
      title: 'What a Trend Is',
      subtitle: 'A definition you can test',
      minutes: 5,
      intro:
          'Plenty of people use "trend" to mean "it has been going up a lot". That is not '
          'testable. Structure gives a definition you can check against the chart.',
      concepts: [
        ConceptSpec(
          'Uptrend',
          'A sequence of higher highs and higher lows.',
          'Both series must be progressing. This is a description of what has already been '
              'printed, and it stays true only until one of the two series breaks.',
        ),
        ConceptSpec(
          'Downtrend',
          'A sequence of lower highs and lower lows.',
          'The mirror image. Again both series are required — lower lows alone are not enough.',
        ),
        ConceptSpec(
          'Trend as description',
          'A trend describes the past, not a commitment about the future.',
          '"The market is in an uptrend" means the recent swings have stepped upwards. It does '
              'not mean the next swing will. Every uptrend that ever existed was still an '
              'uptrend right up to the moment it was not.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Which pair of conditions defines an uptrend in this framework?',
          [
            'Higher highs and higher lows',
            'Higher highs only',
            'Price above a moving average',
            'Several green candles in a row',
          ],
          0,
          'Both series must be stepping up. The other options describe appearance, not structure.',
          concept: 'uptrend',
        ),
        QuizSpec(
          'Saying "this market is in an uptrend" is a claim about:',
          [
            'What the recent swings have done',
            'What the next swing will do',
            'The true value of the asset',
            'The next week of trading',
          ],
          0,
          'It is a description of printed structure and nothing else.',
          concept: 'trend_as_description',
        ),
        QuizSpec(
          'Price has made lower lows but also higher highs. Is that a downtrend?',
          [
            'No — a downtrend needs lower highs as well',
            'Yes, lower lows are what matter',
            'Yes, if volume is rising',
            'Only on a daily chart',
          ],
          0,
          'That combination is an expanding pattern, not a trend by this definition.',
          concept: 'downtrend',
        ),
      ],
      facts: [
        FactSpec(
          'An uptrend requires both higher highs and higher lows.',
          true,
          'Either one alone is an incomplete reading.',
          concept: 'uptrend',
        ),
        FactSpec(
          'Identifying a trend tells you how much longer it will last.',
          false,
          'Nothing on a chart contains that information.',
          concept: 'trend_as_description',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.uptrend, 40101),
        ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.downtrend, 40102),
      ],
    ),
    LessonSpec(
      title: 'Impulse and Pullback',
      subtitle: 'Two halves of every trend leg',
      minutes: 5,
      intro:
          'Trends move in two alternating phases. Telling them apart is what most trend-following '
          'decisions actually rest on.',
      concepts: [
        ConceptSpec(
          'Impulse',
          'A move in the direction of the trend, usually faster and with less overlap.',
          'Impulse legs cover ground. Candles tend to be larger and overlap less, because one '
              'side is carrying price without much argument.',
        ),
        ConceptSpec(
          'Pullback',
          'A move against the trend that does not break its structure.',
          'Pullbacks are usually slower, choppier and more overlapped. They are where higher '
              'lows form in an uptrend — and where the temptation to call a reversal is strongest.',
        ),
        ConceptSpec(
          'Overlap as a clue',
          'How much consecutive candles share price tells you which phase you are in.',
          'Heavy overlap suggests a pullback; light overlap suggests an impulse. Like everything '
              'else here it is a tendency, not a rule.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Compared with an impulse leg, a pullback usually shows:',
          [
            'More overlap between consecutive candles',
            'Larger candles with less overlap',
            'Higher volume without exception',
            'Exactly half the distance',
          ],
          0,
          'Pullbacks are contested moves, which shows up as candles trading over the same ground.',
          concept: 'overlap_as_a_clue',
        ),
        QuizSpec(
          'Where do higher lows form in an uptrend?',
          [
            'At the end of pullbacks',
            'At the end of impulses',
            'At the highest point of the trend',
            'Randomly',
          ],
          0,
          'A higher low is where a pullback stopped.',
          concept: 'pullback',
        ),
        QuizSpec(
          'Why is it hard to tell a pullback from the start of a reversal?',
          [
            'They look identical while they are happening',
            'Pullbacks only appear on low timeframes',
            'Reversals are always faster',
            'It is not hard if you use the 50% level',
          ],
          0,
          'Only what follows distinguishes them. Retracement percentages are conventions with '
              'many exceptions.',
          concept: 'pullback',
        ),
      ],
      facts: [
        FactSpec(
          'A deep pullback proves the trend has ended.',
          false,
          'Deep pullbacks resolve in the original direction regularly. Structure, not depth, '
              'decides.',
          concept: 'pullback',
        ),
        FactSpec(
          'Impulse legs typically show less overlap between candles than pullbacks.',
          true,
          'One side is carrying price with little resistance.',
          concept: 'impulse',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.uptrendPullback,
          40201,
        ),
        ChartTaskSpec(
          ChartTask.identifyHigherLow,
          ChartPattern.uptrendPullback,
          40202,
        ),
      ],
    ),
    LessonSpec(
      title: 'Trend Strength',
      subtitle: 'How firmly a trend is holding',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'Not all trends are equally firm. Strength is readable from the structure itself, and '
          'it is a statement about the past like everything else.',
      concepts: [
        ConceptSpec(
          'Shallow pullbacks',
          'Pullbacks that give back only a small part of the previous impulse.',
          'When each pullback gives back little, buyers (or sellers) are stepping in eagerly. '
              'That is what a firm trend looks like on the chart.',
        ),
        ConceptSpec(
          'Deep pullbacks',
          'Pullbacks that give back most of the previous impulse.',
          'Deep pullbacks mean the other side is fighting harder. The trend can continue, but '
              'the invalidation level is far away, which makes trading it more expensive.',
        ),
        ConceptSpec(
          'Expanding legs',
          'Each impulse covering more ground than the last.',
          'Expansion suggests increasing urgency. It also means the structure is stretching, and '
              'stretched structures tend to break more dramatically when they do.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A trend with consistently shallow pullbacks suggests:',
          [
            'The trending side has been stepping in quickly',
            'A reversal is imminent',
            'Volume is falling',
            'The trend must continue',
          ],
          0,
          'It describes eagerness that has already been demonstrated — not a promise.',
          concept: 'shallow_pullbacks',
        ),
        QuizSpec(
          'Why do deep pullbacks make a trend more expensive to trade?',
          [
            'The invalidation level sits much further away, so risk per unit is larger',
            'Spreads widen during pullbacks',
            'Deep pullbacks always reverse',
            'Brokers charge more',
          ],
          0,
          'Stops belong beyond the structural level. A deeper pullback pushes that level further '
              'from any sensible entry.',
          concept: 'deep_pullbacks',
        ),
        QuizSpec(
          'Successive impulse legs are getting longer. What is the honest reading?',
          [
            'Movement is expanding; the structure is stretching',
            'The trend is guaranteed to continue',
            'A reversal is due',
            'The data is unreliable',
          ],
          0,
          'Expansion describes what has happened. Both "continues" and "reverses" remain open.',
          concept: 'expanding_legs',
        ),
      ],
      facts: [
        FactSpec(
          'Shallow pullbacks guarantee the trend will continue.',
          false,
          'They describe past eagerness. Trends with shallow pullbacks still end.',
          concept: 'shallow_pullbacks',
        ),
        FactSpec(
          'Deeper pullbacks push the structural invalidation level further from a trend entry.',
          true,
          'Which directly increases risk per unit for the same idea.',
          concept: 'deep_pullbacks',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.breakoutUp, 40301),
      ],
    ),
    LessonSpec(
      title: 'Trend Continuation',
      subtitle: 'What has to keep happening',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'For an uptrend to continue, two specific things have to keep happening. Naming them '
          'turns a vague hope into a checkable condition.',
      concepts: [
        ConceptSpec(
          'Continuation conditions',
          'The next low holds above the last low, and the next high exceeds the last high.',
          'Both. If the low holds but the high fails, the trend is stalling rather than '
              'continuing. Writing the two conditions down is what makes "I think it goes up" '
              'into something that can be checked.',
        ),
        ConceptSpec(
          'Stalling',
          'Lows still holding but highs no longer progressing.',
          'A stall is neither continuation nor reversal. It often precedes a range. It is an '
              'uncomfortable state precisely because it does not tell you what to do.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'An uptrend makes a higher low but then a lower high. What is that?',
          [
            'Stalling — one condition held, the other did not',
            'Confirmed continuation',
            'Confirmed reversal',
            'A labelling error',
          ],
          0,
          'Half of the structure progressed and half did not. Neither conclusion is available yet.',
          concept: 'stalling',
        ),
        QuizSpec(
          'What are the two conditions for uptrend continuation?',
          [
            'A higher low followed by a higher high',
            'A higher high followed by higher volume',
            'Three green candles',
            'Price above the previous close',
          ],
          0,
          'Both series have to progress for the trend definition to keep holding.',
          concept: 'continuation_conditions',
        ),
        QuizSpec(
          'Why write the continuation conditions down before entering?',
          [
            'It turns an opinion into something that can be checked against the chart',
            'It is required by most brokers',
            'It improves the win rate',
            'It makes the stop unnecessary',
          ],
          0,
          'A condition you can check is a condition you can be wrong about — which is what makes '
              'risk management possible.',
          concept: 'continuation_conditions',
        ),
      ],
      facts: [
        FactSpec(
          'A stalling trend is the same thing as a reversal.',
          false,
          'Stalls resolve in either direction, and often into a range.',
          concept: 'stalling',
        ),
        FactSpec(
          'Continuation requires both the low and the high to progress.',
          true,
          'One alone leaves the reading incomplete.',
          concept: 'continuation_conditions',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.identifyHigherHigh,
          ChartPattern.uptrend,
          40401,
        ),
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.changeOfCharacterDown,
          40402,
        ),
      ],
    ),
    LessonSpec(
      title: 'Trend Endings',
      subtitle: 'How readings stop being true',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'Trends do not announce their endings. What happens is that one of the two conditions '
          'stops holding, and the reading has to change.',
      concepts: [
        ConceptSpec(
          'Failed continuation',
          'The trend fails to make a new extreme and then breaks the last pullback level.',
          'This is the ordinary way a trend reading ends: a high that falls short, followed by a '
              'break of the last higher low. Two events, in that order.',
        ),
        ConceptSpec(
          'Transition',
          'The period between one clear structure and the next.',
          'Transitions are messy by nature. They frequently look like ranges, and many of the '
              'worst trades get taken inside them by people insisting on a direction.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What is the ordinary two-step way an uptrend reading ends?',
          [
            'A high that falls short, then a break below the last higher low',
            'A single large red candle',
            'Volume falling for three candles',
            'Price crossing a moving average',
          ],
          0,
          'Failure to progress, then failure to hold. Both steps are structural events.',
          concept: 'failed_continuation',
        ),
        QuizSpec(
          'How should a messy transition period be treated?',
          [
            'As a period where standing aside is often the strongest option',
            'As an opportunity to trade both directions',
            'As a guaranteed range',
            'As a reason to increase size',
          ],
          0,
          'Unclear structure and forced direction are how transitions drain accounts.',
          concept: 'transition',
        ),
        QuizSpec(
          'One lower high appears in an uptrend. What does it confirm?',
          [
            'Nothing on its own — the higher lows have not been broken',
            'The trend is over',
            'A downtrend has started',
            'A range has formed',
          ],
          0,
          'One failed high is a stall. The reading changes when the low breaks too.',
          concept: 'failed_continuation',
        ),
      ],
      facts: [
        FactSpec(
          'Trends give a clear warning before they end.',
          false,
          'The signs are only obvious afterwards. At the time they look like every ordinary '
              'pullback.',
          concept: 'transition',
        ),
        FactSpec(
          'A single lower high ends an uptrend reading by itself.',
          false,
          'The higher lows have to break as well.',
          concept: 'failed_continuation',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.falseBreakoutUp,
          40501,
        ),
        ChartTaskSpec(
          ChartTask.identifyLowerHigh,
          ChartPattern.changeOfCharacterDown,
          40502,
        ),
      ],
    ),
    LessonSpec(
      title: 'Ranges as an Answer',
      subtitle: 'Sideways is a real reading',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          '"Range" is not what you say when you cannot find a trend. It is a distinct reading '
          'with its own consequences.',
      concepts: [
        ConceptSpec(
          'Range reading',
          'Concluding that neither series of swings is making progress.',
          'Inside a range, trend-following logic works against you: the moves are short and '
              'reverse at the boundaries. Recognising the range is what prevents that.',
        ),
        ConceptSpec(
          'Range width',
          'The distance between the boundaries.',
          'A wide range can contain perfectly tradeable moves. A narrow one usually does not, '
              'because the available distance barely covers the spread and a sensible stop.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Why does trend-following logic tend to fail inside a range?',
          [
            'Moves are short and reverse near the boundaries',
            'Ranges have no volume',
            'Spreads are always wider',
            'Ranges are not real structures',
          ],
          0,
          'Breakout entries inside a range repeatedly buy the high and sell the low.',
          concept: 'range_reading',
        ),
        QuizSpec(
          'A very narrow range is usually a poor place to trade because:',
          [
            'The available distance barely covers the spread and a sensible stop',
            'Narrow ranges never break out',
            'Price does not move in them',
            'Brokers restrict them',
          ],
          0,
          'If the whole range is only a few times the spread, the arithmetic does not work.',
          concept: 'range_width',
        ),
        QuizSpec(
          'Concluding "this is a range" is:',
          [
            'A legitimate analytical result',
            'An admission of failure',
            'A sign you need a lower timeframe',
            'Only valid on daily charts',
          ],
          0,
          'It is a reading with clear consequences, which makes it useful.',
          concept: 'range_reading',
        ),
      ],
      facts: [
        FactSpec(
          'Concluding a chart is ranging is a valid outcome of analysis.',
          true,
          'It changes what you do, which is what makes it a result.',
          concept: 'range_reading',
        ),
        FactSpec(
          'All ranges are too small to trade.',
          false,
          'Width decides. Wide ranges contain plenty of distance.',
          concept: 'range_width',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.tightConsolidation,
          40601,
        ),
        ChartTaskSpec(ChartTask.selectRangeHigh, ChartPattern.range, 40602),
      ],
    ),
    LessonSpec(
      title: 'Multi-Swing Reading',
      subtitle: 'Looking at five swings, not two',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro: 'Two swings can be labelled but barely describe anything. Five start to show a shape.',
      concepts: [
        ConceptSpec(
          'Swing count',
          'How many swings you include in a reading.',
          'Reading only the last two swings makes every pullback look like a reversal. Widening '
              'to four or five puts each move in proportion.',
        ),
        ConceptSpec(
          'Proportion',
          'Comparing the size of each leg with the ones around it.',
          'A pullback that is small relative to the impulse before it reads very differently '
              'from one the same size as the impulse, even though both are labelled the same way.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What goes wrong when you read only the last two swings?',
          [
            'Every pullback looks like a potential reversal',
            'You cannot apply labels',
            'The chart renders incorrectly',
            'Nothing — two swings is enough',
          ],
          0,
          'Without surrounding context there is no way to judge whether a move is ordinary.',
          concept: 'swing_count',
        ),
        QuizSpec(
          'Two pullbacks carry the same HL label but one is far larger. Does that matter?',
          [
            'Yes — proportion changes the reading even when the label is identical',
            'No, the label is all that matters',
            'Only if volume differs',
            'Only on daily charts',
          ],
          0,
          'Labels are categorical; proportion adds the degree that labels leave out.',
          concept: 'proportion',
        ),
        QuizSpec(
          'How many swings give a reasonable structural reading?',
          [
            'Around four to six',
            'Exactly two',
            'At least twenty',
            'One is enough on a higher timeframe',
          ],
          0,
          'Enough for a pattern to emerge, few enough to still be current.',
          concept: 'swing_count',
        ),
      ],
      facts: [
        FactSpec(
          'Two swings labelled correctly are enough for a full structural reading.',
          false,
          'Labels without proportion and context describe very little.',
          concept: 'swing_count',
        ),
        FactSpec(
          'The relative size of legs adds information the labels do not carry.',
          true,
          'HH and HL are categories; size is degree.',
          concept: 'proportion',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.labelStructure, ChartPattern.uptrend, 40701),
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.liquiditySweepHigh,
          40702,
        ),
      ],
    ),
    LessonSpec(
      title: 'Trends and Timeframes',
      subtitle: 'Which trend are you talking about?',
      minutes: 4,
      difficulty: Difficulty.advanced,
      intro:
          'The word "trend" is meaningless without a timeframe attached. Saying which one you '
          'mean prevents most trend arguments.',
      concepts: [
        ConceptSpec(
          'Trend scope',
          'The timeframe a trend statement refers to.',
          '"The trend is up" should always be "the trend is up on the 4-hour chart". Different '
              'scopes routinely disagree, and both can be right.',
        ),
        ConceptSpec(
          'Alignment',
          'When two timeframes point the same way.',
          'Alignment is often described as a stronger condition. It is more accurate to say it '
              'is a clearer one: fewer conflicting readings to weigh. It does not raise the '
              'probability of any individual trade in a way anyone can measure reliably.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What is missing from the statement "the trend is up"?',
          [
            'Which timeframe it refers to',
            'The instrument',
            'The volume',
            'Nothing is missing',
          ],
          0,
          'Without a scope the statement cannot be checked.',
          concept: 'trend_scope',
        ),
        QuizSpec(
          'Two timeframes both show bullish structure. The honest description is:',
          [
            'The readings agree, so there are fewer conflicting signals to weigh',
            'The trade is now high probability',
            'The trend cannot reverse',
            'Risk can safely be increased',
          ],
          0,
          'Agreement simplifies the decision. It does not supply a probability.',
          optionFeedback: {
            1: 'No chart condition supplies a measurable probability for an individual trade.',
          },
          concept: 'alignment',
        ),
        QuizSpec(
          'The daily is bullish and the 15-minute is bearish. Which is correct?',
          [
            'Both, for their own scope',
            'The daily',
            'The 15-minute',
            'Neither',
          ],
          0,
          'They describe different scales of the same data.',
          concept: 'trend_scope',
        ),
      ],
      facts: [
        FactSpec(
          'A trend statement should always name the timeframe it refers to.',
          true,
          'Otherwise it cannot be checked or disagreed with usefully.',
          concept: 'trend_scope',
        ),
        FactSpec(
          'Timeframe alignment makes a trade high probability.',
          false,
          'It makes the reading clearer. Probability is not something a chart hands you.',
          concept: 'alignment',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.downtrendPullback,
          40801,
        ),
      ],
    ),
    LessonSpec(
      title: 'Trend Reading Mistakes',
      subtitle: 'Where trend reading usually breaks',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'Almost every trend-reading error is one of three things: too few swings, the wrong '
          'timeframe, or a conclusion decided before the chart was read.',
      concepts: [
        ConceptSpec(
          'Confirmation bias',
          'Reading the chart to support a conclusion you already hold.',
          'Once you want a long, higher lows become obvious and lower highs become noise. The '
              'defence is mechanical: label every swing before deciding anything.',
        ),
        ConceptSpec(
          'Timeframe hopping',
          'Switching timeframes until one agrees with you.',
          'If the hourly does not support the idea, the 5-minute usually will. That is not '
              'analysis; it is shopping for permission.',
        ),
        ConceptSpec(
          'Recency weighting',
          'Giving the last candle more weight than the whole structure.',
          'One large candle feels like new information. Usually it is one swing inside a '
              'sequence that has not changed.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A trader wants to buy, checks the hourly (bearish), the 15-minute (bearish) and the '
              '5-minute (bullish), then takes the long. What happened?',
          [
            'Timeframe hopping to find agreement with a decision already made',
            'Sound multi-timeframe analysis',
            'Correct use of the lower timeframe for entry',
            'Nothing wrong',
          ],
          0,
          'The context timeframe should be chosen before the analysis, not after the answer.',
          concept: 'timeframe_hopping',
          mistake: MistakeTag.impulsiveTrade,
        ),
        QuizSpec(
          'What is the practical defence against confirmation bias when reading structure?',
          [
            'Label every swing mechanically before forming a view',
            'Trade smaller',
            'Use more indicators',
            'Only trade higher timeframes',
          ],
          0,
          'A mechanical process gives the chart a chance to disagree with you.',
          concept: 'confirmation_bias',
        ),
        QuizSpec(
          'One unusually large candle appears against the trend. What is the honest reading?',
          [
            'It is one candle; the structure has not changed until a swing breaks',
            'The trend has reversed',
            'It should be ignored entirely',
            'It confirms the trend',
          ],
          0,
          'Structure changes when swings break, not when a candle looks dramatic.',
          concept: 'recency_weighting',
        ),
      ],
      facts: [
        FactSpec(
          'Choosing your context timeframe after analysing is a sound method.',
          false,
          'Choosing it afterwards means choosing the answer you wanted.',
          concept: 'timeframe_hopping',
        ),
        FactSpec(
          'A single large candle changes the structural reading.',
          false,
          'Structure changes when a swing level is broken.',
          concept: 'recency_weighting',
        ),
      ],
      extras: [
        SpotMistakeSpec(
          'A trader writes: "Daily is clearly down but I found a bullish setup on the 3-minute '
              'chart, so I am going long with a wide stop and holding it for days."',
          [
            'The entry timeframe and the holding period do not match, and the context was ignored',
            'The stop should be tighter',
            '3-minute charts cannot be traded',
            'The trader should have used a limit order',
          ],
          0,
          MistakeTag.trendMisread,
          'A 3-minute signal describes 3-minute structure. Holding for days means daily '
              'structure decides the outcome, and that was read as down. The mismatch between '
              'signal scope and holding period is the core problem.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Trend Practice',
      subtitle: 'Classify unfamiliar charts',
      minutes: 6,
      difficulty: Difficulty.advanced,
      intro: 'Mixed charts with no hints. Classify each one, and be willing to answer "range".',
      concepts: [
        ConceptSpec(
          'Classification discipline',
          'Applying the same definition to every chart, however it looks.',
          'The definitions do not bend for a chart that feels obviously bullish. Consistency is '
              'what makes your readings comparable over time.',
        ),
        ConceptSpec(
          'Comfort with "range"',
          'Being willing to answer that there is no trend.',
          'Learners systematically under-report ranges because a trend feels like a better '
              'answer. It is not; it is just a different one.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Why do learners under-report ranges?',
          [
            'A trend feels like a more useful answer, so it gets chosen more often',
            'Ranges are rarer than trends',
            'Ranges are harder to see',
            'Software hides them',
          ],
          0,
          'Ranges are extremely common. The bias is psychological, not visual.',
          concept: 'comfort_with_range',
        ),
        QuizSpec(
          'A chart is genuinely ambiguous. What is the correct classification?',
          [
            'Range or unclear',
            'Whichever direction the last candle points',
            'Bullish, as the default',
            'Wait for more candles before answering',
          ],
          0,
          'Ambiguity is the answer, and it leads directly to a no-trade decision.',
          concept: 'classification_discipline',
        ),
        QuizSpec(
          'Consistent classification matters because:',
          [
            'It makes your readings comparable across time and charts',
            'It guarantees better results',
            'It is required for journaling',
            'It speeds up analysis',
          ],
          0,
          'Without consistency you cannot tell whether your reading improved or the charts got '
              'easier.',
          concept: 'classification_discipline',
        ),
      ],
      facts: [
        FactSpec(
          'Ranges are less common than trends on most charts.',
          false,
          'Sideways conditions occupy a large share of market time.',
          concept: 'comfort_with_range',
        ),
        FactSpec(
          'The same trend definition should be applied to every chart regardless of appearance.',
          true,
          'That consistency is what makes the readings worth anything.',
          concept: 'classification_discipline',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.choppyVolatile,
          40901,
        ),
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.breakOfStructureUp,
          40902,
        ),
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.resistanceTest,
          40903,
        ),
      ],
    ),
  ],
  boss: BossSpec(
    title: 'Trend Reading Challenge',
    subtitle: 'Bullish, bearish or range',
    difficulty: Difficulty.advanced,
    minutes: 8,
    intro:
        'Classify a spread of charts and answer on continuation, pullbacks and endings. Score '
        '80% to unlock Long & Short.',
    charts: [
      ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.uptrend, 49001),
      ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.downtrend, 49002),
      ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.range, 49003),
      ChartTaskSpec(
        ChartTask.classifyTrend,
        ChartPattern.uptrendPullback,
        49004,
      ),
      ChartTaskSpec(
        ChartTask.classifyTrend,
        ChartPattern.choppyVolatile,
        49005,
      ),
      ChartTaskSpec(ChartTask.identifyHigherLow, ChartPattern.uptrend, 49006),
    ],
    quizzes: [
      QuizSpec(
        'What two things must keep happening for an uptrend to continue?',
        [
          'Each low holds above the last, and each high exceeds the last',
          'Volume rises and candles get bigger',
          'Price stays above a moving average',
          'Green candles outnumber red ones',
        ],
        0,
        'Both structural series must progress.',
        concept: 'continuation_conditions',
      ),
      QuizSpec(
        'A trend makes a lower high but its higher lows are intact. What is it?',
        ['Stalling', 'Reversed', 'Continuing', 'A range, confirmed'],
        0,
        'One condition failed and one held; neither conclusion is available.',
        concept: 'stalling',
      ),
      QuizSpec(
        'Deep pullbacks affect a trend trade mainly by:',
        [
          'Pushing the structural invalidation level further away',
          'Reducing the spread',
          'Guaranteeing a reversal',
          'Improving reward-to-risk',
        ],
        0,
        'A further stop means more risk per unit for the same idea.',
        concept: 'deep_pullbacks',
      ),
    ],
    facts: [
      FactSpec(
        'A trend describes what price has already done.',
        true,
        'It carries no information about duration or what comes next.',
        concept: 'trend_as_description',
      ),
      FactSpec(
        'Answering "range" means you failed to analyse the chart.',
        false,
        'It is a distinct reading with distinct consequences.',
        concept: 'range_reading',
      ),
    ],
  ),
);
