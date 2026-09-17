# Bundled market data

TradePath ships with **no recorded market history**. Every chart in the app is
generated from a seed by `SyntheticSeriesGenerator`, which is why the install is
small and why the same exercise looks identical on every device.

Charts produced that way are clearly-labelled **synthetic educational data**.
They are built to demonstrate a specific structure — an uptrend, a failed
breakout, a sweep of equal highs — and they are never presented as a recording
of what a real instrument did.

## Dropping in real data

The simulator consumes `List<Candle>`; it does not care where the candles came
from. To add verified historical data:

```
dart run tools/import_ohlcv.dart \
    --input path/to/BTCUSDT-1h.csv \
    --symbol BTC/USDT \
    --timeframe h1 \
    --class crypto \
    --scenarios 2000 \
    --out assets/market_data
```

That writes two files into this directory:

* `BTC_USDT_h1.json` — the validated candles.
* `BTC_USDT_h1_scenarios.json` — a scenario package: windows over that data,
  each with its decision point, detected features and scored difficulty.

Rows that would draw an impossible candle (a low above its high, an
unparseable timestamp, a non-numeric price) are reported and skipped rather
than silently rendered.

Add the files to the `assets:` list in `pubspec.yaml` and they are available to
the app. No simulator, scoring or charting code changes.
