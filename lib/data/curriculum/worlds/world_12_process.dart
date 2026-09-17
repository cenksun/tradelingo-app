import '../../../domain/models/enums.dart';
import '../../../domain/models/skill.dart';
import '../lesson_spec.dart';

/// World 12 — Building a Trading Process.
const WorldSpec world12Process = WorldSpec(
  id: 'w12',
  index: 12,
  title: 'Building a Trading Process',
  subtitle: 'Plans, journals and review',
  description:
      'Turning everything learned so far into a repeatable process: written plans, checklists, '
      'journaling, sample size, expectancy and honest review.',
  primarySkillId: Skills.tradePlanning,
  accentColor: 0xFF2BE5A8,
  lessons: [
    LessonSpec(
      title: 'The Trade Plan',
      subtitle: 'Written before, not after',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'A trade plan is a short written statement made before the position exists. Its value '
          'comes entirely from the fact that it cannot be quietly revised later.',
      concepts: [
        ConceptSpec(
          'Trade plan',
          'A written statement of the idea, the levels and the size, made before entering.',
          'Instrument, direction, reason, entry, stop, target, risk percentage and position size. '
              'Eight fields. If any is missing it will be decided under pressure instead.',
        ),
        ConceptSpec(
          'Pre-commitment',
          'Deciding in advance so the decision is not made under pressure.',
          'The whole point is that the person writing the plan has no position and no exposure. '
              'That person makes better decisions than the one watching it move.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Why does a written plan help even if you would have made the same decision?',
          [
            'It cannot be quietly revised once the position exists',
            'It is required by brokers',
            'It improves the entry price',
            'It increases the win rate',
          ],
          0,
          'Memory rewrites plans to match outcomes. Writing removes that option.',
          concept: 'pre_commitment',
        ),
        QuizSpec(
          'Which field is missing from "long BTC, entry 42,000, stop 41,200, target 44,000"?',
          [
            'The risk percentage and position size',
            'The instrument',
            'The direction',
            'Nothing is missing',
          ],
          0,
          'Without risk and size, the levels do not determine what is actually at stake.',
          concept: 'trade_plan',
        ),
        QuizSpec(
          'A plan is written by:',
          [
            'Someone with no position and no exposure',
            'Someone already in the trade',
            'The broker',
            'It does not matter',
          ],
          0,
          'That is exactly what makes it worth more than an in-the-moment decision.',
          concept: 'pre_commitment',
        ),
      ],
      facts: [
        FactSpec(
          'A plan made before entering is written by someone under less pressure than the person '
              'managing the position.',
          true,
          'Which is why the plan should win the argument.',
          concept: 'pre_commitment',
        ),
        FactSpec(
          'A plan without a position size is complete.',
          false,
          'Without size, the levels do not determine what is at stake.',
          concept: 'trade_plan',
        ),
      ],
      extras: [
        SequenceSpec(
          'Put the steps of building a trade plan in order.',
          [
            'Read the structure on your context timeframe',
            'Identify the level that would invalidate the idea',
            'Place the stop just beyond that level',
            'Identify a plausible structural target',
            'Check whether reward-to-risk justifies the trade',
            'Calculate position size from risk amount and stop distance',
          ],
          'Each step depends on the one before it. Size comes last because it needs the stop '
              'distance, and the go/no-go check comes before size because a failed check means '
              'there is nothing to size.',
          concept: 'trade_plan',
        ),
      ],
    ),
    LessonSpec(
      title: 'Checklists',
      subtitle: 'The same questions every time',
      minutes: 4,
      difficulty: Difficulty.advanced,
      intro:
          'A checklist is not a strategy. It is a way of making sure the strategy you have is '
          'actually applied.',
      concepts: [
        ConceptSpec(
          'Checklist',
          'A fixed set of questions answered before every trade.',
          'Short enough to actually use — five or six items. Each one must have a clear yes or '
              'no answer, otherwise it becomes a place to rationalise.',
        ),
        ConceptSpec(
          'Binary items',
          'Checklist items with unambiguous answers.',
          '"Is the stop beyond the invalidation level?" has an answer. "Does this look good?" '
              'does not, and will always answer yes when you want to trade.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Which is a usable checklist item?',
          [
            '"Is the stop beyond the swing that invalidates the idea?"',
            '"Does the setup look strong?"',
            '"Am I confident?"',
            '"Is the trend my friend?"',
          ],
          0,
          'Only the first has an answer that does not depend on how much you want to trade.',
          concept: 'binary_items',
        ),
        QuizSpec(
          'How long should a checklist be?',
          [
            'Short enough to be used every time — around five or six items',
            'As long as possible',
            'One item',
            'Twenty items',
          ],
          0,
          'A checklist that is skipped provides nothing.',
          concept: 'checklist',
        ),
        QuizSpec(
          'A checklist is:',
          [
            'A way of ensuring the strategy is applied consistently',
            'A strategy',
            'A substitute for analysis',
            'A risk control',
          ],
          0,
          'It enforces application; it does not supply the method.',
          concept: 'checklist',
        ),
      ],
      facts: [
        FactSpec(
          'Checklist items should have unambiguous yes or no answers.',
          true,
          'Ambiguous items become places to rationalise.',
          concept: 'binary_items',
        ),
        FactSpec(
          'A longer checklist is a better checklist.',
          false,
          'Length is what causes it to be skipped.',
          concept: 'checklist',
        ),
      ],
    ),
    LessonSpec(
      title: 'Journaling',
      subtitle: 'A record you cannot argue with',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'Memory is unreliable about trading in a very specific way: it remembers outcomes and '
          'forgets reasoning. A journal fixes that.',
      concepts: [
        ConceptSpec(
          'Journal entry',
          'A record of the plan, the execution and the outcome for one trade.',
          'In this app, every simulated trade creates one automatically, including the levels, '
              'the risk, the R result and the process score. You add the notes.',
        ),
        ConceptSpec(
          'What to record',
          'Plan, deviation and reasoning — not just the result.',
          'The result is the least useful field. Whether you followed the plan, and why not if '
              'you did not, is what a review can actually act on.',
        ),
        ConceptSpec(
          'Reviewing honestly',
          'Reading the record without reinterpreting it.',
          'The temptation after a loss is to decide the plan was wrong. Sometimes it was. Often '
              'the plan was fine and the outcome was simply one of the losses a sound plan '
              'produces.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Which journal field is most useful for improvement?',
          [
            'Whether the plan was followed, and why not if it was not',
            'The profit or loss',
            'The instrument',
            'The time of day',
          ],
          0,
          'Adherence is actionable. The result on a single trade is mostly noise.',
          concept: 'what_to_record',
        ),
        QuizSpec(
          'A trade follows the plan and loses. What should the review conclude?',
          [
            'Probably nothing — sound plans lose regularly',
            'The plan was wrong',
            'The method is broken',
            'Risk should be reduced',
          ],
          0,
          'Changing a method after every loss guarantees you never trade one long enough to '
              'evaluate it.',
          concept: 'reviewing_honestly',
        ),
        QuizSpec(
          'Why is memory unreliable for reviewing trades?',
          [
            'It retains outcomes and loses the reasoning behind decisions',
            'It is fine',
            'It forgets the numbers only',
            'It exaggerates losses only',
          ],
          0,
          'Outcomes are vivid; reasoning fades and gets reconstructed to fit.',
          concept: 'journal_entry',
        ),
      ],
      facts: [
        FactSpec(
          'In TradePath, every completed simulation creates a journal entry automatically.',
          true,
          'Including levels, risk, R result and process score.',
          concept: 'journal_entry',
        ),
        FactSpec(
          'A losing trade means the plan behind it was wrong.',
          false,
          'Sound plans produce losses as a matter of course.',
          concept: 'reviewing_honestly',
        ),
      ],
    ),
    LessonSpec(
      title: 'Sample Size',
      subtitle: 'How many trades before you know anything',
      minutes: 5,
      difficulty: Difficulty.expert,
      intro:
          'The single most common analytical error in trading is drawing conclusions from far too '
          'few trades.',
      concepts: [
        ConceptSpec(
          'Sample size',
          'The number of trades a conclusion rests on.',
          'Ten trades tell you almost nothing. Thirty is still thin. Randomness dominates small '
              'samples completely, which means early results mostly measure luck.',
        ),
        ConceptSpec(
          'Streaks in random data',
          'Long runs occur naturally without any change in method.',
          'A coin flipped a hundred times will usually produce a run of six or seven heads. '
              'Seeing one in your results is not evidence that anything changed.',
        ),
        ConceptSpec(
          'Changing too early',
          'Abandoning a method before the sample means anything.',
          'Switching after every drawdown means every method is evaluated at its worst moment '
              'and none is ever given enough trades to assess.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'After twelve trades you are down. What have you learned about the method?',
          [
            'Almost nothing — the sample is far too small',
            'That it does not work',
            'That it needs adjusting',
            'That the market changed',
          ],
          0,
          'At twelve trades, randomness accounts for almost any result.',
          concept: 'sample_size',
        ),
        QuizSpec(
          'A run of seven losses appears in your results. What does it indicate?',
          [
            'Nothing by itself — runs like this occur naturally',
            'The method has broken',
            'Conditions changed',
            'You should stop trading',
          ],
          0,
          'Streaks of that length occur regularly in random sequences.',
          concept: 'streaks_in_random_data',
        ),
        QuizSpec(
          'What is the cost of switching methods after every drawdown?',
          [
            'Every method is judged at its worst moment and none gets enough trades',
            'Higher commission',
            'Nothing',
            'A lower win rate only',
          ],
          0,
          'You end up with a series of methods, each evaluated on its unluckiest stretch.',
          concept: 'changing_too_early',
        ),
      ],
      facts: [
        FactSpec(
          'Long losing runs occur naturally in random sequences.',
          true,
          'Which is why one is not evidence that something broke.',
          concept: 'streaks_in_random_data',
        ),
        FactSpec(
          'Twenty trades is enough to evaluate a method.',
          false,
          'Randomness still dominates at that sample size.',
          concept: 'sample_size',
        ),
      ],
    ),
    LessonSpec(
      title: 'Expectancy',
      subtitle: 'The average R per trade',
      minutes: 5,
      difficulty: Difficulty.expert,
      intro: 'Expectancy combines hit rate and average win size into one number, expressed in R.',
      concepts: [
        ConceptSpec(
          'Expectancy',
          'The average R result per trade across a sample.',
          'Expectancy = (hit rate × average win in R) − (loss rate × average loss in R). A '
              'positive number means the average trade gained more than it lost, over that '
              'sample.',
        ),
        ConceptSpec(
          'Hit rate is not enough',
          'A high win rate can still lose money.',
          'Winning 80% of the time at +0.2R and losing 20% at −1R gives an expectancy of '
              '+0.16 − 0.20 = −0.04R. The win rate looks excellent and the account shrinks.',
        ),
      ],
      quizzes: [
        QuizSpec(
          '60% hit rate, average win +1R, average loss −1R. What is the expectancy?',
          ['+0.2R', '+0.6R', '−0.2R', '+1.0R'],
          0,
          '(0.6 × 1) − (0.4 × 1) = 0.2R per trade.',
          concept: 'expectancy',
        ),
        QuizSpec(
          '80% hit rate, average win +0.2R, average loss −1R. What is the expectancy?',
          ['−0.04R', '+0.16R', '+0.8R', '+0.6R'],
          0,
          '(0.8 × 0.2) − (0.2 × 1) = 0.16 − 0.20 = −0.04R. A losing method with a great win rate.',
          concept: 'hit_rate_is_not_enough',
        ),
        QuizSpec(
          'Why is win rate alone a poor measure?',
          [
            'It ignores how large the wins are relative to the losses',
            'It is hard to calculate',
            'It changes daily',
            'It is not poor',
          ],
          0,
          'Size and frequency both matter, and only expectancy combines them.',
          concept: 'hit_rate_is_not_enough',
        ),
      ],
      facts: [
        FactSpec(
          'A method with an 80% win rate can still lose money.',
          true,
          'If the losses are large enough relative to the wins.',
          concept: 'hit_rate_is_not_enough',
        ),
        FactSpec(
          'Positive expectancy means the next trade will be a winner.',
          false,
          'It is an average across a sample, not a statement about any single trade.',
          concept: 'expectancy',
        ),
      ],
      extras: [
        RiskCalcSpec(
          'A method has a 40% hit rate, average win +3R and average loss −1R. What is the '
              'expectancy in R?',
          0.6,
          '(0.4 × 3) − (0.6 × 1) = 1.2 − 0.6 = +0.6R per trade.',
          concept: 'expectancy',
        ),
      ],
    ),
    LessonSpec(
      title: 'Backtesting',
      subtitle: 'Testing against history, honestly',
      minutes: 5,
      difficulty: Difficulty.expert,
      intro:
          'Backtesting means applying rules to past data. Done carelessly it produces confidence '
          'with no basis at all.',
      concepts: [
        ConceptSpec(
          'Backtesting',
          'Applying a fixed set of rules to historical data.',
          'The rules must be fixed before the test. Adjusting them as you go turns the exercise '
              'into a search for the settings that happened to work on that data.',
        ),
        ConceptSpec(
          'Look-ahead bias',
          'Accidentally using information that was not available at the time.',
          'Scrolling a chart while knowing what came next is the most common form. This app '
              'prevents it structurally: future candles are not present in the simulator state '
              'until the replay reveals them.',
        ),
        ConceptSpec(
          'Curve fitting',
          'Tuning rules until they fit one particular dataset.',
          'A rule with six parameters can be made to fit almost any history. It will usually '
              'perform far worse on data it was not tuned on.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What is look-ahead bias?',
          [
            'Using information in a test that was not available at the time',
            'Testing on too little data',
            'Trading too early',
            'Using the wrong timeframe',
          ],
          0,
          'It makes historical results meaningless because the decisions could not have been '
              'made in real time.',
          concept: 'look_ahead_bias',
        ),
        QuizSpec(
          'How does TradePath prevent look-ahead bias?',
          [
            'Future candles are not present in the simulator state until the replay reveals them',
            'By showing a warning',
            'By blurring the right side of the chart',
            'It does not',
          ],
          0,
          'Hiding it structurally is the only version that actually works.',
          concept: 'look_ahead_bias',
        ),
        QuizSpec(
          'A rule set with many parameters that fits history perfectly is:',
          [
            'Likely curve fitted to that particular data',
            'A strong method',
            'Ready to trade',
            'Proof of an edge',
          ],
          0,
          'Enough parameters will fit any dataset, including a random one.',
          concept: 'curve_fitting',
        ),
      ],
      facts: [
        FactSpec(
          'Backtest rules should be fixed before the test begins.',
          true,
          'Otherwise the test becomes a search for whatever fits.',
          concept: 'backtesting',
        ),
        FactSpec(
          'A perfect fit to historical data indicates a strong method.',
          false,
          'It usually indicates curve fitting.',
          concept: 'curve_fitting',
        ),
      ],
    ),
    LessonSpec(
      title: 'Overtrading',
      subtitle: 'Too many trades, too little reason',
      minutes: 5,
      difficulty: Difficulty.expert,
      intro:
          'Overtrading is taking positions that do not meet your own criteria. It is the most '
          'common way a workable method produces losses.',
      concepts: [
        ConceptSpec(
          'Overtrading',
          'Taking trades that do not meet your stated conditions.',
          'The measure is not the number of trades. It is the proportion that met the criteria '
              'you wrote down. Twenty trades that all qualified is not overtrading; three that '
              'did not is.',
        ),
        ConceptSpec(
          'Boredom and revenge',
          'The two most common triggers.',
          'Boredom produces trades on charts with nothing happening. Revenge produces oversized '
              'trades immediately after losses. Both are identifiable in a journal afterwards.',
        ),
        ConceptSpec(
          'Cost accumulation',
          'Every unnecessary trade pays the spread and carries full risk.',
          'Ten unnecessary trades at 1% risk each is a 10% exposure taken for no reason. The '
              'spread is paid on all of them regardless of outcome.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'How is overtrading actually measured?',
          [
            'By the proportion of trades that met your stated criteria',
            'By the number of trades per day',
            'By total volume',
            'By time spent at the screen',
          ],
          0,
          'Frequency alone says nothing without knowing whether the trades qualified.',
          concept: 'overtrading',
        ),
        QuizSpec(
          'Ten unnecessary trades at 1% risk each represents:',
          [
            'About 10% of the account exposed for no reason, plus spread on each',
            '1% of risk',
            'No risk, since they were small',
            'Only the spread cost',
          ],
          0,
          'Each one carries full risk whether or not it was justified.',
          concept: 'cost_accumulation',
        ),
        QuizSpec(
          'A trade taken immediately after a loss, in larger size, is usually:',
          [
            'A revenge trade, identifiable in the journal',
            'A high conviction trade',
            'Good use of momentum',
            'Nothing unusual',
          ],
          0,
          'The size came from the previous loss, not from the setup.',
          concept: 'boredom_and_revenge',
          mistake: MistakeTag.impulsiveTrade,
        ),
      ],
      facts: [
        FactSpec(
          'Taking many trades is overtrading by definition.',
          false,
          'Only trades that did not meet your criteria count.',
          concept: 'overtrading',
        ),
        FactSpec(
          'Unnecessary trades carry the same risk as necessary ones.',
          true,
          'The market does not discount positions taken for poor reasons.',
          concept: 'cost_accumulation',
        ),
      ],
    ),
    LessonSpec(
      title: 'Strategy Rules',
      subtitle: 'Writing a method down',
      minutes: 5,
      difficulty: Difficulty.expert,
      intro:
          'A strategy that exists only in your head changes shape to fit whatever just happened. '
          'Writing it down is what makes it a thing that can be tested.',
      concepts: [
        ConceptSpec(
          'Strategy rules',
          'The written conditions that define what you trade.',
          'Instruments, timeframes, structural conditions, entry trigger, stop placement rule, '
              'target rule, risk percentage. Specific enough that someone else could apply them '
              'and get the same trades.',
        ),
        ConceptSpec(
          'The other-person test',
          'Whether someone else could follow your rules and take the same trades.',
          'If they could not, the rules contain judgement you have not written down — which is '
              'where inconsistency lives.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What is the test of a well-written strategy?',
          [
            'Someone else could apply it and take the same trades',
            'It sounds sophisticated',
            'It has many conditions',
            'It works on every chart',
          ],
          0,
          'Specificity is what makes it testable and repeatable.',
          concept: 'the_other_person_test',
        ),
        QuizSpec(
          'Why does an unwritten strategy drift?',
          [
            'It reshapes itself around whatever just happened',
            'Memory fails entirely',
            'Markets change',
            'It does not drift',
          ],
          0,
          'Without a fixed record, every recent outcome quietly adjusts the rules.',
          concept: 'strategy_rules',
        ),
        QuizSpec(
          'A rule reading "enter when the setup looks clean" is:',
          [
            'Not a rule — it contains undefined judgement',
            'Concise and effective',
            'Fine for experienced traders',
            'A valid discretionary rule',
          ],
          0,
          '"Clean" will mean whatever you need it to mean at the time.',
          concept: 'the_other_person_test',
        ),
      ],
      facts: [
        FactSpec(
          'A strategy someone else cannot apply contains unwritten judgement.',
          true,
          'Which is where inconsistency comes from.',
          concept: 'the_other_person_test',
        ),
        FactSpec(
          'Keeping a strategy flexible and unwritten helps you adapt.',
          false,
          'It mostly means the strategy reshapes itself around recent outcomes.',
          concept: 'strategy_rules',
        ),
      ],
      extras: [
        SequenceSpec(
          'Put the steps of a review session in order.',
          [
            'Export or open the trades from the period',
            'Check what proportion followed the written plan',
            'Group the deviations by mistake type',
            'Look for the mistake type that appears most often',
            'Change one rule or habit to address it',
            'Set the sample size before judging whether the change helped',
          ],
          'Reviews work when they end in one specific change and a defined number of trades '
              'before evaluating it. Changing several things at once makes the result '
              'uninterpretable.',
          concept: 'review_process',
        ),
      ],
    ),
    LessonSpec(
      title: 'The Review Process',
      subtitle: 'Turning records into changes',
      minutes: 5,
      difficulty: Difficulty.expert,
      intro:
          'A journal nobody reads is a diary. Review is what turns it into something that changes '
          'behaviour.',
      concepts: [
        ConceptSpec(
          'Review cadence',
          'How often you review, decided in advance.',
          'Weekly or every twenty-five trades are both reasonable. Reviewing after every loss is '
              'not review — it is reacting.',
        ),
        ConceptSpec(
          'One change at a time',
          'Changing a single thing between reviews.',
          'Change three rules at once and you cannot tell which one mattered. One change, a '
              'defined number of trades, then assess.',
        ),
        ConceptSpec(
          'Mistake grouping',
          'Sorting deviations by type rather than by trade.',
          'Fifteen scattered mistakes usually turn out to be three recurring ones. The grouping is '
              'what makes them addressable — which is why this app tags every simulated trade '
              'with a standard mistake type.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Why change only one thing between reviews?',
          [
            'Otherwise you cannot tell which change was responsible',
            'It is less work',
            'Brokers require it',
            'Multiple changes are impossible',
          ],
          0,
          'Attribution requires isolating the variable.',
          concept: 'one_change_at_a_time',
        ),
        QuizSpec(
          'What does grouping mistakes by type reveal?',
          [
            'That many scattered errors are usually a few recurring ones',
            'The most profitable instrument',
            'The best time of day',
            'Nothing useful',
          ],
          0,
          'Grouping turns a long list into a short set of addressable habits.',
          concept: 'mistake_grouping',
        ),
        QuizSpec(
          'Reviewing immediately after every loss is:',
          [
            'Reacting, not reviewing',
            'The best cadence',
            'Required for improvement',
            'Neutral',
          ],
          0,
          'Reviews done in the emotional aftermath of a loss reliably reach the wrong conclusion.',
          concept: 'review_cadence',
        ),
      ],
      facts: [
        FactSpec(
          'TradePath tags simulated trades with standardised mistake types.',
          true,
          'Which is what makes the analytics groupable and the practice targeted.',
          concept: 'mistake_grouping',
        ),
        FactSpec(
          'Changing several rules at once speeds up improvement.',
          false,
          'It makes the result impossible to attribute to any one change.',
          concept: 'one_change_at_a_time',
        ),
      ],
    ),
    LessonSpec(
      title: 'Putting It Together',
      subtitle: 'The whole process, end to end',
      minutes: 7,
      difficulty: Difficulty.expert,
      intro: 'Everything from twelve worlds in one loop: read, plan, size, execute, record, review.',
      concepts: [
        ConceptSpec(
          'The loop',
          'Read, plan, size, execute, record, review, adjust.',
          'Each step feeds the next and the last feeds back to the first. Missing any one of them '
              'breaks the chain — most commonly the last two, which is why most traders repeat '
              'the same mistakes.',
        ),
        ConceptSpec(
          'Process over outcome',
          'Judging yourself on the parts you control.',
          'Risk chosen, invalidation defined, plan followed, record kept. These are all within '
              'your control. The result of any individual trade is not.',
        ),
        ConceptSpec(
          'Honest expectations',
          'What study can and cannot deliver.',
          'Study makes your decisions deliberate and consistent. It does not make trading safe, '
              'and it does not make outcomes predictable. Most people who trade with real money '
              'lose it, and nothing in this app changes that.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Which steps do traders most often skip?',
          [
            'Recording and reviewing',
            'Reading and planning',
            'Sizing and executing',
            'None of them',
          ],
          0,
          'Which is exactly why the same mistakes recur.',
          concept: 'the_loop',
        ),
        QuizSpec(
          'Which of these is entirely within your control?',
          [
            'The percentage of the account risked',
            'Whether the trade wins',
            'Where price goes',
            'How far the target is reached',
          ],
          0,
          'Risk chosen is a decision. The rest are outcomes.',
          concept: 'process_over_outcome',
        ),
        QuizSpec(
          'What can studying trading honestly deliver?',
          [
            'More deliberate and consistent decisions',
            'Predictable outcomes',
            'Safety',
            'Guaranteed profit',
          ],
          0,
          'Consistency is available. Certainty is not.',
          concept: 'honest_expectations',
        ),
      ],
      facts: [
        FactSpec(
          'Studying trading makes outcomes predictable.',
          false,
          'It makes decisions deliberate. Outcomes stay uncertain.',
          concept: 'honest_expectations',
        ),
        FactSpec(
          'The review step feeds back into how you read the next chart.',
          true,
          'That feedback is what makes it a loop rather than a list.',
          concept: 'the_loop',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.buildTradeLong,
          ChartPattern.uptrendPullback,
          121001,
        ),
        ChartTaskSpec(
          ChartTask.miniSimulation,
          ChartPattern.breakOfStructureUp,
          121002,
        ),
      ],
    ),
  ],
  boss: BossSpec(
    title: 'Trading Process Challenge',
    subtitle: 'The final challenge',
    difficulty: Difficulty.expert,
    minutes: 10,
    intro:
        'The last boss: plans, sample size, expectancy, review and the honest limits of all of '
        'it. Score 80% to complete the curriculum.',
    charts: [
      ChartTaskSpec(
        ChartTask.buildTradeLong,
        ChartPattern.uptrendPullback,
        129001,
      ),
      ChartTaskSpec(
        ChartTask.buildTradeShort,
        ChartPattern.downtrendPullback,
        129002,
      ),
      ChartTaskSpec(
        ChartTask.miniSimulation,
        ChartPattern.liquiditySweepHigh,
        129003,
      ),
      ChartTaskSpec(
        ChartTask.decideDirection,
        ChartPattern.choppyVolatile,
        129004,
        preferred: TradeDirection.noTrade,
      ),
    ],
    quizzes: [
      QuizSpec(
        '55% hit rate, average win +1R, average loss −1R. Expectancy is:',
        ['+0.1R', '+0.55R', '−0.1R', '+1.0R'],
        0,
        '(0.55 × 1) − (0.45 × 1) = 0.10R per trade.',
        concept: 'expectancy',
      ),
      QuizSpec(
        'After fifteen trades your method is down. The right conclusion is:',
        [
          'The sample is too small to conclude anything',
          'The method fails',
          'Reduce risk immediately',
          'Change strategy',
        ],
        0,
        'Randomness dominates at that sample size.',
        concept: 'sample_size',
      ),
      QuizSpec(
        'Which field in a journal is most actionable?',
        [
          'Whether the plan was followed',
          'The profit or loss',
          'The entry time',
          'The instrument',
        ],
        0,
        'Adherence can be changed; the result of one trade cannot.',
        concept: 'what_to_record',
      ),
      QuizSpec(
        'Why change one rule at a time between reviews?',
        [
          'So the effect can be attributed to that change',
          'To save time',
          'Because rules are expensive',
          'It does not matter',
        ],
        0,
        'Isolating the variable is what makes the review informative.',
        concept: 'one_change_at_a_time',
      ),
      QuizSpec(
        'What is the honest summary of what this curriculum can give you?',
        [
          'More deliberate, more consistent decisions under permanent uncertainty',
          'A reliable income',
          'A predictive edge',
          'Protection from losses',
        ],
        0,
        'Consistency is achievable. Certainty is not, and real trading can lose real money.',
        concept: 'honest_expectations',
      ),
    ],
    extras: [
      SequenceSpec(
        'Put the full trading loop in order.',
        [
          'Read the structure',
          'Write the plan with entry, stop and target',
          'Calculate position size from risk and stop distance',
          'Execute according to the plan',
          'Record the trade and any deviation',
          'Review in batches and change one thing',
        ],
        'Each step supplies what the next one needs, and the last feeds back into the first.',
        concept: 'the_loop',
      ),
      SpotMistakeSpec(
        'A journal entry reads: "Won +3R. Great trade. Risked 12% because I was certain. Moved '
            'the stop twice. Did not write a plan."',
        [
          'The trade is being judged by its result while every part of the process failed',
          'The position was too small',
          '+3R is not a good result',
          'The instrument is missing',
        ],
        0,
        MistakeTag.overRisk,
        'Over-risked, no plan, stop moved twice — and the entry records it as a great trade '
            'because it won. Judging by outcome is how the worst habits get reinforced.',
      ),
    ],
    facts: [
      FactSpec(
        'TradePath is an educational simulation product and does not provide investment advice.',
        true,
        'Simulated results do not indicate future performance, and real trading can lose real '
            'money.',
        concept: 'honest_expectations',
      ),
      FactSpec(
        'A profitable trade proves the process behind it was sound.',
        false,
        'Outcome and process are independent on any single trade.',
        concept: 'process_over_outcome',
      ),
    ],
  ),
);
