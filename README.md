# TradePath

An offline-first, gamified trading **education** app built with Flutter.

TradePath teaches chart reading and risk management through 12 worlds of short
lessons, then puts it to work in a simulator that hides the right-hand side of
the chart until you have committed to a decision — and grades how you decided
rather than whether you got lucky.

> **TradePath is an educational simulation product. It does not provide
> investment advice or guarantee future results. Historical or simulated
> performance does not guarantee future performance. Real trading can result in
> financial loss.**

---

## What is in the box

| | |
|---|---|
| Worlds | 12 |
| Lessons | 132 (120 standard + 12 boss challenges) |
| Activities | 1,512 (952 graded) |
| Activity types | 20, all used |
| Chart-backed exercises | 176 |
| Addressable simulation scenarios | 250,000 |
| Tests | 147 |

Everything runs on-device. There is no account, no sign-in, no analytics, no
network code, and the Android manifest does not request the `INTERNET`
permission.

## Running it

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug      # requires an Android SDK
```

Drift models are code-generated. After changing anything in
`lib/data/db/tables.dart`:

```bash
dart run build_runner build
```

## How it is put together

```
lib/
  app/              routing, providers, the five-tab shell
  core/             seeded RNG, date helpers, NaN-safe formatters
  design_system/    tokens, palette, theme, reusable components
  domain/
    models/         candles, activities, lessons, scenarios, trades
    services/       XP, levels, mastery, spaced repetition, risk maths,
                    replay, process scoring, coaching, recommendations
    repositories/   interfaces a backend can implement later
  data/
    curriculum/     the authored curriculum + the assembler that expands it
    market/         synthetic series generator, OHLCV CSV importer
    scenarios/      feature detection, difficulty scoring, scenario generation
    db/             Drift schema, migrations, local repository implementations
  features/         one folder per screen area
  shared/chart/     the CustomPainter candlestick chart
tools/              CLI for importing real OHLCV data
```

### The chart is native Flutter

`lib/shared/chart/` is a `CustomPainter` implementation with pan, pinch zoom,
tap selection, a long-press crosshair, draggable price levels, structure
markers, shaded zones and an optional volume pane. No WebView, no embedded
charting library, no third-party chart package. Only the candles inside the
viewport are laid out and painted, so panning a long series costs the same as
panning a short one.

### Charts are generated, not stored

Every chart comes from a `ChartRecipe` — a seed and a shape — and is rebuilt
deterministically by `SyntheticSeriesGenerator`. That is why the app ships no
candle data and why the same exercise looks identical on every device.

The generator starts from a *designed* sequence of swing levels and then fills
candles between them under a hard invariant: every candle strictly between two
swing nodes stays inside the price band bounded by those nodes. That makes each
node a genuine local extreme, and it makes "which point is the Higher Low?"
answerable with certainty rather than with a heuristic. The invariant is
enforced by tests across all 23 chart shapes and all four difficulties.

This data is **synthetic educational data**, clearly labelled as such
throughout. It is never presented as a recording of real market history. The
importer in `tools/` loads real OHLCV data without any simulator change.

### Look-ahead protection is structural

`SimulationSession` keeps future candles in a private field. `chartCandles` —
the only list any widget renders — returns the visible window plus exactly the
candles that have been revealed, and nothing is revealed before a decision has
been committed. There is no code path that hands an unrevealed candle to a
widget. Tests assert this across hundreds of generated scenarios.

### Process over profit

`ProcessScorer` grades risk discipline (30%), invalidation logic (22%),
reward-to-risk (20%), stop distance against normal movement (13%) and direction
reasoning (15%). Simulated P&L is reported and deliberately excluded from the
score. A reckless trade that wins scores badly; a disciplined trade that loses
scores well. Where a dimension genuinely involves judgement it is marked as such
and the feedback is phrased as a view rather than a correction.

### The ambiguous-candle rule

A candle records open, high, low and close but not the order in which the high
and low were reached. When a single candle contains both the stop and the
target there is no way to know which was touched first. `ReplayEngine` resolves
that case with one fixed conservative rule — **the stop is treated as hit
first** — and flags the result so the review screen says so out loud. Resolving
ties in the learner's favour would inflate every outcome.

### XP and mastery are different things

XP only ever increases and measures activity; it is capped daily and decays on
lesson replays so grinding lesson 1 is never efficient. Skill mastery moves in
both directions, responds to difficulty, weighs early answers more heavily than
later ones, and decays when a skill is left alone. A learner can have a lot of
XP and weak mastery, which is the point.

### Ready for a backend, dependent on none

`lib/domain/repositories/` defines the interfaces; `lib/data/repositories/`
holds the local SQLite implementations. `CoachService` has a deterministic
`LocalCoachService` today and room for a `RemoteAiCoachService` later — with no
fake network calls standing in for one. The offline league generates clearly
labelled **sample profiles** and says so in the UI; it does not pretend to show
other players.

## Testing

```bash
flutter test
```

147 tests covering curriculum integrity (12 worlds, ≥10 lessons each, unique
ids, a valid prerequisite graph, 8–15 activities per lesson, every chart
exercise having a resolvable answer), the chart generator's structural
invariants, XP and level curves, mastery, spaced repetition, streaks, risk and
position-size maths, long/short validation, replay outcomes including the
ambiguous-candle rule, process scoring, scenario uniqueness and look-ahead
protection, persistence across a simulated app restart, reset behaviour,
deterministic daily challenges, the CSV importer, and widget tests for
onboarding, the learn path, the lesson player, the chart and settings.

## Licence and content

All artwork, the launcher icon, the colour identity and the curriculum text are
original to this project. No third-party logos, brand assets or copyrighted
course material are included.
