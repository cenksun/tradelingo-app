import '../../../domain/models/enums.dart';
import '../../../domain/models/skill.dart';
import '../lesson_spec.dart';

/// World 8 — Risk Management. The most consequential world in the curriculum.
const WorldSpec world08Risk = WorldSpec(
  id: 'w08',
  index: 8,
  title: 'Risk Management',
  subtitle: 'Sizing, R multiples and survival',
  description:
      'Turning a stop distance into a position size, measuring results in R, and understanding '
      'drawdown, leverage and why survival comes before returns.',
  primarySkillId: Skills.riskManagement,
  accentColor: 0xFFFFB648,
  lessons: [
    LessonSpec(
      title: 'Risk Per Trade',
      subtitle: 'Deciding the loss before the trade',
      minutes: 5,
      intro:
          'Risk per trade is the amount you are prepared to lose if the idea fails. It is chosen '
          'in advance, as a share of the account, and it does not change with how confident you '
          'feel.',
      concepts: [
        ConceptSpec(
          'Risk percentage',
          'The share of the account risked on a single trade.',
          'Commonly between 0.5% and 2% in educational material. The exact number matters less '
              'than the fact that it is fixed in advance and applied consistently.',
        ),
        ConceptSpec(
          'Risk amount',
          'The money value of that percentage.',
          r'Risk amount = balance × risk percentage. On a $10,000 account at 1%, that is $100. '
              'This is the number position sizing works from.',
        ),
        ConceptSpec(
          'Fixed fractional risk',
          'Risking the same percentage of the current balance each time.',
          'As the account grows, the amount risked grows with it; as it shrinks, the amount '
              'shrinks. This is what makes a long run of losses survivable: each loss is smaller '
              'than the last in absolute terms.',
        ),
      ],
      quizzes: [
        QuizSpec(
          r'A $10,000 account risking 1% per trade. What is the risk amount?',
          [r'$100', r'$1,000', r'$10', r'$1'],
          0,
          r'Risk amount = balance × risk percentage. $10,000 × 0.01 = $100. This is the '
              'figure position size is calculated from.',
          concept: 'risk_amount',
        ),
        QuizSpec(
          'Why does fixed fractional risk help survive a losing streak?',
          [
            'Each loss is a percentage of a smaller balance, so losses shrink in money terms',
            'It reduces the number of losses',
            'It guarantees recovery',
            'It increases the win rate',
          ],
          0,
          'The account decays rather than collapsing, which leaves capital to continue with.',
          concept: 'fixed_fractional_risk',
        ),
        QuizSpec(
          'Should risk percentage change with how confident you feel about a setup?',
          [
            'No — confidence is not a measurable quantity and varies with mood',
            'Yes, double it on strong setups',
            'Yes, halve it when unsure',
            'Only on higher timeframes',
          ],
          0,
          'Confidence is highest exactly when you are most likely to be overlooking something.',
          concept: 'risk_percentage',
          mistake: MistakeTag.overRisk,
        ),
      ],
      facts: [
        FactSpec(
          'Risk amount is decided before the trade, not after seeing how it goes.',
          true,
          'Afterwards is too late to decide what you were willing to lose.',
          concept: 'risk_amount',
        ),
        FactSpec(
          'A 1% risk means you can only lose 1% of your account in total.',
          false,
          'It is 1% per trade. Ten consecutive losses at 1% cost roughly 9.6% of the account.',
          concept: 'risk_percentage',
        ),
      ],
      extras: [
        RiskCalcSpec(
          r'Balance $25,000, risk 0.8% per trade. What is the risk amount?',
          200,
          r'Risk amount = balance × risk percentage. $25,000 × 0.008 = $200, which is what a '
              'single losing trade should cost at this setting.',
          concept: 'risk_amount',
        ),
      ],
    ),
    LessonSpec(
      title: 'Position Sizing',
      subtitle: 'The one formula that matters',
      minutes: 6,
      intro:
          'Position size is not a judgement call. It falls out of two numbers you already have: '
          'how much you are risking and how far away the stop is.',
      concepts: [
        ConceptSpec(
          'Position size formula',
          'Position size = risk amount ÷ stop distance.',
          r'Risking $100 with a stop 2.00 away gives 50 units. Every part of this is already '
              'decided by the time you calculate it — which is the point.',
          bullets: [
            'Risk amount comes from the balance and your fixed percentage.',
            'Stop distance comes from the chart.',
            'Size is the output, never an input.',
          ],
        ),
        ConceptSpec(
          'Size as an output',
          'Size is calculated, not chosen.',
          'Choosing a size and then finding a stop that fits is the formula run backwards, and it '
              'is how positions end up far larger than intended.',
        ),
        ConceptSpec(
          'Zero stop distance',
          'Entry and stop at the same price.',
          'This makes the formula divide by zero. There is no valid position size, and the '
              'simulator in this app rejects the setup rather than showing an infinite number.',
        ),
      ],
      quizzes: [
        QuizSpec(
          r'Risk amount $150, entry 40.00, stop 37.00. What is the position size?',
          ['50 units', '150 units', '3 units', '450 units'],
          0,
          r'Stop distance is 3.00. $150 ÷ 3.00 = 50 units.',
          concept: 'position_sizing',
        ),
        QuizSpec(
          'The stop moves further away and the risk amount stays fixed. What happens to size?',
          [
            'It decreases',
            'It increases',
            'It stays the same',
            'It depends on direction',
          ],
          0,
          'Size is inversely proportional to stop distance.',
          concept: 'position_sizing',
        ),
        QuizSpec(
          'What is wrong with picking a position size first?',
          [
            'The risk then depends on wherever the stop happens to land',
            'Nothing',
            'It makes the calculation harder',
            'Brokers do not allow it',
          ],
          0,
          'Risk becomes an accident instead of a decision.',
          concept: 'size_as_an_output',
          mistake: MistakeTag.sizingError,
        ),
      ],
      facts: [
        FactSpec(
          'Position size is calculated from risk amount and stop distance.',
          true,
          'Both are known before the trade, so the size is too.',
          concept: 'position_sizing',
        ),
        FactSpec(
          'If entry and stop are the same price, the position size is very large.',
          false,
          'It is undefined. The setup is invalid and this app refuses it.',
          concept: 'zero_stop_distance',
        ),
      ],
      extras: [
        RiskCalcSpec(
          r'Balance $8,000, risk 1.5%, entry 120.00, stop 114.00. How many units?',
          20,
          r'Risk amount = $120. Stop distance = 6.00. $120 ÷ 6.00 = 20 units.',
          concept: 'position_sizing',
        ),
      ],
    ),
    LessonSpec(
      title: 'R Multiples',
      subtitle: 'One unit of risk',
      minutes: 5,
      intro:
          'R is the distance from entry to stop, expressed as a unit. Once results are measured '
          'in R, trades on different instruments and account sizes become comparable.',
      concepts: [
        ConceptSpec(
          'R',
          'One unit of risk — the money lost if the stop is hit.',
          r'If you risk $100, then 1R is $100. A loss at the stop is −1R by definition, whatever '
              'the instrument or the position size was.',
        ),
        ConceptSpec(
          'R multiple',
          'A trade result expressed in units of R.',
          r'A $250 gain on a $100 risk is +2.5R. This strips out account size and instrument, '
              'leaving only how much was made relative to what was risked.',
        ),
        ConceptSpec(
          'Expectancy',
          'The average R result across many trades.',
          'Positive expectancy means the average trade gains more than it loses in R terms. It '
              'needs a large sample to mean anything, and it says nothing about any individual '
              'trade.',
        ),
      ],
      quizzes: [
        QuizSpec(
          r'You risked $200 and made $500. What is the R multiple?',
          ['+2.5R', '+500R', '+0.4R', '+2R'],
          0,
          r'An R multiple is the result divided by the amount risked: $500 ÷ $200 = 2.5, so '
              'the trade returned two and a half times what it put at risk.',
          concept: 'r_multiple',
        ),
        QuizSpec(
          'A trade stopped out exactly at the stop is:',
          ['−1R', '−100R', '0R', 'Depends on the instrument'],
          0,
          'By definition, the stop is 1R away.',
          concept: 'r',
        ),
        QuizSpec(
          'Why measure results in R rather than money?',
          [
            'It makes trades comparable across instruments and account sizes',
            'It avoids tax',
            'It is easier to calculate',
            'Brokers require it',
          ],
          0,
          r'A $50 gain means nothing without knowing what was risked to get it.',
          concept: 'r_multiple',
        ),
      ],
      facts: [
        FactSpec(
          'A loss at the stop is always −1R, whatever the instrument.',
          true,
          'That is what makes R a common unit.',
          concept: 'r',
        ),
        FactSpec(
          'Positive expectancy means the next trade will be profitable.',
          false,
          'It is an average over many trades and says nothing about any single one.',
          concept: 'expectancy',
        ),
      ],
      extras: [
        RiskCalcSpec(
          r'You risked $120 per trade. Over five trades you had −1R, +2R, −1R, +3R, −1R. What is '
              r'the total result in dollars?',
          240,
          r'Net is +2R. 2 × $120 = $240.',
          concept: 'r_multiple',
        ),
      ],
    ),
    LessonSpec(
      title: 'Reward to Risk',
      subtitle: 'What you stand to gain per unit risked',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'Reward-to-risk ties the target back to the stop. It decides how often you need to be '
          'right for the approach to hold up.',
      concepts: [
        ConceptSpec(
          'Reward-to-risk ratio',
          'Reward distance divided by risk distance.',
          'A 3.00 ratio means the target is three times as far as the stop. It is planned, not '
              'realised: the trade still has to reach the target.',
        ),
        ConceptSpec(
          'Break-even hit rate',
          'The win rate needed to break even at a given ratio.',
          'At 1:1 you need to be right more than half the time. At 2:1, roughly a third. At 3:1, '
              'a quarter. Higher ratios buy tolerance for being wrong.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'At 3:1 reward-to-risk, roughly what hit rate breaks even (ignoring costs)?',
          ['About 25%', 'About 50%', 'About 75%', 'About 10%'],
          0,
          'One win of 3R covers three losses of 1R, so one in four breaks even.',
          concept: 'break_even_hit_rate',
        ),
        QuizSpec(
          'A ratio of 1:1 requires what to be profitable?',
          [
            'Winning more than half the time, plus enough to cover costs',
            'Winning a quarter of the time',
            'Nothing — it is break-even by design',
            'Winning 10% of the time',
          ],
          0,
          'Equal reward and risk means the hit rate has to carry the whole result.',
          concept: 'break_even_hit_rate',
        ),
        QuizSpec(
          'The reward-to-risk ratio you calculate before entering is:',
          [
            'Planned — the trade still has to reach the target',
            'Guaranteed',
            'The realised result',
            'Irrelevant once in the trade',
          ],
          0,
          'Planned and realised ratios differ whenever the target is not reached.',
          concept: 'reward_to_risk_ratio',
        ),
      ],
      facts: [
        FactSpec(
          'A higher reward-to-risk ratio lowers the hit rate needed to break even.',
          true,
          'Which is the main practical reason to care about it.',
          concept: 'break_even_hit_rate',
        ),
        FactSpec(
          'A planned 3:1 ratio means the trade will return 3R.',
          false,
          'It returns 3R only if the target fills.',
          concept: 'reward_to_risk_ratio',
        ),
      ],
      extras: [
        RiskRewardSpec(
          'Long: entry 1,850, stop 1,820, target 1,940. What is the reward-to-risk ratio?',
          1850,
          1820,
          1940,
          TradeDirection.long,
          'Risk 30, reward 90, ratio 3.00.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Drawdown',
      subtitle: 'The cost of getting back to even',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'Losses and the gains needed to recover them are not symmetrical, and the gap widens '
          'fast.',
      concepts: [
        ConceptSpec(
          'Drawdown',
          'The fall from an equity peak to a subsequent low.',
          'Always measured from the highest point reached. It is the number that decides whether '
              'an approach can be followed in practice, not just on paper.',
        ),
        ConceptSpec(
          'Recovery asymmetry',
          'The gain needed to recover a loss is larger than the loss itself.',
          'Lose 10% and you need 11.1% to get back. Lose 50% and you need 100%. At 90%, you need '
              '900%. This is why avoiding deep drawdowns matters more than capturing large gains.',
          bullets: [
            '−10% needs +11.1%',
            '−25% needs +33.3%',
            '−50% needs +100%',
            '−75% needs +300%',
          ],
        ),
      ],
      quizzes: [
        QuizSpec(
          'You lose 50% of your account. What gain returns you to the starting balance?',
          ['100%', '50%', '75%', '150%'],
          0,
          'Half of the capital has to double to restore the whole.',
          concept: 'recovery_asymmetry',
        ),
        QuizSpec(
          'Why does recovery asymmetry argue for small risk per trade?',
          [
            'Shallow drawdowns are recoverable; deep ones may not be in practice',
            'It increases the win rate',
            'It reduces the spread',
            'It has no bearing on risk per trade',
          ],
          0,
          'Keeping the worst case shallow is what keeps recovery realistic.',
          concept: 'drawdown',
        ),
        QuizSpec(
          'An account goes 10,000 → 14,000 → 11,200. What is the drawdown?',
          ['20%', '12%', '28%', 'None'],
          0,
          '2,800 from a 14,000 peak is 20%.',
          concept: 'drawdown',
        ),
      ],
      facts: [
        FactSpec(
          'Recovering a 25% loss requires a 25% gain.',
          false,
          'It requires 33.3%. The base you are growing from is smaller.',
          concept: 'recovery_asymmetry',
        ),
        FactSpec(
          'Drawdown is measured from the peak of the equity curve.',
          true,
          'Which is why it captures the worst experience along the way.',
          concept: 'drawdown',
        ),
      ],
      extras: [
        RiskCalcSpec(
          r'An account peaks at $20,000 and falls to $16,000. What percentage drawdown is that?',
          20,
          r'Drawdown runs from the equity peak: the $4,000 fall is measured against the '
              r'$20,000 high, which gives 20%.',
          concept: 'drawdown',
        ),
      ],
    ),
    LessonSpec(
      title: 'Consecutive Losses',
      subtitle: 'Streaks are normal',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'A run of losses is not evidence that something is broken. It is an ordinary '
          'consequence of a hit rate below 100%.',
      concepts: [
        ConceptSpec(
          'Losing streak',
          'A run of consecutive losing trades.',
          'At a 50% hit rate, six losses in a row will happen regularly over a few hundred '
              'trades. Planning for it is what keeps it survivable.',
        ),
        ConceptSpec(
          'Risk of ruin',
          'The chance of losing so much that continuing is impossible.',
          'It rises steeply with risk per trade. At 1% per trade a ten-loss streak costs about '
              '10% of the account. At 10% per trade the same streak costs about 65%. The streak '
              'is the same; the consequence is not.',
        ),
        ConceptSpec(
          'Tilt',
          'Increasing risk to recover losses quickly.',
          'This is the behaviour that converts a survivable drawdown into an unrecoverable one. '
              'It feels like decisiveness and behaves like a final bet.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Six losses in a row at a 50% hit rate means:',
          [
            'Nothing unusual — streaks like this are expected',
            'The method has stopped working',
            'The market has changed',
            'You should double the next size',
          ],
          0,
          'Streaks of that length occur routinely across a few hundred trades.',
          concept: 'losing_streak',
        ),
        QuizSpec(
          'Ten consecutive losses at 1% per trade costs roughly:',
          [
            'About 10% of the account',
            'About 65%',
            'About 1%',
            'The whole account',
          ],
          0,
          'Each loss is 1% of a slightly smaller balance, so the total is just under 10%.',
          concept: 'risk_of_ruin',
        ),
        QuizSpec(
          'What does increasing risk after losses do to risk of ruin?',
          [
            'Raises it sharply, because the losses are now larger from a smaller base',
            'Lowers it by recovering faster',
            'Leaves it unchanged',
            'Depends on the instrument',
          ],
          0,
          'You are betting more of less, which is the shortest route to being unable to continue.',
          concept: 'tilt',
          mistake: MistakeTag.overRisk,
        ),
      ],
      facts: [
        FactSpec(
          'Losing streaks are a normal consequence of a hit rate below 100%.',
          true,
          'They are expected, and a plan should assume they will happen.',
          concept: 'losing_streak',
        ),
        FactSpec(
          'Increasing size after a losing streak is a reasonable way to recover.',
          false,
          'It is the most reliable way to turn a drawdown into a permanent one.',
          concept: 'tilt',
        ),
      ],
    ),
    LessonSpec(
      title: 'Leverage',
      subtitle: 'Borrowed size, unchanged risk rules',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'Leverage lets you control a position larger than your balance. It changes what you can '
          'hold. It does not change how much you should risk.',
      concepts: [
        ConceptSpec(
          'Leverage',
          'Controlling a position larger than your account balance using borrowed funds.',
          '10x leverage on a \$1,000 account allows \$10,000 of exposure. The position moves on '
              'the full \$10,000, so a 1% adverse move costs \$100 — 10% of your balance.',
        ),
        ConceptSpec(
          'Margin',
          'The portion of your balance reserved to support the position.',
          'Margin is collateral, not the cost of the trade. If losses eat into it far enough, the '
              'position is closed for you.',
        ),
        ConceptSpec(
          'Liquidation',
          'A forced close when losses exhaust the margin supporting a position.',
          'Liquidation happens at the broker\'s level, not yours, and it can occur before a price '
              'level you were watching is even reached. High leverage moves that point '
              'uncomfortably close to the current price.',
        ),
      ],
      quizzes: [
        QuizSpec(
          r'$1,000 balance, 10x leverage, $10,000 exposure. Price moves 2% against you. What do '
              'you lose?',
          [r'$200 — 20% of your balance', r'$20', r'$2,000', r'$100'],
          0,
          'The move applies to the full exposure, not to your balance.',
          concept: 'leverage',
        ),
        QuizSpec(
          'Does leverage change how much you should risk per trade?',
          [
            'No — risk per trade is still a percentage of the account',
            'Yes, you can risk more',
            'Yes, you must risk less than 0.1%',
            'Leverage removes risk',
          ],
          0,
          'Leverage changes the maximum size available. The risk rule is unchanged.',
          concept: 'leverage',
          mistake: MistakeTag.overRisk,
        ),
        QuizSpec(
          'What is liquidation?',
          [
            'A forced close when losses exhaust the margin supporting the position',
            'Closing a trade at your stop',
            'Withdrawing funds',
            'Selling at market',
          ],
          0,
          'It is imposed by the broker and can occur before your own stop level is reached.',
          concept: 'liquidation',
        ),
      ],
      facts: [
        FactSpec(
          'Higher leverage moves the liquidation point closer to the current price.',
          true,
          'Less adverse movement is needed to exhaust the margin.',
          concept: 'liquidation',
        ),
        FactSpec(
          'Using leverage means you should increase risk per trade.',
          false,
          'The percentage rule is independent of leverage.',
          concept: 'leverage',
        ),
      ],
    ),
    LessonSpec(
      title: 'Risk Guardrails',
      subtitle: 'Limits beyond the single trade',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'Per-trade risk is one control. A complete approach also limits exposure across trades '
          'and across time.',
      concepts: [
        ConceptSpec(
          'Correlated exposure',
          'Several positions that move together.',
          'Three long crypto positions at 1% each is not three separate 1% risks. When the '
              'market moves as one, it behaves much closer to a single 3% risk.',
        ),
        ConceptSpec(
          'Daily loss limit',
          'A maximum loss for a single day, after which you stop.',
          'Its purpose is behavioural: it removes the decision to keep going from a moment when '
              'you are least able to make it well.',
        ),
        ConceptSpec(
          'Maximum open risk',
          'The total risk across all open positions at once.',
          'Adding up the risk on every open position gives the real exposure. It is routinely '
              'much larger than people assume.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'You hold three highly correlated longs at 1% risk each. What is your real exposure?',
          [
            'Closer to 3%, because they are likely to lose together',
            'Exactly 1%',
            'Exactly 3% with no qualification',
            '0.33%',
          ],
          0,
          'Correlation means the positions behave more like one larger position than three '
              'independent ones.',
          concept: 'correlated_exposure',
        ),
        QuizSpec(
          'What is the purpose of a daily loss limit?',
          [
            'To remove the decision to continue from a moment when judgement is poorest',
            'To guarantee profitability',
            'To satisfy the broker',
            'To increase the number of trades',
          ],
          0,
          'It is a behavioural control, decided in advance.',
          concept: 'daily_loss_limit',
        ),
        QuizSpec(
          'Maximum open risk is calculated by:',
          [
            'Adding the risk on every open position',
            'Taking the largest single position risk',
            'Averaging the position risks',
            'Multiplying risk by leverage',
          ],
          0,
          'All of it can be lost at once, so all of it counts.',
          concept: 'maximum_open_risk',
        ),
      ],
      facts: [
        FactSpec(
          'Correlated positions carry less combined risk than independent ones.',
          false,
          'More, not less. They tend to lose at the same time.',
          concept: 'correlated_exposure',
        ),
        FactSpec(
          'A daily loss limit is decided in advance, not in the moment.',
          true,
          'Deciding it in the moment defeats the purpose entirely.',
          concept: 'daily_loss_limit',
        ),
      ],
      extras: [
        SpotMistakeSpec(
          'A trader is down 4% on the day after three losses. They write: "One more trade at 5% '
              'to get it back, then I will stop for the day."',
          [
            'Risk was increased specifically because of losses, with no reference to the chart',
            'They should have stopped after two losses',
            '5% is fine on a good setup',
            'They should have traded a different instrument',
          ],
          0,
          MistakeTag.overRisk,
          'The size came from the drawdown, not from a setup. This single trade now risks more '
              'than the three losses combined, and the reasoning behind it is recovery rather '
              'than analysis.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Risk in the Simulator',
      subtitle: 'How this app scores your risk decisions',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'The simulator allows any risk level you want. It also scores what you chose, which is '
          'a deliberate design decision.',
      concepts: [
        ConceptSpec(
          'Risk discipline score',
          'A component of the process score based on the risk you chose.',
          'Risk within a conservative training band scores well. Larger risk reduces it, '
              'regardless of whether the trade won. The simulator will still let you run the '
              'experiment.',
        ),
        ConceptSpec(
          'Experimentation',
          'Trying extreme settings to see what they do.',
          'Everything here is simulated, so experimenting costs nothing real and teaches a lot. '
              'A 25% risk trade shows the equity curve behaviour far more vividly than reading '
              'about it does.',
        ),
        ConceptSpec(
          'Process over profit',
          'Grading the decision rather than the outcome.',
          'A reckless trade that wins scores poorly. A disciplined trade that loses scores well. '
              'This is the single most important scoring choice in the app, because outcome-based '
              'learning teaches exactly the wrong lesson.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A simulated trade risks 40% of the virtual account and gains 5R. How is it scored?',
          [
            'Poorly on process, despite the profit',
            'Highly, because it was profitable',
            'Neutrally',
            'It is excluded from scoring',
          ],
          0,
          'Process is scored separately from outcome. Repeated often, that risk level ends an '
              'account.',
          concept: 'process_over_profit',
          mistake: MistakeTag.overRisk,
        ),
        QuizSpec(
          'Why does the simulator allow extreme risk instead of blocking it?',
          [
            'Experimenting is instructive and nothing real is at stake',
            'To make the app harder',
            'Because blocking is technically difficult',
            'To encourage large positions',
          ],
          0,
          'Seeing what 25% risk does to an equity curve is more convincing than being told.',
          concept: 'experimentation',
        ),
        QuizSpec(
          'A disciplined trade that follows the plan and loses 1R scores:',
          [
            'Well on process — the loss does not reduce it',
            'Poorly, because it lost',
            'Neutrally',
            'It is not scored',
          ],
          0,
          'Losing while following a sound plan is the expected cost of doing business.',
          concept: 'process_over_profit',
        ),
      ],
      facts: [
        FactSpec(
          'The process score rewards profit above everything else.',
          false,
          'It scores risk discipline, invalidation logic, reward-to-risk and plan adherence.',
          concept: 'process_over_profit',
        ),
        FactSpec(
          'All balances in the TradePath simulator are virtual.',
          true,
          'Nothing in the app involves real money or real orders.',
          concept: 'experimentation',
        ),
      ],
    ),
    LessonSpec(
      title: 'Risk Practice',
      subtitle: 'Full calculations end to end',
      minutes: 7,
      difficulty: Difficulty.expert,
      intro:
          'Complete calculations: balance and percentage to risk amount, stop distance to size, '
          'result to R.',
      concepts: [
        ConceptSpec(
          'Calculation chain',
          'Balance → risk amount → stop distance → position size → R result.',
          'Five steps, always the same order. Each one uses only the numbers from the steps '
              'before it, which is what makes the whole thing checkable.',
        ),
        ConceptSpec(
          'Sanity checks',
          'Confirming the numbers make sense before trading.',
          'Is the size affordable? Is the stop distance sensible for this instrument? Does the '
              'risk amount match the percentage you intended? Three checks that catch most '
              'arithmetic slips.',
        ),
      ],
      quizzes: [
        QuizSpec(
          r'$50,000 balance, 1% risk, entry 200, stop 190. Position size?',
          ['50 units', '500 units', '5 units', '250 units'],
          0,
          r'Risk $500, distance 10, so 50 units.',
          concept: 'calculation_chain',
        ),
        QuizSpec(
          'That trade closes at 225. What is the R multiple?',
          ['+2.5R', '+25R', '+1.25R', '+5R'],
          0,
          'Reward 25 against risk 10 is 2.5R.',
          concept: 'r_multiple',
        ),
        QuizSpec(
          'Your calculated size requires more capital than the account holds. What does that mean?',
          [
            'The stop is too tight for this account, or leverage would be required',
            'The calculation is wrong',
            'Increase the risk percentage',
            'Move the stop closer',
          ],
          0,
          'A very tight stop produces a very large size. Either the level is wrong or the trade '
              'is not available at this account size.',
          concept: 'sanity_checks',
        ),
      ],
      facts: [
        FactSpec(
          'The calculation chain always runs in the same order.',
          true,
          'Each step depends only on the ones before it.',
          concept: 'calculation_chain',
        ),
        FactSpec(
          'A position size larger than the account balance is always an error.',
          false,
          'With leverage it is possible — but it is always worth checking deliberately.',
          concept: 'sanity_checks',
        ),
      ],
      extras: [
        RiskCalcSpec(
          r'Balance $12,000, risk 1.25%, entry 75.00, stop 72.00. How many units?',
          50,
          r'Risk amount $150, stop distance 3.00, so 50 units.',
          concept: 'position_sizing',
        ),
        RiskRewardSpec(
          'Short: entry 320, stop 328, target 296. Reward-to-risk?',
          320,
          328,
          296,
          TradeDirection.short,
          'Risk 8, reward 24, ratio 3.00.',
        ),
      ],
    ),
  ],
  boss: BossSpec(
    title: 'Risk Management Challenge',
    subtitle: 'Sizing, R and survival',
    difficulty: Difficulty.expert,
    minutes: 10,
    intro:
        'The most consequential challenge in the app. Calculations, drawdown arithmetic and the '
        'decisions that keep an account alive. Score 80% to unlock Support & Resistance.',
    charts: [
      ChartTaskSpec(
        ChartTask.buildTradeLong,
        ChartPattern.uptrendPullback,
        89001,
      ),
      ChartTaskSpec(
        ChartTask.placeStopShort,
        ChartPattern.resistanceTest,
        89002,
      ),
    ],
    quizzes: [
      QuizSpec(
        r'$20,000 balance, 1% risk, entry 500, stop 480. Position size?',
        ['10 units', '40 units', '100 units', '4 units'],
        0,
        r'Risk $200, distance 20, so 10 units.',
        concept: 'position_sizing',
      ),
      QuizSpec(
        'You lose 40% of an account. What gain restores it?',
        ['About 66.7%', '40%', '50%', '140%'],
        0,
        '0.6 × 1.667 = 1.0. Recovery is always larger than the loss.',
        concept: 'recovery_asymmetry',
      ),
      QuizSpec(
        r'You risked $300 and lost $300. The R result is:',
        ['−1R', '−300R', '0R', '−3R'],
        0,
        'A loss at the stop is one unit of risk.',
        concept: 'r',
      ),
      QuizSpec(
        'At 2:1 reward-to-risk, the approximate break-even hit rate is:',
        ['About 33%', 'About 50%', 'About 66%', 'About 20%'],
        0,
        'One 2R win covers two 1R losses.',
        concept: 'break_even_hit_rate',
      ),
      QuizSpec(
        'Three correlated positions at 1% risk each should be treated as:',
        [
          'Closer to a single 3% risk',
          'Three independent 1% risks',
          'A 0.33% risk',
          'Risk-free through diversification',
        ],
        0,
        'Correlated positions tend to lose together.',
        concept: 'correlated_exposure',
      ),
    ],
    extras: [
      RiskCalcSpec(
        r'Balance $15,000, risk 2%, entry 60.00, stop 54.00. How many units?',
        50,
        r'Risk amount $300, stop distance 6.00, so 50 units.',
        concept: 'position_sizing',
      ),
      SpotMistakeSpec(
        'A plan reads: "Long at market. Size 500 units because that is what I usually trade. '
            'Stop wherever it looks about right. Target when it feels done."',
        [
          'Size was chosen first and both levels were left undefined',
          'The size is too small',
          'Market orders should never be used',
          'The instrument was not stated',
        ],
        0,
        MistakeTag.sizingError,
        'Size should be the output of risk amount and stop distance. Here it is an input, and '
            'neither level exists — so the risk on this trade is whatever happens to occur.',
      ),
    ],
    facts: [
      FactSpec(
        'Position size is an output of the risk calculation, not an input to it.',
        true,
        'Choosing it first makes risk accidental.',
        concept: 'size_as_an_output',
      ),
      FactSpec(
        'Leverage changes how much of your account you should risk per trade.',
        false,
        'It changes available size. The risk rule is unchanged.',
        concept: 'leverage',
      ),
    ],
  ),
);
