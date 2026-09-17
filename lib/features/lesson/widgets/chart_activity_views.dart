import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/formatters.dart';
import '../../../data/market/synthetic_series_generator.dart';
import '../../../design_system/components.dart';
import '../../../domain/models/activity.dart';
import '../../../domain/models/chart_series.dart';
import '../../../domain/models/enums.dart';
import '../../../shared/chart/candle_chart.dart';
import '../../../shared/chart/chart_models.dart';
import 'activity_shell.dart';
import 'simple_activity_views.dart';

/// Builds (and caches) the series for a chart activity.
///
/// Series are rebuilt from the recipe rather than stored, so this cache exists
/// purely to avoid regenerating on every rebuild of the same screen.
class SeriesCache {
  SeriesCache._();
  static final SeriesCache instance = SeriesCache._();

  final Map<String, GeneratedSeries> _cache = {};

  GeneratedSeries of(ChartRecipe recipe) {
    final key = recipe.cacheKey;
    final existing = _cache[key];
    if (existing != null) return existing;
    final built = SyntheticSeriesGenerator.build(recipe);
    // Keep the cache small: chart exercises are transient.
    if (_cache.length > 40) _cache.clear();
    _cache[key] = built;
    return built;
  }
}

/// Header strip above an exercise chart showing what is being looked at.
class ChartContextBar extends StatelessWidget {
  const ChartContextBar({super.key, required this.series});

