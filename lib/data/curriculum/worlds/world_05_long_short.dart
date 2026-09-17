import '../../../domain/models/enums.dart';
import '../../../domain/models/skill.dart';
import '../lesson_spec.dart';

/// World 5 — Long & Short, including the decision not to trade.
const WorldSpec world05LongShort = WorldSpec(
  id: 'w05',
  index: 5,
  title: 'Long & Short',
  subtitle: 'Both directions, and standing aside',
  description:
      'How positions work in each direction, what profit and loss mean before and after closing, '
      'and why no-trade is a real decision.',
  primarySkillId: Skills.longShort,
  accentColor: 0xFFFF9F43,
  lessons: [
    LessonSpec(
      title: 'Going Long',
      subtitle: 'Buying first, selling later',
      minutes: 4,
      intro:
          'A long position profits if price rises. You buy, you hold, you sell. The arithmetic is '
          'simple; what people get wrong is everything around it.',
      concepts: [
        ConceptSpec(
          'Long position',
          'An open position that gains when price rises.',
          'You buy at one price and aim to sell higher. Until you sell, the gain or loss is '
              'unrealised — it exists on screen, not in your balance.',
        ),
        ConceptSpec(
          'Entry',
          'The price at which a position opens.',
          'Entry is not where you decided; it is where you were filled. The two differ whenever '
              'the market moves between decision and execution.',
        ),
        ConceptSpec(
          'Exit',
          'The price at which a position closes.',
          'Every position has exactly one entry and one exit. The exit is what turns a screen '
              'number into an actual result.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'You go long at 100 and price is now 108. What do you have?',
          [
            'An unrealised gain of 8 per unit',
            'A realised gain of 8 per unit',
            'Nothing until price reaches your target',
            'A gain you can no longer lose',
          ],
          0,
          'Nothing is realised until the position closes. An unrealised gain can shrink or '
              'become a loss.',
          optionFeedback: {
            3: 'Unrealised gains disappear regularly. Only a closed position is settled.',
          },
          concept: 'long_position',
        ),
        QuizSpec(
          'Why can your entry price differ from the price you saw when deciding?',
          [
            'The market moves between the decision and the fill',
            'Brokers adjust prices',
            'Charts are delayed by design',
            'It cannot differ',
          ],
          0,
          'You are filled at what is available when your order reaches the market, which is what '
              'slippage measures.',
          concept: 'entry',
        ),
        QuizSpec(
          'A long position gains when:',
          [
            'Price rises above the entry',
            'Volume rises',
            'Price falls',
            'The trend is up',
          ],
          0,
          'Direction relative to your entry is what decides, nothing else.',
          concept: 'long_position',
        ),
      ],
      facts: [
        FactSpec(
          'An unrealised gain is already yours.',
          false,
          'It only becomes yours when the position closes.',
          concept: 'long_position',
        ),
        FactSpec(
          'Every position has exactly one entry and one exit.',
          true,
          'Partial closes are simply several smaller positions treated separately.',
          concept: 'exit',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.decideDirection, ChartPattern.uptrend, 50101),
      ],
    ),
    LessonSpec(
      title: 'Going Short',
      subtitle: 'Selling first, buying later',
      minutes: 5,
      intro:
          'A short position profits if price falls. The order is reversed: you sell first and buy '
          'back later. It feels strange until you have done it once.',
      concepts: [
        ConceptSpec(
          'Short position',
          'An open position that gains when price falls.',
          'You sell something you have borrowed, then buy it back to return it. If you sold at '
              '100 and buy back at 90, the difference is your gain.',
        ),
        ConceptSpec(
          'Borrowing',
          'The mechanism that makes selling first possible.',
          'You cannot sell what you do not have, so it is borrowed from someone who does, '
              'usually via the broker. Borrowing has a cost, and in extreme cases the lender can '
              'demand it back.',
        ),
        ConceptSpec(
          'Asymmetric exposure',
          'A long can lose at most its entry price; a short has no fixed upper limit.',
          'Price cannot fall below zero, so a long has a floor. Price has no ceiling, so a short '
              'has no equivalent cap. This is a genuine structural difference and a reason stops '
              'matter especially on shorts.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'You short at 100 and buy back at 90. What happened?',
          [
            'You gained 10 per unit',
            'You lost 10 per unit',
            'You broke even',
            'It depends on the trend',
          ],
          0,
          'Sold high, bought back lower. The difference is the gain.',
          concept: 'short_position',
        ),
        QuizSpec(
          'Why is the theoretical loss on a short unbounded?',
          [
            'Price has no upper limit, while a long is bounded below by zero',
            'Shorts always use leverage',
            'Borrowing costs compound forever',
            'It is not unbounded',
          ],
          0,
          'A long can lose 100% at most. A short can lose more than the position was worth if '
              'price multiplies.',
          concept: 'asymmetric_exposure',
        ),
        QuizSpec(
          'What makes selling before owning possible?',
          [
            'The asset is borrowed, usually through the broker',
            'The exchange creates new units',
            'The order is simulated until closed',
            'It is not possible',
          ],
          0,
          'Borrowing is the mechanism, and it carries a cost.',
          concept: 'borrowing',
        ),
      ],
      facts: [
        FactSpec(
          'A short position has a theoretically unlimited loss.',
          true,
          'There is no ceiling on price, which is exactly why a stop matters on a short.',
          concept: 'asymmetric_exposure',
        ),
        FactSpec(
          'Shorting requires no borrowing at all.',
          false,
          'Selling something you do not own requires borrowing it, and that has a cost.',
          concept: 'borrowing',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.decideDirection, ChartPattern.downtrend, 50201),
      ],
    ),
    LessonSpec(
      title: 'Realised and Unrealised',
      subtitle: 'Screen numbers versus settled results',
      minutes: 4,
      intro: 'The distinction sounds pedantic until an unrealised gain turns into a realised loss.',
      concepts: [
        ConceptSpec(
          'Unrealised P&L',
          'The gain or loss on a position that is still open.',
          'It changes with every tick and is not settled. Treating it as money already earned is '
              'one of the most reliable ways to hold a losing position too long.',
        ),
        ConceptSpec(
          'Realised P&L',
          'The gain or loss locked in when a position closes.',
          'This is the number that actually changes your balance. Everything a journal analyses '
              'is built from realised results.',
        ),
        ConceptSpec(
          'Equity',
          'Balance plus the unrealised result of open positions.',
          'Equity is what your account is worth right now if everything closed at current '
              'prices. Drawdown is measured on equity, which is why it can look worse than the '
              'balance suggests.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Balance is \$10,000 and an open position shows −\$400. What is equity?',
          [
            r'$9,600',
            r'$10,000',
            r'$10,400',
            'Undefined until the position closes',
          ],
          0,
          'Equity is balance plus unrealised result: 10,000 − 400.',
          concept: 'equity',
        ),
        QuizSpec(
          'Why is treating unrealised gains as earned a problem?',
          [
            'It encourages holding positions past the point where the idea has failed',
            'It overstates your tax bill',
            'It has no effect',
            'It makes the platform slow',
          ],
          0,
          'Once it feels like your money, giving it back feels like a loss — and people avoid '
              'realising losses.',
          concept: 'unrealised_p_l',
        ),
        QuizSpec(
          'Which number changes your account balance?',
          [
            'Realised P&L',
            'Unrealised P&L',
            'Equity',
            'Both realised and unrealised equally',
          ],
          0,
          'Only closing a position settles anything.',
          concept: 'realised_p_l',
        ),
      ],
      facts: [
        FactSpec(
          'Drawdown is measured on equity rather than on balance alone.',
          true,
          'Which is why open losses count towards it.',
          concept: 'equity',
        ),
        FactSpec(
          'Unrealised profit cannot turn into a realised loss.',
          false,
          'It happens constantly. Nothing is settled until the position closes.',
          concept: 'unrealised_p_l',
        ),
      ],
      extras: [
        RiskCalcSpec(
          'You are long 3 units from 250. Price is now 268. What is the unrealised gain?',
          54,
          '(268 − 250) × 3 = 54. It stays unrealised until you close.',
          concept: 'unrealised_p_l',
        ),
      ],
    ),
    LessonSpec(
      title: 'The No-Trade Decision',
      subtitle: 'Choosing to stay flat',
      minutes: 5,
      intro:
          'Most charts, most of the time, do not offer anything worth acting on. Being able to '
          'say so is a skill this app grades directly.',
      concepts: [
        ConceptSpec(
          'No trade',
          'Deliberately taking no position.',
          'This is a decision with a reason behind it, not the absence of one. In the simulator, '
              'a well-judged no-trade scores as highly as a well-constructed trade.',
        ),
        ConceptSpec(
          'Opportunity cost illusion',
          'Feeling that not trading is losing money.',
          'A trade you did not take cost you nothing. The feeling that it did is what drives '
              'overtrading, and it is strongest right after watching a move you sat out.',
        ),
        ConceptSpec(
          'Selectivity',
          'Acting only on situations that meet your conditions.',
          'Fewer trades with clearer reasoning generally produce a more survivable record than '
              'many trades with vague ones — mostly because each unclear trade still pays the '
              'spread.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'The chart is unclear, structure is mixed and there is no sensible invalidation level. '
              'What is the strongest decision?',
          [
            'No trade',
            'A small long',
            'A small short',
            'Wait five candles then take whichever way it breaks',
          ],
          0,
          'Without an invalidation level there is no way to size the position or define the risk.',
          concept: 'no_trade',
        ),
        QuizSpec(
          'You stand aside and price then moves strongly. What did that cost you?',
          [
            'Nothing — an unrealised opportunity is not a loss',
            r'The full move you missed',
            'Your edge',
            'One position of drawdown',
          ],
          0,
          'You cannot lose money you never risked. The feeling is real; the loss is not.',
          concept: 'opportunity_cost_illusion',
        ),
        QuizSpec(
          'Why does taking many unclear trades tend to erode an account even with a decent win '
              'rate?',
          [
            'Each one still pays the spread and carries full risk',
            'Brokers penalise frequent trading',
            'Win rate falls automatically',
            'It does not erode the account',
          ],
          0,
          'Costs accumulate per trade regardless of how good the reasoning was.',
          concept: 'selectivity',
        ),
      ],
      facts: [
        FactSpec(
          'In this app, a well-judged no-trade can score as highly as a well-constructed trade.',
          true,
          'Process is what gets graded, and choosing not to act is part of process.',
          concept: 'no_trade',
        ),
        FactSpec(
          'Missing a move you did not trade is a financial loss.',
          false,
          'It costs nothing. Treating it as a loss is what causes the next bad trade.',
          concept: 'opportunity_cost_illusion',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.decideDirection,
          ChartPattern.choppyVolatile,
          50401,
          preferred: TradeDirection.noTrade,
        ),
        ChartTaskSpec(
          ChartTask.decideDirection,
          ChartPattern.tightConsolidation,
          50402,
          preferred: TradeDirection.noTrade,
        ),
      ],
    ),
    LessonSpec(
      title: 'Forming a Directional Thesis',
      subtitle: 'Saying what you think and why',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'A thesis is one sentence: what you expect, based on what, and what would prove you '
          'wrong. If you cannot write it, you do not have one.',
      concepts: [
        ConceptSpec(
          'Thesis',
          'A short statement of the reading, the reason and the invalidation.',
          '"Bullish structure with higher lows holding; invalid below the last higher low at '
              '96.40." That is complete: reading, evidence, and the level that ends it.',
        ),
        ConceptSpec(
          'Evidence',
          'The specific chart observations supporting the reading.',
          'Evidence is things you can point at: a sequence of swings, a level tested twice. '
              '"It feels like it wants to go up" is not evidence.',
        ),
        ConceptSpec(
          'Falsifiability',
          'The property of being able to be proven wrong.',
          'A thesis with no invalidation level cannot be wrong, which means it also cannot be '
              'risk-managed. Every plan in this app requires one.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Which is a complete directional thesis?',
          [
            '"Bullish while higher lows hold; invalid below 96.40"',
            '"I think it goes up"',
            '"The chart looks strong"',
            '"Everyone is bullish right now"',
          ],
          0,
          'Only the first names a reading, its condition and the level that ends it.',
          concept: 'thesis',
        ),
        QuizSpec(
          'Why must a thesis be falsifiable?',
          [
            'Without a way to be wrong there is no way to define risk',
            'Brokers require it',
            'It improves accuracy',
            'It does not need to be',
          ],
          0,
          'The invalidation level is what the stop is placed against and what position size is '
              'calculated from.',
          concept: 'falsifiability',
        ),
        QuizSpec(
          'Which of these counts as evidence?',
          [
            'Three consecutive higher lows on the visible chart',
            'A strong feeling about the direction',
            'Other people being bullish',
            'The asset being popular',
          ],
          0,
          'Evidence is something you can point at on the chart.',
          concept: 'evidence',
        ),
      ],
      facts: [
        FactSpec(
          'A thesis without an invalidation level cannot be risk-managed.',
          true,
          'There is nothing to place the stop against or size from.',
          concept: 'falsifiability',
        ),
        FactSpec(
          'Writing the thesis down before entering changes nothing.',
          false,
          'Written theses are much harder to quietly revise after the fact.',
          concept: 'thesis',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.decideDirection,
          ChartPattern.breakOfStructureUp,
          50501,
        ),
      ],
    ),
    LessonSpec(
      title: 'Direction and Structure',
      subtitle: 'Matching the idea to the chart',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro: 'Direction should follow from the structural reading, not the other way round.',
      concepts: [
        ConceptSpec(
          'Alignment with structure',
          'Taking the direction the structure already describes.',
          'Trading longs in bullish structure means the invalidation level is close and the room '
              'to the next high is clear. It does not make the trade work; it makes the plan '
              'coherent.',
        ),
        ConceptSpec(
          'Counter-trend trading',
          'Taking a position against the prevailing structure.',
          'Sometimes justified, always harder: the invalidation is usually further away and the '
              'target is into the direction price has been moving. It is not forbidden — it just '
              'needs a better reason.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Why is a long in bullish structure usually simpler to plan than a short?',
          [
            'The invalidation level is close and the target sits in clear space',
            'It is more likely to be profitable',
            'Spreads are narrower',
            'It requires less capital',
          ],
          0,
          'The plan is more coherent. Probability is not something the structure supplies.',
          optionFeedback: {
            1: 'Structure makes the plan clearer, not the outcome more likely in a measurable way.',
          },
          concept: 'alignment_with_structure',
        ),
        QuizSpec(
          'A counter-trend trade needs:',
          [
            'A stronger reason, because the invalidation is usually further away',
            'A tighter stop',
            'More leverage',
            'A lower timeframe',
          ],
          0,
          'Fighting the structure costs you the proximity of a clean invalidation level.',
          concept: 'counter_trend_trading',
        ),
        QuizSpec(
          'Direction should be chosen:',
          [
            'After reading the structure',
            'Before opening the chart',
            'Based on what you traded last',
            'Based on which way feels overdue',
          ],
          0,
          'Deciding first and reading second is confirmation bias with extra steps.',
          concept: 'alignment_with_structure',
        ),
      ],
      facts: [
        FactSpec(
          'Counter-trend trades are forbidden in this curriculum.',
          false,
          'They are harder to plan, not banned. They need a clearer reason and usually more room.',
          concept: 'counter_trend_trading',
        ),
        FactSpec(
          'Aligning with structure keeps the invalidation level close to the entry.',
          true,
          'Which is what makes risk per unit manageable.',
          concept: 'alignment_with_structure',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.decideDirection,
          ChartPattern.downtrendPullback,
          50601,
        ),
        ChartTaskSpec(
          ChartTask.decideDirection,
          ChartPattern.uptrendPullback,
          50602,
        ),
      ],
    ),
    LessonSpec(
      title: 'Position Basics',
      subtitle: 'Size, exposure and what moves your balance',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'Direction decides whether you gain or lose. Size decides by how much. They are '
          'separate decisions and mixing them up is expensive.',
      concepts: [
        ConceptSpec(
          'Position size',
          'How many units of the instrument you hold.',
          'Size multiplies every price move. Doubling it doubles both the gain and the loss. It '
              'has nothing to do with how confident you feel.',
        ),
        ConceptSpec(
          'Exposure',
          'The total value of the position.',
          r'Ten units at $50 is $500 of exposure. Exposure is not the same as risk: risk depends '
              'on how far price has to move against you before you exit.',
        ),
        ConceptSpec(
          'Per-unit move',
          'What one unit of price movement is worth to your position.',
          'With 4 units held, a 1.00 move is worth 4.00. This is the arithmetic that connects '
              'stop distance to risk amount in World 8.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'You hold 6 units and price moves 2.50 in your favour. What is the unrealised gain?',
          ['15.00', '2.50', '6.00', '8.50'],
          0,
          'Multiply the price move by the number of units held: 6 × 2.50 = 15.00. This is '
              'the per-unit arithmetic that later connects stop distance to risk amount.',
          concept: 'per_unit_move',
        ),
        QuizSpec(
          'Exposure and risk are:',
          [
            'Different — risk depends on the distance to your exit, not the position value',
            'The same thing',
            'Both equal to the account balance',
            'Unrelated to position size',
          ],
          0,
          r'$10,000 of exposure with a stop 1% away risks about $100, not $10,000.',
          concept: 'exposure',
        ),
        QuizSpec(
          'Position size should be decided by:',
          [
            'The stop distance and the amount you are willing to risk',
            'How confident you feel',
            'How much the account can afford to buy',
            'The size of your last trade',
          ],
          0,
          'Size is an output of risk and stop distance, which is exactly what World 8 covers.',
          concept: 'position_size',
        ),
      ],
      facts: [
        FactSpec(
          'Exposure and risk are the same number.',
          false,
          'Risk is bounded by where you exit; exposure is the whole position value.',
          concept: 'exposure',
        ),
        FactSpec(
          'Doubling position size doubles both the potential gain and the potential loss.',
          true,
          'Size is a multiplier on the move, in both directions.',
          concept: 'position_size',
        ),
      ],
      extras: [
        RiskCalcSpec(
          r'You hold 8 units. Price moves 3.25 against you. What is the unrealised loss?',
          26,
          '8 × 3.25 = 26.00 against you.',
          concept: 'per_unit_move',
        ),
      ],
    ),
    LessonSpec(
      title: 'Closing a Position',
      subtitle: 'Exits decide the result',
      minutes: 4,
      difficulty: Difficulty.intermediate,
      intro:
          'The entry gets all the attention. The exit is what actually produces the number in '
          'your journal.',
      concepts: [
        ConceptSpec(
          'Planned exit',
          'An exit decided before the position opened.',
          'Stops and targets are planned exits. Their value is that they were chosen while you '
              'had no position and therefore no pressure.',
        ),
        ConceptSpec(
          'Discretionary exit',
          'An exit decided while the position is open.',
          'Sometimes legitimate — the reason for the trade genuinely disappeared. Often it is '
              'discomfort dressed up as analysis. The journal is what tells the two apart over '
              'time.',
        ),
        ConceptSpec(
          'Plan adherence',
          'Whether the exit matched the plan.',
          'This app tracks adherence separately from the result, because a trade can follow the '
              'plan perfectly and still lose, and vice versa.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Why are planned exits generally more reliable than in-the-moment ones?',
          [
            'They were chosen without an open position creating pressure',
            'They are always closer to the entry',
            'Brokers execute them faster',
            'They cannot be wrong',
          ],
          0,
          'Decisions made under no pressure tend to be more consistent than decisions made under '
              'it.',
          concept: 'planned_exit',
        ),
        QuizSpec(
          'A trade follows the plan exactly and loses. How does this app score it?',
          [
            'Well on process; the loss does not lower the process score by itself',
            'Poorly, because it lost',
            'It is not scored',
            'It depends on the size of the loss',
          ],
          0,
          'Losing while following a sound plan is a normal, expected outcome.',
          concept: 'plan_adherence',
        ),
        QuizSpec(
          'A discretionary exit is legitimate when:',
          [
            'The reason for the trade genuinely disappeared',
            'The position is uncomfortable',
            'You have been in it a while',
            'It has moved in your favour a little',
          ],
          0,
          'Changed information justifies a changed plan. Discomfort does not.',
          concept: 'discretionary_exit',
        ),
      ],
      facts: [
        FactSpec(
          'A trade that follows its plan and loses was a bad trade.',
          false,
          'Sound plans lose regularly. The process and the outcome are separate.',
          concept: 'plan_adherence',
        ),
        FactSpec(
          'Exits are what turn an idea into a recorded result.',
          true,
          'Which is why they deserve as much planning as entries.',
          concept: 'planned_exit',
        ),
      ],
    ),
    LessonSpec(
      title: 'Direction Mistakes',
      subtitle: 'Common ways direction goes wrong',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'Three failure modes cover most directional errors: trading the last candle, needing '
          'to be in, and refusing to consider the other side.',
      concepts: [
        ConceptSpec(
          'Chasing',
          'Entering late because the move already started without you.',
          'Chasing puts the entry far from the invalidation level, so the stop is wide and the '
              'remaining distance to any sensible target is short. The arithmetic is against you '
              'before anything else happens.',
        ),
        ConceptSpec(
          'Needing a position',
          'Trading because you are not in one, rather than because of the chart.',
          'A common pattern after a missed move. The tell is being unable to state the '
              'invalidation level.',
        ),
        ConceptSpec(
          'One-sided reading',
          'Only ever considering one direction.',
          'If you only ever look for longs you will find them everywhere, including on charts '
              'where the structure says the opposite.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What is structurally wrong with chasing an extended move?',
          [
            'The stop is far away and the remaining distance to target is short',
            'It is always unprofitable',
            'Spreads widen during moves',
            'Nothing, if the trend is strong',
          ],
          0,
          'Late entries damage reward-to-risk mechanically, regardless of how the trade turns out.',
          concept: 'chasing',
          mistake: MistakeTag.lateEntry,
        ),
        QuizSpec(
          'What is the clearest tell that you are trading because you want a position?',
          [
            'You cannot state where the idea would be wrong',
            'The position is small',
            'You are on a lower timeframe',
            'The chart is trending',
          ],
          0,
          'A real thesis always includes the invalidation level. Its absence is diagnostic.',
          concept: 'needing_a_position',
        ),
        QuizSpec(
          'How do you counter a one-sided reading habit?',
          [
            'Label the structure before deciding direction',
            'Alternate longs and shorts',
            'Only trade one instrument',
            'Use more indicators',
          ],
          0,
          'Mechanical labelling first gives the chart a chance to contradict your preference.',
          concept: 'one_sided_reading',
        ),
      ],
      facts: [
        FactSpec(
          'Entering late worsens reward-to-risk even when the direction is correct.',
          true,
          'The distance to invalidation grows while the distance to target shrinks.',
          concept: 'chasing',
        ),
        FactSpec(
          'Only looking for one direction is a neutral preference with no cost.',
          false,
          'It produces trades on charts whose structure says the opposite.',
          concept: 'one_sided_reading',
        ),
      ],
      extras: [
        SpotMistakeSpec(
          'A trader misses a large rally, then writes: "I have to get in on the next pullback, '
              'any pullback. I am not missing this twice."',
          [
            'The decision to enter was made before any chart condition existed',
            'They should have used a market order',
            'Pullbacks should not be traded',
            'The position size is not stated',
          ],
          0,
          MistakeTag.impulsiveTrade,
          '"Any pullback" is not a condition — it is a commitment to enter regardless of what '
              'the chart shows. The missed move created the urge; the chart had no say in it.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Direction Practice',
      subtitle: 'Long, short or nothing',
      minutes: 6,
      difficulty: Difficulty.advanced,
      intro:
          'Mixed charts. Some support a direction; several do not. Answering "no trade" on the '
          'unclear ones is the point of the exercise.',
      concepts: [
        ConceptSpec(
          'Decision discipline',
          'Applying the same criteria to every chart.',
          'The criteria are: is the structure readable, is there an invalidation level, and is '
              'there room to a sensible target. If any answer is no, the decision is no trade.',
        ),
        ConceptSpec(
          'Comfort with inaction',
          'Being able to pass on most charts without discomfort.',
          'Most charts, most of the time, do not offer anything. Being at ease with that is '
              'closer to a professional habit than any pattern you could learn.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What are the three checks before taking a direction?',
          [
            'Readable structure, a clear invalidation level, room to a sensible target',
            'Trend, volume, indicator',
            'Timeframe, spread, session',
            'News, sentiment, correlation',
          ],
          0,
          'All three are structural and all three can be checked on the chart in front of you.',
          concept: 'decision_discipline',
        ),
        QuizSpec(
          'Structure is readable and invalidation is clear, but the next structural level is '
              'very close. What now?',
          [
            'No trade — there is no room for a sensible target',
            'Take it with a tighter stop',
            'Take it with a bigger size',
            'Switch to a lower timeframe',
          ],
          0,
          'Two of three checks passing is not enough; the reward side has to work as well.',
          concept: 'decision_discipline',
        ),
        QuizSpec(
          'Passing on most charts is:',
          [
            'Normal and expected',
            'A sign of indecision',
            'A sign the method is broken',
            'Only reasonable for beginners',
          ],
          0,
          'Selectivity is what keeps costs and unclear trades down.',
          concept: 'comfort_with_inaction',
        ),
      ],
      facts: [
        FactSpec(
          'A chart that passes two of the three checks is still a no trade.',
          true,
          'All three have to hold for the plan to be coherent.',
          concept: 'decision_discipline',
        ),
        FactSpec(
          'Frequent no-trade decisions indicate a problem with your method.',
          false,
          'They usually indicate the method is being applied.',
          concept: 'comfort_with_inaction',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.decideDirection, ChartPattern.uptrend, 51001),
        ChartTaskSpec(
          ChartTask.decideDirection,
          ChartPattern.choppyVolatile,
          51002,
          preferred: TradeDirection.noTrade,
        ),
        ChartTaskSpec(
          ChartTask.decideDirection,
          ChartPattern.breakOfStructureDown,
          51003,
        ),
      ],
    ),
  ],
  boss: BossSpec(
    title: 'Direction Challenge',
    subtitle: 'Long, short and the discipline to pass',
    difficulty: Difficulty.advanced,
    minutes: 8,
    intro:
        'Directional decisions across clear and unclear charts, plus the mechanics of long and '
        'short positions. Score 80% to unlock Order Types.',
    charts: [
      ChartTaskSpec(ChartTask.decideDirection, ChartPattern.uptrend, 59001),
      ChartTaskSpec(ChartTask.decideDirection, ChartPattern.downtrend, 59002),
      ChartTaskSpec(
        ChartTask.decideDirection,
        ChartPattern.range,
        59003,
        preferred: TradeDirection.noTrade,
      ),
      ChartTaskSpec(
        ChartTask.decideDirection,
        ChartPattern.choppyVolatile,
        59004,
        preferred: TradeDirection.noTrade,
      ),
      ChartTaskSpec(
        ChartTask.miniSimulation,
        ChartPattern.uptrendPullback,
        59005,
      ),
    ],
    quizzes: [
      QuizSpec(
        'Why is the theoretical loss on a short unbounded?',
        [
          'Price has no upper limit',
          'Shorts always use leverage',
          'Borrow costs compound',
          'It is bounded, at 100%',
        ],
        0,
        'A long is floored at zero; a short has no equivalent ceiling.',
        concept: 'asymmetric_exposure',
      ),
      QuizSpec(
        r'Balance $8,000 with an open position showing +$350. Equity is:',
        [r'$8,350', r'$8,000', r'$7,650', 'Undefined'],
        0,
        'Equity = balance + unrealised result.',
        concept: 'equity',
      ),
      QuizSpec(
        'Which is a complete thesis?',
        [
          '"Bearish while lower highs hold; invalid above 121.80"',
          '"Looks weak to me"',
          '"Shorting because it has run too far"',
          '"Everyone expects a drop"',
        ],
        0,
        'Reading, condition and invalidation level — all three present.',
        concept: 'thesis',
      ),
    ],
    facts: [
      FactSpec(
        'A well-reasoned no-trade decision is graded as a real decision in this app.',
        true,
        'Process is what gets scored, and passing is part of process.',
        concept: 'no_trade',
      ),
      FactSpec(
        'Unrealised profit changes your account balance.',
        false,
        'Balance changes only when a position closes. Until then the gain or loss lives in '
            'equity, where it can still disappear.',
        concept: 'realised_p_l',
      ),
    ],
  ),
);
