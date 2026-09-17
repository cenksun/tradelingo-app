import '../../../domain/models/enums.dart';
import '../../../domain/models/skill.dart';
import '../lesson_spec.dart';

/// World 7 — Stop Loss & Take Profit.
const WorldSpec world07Stops = WorldSpec(
  id: 'w07',
  index: 7,
  title: 'Stop Loss & Take Profit',
  subtitle: 'Defining where an idea ends',
  description:
      'Why stops exist, how structure decides where they go, what makes a target realistic, and '
      'the distance between them that everything else is measured against.',
  primarySkillId: Skills.stopLoss,
  accentColor: 0xFFFF5F7E,
  lessons: [
    LessonSpec(
      title: 'Why Stops Exist',
      subtitle: 'Defining the loss in advance',
      minutes: 5,
      intro:
          'A stop is not pessimism. It is the only way to know, before you enter, what being '
          'wrong will cost.',
      concepts: [
        ConceptSpec(
          'Stop loss',
          'A predefined exit that closes the position if the idea fails.',
          'The stop turns an open-ended loss into a bounded one. Without it, the size of a loss '
              'is decided by how long you can tolerate watching it, which is not a plan.',
        ),
        ConceptSpec(
          'Bounded risk',
          'Knowing the maximum planned loss before entering.',
          'Bounded risk is what makes position sizing possible at all. It is also what lets you '
              'survive a run of losses without a single one ending the account.',
        ),
        ConceptSpec(
          'The no-stop trap',
          'Holding a losing position on the belief it must come back.',
          'Some do come back. The ones that do not are the ones that end accounts, and you '
              'cannot tell which is which at the time. A stop removes the need to.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What does a stop loss make possible?',
          [
            'Knowing the maximum planned loss before entering',
            'Guaranteeing the trade is profitable',
            'Avoiding losses entirely',
            'Trading without analysis',
          ],
          0,
          'Bounded loss is the precondition for calculating position size.',
          concept: 'bounded_risk',
        ),
        QuizSpec(
          'Without a stop, what decides the size of a loss?',
          [
            'How long you can tolerate holding it',
            'The market, fairly',
            'Your position size alone',
            'The spread',
          ],
          0,
          'Tolerance is not a risk parameter. It varies with mood, account size and time of day.',
          concept: 'the_no_stop_trap',
          mistake: MistakeTag.noStop,
        ),
        QuizSpec(
          '"It always comes back eventually" is a problem because:',
          [
            'Some positions never do, and you cannot tell which in advance',
            'It takes too long',
            'It is always false',
            'Brokers close positions automatically',
          ],
          0,
          'The survivors are visible and the failures are not, which makes the belief feel more '
              'true than it is.',
          concept: 'the_no_stop_trap',
        ),
      ],
      facts: [
        FactSpec(
          'A stop loss guarantees you cannot lose more than planned.',
          false,
          'It bounds the intended loss. Slippage can still take the fill beyond the level.',
          concept: 'stop_loss',
        ),
        FactSpec(
          'Position sizing depends on having a defined stop.',
          true,
          'Without a stop distance there is no number to divide the risk amount by.',
          concept: 'bounded_risk',
        ),
      ],
    ),
    LessonSpec(
      title: 'Stops and Invalidation',
      subtitle: 'The level that proves you wrong',
      minutes: 5,
      intro:
          'The stop does not go where the loss feels acceptable. It goes where the idea stops '
          'being true.',
      concepts: [
        ConceptSpec(
          'Invalidation',
          'The price at which the reason for the trade no longer holds.',
          'If you are long because higher lows are holding, the idea is invalid below the last '
              'higher low. That level comes from the chart, not from your account.',
        ),
        ConceptSpec(
          'Structural stop',
          'A stop placed just beyond the invalidation level.',
          'Just beyond, not exactly at: ordinary overshoot routinely pokes a few ticks past a '
              'level and returns. The buffer is what keeps you in for noise and out for a real '
              'break.',
        ),
        ConceptSpec(
          'Account-based stops',
          'Placing the stop where a chosen loss amount lands.',
          'Deciding "I will risk 20 points" and putting the stop 20 points away ignores the '
              'chart completely. The correct order is: find the level, measure the distance, then '
              'adjust size so the money risked is what you intended.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'You are long because higher lows are holding. Where does the stop belong?',
          [
            'Just below the most recent higher low',
            'At a fixed 2% below entry',
            'Just below the entry price',
            'At the lowest point on the chart',
          ],
          0,
          'That swing is the level that defines the idea. Below it, the reason for being long '
              'has gone.',
          concept: 'invalidation',
        ),
        QuizSpec(
          'What is wrong with "I will risk 20 points, so the stop goes 20 points away"?',
          [
            'The level comes from the account rather than from the chart',
            'Twenty points is always too tight',
            'It should be 20 points plus the spread',
            'Nothing is wrong',
          ],
          0,
          'The chart decides the level; size is what adjusts to hit your intended risk amount.',
          concept: 'account_based_stops',
          mistake: MistakeTag.ignoredInvalidation,
        ),
        QuizSpec(
          'Why place the stop slightly beyond the level rather than exactly on it?',
          [
            'Ordinary overshoot routinely pokes past a level and returns',
            'Brokers require a buffer',
            'It makes the risk calculation simpler',
            'It does not matter',
          ],
          0,
          'Exact-level stops get taken out by movement that did not actually break the structure.',
          concept: 'structural_stop',
        ),
      ],
      facts: [
        FactSpec(
          'The chart decides where the stop goes; the account decides how much size to take.',
          true,
          'That order is the whole method.',
          concept: 'invalidation',
        ),
        FactSpec(
          'A stop placed exactly at a swing level is the safest choice.',
          false,
          'Overshoot is routine. A small buffer beyond the level is standard practice.',
          concept: 'structural_stop',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.placeStopLong, ChartPattern.uptrend, 70201),
        ChartTaskSpec(ChartTask.placeStopShort, ChartPattern.downtrend, 70202),
      ],
    ),
    LessonSpec(
      title: 'Stops That Are Too Tight',
      subtitle: 'Getting stopped out by noise',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'A tight stop feels efficient. In practice it often means being removed from positions '
          'by movement that proved nothing.',
      concepts: [
        ConceptSpec(
          'Noise',
          'Ordinary movement that carries no structural meaning.',
          'Every instrument has a normal amount of back-and-forth. A stop inside that range will '
              'be hit regularly, regardless of whether the idea was right.',
        ),
        ConceptSpec(
          'Premature exit',
          'Being stopped out before the idea had a chance to fail properly.',
          'The tell is being stopped out and then watching price go the way you expected without '
              'you. That is not bad luck; it is a stop placed inside the noise.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'You are repeatedly stopped out and then price moves your way. What is the likely cause?',
          [
            'The stop sits inside normal movement for this instrument',
            'The market is targeting you',
            'Your direction is wrong',
            'Your position size is too small',
          ],
          0,
          'A stop inside the noise band gets hit by movement that does not change the structure.',
          concept: 'premature_exit',
          mistake: MistakeTag.stopTooTight,
        ),
        QuizSpec(
          'The correct response to a stop that is too tight is:',
          [
            'Move the stop to a structural level and reduce size to keep risk constant',
            'Widen the stop and keep the same size',
            'Remove the stop',
            'Trade a lower timeframe',
          ],
          0,
          'The level must be right first. Size is what adjusts to keep the money risked the same.',
          concept: 'noise',
        ),
        QuizSpec(
          'What makes a stop "tight" or "wide"?',
          [
            'Its distance relative to normal movement in that instrument',
            'A fixed number of points',
            'The account size',
            'The timeframe alone',
          ],
          0,
          'Like candle size, it is relative to the instrument and the conditions.',
          concept: 'noise',
        ),
      ],
      facts: [
        FactSpec(
          'A tighter stop always means less risk.',
          false,
          'It means less risk per trade but more trades stopped out by noise. The total cost can '
              'easily be higher.',
          concept: 'noise',
        ),
        FactSpec(
          'The fix for a stop inside the noise is a better level plus a smaller position.',
          true,
          'The chart decides where the stop belongs, and position size is then adjusted so '
              'the money risked stays what you intended. Doing it the other way round makes '
              'the level arbitrary.',
          concept: 'premature_exit',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.placeStopLong,
          ChartPattern.uptrendPullback,
          70301,
        ),
      ],
    ),
    LessonSpec(
      title: 'Stops That Are Too Wide',
      subtitle: 'Keeping a trade alive past its reason',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'A stop far beyond the invalidation level keeps a position open long after the reason '
          'for it has gone.',
      concepts: [
        ConceptSpec(
          'Over-wide stop',
          'A stop placed well beyond the level that invalidates the idea.',
          'It produces larger losses than necessary and forces a smaller position for the same '
              'risk, which shrinks the gain when the idea does work.',
        ),
        ConceptSpec(
          'Dead trade',
          'A position still open after its thesis has failed.',
          'The idea was wrong at the invalidation level. Everything after that is holding an '
              'exposure with no reasoning behind it.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What does an over-wide stop cost you even when the trade works?',
          [
            'A smaller position for the same risk, so a smaller gain',
            'A wider spread',
            'Extra commission',
            'Nothing',
          ],
          0,
          'Size is risk divided by distance. A larger distance means fewer units.',
          concept: 'over_wide_stop',
          mistake: MistakeTag.stopTooWide,
        ),
        QuizSpec(
          'Price trades through your invalidation level but your stop is far below. What do you '
              'hold?',
          [
            'A position with no reasoning behind it',
            'A long-term investment',
            'A hedged position',
            'The same trade as before',
          ],
          0,
          'The thesis failed at the level. The position is now exposure without an idea.',
          concept: 'dead_trade',
        ),
        QuizSpec(
          'How do you avoid both over-wide and over-tight stops?',
          [
            'Place the stop just beyond the structural level, then size to fit',
            'Use a fixed percentage every time',
            'Use the widest stop you can afford',
            'Use the tightest stop possible',
          ],
          0,
          'The structure decides the level; the account decides the size.',
          concept: 'over_wide_stop',
        ),
      ],
      facts: [
        FactSpec(
          'A wider stop means a smaller position for the same money risked.',
          true,
          'Size and stop distance are inversely related.',
          concept: 'over_wide_stop',
        ),
        FactSpec(
          'A position held past its invalidation level is still the trade you planned.',
          false,
          'The plan ended at that level. What remains is unplanned exposure.',
          concept: 'dead_trade',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.placeStopShort,
          ChartPattern.downtrendPullback,
          70401,
        ),
      ],
    ),
    LessonSpec(
      title: 'Take Profit',
      subtitle: 'Deciding where the trade is finished',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'A target is where you have decided the idea has delivered what it was going to '
          'deliver. It needs a reason, just like the stop does.',
      concepts: [
        ConceptSpec(
          'Take profit',
          'A predefined exit that closes the position in profit.',
          'The target should point at something on the chart — a prior swing, a range boundary, '
              'the opposite side of a structure. A round number chosen because it sounds good is '
              'not a target.',
        ),
        ConceptSpec(
          'Structural target',
          'A target placed at a level price has plausibly reached before.',
          'Prior swing highs and range boundaries are the usual candidates. They are places where '
              'price has already been, which makes reaching them a plausible expectation rather '
              'than a hope.',
        ),
        ConceptSpec(
          'Unrealistic targets',
          'Targets far beyond anything visible on the chart.',
          'A target five times further than any recent move produces a beautiful reward-to-risk '
              'number and almost never fills. The ratio looks good on paper and does nothing in '
              'practice.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What makes a target plausible?',
          [
            'It points at structure that is already visible on the chart',
            'It produces a large reward-to-risk number',
            'It is a round number',
            'It is far from the entry',
          ],
          0,
          'A target is a claim that price can reach a place. Structure is the evidence for it.',
          concept: 'structural_target',
        ),
        QuizSpec(
          'A target five times further than any recent swing gives 8:1 reward-to-risk. What is '
              'the problem?',
          [
            'The ratio is only meaningful if the target is reachable',
            'Eight to one is too high to be allowed',
            'Nothing — it is an excellent trade',
            'The stop must be too tight',
          ],
          0,
          'Reward-to-risk assumes the target can fill. An unreachable one makes the number '
              'decorative.',
          concept: 'unrealistic_targets',
          mistake: MistakeTag.poorRr,
        ),
        QuizSpec(
          'Which is the most common structural target for a long?',
          [
            'A prior swing high or range boundary above the entry',
            'The all-time high',
            'A round number',
            'Twice the stop distance, always',
          ],
          0,
          'Prior structure is where price has demonstrably traded before.',
          concept: 'structural_target',
        ),
      ],
      facts: [
        FactSpec(
          'A larger reward-to-risk ratio is always better.',
          false,
          'Only if the target is reachable. Ratios from unreachable targets mean nothing.',
          concept: 'unrealistic_targets',
        ),
        FactSpec(
          'Targets should point at structure visible on the chart.',
          true,
          'That is what makes them an expectation rather than a wish.',
          concept: 'structural_target',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.placeTargetLong, ChartPattern.uptrend, 70501),
        ChartTaskSpec(
          ChartTask.placeTargetShort,
          ChartPattern.downtrend,
          70502,
        ),
      ],
    ),
    LessonSpec(
      title: 'Risk Distance',
      subtitle: 'The number everything is measured in',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'The distance from entry to stop is the unit of measurement for the whole trade. Once '
          'you have it, everything else is arithmetic.',
      concepts: [
        ConceptSpec(
          'Risk distance',
          'The price distance between entry and stop.',
          'Also called stop distance. It is what position size is calculated from and what the '
              'reward is compared against. In World 8 it becomes 1R.',
        ),
        ConceptSpec(
          'Reward distance',
          'The price distance between entry and target.',
          'Measured the same way, in the opposite direction. The two together give the '
              'reward-to-risk ratio.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Entry 100, stop 97, target 109. What is the risk distance?',
          ['3', '9', '12', '6'],
          0,
          'Entry minus stop: 100 − 97 = 3.',
          concept: 'risk_distance',
        ),
        QuizSpec(
          'Using the same trade, what is the reward distance?',
          ['9', '3', '12', '109'],
          0,
          'Target minus entry: 109 − 100 = 9.',
          concept: 'reward_distance',
        ),
        QuizSpec(
          'Why is risk distance the unit everything is measured in?',
          [
            'Position size and reward-to-risk are both derived from it',
            'It is the largest number in the trade',
            'Brokers report it',
            'It determines the spread',
          ],
          0,
          'Size = risk amount ÷ risk distance; reward-to-risk = reward distance ÷ risk distance.',
          concept: 'risk_distance',
        ),
      ],
      facts: [
        FactSpec(
          'Risk distance is measured from entry to stop, not from the current price to the stop.',
          true,
          'It is fixed once the position opens.',
          concept: 'risk_distance',
        ),
        FactSpec(
          'Reward and risk distances are measured in different units.',
          false,
          'Both are plain price distances, which is what makes the ratio meaningful.',
          concept: 'reward_distance',
        ),
      ],
      extras: [
        RiskRewardSpec(
          'Entry 50.00, stop 48.00, target 56.00 on a long. What is the reward-to-risk ratio?',
          50,
          48,
          56,
          TradeDirection.long,
          'Risk is 2.00 and reward is 6.00, so the ratio is 3.00.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Bad Stop Placement',
      subtitle: 'The places stops should not go',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro: 'Some stop placements are wrong for structural reasons, not just unlucky ones.',
      concepts: [
        ConceptSpec(
          'Stops inside structure',
          'A stop placed within the range price is actively trading in.',
          'Putting a stop in the middle of a recent swing guarantees that ordinary movement '
              'reaches it. The structure has to be behind the stop, not around it.',
        ),
        ConceptSpec(
          'Obvious levels',
          'Stops clustered a few ticks beyond a widely watched level.',
          'When many participants place stops in the same small area, that area becomes a '
              'concentration of resting orders. World 10 covers what that concentration means. '
              'For now: a small buffer beyond a level is sensible, and the exact tick past it is '
              'the most crowded spot on the chart.',
        ),
        ConceptSpec(
          'Round numbers',
          'Stops placed exactly at round prices.',
          'Round numbers attract attention and orders for no structural reason. If your stop '
              'lands on one by coincidence, it is worth moving slightly.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What is wrong with a stop placed inside a recent swing range?',
          [
            'Ordinary movement within that range will reach it',
            'It is too far from entry',
            'It cannot be executed',
            'Nothing',
          ],
          0,
          'Price is actively trading through that area. The structure needs to sit behind the '
              'stop.',
          concept: 'stops_inside_structure',
          mistake: MistakeTag.stopTooTight,
        ),
        QuizSpec(
          'Why avoid placing a stop exactly one tick beyond a widely watched level?',
          [
            'It is the most crowded spot on the chart',
            'Brokers reject such orders',
            'It is too far away',
            'Round numbers are illegal',
          ],
          0,
          'Concentrated resting orders in a tiny area make that area a natural magnet for '
              'movement.',
          concept: 'obvious_levels',
        ),
        QuizSpec(
          'A sensible stop for a long sits:',
          [
            'A small buffer beyond the swing low that invalidates the idea',
            'Exactly at the swing low',
            'At a round number below entry',
            'Wherever the loss feels comfortable',
          ],
          0,
          'Beyond the level with a buffer, chosen from the chart rather than from comfort.',
          concept: 'stops_inside_structure',
        ),
      ],
      facts: [
        FactSpec(
          'Round numbers attract orders for reasons unrelated to structure.',
          true,
          'Which is a reason to avoid placing a stop exactly on one.',
          concept: 'round_numbers',
        ),
        FactSpec(
          'A stop inside a recent swing range is a conservative choice.',
          false,
          'It is a placement that ordinary movement will reach.',
          concept: 'stops_inside_structure',
        ),
      ],
      extras: [
        SpotMistakeSpec(
          'A trader goes long after a pullback and writes: "Stop at 100.00 because it is a nice '
              'round number and close to my entry, so the loss is small."',
          [
            'The stop was chosen for comfort and roundness, not from the structure',
            'The stop is too far away',
            'They should not have traded a pullback',
            'The entry should have been a market order',
          ],
          0,
          MistakeTag.ignoredInvalidation,
          'Two separate problems: the level came from a preference for small losses rather than '
              'from the chart, and round numbers attract concentrated orders. The swing that '
              'defines the idea is what should have set the level.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Managing Stops',
      subtitle: 'When moving a stop is legitimate',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro: 'Moving a stop is sometimes correct and often a mistake. The direction tells you which.',
      concepts: [
        ConceptSpec(
          'Trailing a stop',
          'Moving the stop in the direction of the trade as structure develops.',
          'When a new higher low forms in an uptrend, the invalidation level has genuinely moved '
              'up. Following it with the stop is a structural decision, not a comfort one.',
        ),
        ConceptSpec(
          'Widening a stop',
          'Moving the stop further away as price approaches it.',
          'This is almost never justified. The level was chosen when you had no position; moving '
              'it now replaces that reasoning with the discomfort of an approaching loss.',
        ),
        ConceptSpec(
          'Break-even stops',
          'Moving the stop to the entry price once the trade is in profit.',
          'Popular, and worth understanding rather than following automatically: it removes the '
              'loss but also makes a small pullback end the trade at zero. It is a trade-off, not '
              'a free improvement.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Which stop movement is structurally justified?',
          [
            'Trailing it up to a new higher low in an uptrend',
            'Widening it as price approaches',
            'Removing it after a large move against you',
            'Moving it to a round number',
          ],
          0,
          'A new higher low is a genuine change in where the idea becomes invalid.',
          concept: 'trailing_a_stop',
        ),
        QuizSpec(
          'What is the honest description of moving a stop to break even?',
          [
            'A trade-off: no loss, but ordinary pullbacks now end the trade at zero',
            'A free improvement to any trade',
            'Always the correct action',
            'The same as trailing to structure',
          ],
          0,
          'The entry price has no structural meaning. It is your price, not the chart\'s.',
          concept: 'break_even_stops',
        ),
        QuizSpec(
          'Why is widening a stop under pressure almost never justified?',
          [
            'The level was chosen without a position; discomfort is not new information',
            'It costs more commission',
            'Brokers do not allow it',
            'It is justified when the trend is strong',
          ],
          0,
          'Nothing about the chart changed — only your exposure to it.',
          concept: 'widening_a_stop',
          mistake: MistakeTag.ignoredInvalidation,
        ),
      ],
      facts: [
        FactSpec(
          'Moving a stop to break even is always an improvement.',
          false,
          'It removes the loss and adds exits at zero on ordinary pullbacks. It is a trade-off.',
          concept: 'break_even_stops',
        ),
        FactSpec(
          'Trailing a stop to a newly formed higher low is a structural decision.',
          true,
          'The invalidation level genuinely moved.',
          concept: 'trailing_a_stop',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.placeStopLong,
          ChartPattern.breakOfStructureUp,
          70801,
        ),
      ],
    ),
    LessonSpec(
      title: 'Both Levels Together',
      subtitle: 'Stop and target as one decision',
      minutes: 6,
      difficulty: Difficulty.advanced,
      intro:
          'The stop and the target are not separate choices. Together they decide whether the '
          'trade is worth taking at all.',
      concepts: [
        ConceptSpec(
          'Complete plan',
          'Entry, stop and target decided before the position opens.',
          'All three, written down. If any one of them is missing the trade is not fully planned, '
              'and the missing piece will get decided under pressure instead.',
        ),
        ConceptSpec(
          'Go / no-go',
          'Using the ratio between the two distances to decide whether to trade.',
          'If the stop has to be far and the target is close, there is no trade worth taking, '
              'however good the reading is. The chart can be read correctly and still not offer '
              'anything.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'The structure is clear but the target is closer than the stop. What follows?',
          [
            'No trade — the reading is fine but the arithmetic is not',
            'Take it with a tighter stop',
            'Take it with more size',
            'Move the target further out',
          ],
          0,
          'A correct reading does not oblige you to trade. Moving the target to fix the ratio '
              'just makes it unreachable.',
          concept: 'go_no_go',
        ),
        QuizSpec(
          'What makes a plan complete?',
          [
            'Entry, stop and target all decided before entering',
            'Entry and stop',
            'A directional view and a size',
            'Entry and target',
          ],
          0,
          'Anything left undecided gets decided while the position is open.',
          concept: 'complete_plan',
        ),
        QuizSpec(
          'Entry 200, stop 196, target 203. What is the sensible conclusion?',
          [
            'Risk 4 for a reward of 3 — this is not worth taking as planned',
            'A good trade with a tight stop',
            'A 1:3 trade',
            'Add size to compensate',
          ],
          0,
          'Risking more than the reward requires a very high hit rate to break even, and nothing '
              'on the chart promises one.',
          concept: 'go_no_go',
          mistake: MistakeTag.poorRr,
        ),
      ],
      facts: [
        FactSpec(
          'A correct chart reading always produces a tradeable setup.',
          false,
          'Reading a chart correctly often leads to the conclusion that there is nothing to do.',
          concept: 'go_no_go',
        ),
        FactSpec(
          'A plan missing one of its three levels will have that level decided under pressure.',
          true,
          'Which is exactly the condition planning exists to avoid.',
          concept: 'complete_plan',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.buildTradeLong, ChartPattern.uptrend, 70901),
        ChartTaskSpec(ChartTask.buildTradeShort, ChartPattern.downtrend, 70902),
      ],
    ),
    LessonSpec(
      title: 'Stop and Target Practice',
      subtitle: 'Place both on unfamiliar charts',
      minutes: 6,
      difficulty: Difficulty.advanced,
      intro:
          'Charts you have not seen. Find the invalidation level, place the stop beyond it, and '
          'aim at structure that is actually there.',
      concepts: [
        ConceptSpec(
          'Placement routine',
          'A fixed order of operations for setting levels.',
          'Read the structure, find the invalidation level, place the stop beyond it, find the '
              'nearest plausible structural target, then check whether the ratio justifies the '
              'trade. Always that order.',
        ),
        ConceptSpec(
          'Accepting no trade',
          'Finishing the routine with a decision not to act.',
          'The routine frequently ends in no trade. That is the routine working, not failing.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What is the correct order of operations?',
          [
            'Structure, invalidation, stop, target, ratio check',
            'Target, stop, entry, structure',
            'Entry, size, stop, target',
            'Ratio, target, stop, structure',
          ],
          0,
          'Each step depends on the one before it. Starting from the ratio means working '
              'backwards to justify a trade.',
          concept: 'placement_routine',
        ),
        QuizSpec(
          'The routine ends with the ratio check failing. What now?',
          [
            'No trade',
            'Move the target out until the ratio works',
            'Tighten the stop until the ratio works',
            'Take it anyway with smaller size',
          ],
          0,
          'Both "fixes" corrupt levels that were chosen from the chart.',
          concept: 'accepting_no_trade',
        ),
        QuizSpec(
          'Why place the stop before choosing the target?',
          [
            'The stop distance is what the reward is measured against',
            'Stops execute faster',
            'Targets are optional',
            'It does not matter',
          ],
          0,
          'Without the risk distance there is nothing to compare the reward to.',
          concept: 'placement_routine',
        ),
      ],
      facts: [
        FactSpec(
          'Adjusting the target until the ratio looks acceptable is sound practice.',
          false,
          'It replaces a structural target with an arbitrary one and makes the ratio meaningless.',
          concept: 'accepting_no_trade',
        ),
        FactSpec(
          'The stop distance has to be known before the reward-to-risk ratio can be calculated.',
          true,
          'Reward-to-risk is reward distance divided by risk distance, so the stop has to be '
              'placed before there is anything to divide by.',
          concept: 'placement_routine',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.placeStopLong, ChartPattern.supportTest, 71001),
        ChartTaskSpec(
          ChartTask.placeTargetLong,
          ChartPattern.uptrendPullback,
          71002,
        ),
        ChartTaskSpec(
          ChartTask.buildTradeShort,
          ChartPattern.resistanceTest,
          71003,
        ),
      ],
    ),
  ],
  boss: BossSpec(
    title: 'Stops & Targets Challenge',
    subtitle: 'Place both levels from structure',
    difficulty: Difficulty.advanced,
    minutes: 9,
    intro:
        'Place stops and targets on unfamiliar charts and answer on invalidation, distance and '
        'management. Score 80% to unlock Risk Management.',
    charts: [
      ChartTaskSpec(ChartTask.placeStopLong, ChartPattern.uptrend, 79001),
      ChartTaskSpec(ChartTask.placeStopShort, ChartPattern.downtrend, 79002),
      ChartTaskSpec(
        ChartTask.placeTargetLong,
        ChartPattern.uptrendPullback,
        79003,
      ),
      ChartTaskSpec(
        ChartTask.buildTradeLong,
        ChartPattern.breakOfStructureUp,
        79004,
      ),
      ChartTaskSpec(
        ChartTask.buildTradeShort,
        ChartPattern.breakOfStructureDown,
        79005,
      ),
    ],
    quizzes: [
      QuizSpec(
        'Where does a stop belong for a long based on holding higher lows?',
        [
          'Just below the most recent higher low',
          'A fixed percentage below entry',
          'At the entry price',
          'At the lowest low on the chart',
        ],
        0,
        'That swing is what defines the idea.',
        concept: 'invalidation',
      ),
      QuizSpec(
        'Entry 80, stop 76, target 92. The reward-to-risk ratio is:',
        ['3.00', '1.50', '0.33', '12.00'],
        0,
        'Risk 4, reward 12, ratio 3.00.',
        concept: 'risk_distance',
      ),
      QuizSpec(
        'Which stop movement is justified by structure rather than comfort?',
        [
          'Trailing up to a newly formed higher low',
          'Widening it as price approaches',
          'Moving it to a round number',
          'Removing it during news',
        ],
        0,
        'A new swing genuinely moves the invalidation level.',
        concept: 'trailing_a_stop',
      ),
    ],
    extras: [
      RiskRewardSpec(
        'A short: entry 1.2500, stop 1.2560, target 1.2380. What is the reward-to-risk ratio?',
        1.25,
        1.256,
        1.238,
        TradeDirection.short,
        'Risk 0.0060, reward 0.0120, so the ratio is 2.00.',
      ),
    ],
    facts: [
      FactSpec(
        'A larger reward-to-risk ratio is better only if the target is reachable.',
        true,
        'Ratios built on unreachable targets are decorative.',
        concept: 'unrealistic_targets',
      ),
      FactSpec(
        'The account balance decides where the stop goes.',
        false,
        'The chart decides the level; the balance decides the size.',
        concept: 'account_based_stops',
      ),
    ],
  ),
);
