import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/formatters.dart';
import '../../design_system/palette.dart';
import '../../design_system/tokens.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/market.dart';
import 'candle_chart_painter.dart';
import 'chart_models.dart';

/// An interactive candlestick chart.
///
/// Supports pan, pinch zoom, tap-to-select, a long-press crosshair and dragging
/// a price level. Everything is painted with a [CustomPainter]; there is no
/// WebView and no third-party charting library anywhere in the app.
class CandleChart extends StatefulWidget {
  const CandleChart({
    super.key,
    required this.candles,
    this.bands = const [],
    this.priceLines = const [],
    this.markers = const [],
    this.selectedIndex,
    this.highlightIndex,
    this.onCandleTap,
    this.onPricePointTap,
    this.onLevelDrag,
    this.onLevelDragEnd,
    this.showVolume = false,
    this.showTimeAxis = true,
    this.interactive = true,
    this.dimAfterIndex,
    this.priceDecimals = 2,
    this.semanticLabel,
    this.initialVisibleCount,
    this.followLatest = false,
  });

  final List<Candle> candles;
  final List<ChartBand> bands;
  final List<ChartPriceLine> priceLines;
  final List<ChartMarker> markers;
  final int? selectedIndex;
  final int? highlightIndex;
  final ValueChanged<int>? onCandleTap;
  final ValueChanged<PricePointHit>? onPricePointTap;

  /// Called while a draggable price line is being moved.
  final ValueChanged<double>? onLevelDrag;
  final VoidCallback? onLevelDragEnd;

  final bool showVolume;
  final bool showTimeAxis;
  final bool interactive;
  final int? dimAfterIndex;
  final int priceDecimals;
  final String? semanticLabel;
  final int? initialVisibleCount;

  /// Keeps the newest candle in view as candles are appended, used by replay.
  final bool followLatest;

  @override
  State<CandleChart> createState() => _CandleChartState();
}

class _CandleChartState extends State<CandleChart> {
  ChartViewport? _viewport;
  ChartGeometry? _geometry;
  Offset? _crosshair;
  bool _draggingLevel = false;
  double _scaleStartCount = 0;
  double _scaleStartFocusIndex = 0;

  @override
  void didUpdateWidget(covariant CandleChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    final length = widget.candles.length;
    if (oldWidget.candles.length != length) {
      if (widget.followLatest && length > oldWidget.candles.length) {
        final v = _viewport;
        if (v != null) {
          // Keep the same zoom but slide the window to the right-hand edge.
          setState(() {
            _viewport = ChartViewport(
              start: math.max(0, length - v.count),
              count: v.count,
            ).clampTo(length);
          });
        }
      } else {
        _viewport = null;
      }
    }
  }

  ChartViewport _ensureViewport(int length) {
    final existing = _viewport;
    if (existing != null) return existing.clampTo(length);
    final count = (widget.initialVisibleCount ?? length)
        .clamp(8, math.max(8, length))
        .toDouble();
    return ChartViewport(
      start: math.max(0, length - count),
      count: count,
    ).clampTo(length);
  }

  void _setViewport(ChartViewport v) {
    setState(() => _viewport = v.clampTo(widget.candles.length));
  }

  bool _isOnLevelHandle(Offset local) {
    final g = _geometry;
    if (g == null) return false;
    for (final line in widget.priceLines) {
      if (!line.draggable || !line.price.isFinite) continue;
      final y = g.yForPrice(line.price);
      if ((local.dy - y).abs() < 26 && local.dx < g.plot.left + 70) return true;
    }
    return false;
  }

