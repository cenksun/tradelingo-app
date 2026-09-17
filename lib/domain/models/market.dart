import 'package:meta/meta.dart';

/// A single OHLCV bar.
///
/// Prices are plain doubles. The generator and the importer both guarantee the
/// OHLC invariant (`low <= min(open, close)` and `high >= max(open, close)`),
/// and [isValid] lets callers reject corrupt imported rows instead of painting
/// impossible candles.
@immutable
class Candle {
  const Candle({
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    this.volume = 0,
  });

  final DateTime timestamp;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  bool get isBullish => close > open;
  bool get isBearish => close < open;
  bool get isDoji => close == open;
  double get body => (close - open).abs();
  double get range => high - low;
  double get upperWick => high - (close > open ? close : open);
  double get lowerWick => (close < open ? close : open) - low;
  double get midpoint => (high + low) / 2;

  /// Body as a share of the full range. Returns 0 for zero-range candles
  /// rather than dividing by zero.
  double get bodyRatio => range <= 0 ? 0 : body / range;

  bool get isValid {
    if (!open.isFinite || !high.isFinite || !low.isFinite || !close.isFinite) {
      return false;
    }
    if (open <= 0 || high <= 0 || low <= 0 || close <= 0) return false;
    if (low > high) return false;
    if (open < low || open > high) return false;
    if (close < low || close > high) return false;
    if (!volume.isFinite || volume < 0) return false;
    return true;
  }

  Candle copyWith({
    DateTime? timestamp,
    double? open,
    double? high,
    double? low,
    double? close,
    double? volume,
  }) => Candle(
    timestamp: timestamp ?? this.timestamp,
    open: open ?? this.open,
    high: high ?? this.high,
    low: low ?? this.low,
    close: close ?? this.close,
    volume: volume ?? this.volume,
  );

  Map<String, Object?> toJson() => {
    't': timestamp.millisecondsSinceEpoch,
    'o': open,
    'h': high,
    'l': low,
    'c': close,
    'v': volume,
  };

  static Candle? tryFromJson(Map<String, Object?> json) {
    final t = json['t'];
    final o = json['o'];
    final h = json['h'];
    final l = json['l'];
    final c = json['c'];
    if (t is! num || o is! num || h is! num || l is! num || c is! num) {
      return null;
    }
    final v = json['v'];
    final candle = Candle(
      timestamp: DateTime.fromMillisecondsSinceEpoch(t.toInt()),
      open: o.toDouble(),
      high: h.toDouble(),
      low: l.toDouble(),
      close: c.toDouble(),
      volume: v is num ? v.toDouble() : 0,
    );
    return candle.isValid ? candle : null;
  }

  @override
  String toString() =>
      'Candle(o:$open h:$high l:$low c:$close @ ${timestamp.toIso8601String()})';
}

/// Broad market families. Business logic keys off [AssetClass] rather than
/// assuming crypto, so stocks, forex and futures can be added later without
/// touching the simulator.
enum AssetClass {
  crypto('Crypto', 8),
  stocks('Stocks', 2),
  forex('Forex', 5),
  futures('Futures', 2),
  commodities('Commodities', 2);

  const AssetClass(this.label, this.maxPriceDecimals);
  final String label;
  final int maxPriceDecimals;

  static AssetClass fromName(String? name) => AssetClass.values.firstWhere(
    (a) => a.name == name,
    orElse: () => AssetClass.crypto,
  );
}

/// Chart timeframes. The engine supports all of them; the bundled educational
/// datasets cover a representative subset.
enum Timeframe {
  m1('1m', 1),
  m5('5m', 5),
  m15('15m', 15),
  h1('1h', 60),
  h4('4h', 240),
  d1('1d', 1440);

  const Timeframe(this.label, this.minutes);
  final String label;
  final int minutes;

  Duration get duration => Duration(minutes: minutes);

  /// Rough volatility multiplier: higher timeframes move further per bar.
  double get volatilityScale => switch (this) {
    Timeframe.m1 => 0.30,
    Timeframe.m5 => 0.50,
    Timeframe.m15 => 0.70,
    Timeframe.h1 => 1.00,
    Timeframe.h4 => 1.55,
    Timeframe.d1 => 2.40,
  };

  static Timeframe fromName(String? name) => Timeframe.values.firstWhere(
    (t) => t.name == name,
    orElse: () => Timeframe.h1,
  );
}

/// Metadata for a tradable instrument.
@immutable
class MarketAsset {
  const MarketAsset({
    required this.symbol,
    required this.displayName,
    required this.assetClass,
    required this.referencePrice,
    required this.baseVolatility,
    this.quoteCurrency = 'USD',
    this.contractSize = 1,
    this.availableTimeframes = Timeframe.values,
  });

