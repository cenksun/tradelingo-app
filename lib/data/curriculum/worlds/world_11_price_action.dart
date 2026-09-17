import '../../../domain/models/enums.dart';
import '../../../domain/models/skill.dart';
import '../lesson_spec.dart';

/// World 11 — Advanced Price Action.
///
/// Everything here is presented as a *framework*: a way of organising a chart
/// that some traders use. None of it is presented as a rule the market follows.
const WorldSpec world11PriceAction = WorldSpec(
  id: 'w11',
  index: 11,
  title: 'Advanced Price Action',
  subtitle: 'Frameworks, not laws',
  description:
      'BOS, CHoCH, fair value gaps and order blocks — what each term means, how it is drawn, and '
      'what it honestly does and does not tell you.',
  primarySkillId: Skills.priceAction,
  accentColor: 0xFF7C5CFF,
  lessons: [
    LessonSpec(
      title: 'Frameworks and Claims',
      subtitle: 'How to hold these ideas',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'This world covers vocabulary you will encounter constantly online. Learning it is '
          'useful. Believing the stronger claims made about it is not.\n\n'
          'Every idea here is a way of organising a chart. None of them predicts.',
      concepts: [
        ConceptSpec(
          'Framework',
          'An agreed way of organising and naming what price has done.',
          'A framework gives you consistent vocabulary and repeatable rules for marking a chart. '
              'That consistency is genuinely valuable. It is a different thing from the framework '
              'being right about the future.',
        ),
        ConceptSpec(
          'Overclaiming',
          'Presenting a descriptive framework as a predictive system.',
          'The tell is language: "price will return to this zone", "this always fills". '
              'Descriptive versions of the same statements are testable; predictive ones are not.',
        ),
        ConceptSpec(
          'Why learn it anyway',
          'Vocabulary and consistency have value independent of prediction.',
          'These terms are how a large part of the trading world communicates. Knowing precisely '
              'what they mean lets you read other people\'s analysis and mark your own charts '
              'the same way twice.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Which statement is a defensible use of a price action framework?',
          [
            '"This area was created by a one-directional move through it"',
            '"Price will return to this area"',
            '"This zone always holds"',
            '"This guarantees a reversal"',
          ],
          0,
          'The first describes what is on the chart. The others make claims about what has not '
              'happened.',
          concept: 'overclaiming',
        ),
        QuizSpec(
          'What does a framework genuinely provide?',
          [
            'Consistent vocabulary and repeatable marking rules',
            'Prediction',
            'A higher win rate',
            'Certainty about reversals',
          ],
          0,
          'Consistency is real value. Prediction is not on offer.',
          concept: 'framework',
        ),
        QuizSpec(
          'Why learn this vocabulary if it does not predict?',
          [
            'It is how much of the trading world communicates, and it makes your own marking consistent',
            'It does not need learning',
            'Because it works',
            'To impress other traders',
          ],
          0,
          'Reading others\' analysis and marking charts the same way twice are both practical '
              'benefits.',
          concept: 'why_learn_it_anyway',
        ),
      ],
      facts: [
        FactSpec(
          'A framework that organises a chart consistently is useful even without predictive power.',
          true,
          'Consistency is what makes your own decisions comparable over time.',
          concept: 'framework',
        ),
        FactSpec(
          'Price action frameworks tell you where price will go.',
          false,
          'They describe what price has done. No chart tool does more than that.',
          concept: 'overclaiming',
        ),
      ],
    ),
    LessonSpec(
      title: 'Break of Structure',
      subtitle: 'BOS',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'A break of structure is price trading beyond the swing that defined the current '
          'sequence. You already know the idea from World 3; this is the name it usually carries.',
      concepts: [
        ConceptSpec(
          'Break of structure',
          'Price trading beyond the swing point that defined the current structure.',
          'In bullish structure, a BOS is price trading above the most recent swing high — the '
              'trend continuing. It confirms the existing reading rather than reversing it.',
        ),
        ConceptSpec(
          'BOS as continuation',
          'A BOS in the direction of the existing structure.',
          'This is the usual meaning. It is the structural equivalent of a higher high in an '
              'uptrend, and like a higher high it describes something already printed.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'In bullish structure, a break of structure is:',
          [
            'Price trading above the most recent swing high',
            'Price trading below the most recent swing low',
            'Any large candle',
            'A gap',
          ],
          0,
          'It is the continuation of the existing sequence, named.',
          concept: 'break_of_structure',
        ),
        QuizSpec(
          'What does a BOS confirm?',
          [
            'That the existing structural sequence has continued',
            'That a reversal has started',
            'That price will keep going',
            'That volume increased',
          ],
          0,
          'Confirmation of what happened, not of what will.',
          concept: 'bos_as_continuation',
        ),
        QuizSpec(
          'How does BOS relate to what World 3 taught?',
          [
            'It is another name for a swing break in the direction of the trend',
            'It is a completely new concept',
            'It replaces the HH/HL labels',
            'It only applies to lower timeframes',
          ],
          0,
          'Same idea, different vocabulary.',
          concept: 'break_of_structure',
        ),
      ],
      facts: [
        FactSpec(
          'A break of structure in the trend direction is a continuation event.',
          true,
          'It is the sequence extending.',
          concept: 'bos_as_continuation',
        ),
        FactSpec(
          'A BOS guarantees the trend continues further.',
          false,
          'It describes the break that already occurred.',
          concept: 'break_of_structure',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.identifyHigherHigh,
          ChartPattern.breakOfStructureUp,
          110201,
        ),
        ChartTaskSpec(
          ChartTask.classifyTrend,
          ChartPattern.breakOfStructureDown,
          110202,
        ),
      ],
    ),
    LessonSpec(
      title: 'Change of Character',
      subtitle: 'CHoCH',
      minutes: 6,
      difficulty: Difficulty.advanced,
      intro:
          'A change of character is the first break against the existing structure. It is where '
          'a sequence stops behaving the way it had been.',
      concepts: [
        ConceptSpec(
          'Change of character',
          'The first break of structure against the prevailing sequence.',
          'In a downtrend of lower highs and lower lows, a CHoCH is price trading above the most '
              'recent lower high — usually after a higher low has formed. It is the first '
              'structural evidence that the sequence has changed.',
        ),
        ConceptSpec(
          'CHoCH versus BOS',
          'Direction relative to the existing structure is what separates them.',
          'A break with the structure is a BOS. The first break against it is a CHoCH. After a '
              'CHoCH, subsequent breaks in the new direction are BOS again.',
        ),
        ConceptSpec(
          'False character changes',
          'Breaks against structure that do not lead anywhere.',
          'Plenty of CHoCH events are followed by a return to the original direction. The term '
              'describes a break; it does not promise a new trend.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'In a downtrend, a change of character is:',
          [
            'Price trading above the most recent lower high',
            'Price trading below the most recent lower low',
            'A large green candle',
            'The trend accelerating',
          ],
          0,
          'The first break against the existing sequence.',
          concept: 'change_of_character',
        ),
        QuizSpec(
          'What separates a CHoCH from a BOS?',
          [
            'Whether the break is with or against the existing structure',
            'Candle size',
            'The timeframe',
            'Volume',
          ],
          0,
          'Direction relative to the current sequence is the whole distinction.',
          concept: 'choch_versus_bos',
        ),
        QuizSpec(
          'A CHoCH occurs and price then resumes the original direction. What does that mean?',
          [
            'The break happened and did not lead to a new trend — a normal outcome',
            'It was not a real CHoCH',
            'The chart was mislabelled',
            'CHoCH does not exist',
          ],
          0,
          'The term describes the break. Retrospectively deciding it "was not real" because it '
              'failed is exactly the unfalsifiable habit to avoid.',
          concept: 'false_character_changes',
        ),
      ],
      facts: [
        FactSpec(
          'After a CHoCH, further breaks in the new direction are called BOS.',
          true,
          'The new sequence becomes the prevailing one.',
          concept: 'choch_versus_bos',
        ),
        FactSpec(
          'A CHoCH reliably marks the start of a new trend.',
          false,
          'Many are followed by a return to the original direction.',
          concept: 'false_character_changes',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.identifyHigherLow,
          ChartPattern.changeOfCharacterUp,
          110301,
        ),
        ChartTaskSpec(
          ChartTask.identifyLowerHigh,
          ChartPattern.changeOfCharacterDown,
          110302,
        ),
      ],
    ),
    LessonSpec(
      title: 'Displacement',
      subtitle: 'Sudden expansion',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'Displacement is a sharp, one-directional expansion in movement. It is the condition '
          'under which fair value gaps appear.',
      concepts: [
        ConceptSpec(
          'Displacement',
          'A run of candles covering much more ground than recent ones, in one direction.',
          'Measured relative to recent candles on the same chart. It describes urgency that '
              'already showed up in the data.',
        ),
        ConceptSpec(
          'Displacement and gaps',
          'Fast one-directional movement is what leaves areas with no two-sided trade.',
          'When price moves far enough fast enough, the first and third candle of a three-candle '
              'run stop overlapping. That non-overlap is what the next lesson names.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Displacement is measured:',
          [
            'Relative to recent candles on the same chart',
            'Against a fixed point value',
            'Against yesterday\'s range',
            'By counting candles',
          ],
          0,
          'Like all size judgements, it is local and relative.',
          concept: 'displacement',
        ),
        QuizSpec(
          'What does displacement create structurally?',
          [
            'Areas that price passed through with little two-sided trading',
            'Support',
            'A range',
            'Equal highs',
          ],
          0,
          'Fast one-directional movement is what leaves non-overlapping candles behind.',
          concept: 'displacement_and_gaps',
        ),
        QuizSpec(
          'Displacement tells you:',
          [
            'That movement expanded — not what follows',
            'That a trend has started',
            'That a reversal is near',
            'That volume spiked',
          ],
          0,
          'It is a description of what already printed.',
          concept: 'displacement',
        ),
      ],
      facts: [
        FactSpec(
          'Displacement is a description of movement that already occurred.',
          true,
          'Like every other reading in this app.',
          concept: 'displacement',
        ),
        FactSpec(
          'Displacement guarantees continuation.',
          false,
          'Sharp moves reverse as often as they extend.',
          concept: 'displacement_and_gaps',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.tapLargestBody,
          ChartPattern.fairValueGapUp,
          110401,
        ),
      ],
    ),
    LessonSpec(
      title: 'Fair Value Gaps',
      subtitle: 'Three candles that do not overlap',
      minutes: 6,
      difficulty: Difficulty.expert,
      intro:
          'A fair value gap is a precisely defined area: three consecutive candles where the '
          'first and third do not share any price.',
      concepts: [
        ConceptSpec(
          'Fair value gap',
          'An area between candle 1 and candle 3 of a three-candle run with no overlap.',
          'For a bullish FVG: the high of candle 1 is below the low of candle 3. The area between '
              'them is price that was passed through in one direction with no two-sided trade.',
        ),
        ConceptSpec(
          'Drawing an FVG',
          'The exact boundaries of the area.',
          'Top is the low of candle 3, bottom is the high of candle 1, for a bullish gap. The '
              'definition is mechanical, which is one of the things that makes the concept '
              'usable — two people marking the same chart get the same area.',
        ),
        ConceptSpec(
          'What it does not mean',
          'The honest limits of the idea.',
          '"Gaps get filled" is a claim about the future. Many do; many do not. What you can say '
              'is that the area was crossed quickly and one-sidedly, which makes it a reference '
              'point some traders watch.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A bullish fair value gap exists when:',
          [
            'The high of candle 1 is below the low of candle 3',
            'Three green candles appear in a row',
            'A gap opens overnight',
            'Volume triples',
          ],
          0,
          'It is defined entirely by non-overlap between the first and third candle.',
          concept: 'fair_value_gap',
        ),
        QuizSpec(
          'Where is the top of a bullish fair value gap?',
          [
            'The low of candle 3',
            'The high of candle 3',
            'The close of candle 2',
            'The high of candle 1',
          ],
          0,
          'Top is candle 3\'s low; bottom is candle 1\'s high.',
          concept: 'drawing_an_fvg',
        ),
        QuizSpec(
          'What can you honestly say about a fair value gap?',
          [
            'Price crossed that area quickly and one-sidedly',
            'Price will return to it',
            'It will be filled',
            'It marks a reversal point',
          ],
          0,
          'The first is an observation about the chart. The rest are predictions.',
          concept: 'what_it_does_not_mean',
        ),
      ],
      facts: [
        FactSpec(
          'The boundaries of a fair value gap are mechanically defined.',
          true,
          'Which means two people marking the same chart produce the same area.',
          concept: 'drawing_an_fvg',
        ),
        FactSpec(
          'All fair value gaps eventually get filled.',
          false,
          'Many do not. "Eventually" is not a tradeable statement in any case.',
          concept: 'what_it_does_not_mean',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.selectFairValueGapUp,
          ChartPattern.fairValueGapUp,
          110501,
        ),
        ChartTaskSpec(
          ChartTask.selectFairValueGapDown,
          ChartPattern.fairValueGapDown,
          110502,
        ),
      ],
    ),
    LessonSpec(
      title: 'Order Blocks',
      subtitle: 'The candle before the move',
      minutes: 6,
      difficulty: Difficulty.expert,
      intro:
          'An order block marks the last opposite-direction candle before a strong move. The '
          'definition is simple; the claims made about it often are not.',
      concepts: [
        ConceptSpec(
          'Order block',
          'The last opposite-direction candle before a displacement move.',
          'For a bullish order block: the last down candle before a strong up move. The area '
              'marked is that candle\'s high to low. It identifies where the move began.',
        ),
        ConceptSpec(
          'Why traders watch them',
          'A reference point with a clear invalidation level.',
          'If price returns to the block and you act there, the block\'s far edge gives a tight '
              'invalidation point. That is a concrete benefit, and it does not require believing '
              'anything about why the area matters.',
        ),
        ConceptSpec(
          'The unsupported version',
          'Claims about institutional orders sitting in the area.',
          'Stories about large unfilled orders resting in an order block are not observable from '
              'a chart. The defensible version is simply: this is where the move started, and it '
              'gives a definable risk point.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A bullish order block is:',
          [
            'The last down candle before a strong up move',
            'The largest up candle',
            'The first up candle of a trend',
            'Any candle at a swing low',
          ],
          0,
          'It marks the origin of the displacement.',
          concept: 'order_block',
        ),
        QuizSpec(
          'What is the defensible reason to mark an order block?',
          [
            'It gives a reference point with a tight, definable invalidation level',
            'Institutions have unfilled orders there',
            'Price must react to it',
            'It is where the market maker is positioned',
          ],
          0,
          'The risk benefit is real and observable. The rest is not.',
          concept: 'why_traders_watch_them',
        ),
        QuizSpec(
          'Why are claims about institutional orders in an order block unsupported?',
          [
            'Nothing on a chart reveals who placed which orders',
            'Institutions do not trade',
            'Order blocks are not real',
            'They are supported',
          ],
          0,
          'The chart shows price and volume. It does not show participants.',
          concept: 'the_unsupported_version',
        ),
      ],
      facts: [
        FactSpec(
          'An order block provides a tight invalidation level if price returns to it.',
          true,
          'That is its concrete, defensible use.',
          concept: 'why_traders_watch_them',
        ),
        FactSpec(
          'A chart shows which participants placed which orders.',
          false,
          'It shows price and volume. Participant identity is not visible.',
          concept: 'the_unsupported_version',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.selectOrderBlockUp,
          ChartPattern.orderBlockUp,
          110601,
        ),
      ],
    ),
    LessonSpec(
      title: 'Confluence',
      subtitle: 'Several observations, one area',
      minutes: 5,
      difficulty: Difficulty.expert,
      intro:
          'Confluence means multiple separate observations pointing at the same area. It is worth '
          'understanding both what it adds and what it does not.',
      concepts: [
        ConceptSpec(
          'Confluence',
          'Several independent observations coinciding at one area.',
          'A prior swing high, a fair value gap and a range boundary all at the same area is more '
              'notable than any one of them alone. More reasons to look, not a probability.',
        ),
        ConceptSpec(
          'False confluence',
          'Counting related observations as if they were independent.',
          'A swing high, the resistance drawn from it and the range boundary it forms are often '
              'the same observation counted three times. Three names for one thing is not '
              'confluence.',
        ),
        ConceptSpec(
          'Confluence and size',
          'Whether more reasons should mean a bigger position.',
          'Increasing size on confluence means increasing risk on a feeling of certainty. The '
              'risk rule from World 8 does not have an exception for charts that look convincing.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A swing high, the resistance drawn from it, and the range boundary it forms. How many '
              'independent observations is that?',
          ['One', 'Three', 'Two', 'Four'],
          0,
          'They are three names for the same price event.',
          concept: 'false_confluence',
        ),
        QuizSpec(
          'Should a high-confluence setup get a larger position?',
          [
            'No — the risk rule does not have an exception for convincing charts',
            'Yes, double it',
            'Yes, proportionally to the number of reasons',
            'Only on higher timeframes',
          ],
          0,
          'Confidence is highest exactly when it is least reliable.',
          concept: 'confluence_and_size',
          mistake: MistakeTag.overRisk,
        ),
        QuizSpec(
          'Confluence honestly provides:',
          [
            'More reason to pay attention to an area',
            'A measurable probability increase',
            'A guarantee',
            'A larger expected return',
          ],
          0,
          'Several observations landing on one area is a reason to look harder at it. It does '
              'not convert into a measurable chance of anything happening.',
          concept: 'confluence',
        ),
      ],
      facts: [
        FactSpec(
          'Three names for the same price event count as three confluences.',
          false,
          'They are one observation described three ways.',
          concept: 'false_confluence',
        ),
        FactSpec(
          'Position size should stay the same regardless of how convincing a setup looks.',
          true,
          'The risk rule has no exception for confidence.',
          concept: 'confluence_and_size',
        ),
      ],
    ),
    LessonSpec(
      title: 'Multi-Timeframe Context',
      subtitle: 'Where these tools are usually applied',
      minutes: 5,
      difficulty: Difficulty.expert,
      intro:
          'These frameworks are typically used with a higher timeframe for context and a lower '
          'one for the entry. The approach has real trade-offs.',
      concepts: [
        ConceptSpec(
          'Top-down analysis',
          'Reading the higher timeframe first, then descending.',
          'Establish the higher timeframe structure, mark the areas, then drop down to find an '
              'entry with a tight invalidation level. Deciding the order in advance is what stops '
              'it becoming timeframe hopping.',
        ),
        ConceptSpec(
          'Lower timeframe noise',
          'The cost of dropping down for an entry.',
          'A lower timeframe gives a tighter stop and more false signals. You gain size for the '
              'same risk and lose some reliability in the trigger.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What does entering on a lower timeframe gain you?',
          [
            'A tighter invalidation level, so more size for the same risk',
            'A higher probability',
            'Fewer false signals',
            'Lower spreads',
          ],
          0,
          'The gain is arithmetic; the cost is signal reliability.',
          concept: 'lower_timeframe_noise',
        ),
        QuizSpec(
          'What separates top-down analysis from timeframe hopping?',
          [
            'The order is decided before looking, not after seeing the answer you wanted',
            'The number of timeframes used',
            'The instrument',
            'Nothing',
          ],
          0,
          'Pre-commitment is the entire difference.',
          concept: 'top_down_analysis',
        ),
        QuizSpec(
          'In top-down analysis, which comes first?',
          [
            'The higher timeframe structure and areas',
            'The entry trigger',
            'The position size',
            'The target',
          ],
          0,
          'The higher timeframe establishes the structure and the areas that matter; the '
              'lower timeframe is only used afterwards to find an entry inside that picture.',
          concept: 'top_down_analysis',
        ),
      ],
      facts: [
        FactSpec(
          'Entering on a lower timeframe trades signal reliability for a tighter stop.',
          true,
          'Both effects are real and go in opposite directions.',
          concept: 'lower_timeframe_noise',
        ),
        FactSpec(
          'Top-down analysis and timeframe hopping are the same thing.',
          false,
          'One decides the order in advance; the other picks a timeframe to justify a conclusion.',
          concept: 'top_down_analysis',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.decideDirection,
          ChartPattern.changeOfCharacterUp,
          110801,
        ),
      ],
    ),
    LessonSpec(
      title: 'Price Action Mistakes',
      subtitle: 'The failure modes of this world',
      minutes: 5,
      difficulty: Difficulty.expert,
      intro:
          'These tools fail in predictable ways, and almost all of them come from treating a '
          'description as a prediction.',
      concepts: [
        ConceptSpec(
          'Zone stacking',
          'Marking so many areas that price is always inside one.',
          'With enough fair value gaps and order blocks marked, every price is in a zone. At '
              'that point the marking has stopped distinguishing anything.',
        ),
        ConceptSpec(
          'Unfalsifiable reading',
          'A reading that explains every outcome after the fact.',
          'If a reversal proves the framework and a continuation proves it too, the framework is '
              'not saying anything. The test is whether it could have been wrong.',
        ),
        ConceptSpec(
          'Skipping the basics',
          'Using advanced vocabulary without the structure underneath.',
          'An order block inside unreadable structure is a rectangle. These tools sit on top of '
              'World 3 and World 7; they do not replace them.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What is wrong with a chart marked with many zones?',
          [
            'Price is always inside one, so the marking distinguishes nothing',
            'It renders slowly',
            'Zones expire',
            'Nothing',
          ],
          0,
          'A signal that is always on is not a signal.',
          concept: 'zone_stacking',
        ),
        QuizSpec(
          'A framework explains both a reversal and a continuation after the fact. What does that '
              'tell you?',
          [
            'It is not making a testable claim',
            'It is very powerful',
            'It needs more zones',
            'It works on all timeframes',
          ],
          0,
          'Explaining everything means predicting nothing.',
          concept: 'unfalsifiable_reading',
        ),
        QuizSpec(
          'An order block marked on a chart with unreadable structure is:',
          [
            'A rectangle with no context behind it',
            'A high-probability setup',
            'Still valid',
            'Better than one in clear structure',
          ],
          0,
          'These tools sit on top of structure; without it they have nothing to refer to.',
          concept: 'skipping_the_basics',
        ),
      ],
      facts: [
        FactSpec(
          'Advanced price action tools sit on top of market structure rather than replacing it.',
          true,
          'Without readable structure they have no reference.',
          concept: 'skipping_the_basics',
        ),
        FactSpec(
          'A framework that explains every outcome afterwards is a strong one.',
          false,
          'It is one that makes no testable claim.',
          concept: 'unfalsifiable_reading',
        ),
      ],
      extras: [
        SpotMistakeSpec(
          'A chart has eleven zones marked. The trader writes: "Price is in a bullish order block '
              'inside a bullish FVG above a demand zone. Maximum confluence, taking a large '
              'position."',
          [
            'With that many zones marked, price is always inside one, and size was increased on confidence',
            'They should have marked more zones',
            'Order blocks and FVGs cannot overlap',
            'The trade direction is wrong',
          ],
          0,
          MistakeTag.overRisk,
          'Two errors compound. Eleven zones means any price is inside several, so "confluence" '
              'here is an artefact of the marking. And size was increased because the chart '
              'looked convincing, which is precisely when it is least reliable.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Price Action Practice',
      subtitle: 'Mark the areas, state the limits',
      minutes: 6,
      difficulty: Difficulty.expert,
      intro: 'Find the structures on unfamiliar charts, and keep the claims about them honest.',
      concepts: [
        ConceptSpec(
          'Marking discipline',
          'Marking only what the mechanical definition produces.',
          'A fair value gap either exists by the three-candle rule or it does not. An order block '
              'is the last opposite candle before displacement or it is not. No judgement, and '
              'therefore no room to see what you want.',
        ),
        ConceptSpec(
          'Stating the limit',
          'Saying what the marking does not tell you.',
          'Getting into the habit of adding "this does not tell me what happens next" is not '
              'false modesty. It is what keeps position sizing honest.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A fair value gap exists when:',
          [
            'The mechanical three-candle condition is met',
            'It looks like one',
            'Price moved quickly',
            'Two candles are large',
          ],
          0,
          'Mechanical definitions leave no room for wishful marking.',
          concept: 'marking_discipline',
        ),
        QuizSpec(
          'Why add "this does not tell me what happens next" to a reading?',
          [
            'It keeps position sizing from drifting with confidence',
            'It is polite',
            'It is required by regulators',
            'It improves accuracy',
          ],
          0,
          'Stated limits are what stop certainty leaking into size.',
          concept: 'stating_the_limit',
        ),
        QuizSpec(
          'Two traders mark the same chart and produce different fair value gaps. What follows?',
          [
            'At least one of them did not apply the mechanical definition',
            'Both are valid readings',
            'The chart data differs',
            'FVGs are subjective',
          ],
          0,
          'The definition is mechanical, so correct application produces the same result.',
          concept: 'marking_discipline',
        ),
      ],
      facts: [
        FactSpec(
          'Correctly applied, the fair value gap definition produces the same area for everyone.',
          true,
          'It is mechanical, not interpretive.',
          concept: 'marking_discipline',
        ),
        FactSpec(
          'Stating what a reading cannot tell you is unnecessary detail.',
          false,
          'It is what stops confidence turning into extra size.',
          concept: 'stating_the_limit',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.selectFairValueGapUp,
          ChartPattern.fairValueGapUp,
          111001,
        ),
        ChartTaskSpec(
          ChartTask.selectOrderBlockUp,
          ChartPattern.orderBlockUp,
          111002,
        ),
        ChartTaskSpec(
          ChartTask.identifyHigherLow,
          ChartPattern.changeOfCharacterUp,
          111003,
        ),
      ],
    ),
  ],
  boss: BossSpec(
    title: 'Price Action Challenge',
    subtitle: 'The vocabulary and its limits',
    difficulty: Difficulty.expert,
    minutes: 9,
    intro:
        'Mark the structures precisely and answer honestly about what they do and do not claim. '
        'Score 80% to unlock Building a Trading Process.',
    charts: [
      ChartTaskSpec(
        ChartTask.selectFairValueGapUp,
        ChartPattern.fairValueGapUp,
        119001,
      ),
      ChartTaskSpec(
        ChartTask.selectFairValueGapDown,
        ChartPattern.fairValueGapDown,
        119002,
      ),
      ChartTaskSpec(
        ChartTask.selectOrderBlockUp,
        ChartPattern.orderBlockUp,
        119003,
      ),
      ChartTaskSpec(
        ChartTask.identifyHigherLow,
        ChartPattern.changeOfCharacterUp,
        119004,
      ),
      ChartTaskSpec(
        ChartTask.classifyTrend,
        ChartPattern.breakOfStructureDown,
        119005,
      ),
    ],
    quizzes: [
      QuizSpec(
        'What separates a CHoCH from a BOS?',
        [
          'Whether the break runs with or against the existing structure',
          'Candle size',
          'Volume',
          'The timeframe',
        ],
        0,
        'Direction relative to the prevailing sequence.',
        concept: 'choch_versus_bos',
      ),
      QuizSpec(
        'Where is the bottom of a bullish fair value gap?',
        [
          'The high of candle 1',
          'The low of candle 1',
          'The low of candle 3',
          'The close of candle 2',
        ],
        0,
        'Bottom is candle 1\'s high; top is candle 3\'s low.',
        concept: 'drawing_an_fvg',
      ),
      QuizSpec(
        'The defensible reason to mark an order block is:',
        [
          'It gives a tight, definable invalidation level on a return',
          'Institutional orders rest there',
          'Price must react there',
          'It predicts reversals',
        ],
        0,
        'The risk benefit is observable; the rest is not.',
        concept: 'why_traders_watch_them',
      ),
      QuizSpec(
        'A high-confluence setup should be traded with:',
        [
          'The same risk percentage as any other trade',
          'Double size',
          'No stop',
          'Maximum leverage',
        ],
        0,
        'The risk rule has no confidence exception.',
        concept: 'confluence_and_size',
      ),
    ],
    facts: [
      FactSpec(
        'These frameworks describe what price has done rather than predicting what it will do.',
        true,
        'That is the honest description of all of them.',
        concept: 'overclaiming',
      ),
      FactSpec(
        'Marking many zones on a chart improves the analysis.',
        false,
        'Past a small number, price is always inside one and the marking stops distinguishing '
            'anything.',
        concept: 'zone_stacking',
      ),
    ],
  ),
);
