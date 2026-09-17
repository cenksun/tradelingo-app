import '../../../domain/models/enums.dart';
import '../../../domain/models/skill.dart';
import '../lesson_spec.dart';

/// World 1 — Trading Basics.
///
/// Assumes no prior knowledge at all. Nothing here requires reading a chart
/// until lesson 5, and jargon is introduced one term at a time.
const WorldSpec world01Basics = WorldSpec(
  id: 'w01',
  index: 1,
  title: 'Trading Basics',
  subtitle: 'What a market is and how prices happen',
  description:
      'Start from zero: what gets traded, who trades it, where a price comes from and what the '
      'words mean.',
  primarySkillId: Skills.marketBasics,
  accentColor: 0xFF2BE5A8,
  lessons: [
    LessonSpec(
      title: 'What Is a Market?',
      subtitle: 'Buyers, sellers and an agreed price',
      minutes: 4,
      intro:
          'A market is any place where people who want to buy something meet people who want to '
          'sell it. A farmers market and a currency market work the same way: someone offers, '
          'someone accepts, and the price they agree on becomes "the price".\n\n'
          'Everything else in this app builds on that one idea.',
      concepts: [
        ConceptSpec(
          'Market',
          'A place where buyers and sellers meet to trade something.',
          'A market does not set prices. It is just the meeting point. Prices come out of what '
              'buyers and sellers actually agree to do. A market can be a physical room, but for '
              'the instruments in this app it is a computer system matching orders.',
        ),
        ConceptSpec(
          'Price',
          'The amount of money agreed in the most recent completed trade.',
          'When you see a price on a screen, you are looking at history: it is what the last '
              'buyer and seller agreed on. It is not a promise about the next trade. A moment '
              'later, a different buyer and seller may agree on something else.',
          bullets: [
            'Price is a record of the last agreement, not a forecast.',
            'A price with nobody willing to trade at it is just a number.',
          ],
        ),
        ConceptSpec(
          'Trade',
          'One completed exchange between a buyer and a seller.',
          'A trade needs both sides. If you want to buy and nobody will sell, nothing happens. '
              'This is why the phrase "there were more buyers than sellers" is misleading — every '
              'trade has exactly one of each. What changes is how eager each side is.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What does the price shown on a trading screen actually tell you?',
          [
            'What the last buyer and seller agreed to trade at',
            'What the asset is truly worth',
            'What the price will be in an hour',
            'What most people think the asset should cost',
          ],
          0,
          'A quoted price is a record of the most recent completed trade. It says nothing '
              'certain about value or about the future.',
          optionFeedback: {
            1: '"True worth" is an opinion, and different participants hold different ones.',
            2: 'No visible price contains information about the future.',
            3: 'Opinion polls do not move prices; completed trades do.',
          },
          concept: 'price',
        ),
        QuizSpec(
          'In every completed trade, how many buyers and sellers are involved?',
          [
            'One buyer and one seller',
            'Many buyers, one seller',
            'It varies with the size of the trade',
            'One buyer and many sellers',
          ],
          0,
          'Every trade matches exactly one buying side with one selling side. Saying there were '
              '"more buyers than sellers" is loose language for one side being more willing to '
              'pay up.',
          concept: 'trade',
        ),
        QuizSpec(
          'A market by itself does what?',
          [
            'Matches people who want to buy with people who want to sell',
            'Decides the fair price of each asset',
            'Guarantees that everyone can trade at the price they want',
            'Prevents prices from falling too far',
          ],
          0,
          'The market is the meeting point. It does not set, guarantee or defend any price.',
          concept: 'market',
        ),
      ],
      facts: [
        FactSpec(
          'If nobody is willing to trade at a given price, that price is still meaningful.',
          false,
          'A price only means something when someone is prepared to act on it. A number with no '
              'willing buyer or seller behind it cannot be traded.',
          concept: 'price',
        ),
        FactSpec(
          'The price on your screen is a record of something that already happened.',
          true,
          'Quoted prices report the last completed trade. Everything after that is still unknown.',
          concept: 'price',
        ),
      ],
      recap:
          'A market is a meeting point. A price is the record of the last agreement made in it. '
          'Every trade has one buyer and one seller. Hold on to that and the rest of the '
          'vocabulary will fall into place.',
    ),
    LessonSpec(
      title: 'What You Can Trade',
      subtitle: 'Assets, instruments and tickers',
      minutes: 4,
      intro:
          'Different markets trade different things, but the mechanics barely change. Once you '
          'can read one market you can read most of them.',
      concepts: [
        ConceptSpec(
          'Asset',
          'The thing being bought and sold in a market.',
          'A share of a company, an ounce of gold, one euro, one bitcoin — each is an asset. The '
              'asset is what changes hands. What you see on a chart is the price of one asset '
              'measured in another.',
        ),
        ConceptSpec(
          'Instrument',
          'The specific tradable product that represents an asset.',
          'You rarely trade the raw asset. You trade an instrument: a share, a futures contract, '
              'a spot currency pair. Two instruments can track the same asset and still behave '
              'differently because their rules differ.',
        ),
        ConceptSpec(
          'Ticker',
          'The short code that identifies an instrument.',
          'BTC/USDT, EUR/USD, AAPL. In a pair like BTC/USDT the first code is what you are '
              'pricing and the second is what you are pricing it in. "BTC/USDT at 42,000" means '
              'one bitcoin costs 42,000 tether.',
          bullets: [
            'The left side of a pair is the thing being priced.',
            'The right side is the money it is priced in.',
          ],
        ),
      ],
      quizzes: [
        QuizSpec(
          r'If EUR/USD is quoted at 1.0850, what does that mean?',
          [
            'One euro costs 1.0850 US dollars',
            'One US dollar costs 1.0850 euros',
            'Euros and dollars are both worth 1.0850',
            'The euro has risen 1.0850% today',
          ],
          0,
          'In a pair, the left code is priced in the right code. EUR/USD tells you the dollar '
              'cost of one euro.',
          optionFeedback: {
            1: 'That would be the USD/EUR quote — the pair the other way round.',
          },
          concept: 'ticker',
        ),
        QuizSpec(
          'Why can two instruments tracking the same asset behave differently?',
          [
            'Because their rules — expiry, contract size, trading hours — differ',
            'Because one of them must be mispriced',
            'They cannot; the same asset always moves identically',
            'Because charts are drawn differently by each provider',
          ],
          0,
          'Instruments carry their own rules. A futures contract on gold expires; a spot gold '
              'position does not. Those differences show up in the price.',
          concept: 'instrument',
        ),
        QuizSpec(
          'Which of these is an asset rather than an instrument?',
          [
            'Gold itself',
            'A gold futures contract',
            'A gold mining company share',
            'A gold exchange-traded fund',
          ],
          0,
          'Gold is the underlying asset. The other three are products built around it, each with '
              'its own rules.',
          concept: 'asset',
        ),
      ],
      facts: [
        FactSpec(
          'A chart always shows the price of one thing measured in another thing.',
          true,
          'Even a single-name stock chart is priced in a currency. There is no such thing as a '
              'price without a unit.',
          concept: 'ticker',
        ),
        FactSpec(
          'Learning to read one market means starting again from scratch for the next one.',
          false,
          'The mechanics — bid, ask, orders, structure — carry across markets. Only the '
              'instrument rules change.',
          concept: 'instrument',
        ),
      ],
    ),
    LessonSpec(
      title: 'Where Price Comes From',
      subtitle: 'Willingness, not value',
      minutes: 4,
      intro:
          'Prices move because the willingness of buyers and sellers changes. Nobody has to be '
          'right for price to move — they only have to act.',
      concepts: [
        ConceptSpec(
          'Demand',
          'How willing buyers are to pay up right now.',
          'When buyers are eager they stop waiting for a better price and accept what sellers '
              'are asking. That lifts the traded price. Eagerness, not correctness, is what moves '
              'the number.',
        ),
        ConceptSpec(
          'Supply',
          'How willing sellers are to accept less right now.',
          'When sellers want out badly enough, they stop holding for a better price and accept '
              'what buyers are bidding. That pushes the traded price down.',
        ),
        ConceptSpec(
          'Order flow',
          'The running stream of buy and sell orders hitting the market.',
          'Every tick on a chart is the result of orders arriving. You do not need to see '
              'individual orders to trade, but knowing that price moves because someone acted — '
              'not because a chart pattern said so — keeps your reasoning honest.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'What makes a traded price rise?',
          [
            'Buyers becoming willing to pay the prices sellers are asking',
            'More people believing the asset is undervalued',
            'The asset becoming genuinely more valuable',
            'Analysts upgrading their forecasts',
          ],
          0,
          'Price rises when buyers act on higher offers. Beliefs and forecasts only matter when '
              'somebody turns them into an order.',
          optionFeedback: {
            1: 'Belief without action leaves the price where it was.',
            3: 'A forecast moves price only if it causes somebody to trade.',
          },
          concept: 'demand',
        ),
        QuizSpec(
          'A price falls sharply on no news at all. What is the most reasonable reading?',
          [
            'Sellers were willing to accept lower prices to get filled',
            'The asset became worth less in a few seconds',
            'Something must be wrong with the exchange',
            'Buyers disappeared entirely from the market',
          ],
          0,
          'Price reflects willingness. Sellers accepting lower bids is a complete explanation on '
              'its own — no news required.',
          concept: 'supply',
        ),
        QuizSpec(
          'Which statement is safe to make about a chart?',
          [
            'It records what buyers and sellers did',
            'It reveals what buyers and sellers will do next',
            'It shows the correct value of the asset',
            'It proves who is currently winning',
          ],
          0,
          'A chart is a record. Reading it well is a skill; treating it as a forecast is not.',
          concept: 'order_flow',
        ),
      ],
      facts: [
        FactSpec(
          'Price can move a long way without any news being released.',
          true,
          'Willingness can shift for reasons no headline captures: position sizes, deadlines, '
              'margin, or simple impatience.',
          concept: 'order_flow',
        ),
        FactSpec(
          'For price to move, somebody has to actually place an order.',
          true,
          'Opinions are free. Only orders change the traded price.',
          concept: 'order_flow',
        ),
      ],
    ),
    LessonSpec(
      title: 'Bid, Ask and the Spread',
      subtitle: 'The two prices that always exist',
      minutes: 5,
      intro:
          'There is never just one price. There is a price you can sell at and a price you can '
          'buy at, and they are not the same.',
      concepts: [
        ConceptSpec(
          'Bid',
          'The highest price a buyer is currently willing to pay.',
          'If you want to sell immediately, the bid is what you get. It is somebody else standing '
              'ready to buy from you.',
        ),
        ConceptSpec(
          'Ask',
          'The lowest price a seller is currently willing to accept.',
          'Also called the offer. If you want to buy immediately, the ask is what you pay. It is '
              'somebody else standing ready to sell to you.',
        ),
        ConceptSpec(
          'Spread',
          'The gap between the bid and the ask.',
          'The spread is a real cost. Buy at the ask and sell instantly at the bid and you are '
              'down by the spread before price has moved at all. Widely traded instruments '
              'usually have narrow spreads; thin ones can be surprisingly expensive.',
          bullets: [
            'Spread = ask − bid.',
            'You cross the spread every time you demand an immediate fill.',
          ],
        ),
      ],
      quizzes: [
        QuizSpec(
          'The bid is 100.20 and the ask is 100.30. You buy immediately and sell again a second '
              'later with no price change. What happens?',
          [
            'You lose 0.10 per unit — the spread',
            'You break even, because the price did not move',
            'You gain 0.10 per unit',
            'Nothing happens until the price moves',
          ],
          0,
          'You bought at 100.30 and sold at 100.20. The 0.10 spread is a cost you paid for '
              'immediacy on both sides.',
          optionFeedback: {
            1: 'The mid price did not move, but you did not trade at the mid price.',
          },
          concept: 'spread',
        ),
        QuizSpec(
          'You want to sell right now. Which price do you get?',
          ['The bid', 'The ask', 'The midpoint', 'Whichever is higher'],
          0,
          'Selling immediately means accepting the best available buyer — the bid.',
          concept: 'bid',
        ),
        QuizSpec(
          'A thinly traded instrument usually has:',
          [
            'A wider spread, making immediate trades more expensive',
            'A narrower spread, because fewer people compete',
            'No spread at all',
            'A spread that only appears during news',
          ],
          0,
          'Fewer participants means less competition to post the best bid and ask, so the gap '
              'between them widens.',
          concept: 'spread',
        ),
      ],
      facts: [
        FactSpec(
          'The spread is a cost you pay even when your trade is profitable.',
          true,
          'It is paid on entry and again on exit. Profitable trades simply cover it.',
          concept: 'spread',
        ),
        FactSpec(
          'The bid is always higher than the ask.',
          false,
          'It is the other way round: the ask is higher. If the bid were above the ask, the two '
              'would immediately trade with each other.',
          concept: 'bid',
        ),
      ],
      extras: [
        RiskCalcSpec(
          'The bid is 42,180 and the ask is 42,205. What is the spread?',
          25,
          'Spread = ask − bid = 42,205 − 42,180 = 25.',
          concept: 'spread',
        ),
      ],
    ),
    LessonSpec(
      title: 'Reading a Price Chart',
      subtitle: 'Time across, price up',
      minutes: 5,
      difficulty: Difficulty.beginner,
      intro:
          'A chart has two axes and that is most of what you need to know to start. Time runs '
          'left to right. Price runs bottom to top. Everything else is detail layered on top.\n\n'
          'The charts in this app are generated educational data, built to show specific '
          'structures clearly. They are not recordings of real market history.',
      concepts: [
        ConceptSpec(
          'Time axis',
          'The horizontal axis, running from oldest on the left to newest on the right.',
          'The rightmost candle is the most recent. Anything to the right of it has not happened '
              'yet — which is exactly why the simulator in this app hides it from you until you '
              'have decided.',
        ),
        ConceptSpec(
          'Price axis',
          'The vertical axis, showing the price level.',
          'Higher on the screen means a higher price. The scale usually adjusts to fit whatever '
              'is visible, so the same move can look dramatic or tame depending on the zoom.',
        ),
        ConceptSpec(
          'Chart scaling',
          'How the visible price range is stretched to fill the screen.',
          'Because scaling adapts, steepness is not a reliable measure of how big a move was. '
              'Read the numbers on the price axis before deciding something was violent.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'On a standard price chart, where is the most recent data?',
          [
            'On the far right',
            'On the far left',
            'In the middle',
            'It depends on the platform',
          ],
          0,
          'Time runs left to right, so the newest candle is always the rightmost one.',
          concept: 'time_axis',
        ),
        QuizSpec(
          'Two charts of the same move look completely different in steepness. Why?',
          [
            'The vertical scaling differs between them',
            'One of them has incorrect data',
            'Steepness is random',
            'The timeframe cannot affect appearance',
          ],
          0,
          'Charts stretch the visible price range to fill the screen. Always check the axis '
              'before judging the size of a move.',
          concept: 'chart_scaling',
        ),
        QuizSpec(
          'Why does this app hide the candles to the right of your decision point?',
          [
            'So your decision is made with the same information you would really have',
            'To make the app load faster',
            'Because future candles are not generated yet',
            'To make simulations harder for no particular reason',
          ],
          0,
          'Seeing the outcome before deciding teaches nothing. Hiding it is what makes the '
              'practice honest.',
          concept: 'time_axis',
        ),
      ],
      facts: [
        FactSpec(
          'A steep-looking line always means a large price move.',
          false,
          'Steepness depends on scaling. Check the price axis numbers instead.',
          concept: 'chart_scaling',
        ),
        FactSpec(
          'The charts used in this app are generated educational data rather than recorded market history.',
          true,
          'They are built to demonstrate specific structures. The import tool in the repository '
              'can load real OHLCV data later without changing how the app works.',
          concept: 'chart_scaling',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.tapHighestHigh, ChartPattern.uptrend, 10501),
        ChartTaskSpec(ChartTask.tapLowestLow, ChartPattern.downtrend, 10502),
      ],
    ),
    LessonSpec(
      title: 'Who Is On The Other Side',
      subtitle: 'Market participants and their motives',
      minutes: 4,
      intro:
          'Not everyone trading is trying to do what you are trying to do. Understanding that '
          'stops you reading every move as a message aimed at you.',
      concepts: [
        ConceptSpec(
          'Hedger',
          'A participant trading to reduce a risk they already have.',
          'An airline buying fuel futures is not predicting oil prices — it is removing '
              'uncertainty from next year\'s costs. Hedgers will happily trade at prices a '
              'speculator would consider poor, because their goal is different.',
        ),
        ConceptSpec(
          'Speculator',
          'A participant trading to profit from price movement.',
          'Most individual traders are speculators. They take on risk deliberately in exchange '
              'for the possibility of a gain.',
        ),
        ConceptSpec(
          'Market maker',
          'A participant who continuously quotes both a bid and an ask.',
          'Market makers earn the spread for providing immediacy to everyone else. They are not '
              'betting on direction in the way a speculator is; they are running an inventory '
              'business.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A large sell order appears with no news. What is the most level-headed reading?',
          [
            'Someone acted for reasons you cannot see, which may have nothing to do with direction',
            'A big player knows something bad and is warning the market',
            'The asset is now definitely overvalued',
            'It is a trick designed to catch small traders',
          ],
          0,
          'Hedging, rebalancing, redemptions and margin calls all produce large orders that carry '
              'no directional opinion at all.',
          optionFeedback: {
            3: 'Assuming every move is aimed at you leads to reading noise as intent.',
          },
          concept: 'hedger',
        ),
        QuizSpec(
          'How does a market maker primarily make money?',
          [
            'By capturing the spread between bid and ask over many trades',
            'By predicting direction better than everyone else',
            'By charging commission to other traders',
            'By holding positions for years',
          ],
          0,
          'Market makers quote both sides and earn the difference, managing the inventory that '
              'builds up as a result.',
          concept: 'market_maker',
        ),
        QuizSpec(
          'Which participant would happily accept a price a speculator would call bad?',
          [
            'A hedger removing an existing risk',
            'A market maker',
            'A momentum trader',
            'Nobody would',
          ],
          0,
          'A hedger measures success by how much uncertainty they removed, not by the entry price.',
          concept: 'hedger',
        ),
      ],
      facts: [
        FactSpec(
          'Everyone trading an instrument is trying to profit from its direction.',
          false,
          'Hedgers, market makers and index funds all trade for reasons unrelated to a '
              'directional view.',
          concept: 'speculator',
        ),
        FactSpec(
          'A market maker provides immediacy: the ability to trade right now.',
          true,
          'That service is what the spread pays for.',
          concept: 'market_maker',
        ),
      ],
    ),
    LessonSpec(
      title: 'Crypto, Stocks, Forex and Futures',
      subtitle: 'Four markets, one set of mechanics',
      minutes: 5,
      intro:
          'These four markets differ in hours, settlement and who regulates them — but a candle '
          'means the same thing in all of them.',
      concepts: [
        ConceptSpec(
          'Crypto market',
          'Digital assets traded continuously, every day of the year.',
          'No closing bell means no overnight gaps, but it also means a position is exposed while '
              'you sleep. Volatility is typically higher than in the other three.',
        ),
        ConceptSpec(
          'Stock market',
          'Shares in companies, traded during set exchange hours.',
          'Because trading stops, news released overnight arrives all at once at the open, which '
              'produces gaps — a price jump with no trading in between.',
        ),
        ConceptSpec(
          'Forex market',
          'Currencies traded as pairs, effectively around the clock on weekdays.',
          'You are always long one currency and short another at the same time. Forex is the '
              'largest market by volume, and major pairs usually carry very narrow spreads.',
        ),
        ConceptSpec(
          'Futures market',
          'Standardised contracts to trade something at a set date.',
          'Futures have expiries and contract sizes, which makes position sizing more rigid than '
              'in spot markets. They are widely used for both hedging and speculation.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'Why do stock charts show gaps more often than crypto charts?',
          [
            'Stock exchanges close, so news accumulates and arrives at the open',
            'Stocks are more volatile than crypto',
            'Crypto exchanges hide gaps',
            'Gaps are a charting error',
          ],
          0,
          'A gap is a price jump with no trading in between. Continuous markets rarely produce '
              'them because trading never stops.',
          concept: 'stock_market',
        ),
        QuizSpec(
          'When you buy EUR/USD, what are you actually doing?',
          [
            'Buying euros and selling dollars at the same time',
            'Buying euros only',
            'Buying a contract that expires next month',
            'Buying a share in the European economy',
          ],
          0,
          'Every forex position is a pair of opposite exposures held simultaneously.',
          concept: 'forex_market',
        ),
        QuizSpec(
          'What makes position sizing less flexible in futures than in spot crypto?',
          [
            'Contracts come in fixed standardised sizes',
            'Futures cannot be sold short',
            'Futures have no price charts',
            'Futures brokers forbid small accounts',
          ],
          0,
          'You trade a whole number of contracts, so size moves in steps rather than smoothly.',
          concept: 'futures_market',
        ),
      ],
      facts: [
        FactSpec(
          'A candle means something different in forex than it does in crypto.',
          false,
          'Open, high, low and close mean exactly the same thing in every market. Only the '
              'instrument rules differ.',
          concept: 'forex_market',
        ),
        FactSpec(
          'A market that never closes removes the risk of holding overnight.',
          false,
          'It removes gaps, not risk. A position is still exposed to every move while you sleep.',
          concept: 'crypto_market',
        ),
      ],
      charts: [
        ChartTaskSpec(ChartTask.tapHighestHigh, ChartPattern.range, 10701),
      ],
    ),
    LessonSpec(
      title: 'Trading and Timeframes',
      subtitle: 'The same chart at different zoom levels',
      minutes: 4,
      intro:
          'A timeframe decides how much time each candle represents. Change it and the same '
          'market can look calm or chaotic without a single price changing.',
      concepts: [
        ConceptSpec(
          'Timeframe',
          'How much time one candle on the chart represents.',
          'On a 1-hour chart each candle covers an hour of trading. On a daily chart each candle '
              'covers a full day. Same market, same prices, different amount of detail.',
        ),
        ConceptSpec(
          'Higher timeframe',
          'A chart where each candle covers more time.',
          'Higher timeframes compress detail, which makes the larger structure easier to see and '
              'slower to change. Fewer decisions, each with more weight behind it.',
        ),
        ConceptSpec(
          'Lower timeframe',
          'A chart where each candle covers less time.',
          'Lower timeframes show more detail and more noise. Signals appear more often and mean '
              'less individually. More decisions, each easier to get wrong.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'How many 15-minute candles cover the same span as one 1-hour candle?',
          ['Four', 'Two', 'Fifteen', 'Sixty'],
          0,
          'Sixty minutes divided by fifteen is four. The four candles hold the same trading, '
              'shown in more detail.',
          concept: 'timeframe',
        ),
        QuizSpec(
          'A move looks enormous on a 1-minute chart and barely visible on a daily chart. What '
              'does that tell you?',
          [
            'It is small relative to the market\'s normal daily movement',
            'One of the charts must be wrong',
            'The daily chart has not updated',
            'It was a data error',
          ],
          0,
          'Both charts are correct. Context decides whether a move is large, and the higher '
              'timeframe supplies that context.',
          concept: 'higher_timeframe',
        ),
        QuizSpec(
          'Why do lower timeframes produce more signals that mean less?',
          [
            'Because they contain more noise relative to real movement',
            'Because their data is less accurate',
            'Because fewer people trade them',
            'Because they update less often',
          ],
          0,
          'Smaller candles capture more random fluctuation, so any given pattern carries less '
              'weight.',
          concept: 'lower_timeframe',
        ),
      ],
      facts: [
        FactSpec(
          'Switching timeframes changes the underlying prices.',
          false,
          'It changes only how the same prices are grouped into candles.',
          concept: 'timeframe',
        ),
        FactSpec(
          'Higher timeframes generally change structure more slowly than lower ones.',
          true,
          'More trading has to happen before a daily swing is broken than before a 5-minute one is.',
          concept: 'higher_timeframe',
        ),
      ],
      charts: [
        ChartTaskSpec(
          ChartTask.tapWidestRange,
          ChartPattern.choppyVolatile,
          10801,
          note: 'On noisy charts the widest candle is often not the one with the biggest body.',
        ),
      ],
    ),
    LessonSpec(
      title: 'Core Trading Vocabulary',
      subtitle: 'The words used everywhere from here on',
      minutes: 5,
      intro:
          'These terms appear in every later world. Getting them exact now saves confusion when '
          'the ideas get more involved.',
      concepts: [
        ConceptSpec(
          'Position',
          'An open exposure to price movement in one direction.',
          'You have a position from the moment a trade is filled until you close it. Before that '
              'you have an idea; after that you have a result.',
        ),
        ConceptSpec(
          'Volatility',
          'How much price tends to move over a given period.',
          'High volatility means wider candles and larger swings. It is not the same as '
              'direction: a market can be extremely volatile and finish exactly where it started.',
        ),
        ConceptSpec(
          'Liquidity',
          'How easily you can trade size without moving the price much.',
          'In a liquid market a large order barely shifts the price. In an illiquid one, the same '
              'order can move it a long way — which shows up as slippage and wide spreads.',
        ),
        ConceptSpec(
          'Drawdown',
          'A fall from a peak in account value down to a low point.',
          'Drawdown is measured from the highest point reached, not from where you started. It '
              'is the number that decides whether a strategy is survivable in practice.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A market moves violently all day and closes unchanged. How would you describe it?',
          [
            'High volatility, no net direction',
            'Low volatility',
            'A strong trend',
            'An illiquid market',
          ],
          0,
          'Volatility measures movement, not progress. Large swings with no net change are '
              'exactly that.',
          concept: 'volatility',
        ),
        QuizSpec(
          'Your account went from \$10,000 up to \$12,000 and then down to \$9,000. What is the '
              'drawdown?',
          [
            r'$3,000 — measured from the $12,000 peak',
            r'$1,000 — measured from the starting balance',
            r'$2,000',
            'There is no drawdown because you are only down on paper',
          ],
          0,
          'Drawdown runs from the peak, so \$12,000 down to \$9,000 is \$3,000, or 25%.',
          optionFeedback: {
            1: 'Drawdown is measured from the high-water mark, not the opening balance.',
          },
          concept: 'drawdown',
        ),
        QuizSpec(
          'What is the practical sign of poor liquidity?',
          [
            'Wide spreads and orders that fill at worse prices than expected',
            'Prices that never move',
            'Charts that update slowly',
            'High trading fees',
          ],
          0,
          'Thin markets cannot absorb size, so you pay for immediacy through the spread and '
              'through slippage.',
          concept: 'liquidity',
        ),
      ],
      facts: [
        FactSpec(
          'High volatility means price is going up quickly.',
          false,
          'Volatility describes the size of movement in either direction, not which way it goes.',
          concept: 'volatility',
        ),
        FactSpec(
          'Drawdown is measured from the highest account value reached, not from the starting balance.',
          true,
          'That is what makes it a measure of the worst experience along the way.',
          concept: 'drawdown',
        ),
      ],
    ),
    LessonSpec(
      title: 'What Trading Actually Involves',
      subtitle: 'Honest expectations before the charts begin',
      minutes: 5,
      intro:
          'Before a single chart pattern, some plain framing.\n\n'
          'Trading is a skill with a real cost of failure. Most people who try it lose money. '
          'Nothing in this app — and nothing anywhere else — removes that. What study can do is '
          'make your decisions deliberate instead of accidental.',
      concepts: [
        ConceptSpec(
          'Uncertainty',
          'The permanent condition of trading: no setup has a known outcome.',
          'Every framework in this app describes what price has already done and organises it. '
              'None of them predicts. A well-reasoned trade can lose and a reckless one can win. '
              'Judging decisions by their outcomes is the single most common way traders learn '
              'the wrong lesson.',
        ),
        ConceptSpec(
          'Process',
          'The part of trading you actually control.',
          'You control what you risk, where you define invalidation, what you target and whether '
              'you follow the plan. You do not control the result of any single trade. This is '
              'why TradePath scores your process rather than your simulated profit.',
        ),
        ConceptSpec(
          'Sample size',
          'The number of trades needed before results mean anything.',
          'Ten trades tell you almost nothing about a method. Randomness dominates small '
              'samples, which is why an early winning streak is not evidence of skill.',
        ),
      ],
      quizzes: [
        QuizSpec(
          'A trader risks half their account on one idea and makes a large profit. How should '
              'that trade be judged?',
          [
            'As a poor decision that happened to work out',
            'As a good decision, because it was profitable',
            'As proof the trader reads the market well',
            'As a reasonable risk given the profit',
          ],
          0,
          'The outcome does not validate the decision. Repeated often enough, that level of risk '
              'ends an account regardless of how well any single trade goes.',
          optionFeedback: {
            1: 'Judging decisions by outcomes rewards luck and punishes discipline.',
          },
          concept: 'process',
          mistake: MistakeTag.overRisk,
        ),
        QuizSpec(
          'What can a technical framework honestly tell you?',
          [
            'How to organise what price has already done',
            'Where price will go next',
            'Which trades will be profitable',
            'When a reversal is guaranteed',
          ],
          0,
          'Frameworks are descriptive. They structure the past so decisions can be consistent — '
              'they do not forecast.',
          concept: 'uncertainty',
        ),
        QuizSpec(
          'After eight winning trades in a row, what do you know about your method?',
          [
            'Very little — the sample is far too small',
            'That it works',
            'That you can increase risk safely',
            'That you have found an edge',
          ],
          0,
          'Short streaks happen easily by chance. Conclusions need far more trades than most '
              'people expect.',
          concept: 'sample_size',
        ),
      ],
      facts: [
        FactSpec(
          'A losing trade always means the decision behind it was wrong.',
          false,
          'Sound decisions lose regularly. That is what trading under uncertainty means.',
          concept: 'uncertainty',
        ),
        FactSpec(
          'TradePath simulations use virtual money and are for education only.',
          true,
          'Every balance in the simulator is simulated. Nothing here is investment advice, and '
              'simulated results do not indicate future performance.',
          concept: 'process',
        ),
      ],
      extras: [
        SpotMistakeSpec(
          'A trader writes: "I am completely certain this breaks out. I am putting 40% of my '
              'account in with no stop, because a stop would just get hit before it works."',
          [
            'Certainty plus no invalidation level plus outsized risk',
            'The position is too small for the conviction',
            'Breakouts should never be traded',
            'The trader should have used a limit order',
          ],
          0,
          MistakeTag.overRisk,
          'Three problems compound here: certainty about an unknowable outcome, no defined point '
              'where the idea is wrong, and a position large enough that being wrong once is '
              'severe. Any one of them is a problem; together they are how accounts end.',
        ),
      ],
      recap:
          'Trading is a skill practised under permanent uncertainty. You control risk, '
          'invalidation, targets and adherence — not outcomes. That is why this app grades '
          'process, and why every balance you will see is virtual.',
    ),
  ],
  boss: BossSpec(
    title: 'Market Foundations Challenge',
    subtitle: 'Everything from World 1',
    difficulty: Difficulty.beginner,
    minutes: 7,
    intro:
        'Ten short questions drawn from the whole world: markets, prices, spreads, participants '
        'and honest expectations. Score 80% to unlock Candlesticks.',
    charts: [
      ChartTaskSpec(ChartTask.tapHighestHigh, ChartPattern.uptrend, 19001),
      ChartTaskSpec(ChartTask.tapLowestLow, ChartPattern.range, 19002),
    ],
    quizzes: [
      QuizSpec(
        'What does a quoted price represent?',
        [
          'The last completed agreement between a buyer and a seller',
          'The true value of the asset',
          'The average opinion of all participants',
          'A forecast of the next move',
        ],
        0,
        'A price is a record of the most recent trade — nothing more.',
        concept: 'price',
      ),
      QuizSpec(
        'You buy at the ask and immediately sell at the bid. Before any price movement, you are:',
        [
          'Down by the spread',
          'Flat',
          'Up by the spread',
          'Down by the commission only',
        ],
        0,
        'Crossing the spread in both directions is a cost paid for immediacy.',
        concept: 'spread',
      ),
      QuizSpec(
        'Which participant trades specifically to reduce a risk they already carry?',
        ['A hedger', 'A speculator', 'A momentum trader', 'A market maker'],
        0,
        'Hedging is about removing uncertainty, not capturing direction.',
        concept: 'hedger',
      ),
      QuizSpec(
        'An account peaks at \$15,000 and falls to \$11,250. The drawdown is:',
        ['25%', '10%', '33%', 'There is none until the position closes'],
        0,
        r'$3,750 from a $15,000 peak is 25%. Drawdown always runs from the high-water mark.',
        concept: 'drawdown',
      ),
      QuizSpec(
        'Which claim would be dishonest to make about any technical framework?',
        [
          'It tells you where price will go next',
          'It organises what price has already done',
          'It helps make decisions consistent',
          'It describes structure',
        ],
        0,
        'Description is honest. Prediction is not.',
        concept: 'uncertainty',
      ),
      QuizSpec(
        'On a chart, the newest candle sits:',
        [
          'On the far right',
          'On the far left',
          'In the centre',
          'Wherever price is highest',
        ],
        0,
        'Time runs left to right on every standard price chart.',
        concept: 'time_axis',
      ),
    ],
    facts: [
      FactSpec(
        'Every completed trade has exactly one buyer and one seller.',
        true,
        'That is what makes a trade a trade. Imbalance shows up as eagerness, not as counts.',
        concept: 'trade',
      ),
      FactSpec(
        'High volatility tells you which direction price is heading.',
        false,
        'Volatility measures the size of movement, not its direction.',
        concept: 'volatility',
      ),
    ],
  ),
);
