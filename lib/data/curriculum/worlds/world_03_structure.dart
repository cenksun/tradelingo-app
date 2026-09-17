import '../../../domain/models/enums.dart';
import '../../../domain/models/skill.dart';
import '../lesson_spec.dart';

/// World 3 — Market Structure. The vocabulary the rest of the app depends on.
const WorldSpec world03Structure = WorldSpec(
  id: 'w03',
  index: 3,
  title: 'Market Structure',
  subtitle: 'Swings, and the sequences they make',
  description:
      'Swing highs and swing lows, and the four labels — HH, HL, LH, LL — that describe how they '
      'follow one another.',
  primarySkillId: Skills.marketStructure,
  accentColor: 0xFF7C5CFF,
  lessons: [
    LessonSpec(
      title: 'Swing Highs and Swing Lows',
      subtitle: 'Turning points',
      minutes: 5,
      intro:
          'Structure starts with turning points. Before any labels, you need to be able to point '
          'at where price turned.',
      concepts: [
        ConceptSpec(
          'Swing high',
          'A candle whose high stands above the candles either side of it.',
          'A swing high is where an advance stopped. It is a local peak, confirmed only once '
              'price has pulled away from it — which means the most recent one is always '
              'provisional.',
        ),
        ConceptSpec(
          'Swing low',
          'A candle whose low sits below the candles either side of it.',
          'A swing low is where a decline stopped. Same logic in reverse, and the same caveat '
              'about the most recent one.',
        ),
        ConceptSpec(
          'Confirmation lag',
          'A swing point is only identifiable after price has moved away from it.',
          'You never know in the moment that you are looking at the high. This lag is a real '
              'constraint, not a flaw in the method, and it is why structure-based decisions are '
              'always slightly late by design.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Why can you not identify a swing high as it forms?',
          [
            'It is only a swing high once price moves away and leaves it behind',
            'Charting software updates slowly',
            'Swing highs only exist on daily charts',
            'You can, if the candle is large enough',
          ],
          0,
          'The definition requires lower highs on both sides. The right-hand side does not exist '
              'yet while the candle is forming.',
          concept: 'confirmation_lag',
        ),
        QuizSpec(
          'A swing low is:',
          [
            'A local turning point where a decline stopped',
            'The lowest price of the day',
            'Any red candle',
            'The bottom of the chart',
          ],
          0,
          'It is local, defined by its neighbours, and has nothing to do with the edge of the '
              'screen.',
          concept: 'swing_low',
        ),
        QuizSpec(
          'What does confirmation lag mean in practice?',
          [
            'Structure-based decisions are always made after the turn, not at it',
            'Your platform is delayed',
            'You should trade smaller',
            'Swings should be ignored',
          ],
          0,
          'Accepting that you act after the turn — rather than trying to catch it — is part of '
              'using structure honestly.',
          concept: 'confirmation_lag',
        ),
      ],
      facts: [
        FactSpec(
          'The most recent swing point on a chart is always provisional.',
          true,
          'Price can still extend past it, which would erase it as a turning point.',
          concept: 'confirmation_lag',
        ),
        FactSpec(
          'A swing high must be the highest point on the whole chart.',
          false,
          'Swing points are local. A chart contains many of them.',
          concept: 'swing_high',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.tapSwingHigh, ChartPattern.uptrend, 30101),
        ChartTaskSpec(ChartTask.tapSwingLow, ChartPattern.uptrend, 30102),
      ],
    ),
    LessonSpec(
      title: 'Higher Highs',
      subtitle: 'The first of four labels',
      minutes: 5,
      intro:
          'A label is always a comparison with the previous swing of the same kind. Start with '
          'highs compared to highs.',
      concepts: [
        ConceptSpec(
          'Higher high',
          'A swing high above the previous swing high.',
          'HH means the advance reached further than the last one did. Note what it does not '
              'mean: it says nothing about lows, and nothing about what happens next.',
        ),
        ConceptSpec(
          'Comparison rule',
          'Highs are only ever compared with highs, lows only with lows.',
          'This is the single rule that makes structure labelling unambiguous. Comparing a high '
              'with a low produces nonsense.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A swing high forms at 110. The previous swing high was 104. What is it?',
          [
            'A higher high',
            'A lower high',
            'A higher low',
            'It depends on the lows',
          ],
          0,
          '110 is above 104 and both are swing highs, so it is a higher high. The lows are a '
              'separate question.',
          concept: 'higherHigh',
        ),
        QuizSpec(
          'Which comparison is valid when labelling structure?',
          [
            'This swing high against the previous swing high',
            'This swing high against the previous swing low',
            'This swing high against the opening price',
            'This swing high against yesterday\'s close',
          ],
          0,
          'Like with like. Every other comparison produces a label that means nothing.',
          concept: 'comparison_rule',
        ),
        QuizSpec(
          'A higher high tells you:',
          [
            'The last advance went further than the one before it',
            'The trend will continue',
            'Lows are also rising',
            'It is safe to buy',
          ],
          0,
          'It is one comparison between two points. The rest requires looking at the lows too.',
          concept: 'higherHigh',
        ),
      ],
      facts: [
        FactSpec(
          'A higher high on its own confirms an uptrend.',
          false,
          'Structure needs both highs and lows. A higher high with a lower low is not an uptrend.',
          concept: 'higherHigh',
        ),
        FactSpec(
          'Labels come from comparing a swing with the previous swing of the same type.',
          true,
          'That comparison is the entire definition.',
          concept: 'comparison_rule',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.identifyHigherHigh,
          ChartPattern.uptrend,
          30201,
        ),
        ChartTaskSpec(
          ChartTask.identifyHigherHigh,
          ChartPattern.breakoutUp,
          30202,
        ),
      ],
    ),
    LessonSpec(
      title: 'Higher Lows',
      subtitle: 'Where pullbacks stop',
      minutes: 5,
      intro:
          'Higher lows are what separate an advance that is holding its ground from one that is '
          'giving it back.',
      concepts: [
        ConceptSpec(
          'Higher low',
          'A swing low above the previous swing low.',
          'HL means the pullback stopped higher than the last one did. Buyers stepped in sooner. '
              'Together with higher highs, this is what the framework calls bullish structure.',
        ),
        ConceptSpec(
          'Pullback',
          'A move against the prevailing direction that does not reverse it.',
          'A pullback is where higher lows form. Deciding whether a move is a pullback or the '
              'start of a reversal is one of the genuinely hard judgements in trading, and it is '
              'rarely obvious at the time.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A swing low forms at 96. The previous swing low was 92. What is it?',
          ['A higher low', 'A lower low', 'A higher high', 'Not a swing point'],
          0,
          '96 is above 92 and both are swing lows, so it is a higher low.',
          concept: 'higherLow',
        ),
        QuizSpec(
          'What does a higher low describe?',
          [
            'The most recent pullback stopped above where the last one stopped',
            'Price made a new high',
            'The trend has reversed',
            'Volume increased on the pullback',
          ],
          0,
          'It is purely a comparison of where two declines stopped.',
          concept: 'higherLow',
        ),
        QuizSpec(
          'When can you be sure a move is a pullback rather than a reversal?',
          [
            'Only afterwards — at the time it is a judgement under uncertainty',
            'When it retraces less than half the prior move',
            'When volume is lower',
            'When it lasts fewer than five candles',
          ],
          0,
          'Every rule of thumb here has plenty of exceptions. Rules like "less than 50%" are '
              'conventions, not facts.',
          optionFeedback: {
            1: 'Deep pullbacks resolve in the original direction all the time.',
          },
          concept: 'pullback',
        ),
      ],
      facts: [
        FactSpec(
          'Higher highs together with higher lows is what this framework calls bullish structure.',
          true,
          'Higher highs say each advance reaches further; higher lows say each pullback '
              'stops higher. Only together do they describe an uptrend.',
          concept: 'higherLow',
        ),
        FactSpec(
          'A pullback can be identified with certainty while it is happening.',
          false,
          'At the time, a pullback and the start of a reversal look identical.',
          concept: 'pullback',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.identifyHigherLow, ChartPattern.uptrend, 30301),
        ChartTaskSpec(
          ChartTask.identifyHigherLow,
          ChartPattern.uptrendPullback,
          30302,
        ),
      ],
    ),
    LessonSpec(
      title: 'Lower Highs',
      subtitle: 'Rallies that fall short',
      minutes: 5,
      intro:
          'The mirror of a higher low. A lower high says the last rally gave up earlier than the '
          'one before it.',
      concepts: [
        ConceptSpec(
          'Lower high',
          'A swing high below the previous swing high.',
          'LH means the recovery stopped short of where the last one reached. Sellers answered '
              'earlier. It is the most commonly mislabelled point on a chart, because a lower '
              'high can still be well above recent prices and therefore "feel" high.',
        ),
        ConceptSpec(
          'Relief rally',
          'A rise inside a falling structure.',
          'Rallies happen constantly during declines. A lower high is simply where one of them '
              'ran out. Mistaking a relief rally for a reversal is one of the classic errors.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A swing high forms at 88. The previous swing high was 95. What is it?',
          ['A lower high', 'A higher high', 'A lower low', 'A range high'],
          0,
          '88 is below 95 and both are swing highs, so it is a lower high — regardless of how '
              'far above the recent lows 88 might be.',
          concept: 'lowerHigh',
        ),
        QuizSpec(
          'Why do people often mislabel a lower high?',
          [
            'It can sit well above recent prices and feel like a strong high',
            'It only appears on lower timeframes',
            'Charting software marks it incorrectly',
            'It is identical to a higher low',
          ],
          0,
          'The label is a comparison with the previous high, not with where price has been most '
              'recently. Intuition pulls the other way.',
          concept: 'lowerHigh',
          mistake: MistakeTag.structureMisread,
        ),
        QuizSpec(
          'A sharp rally inside an ongoing decline is best described as:',
          [
            'A move that may or may not become a reversal — unknown at the time',
            'A confirmed reversal',
            'A guaranteed lower high',
            'Meaningless noise',
          ],
          0,
          'Only the following swings will tell you which it was. In the moment it is genuinely '
              'ambiguous.',
          concept: 'relief_rally',
        ),
      ],
      facts: [
        FactSpec(
          'A lower high can still be much higher than the most recent prices on the chart.',
          true,
          'The label compares it with the previous swing high, nothing else.',
          concept: 'lowerHigh',
        ),
        FactSpec(
          'Rallies do not occur during downtrends.',
          false,
          'They occur constantly. Lower highs are what they leave behind.',
          concept: 'relief_rally',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.identifyLowerHigh,
          ChartPattern.downtrend,
          30401,
        ),
        ChartTaskSpec(
          ChartTask.identifyLowerHigh,
          ChartPattern.downtrendPullback,
          30402,
        ),
      ],
    ),
    LessonSpec(
      title: 'Lower Lows',
      subtitle: 'Completing the set',
      minutes: 5,
      intro: 'The fourth label. With this you can describe any sequence of swings on any chart.',
      concepts: [
        ConceptSpec(
          'Lower low',
          'A swing low below the previous swing low.',
          'LL means the decline reached further than the last one. With lower highs alongside '
              'it, the framework calls this bearish structure.',
        ),
        ConceptSpec(
          'Bearish structure',
          'A sequence of lower highs and lower lows.',
          'Both parts matter. Lower lows with higher highs is not bearish structure — it is an '
              'expanding, unstable pattern that is usually best left alone.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A chart shows lower highs and lower lows. How does the framework describe it?',
          ['Bearish structure', 'Bullish structure', 'A range', 'Undefined'],
          0,
          'Both series stepping down is the definition of bearish structure in this framework.',
          concept: 'bearish_structure',
        ),
        QuizSpec(
          'A chart shows higher highs and lower lows at the same time. What is that?',
          [
            'An expanding, unstable pattern that fits neither trend definition',
            'Bullish structure',
            'Bearish structure',
            'Impossible',
          ],
          0,
          'Each swing goes further in both directions. It is a real pattern, it is just not a '
              'trend — and it is a difficult one to trade.',
          concept: 'bearish_structure',
        ),
        QuizSpec(
          'A swing low at 74 follows a previous swing low at 81. What is it?',
          ['A lower low', 'A higher low', 'A lower high', 'A range low'],
          0,
          '74 is below 81 and both are swing lows.',
          concept: 'lowerLow',
        ),
      ],
      facts: [
        FactSpec(
          'Bearish structure requires both lower highs and lower lows.',
          true,
          'One without the other is not a trend by this definition.',
          concept: 'bearish_structure',
        ),
        FactSpec(
          'Lower lows guarantee that price will keep falling.',
          false,
          'They describe what has happened. Every downtrend in history ended while still making '
              'lower lows right up until it did not.',
          concept: 'lowerLow',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.identifyLowerLow,
          ChartPattern.downtrend,
          30501,
        ),
        ChartTaskSpec(
          ChartTask.identifyLowerLow,
          ChartPattern.breakoutDown,
          30502,
        ),
      ],
    ),
    LessonSpec(
      title: 'Labelling a Whole Sequence',
      subtitle: 'All four labels at once',
      minutes: 6,
      difficulty: Difficulty.intermediate,
      intro:
          'Individually the labels are easy. The skill is applying them consistently across a '
          'chart without letting the overall impression override the comparisons.',
      concepts: [
        ConceptSpec(
          'Sequence labelling',
          'Walking left to right, labelling each swing against the previous one of its type.',
          'Work in order. Keep two running values in mind — the last high and the last low — and '
              'compare each new swing against the matching one. Never skip ahead.',
        ),
        ConceptSpec(
          'Mixed structure',
          'A sequence where the labels do not form a consistent pattern.',
          'Real charts produce mixed sequences constantly: HH, HL, LH, LL, HH. That is not a '
              'failure to read it correctly — it is what an unclear market looks like.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'When labelling left to right, what do you compare each new swing high against?',
          [
            'The previous swing high',
            'The previous swing low',
            'The highest point on the chart',
            'The first candle',
          ],
          0,
          'Always the previous swing of the same type.',
          concept: 'sequence_labelling',
        ),
        QuizSpec(
          'You label a sequence HH, HL, LH, LL. What does that describe?',
          [
            'A bullish phase that shifted into a bearish one',
            'A clean uptrend',
            'A labelling error',
            'A range',
          ],
          0,
          'The first pair is bullish, the second bearish. Transitions like this are exactly what '
              'World 11 examines under the name change of character.',
          concept: 'mixed_structure',
        ),
        QuizSpec(
          'A chart produces a messy, inconsistent label sequence. What does that mean?',
          [
            'The market is genuinely unclear right now',
            'You have labelled it wrong',
            'The timeframe is broken',
            'A reversal is coming',
          ],
          0,
          'Unclear charts exist. Recognising one is a useful result, and usually points at a '
              'no-trade decision.',
          concept: 'mixed_structure',
        ),
      ],
      facts: [
        FactSpec(
          'Real charts frequently produce mixed label sequences.',
          true,
          'Clean textbook sequences are the exception, not the rule.',
          concept: 'mixed_structure',
        ),
        FactSpec(
          'Labelling should be done right to left, starting from the newest swing.',
          false,
          'Each label depends on what came before it, so labelling runs left to right.',
          concept: 'sequence_labelling',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.labelStructure, ChartPattern.uptrend, 30601),
        ChartTaskSpec(ChartTask.labelStructure, ChartPattern.downtrend, 30602),
      ],
    ),
    LessonSpec(
      title: 'Ranges',
      subtitle: 'When structure goes sideways',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'Not every chart trends. Markets spend a large share of their time going sideways, and '
          'recognising that early saves a lot of unnecessary trades.',
      concepts: [
        ConceptSpec(
          'Range',
          'A sideways area bounded by a high and a low that price keeps returning to.',
          'In a range, highs land at similar levels and so do lows. Neither series makes '
              'progress. The labels tend to come out as roughly equal highs and equal lows.',
        ),
        ConceptSpec(
          'Range boundary',
          'The upper or lower edge of the sideways area.',
          'Boundaries are areas, not exact lines. Price routinely pokes slightly past them and '
              'comes back, which is what makes trading range edges tricky.',
        ),
        ConceptSpec(
          'Chop',
          'A range with no clean boundaries at all.',
          'Some sideways phases have no usable structure whatsoever. There is no requirement to '
              'find a trade in them, and standing aside is usually the strongest option.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'How do the labels typically come out inside a range?',
          [
            'Roughly equal highs and roughly equal lows',
            'Consistent higher highs and higher lows',
            'Consistent lower highs and lower lows',
            'No labels can be applied',
          ],
          0,
          'Swings land at similar levels repeatedly, so neither series progresses.',
          concept: 'range',
        ),
        QuizSpec(
          'Why are range boundaries drawn as areas rather than lines?',
          [
            'Price routinely overshoots slightly and returns',
            'Charting tools are imprecise',
            'It makes them easier to see',
            'Because the range is not real',
          ],
          0,
          'Exact-line thinking leads to stops placed a few ticks beyond a level, in exactly the '
              'spot ordinary overshoot reaches.',
          concept: 'range_boundary',
        ),
        QuizSpec(
          'What is the reasonable response to a chart with no clean structure?',
          [
            'Not taking a trade',
            'Trading smaller but still trading',
            'Switching to a lower timeframe until something appears',
            'Waiting for an indicator to decide',
          ],
          0,
          'No-trade is a decision, and unclear charts are what it is for. Dropping timeframes to '
              'manufacture a setup is a common way to lose money.',
          concept: 'chop',
        ),
      ],
      facts: [
        FactSpec(
          'Markets spend a large proportion of their time in ranges rather than trends.',
          true,
          'Which is why range recognition matters as much as trend recognition.',
          concept: 'range',
        ),
        FactSpec(
          'A range boundary is an exact price that price should never cross.',
          false,
          'It is an area, and brief overshoots are normal.',
          concept: 'range_boundary',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.range, 30701),
        ChartTaskSpec(ChartTask.selectRangeHigh, ChartPattern.range, 30702),
        ChartTaskSpec(
          ChartTask.selectRangeLow,
          ChartPattern.tightConsolidation,
          30703,
        ),
      ],
    ),
    LessonSpec(
      title: 'Broken Structure',
      subtitle: 'When a sequence stops holding',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'Structure is useful mostly because it gives you a specific level that would make your '
          'reading wrong.',
      concepts: [
        ConceptSpec(
          'Invalidation level',
          'The price at which the current structural reading stops being true.',
          'In bullish structure, the most recent higher low is the level. If price trades below '
              'it, the sequence of higher lows has ended. This is the single most practical use '
              'of structure, and it is where World 7 gets its stop placement logic.',
        ),
        ConceptSpec(
          'Structure break',
          'Price trading beyond the swing that defined the current sequence.',
          'A break does not mean the opposite trend has started. It means the previous reading '
              'no longer holds and you need to relabel from that point.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'In bullish structure, which level would invalidate the reading?',
          [
            'The most recent higher low',
            'The most recent higher high',
            'The first swing low on the chart',
            'The opening price',
          ],
          0,
          'Trading below the most recent higher low ends the sequence of higher lows, which is '
              'half the definition of bullish structure.',
          concept: 'invalidation_level',
        ),
        QuizSpec(
          'Price breaks below the most recent higher low. What follows?',
          [
            'The bullish reading no longer holds and you relabel from there',
            'A downtrend has definitely begun',
            'Price will return to the break level',
            'Nothing — one break is meaningless',
          ],
          0,
          'A break ends the previous reading. What replaces it is decided by the swings that '
              'come afterwards.',
          optionFeedback: {
            1: 'A break is not the same as a confirmed new trend.',
          },
          concept: 'structure_break',
        ),
        QuizSpec(
          'Why is having an invalidation level useful?',
          [
            'It converts a reading into a specific, testable price',
            'It guarantees the trade works',
            'It removes the need for a stop',
            'It predicts the next move',
          ],
          0,
          'Without one, "I think it goes up" has no way to be proven wrong, and therefore no way '
              'to be risk-managed.',
          concept: 'invalidation_level',
        ),
      ],
      facts: [
        FactSpec(
          'A structure break confirms the opposite trend has started.',
          false,
          'It ends the previous reading. The next sequence decides what comes after.',
          concept: 'structure_break',
        ),
        FactSpec(
          'The most useful thing structure gives you is a specific level that would prove your '
              'reading wrong.',
          true,
          'That level is what makes a stop placement logical rather than arbitrary.',
          concept: 'invalidation_level',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.identifyHigherLow,
          ChartPattern.breakOfStructureUp,
          30801,
        ),
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.breakOfStructureDown,
          30802,
        ),
      ],
    ),
    LessonSpec(
      title: 'Structure Across Timeframes',
      subtitle: 'Two readings, both correct',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'A pullback on the higher timeframe is a complete downtrend on the lower one. Neither '
          'is wrong; they are answers to different questions.',
      concepts: [
        ConceptSpec(
          'Nested structure',
          'Lower timeframe structure contained inside a single higher timeframe swing.',
          'One daily pullback can contain a full sequence of lower highs and lower lows on the '
              'hourly chart. Both readings describe the same trading.',
        ),
        ConceptSpec(
          'Context timeframe',
          'The higher timeframe you use to decide what the larger picture is doing.',
          'Choosing a context timeframe before you look at detail keeps you from being pulled '
              'around by every small move. Which one you choose is a personal decision, but '
              'making it in advance is not.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'The daily chart shows bullish structure and the hourly shows bearish structure. What '
              'is happening?',
          [
            'A pullback within a larger up move',
            'One of the charts is wrong',
            'A reversal is confirmed',
            'The instrument has two prices',
          ],
          0,
          'This is the most common relationship between timeframes, not a contradiction.',
          concept: 'nested_structure',
        ),
        QuizSpec(
          'Why decide your context timeframe before analysing?',
          [
            'So small moves do not repeatedly change your reading',
            'Because higher timeframes are more accurate',
            'To reduce screen time',
            'Because brokers require it',
          ],
          0,
          'Without a fixed reference you end up rereading the market every few minutes, which is '
              'how overtrading starts.',
          concept: 'context_timeframe',
        ),
        QuizSpec(
          'A single daily swing can contain:',
          [
            'A complete structural sequence on the hourly chart',
            'Only one hourly swing',
            'No hourly structure at all',
            'Exactly four hourly swings',
          ],
          0,
          'Structure nests. Each level down reveals more of it.',
          concept: 'nested_structure',
        ),
      ],
      facts: [
        FactSpec(
          'Higher and lower timeframe structure regularly point in opposite directions.',
          true,
          'That is normal and usually indicates a pullback.',
          concept: 'nested_structure',
        ),
        FactSpec(
          'The lower timeframe reading always overrides the higher timeframe.',
          false,
          'Neither overrides the other. They answer different questions.',
          concept: 'context_timeframe',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.uptrendPullback,
          30901,
        ),
        ChartTaskSpec(
          ChartTask.identifyHigherLow,
          ChartPattern.changeOfCharacterUp,
          30902,
        ),
      ],
    ),
    LessonSpec(
      title: 'Structure Practice',
      subtitle: 'Mixed charts, no hints',
      minutes: 6,
      difficulty: Difficulty.advanced,
      intro:
          'Charts from across the world, unlabelled. Work left to right and trust the '
          'comparisons over the overall impression.',
      concepts: [
        ConceptSpec(
          'Reading order',
          'Left to right, comparing like with like, without skipping.',
          'The discipline of working in order is what stops the eye from jumping to the biggest '
              'move on screen and labelling everything around it to match.',
        ),
        ConceptSpec(
          'Impression bias',
          'Letting the overall look of a chart override the individual comparisons.',
          'A chart that "looks bullish" can contain a lower high that changes the reading '
              'entirely. The comparisons are the reading; the impression is not.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A chart looks strongly bullish, but the last swing high is below the previous one. '
              'What is the correct label?',
          [
            'Lower high — the comparison decides, not the impression',
            'Higher high, because the trend is up',
            'It depends on the timeframe',
            'No label applies',
          ],
          0,
          'This is exactly the trap. The comparison is the definition.',
          concept: 'impression_bias',
          mistake: MistakeTag.structureMisread,
        ),
        QuizSpec(
          'What is the reliable way to label a busy chart?',
          [
            'Work left to right, tracking the last high and last low',
            'Start from the biggest move and work outwards',
            'Label only the obvious swings',
            'Use the highest and lowest points only',
          ],
          0,
          'Order and consistency beat intuition on busy charts.',
          concept: 'reading_order',
        ),
        QuizSpec(
          'You cannot tell whether the current chart is bullish, bearish or ranging. What does '
              'that indicate?',
          [
            'The chart is genuinely unclear, which is useful information',
            'You need a lower timeframe',
            'You need an indicator',
            'You have made an error',
          ],
          0,
          '"Unclear" is a legitimate conclusion and usually the correct one before a no-trade '
              'decision.',
          concept: 'impression_bias',
        ),
      ],
      facts: [
        FactSpec(
          'The overall look of a chart is a reliable substitute for labelling the swings.',
          false,
          'Impression and structure disagree often enough that the comparisons must be done.',
          concept: 'impression_bias',
        ),
        FactSpec(
          'Concluding that a chart is unclear is a valid outcome of structural analysis.',
          true,
          'It often leads directly to the correct decision, which is to stand aside.',
          concept: 'reading_order',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.labelStructure,
          ChartPattern.changeOfCharacterDown,
          31001,
        ),
        ChartTaskSpec(
          ChartTask.identifyLowerHigh,
          ChartPattern.liquiditySweepLow,
          31002,
        ),
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.choppyVolatile,
          31003,
        ),
      ],
    ),
  ],
  boss: BossSpec(
    title: 'Market Structure Challenge',
    subtitle: 'HH, HL, LH, LL and the sequences they form',
    difficulty: Difficulty.advanced,
    minutes: 9,
    intro:
        'The full structure toolkit across unfamiliar charts: identify each label, classify the '
        'sequence and read the invalidation level. Score 80% to unlock Trends.',
    charts: [
      ChartTaskSpec(ChartTask.identifyHigherHigh, ChartPattern.uptrend, 39001),
      ChartTaskSpec(
        ChartTask.identifyHigherLow,
        ChartPattern.breakoutUp,
        39002,
      ),
      ChartTaskSpec(ChartTask.identifyLowerHigh, ChartPattern.downtrend, 39003),
      ChartTaskSpec(
        ChartTask.identifyLowerLow,
        ChartPattern.downtrendPullback,
        39004,
      ),
      ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.range, 39005),
      ChartTaskSpec(ChartTask.labelStructure, ChartPattern.uptrend, 39006),
      ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.downtrend, 39007),
    ],
    quizzes: [
      QuizSpec(
        'In bullish structure, which level invalidates the reading if price trades through it?',
        [
          'The most recent higher low',
          'The most recent higher high',
          'The lowest low on the chart',
          'The previous day\'s close',
        ],
        0,
        'Breaking the most recent higher low ends the sequence of higher lows.',
        concept: 'invalidation_level',
      ),
      QuizSpec(
        'A swing high at 88 follows a previous swing high at 95, while lows are also stepping '
            'down. How does the framework read this?',
        ['Bearish structure', 'Bullish structure', 'A range', 'Undefined'],
        0,
        'Lower highs plus lower lows is bearish structure.',
        concept: 'bearish_structure',
      ),
      QuizSpec(
        'Why is the most recent swing point always provisional?',
        [
          'Price can still extend past it and erase it as a turning point',
          'Data providers revise it',
          'It only becomes real on the daily chart',
          'It is not provisional',
        ],
        0,
        'A swing needs candles either side. The right side is still being written.',
        concept: 'confirmation_lag',
      ),
    ],
    facts: [
      FactSpec(
        'Swing highs are compared with swing highs, never with swing lows.',
        true,
        'Like with like is the rule that makes labelling unambiguous.',
        concept: 'comparison_rule',
      ),
      FactSpec(
        'A lower high must be below the most recent prices on the chart.',
        false,
        'It only has to be below the previous swing high. It can sit well above current price.',
        concept: 'lowerHigh',
      ),
    ],
  ),
);
