import '../../../domain/models/enums.dart';
import '../../../domain/models/skill.dart';
import '../lesson_spec.dart';

/// World 9 — Support & Resistance.
const WorldSpec world09Levels = WorldSpec(
  id: 'w09',
  index: 9,
  title: 'Support & Resistance',
  subtitle: 'Areas price keeps reacting to',
  description:
      'Drawing areas rather than lines, what a retest is, what a failed level means, and why '
      'context decides whether a level matters at all.',
  primarySkillId: Skills.supportResistance,
  accentColor: 0xFF2BE5A8,
  lessons: [
    LessonSpec(
      title: 'Support',
      subtitle: 'Where declines have stopped',
      minutes: 5,
      intro:
          'Support is an area where buying has previously been strong enough to turn price up. '
          'It is a record of what happened, not a floor.',
      concepts: [
        ConceptSpec(
          'Support',
          'An area where price has previously turned up.',
          'Support needs at least two reactions to be worth marking. One low is just a low; two '
              'or more at a similar area is a pattern worth noting.',
        ),
        ConceptSpec(
          'Area not line',
          'Support occupies a band of prices, not a single one.',
          'Reactions rarely occur at the exact same price twice. Drawing a band that covers the '
              'wicks is more honest and produces better stop placement than a precise line.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'How many reactions make an area worth marking as support?',
          ['At least two', 'One', 'At least five', 'It does not matter'],
          0,
          'One low is a low. Repetition is what makes it a pattern.',
          concept: 'support',
        ),
        QuizSpec(
          'Why draw support as a band rather than a line?',
          [
            'Reactions occur near, not exactly at, the same price',
            'Bands look clearer',
            'Lines are inaccurate on charts',
            'Brokers require bands',
          ],
          0,
          'Precise lines encourage stops a tick away, exactly where overshoot lands.',
          concept: 'area_not_line',
        ),
        QuizSpec(
          'What does support guarantee?',
          [
            'Nothing — it records past reactions only',
            'That price will bounce',
            'That price cannot fall below it',
            'That buyers are present now',
          ],
          0,
          'Every support area that has ever existed eventually failed.',
          concept: 'support',
        ),
      ],
      facts: [
        FactSpec(
          'Support is a price floor that cannot break.',
          false,
          'It is an area of past reaction. All of them break eventually.',
          concept: 'support',
        ),
        FactSpec(
          'Support areas are drawn as bands covering the reaction wicks.',
          true,
          'Which reflects how price actually behaves around them.',
          concept: 'area_not_line',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.selectSupport, ChartPattern.supportTest, 90101),
      ],
    ),
    LessonSpec(
      title: 'Resistance',
      subtitle: 'Where advances have stopped',
      minutes: 4,
      intro: 'The mirror of support: an area where selling has previously turned price down.',
      concepts: [
        ConceptSpec(
          'Resistance',
          'An area where price has previously turned down.',
          'Same rules in reverse. Two or more reactions at a similar area, drawn as a band '
              'covering the wicks.',
        ),
        ConceptSpec(
          'Symmetry of logic',
          'Support and resistance are the same idea in opposite directions.',
          'Everything true of one is true of the other with the signs flipped. There is no need '
              'to learn them as separate topics.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Resistance is:',
          [
            'An area where price has previously turned down',
            'The highest price ever reached',
            'A line drawn at a round number',
            'The top of the current candle',
          ],
          0,
          'It is defined by repeated reaction, not by extremes or round numbers.',
          concept: 'resistance',
        ),
        QuizSpec(
          'How do the rules for resistance differ from those for support?',
          [
            'They do not — only the direction changes',
            'Resistance needs more touches',
            'Resistance is always a line',
            'Resistance only applies to stocks',
          ],
          0,
          'The logic is identical with the signs reversed.',
          concept: 'symmetry_of_logic',
        ),
        QuizSpec(
          'A single swing high is:',
          [
            'A swing high, not yet a resistance area',
            'Resistance',
            'A range boundary',
            'A failed level',
          ],
          0,
          'One reaction does not establish a pattern.',
          concept: 'resistance',
        ),
      ],
      facts: [
        FactSpec(
          'The same rules apply to support and resistance with the direction reversed.',
          true,
          'Support and resistance are a single idea applied in two directions, so anything '
              'true of one is true of the other with the signs reversed.',
          concept: 'symmetry_of_logic',
        ),
        FactSpec(
          'A single swing high establishes a resistance area.',
          false,
          'Repetition is what makes it worth marking.',
          concept: 'resistance',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.selectResistance,
          ChartPattern.resistanceTest,
          90201,
        ),
      ],
    ),
    LessonSpec(
      title: 'Retests',
      subtitle: 'Returning to a level',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'A retest is price coming back to an area it previously reacted from. It is a common '
          'reference point for entries, and it resolves both ways.',
      concepts: [
        ConceptSpec(
          'Retest',
          'Price returning to a previously significant area.',
          'The value of a retest is practical: it gives an entry close to a level, which means a '
              'close invalidation point and therefore a small risk per unit.',
        ),
        ConceptSpec(
          'Why retests are used',
          'Proximity to invalidation, not a higher chance of success.',
          'Entering at a level puts the stop just beyond it. That is an arithmetic advantage in '
              'risk per unit. It is not a claim that the level will hold.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What is the honest reason to prefer entering at a retest?',
          [
            'The invalidation level is close, so risk per unit is small',
            'Retests usually hold',
            'It guarantees a better fill',
            'It is what professionals do',
          ],
          0,
          'The advantage is arithmetic. It says nothing about the probability of the level '
              'holding.',
          concept: 'why_retests_are_used',
        ),
        QuizSpec(
          'A retest fails and price trades straight through. What does that mean?',
          [
            'The idea was invalidated, which is what the stop was for',
            'The level was drawn wrongly',
            'The market is manipulated',
            'The level will hold next time',
          ],
          0,
          'Levels fail regularly. That is why the trade had a defined invalidation point.',
          concept: 'retest',
        ),
        QuizSpec(
          'A retest is:',
          [
            'Price returning to an area it previously reacted from',
            'A second attempt at the same trade',
            'A test of the trading platform',
            'Any pullback',
          ],
          0,
          'It is specifically a return to a marked area.',
          concept: 'retest',
        ),
      ],
      facts: [
        FactSpec(
          'Entering at a retest reduces risk per unit by putting the stop close by.',
          true,
          'That is the concrete benefit.',
          concept: 'why_retests_are_used',
        ),
        FactSpec(
          'Retests usually hold.',
          false,
          'They resolve in both directions frequently. The benefit is the tight invalidation, '
              'not the outcome.',
          concept: 'retest',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.selectSupport, ChartPattern.supportTest, 90301),
        ChartTaskSpec(ChartTask.placeStopLong, ChartPattern.supportTest, 90302),
      ],
    ),
    LessonSpec(
      title: 'Role Reversal',
      subtitle: 'Broken support, new resistance',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'When a level breaks, it often becomes relevant from the other side. The idea is worth '
          'understanding, and worth holding loosely.',
      concepts: [
        ConceptSpec(
          'Role reversal',
          'A broken support area acting as resistance afterwards, or the reverse.',
          'The usual explanation involves positioning around the level. Whatever the mechanism, '
              'what you can verify is only whether price reacted there again.',
        ),
        ConceptSpec(
          'Confirmation of a break',
          'Deciding whether a level was genuinely broken.',
          'A wick through a level is not the same as price accepting beyond it. Waiting for a '
              'close beyond, or for a retest from the other side, is a convention — not a rule '
              'that makes it reliable.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Broken support is often watched afterwards as:',
          ['Resistance', 'Stronger support', 'A range low', 'Irrelevant'],
          0,
          'That flip is what role reversal describes.',
          concept: 'role_reversal',
        ),
        QuizSpec(
          'A single wick through a level means:',
          [
            'Price traded there briefly; acceptance beyond is a separate question',
            'The level has broken',
            'The level is confirmed',
            'A reversal is coming',
          ],
          0,
          'Brief penetration and acceptance are different things, which is why the distinction '
              'matters.',
          concept: 'confirmation_of_a_break',
        ),
        QuizSpec(
          'Role reversal should be treated as:',
          [
            'A pattern worth watching, not a rule',
            'A guaranteed behaviour',
            'A myth with no basis',
            'A signal to enter immediately',
          ],
          0,
          'It happens often enough to note and fails often enough to require a stop.',
          concept: 'role_reversal',
        ),
      ],
      facts: [
        FactSpec(
          'A wick beyond a level is the same as acceptance beyond it.',
          false,
          'Acceptance means trading and staying there, which a single wick does not show.',
          concept: 'confirmation_of_a_break',
        ),
        FactSpec(
          'Role reversal is a tendency rather than a rule.',
          true,
          'It fails regularly, which is why trades built on it still need stops.',
          concept: 'role_reversal',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.selectResistance,
          ChartPattern.breakoutDown,
          90401,
          note:
              'This area held price up until it broke. Price is now below it, so it is '
              'watched from the other side.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Failed Levels',
      subtitle: 'When an area stops mattering',
      minutes: 4,
      difficulty: Difficulty.intermediate,
      intro:
          'Levels lose relevance. Recognising when one has stopped working prevents a chart full '
          'of lines nobody is reacting to.',
      concepts: [
        ConceptSpec(
          'Failed level',
          'An area price has traded through without reacting.',
          'Once price passes through cleanly and keeps going, the area has stopped being a '
              'reference. Leaving it on the chart clutters the picture.',
        ),
        ConceptSpec(
          'Level hygiene',
          'Removing areas that no longer matter.',
          'A chart with ten lines has no levels, only decoration. Two or three areas that price '
              'has genuinely reacted to are more useful than a dozen historical ones.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Price trades cleanly through a support area and continues. What now?',
          [
            'The area has stopped being a support reference',
            'It becomes stronger support',
            'It was drawn incorrectly',
            'Price must return to it',
          ],
          0,
          'A clean break through without reaction means it is no longer acting as one.',
          concept: 'failed_level',
        ),
        QuizSpec(
          'What is wrong with a chart covered in levels?',
          [
            'Everything is near a level, so no level means anything',
            'It renders slowly',
            'It uses too much memory',
            'Nothing',
          ],
          0,
          'When every price is close to a line, the lines stop carrying information.',
          concept: 'level_hygiene',
        ),
        QuizSpec(
          'How many meaningful areas does a typical chart support?',
          [
            'A small number — usually two or three',
            'As many as you can find',
            'Exactly one',
            'At least ten',
          ],
          0,
          'Few and well-tested beats many and historical.',
          concept: 'level_hygiene',
        ),
      ],
      facts: [
        FactSpec(
          'More levels on a chart means more information.',
          false,
          'Past a small number they stop being distinguishable and stop being useful.',
          concept: 'level_hygiene',
        ),
        FactSpec(
          'A level price has traded straight through has stopped acting as a reference.',
          true,
          'Once price passes through without reacting, the area has stopped acting as a '
              'reference and can be taken off the chart.',
          concept: 'failed_level',
        ),
      ],
    ),
    LessonSpec(
      title: 'Range Boundaries',
      subtitle: 'Support and resistance together',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'A range is support and resistance holding at the same time. The boundaries are where '
          'the decisions happen.',
      concepts: [
        ConceptSpec(
          'Range boundaries',
          'The support and resistance areas that define a sideways market.',
          'Inside a range, the edges are where risk is definable: close to a boundary the '
              'invalidation level is close, and the opposite boundary is a natural target.',
        ),
        ConceptSpec(
          'Mid-range',
          'The area between the boundaries.',
          'The middle of a range is the worst place to act: the invalidation level is far in both '
              'directions and there is no clear target. Most range losses are taken here.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Where in a range is risk most definable?',
          [
            'Close to a boundary',
            'In the middle',
            'Anywhere inside it',
            'Only outside it',
          ],
          0,
          'Near a boundary the invalidation point is close and the opposite side is a target.',
          concept: 'range_boundaries',
        ),
        QuizSpec(
          'Why is mid-range usually a poor place to enter?',
          [
            'Invalidation is far in both directions and there is no clear target',
            'Spreads widen there',
            'Volume is lower',
            'It is not poor',
          ],
          0,
          'Neither the risk nor the reward side can be defined well.',
          concept: 'mid_range',
          mistake: MistakeTag.impulsiveTrade,
        ),
        QuizSpec(
          'A range is defined by:',
          [
            'A support area and a resistance area both holding',
            'Low volume',
            'Small candles',
            'Sideways moving averages',
          ],
          0,
          'Two areas containing price is what makes it a range.',
          concept: 'range_boundaries',
        ),
      ],
      facts: [
        FactSpec(
          'The middle of a range is where the clearest setups occur.',
          false,
          'It is where risk and reward are both hardest to define.',
          concept: 'mid_range',
        ),
        FactSpec(
          'In a range, the opposite boundary is a natural target.',
          true,
          'Price has demonstrably reached it before.',
          concept: 'range_boundaries',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.selectRangeHigh, ChartPattern.range, 90601),
        ChartTaskSpec(ChartTask.selectRangeLow, ChartPattern.range, 90602),
      ],
    ),
    LessonSpec(
      title: 'Context Decides',
      subtitle: 'The same level in different situations',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro: 'A level in a strong trend and the same level in a range are not the same observation.',
      concepts: [
        ConceptSpec(
          'Level in context',
          'How the surrounding structure changes what a level implies.',
          'Resistance inside a strong uptrend gets broken frequently. The same area in a range '
              'holds more often. The line is identical; the situation is not.',
        ),
        ConceptSpec(
          'Confluence',
          'Several separate observations pointing at the same area.',
          'A swing high, a range boundary and a prior reaction all at one area is more notable '
              'than any one alone. Worth saying plainly: confluence increases how much attention '
              'an area deserves. It does not supply a probability.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Resistance inside a strong uptrend compared with the same area in a range:',
          [
            'Is more likely to be traded through, based on how trends behave',
            'Behaves identically',
            'Always holds',
            'Cannot be drawn',
          ],
          0,
          'Context changes what the same drawing implies.',
          concept: 'level_in_context',
        ),
        QuizSpec(
          'What does confluence honestly give you?',
          [
            'A reason to pay more attention to an area',
            'A higher probability of success',
            'A guarantee',
            'A larger position size',
          ],
          0,
          'Attention, not probability. Nothing on a chart hands you a probability.',
          concept: 'confluence',
        ),
        QuizSpec(
          'Two traders draw the same level but read it differently. Why?',
          [
            'They are weighing the surrounding context differently',
            'One of them is wrong',
            'The chart data differs',
            'Levels are arbitrary',
          ],
          0,
          'The level is an observation; what it implies depends on context, and context is '
              'judged.',
          concept: 'level_in_context',
        ),
      ],
      facts: [
        FactSpec(
          'Confluence raises the probability that a level holds.',
          false,
          'It raises how notable the area is. Probability is not something a chart provides.',
          concept: 'confluence',
        ),
        FactSpec(
          'The same level can imply different things depending on the surrounding structure.',
          true,
          'Context is part of the reading.',
          concept: 'level_in_context',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.selectResistance,
          ChartPattern.resistanceTest,
          90701,
        ),
        ChartTaskSpec(
          ChartTask.decideDirection,
          ChartPattern.supportTest,
          90702,
        ),
      ],
    ),
    LessonSpec(
      title: 'Levels and Stops',
      subtitle: 'Using areas to place invalidation',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'Levels are most useful for the same reason structure is: they give a specific place '
          'where the idea is wrong.',
      concepts: [
        ConceptSpec(
          'Stops beyond areas',
          'Placing the stop beyond the whole band, not inside it.',
          'If support runs from 96.0 to 96.8, a stop at 96.4 sits inside the area price is '
              'actively reacting within. Beyond the band means below 96.0 plus a buffer.',
        ),
        ConceptSpec(
          'Band width and size',
          'A wider area means a wider stop and therefore a smaller position.',
          'Thick bands are honest but expensive. If the band is so wide that the resulting size '
              'is negligible, that is useful information: this trade is not available at this '
              'account size.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Support runs 96.0–96.8. Where does a long stop belong?',
          [
            'Below 96.0, with a small buffer',
            'At 96.4, in the middle',
            'At 96.8, at the top',
            'At 96.0 exactly',
          ],
          0,
          'The whole band is the area price reacts within, so the stop goes beyond all of it.',
          concept: 'stops_beyond_areas',
        ),
        QuizSpec(
          'A very wide support band means:',
          [
            'A wider stop and therefore a smaller position for the same risk',
            'A stronger level',
            'A better trade',
            'A tighter stop',
          ],
          0,
          'Width feeds directly into stop distance and therefore into size.',
          concept: 'band_width_and_size',
        ),
        QuizSpec(
          'The calculated size comes out negligible because the band is very wide. What does that '
              'tell you?',
          [
            'This trade is not available at this account size',
            'Increase the risk percentage',
            'Narrow the band',
            'Ignore the band',
          ],
          0,
          'Adjusting the band or the risk percentage to force the trade discards the reason for '
              'both.',
          concept: 'band_width_and_size',
        ),
      ],
      facts: [
        FactSpec(
          'A stop inside a support band is protected by the level.',
          false,
          'It sits inside the area price is actively reacting within.',
          concept: 'stops_beyond_areas',
        ),
        FactSpec(
          'Band width directly affects position size.',
          true,
          'A wider band pushes the stop further from the entry, which increases the risk '
              'distance and therefore reduces the number of units for the same risk amount.',
          concept: 'band_width_and_size',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.placeStopLong, ChartPattern.supportTest, 90801),
        ChartTaskSpec(
          ChartTask.placeStopShort,
          ChartPattern.resistanceTest,
          90802,
        ),
      ],
    ),
    LessonSpec(
      title: 'Level Mistakes',
      subtitle: 'How level drawing goes wrong',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'Three failure modes: too many lines, lines drawn after the fact, and treating an area '
          'as a certainty.',
      concepts: [
        ConceptSpec(
          'Hindsight levels',
          'Drawing a level after seeing the reaction that justifies it.',
          'Every chart is full of areas that worked once you know where price turned. The test '
              'is whether the level was marked before the reaction.',
        ),
        ConceptSpec(
          'Level worship',
          'Treating a level as a certainty rather than an area of interest.',
          'Removing a stop because "this level will hold" converts a bounded risk into an '
              'unbounded one on the strength of a drawing.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What is the test of whether a level was genuinely useful?',
          [
            'Whether it was marked before price reacted to it',
            'Whether price reacted at it',
            'Whether it is a round number',
            'How many times it appears',
          ],
          0,
          'Levels identified afterwards always look perfect.',
          concept: 'hindsight_levels',
        ),
        QuizSpec(
          'A trader removes their stop because "support will hold here". What happened?',
          [
            'A drawing was used to justify unbounded risk',
            'A reasonable use of confluence',
            'Good risk management',
            'Nothing unusual',
          ],
          0,
          'Every level fails eventually, and the stop was the only thing bounding the loss.',
          concept: 'level_worship',
          mistake: MistakeTag.noStop,
        ),
        QuizSpec(
          'Why is drawing levels in hindsight misleading?',
          [
            'The reaction is what made the area visible, so it always looks reliable',
            'The data is different',
            'It takes too long',
            'It is not misleading',
          ],
          0,
          'Selecting areas by their outcomes guarantees they look good.',
          concept: 'hindsight_levels',
        ),
      ],
      facts: [
        FactSpec(
          'A level marked after the reaction is weaker evidence than one marked before it.',
          true,
          'Hindsight selection makes any area look reliable.',
          concept: 'hindsight_levels',
        ),
        FactSpec(
          'A strong level justifies trading without a stop.',
          false,
          'No level justifies unbounded risk.',
          concept: 'level_worship',
        ),
      ],
      extras: [
        SpotMistakeSpec(
          'A trader writes: "Major support here, been respected for years. Going long with no '
              'stop — if it breaks, it is a generational buying opportunity anyway."',
          [
            'A level is being used to justify an unbounded loss',
            'The position is too small',
            'They should have used a limit order',
            'Support is not a real concept',
          ],
          0,
          MistakeTag.noStop,
          'Two moves in one: removing the bound on the loss, and pre-framing the failure as an '
              'opportunity so the position never has to be closed. Together they describe a '
              'position that can only be exited by force.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Level Practice',
      subtitle: 'Mark and use areas on fresh charts',
      minutes: 6,
      difficulty: Difficulty.advanced,
      intro: 'Find the areas, place stops beyond them, and pass on charts where nothing is clear.',
      concepts: [
        ConceptSpec(
          'Marking routine',
          'A repeatable way to find areas on a new chart.',
          'Find the swing points, look for prices that appear more than once, draw a band over '
              'the wicks, then check whether price actually reacted there each time.',
        ),
        ConceptSpec(
          'Discarding',
          'Being willing to conclude there is no usable level.',
          'Some charts have no area price has reacted to more than once. Marking one anyway is '
              'inventing information.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What is the first step in marking areas on a fresh chart?',
          [
            'Identify the swing points',
            'Draw round numbers',
            'Add an indicator',
            'Mark the highest and lowest prices',
          ],
          0,
          'Swings are where reactions happened, which is where areas come from.',
          concept: 'marking_routine',
        ),
        QuizSpec(
          'A chart has no price that has been reacted to more than once. What do you do?',
          [
            'Mark nothing',
            'Mark the most recent high anyway',
            'Use round numbers instead',
            'Switch timeframe until something appears',
          ],
          0,
          'Marking an area with no evidence behind it is inventing information.',
          concept: 'discarding',
        ),
        QuizSpec(
          'After drawing a band you should:',
          [
            'Check that price actually reacted at each touch',
            'Immediately place an order',
            'Draw two more',
            'Extend it to the whole chart history',
          ],
          0,
          'Touches without reactions are coincidence, not evidence.',
          concept: 'marking_routine',
        ),
      ],
      facts: [
        FactSpec(
          'Some charts contain no usable support or resistance area.',
          true,
          'Marking one anyway invents information.',
          concept: 'discarding',
        ),
        FactSpec(
          'A price being touched is the same as price reacting to it.',
          false,
          'A reaction means price turned there, not merely traded through it.',
          concept: 'marking_routine',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.selectSupport, ChartPattern.supportTest, 91001),
        ChartTaskSpec(
          ChartTask.selectResistance,
          ChartPattern.resistanceTest,
          91002,
        ),
        ChartTaskSpec(
          ChartTask.buildTradeLong,
          ChartPattern.supportTest,
          91003,
        ),
      ],
    ),
  ],
  boss: BossSpec(
    title: 'Levels Challenge',
    subtitle: 'Areas, retests and honest limits',
    difficulty: Difficulty.advanced,
    minutes: 8,
    intro: 'Find and use areas across unfamiliar charts. Score 80% to unlock Breakouts & Liquidity.',
    charts: [
      ChartTaskSpec(ChartTask.selectSupport, ChartPattern.supportTest, 99001),
      ChartTaskSpec(
        ChartTask.selectResistance,
        ChartPattern.resistanceTest,
        99002,
      ),
      ChartTaskSpec(ChartTask.selectRangeHigh, ChartPattern.range, 99003),
      ChartTaskSpec(ChartTask.placeStopLong, ChartPattern.supportTest, 99004),
      ChartTaskSpec(
        ChartTask.buildTradeShort,
        ChartPattern.resistanceTest,
        99005,
      ),
    ],
    quizzes: [
      QuizSpec(
        'Support runs 44.0–44.6. A long stop belongs:',
        ['Below 44.0 with a buffer', 'At 44.3', 'At 44.6', 'Above 44.6'],
        0,
        'The whole band is the reaction area.',
        concept: 'stops_beyond_areas',
      ),
      QuizSpec(
        'The honest reason to enter at a retest is:',
        [
          'The invalidation level is close, so risk per unit is small',
          'Retests usually hold',
          'Better fills',
          'Lower spreads',
        ],
        0,
        'An arithmetic advantage, not a probabilistic one.',
        concept: 'why_retests_are_used',
      ),
      QuizSpec(
        'Confluence gives you:',
        [
          'A reason to pay more attention',
          'A higher probability',
          'A guarantee',
          'Permission to size up',
        ],
        0,
        'Several observations landing on one area is a reason to look harder at it. No chart '
            'condition converts into a probability you can rely on.',
        concept: 'confluence',
      ),
    ],
    facts: [
      FactSpec(
        'Every support and resistance area eventually breaks.',
        true,
        'Which is why trades built on them still need bounded risk.',
        concept: 'support',
      ),
      FactSpec(
        'A chart with many levels marked is better analysed than one with few.',
        false,
        'Past a small number they stop carrying information.',
        concept: 'level_hygiene',
      ),
    ],
  ),
);