  final String symbol;
  final String displayName;
  final AssetClass assetClass;

  /// Typical price level, used to scale synthetic series realistically.
  final double referencePrice;

  /// Typical per-bar move as a fraction of price on the 1h timeframe.
  final double baseVolatility;
  final String quoteCurrency;
  final double contractSize;
  final List<Timeframe> availableTimeframes;

  /// Decimal places used when rendering prices for this instrument.
  int get priceDecimals {
    if (referencePrice >= 1000) return 2;
    if (referencePrice >= 10) return assetClass == AssetClass.forex ? 4 : 2;
    if (referencePrice >= 1) return assetClass == AssetClass.forex ? 5 : 3;
    return 5;
  }

  @override
  bool operator ==(Object other) =>
      other is MarketAsset && other.symbol == symbol;

  @override
  int get hashCode => symbol.hashCode;
}

/// The instruments bundled with the offline build, plus the ones the engine is
/// already able to drive once data is supplied.
class AssetCatalog {
  const AssetCatalog._();

  static const MarketAsset btcUsdt = MarketAsset(
    symbol: 'BTC/USDT',
    displayName: 'Bitcoin / Tether',
    assetClass: AssetClass.crypto,
    referencePrice: 42000,
    baseVolatility: 0.0085,
    quoteCurrency: 'USDT',
  );

  static const MarketAsset ethUsdt = MarketAsset(
    symbol: 'ETH/USDT',
    displayName: 'Ethereum / Tether',
    assetClass: AssetClass.crypto,
    referencePrice: 2350,
    baseVolatility: 0.0105,
    quoteCurrency: 'USDT',
  );

  static const MarketAsset solUsdt = MarketAsset(
    symbol: 'SOL/USDT',
    displayName: 'Solana / Tether',
    assetClass: AssetClass.crypto,
    referencePrice: 98,
    baseVolatility: 0.0145,
    quoteCurrency: 'USDT',
  );

  static const MarketAsset eurUsd = MarketAsset(
    symbol: 'EUR/USD',
    displayName: 'Euro / US Dollar',
    assetClass: AssetClass.forex,
    referencePrice: 1.0850,
    baseVolatility: 0.0018,
  );

  static const MarketAsset xauUsd = MarketAsset(
    symbol: 'XAU/USD',
    displayName: 'Gold / US Dollar',
    assetClass: AssetClass.commodities,
    referencePrice: 2040,
    baseVolatility: 0.0035,
  );

  static const MarketAsset nasdaqFutures = MarketAsset(
    symbol: 'MNQ',
    displayName: 'Micro Nasdaq 100 Futures',
    assetClass: AssetClass.futures,
    referencePrice: 17500,
    baseVolatility: 0.0055,
    contractSize: 2,
  );

  static const MarketAsset spFutures = MarketAsset(
    symbol: 'MES',
    displayName: 'Micro S&P 500 Futures',
    assetClass: AssetClass.futures,
    referencePrice: 4780,
    baseVolatility: 0.0042,
    contractSize: 5,
  );

  static const MarketAsset appleStock = MarketAsset(
    symbol: 'AAPL',
    displayName: 'Apple Inc.',
    assetClass: AssetClass.stocks,
    referencePrice: 186,
    baseVolatility: 0.0062,
    availableTimeframes: [
      Timeframe.m15,
      Timeframe.h1,
      Timeframe.h4,
      Timeframe.d1,
    ],
  );

  static const MarketAsset nvidiaStock = MarketAsset(
    symbol: 'NVDA',
    displayName: 'NVIDIA Corporation',
    assetClass: AssetClass.stocks,
    referencePrice: 495,
    baseVolatility: 0.0098,
    availableTimeframes: [
      Timeframe.m15,
      Timeframe.h1,
      Timeframe.h4,
      Timeframe.d1,
    ],
  );

  /// Everything the scenario engine generates from in the offline build.
  static const List<MarketAsset> all = [
    btcUsdt,
    ethUsdt,
    solUsdt,
    eurUsd,
    xauUsd,
    nasdaqFutures,
    spFutures,
    appleStock,
    nvidiaStock,
  ];

  static MarketAsset bySymbol(String symbol) =>
      all.firstWhere((a) => a.symbol == symbol, orElse: () => btcUsdt);

  static List<MarketAsset> byClass(AssetClass assetClass) =>
      all.where((a) => a.assetClass == assetClass).toList(growable: false);

  static List<AssetClass> get classes =>
      all.map((a) => a.assetClass).toSet().toList(growable: false);
}
