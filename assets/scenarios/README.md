# Scenario assets

There are no bundled scenario files, and that is deliberate.

Simulation scenarios are **procedural**. `ScenarioGenerator.byIndex(n)` maps an
integer to a fully-specified window — instrument, timeframe, chart shape, seed,
visible range and decision point — and the candles are rebuilt on demand. The
addressable space is 250,000 windows (`ScenarioGenerator.scenarioSpace`), none
of which exist until asked for, so the app ships no scenario data at all while
scenario 91,203 is still identical on every device and in every test run.

Packages generated from imported CSV data (see `assets/market_data/README.md`)
land here.