  final GeneratedSeries series;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return Row(
      children: [
        TpBadge(
          label: series.displayName,
          icon: Icons.candlestick_chart_rounded,
          dense: true,
          color: c.textSecondary,
        ),
        const HGap(Gap.sm),
        TpBadge(
          label: series.timeframe.label,
          dense: true,
          color: c.textTertiary,
        ),
        const Spacer(),
        Text(
          '${series.candles.length} candles',
          style: context.texts.labelSmall,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Tap the candle
// ---------------------------------------------------------------------------

class TapCandleView extends StatefulWidget {
  const TapCandleView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final TapCandleActivity activity;
  final ResponseChanged onChanged;

  @override
  State<TapCandleView> createState() => _TapCandleViewState();
}

class _TapCandleViewState extends State<TapCandleView> {
  int? _selected;

  @override
  void didUpdateWidget(covariant TapCandleView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _selected = null;
  }

  @override
  Widget build(BuildContext context) {
    final series = SeriesCache.instance.of(widget.activity.chartRecipe);
    return ActivityShell(
      activity: widget.activity,
      instruction: 'Tap a candle on the chart. Pinch to zoom, drag to pan.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChartContextBar(series: series),
          const VGap(Gap.md),
          SizedBox(
            height: 300,
            child: CandleChart(
              candles: series.candles,
              selectedIndex: _selected,
              priceDecimals: series.asset.priceDecimals,
              onCandleTap: (index) {
                setState(() => _selected = index);
                widget.onChanged(CandleIndexResponse(index));
              },
            ),
          ),
          const VGap(Gap.md),
          if (_selected != null)
            _CandleReadout(
              candle: series.candles[_selected!],
              index: _selected!,
            ),
        ],
      ),
    );
  }
}

class _CandleReadout extends StatelessWidget {
  const _CandleReadout({required this.candle, required this.index});

  final dynamic candle;
  final int index;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    return TpCard(
      raised: true,
      padding: const EdgeInsets.all(Gap.md),
      child: Row(
        children: [
          TpBadge(label: 'Candle ${index + 1}', dense: true, color: c.accent),
          const HGap(Gap.md),
          Expanded(
            child: Wrap(
              spacing: Gap.md,
              runSpacing: Gap.xs,
              children: [
                _kv(context, 'O', Fmt.price(candle.open)),
                _kv(context, 'H', Fmt.price(candle.high)),
                _kv(context, 'L', Fmt.price(candle.low)),
                _kv(context, 'C', Fmt.price(candle.close)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(BuildContext context, String k, String v) => RichText(
    text: TextSpan(
      children: [
        TextSpan(text: '$k ', style: context.texts.labelSmall),
        TextSpan(text: v, style: context.texts.labelMedium),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
// 5. Tap the price point
// ---------------------------------------------------------------------------

class TapPricePointView extends StatefulWidget {
  const TapPricePointView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final TapPricePointActivity activity;
  final ResponseChanged onChanged;

  @override
  State<TapPricePointView> createState() => _TapPricePointViewState();
}

class _TapPricePointViewState extends State<TapPricePointView> {
  PricePointHit? _hit;

  @override
  void didUpdateWidget(covariant TapPricePointView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _hit = null;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final series = SeriesCache.instance.of(widget.activity.chartRecipe);
    final target = widget.activity.candleTarget.resolve(series);

    return ActivityShell(
      activity: widget.activity,
      instruction:
          'Tap the exact point on the candle. The app picks whichever of the four '
          'prices you tapped closest to.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChartContextBar(series: series),
          const VGap(Gap.md),
          SizedBox(
            height: 300,
            child: CandleChart(
              candles: series.candles,
              highlightIndex: target,
              priceDecimals: series.asset.priceDecimals,
              priceLines: _hit == null
                  ? const []
                  : [
                      ChartPriceLine(
                        price: _hit!.price,
                        color: c.accent,
                        label: _hit!.part.label,
                      ),
                    ],
              onPricePointTap: (hit) {
                setState(() => _hit = hit);
                widget.onChanged(PricePointResponse(hit.candleIndex, hit.part));
              },
            ),
          ),
          const VGap(Gap.md),
          TpCard(
            raised: true,
            padding: const EdgeInsets.all(Gap.md),
            child: Text(
              _hit == null
                  ? 'Nothing selected yet.'
                  : 'Selected: candle ${_hit!.candleIndex + 1} · '
                        '${_hit!.part.label} at ${Fmt.price(_hit!.price)}',
              style: context.texts.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. Identify a structure point
// ---------------------------------------------------------------------------

class IdentifyStructureView extends StatefulWidget {
  const IdentifyStructureView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final IdentifyStructureActivity activity;
  final ResponseChanged onChanged;

  @override
  State<IdentifyStructureView> createState() => _IdentifyStructureViewState();
}

class _IdentifyStructureViewState extends State<IdentifyStructureView> {
  int? _selectedIndex;

  @override
  void didUpdateWidget(covariant IdentifyStructureView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _selectedIndex = null;
  }

  void _select(int candleIndex) {
    setState(() => _selectedIndex = candleIndex);
    widget.onChanged(CandleIndexResponse(candleIndex));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final series = SeriesCache.instance.of(widget.activity.chartRecipe);
    final swings = series.swings;

    return ActivityShell(
      activity: widget.activity,
      instruction:
          'The numbered points are the swings. Tap one on the chart, or use the '
          'buttons below.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChartContextBar(series: series),
          const VGap(Gap.md),
          SizedBox(
            height: 310,
            child: CandleChart(
              candles: series.candles,
              selectedIndex: _selectedIndex,
              priceDecimals: series.asset.priceDecimals,
              markers: [
                for (final s in swings)
                  ChartMarker(
                    candleIndex: s.index,
                    price: s.price,
                    label: '${s.order + 1}',
                    above: s.isHigh,
                    color: c.textTertiary,
                    emphasised: _selectedIndex == s.index,
                  ),
              ],
              onCandleTap: (index) {
                // Snap to the nearest swing so a near-miss still registers.
                var best = index;
                var bestDistance = 3;
                for (final s in swings) {
                  final d = (s.index - index).abs();
                  if (d <= bestDistance) {
                    bestDistance = d;
                    best = s.index;
                  }
                }
                _select(best);
              },
            ),
          ),
          const VGap(Gap.lg),
          Wrap(
            spacing: Gap.sm,
            runSpacing: Gap.sm,
            children: [
              for (final s in swings)
                TpFilterChip(
                  label: 'Point ${s.order + 1}',
                  selected: _selectedIndex == s.index,
                  onTap: () => _select(s.index),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. Label the structure
// ---------------------------------------------------------------------------

class LabelStructureView extends StatefulWidget {
  const LabelStructureView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final LabelStructureActivity activity;
  final ResponseChanged onChanged;

  @override
  State<LabelStructureView> createState() => _LabelStructureViewState();
}

class _LabelStructureViewState extends State<LabelStructureView> {
  final Map<int, SwingLabel> _labels = {};

  @override
  void didUpdateWidget(covariant LabelStructureView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _labels.clear();
  }

  void _emit() {
    if (_labels.length == widget.activity.swingOrders.length) {
      widget.onChanged(LabelSetResponse(Map.of(_labels)));
    } else {
      widget.onChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final series = SeriesCache.instance.of(widget.activity.chartRecipe);
    final orders = widget.activity.swingOrders;

    return ActivityShell(
      activity: widget.activity,
      instruction:
          'Compare each high with the previous high, and each low with the '
          'previous low.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChartContextBar(series: series),
          const VGap(Gap.md),
          SizedBox(
            height: 300,
            child: CandleChart(
              candles: series.candles,
              priceDecimals: series.asset.priceDecimals,
              markers: [
                for (final s in series.swings)
                  if (orders.contains(s.order))
                    ChartMarker(
                      candleIndex: s.index,
                      price: s.price,
                      label: _labels[s.order]?.short ?? '${s.order + 1}',
                      above: s.isHigh,
                      color: c.textTertiary,
                      emphasised: _labels.containsKey(s.order),
                    ),
              ],
            ),
          ),
          const VGap(Gap.lg),
          for (final order in orders)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.md),
              child: TpCard(
                raised: true,
                padding: const EdgeInsets.all(Gap.md),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: c.surfaceSunken,
                        borderRadius: BorderRadius.circular(Radii.sm),
                      ),
                      child: Text(
                        '${order + 1}',
                        style: context.texts.labelMedium,
                      ),
                    ),
                    const HGap(Gap.md),
                    Expanded(
                      child: Wrap(
                        spacing: Gap.sm,
                        runSpacing: Gap.sm,
                        children: [
                          for (final label in SwingLabel.structureSet)
                            TpFilterChip(
                              label: label.short,
                              selected: _labels[order] == label,
                              onTap: () {
                                setState(() => _labels[order] = label);
                                _emit();
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8 & 9 & 20. Choice-on-a-chart activities
// ---------------------------------------------------------------------------

class TrendClassificationView extends StatefulWidget {
  const TrendClassificationView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final TrendClassificationActivity activity;
  final ResponseChanged onChanged;

  @override
  State<TrendClassificationView> createState() =>
      _TrendClassificationViewState();
}

class _TrendClassificationViewState extends State<TrendClassificationView> {
  TrendClass? _selected;

  @override
  void didUpdateWidget(covariant TrendClassificationView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _selected = null;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final series = SeriesCache.instance.of(widget.activity.chartRecipe);
    return ActivityShell(
      activity: widget.activity,
      instruction: 'Read the sequence of swings, not the last candle.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChartContextBar(series: series),
          const VGap(Gap.md),
          SizedBox(
            height: 280,
            child: CandleChart(
              candles: series.candles,
              priceDecimals: series.asset.priceDecimals,
            ),
          ),
          const VGap(Gap.lg),
          ActivityOption(
            label: 'Bullish structure',
            detail: 'Higher highs and higher lows',
            selected: _selected == TrendClass.bullish,
            leading: Icon(Icons.trending_up_rounded, color: c.bullish),
            onTap: () => _pick(TrendClass.bullish),
          ),
          ActivityOption(
            label: 'Bearish structure',
            detail: 'Lower highs and lower lows',
            selected: _selected == TrendClass.bearish,
            leading: Icon(Icons.trending_down_rounded, color: c.bearish),
            onTap: () => _pick(TrendClass.bearish),
          ),
          ActivityOption(
            label: 'Range or unclear',
            detail: 'Neither series is making progress',
            selected: _selected == TrendClass.range,
            leading: Icon(Icons.trending_flat_rounded, color: c.neutralTrend),
            onTap: () => _pick(TrendClass.range),
          ),
        ],
      ),
    );
  }

  void _pick(TrendClass value) {
    setState(() => _selected = value);
    widget.onChanged(TrendResponse(value));
  }
}

class DirectionDecisionView extends StatefulWidget {
  const DirectionDecisionView({
    super.key,
    required this.activity,
    required this.onChanged,
    this.visibleCandles,
    this.chartRecipe,
    this.extraInstruction,
  });

  final Activity activity;
  final ResponseChanged onChanged;

  /// Set by the mini-simulation renderer to hide the tail of the chart.
  final int? visibleCandles;
  final ChartRecipe? chartRecipe;
  final String? extraInstruction;

  @override
  State<DirectionDecisionView> createState() => _DirectionDecisionViewState();
}

class _DirectionDecisionViewState extends State<DirectionDecisionView> {
  TradeDirection? _selected;

  @override
  void didUpdateWidget(covariant DirectionDecisionView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _selected = null;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final recipe = widget.chartRecipe ?? widget.activity.recipe!;
    final series = SeriesCache.instance.of(recipe);
    final visible = widget.visibleCandles == null
        ? series.candles
        : series.candles
              .take(widget.visibleCandles!.clamp(5, series.candles.length))
              .toList(growable: false);

    return ActivityShell(
      activity: widget.activity,
      instruction:
          widget.extraInstruction ??
          'If nothing here gives a clear invalidation level, standing aside is '
              'a real answer.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChartContextBar(series: series),
          const VGap(Gap.md),
          SizedBox(
            height: 280,
            child: CandleChart(
              candles: visible,
              priceDecimals: series.asset.priceDecimals,
            ),
          ),
          const VGap(Gap.lg),
          ActivityOption(
            label: 'Long',
            detail: 'Position that gains if price rises',
            selected: _selected == TradeDirection.long,
            leading: Icon(Icons.north_east_rounded, color: c.bullish),
            onTap: () => _pick(TradeDirection.long),
          ),
          ActivityOption(
            label: 'Short',
            detail: 'Position that gains if price falls',
            selected: _selected == TradeDirection.short,
            leading: Icon(Icons.south_east_rounded, color: c.bearish),
            onTap: () => _pick(TradeDirection.short),
          ),
          ActivityOption(
            label: 'No trade',
            detail: 'Stand aside — a decision, not the absence of one',
            selected: _selected == TradeDirection.noTrade,
            leading: Icon(Icons.pause_rounded, color: c.neutralTrend),
            onTap: () => _pick(TradeDirection.noTrade),
          ),
        ],
      ),
    );
  }

  void _pick(TradeDirection value) {
    setState(() => _selected = value);
    widget.onChanged(DirectionResponse(value));
  }
}

// ---------------------------------------------------------------------------
// 10, 11, 19. Placing a level on the chart
// ---------------------------------------------------------------------------

/// Shared renderer for stop, target and zone placement.
///
/// Dragging the line is the primary interaction; the stepper and slider
/// underneath are a full keyboard- and screen-reader-accessible alternative,
/// so the exercise never depends on a drag gesture.
class LevelPlacementView extends StatefulWidget {
  const LevelPlacementView({
    super.key,
    required this.activity,
    required this.onChanged,
    required this.recipe,
    required this.lineLabel,
    required this.lineColor,
    required this.responseBuilder,
    this.direction,
    this.showEntry = true,
    this.instruction,
  });

  final Activity activity;
  final ResponseChanged onChanged;
  final ChartRecipe recipe;
  final String lineLabel;
  final Color Function(BuildContext) lineColor;
  final ActivityResponse Function(double price) responseBuilder;
  final TradeDirection? direction;
  final bool showEntry;
  final String? instruction;

  @override
  State<LevelPlacementView> createState() => _LevelPlacementViewState();
}

class _LevelPlacementViewState extends State<LevelPlacementView> {
  late GeneratedSeries _series;
  late double _level;
  late double _min;
  late double _max;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant LevelPlacementView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _init();
  }

  void _init() {
    _series = SeriesCache.instance.of(widget.recipe);
    final high = _series.highestPrice;
    final low = _series.lowestPrice;
    final span = math.max(high - low, 1e-6);
    _min = low - span * 0.35;
    _max = high + span * 0.35;

    final entry = _series.candles.last.close;
    _level = switch (widget.direction) {
      TradeDirection.long =>
        widget.lineLabel == 'Stop' ? entry - span * 0.18 : entry + span * 0.28,
      TradeDirection.short =>
        widget.lineLabel == 'Stop' ? entry + span * 0.18 : entry - span * 0.28,
      _ => (high + low) / 2,
    };
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onChanged(widget.responseBuilder(_level)),
    );
  }

  void _setLevel(double value) {
    setState(() => _level = value.clamp(_min, _max));
    widget.onChanged(widget.responseBuilder(_level));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final color = widget.lineColor(context);
    final entry = _series.candles.last.close;
    final step = (_max - _min) / 220;

    return ActivityShell(
      activity: widget.activity,
      instruction:
          widget.instruction ??
          'Drag the handle on the line, or use the buttons below.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChartContextBar(series: _series),
          const VGap(Gap.md),
          SizedBox(
            height: 300,
            child: CandleChart(
              candles: _series.candles,
              priceDecimals: _series.asset.priceDecimals,
              priceLines: [
                if (widget.showEntry)
                  ChartPriceLine(
                    price: entry,
                    color: c.entryLine,
                    label: 'Entry',
                    dashed: false,
                  ),
                ChartPriceLine(
                  price: _level,
                  color: color,
                  label: widget.lineLabel,
                  draggable: true,
                ),
              ],
              markers: [
                for (final s in _series.swings.reversed.take(3))
                  ChartMarker(
                    candleIndex: s.index,
                    price: s.price,
                    label: s.label.short,
                    above: s.isHigh,
                    color: c.textTertiary,
                  ),
              ],
              onLevelDrag: _setLevel,
            ),
          ),
          const VGap(Gap.lg),
          TpCard(
            raised: true,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TpStatTile(
                        label: widget.lineLabel,
                        value: Fmt.price(_level),
                        valueColor: color,
                        compact: true,
                      ),
                    ),
                    if (widget.showEntry)
                      Expanded(
                        child: TpStatTile(
                          label: 'Distance',
                          value: Fmt.price((entry - _level).abs()),
                          compact: true,
                        ),
                      ),
                  ],
                ),
                const VGap(Gap.md),
                Row(
                  children: [
                    TpIconButton(
                      icon: Icons.remove_rounded,
                      tooltip: 'Lower the ${widget.lineLabel.toLowerCase()}',
                      background: c.surfaceSunken,
                      onPressed: () => _setLevel(_level - step * 4),
                    ),
                    Expanded(
                      child: Semantics(
                        label: '${widget.lineLabel} price',
                        value: Fmt.price(_level),
                        slider: true,
                        child: Slider(
                          value: _level.clamp(_min, _max),
                          min: _min,
                          max: _max,
                          onChanged: _setLevel,
                        ),
                      ),
                    ),
                    TpIconButton(
                      icon: Icons.add_rounded,
                      tooltip: 'Raise the ${widget.lineLabel.toLowerCase()}',
                      background: c.surfaceSunken,
                      onPressed: () => _setLevel(_level + step * 4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 12. Build a trade
// ---------------------------------------------------------------------------

class BuildTradeView extends StatefulWidget {
  const BuildTradeView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final BuildTradeActivity activity;
  final ResponseChanged onChanged;

  @override
  State<BuildTradeView> createState() => _BuildTradeViewState();
}

class _BuildTradeViewState extends State<BuildTradeView> {
  late GeneratedSeries _series;
  late double _entry;
  late double _stop;
  late double _target;
  late double _min;
  late double _max;
  String _active = 'stop';

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant BuildTradeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.activity.id != widget.activity.id) _init();
  }

  void _init() {
    _series = SeriesCache.instance.of(widget.activity.chartRecipe);
    final high = _series.highestPrice;
    final low = _series.lowestPrice;
    final span = math.max(high - low, 1e-6);
    _min = low - span * 0.4;
    _max = high + span * 0.4;
    _entry = _series.candles.last.close;
    final isLong = widget.activity.direction == TradeDirection.long;
    _stop = isLong ? _entry - span * 0.16 : _entry + span * 0.16;
    _target = isLong ? _entry + span * 0.34 : _entry - span * 0.34;
    _active = 'stop';
    WidgetsBinding.instance.addPostFrameCallback((_) => _emit());
  }

  void _emit() {
    widget.onChanged(
      TradeSetupResponse(entry: _entry, stopLoss: _stop, takeProfit: _target),
    );
  }

  void _setActive(double value) {
    final v = value.clamp(_min, _max);
    setState(() {
      switch (_active) {
        case 'entry':
          _entry = v;
        case 'stop':
          _stop = v;
        default:
          _target = v;
      }
    });
    _emit();
  }

  double get _current => switch (_active) {
    'entry' => _entry,
    'stop' => _stop,
    _ => _target,
  };

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    final step = (_max - _min) / 220;
    final risk = (_entry - _stop).abs();
    final reward = (_target - _entry).abs();
    final rr = risk <= 0 ? 0.0 : reward / risk;

    return ActivityShell(
      activity: widget.activity,
      instruction:
          'Pick a level, then drag its handle or use the controls. Set the stop '
          'first — it defines the risk everything else is measured against.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ChartContextBar(series: _series),
          const VGap(Gap.md),
          SizedBox(
            height: 300,
            child: CandleChart(
              candles: _series.candles,
              priceDecimals: _series.asset.priceDecimals,
              priceLines: [
                ChartPriceLine(
                  price: _entry,
                  color: c.entryLine,
                  label: 'Entry',
                  dashed: false,
                  draggable: _active == 'entry',
                ),
                ChartPriceLine(
                  price: _stop,
                  color: c.stopLine,
                  label: 'Stop',
                  draggable: _active == 'stop',
                ),
                ChartPriceLine(
                  price: _target,
                  color: c.targetLine,
                  label: 'Target',
                  draggable: _active == 'target',
                ),
              ],
              markers: [
                for (final s in _series.swings.reversed.take(3))
                  ChartMarker(
                    candleIndex: s.index,
                    price: s.price,
                    label: s.label.short,
                    above: s.isHigh,
                    color: c.textTertiary,
                  ),
              ],
              onLevelDrag: _setActive,
            ),
          ),
          const VGap(Gap.lg),
          Row(
            children: [
              for (final entry in const [
                ('entry', 'Entry'),
                ('stop', 'Stop'),
                ('target', 'Target'),
              ])
                Padding(
                  padding: const EdgeInsets.only(right: Gap.sm),
                  child: TpFilterChip(
                    label: entry.$2,
                    selected: _active == entry.$1,
                    onTap: () => setState(() => _active = entry.$1),
                  ),
                ),
            ],
          ),
          const VGap(Gap.md),
          TpCard(
            raised: true,
            child: Column(
              children: [
                Row(
                  children: [
                    TpIconButton(
                      icon: Icons.remove_rounded,
                      tooltip: 'Lower',
                      background: c.surfaceSunken,
                      onPressed: () => _setActive(_current - step * 4),
                    ),
                    Expanded(
                      child: Semantics(
                        label: '$_active price',
                        value: Fmt.price(_current),
                        slider: true,
                        child: Slider(
                          value: _current.clamp(_min, _max),
                          min: _min,
                          max: _max,
                          onChanged: _setActive,
                        ),
                      ),
                    ),
                    TpIconButton(
                      icon: Icons.add_rounded,
                      tooltip: 'Raise',
                      background: c.surfaceSunken,
                      onPressed: () => _setActive(_current + step * 4),
                    ),
                  ],
                ),
                const Divider(height: Gap.xl),
                Row(
                  children: [
                    Expanded(
                      child: TpStatTile(
                        label: 'Risk',
                        value: Fmt.price(risk),
                        valueColor: c.bearish,
                        compact: true,
                      ),
                    ),
                    Expanded(
                      child: TpStatTile(
                        label: 'Reward',
                        value: Fmt.price(reward),
                        valueColor: c.bullish,
                        compact: true,
                      ),
                    ),
                    Expanded(
                      child: TpStatTile(
                        label: 'R:R',
                        value: Fmt.ratio(rr),
                        compact: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 20. Mini simulation
// ---------------------------------------------------------------------------

class MiniSimulationView extends StatelessWidget {
  const MiniSimulationView({
    super.key,
    required this.activity,
    required this.onChanged,
  });

  final MiniSimulationActivity activity;
  final ResponseChanged onChanged;

  @override
  Widget build(BuildContext context) {
    return DirectionDecisionView(
      activity: activity,
      onChanged: onChanged,
      chartRecipe: activity.chartRecipe,
      visibleCandles: activity.visibleCandles,
      extraInstruction:
          'Only part of this chart is visible. The rest stays hidden until you '
          'have committed to a decision.',
    );
  }
}
