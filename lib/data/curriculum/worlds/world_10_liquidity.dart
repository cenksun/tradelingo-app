import '../../../domain/models/enums.dart';
import '../../../domain/models/skill.dart';
import '../lesson_spec.dart';

/// World 10 — Breakouts & Liquidity.
const WorldSpec world10Liquidity = WorldSpec(
  id: 'w10',
  index: 10,
  title: 'Breakouts & Liquidity',
  subtitle: 'Breaks, failed breaks and clustered orders',
  description:
      'What a breakout is, why so many fail, and what it means when resting orders concentrate '
      'in one small area.',
  primarySkillId: Skills.liquidity,
  accentColor: 0xFF52A8FF,
  lessons: [
    LessonSpec(
      title: 'Breakouts',
      subtitle: 'Trading beyond a boundary',
      minutes: 5,
      intro:
          'A breakout is price trading beyond an area that had been containing it. Whether it '
          'holds is a separate question from whether it happened.',
      concepts: [
        ConceptSpec(
          'Breakout',
          'Price trading beyond a level that had been holding.',
          'The event itself is objective: price was contained, now it is not. What people '
              'disagree about is whether it will continue, which the break alone does not tell '
              'you.',
        ),
        ConceptSpec(
          'Acceptance',
          'Price trading and remaining beyond the level.',
          'A wick through a boundary and several candles trading above it are different things. '
              'Acceptance is the more meaningful of the two, and it takes time to establish.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What does a breakout tell you on its own?',
          [
            'That price traded beyond a level — nothing about continuation',
            'That a trend has started',
            'That the level is now support',
            'That volume increased',
          ],
          0,
          'The event is objective; the implication is not.',
          concept: 'breakout',
        ),
        QuizSpec(
          'Acceptance beyond a level means:',
          [
            'Price traded there and stayed there for a period',
            'One candle closed beyond',
            'A wick passed through',
            'The level was deleted',
          ],
          0,
          'Time spent beyond is what distinguishes acceptance from penetration.',
          concept: 'acceptance',
        ),
        QuizSpec(
          'Why is waiting for acceptance a trade-off rather than an improvement?',
          [
            'It reduces false signals but gives up a worse entry price',
            'It costs commission',
            'It has no downside',
            'It always produces better entries',
          ],
          0,
          'Every confirmation you wait for costs distance from the invalidation level.',
          concept: 'acceptance',
        ),
      ],
      facts: [
        FactSpec(
          'A breakout guarantees continuation in the direction of the break.',
          false,
          'Many breaks reverse immediately. The event and the outcome are separate.',
          concept: 'breakout',
        ),
        FactSpec(
          'Waiting for acceptance means entering further from the invalidation level.',
          true,
          'Which is the cost of the extra confirmation.',
          concept: 'acceptance',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.breakoutUp, 100101),
        ChartTaskSpec(
          ChartTask.selectResistance,
          ChartPattern.breakoutUp,
          100102,
        ),
      ],
    ),
    LessonSpec(
      title: 'False Breakouts',
      subtitle: 'Breaks that do not hold',
      minutes: 5,
      intro:
          'Price trades beyond the boundary, fails to hold, and comes back. This is common enough '
          'that it has to be planned for, not treated as a surprise.',
      concepts: [
        ConceptSpec(
          'False breakout',
          'A break that reverses back inside the prior area.',
          'Only identifiable afterwards. At the moment of the break, a real one and a false one '
              'look identical — which is the entire problem with breakout trading.',
        ),
        ConceptSpec(
          'Cost of false breaks',
          'What happens when you enter a break that fails.',
          'You entered at the extreme and price came straight back. Stops beyond the level are '
              'now on the wrong side of a move going the other way.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'When can a false breakout be identified?',
          [
            'Only afterwards',
            'At the moment of the break',
            'From volume',
            'From the candle colour',
          ],
          0,
          'Real and false breaks are indistinguishable while they happen.',
          concept: 'false_breakout',
        ),
        QuizSpec(
          'Why is entering on the break itself expensive when it fails?',
          [
            'You entered at the extreme of the move and price reversed from there',
            'Spreads widen',
            'Commission doubles',
            'It is not expensive',
          ],
          0,
          'The break level is the worst price in the move if it reverses.',
          concept: 'cost_of_false_breaks',
        ),
        QuizSpec(
          'False breakouts are:',
          [
            'Common enough that a breakout plan must account for them',
            'Rare',
            'A sign of manipulation',
            'Only present in crypto',
          ],
          0,
          'They occur across every market and timeframe.',
          concept: 'false_breakout',
        ),
      ],
      facts: [
        FactSpec(
          'A real and a false breakout look the same at the moment of the break.',
          true,
          'Which is why the plan has to include what happens if it fails.',
          concept: 'false_breakout',
        ),
        FactSpec(
          'False breakouts only happen in thinly traded markets.',
          false,
          'They occur in the most liquid markets in the world.',
          concept: 'false_breakout',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.falseBreakoutUp,
          100201,
        ),
        ChartTaskSpec(
          ChartTask.identifyLowerLow,
          ChartPattern.falseBreakoutUp,
          100202,
        ),
      ],
    ),
    LessonSpec(
      title: 'What Liquidity Means Here',
      subtitle: 'Resting orders, not a mystery force',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'In this world, "liquidity" means orders waiting to be filled. It is a structural '
          'observation about where orders sit, not a claim about intent.',
      concepts: [
        ConceptSpec(
          'Resting orders',
          'Orders waiting in the book at particular prices.',
          'Stop orders and limit orders both rest until triggered or filled. Where many of them '
              'sit at similar prices, that area can absorb or accelerate movement.',
        ),
        ConceptSpec(
          'Clustering',
          'Many orders concentrating in a narrow price area.',
          'Traders place protective stops in similar places for similar reasons — just beyond an '
              'obvious level. That is not a conspiracy; it is a consequence of everyone reading '
              'the same chart.',
        ),
        ConceptSpec(
          'Honest framing',
          'Describing order concentration without claiming anyone is hunting you.',
          '"Orders tend to cluster above matched highs" is a description. "The market is hunting '
              'your stops" is a story that assigns intent nobody can observe.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Why do protective stops cluster in similar areas?',
          [
            'Many traders read the same chart and place stops just beyond the same levels',
            'Brokers place them there',
            'Exchanges require it',
            'It is coordinated',
          ],
          0,
          'Shared method produces shared placement, with no coordination required.',
          concept: 'clustering',
        ),
        QuizSpec(
          'Which is the honest description?',
          [
            '"Orders tend to cluster just above these matched highs"',
            '"The market is hunting your stop"',
            '"They will run the stops before reversing"',
            '"This level was engineered"',
          ],
          0,
          'The first describes something structural. The others assign intent nobody can observe.',
          concept: 'honest_framing',
        ),
        QuizSpec(
          'A large cluster of resting orders in a narrow area can:',
          [
            'Absorb or accelerate movement when price reaches it',
            'Prevent price from reaching it',
            'Guarantee a reversal',
            'Set the price directly',
          ],
          0,
          'Concentrated orders change how price behaves at that area when it gets there.',
          concept: 'resting_orders',
        ),
      ],
      facts: [
        FactSpec(
          'Stop clustering requires coordination between traders.',
          false,
          'It follows from many people using similar methods independently.',
          concept: 'clustering',
        ),
        FactSpec(
          'Describing where orders concentrate is different from claiming someone is targeting you.',
          true,
          'One is observable; the other is not.',
          concept: 'honest_framing',
        ),
      ],
    ),
    LessonSpec(
      title: 'Equal Highs and Equal Lows',
      subtitle: 'Where clusters form',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'When two or more swings finish at almost the same price, the area just beyond them '
          'becomes a natural place for orders to accumulate.',
      concepts: [
        ConceptSpec(
          'Equal highs',
          'Two or more swing highs at nearly the same price.',
          'Shorts taken at those highs place stops just above. Breakout buyers place entries just '
              'above. Both kinds of order sit in the same narrow band.',
        ),
        ConceptSpec(
          'Equal lows',
          'Two or more swing lows at nearly the same price.',
          'The mirror image: protective stops from longs and breakout sell orders both sit just '
              'below.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Which two order types sit just above a pair of equal highs?',
          [
            'Protective stops from shorts and breakout buy orders',
            'Only protective stops',
            'Only limit sells',
            'Nothing rests there',
          ],
          0,
          'Both are buy-side orders, which is what makes the area notable.',
          concept: 'equal_highs',
        ),
        QuizSpec(
          'Equal lows are notable because:',
          [
            'Sell-side orders from long stops and breakout sells concentrate just beneath them',
            'They guarantee support',
            'They mark the end of a trend',
            'They cannot be broken',
          ],
          0,
          'The concentration is the observation; nothing is guaranteed.',
          concept: 'equal_lows',
        ),
        QuizSpec(
          'Two highs at nearly the same price are:',
          [
            'A structural observation about where orders may sit',
            'Proof of manipulation',
            'A reversal signal',
            'A charting artefact',
          ],
          0,
          'It is an observation about order placement, nothing more.',
          concept: 'equal_highs',
        ),
      ],
      facts: [
        FactSpec(
          'Equal highs attract both protective buy stops and breakout buy orders.',
          true,
          'Both sit just above, in the same band.',
          concept: 'equal_highs',
        ),
        FactSpec(
          'Equal lows mean price cannot fall further.',
          false,
          'They mark where sell-side orders concentrate, which is closer to the opposite.',
          concept: 'equal_lows',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.selectLiquidityAbove,
          ChartPattern.liquiditySweepHigh,
          100401,
        ),
        ChartTaskSpec(
          ChartTask.selectLiquidityBelow,
          ChartPattern.liquiditySweepLow,
          100402,
        ),
      ],
    ),
    LessonSpec(
      title: 'Liquidity Sweeps',
      subtitle: 'Reaching the cluster and reversing',
      minutes: 6,
      difficulty: Difficulty.advanced,
      intro:
          'A sweep is price trading just past an area of clustered orders and then reversing. It '
          'is a recognisable shape, described after the fact.',
      concepts: [
        ConceptSpec(
          'Sweep',
          'A brief move beyond a cluster, followed by a reversal.',
          'The shape: equal highs, a shallow poke above them, then price trading back down '
              'through the structure. Like every pattern here, it is identified afterwards.',
        ),
        ConceptSpec(
          'Sweep versus breakout',
          'The same event until it resolves.',
          'A poke above equal highs is a breakout if it holds and a sweep if it does not. There '
              'is no way to distinguish them at the moment it happens, which is the honest '
              'limitation of the whole idea.',
        ),
        ConceptSpec(
          'Practical use',
          'What the shape is actually good for.',
          'Its practical value is that a failed break gives a clear invalidation level: the '
              'extreme of the poke. That makes risk definable, which is a concrete benefit '
              'independent of any claim about what price does next.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What distinguishes a sweep from a breakout at the moment it happens?',
          [
            'Nothing — they are the same event until it resolves',
            'Volume',
            'Candle size',
            'The timeframe',
          ],
          0,
          'The label is applied afterwards based on what followed.',
          concept: 'sweep_versus_breakout',
        ),
        QuizSpec(
          'What is the concrete, defensible benefit of the sweep shape?',
          [
            'The extreme of the poke gives a clear invalidation level',
            'It predicts a reversal',
            'It guarantees the level holds',
            'It removes the need for a stop',
          ],
          0,
          'Definable risk is a real benefit. Prediction is not on offer.',
          concept: 'practical_use',
        ),
        QuizSpec(
          'The sweep shape is:',
          [
            'Equal highs, a shallow poke above, then a move back through the structure',
            'A long trend followed by a gap',
            'Two equal lows and nothing else',
            'Any large candle',
          ],
          0,
          'That specific sequence is what the term describes.',
          concept: 'sweep',
        ),
      ],
      facts: [
        FactSpec(
          'A sweep can be identified with certainty as it occurs.',
          false,
          'It only becomes a sweep once price fails to hold beyond the cluster.',
          concept: 'sweep_versus_breakout',
        ),
        FactSpec(
          'The extreme of a failed break provides a clear invalidation level.',
          true,
          'Which is what makes the shape practically useful.',
          concept: 'practical_use',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.selectLiquidityAbove,
          ChartPattern.liquiditySweepHigh,
          100501,
        ),
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.liquiditySweepLow,
          100502,
        ),
      ],
    ),
    LessonSpec(
      title: 'Breakout Confirmation',
      subtitle: 'What waiting actually buys you',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'Every confirmation method trades a worse entry for fewer false signals. None of them '
          'removes the problem.',
      concepts: [
        ConceptSpec(
          'Close beyond',
          'Waiting for a candle to close past the level.',
          'Filters out pure wicks. Costs you the distance between the level and the close, which '
              'on a fast break can be considerable.',
        ),
        ConceptSpec(
          'Retest after break',
          'Waiting for price to return to the broken level.',
          'Gives a much better entry and a tight invalidation point. Costs you every break that '
              'never comes back — and strong breaks frequently do not.',
        ),
        ConceptSpec(
          'No free confirmation',
          'Every filter has a cost.',
          'There is no method that removes false breaks without also removing some real ones. '
              'Choosing between them is a preference about which error you would rather make.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What does waiting for a retest after a break cost you?',
          [
            'Every break that never returns to the level',
            'Nothing',
            'Extra commission',
            'A wider stop',
          ],
          0,
          'Strong breaks often run without looking back.',
          concept: 'retest_after_break',
        ),
        QuizSpec(
          'What does waiting for a close beyond the level cost?',
          [
            'The distance between the level and the closing price',
            'Nothing',
            'The whole move',
            'A higher spread',
          ],
          0,
          'You enter further from the invalidation point, which raises risk per unit.',
          concept: 'close_beyond',
        ),
        QuizSpec(
          'Is there a confirmation method that filters false breaks without cost?',
          [
            'No — every filter removes some real signals too',
            'Yes, waiting for a close',
            'Yes, waiting for volume',
            'Yes, using a higher timeframe',
          ],
          0,
          'The trade-off is structural, not a matter of finding the right filter.',
          concept: 'no_free_confirmation',
        ),
      ],
      facts: [
        FactSpec(
          'Every breakout confirmation method removes some genuine signals as well as false ones.',
          true,
          'That is what makes it a trade-off rather than an improvement.',
          concept: 'no_free_confirmation',
        ),
        FactSpec(
          'Waiting for a retest guarantees a better entry.',
          true,
          'When it comes. The cost is the breaks where it never arrives.',
          concept: 'retest_after_break',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.buildTradeLong,
          ChartPattern.breakoutUp,
          100601,
        ),
      ],
    ),
    LessonSpec(
      title: 'Ranges and Breaks',
      subtitle: 'Where breakouts come from',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'Most breakouts start in a range, and most ranges produce at least one false break '
          'before a real one.',
      concepts: [
        ConceptSpec(
          'Range compression',
          'A range narrowing before a break.',
          'Narrowing ranges produce breaks that cover more ground relative to the range size. '
              'This is a description of a common sequence, not a signal about direction.',
        ),
        ConceptSpec(
          'Direction is unknown',
          'A compressing range says nothing about which way it resolves.',
          'Tight consolidation is frequently described as "coiling for a move". The move is a '
              'reasonable expectation; the direction is not something the shape contains.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A range narrows significantly. What can you honestly say?',
          [
            'A break is likely at some point; the direction is unknown',
            'It will break upward',
            'It will break downward',
            'It will never break',
          ],
          0,
          'Ranges end. Which side they end on is not encoded in the narrowing.',
          concept: 'direction_is_unknown',
        ),
        QuizSpec(
          'Why do breaks from tight ranges often cover a lot of ground?',
          [
            'The move is measured against a small range, so it looks and is proportionally larger',
            'Volume is always higher',
            'Tight ranges are manipulated',
            'They do not',
          ],
          0,
          'The same absolute move is proportionally bigger relative to a smaller range.',
          concept: 'range_compression',
        ),
        QuizSpec(
          'Most ranges produce:',
          [
            'At least one break that fails before one holds',
            'Exactly one clean break',
            'No breaks',
            'Breaks only on higher timeframes',
          ],
          0,
          'Which is why the plan has to include the failed case.',
          concept: 'range_compression',
        ),
      ],
      facts: [
        FactSpec(
          'A compressing range indicates the direction of the coming break.',
          false,
          'It suggests a break is coming. Direction is not part of the observation.',
          concept: 'direction_is_unknown',
        ),
        FactSpec(
          'Most ranges produce a failed break before a successful one.',
          true,
          'Planning for it is part of trading breaks.',
          concept: 'range_compression',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.tightConsolidation,
          100701,
        ),
        ChartTaskSpec(
          ChartTask.decideDirection,
          ChartPattern.tightConsolidation,
          100702,
          preferred: TradeDirection.noTrade,
        ),
      ],
    ),
    LessonSpec(
      title: 'Liquidity and Stops',
      subtitle: 'Placing stops with clusters in mind',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'Knowing where orders concentrate changes where you put yours — slightly, and for a '
          'specific reason.',
      concepts: [
        ConceptSpec(
          'Avoiding the crowd',
          'Placing stops slightly beyond the most obvious spot.',
          'One tick above equal highs is the single most crowded price on the chart. A slightly '
              'wider stop costs a little size and avoids the densest cluster.',
        ),
        ConceptSpec(
          'Cost of wider stops',
          'The size reduction that comes with more room.',
          'This is a genuine trade-off, not a free improvement. Going wider means fewer units for '
              'the same money risked.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Why might you place a stop slightly beyond the most obvious level?',
          [
            'That exact area is where resting orders concentrate most densely',
            'Brokers fill them better',
            'It reduces commission',
            'It increases position size',
          ],
          0,
          'Avoiding the densest cluster is the reason; it costs size.',
          concept: 'avoiding_the_crowd',
        ),
        QuizSpec(
          'What does a wider stop cost?',
          [
            'Position size, for the same money risked',
            'Nothing',
            'Commission',
            'The target',
          ],
          0,
          'Size and stop distance are inversely related.',
          concept: 'cost_of_wider_stops',
        ),
        QuizSpec(
          'Is placing stops away from clusters a way to avoid losses?',
          [
            'No — it avoids one specific failure mode and costs size',
            'Yes, it prevents stop-outs',
            'Yes, if the stop is wide enough',
            'Only in liquid markets',
          ],
          0,
          'It addresses one thing. The idea can still simply be wrong.',
          concept: 'avoiding_the_crowd',
        ),
      ],
      facts: [
        FactSpec(
          'A wider stop reduces the number of units for the same risk amount.',
          true,
          'The arithmetic is unavoidable.',
          concept: 'cost_of_wider_stops',
        ),
        FactSpec(
          'Placing stops away from clusters removes the risk of being wrong.',
          false,
          'It addresses one failure mode only.',
          concept: 'avoiding_the_crowd',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.placeStopLong,
          ChartPattern.liquiditySweepLow,
          100801,
        ),
      ],
    ),
    LessonSpec(
      title: 'Liquidity Mistakes',
      subtitle: 'Where this topic goes wrong',
      minutes: 5,
      difficulty: Difficulty.expert,
      intro:
          'This is the part of technical analysis most prone to overclaiming. Two habits cause '
          'most of it.',
      concepts: [
        ConceptSpec(
          'Assigning intent',
          'Describing market movement as if it were aimed at you personally.',
          '"They ran my stop" is not an observation. Price reached an area where many orders '
              'sat, and yours was among them. The distinction matters because the first framing '
              'stops you examining your own placement.',
        ),
        ConceptSpec(
          'Retrospective labelling',
          'Calling every reversal a sweep afterwards.',
          'Once you know price reversed, the poke before it looks like a sweep. The same poke '
              'that continued is called a breakout. Labelling by outcome makes the concept '
              'unfalsifiable and therefore useless.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What is wrong with "the market hunted my stop"?',
          [
            'It assigns intent to something observable only as order concentration',
            'Nothing — it is accurate',
            'It understates the problem',
            'It is a technical term',
          ],
          0,
          'The framing also removes any reason to examine where the stop was placed.',
          concept: 'assigning_intent',
        ),
        QuizSpec(
          'Why is labelling every reversal a "sweep" afterwards a problem?',
          [
            'It becomes unfalsifiable and therefore carries no information',
            'It takes too long',
            'Sweeps are not real',
            'It is not a problem',
          ],
          0,
          'A label applied only to the cases that worked describes nothing.',
          concept: 'retrospective_labelling',
        ),
        QuizSpec(
          'The defensible version of liquidity analysis is:',
          [
            'Marking where orders plausibly concentrate, before price gets there',
            'Explaining reversals afterwards',
            'Assuming large players target retail stops',
            'Avoiding stops entirely',
          ],
          0,
          'Marked in advance, it is a testable observation.',
          concept: 'retrospective_labelling',
        ),
      ],
      facts: [
        FactSpec(
          'Marking likely order concentrations in advance is more defensible than explaining '
              'reversals afterwards.',
          true,
          'Only the first can be checked.',
          concept: 'retrospective_labelling',
        ),
        FactSpec(
          '"The market hunted my stop" is a precise technical description.',
          false,
          'It assigns intent that cannot be observed, and it discourages reviewing your own '
              'placement.',
          concept: 'assigning_intent',
        ),
      ],
      extras: [
        SpotMistakeSpec(
          'A trader is stopped out one tick above a pair of equal highs, then price falls '
              'sharply. They write: "Classic stop hunt. Nothing I could have done."',
          [
            'The conclusion prevents any review of where the stop was placed',
            'The stop was too wide',
            'They should not have shorted',
            'Equal highs are not real',
          ],
          0,
          MistakeTag.stopTooTight,
          'The stop sat in the most crowded price area on the chart. "Nothing I could have done" '
              'is the part that costs the most: it closes off the one adjustment available, '
              'which is a slightly wider stop and correspondingly smaller size.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Breakout Practice',
      subtitle: 'Real breaks, failed breaks and sweeps',
      minutes: 6,
      difficulty: Difficulty.expert,
      intro:
          'Mixed charts. Identify the boundary, mark where orders plausibly sit, and decide '
          'whether anything is worth acting on.',
      concepts: [
        ConceptSpec(
          'Breakout routine',
          'A fixed sequence for reading a potential break.',
          'Find the boundary, check whether the highs or lows either side are matched, decide '
              'what your confirmation is, and set the invalidation point before anything happens.',
        ),
        ConceptSpec(
          'Pre-commitment',
          'Deciding your response before the break occurs.',
          'Deciding in advance is the only defence against reacting to the break itself, which '
              'is the most emotionally charged moment on the chart.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'When should the breakout plan be decided?',
          [
            'Before the break happens',
            'As it happens',
            'After the first pullback',
            'After the close',
          ],
          0,
          'Deciding during the break means deciding at the least reliable moment.',
          concept: 'pre_commitment',
        ),
        QuizSpec(
          'What should you identify before a break occurs?',
          [
            'The boundary, whether the swings around it are matched, and your invalidation point',
            'Only the boundary',
            'The target only',
            'The volume profile',
          ],
          0,
          'All three, decided in advance.',
          concept: 'breakout_routine',
        ),
        QuizSpec(
          'The break happens and does not match your plan. What do you do?',
          [
            'Nothing — the plan was the decision',
            'Take it anyway with smaller size',
            'Revise the plan quickly',
            'Enter and set a wider stop',
          ],
          0,
          'A plan you abandon at the moment of pressure was not a plan.',
          concept: 'pre_commitment',
        ),
      ],
      facts: [
        FactSpec(
          'A breakout plan decided in advance is more reliable than one decided during the break.',
          true,
          'The break is the least reliable moment to make a decision.',
          concept: 'pre_commitment',
        ),
        FactSpec(
          'The invalidation point should be set after entering.',
          false,
          'Before. It is what decides the size.',
          concept: 'breakout_routine',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.breakoutDown,
          101001,
        ),
        ChartTaskSpec(
          ChartTask.selectLiquidityAbove,
          ChartPattern.liquiditySweepHigh,
          101002,
        ),
        ChartTaskSpec(
          ChartTask.buildTradeShort,
          ChartPattern.falseBreakoutUp,
          101003,
        ),
      ],
    ),
  ],
  boss: BossSpec(
    title: 'Breakouts & Liquidity Challenge',
    subtitle: 'Breaks, failures and clustered orders',
    difficulty: Difficulty.expert,
    minutes: 9,
    intro:
        'Identify boundaries and clusters, and answer honestly about what the shapes do and do '
        'not tell you. Score 80% to unlock Advanced Price Action.',
    charts: [
      ChartTaskSpec(ChartTask.classifyTrend, ChartPattern.breakoutUp, 109001),
      ChartTaskSpec(
        ChartTask.classifyTrend,
        ChartPattern.falseBreakoutDown,
        109002,
      ),
      ChartTaskSpec(
        ChartTask.selectLiquidityAbove,
        ChartPattern.liquiditySweepHigh,
        109003,
      ),
      ChartTaskSpec(
        ChartTask.selectLiquidityBelow,
        ChartPattern.liquiditySweepLow,
        109004,
      ),
      ChartTaskSpec(
        ChartTask.selectResistance,
        ChartPattern.breakoutUp,
        109005,
      ),
    ],
    quizzes: [
      QuizSpec(
        'What distinguishes a sweep from a breakout at the moment it occurs?',
        ['Nothing', 'Volume', 'Candle size', 'Time of day'],
        0,
        'The distinction is made afterwards, from what followed.',
        concept: 'sweep_versus_breakout',
      ),
      QuizSpec(
        'Why do orders concentrate just above equal highs?',
        [
          'Protective stops from shorts and breakout buy orders both sit there',
          'Exchanges place them there',
          'It is coordinated',
          'They do not',
        ],
        0,
        'Two independent reasons put buy-side orders in the same narrow band.',
        concept: 'equal_highs',
      ),
      QuizSpec(
        'Waiting for a retest after a break costs you:',
        [
          'Every break that never returns',
          'Nothing',
          'Commission',
          'Your invalidation level',
        ],
        0,
        'Strong breaks frequently do not come back.',
        concept: 'retest_after_break',
      ),
      QuizSpec(
        'A range compresses sharply. The honest reading is:',
        [
          'A break is likely eventually; the direction is unknown',
          'It will break upward',
          'It will break downward',
          'It will keep compressing',
        ],
        0,
        'Direction is not encoded in the compression.',
        concept: 'direction_is_unknown',
      ),
    ],
    facts: [
      FactSpec(
        'Describing where orders concentrate is different from claiming someone is targeting you.',
        true,
        'One is structural; the other assigns unobservable intent.',
        concept: 'honest_framing',
      ),
      FactSpec(
        'False breakouts only occur in illiquid markets.',
        false,
        'They occur everywhere, including the most liquid markets.',
        concept: 'false_breakout',
      ),
    ],
  ),
);
