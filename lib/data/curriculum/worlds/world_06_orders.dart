import '../../../domain/models/enums.dart';
import '../../../domain/models/skill.dart';
import '../lesson_spec.dart';

/// World 6 — Order Types.
const WorldSpec world06Orders = WorldSpec(
  id: 'w06',
  index: 6,
  title: 'Order Types',
  subtitle: 'How an idea becomes a position',
  description:
      'Market, limit and stop orders, what each one guarantees, and the execution details that '
      'decide where you actually get filled.',
  primarySkillId: Skills.orders,
  accentColor: 0xFF52A8FF,
  lessons: [
    LessonSpec(
      title: 'Market Orders',
      subtitle: 'Certain fill, uncertain price',
      minutes: 4,
      intro:
          'A market order says "get me in now, at whatever the market is offering". It trades '
          'price certainty for speed.',
      concepts: [
        ConceptSpec(
          'Market order',
          'An order to trade immediately at the best available price.',
          'You will almost always get filled. What you will not know in advance is exactly where. '
              'In fast or thin markets the difference can be significant.',
        ),
        ConceptSpec(
          'Crossing the spread',
          'Paying the ask to buy or accepting the bid to sell.',
          'Every market order crosses the spread. That is the cost of demanding immediacy, and '
              'it is paid on entry and again on exit.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What does a market order guarantee?',
          [
            'That you will be filled, but not at what price',
            'The exact price you saw',
            'The best price of the day',
            'Both price and fill',
          ],
          0,
          'Speed is guaranteed; price is not. That trade-off is the whole design of the order.',
          concept: 'market_order',
        ),
        QuizSpec(
          'You submit a market buy. Which price do you pay?',
          ['The ask', 'The bid', 'The midpoint', 'The last traded price'],
          0,
          'Buying immediately means taking what sellers are offering — the ask.',
          concept: 'crossing_the_spread',
        ),
        QuizSpec(
          'When is a market order most likely to fill far from the expected price?',
          [
            'In fast-moving or thinly traded conditions',
            'During quiet periods',
            'On higher timeframes',
            'When the spread is narrow',
          ],
          0,
          'Thin books and rapid movement both mean the best available price changes between '
              'submission and execution.',
          concept: 'market_order',
        ),
      ],
      facts: [
        FactSpec(
          'A market order guarantees the price you saw on screen.',
          false,
          'It guarantees a fill. The price is whatever is available when it arrives.',
          concept: 'market_order',
        ),
        FactSpec(
          'Every market order pays the spread.',
          true,
          'Crossing the spread is the cost of immediacy.',
          concept: 'crossing_the_spread',
        ),
      ],
      extras: [
        OrderTypeSpec(
          'A structural level just broke and you want to be in the move now. You accept that the '
              'fill price may be a little worse than what is on screen.',
          OrderType.market,
          'Immediacy is the priority and price certainty is being given up deliberately. That is '
              'exactly what a market order is for.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Limit Orders',
      subtitle: 'Certain price, uncertain fill',
      minutes: 5,
      intro:
          'A limit order is the opposite trade-off: you name your price and accept that you might '
          'not trade at all.',
      concepts: [
        ConceptSpec(
          'Limit order',
          'An order to trade at a specified price or better, never worse.',
          'A buy limit sits below the current price and fills only if price comes down to it. A '
              'sell limit sits above and fills only if price comes up. If price never reaches it, '
              'nothing happens.',
        ),
        ConceptSpec(
          'Resting order',
          'An order waiting in the book to be filled.',
          'Resting orders provide liquidity to everyone else. Because you are not demanding '
              'immediacy, you are not paying the spread to get in.',
        ),
        ConceptSpec(
          'Missed fill',
          'The trade that never happened because price did not reach your level.',
          'The cost of a limit order is the trades you miss. Placing one a fraction beyond where '
              'price actually turns is one of the most common ways to watch a good idea go '
              'without you.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A buy limit order is placed:',
          [
            'Below the current price',
            'Above the current price',
            'At the current price exactly',
            'Anywhere; it fills immediately',
          ],
          0,
          'You are asking to buy cheaper than now, so the order sits below and waits.',
          concept: 'limit_order',
        ),
        QuizSpec(
          'What does a limit order guarantee?',
          [
            'Your price or better — but not that you trade at all',
            'That you will be filled',
            'A fill at the midpoint',
            'Both price and fill',
          ],
          0,
          'Price certainty is guaranteed; participation is not.',
          concept: 'limit_order',
        ),
        QuizSpec(
          'What is the real cost of using limit orders?',
          [
            'The trades you never get into',
            'A higher commission',
            'A wider spread',
            'Slower execution when they do fill',
          ],
          0,
          'Missed fills are the price of price certainty.',
          concept: 'missed_fill',
        ),
      ],
      facts: [
        FactSpec(
          'A limit order can fill at a better price than the one you specified.',
          true,
          '"Or better" is part of the definition, though in practice it is uncommon.',
          concept: 'limit_order',
        ),
        FactSpec(
          'A limit order always eventually fills if you wait long enough.',
          false,
          'Price may simply never return to your level.',
          concept: 'missed_fill',
        ),
      ],
      extras: [
        OrderTypeSpec(
          'You want to buy only if price pulls back to a support area, and you are content to '
              'miss the trade entirely if it does not.',
          OrderType.limit,
          'Naming a price and accepting no fill if it is not reached is precisely a limit order.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Stop Orders',
      subtitle: 'Triggered by price trading through a level',
      minutes: 5,
      intro:
          'A stop order does nothing until price reaches a trigger. Then it becomes a market '
          'order. This is both how protective stops work and how breakout entries are placed.',
      concepts: [
        ConceptSpec(
          'Stop order',
          'An order that activates when price trades through a trigger level.',
          'A buy stop sits above the current price; a sell stop sits below. Once triggered it '
              'usually becomes a market order, so the trigger price and the fill price are not '
              'the same thing.',
        ),
        ConceptSpec(
          'Protective stop',
          'A stop order placed to close a position if the idea fails.',
          'For a long, a sell stop below the entry. For a short, a buy stop above it. This is '
              'the "stop loss" World 7 builds on.',
        ),
        ConceptSpec(
          'Breakout entry',
          'A stop order used to enter when price trades beyond a level.',
          'A buy stop above a range high enters only if price actually trades up there. You give '
              'up the best price in exchange for not entering unless the move happens.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A buy stop is placed where relative to the current price?',
          ['Above it', 'Below it', 'At it', 'Either side'],
          0,
          'It triggers on price rising through the level, so it sits above.',
          concept: 'stop_order',
        ),
        QuizSpec(
          'Why can a triggered stop fill at a worse price than its trigger?',
          [
            'Once triggered it becomes a market order and takes what is available',
            'Brokers add a fee at the trigger',
            'Stops are always delayed by one candle',
            'It cannot fill worse',
          ],
          0,
          'The trigger starts the order; the market decides the fill. In fast conditions the gap '
              'can be large.',
          concept: 'stop_order',
        ),
        QuizSpec(
          'A protective stop for a long position is:',
          [
            'A sell stop below the entry',
            'A buy stop above the entry',
            'A sell limit above the entry',
            'A buy limit below the entry',
          ],
          0,
          'It has to sell you out if price falls, so it is a sell stop underneath.',
          concept: 'protective_stop',
        ),
      ],
      facts: [
        FactSpec(
          'A stop order guarantees you exit at exactly the stop price.',
          false,
          'It guarantees the order is sent. The fill depends on what is available.',
          concept: 'stop_order',
        ),
        FactSpec(
          'The same order type is used both for protective stops and for breakout entries.',
          true,
          'Both are "act only if price trades through this level".',
          concept: 'breakout_entry',
        ),
      ],
      extras: [
        OrderTypeSpec(
          'You only want to be long if price trades above the range high, and you do not want to '
              'be in beforehand.',
          OrderType.stop,
          'A buy stop above the range high enters only on the break, which is exactly the '
              'condition being described.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Choosing an Order Type',
      subtitle: 'Matching the order to the intent',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'Each order type answers a different question. Getting the match right is mostly about '
          'being honest about what you actually want.',
      concepts: [
        ConceptSpec(
          'Intent matching',
          'Choosing the order that expresses what you actually want to happen.',
          'Do you need to be in now? Market. Only at a better price? Limit. Only if the move '
              'happens? Stop. The question is about intent, not about which is "best".',
        ),
        ConceptSpec(
          'Trade-off triangle',
          'Speed, price and certainty of participation — you get two.',
          'Market gives speed and participation but not price. Limit gives price but not '
              'participation. Stop gives participation conditional on a move, at an uncertain '
              'price.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'You want in only if price falls to a level you have identified. Which order?',
          ['A buy limit', 'A market order', 'A buy stop', 'A sell limit'],
          0,
          'Buying lower than the current price is exactly what a buy limit does.',
          concept: 'intent_matching',
        ),
        QuizSpec(
          'You want in only if price rises through resistance. Which order?',
          ['A buy stop', 'A buy limit', 'A market order', 'A sell stop'],
          0,
          'Acting only on a break upward requires a trigger above the current price.',
          concept: 'intent_matching',
        ),
        QuizSpec(
          'Which combination is impossible in a single order?',
          [
            'Guaranteed fill at a guaranteed price',
            'Guaranteed fill at an unknown price',
            'A known price with no guarantee of a fill',
            'A conditional entry at an unknown price',
          ],
          0,
          'You cannot have both. Every order type gives up one of the two.',
          concept: 'trade_off_triangle',
        ),
      ],
      facts: [
        FactSpec(
          'No single order type guarantees both a fill and a price.',
          true,
          'That is the fundamental trade-off between them.',
          concept: 'trade_off_triangle',
        ),
        FactSpec(
          'Market orders are always the worst choice.',
          false,
          'When being in matters more than the exact price, a market order is the right tool.',
          concept: 'intent_matching',
        ),
      ],
      extras: [
        OrderTypeSpec(
          'Price is approaching a support area you have marked. You want to buy there if it '
              'arrives, at that price and no worse.',
          OrderType.limit,
          'Price certainty at a chosen level, with no obligation to trade if it is missed.',
        ),
        OrderTypeSpec(
          'You are already long and want an order that closes the position if price falls back '
              'through your invalidation level.',
          OrderType.stop,
          'A protective stop is a stop order: it does nothing until price trades through the '
              'level.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Slippage',
      subtitle: 'The gap between expected and actual',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'Slippage is the difference between the price you expected and the price you got. It is '
          'a normal cost, not a malfunction.',
      concepts: [
        ConceptSpec(
          'Slippage',
          'The difference between the expected fill price and the actual one.',
          'It occurs whenever price moves between order submission and execution, or when the '
              'order is larger than the size resting at the best price.',
        ),
        ConceptSpec(
          'Depth',
          'How much size is available at each price level.',
          'A large order eats through several levels, filling progressively worse. Thin books '
              'produce dramatic slippage on orders that would be unremarkable elsewhere.',
        ),
        ConceptSpec(
          'Slippage on stops',
          'Protective stops can fill worse than their trigger price.',
          'This matters for risk calculations: a 1% planned risk can become more than 1% if the '
              'stop fills badly. Planned risk is the intention, not a guarantee.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What causes slippage on a large market order in a thin book?',
          [
            'The order consumes several price levels as it fills',
            'The broker delays the order',
            'The spread is fixed',
            'The chart is inaccurate',
          ],
          0,
          'There is not enough size at the best price, so the remainder fills at worse ones.',
          concept: 'depth',
        ),
        QuizSpec(
          'Your stop triggers and fills 0.4% beyond its level. What happened to your planned 1% '
              'risk?',
          [
            'The realised loss was larger than planned',
            'It stayed exactly 1%',
            'It became smaller',
            'The stop failed',
          ],
          0,
          'Planned risk assumes a fill at the stop price. Slippage makes the realised loss larger.',
          concept: 'slippage_on_stops',
        ),
        QuizSpec(
          'Slippage is best understood as:',
          [
            'A normal cost of trading that varies with conditions',
            'A broker error',
            'Something that only affects large accounts',
            'Always in your favour',
          ],
          0,
          'It is an ordinary consequence of how orders meet a moving market.',
          concept: 'slippage',
        ),
      ],
      facts: [
        FactSpec(
          'Slippage can occasionally work in your favour.',
          true,
          'If price moves your way between submission and fill, you get a better price. It is '
              'just less common than the reverse on stops.',
          concept: 'slippage',
        ),
        FactSpec(
          'Planned risk is a guaranteed maximum loss.',
          false,
          'It assumes the stop fills at its level. Slippage can exceed it.',
          concept: 'slippage_on_stops',
        ),
      ],
    ),
    LessonSpec(
      title: 'Entry Planning',
      subtitle: 'Deciding where before deciding whether',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro:
          'The entry price is not a detail. It sets the distance to your invalidation level, which '
          'sets your risk per unit, which sets your position size.',
      concepts: [
        ConceptSpec(
          'Entry location',
          'Where in the structure the entry sits.',
          'An entry close to the invalidation level gives a small risk per unit and therefore '
              'more size for the same money risked. An entry far from it does the opposite.',
        ),
        ConceptSpec(
          'Entry trigger',
          'The specific condition that turns a plan into an order.',
          'A trigger might be price reaching a level, or a candle closing beyond one. Writing it '
              'down in advance is what stops "I will know it when I see it".',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Why does entry location affect position size?',
          [
            'It changes the distance to the stop, which changes risk per unit',
            'Brokers charge more for distant entries',
            'It does not affect size',
            'Larger distances require more margin only',
          ],
          0,
          'Size comes from risk amount divided by stop distance. Move the entry and the distance '
              'changes.',
          concept: 'entry_location',
        ),
        QuizSpec(
          'What makes an entry trigger useful?',
          [
            'It is specific enough to be checked without judgement in the moment',
            'It is always a market order',
            'It guarantees a good fill',
            'It removes the need for a stop',
          ],
          0,
          'A trigger you have to interpret under pressure is not really a trigger.',
          concept: 'entry_trigger',
        ),
        QuizSpec(
          'Two traders take the same idea; one enters near the invalidation level and one far '
              'from it. Assuming equal money risked:',
          [
            'The closer entry allows a larger position for the same risk',
            'They have identical positions',
            'The further entry is safer',
            'The closer entry risks more money',
          ],
          0,
          'Same risk amount, smaller stop distance, larger size. The money at risk is unchanged.',
          concept: 'entry_location',
        ),
      ],
      facts: [
        FactSpec(
          'Entry price affects position size through the stop distance.',
          true,
          'That chain — entry, stop, distance, size — is the core of World 8.',
          concept: 'entry_location',
        ),
        FactSpec(
          'A vague entry trigger works as well as a specific one.',
          false,
          'Vague triggers get interpreted in whatever way suits the moment.',
          concept: 'entry_trigger',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.buildTradeLong,
          ChartPattern.uptrendPullback,
          60601,
        ),
      ],
    ),
    LessonSpec(
      title: 'Order Mistakes',
      subtitle: 'Where execution goes wrong',
      minutes: 5,
      difficulty: Difficulty.intermediate,
      intro: 'Most execution errors are an order type that does not match the intention behind it.',
      concepts: [
        ConceptSpec(
          'Wrong side',
          'Placing a limit where a stop belongs, or vice versa.',
          'A buy limit above the current price fills immediately and badly. A buy stop below it '
              'does the same. Both are easy to do in a hurry and immediately obvious afterwards.',
        ),
        ConceptSpec(
          'Chasing with market orders',
          'Repeatedly using market orders to catch a move.',
          'Each one crosses the spread and each one enters further from the invalidation level. '
              'Repeated a few times, this alone can turn a decent idea into a poor trade.',
        ),
        ConceptSpec(
          'Moving the stop',
          'Widening a protective stop because price is approaching it.',
          'This converts a planned loss into an unplanned one. The level was chosen when the '
              'position did not exist; moving it while under pressure discards that reasoning.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What happens if you place a buy limit above the current market price?',
          [
            'It fills immediately at the current ask, which was not the intention',
            'It rejects',
            'It waits until price rises',
            'It becomes a stop order',
          ],
          0,
          '"At this price or better" is already satisfied, so it executes at once.',
          concept: 'wrong_side',
          mistake: MistakeTag.wrongOrderType,
        ),
        QuizSpec(
          'What is wrong with widening a stop as price approaches it?',
          [
            'It discards the reasoning the stop was based on and increases the loss',
            'Brokers charge a fee',
            'It always triggers slippage',
            'Nothing, if the idea is still valid',
          ],
          0,
          'The level was chosen deliberately. Moving it under pressure replaces analysis with '
              'discomfort.',
          concept: 'moving_the_stop',
          mistake: MistakeTag.ignoredInvalidation,
        ),
        QuizSpec(
          'Repeatedly chasing a move with market orders costs you:',
          [
            'The spread each time, plus a worse entry relative to invalidation',
            'Only commission',
            'Nothing if the trade wins',
            'Only time',
          ],
          0,
          'Both costs are structural and apply whether or not the trade eventually works.',
          concept: 'chasing_with_market_orders',
          mistake: MistakeTag.lateEntry,
        ),
      ],
      facts: [
        FactSpec(
          'Moving a protective stop further away converts a planned loss into an unplanned one.',
          true,
          'The plan defined the loss; abandoning it removes that definition.',
          concept: 'moving_the_stop',
        ),
        FactSpec(
          'A buy stop placed below the current price behaves as intended.',
          false,
          'It triggers immediately, which is the opposite of the intent.',
          concept: 'wrong_side',
        ),
      ],
      extras: [
        SpotMistakeSpec(
          'A trader is long from 100 with a stop at 97. Price reaches 97.4 and they move the '
              'stop to 94, writing "giving it more room".',
          [
            'The invalidation level was abandoned while under pressure',
            'The original stop was too wide',
            'They should have added to the position',
            'They should have used a limit order',
          ],
          0,
          MistakeTag.ignoredInvalidation,
          '97 was chosen as the level that would make the idea wrong. Nothing about the chart '
              'changed — only the discomfort of being close to it. The loss is now larger and '
              'unplanned.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Orders in Practice',
      subtitle: 'Scenarios, one order each',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro: 'Several situations. For each, identify the order that matches the intention described.',
      concepts: [
        ConceptSpec(
          'Reading the intent',
          'Extracting what the trader actually wants from how they describe it.',
          'Phrases map to order types: "only if it gets there" means a limit; "only if it breaks" '
              'means a stop; "now, whatever the price" means market.',
        ),
        ConceptSpec(
          'Cost awareness',
          'Knowing what each choice costs before making it.',
          'Market orders cost the spread and possible slippage. Limit orders cost missed trades. '
              'Neither is free; they are just different bills.',
        ),
      ],
      quizzes: [
        QuizSpec(
          '"I want in only if it gets back down to 96" describes which order?',
          [
            'A buy limit at 96',
            'A buy stop at 96',
            'A market order',
            'A sell limit at 96',
          ],
          0,
          '"Only if it gets down to" is a limit sitting below the current price.',
          concept: 'reading_the_intent',
        ),
        QuizSpec(
          '"I want in only if it breaks above 104" describes which order?',
          [
            'A buy stop at 104',
            'A buy limit at 104',
            'A market order',
            'A sell stop at 104',
          ],
          0,
          '"Only if it breaks above" requires a trigger above the current price.',
          concept: 'reading_the_intent',
        ),
        QuizSpec(
          'Which cost belongs to limit orders specifically?',
          [
            'Trades you never enter',
            'The spread on entry',
            'Slippage on the fill',
            'Higher commission',
          ],
          0,
          'The limit order trades participation for price certainty.',
          concept: 'cost_awareness',
        ),
      ],
      facts: [
        FactSpec(
          'Every order type has a cost; they are simply different costs.',
          true,
          'Spread and slippage on one side, missed trades on the other.',
          concept: 'cost_awareness',
        ),
        FactSpec(
          'The phrase "only if it breaks" implies a limit order.',
          false,
          'It implies a stop order — action conditional on trading through a level.',
          concept: 'reading_the_intent',
        ),
      ],
      extras: [
        OrderTypeSpec(
          'A news release is in ten seconds and you want to be flat immediately, whatever the '
              'cost.',
          OrderType.market,
          'Immediacy overrides price entirely, which is what a market order provides.',
        ),
        OrderTypeSpec(
          'You have identified a resistance area and want to be short only if price reaches it, '
              'accepting that it may not.',
          OrderType.limit,
          'A sell limit at the area: your price or better, with no obligation to trade.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Orders and Risk',
      subtitle: 'How execution feeds the risk calculation',
      minutes: 5,
      difficulty: Difficulty.advanced,
      intro:
          'Execution is where the plan meets reality. Fill prices, not planned prices, determine '
          'what actually happened.',
      concepts: [
        ConceptSpec(
          'Planned versus actual',
          'The difference between the prices in the plan and the prices you were filled at.',
          'Your journal should record both. The gap between them is a measurable part of your '
              'execution quality, separate from whether the idea was good.',
        ),
        ConceptSpec(
          'Risk drift',
          'Realised risk differing from planned risk because of fills.',
          'Enter worse than planned and the stop distance grows; the same position now risks more '
              'than intended. Small drifts compound across many trades.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'You planned to enter at 100 with a stop at 98, but were filled at 100.6. What happened '
              'to your risk?',
          [
            'Stop distance grew from 2.0 to 2.6, so the same size now risks 30% more',
            'Risk is unchanged',
            'Risk fell',
            'The stop should move down to compensate',
          ],
          0,
          'Size was calculated from a 2.0 distance. At 2.6 the same size risks proportionally '
              'more.',
          optionFeedback: {
            3: 'Moving the stop to fit the size is backwards — size should be adjusted instead.',
          },
          concept: 'risk_drift',
        ),
        QuizSpec(
          'The correct response to a worse-than-planned fill is:',
          [
            'Reduce size so the money risked stays the same, or skip the trade',
            'Move the stop closer',
            'Accept the larger risk',
            'Add to the position to average in',
          ],
          0,
          'The risk amount is the fixed quantity. Size is the variable that adjusts.',
          concept: 'risk_drift',
        ),
        QuizSpec(
          'Why record both planned and actual prices in a journal?',
          [
            'It separates execution quality from the quality of the idea',
            'Brokers require it',
            'It calculates tax',
            'It is not necessary',
          ],
          0,
          'Two different problems need two different fixes, and you cannot tell them apart '
              'without both numbers.',
          concept: 'planned_versus_actual',
        ),
      ],
      facts: [
        FactSpec(
          'A worse entry fill increases risk if position size is not adjusted.',
          true,
          'Stop distance grew while size stayed the same.',
          concept: 'risk_drift',
        ),
        FactSpec(
          'Execution quality and idea quality are the same thing.',
          false,
          'A good idea can be executed badly and a poor idea executed cleanly.',
          concept: 'planned_versus_actual',
        ),
      ],
      extras: [
        RiskCalcSpec(
          r'Planned entry 50.00, stop 49.00, risk $200. What position size does the plan imply?',
          200,
          r'Risk ÷ stop distance = $200 ÷ 1.00 = 200 units.',
          concept: 'position_sizing',
        ),
      ],
    ),
    LessonSpec(
      title: 'Execution Practice',
      subtitle: 'Full scenarios, end to end',
      minutes: 6,
      difficulty: Difficulty.advanced,
      intro: 'Mixed scenarios combining order choice, structure and the consequences for risk.',
      concepts: [
        ConceptSpec(
          'Execution checklist',
          'The questions to answer before sending any order.',
          'What am I trying to achieve? Which order expresses that? What does it cost me? What '
              'happens to my risk if the fill is poor? Four questions, every time.',
        ),
        ConceptSpec(
          'Consistency',
          'Using the same process regardless of how the chart feels.',
          'Execution is the easiest part of trading to make mechanical, which makes it the '
              'cheapest place to remove variance from your results.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Which question is missing from "which order type should I use?"',
          [
            'What happens to my risk if the fill is worse than planned',
            'What time is it',
            'What is the trend',
            'What did I trade last',
          ],
          0,
          'Fill quality feeds directly into realised risk, so it belongs in the checklist.',
          concept: 'execution_checklist',
        ),
        QuizSpec(
          'Why make execution mechanical?',
          [
            'It is the part of trading where consistency is easiest and cheapest to achieve',
            'It improves your reading of structure',
            'It removes the need for a plan',
            'Brokers give better fills',
          ],
          0,
          'Removing variance where it is easy leaves attention for the parts that are hard.',
          concept: 'consistency',
        ),
        QuizSpec(
          'You want a specific price and are willing to miss the trade. A market order here would:',
          [
            'Contradict your stated intent by filling immediately at whatever is available',
            'Be the safest choice',
            'Guarantee your price',
            'Be identical to a limit order',
          ],
          0,
          'The order must match the intent, and here the intent is price certainty.',
          concept: 'execution_checklist',
          mistake: MistakeTag.wrongOrderType,
        ),
      ],
      facts: [
        FactSpec(
          'Execution is the part of trading where consistency is easiest to achieve.',
          true,
          'The rules can be written down completely, unlike chart reading.',
          concept: 'consistency',
        ),
        FactSpec(
          'The order type has no bearing on the risk calculation.',
          false,
          'It affects the fill, which affects stop distance, which affects size.',
          concept: 'execution_checklist',
        ),
      ],
      extras: [
        OrderTypeSpec(
          'You are watching a range and want to be short only if price trades below the range '
              'low, not before.',
          OrderType.stop,
          'A sell stop under the range low: conditional on the break happening.',
        ),
        SpotMistakeSpec(
          'A trader wants to buy a pullback to 96 but "does not want to miss it", so they send a '
              'market buy at 101 while price is still rising.',
          [
            'The order taken contradicts the plan that was written',
            'They should have bought more',
            'Pullbacks cannot be traded',
            '96 was too far away',
          ],
          0,
          MistakeTag.lateEntry,
          'The plan was a limit at 96. Entering at 101 puts the entry five points further from '
              'the invalidation level, which changes the risk on every unit held.',
        ),
      ],
    ),
  ],
  boss: BossSpec(
    title: 'Execution Challenge',
    subtitle: 'The right order for the right intent',
    difficulty: Difficulty.advanced,
    minutes: 8,
    intro:
        'Order selection, slippage and the link between execution and risk. Score 80% to unlock '
        'Stop Loss & Take Profit.',
    charts: [
      ChartTaskSpec(
        ChartTask.buildTradeLong,
        ChartPattern.uptrendPullback,
        69001,
      ),
      ChartTaskSpec(ChartTask.decideDirection, ChartPattern.breakoutUp, 69002),
    ],
    quizzes: [
      QuizSpec(
        'Which order guarantees a fill but not a price?',
        ['Market', 'Limit', 'Stop-limit', 'None of them'],
        0,
        'Immediacy at the cost of price certainty.',
        concept: 'market_order',
      ),
      QuizSpec(
        'A buy stop is placed above the current price in order to:',
        [
          'Enter only if price trades up through the level',
          'Buy cheaper than the current price',
          'Exit a long position',
          'Guarantee the trigger price',
        ],
        0,
        'Conditional entry on an upward break.',
        concept: 'breakout_entry',
      ),
      QuizSpec(
        'Filled at 100.5 instead of the planned 100.0, with the stop still at 98.0. What should '
            'change?',
        [
          'Position size, so the money risked stays as planned',
          'The stop, moved up to 98.5',
          'Nothing',
          'The target only',
        ],
        0,
        'Stop distance grew from 2.0 to 2.5, so size must fall to keep risk constant.',
        concept: 'risk_drift',
      ),
      QuizSpec(
        'The cost specific to limit orders is:',
        ['Missed trades', 'The spread', 'Slippage', 'Commission'],
        0,
        'Price certainty is paid for with participation.',
        concept: 'missed_fill',
      ),
    ],
    extras: [
      OrderTypeSpec(
        'You want to close a long immediately because the structural reason for it has gone.',
        OrderType.market,
        'Being out now matters more than the exact exit price.',
      ),
      OrderTypeSpec(
        'You want to short only if price returns up to a resistance area you marked earlier.',
        OrderType.limit,
        'A sell limit at the area gives price certainty and accepts a possible miss.',
      ),
    ],
    facts: [
      FactSpec(
        'A triggered stop order can fill at a worse price than its trigger level.',
        true,
        'It becomes a market order once triggered.',
        concept: 'stop_order',
      ),
    ],
  ),
);
