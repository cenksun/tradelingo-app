import '../../../domain/models/enums.dart';
import '../../../domain/models/skill.dart';
import '../lesson_spec.dart';

/// World 2 — Candlesticks. The first world with heavy chart interaction.
const WorldSpec world02Candlesticks = WorldSpec(
  id: 'w02',
  index: 2,
  title: 'Candlesticks',
  subtitle: 'Reading one bar at a time',
  description:
      'Open, high, low and close. What a single candle records, what it leaves out, and how to '
      'read one without inventing a story.',
  primarySkillId: Skills.candlesticks,
  accentColor: 0xFF52A8FF,
  lessons: [
    LessonSpec(
      title: 'The Four Prices',
      subtitle: 'Open, high, low, close',
      minutes: 5,
      intro:
          'A candle summarises a whole period of trading with four numbers. Everything else you '
          'will ever read on a candle chart is built from those four.',
      concepts: [
        ConceptSpec(
          'Open',
          'The first traded price of the period.',
          'The open is where the period started. On a rising candle it sits at the bottom of the '
              'body; on a falling candle it sits at the top.',
        ),
        ConceptSpec(
          'High',
          'The highest price traded during the period.',
          'The high is the tip of the upper wick, not the top of the body. It tells you how far '
              'buyers managed to push before sellers answered.',
        ),
        ConceptSpec(
          'Low',
          'The lowest price traded during the period.',
          'The low is the tip of the lower wick. It marks the furthest sellers got before buyers '
              'answered.',
        ),
        ConceptSpec(
          'Close',
          'The last traded price of the period.',
          'The close is the most watched of the four. It is where the period finished, and on '
              'higher timeframes it is treated as the summary of the whole session.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Which two prices form the body of a candle?',
          ['Open and close', 'High and low', 'Open and high', 'Low and close'],
          0,
          'The body spans open to close. The wicks extend out to the high and the low.',
          concept: 'ohlc_open',
        ),
        QuizSpec(
          'A candle opens at 100, trades as high as 108, as low as 96, and closes at 97. Which '
              'value is the high?',
          ['108', '100', '97', '96'],
          0,
          'The high is the furthest price reached in either direction upward — 108 — regardless '
              'of where the candle finished.',
          concept: 'ohlc_high',
        ),
        QuizSpec(
          'Why is the close usually treated as the most important of the four?',
          [
            'It shows where the period finished after all the back-and-forth',
            'It is always the highest price',
            'It is the only price that is accurate',
            'Because charts are drawn from it alone',
          ],
          0,
          'Intra-period moves get reversed constantly. Where price settled at the end carries '
              'more weight than where it briefly travelled.',
          concept: 'ohlc_close',
        ),
      ],
      facts: [
        FactSpec(
          'The high of a candle is the top of its body.',
          false,
          'The top of the body is the higher of open and close. The high is the tip of the upper '
              'wick, which can be far above it.',
          concept: 'ohlc_high',
        ),
        FactSpec(
          'A candle tells you the order in which prices were reached within the period.',
          false,
          'It does not. A candle records four values but not their sequence. Dropping to a lower '
              'timeframe is the only way to see the path.',
          concept: 'ohlc_close',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.tapHigh, ChartPattern.uptrend, 20101),
        ChartTaskSpec(ChartTask.tapLow, ChartPattern.downtrend, 20102),
        ChartTaskSpec(ChartTask.tapClose, ChartPattern.range, 20103),
      ],
    ),
    LessonSpec(
      title: 'Bullish and Bearish Candles',
      subtitle: 'Which way did the period finish?',
      minutes: 4,
      intro:
          'A candle is called bullish or bearish purely by comparing its close with its open. '
          'That is the whole definition — no interpretation required.',
      concepts: [
        ConceptSpec(
          'Bullish candle',
          'A candle that closed above where it opened.',
          'Buyers finished the period in control. In this app bullish candles are drawn hollow '
              'with an upward marker as well as coloured, so the reading never depends on colour '
              'alone.',
        ),
        ConceptSpec(
          'Bearish candle',
          'A candle that closed below where it opened.',
          'Sellers finished the period in control. Bearish candles are drawn filled with a '
              'downward marker.',
        ),
        ConceptSpec(
          'Doji',
          'A candle that closed at or very near its open.',
          'A doji has almost no body. It says the period ended roughly where it began, whatever '
              'happened in between. It signals indecision in that period — not a reversal.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A candle opens at 50, drops to 40, rallies to 62 and closes at 51. Is it bullish or '
              'bearish?',
          [
            'Bullish — it closed above its open',
            'Bearish — it fell to 40 first',
            'Neither, because it moved both ways',
            'It depends on the previous candle',
          ],
          0,
          'Only the close-versus-open comparison decides. 51 is above 50, so the candle is '
              'bullish, however dramatic the path was.',
          optionFeedback: {
            1: 'The low does not enter into the definition at all.',
          },
          concept: 'bullish_candle',
        ),
        QuizSpec(
          'What does a doji tell you on its own?',
          [
            'That the period finished roughly where it started',
            'That price is about to reverse',
            'That volume was low',
            'That the trend has ended',
          ],
          0,
          'A doji reports indecision within one period. Treating it as a reversal signal by '
              'itself is reading far more into it than it contains.',
          optionFeedback: {
            1: 'Many dojis appear in the middle of strong trends and resolve in the same direction.',
          },
          concept: 'doji',
        ),
        QuizSpec(
          'A bullish candle with a very long upper wick suggests what happened?',
          [
            'Buyers pushed price well up but could not hold most of the gain',
            'Buyers were in complete control throughout',
            'The candle must be a data error',
            'Sellers never appeared',
          ],
          0,
          'The wick records ground that was taken and then given back. The close still being '
              'above the open makes it bullish, but a weaker one.',
          concept: 'bullish_candle',
        ),
      ],
      facts: [
        FactSpec(
          'A candle is bullish if it closed higher than the previous candle.',
          false,
          'Bullish or bearish is decided within one candle, comparing its own close with its own '
              'open.',
          concept: 'bullish_candle',
        ),
        FactSpec(
          'In this app, bullish and bearish candles differ by shape as well as by colour.',
          true,
          'Meaning never depends on colour alone, so the charts stay readable for anyone who '
              'sees colour differently.',
          concept: 'bearish_candle',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.tapLargestBody, ChartPattern.uptrend, 20201),
      ],
    ),
    LessonSpec(
      title: 'Bodies and Wicks',
      subtitle: 'Where price went versus where it settled',
      minutes: 5,
      intro:
          'The body says where the period settled. The wicks say where it travelled and was '
          'rejected. Reading both together is most of candle reading.',
      concepts: [
        ConceptSpec(
          'Body',
          'The filled or hollow block between open and close.',
          'A long body means the period finished a long way from where it started — one side '
              'stayed in control. A short body means the two sides finished close to level.',
        ),
        ConceptSpec(
          'Wick',
          'The thin line extending beyond the body to the high or the low.',
          'A wick marks price that was reached and then given back. A long upper wick shows '
              'buyers being pushed back; a long lower wick shows sellers being pushed back.',
          bullets: [
            'Upper wick = high minus the top of the body.',
            'Lower wick = bottom of the body minus the low.',
          ],
        ),
        ConceptSpec(
          'Range',
          'The full distance from the low to the high.',
          'Range measures total movement including wicks. A candle can have a tiny body and a '
              'huge range, which usually means a violent period that resolved nowhere.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A candle has a small body and very long wicks on both sides. What does that describe?',
          [
            'A period of large movement that finished near where it started',
            'A quiet period with little trading',
            'A strong trending period',
            'A data error',
          ],
          0,
          'Both sides pushed hard and neither held the ground. Large range, minimal net progress.',
          concept: 'range',
        ),
        QuizSpec(
          'Which candle shows one side most firmly in control of its period?',
          [
            'A long body with almost no wicks',
            'A long upper wick and a small body',
            'A doji',
            'A long lower wick and a small body',
          ],
          0,
          'A long body with minimal wicks means price moved and stayed moved — no meaningful '
              'pushback.',
          concept: 'body',
        ),
        QuizSpec(
          'A long lower wick means:',
          [
            'Price fell during the period and then recovered before the close',
            'Price fell and stayed down',
            'The candle must be bearish',
            'Volume was unusually low',
          ],
          0,
          'The wick maps ground given back. A long lower wick shows a fall that was bought back '
              'before the period ended.',
          concept: 'wick',
        ),
      ],
      facts: [
        FactSpec(
          'A candle with a large range always has a large body.',
          false,
          'Range includes the wicks. A candle can travel a long way and still close near its open.',
          concept: 'range',
        ),
        FactSpec(
          'A wick shows a price level that was reached and then rejected before the close.',
          true,
          'That is exactly what a wick records.',
          concept: 'wick',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.tapWidestRange,
          ChartPattern.choppyVolatile,
          20301,
        ),
        ChartTaskSpec(ChartTask.tapLargestBody, ChartPattern.breakoutUp, 20302),
      ],
    ),
    LessonSpec(
      title: 'What a Candle Hides',
      subtitle: 'The path is missing',
      minutes: 4,
      intro:
          'Candles compress. Four numbers cannot describe everything that happened in an hour, '
          'and knowing exactly what is missing prevents a lot of bad reasoning later.',
      concepts: [
        ConceptSpec(
          'Path ambiguity',
          'A candle does not record the order in which its high and low were reached.',
          'A candle that touched both 108 and 96 might have gone up first or down first. You '
              'cannot tell from the candle. This matters enormously when a stop and a target both '
              'sit inside one candle — which is why the simulator in this app applies an explicit '
              'conservative rule for that case.',
        ),
        ConceptSpec(
          'Compression',
          'Higher timeframes hide detail that lower timeframes show.',
          'One daily candle can contain twenty-four hourly candles worth of structure. Neither '
              'view is wrong; they answer different questions.',
        ),
        ConceptSpec(
          'Volume',
          'How much was traded during the period.',
          'Volume is a separate series shown beneath the candles. It adds context about '
              'participation, but like everything else it describes the past.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A single candle contains both your stop and your target. What can you conclude?',
          [
            'Nothing from that candle alone — the order is unknown',
            'The target was hit first',
            'The stop was hit first',
            'Both were hit, so they cancel out',
          ],
          0,
          'The candle does not record sequence. This app resolves it conservatively by assuming '
              'the stop was reached first, so simulated results never flatter you.',
          concept: 'path_ambiguity',
        ),
        QuizSpec(
          'How would you find out what actually happened inside one hourly candle?',
          [
            'Look at a lower timeframe covering the same hour',
            'Look at a higher timeframe',
            'Check the volume bar',
            'It cannot be recovered',
          ],
          0,
          'Lower timeframes decompose the same period into more candles, revealing the path.',
          concept: 'compression',
        ),
        QuizSpec(
          'What does volume add to a chart?',
          [
            'Context about how much trading happened in each period',
            'A prediction of the next move',
            'Confirmation that a pattern will work',
            'The number of traders participating',
          ],
          0,
          'Volume measures activity. It is context, not confirmation, and it describes the past '
              'like everything else on the chart.',
          concept: 'volume',
        ),
      ],
      facts: [
        FactSpec(
          'You can always tell from a candle whether its high or its low came first.',
          false,
          'That information is not stored in a candle. Only a lower timeframe can show it.',
          concept: 'path_ambiguity',
        ),
        FactSpec(
          'A daily candle and the hourly candles inside it describe the same trading.',
          true,
          'They are the same data at different resolutions.',
          concept: 'compression',
        ),
      ],
    ),
    LessonSpec(
      title: 'Strong and Weak Candles',
      subtitle: 'Relative, not absolute',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'There is no fixed size that makes a candle "big". Strength is always relative to what '
          'the same instrument has been doing recently.',
      concepts: [
        ConceptSpec(
          'Relative size',
          'A candle is large or small compared with its recent neighbours.',
          'A 200-point candle is enormous on one instrument and unremarkable on another. Compare '
              'each candle with the last twenty on the same chart, never with a number you '
              'remember from elsewhere.',
        ),
        ConceptSpec(
          'Displacement',
          'A candle or short run that covers much more ground than recent candles.',
          'Displacement shows a sudden change in urgency. It is a description of what happened, '
              'and later worlds use it as one input among several — never on its own.',
        ),
        ConceptSpec(
          'Indecision',
          'A run of small-bodied candles with overlapping ranges.',
          'When candles overlap heavily and bodies shrink, neither side is making progress. '
              'These stretches are where most unnecessary trades get taken.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'How do you judge whether a candle is unusually large?',
          [
            'Compare it with the recent candles on the same chart',
            'Compare it with a fixed point value',
            'Compare it with the same instrument a year ago',
            'By how it looks on screen',
          ],
          0,
          'Only local context makes size meaningful. Screen appearance depends on scaling, and '
              'absolute numbers depend on the instrument.',
          concept: 'relative_size',
        ),
        QuizSpec(
          'What does a stretch of small overlapping candles usually indicate?',
          [
            'Neither side is making progress',
            'A reversal is imminent',
            'Volume has stopped',
            'The trend is accelerating',
          ],
          0,
          'Overlapping ranges and shrinking bodies mean a balanced fight, not a signal.',
          concept: 'indecision',
        ),
        QuizSpec(
          'Displacement is best described as:',
          [
            'A sudden expansion in how far price travels per candle',
            'A guaranteed continuation signal',
            'A gap between two candles',
            'A reversal pattern',
          ],
          0,
          'It describes an expansion of movement. What follows it is still unknown.',
          concept: 'displacement',
        ),
      ],
      facts: [
        FactSpec(
          'A candle of a given point size means the same thing on every instrument.',
          false,
          'Instruments differ in typical range. Size only means something relative to the same '
              'chart.',
          concept: 'relative_size',
        ),
        FactSpec(
          'Displacement describes what has already happened rather than what comes next.',
          true,
          'Like every other reading in this app, it is descriptive.',
          concept: 'displacement',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.tapLargestBody,
          ChartPattern.fairValueGapUp,
          20501,
        ),
        ChartTaskSpec(
          ChartTask.tapWidestRange,
          ChartPattern.liquiditySweepHigh,
          20502,
        ),
      ],
    ),
    LessonSpec(
      title: 'Reading a Sequence',
      subtitle: 'Candles in context',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'One candle in isolation says very little. A run of them starts to say something, '
          'because you can see what each one did relative to the last.',
      concepts: [
        ConceptSpec(
          'Sequence',
          'A run of consecutive candles read together.',
          'Are closes progressing in one direction? Are ranges expanding or contracting? Are '
              'wicks appearing consistently on one side? Those questions need several candles.',
        ),
        ConceptSpec(
          'Overlap',
          'How much two consecutive candles share the same price area.',
          'Heavy overlap means slow, contested movement. Little overlap means one side is '
              'carrying price without much resistance.',
        ),
        ConceptSpec(
          'Consistent rejection',
          'Repeated wicks appearing on the same side across several candles.',
          'Several candles in a row with long upper wicks say sellers keep answering at a '
              'similar area. That is an observation worth noting — it is not a prediction that '
              'they will keep doing so.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Four candles in a row each have long upper wicks around the same price. What is the '
              'honest reading?',
          [
            'Sellers have repeatedly answered near that area',
            'Price will definitely fall from there',
            'That area can never be broken',
            'Buyers have given up',
          ],
          0,
          'Repeated rejection is a description of what happened. Areas like this get broken '
              'regularly.',
          optionFeedback: {
            1: 'Repetition raises attention, never certainty.',
            2: 'Every level that has ever held has eventually failed at some point.',
          },
          concept: 'consistent_rejection',
        ),
        QuizSpec(
          'Consecutive candles that barely overlap suggest:',
          [
            'One side is moving price with little resistance',
            'The market is quiet',
            'A reversal is forming',
            'Volume has dried up',
          ],
          0,
          'Low overlap means each period picks up where the last left off, which is what a '
              'strong directional run looks like.',
          concept: 'overlap',
        ),
        QuizSpec(
          'Why is one candle rarely enough to act on?',
          [
            'It has no context to be compared against',
            'Candles are unreliable data',
            'One candle is always noise',
            'Platforms draw the first candle inaccurately',
          ],
          0,
          'Meaning comes from comparison. Without neighbours there is nothing to compare to.',
          concept: 'sequence',
        ),
      ],
      facts: [
        FactSpec(
          'Heavy overlap between consecutive candles indicates contested, slow movement.',
          true,
          'Both sides are trading in the same area repeatedly.',
          concept: 'overlap',
        ),
        FactSpec(
          'Repeated rejection at an area guarantees that area will hold again.',
          false,
          'It raises attention. Every area eventually fails.',
          concept: 'consistent_rejection',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.uptrend, 20601),
        ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.range, 20602),
      ],
    ),
    LessonSpec(
      title: 'Timeframes and Candles',
      subtitle: 'The same data, grouped differently',
      minutes: 4,
      difficulty: Difficulty.intermediate,
      intro:
          'Changing timeframe regroups identical trades into different candles. Understanding '
          'the arithmetic keeps you from thinking the chart changed.',
      concepts: [
        ConceptSpec(
          'Aggregation',
          'How several smaller candles combine into one larger one.',
          'The larger candle takes the open of the first, the close of the last, the highest '
              'high and the lowest low. Nothing is invented; detail is simply dropped.',
        ),
        ConceptSpec(
          'Closing candle',
          'A candle that has finished forming.',
          'The rightmost candle is usually still forming and its close will change. Decisions '
              'made on an unfinished candle are made on incomplete information.',
        ),
        ConceptSpec(
          'Multi-timeframe reading',
          'Using a higher timeframe for context and a lower one for detail.',
          'The higher timeframe tells you what the larger structure is doing; the lower one '
              'shows how it is unfolding. Conflicts between them are normal, not errors.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Four 15-minute candles combine into one hourly candle. What is the hourly high?',
          [
            'The highest high among the four',
            'The high of the last of the four',
            'The average of the four highs',
            'The high of the first of the four',
          ],
          0,
          'Aggregation takes the extreme values across the whole group.',
          concept: 'aggregation',
        ),
        QuizSpec(
          'Why is the rightmost candle treated with caution?',
          [
            'It is still forming, so its close is not final',
            'It is always inaccurate',
            'It is drawn from different data',
            'It has no volume yet',
          ],
          0,
          'An unfinished candle can change completely before it closes.',
          concept: 'closing_candle',
        ),
        QuizSpec(
          'The hourly chart looks bullish and the 5-minute looks bearish. What is going on?',
          [
            'A pullback within a larger up move — both readings can be true',
            'One chart has bad data',
            'The bullish reading must be wrong',
            'Timeframes should never disagree',
          ],
          0,
          'Different timeframes answer different questions. Short-term weakness inside a longer '
              'up move is the most ordinary thing on a chart.',
          concept: 'multi_timeframe_reading',
        ),
      ],
      facts: [
        FactSpec(
          'A one-hour candle opens at the open of the first 15-minute candle in that hour.',
          true,
          'Open comes from the first candle and close from the last.',
          concept: 'aggregation',
        ),
        FactSpec(
          'Timeframes disagreeing means one of them is wrong.',
          false,
          'They describe different scales. Disagreement is information, not error.',
          concept: 'multi_timeframe_reading',
        ),
      ],
    ),
    LessonSpec(
      title: 'Candles Around Gaps',
      subtitle: 'When price skips',
      minutes: 4,
      difficulty: Difficulty.intermediate,
      intro:
          'Sometimes price jumps without trading in between. Gaps look dramatic and are worth '
          'understanding, but they are not signals in themselves.',
      concepts: [
        ConceptSpec(
          'Gap',
          'A jump between one candle\'s close and the next candle\'s open with no trading between.',
          'Gaps mainly occur where a market closes and reopens. During the closed period, news '
              'arrives and opinions change, so trading restarts at a different level.',
        ),
        ConceptSpec(
          'Continuous market',
          'A market that never closes, so gaps are rare.',
          'Crypto trades around the clock. Price still moves quickly, but it usually trades '
              'through each level rather than skipping it.',
        ),
        ConceptSpec(
          'Imbalance',
          'An area price crossed rapidly with little two-sided trading.',
          'Even in continuous markets, price sometimes moves through an area so quickly that '
              'almost no trading happens there. World 11 looks at how some frameworks mark these '
              'areas out.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Why are gaps common in stocks and rare in crypto?',
          [
            'Stock exchanges close overnight; crypto trades continuously',
            'Stock data is less accurate',
            'Crypto charts remove gaps automatically',
            'Stocks are more volatile',
          ],
          0,
          'A gap needs a period with no trading. Continuous markets barely provide one.',
          concept: 'gap',
        ),
        QuizSpec(
          'What does a gap tell you about what happens next?',
          [
            'Nothing reliable on its own',
            'That it will be filled',
            'That the trend will continue',
            'That the move is exhausted',
          ],
          0,
          '"Gaps always fill" is a saying, not a rule. Plenty never do.',
          optionFeedback: {
            1: 'Many gaps do close eventually, but "eventually" is not a tradeable statement.',
          },
          concept: 'gap',
        ),
        QuizSpec(
          'An imbalance in a continuous market is:',
          [
            'An area price crossed quickly with very little two-sided trading',
            'The same thing as a gap',
            'A broker error',
            'A guaranteed reversal area',
          ],
          0,
          'It is a rapid one-sided pass through an area, not a true break in trading.',
          concept: 'imbalance',
        ),
      ],
      facts: [
        FactSpec(
          'All gaps eventually get filled.',
          false,
          'A common saying with plenty of counter-examples. It is not something to rely on.',
          concept: 'gap',
        ),
        FactSpec(
          'A gap requires a period during which no trading took place.',
          true,
          'That is the definition — which is why closed markets produce them.',
          concept: 'continuous_market',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.selectFairValueGapUp,
          ChartPattern.fairValueGapUp,
          20801,
        ),
      ],
    ),
    LessonSpec(
      title: 'Common Candle Mistakes',
      subtitle: 'How candle reading goes wrong',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'Most candle mistakes come from asking a single candle to carry more meaning than four '
          'numbers can hold.',
      concepts: [
        ConceptSpec(
          'Over-reading',
          'Treating one candle as a complete signal.',
          'A hammer, an engulfing candle, a doji — none of these mean anything reliable without '
              'the surrounding structure. They are starting points for a question, not answers.',
        ),
        ConceptSpec(
          'Colour dependence',
          'Deciding based on colour rather than on the actual values.',
          'Colour is a convenience. Two green candles can describe completely different periods. '
              'Read open, close and wicks.',
        ),
        ConceptSpec(
          'Ignoring context',
          'Reading a candle without asking where it sits in the larger picture.',
          'The same candle at the top of an extended run and in the middle of a range means '
              'different things. Location is part of the reading.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Someone says "this is a bullish engulfing candle, so it is going up". What is wrong?',
          [
            'A single candle pattern does not carry a reliable outcome',
            'Bullish engulfing candles are actually bearish',
            'They should have waited for two candles',
            'Nothing — that is a valid read',
          ],
          0,
          'Candle patterns describe what happened in a period. Attaching a certain outcome to '
              'them is exactly the over-reading this lesson is about.',
          concept: 'over_reading',
          mistake: MistakeTag.impulsiveTrade,
        ),
        QuizSpec(
          'Why is context part of reading a candle?',
          [
            'The same candle means different things in different locations',
            'Charts render candles differently in different places',
            'Context changes the candle values',
            'It does not; candles are self-contained',
          ],
          0,
          'A long lower wick after an extended fall and the same wick mid-range are not the same '
              'observation.',
          concept: 'ignoring_context',
        ),
        QuizSpec(
          'What is the problem with reading candles by colour alone?',
          [
            'Colour omits the size, the wicks and the location',
            'Colours vary between platforms',
            'Colour is not accurate',
            'There is no problem',
          ],
          0,
          'Colour reduces four numbers plus context down to one bit of information.',
          concept: 'colour_dependence',
        ),
      ],
      facts: [
        FactSpec(
          'A single candle pattern is enough to justify a trade on its own.',
          false,
          'Structure, location and risk still have to be established. One candle is a starting '
              'point at best.',
          concept: 'over_reading',
        ),
        FactSpec(
          'The same candle shape can mean different things depending on where it appears.',
          true,
          'Location is part of the reading, not an optional extra.',
          concept: 'ignoring_context',
        ),
      ],
      extras: [
        SpotMistakeSpec(
          'A trader sees one green candle with a long lower wick after a long fall and writes: '
              '"Reversal confirmed. Going long with a stop just under the candle body."',
          [
            'One candle is being treated as confirmation of a reversal',
            'The stop should be wider than the whole candle',
            'They should have gone short instead',
            'Long lower wicks are meaningless',
          ],
          0,
          MistakeTag.impulsiveTrade,
          'The wick is a real observation — sellers were pushed back. But "reversal confirmed" '
              'from a single candle skips every question about structure and invalidation. Note '
              'also that a stop under the body, rather than under the wick, sits inside the '
              'range price just traded through.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Candle Practice',
      subtitle: 'Putting the whole world together',
      minutes: 6,
      difficulty: Difficulty.intermediate,
      intro:
          'A working session across everything in this world: the four prices, bodies, wicks, '
          'relative size and sequence.',
      concepts: [
        ConceptSpec(
          'Reading routine',
          'A repeatable order of questions to ask of any candle.',
          'Where did it close relative to its open? How big is it compared with its neighbours? '
              'Where are the wicks? Where does it sit in the sequence? Four questions, always in '
              'the same order.',
        ),
        ConceptSpec(
          'Description before conclusion',
          'Say what happened before deciding what it means.',
          'Describing first — "closed near the high, small lower wick, largest body in twenty '
              'candles" — keeps interpretation anchored to what is actually on screen.',
        ),
        ConceptSpec(
          'Honest language',
          'Phrasing readings as observations rather than forecasts.',
          '"Sellers answered at this area twice" is honest. "Price will reverse here" is not. '
              'The habit matters because the words you use shape how confident you feel.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Which phrasing is honest about a chart?',
          [
            '"Price has been rejected from this area twice"',
            '"Price will reverse from this area"',
            '"This area cannot break"',
            '"This is a guaranteed short"',
          ],
          0,
          'The first describes what happened. The rest claim knowledge about what has not '
              'happened yet.',
          concept: 'honest_language',
        ),
        QuizSpec(
          'What should come first when reading a candle?',
          [
            'Describing what it actually did',
            'Deciding whether to buy or sell',
            'Checking the indicator',
            'Looking at the next candle',
          ],
          0,
          'Description before conclusion keeps the reading tied to the chart.',
          concept: 'description_before_conclusion',
        ),
        QuizSpec(
          'A candle closes at its high with the largest body of the last thirty. The honest '
              'reading is:',
          [
            'Buyers controlled this period more firmly than any recent period',
            'The next candle will be bullish',
            'A top is forming',
            'Volume must have been high',
          ],
          0,
          'Everything else listed is an inference about something the candle does not contain.',
          concept: 'reading_routine',
        ),
      ],
      facts: [
        FactSpec(
          'Describing a candle before interpreting it reduces the chance of inventing a story.',
          true,
          'Description anchors interpretation to what is visible.',
          concept: 'description_before_conclusion',
        ),
        FactSpec(
          'Saying "price will reverse here" is an honest way to describe resistance.',
          false,
          '"Has been rejected here before" is honest. The forecast version is not.',
          concept: 'honest_language',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.tapHigh, ChartPattern.uptrendPullback, 21001),
        ChartTaskSpec(ChartTask.tapLow, ChartPattern.supportTest, 21002),
        ChartTaskSpec(
          ChartTask.tapLargestBody,
          ChartPattern.breakoutDown,
          21003,
        ),
      ],
    ),
  ],
  boss: BossSpec(
    title: 'Candlestick Challenge',
    subtitle: 'Read the bars without inventing a story',
    difficulty: Difficulty.intermediate,
    minutes: 8,
    intro: 'Chart work plus theory from the whole world. Score 80% to unlock Market Structure.',
    charts: [
      ChartTaskSpec(ChartTask.tapHigh, ChartPattern.uptrend, 29001),
      ChartTaskSpec(ChartTask.tapLow, ChartPattern.downtrend, 29002),
      ChartTaskSpec(ChartTask.tapLargestBody, ChartPattern.breakoutUp, 29003),
      ChartTaskSpec(
        ChartTask.tapWidestRange,
        ChartPattern.choppyVolatile,
        29004,
      ),
      ChartTaskSpec(ChartTask.tapClose, ChartPattern.range, 29005),
    ],
    quizzes: [
      QuizSpec(
        'A candle opens 100, high 112, low 99, closes 101. Which description is right?',
        [
          'Bullish, with a long upper wick showing rejection higher up',
          'Bearish, because it nearly closed at its open',
          'Bullish, with buyers in firm control throughout',
          'A doji',
        ],
        0,
        'Close above open makes it bullish, but the 11-point upper wick against a 1-point body '
            'says almost all the gain was given back.',
        concept: 'bullish_candle',
      ),
      QuizSpec(
        'What does a candle never tell you?',
        [
          'Whether the high or the low came first',
          'The highest price traded',
          'Where the period closed',
          'The full range of the period',
        ],
        0,
        'Sequence is the one thing the four values cannot encode.',
        concept: 'path_ambiguity',
      ),
      QuizSpec(
        'How is a candle judged large or small?',
        [
          'Relative to recent candles on the same chart',
          'Against a fixed number of points',
          'By its colour',
          'By how it looks on screen',
        ],
        0,
        'Local context is the only meaningful comparison.',
        concept: 'relative_size',
      ),
      QuizSpec(
        'Which is the honest reading of three consecutive long upper wicks at one area?',
        [
          'Sellers have answered repeatedly around that area',
          'That area will hold',
          'Price must fall from here',
          'Buyers have given up permanently',
        ],
        0,
        'Repetition is an observation. It never becomes a guarantee.',
        concept: 'consistent_rejection',
      ),
    ],
    facts: [
      FactSpec(
        'The body of a candle spans its open and its close.',
        true,
        'The wicks then extend from the body out to the high and the low.',
        concept: 'body',
      ),
      FactSpec(
        'A doji reliably signals that a trend is ending.',
        false,
        'A doji reports indecision in one period. Trends contain many of them.',
        concept: 'doji',
      ),
    ],
  ),
);