  void _handleTap(Offset local) {
    final g = _geometry;
    if (g == null || widget.candles.isEmpty) return;
    final index = g.indexForX(local.dx);
    if (widget.onPricePointTap != null) {
      final candle = widget.candles[index];
      final options = <(PricePart, double)>[
        (PricePart.open, candle.open),
        (PricePart.high, candle.high),
        (PricePart.low, candle.low),
        (PricePart.close, candle.close),
      ];
      var best = options.first;
      var bestDistance = double.infinity;
      for (final option in options) {
        final d = (g.yForPrice(option.$2) - local.dy).abs();
        if (d < bestDistance) {
          bestDistance = d;
          best = option;
        }
      }
      widget.onPricePointTap!(PricePointHit(index, best.$1, best.$2));
      return;
    }
    widget.onCandleTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    if (widget.candles.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: c.surfaceSunken,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: c.border),
        ),
        alignment: Alignment.center,
        child: Text('No chart data', style: context.texts.bodySmall),
      );
    }

    final viewport = _ensureViewport(widget.candles.length);

    Widget chart = LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: CandleChartPainter(
            candles: widget.candles,
            viewport: viewport,
            colors: c,
            textDirection: Directionality.of(context),
            bands: widget.bands,
            priceLines: widget.priceLines,
            markers: widget.markers,
            selectedIndex: widget.selectedIndex,
            highlightIndex: widget.highlightIndex,
            crosshair: _crosshair,
            showVolume: widget.showVolume,
            showTimeAxis: widget.showTimeAxis,
            priceDecimals: widget.priceDecimals,
            dimAfterIndex: widget.dimAfterIndex,
            onGeometry: (g) => _geometry = g,
          ),
        );
      },
    );

    if (widget.interactive) {
      chart = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (d) => _handleTap(d.localPosition),
        onLongPressStart: (d) => setState(() => _crosshair = d.localPosition),
        onLongPressMoveUpdate: (d) =>
            setState(() => _crosshair = d.localPosition),
        onLongPressEnd: (_) => setState(() => _crosshair = null),
        onScaleStart: (details) {
          final g = _geometry;
          if (g == null) return;
          _draggingLevel =
              widget.onLevelDrag != null &&
              _isOnLevelHandle(details.localFocalPoint);
          _scaleStartCount = viewport.count;
          _scaleStartFocusIndex =
              viewport.start +
              (details.localFocalPoint.dx / math.max(1, g.plot.width)) *
                  viewport.count;
        },
        onScaleUpdate: (details) {
          final g = _geometry;
          if (g == null) return;
          if (_draggingLevel) {
            widget.onLevelDrag?.call(g.priceForY(details.localFocalPoint.dy));
            return;
          }
          if (details.pointerCount > 1 && details.scale != 1.0) {
            final newCount = (_scaleStartCount / details.scale).clamp(
              8.0,
              widget.candles.length.toDouble(),
            );
            final focusFraction =
                details.localFocalPoint.dx / math.max(1, g.plot.width);
            _setViewport(
              ChartViewport(
                start: _scaleStartFocusIndex - focusFraction * newCount,
                count: newCount,
              ),
            );
          } else {
            final deltaIndex =
                -details.focalPointDelta.dx / math.max(1, g.slotWidth);
            _setViewport(viewport.copyWith(start: viewport.start + deltaIndex));
          }
        },
        onScaleEnd: (_) {
          if (_draggingLevel) {
            _draggingLevel = false;
            widget.onLevelDragEnd?.call();
          }
        },
        child: chart,
      );
    }

    return Semantics(
      label: widget.semanticLabel ?? _defaultSemantics(),
      image: true,
      child: Container(
        decoration: BoxDecoration(
          color: c.surfaceSunken,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: c.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: chart,
      ),
    );
  }

  String _defaultSemantics() {
    final candles = widget.candles;
    if (candles.isEmpty) return 'Empty price chart';
    final first = candles.first.close;
    final last = candles.last.close;
    final direction = last > first
        ? 'higher than'
        : last < first
        ? 'lower than'
        : 'level with';
    return 'Candlestick chart with ${candles.length} candles. The last close, '
        '${Fmt.price(last)}, is $direction the first close, ${Fmt.price(first)}.';
  }
}

/// A compact, non-interactive chart used in lists and review screens.
class CandleChartPreview extends StatelessWidget {
  const CandleChartPreview({
    super.key,
    required this.candles,
    this.height = 96,
    this.bands = const [],
    this.priceLines = const [],
  });

  final List<Candle> candles;
  final double height;
  final List<ChartBand> bands;
  final List<ChartPriceLine> priceLines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CandleChart(
        candles: candles,
        bands: bands,
        priceLines: priceLines,
        interactive: false,
        showTimeAxis: false,
      ),
    );
  }
}
