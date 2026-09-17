import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../core/formatters.dart';
import '../../design_system/palette.dart';
import '../../domain/models/market.dart';
import 'chart_models.dart';

/// Geometry shared between the painter and the gesture handling, so a tap maps
/// to exactly the candle that was drawn there.
class ChartGeometry {
  ChartGeometry({
    required this.plot,
    required this.volumePane,
    required this.candles,
    required this.viewport,
    required this.minPrice,
    required this.maxPrice,
  });

  final Rect plot;
  final Rect? volumePane;
  final List<Candle> candles;
  final ChartViewport viewport;
  final double minPrice;
  final double maxPrice;

  double get priceSpan =>
      (maxPrice - minPrice).abs() < 1e-12 ? 1 : maxPrice - minPrice;

  double get slotWidth =>
      viewport.count <= 0 ? plot.width : plot.width / viewport.count;

  double get candleWidth => math.max(1.4, slotWidth * 0.62);

  /// Screen x for a candle index.
  double xForIndex(double index) =>
      plot.left + (index - viewport.start + 0.5) * slotWidth;

  /// Screen y for a price.
  double yForPrice(double price) {
    final t = (maxPrice - price) / priceSpan;
    return plot.top + t.clamp(-2.0, 3.0) * plot.height;
  }

  /// Price at a screen y.
  double priceForY(double y) {
    final t = ((y - plot.top) / plot.height).clamp(-2.0, 3.0);
    return maxPrice - t * priceSpan;
  }

  /// Candle index nearest to a screen x.
  int indexForX(double x) {
    if (candles.isEmpty) return 0;
    final raw = viewport.start + (x - plot.left) / slotWidth - 0.5;
    return raw.round().clamp(0, candles.length - 1);
  }

  int get firstVisible =>
      viewport.start.floor().clamp(0, math.max(0, candles.length - 1));

  int get lastVisible =>
      (viewport.start + viewport.count).ceil().clamp(0, candles.length);
}

/// Draws the candlestick chart.
///
/// Only the candles inside the viewport are laid out and painted. Panning a
/// 5,000-candle series costs the same as panning a 50-candle one, which is what
/// keeps the chart smooth on a mid-range phone.
class CandleChartPainter extends CustomPainter {
  CandleChartPainter({
    required this.candles,
    required this.viewport,
    required this.colors,
    required this.textDirection,
    this.bands = const [],
    this.priceLines = const [],
    this.markers = const [],
    this.selectedIndex,
    this.highlightIndex,
    this.crosshair,
    this.showVolume = false,
    this.showPriceAxis = true,
    this.showTimeAxis = true,
    this.priceDecimals = 2,
    this.dimAfterIndex,
    this.onGeometry,
  });

  final List<Candle> candles;
  final ChartViewport viewport;
  final TpColors colors;
  final TextDirection textDirection;
  final List<ChartBand> bands;
  final List<ChartPriceLine> priceLines;
  final List<ChartMarker> markers;
  final int? selectedIndex;
  final int? highlightIndex;
  final Offset? crosshair;
  final bool showVolume;
  final bool showPriceAxis;
  final bool showTimeAxis;
  final int priceDecimals;

  /// Candles at or after this index are drawn faded, used by replay.
  final int? dimAfterIndex;

  /// Reports the geometry back so gesture handling matches exactly what was
  /// painted.
  final void Function(ChartGeometry)? onGeometry;

  static const double _axisWidth = 58;
  static const double _timeAxisHeight = 20;

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty || size.width <= 0 || size.height <= 0) return;

    final axisWidth = showPriceAxis ? _axisWidth : 6.0;
    final timeHeight = showTimeAxis ? _timeAxisHeight : 0.0;
    final volumeHeight = showVolume ? (size.height - timeHeight) * 0.16 : 0.0;

    final plot = Rect.fromLTWH(
      0,
      6,
      math.max(1, size.width - axisWidth),
      math.max(1, size.height - timeHeight - volumeHeight - 10),
    );
    final volumePane = showVolume
        ? Rect.fromLTWH(
            0,
            plot.bottom + 4,
            plot.width,
            math.max(1, volumeHeight - 4),
          )
        : null;

    final clamped = viewport.clampTo(candles.length);
    final first = clamped.start.floor().clamp(0, candles.length - 1);
    final last = (clamped.start + clamped.count).ceil().clamp(
      1,
      candles.length,
    );

    // Price range covers the visible candles plus anything overlaid on them, so
    // a stop line just outside the data never disappears off-screen.
    var minPrice = double.infinity;
    var maxPrice = double.negativeInfinity;
    for (var i = first; i < last; i++) {
      final c = candles[i];
      if (c.low < minPrice) minPrice = c.low;
      if (c.high > maxPrice) maxPrice = c.high;
    }
    for (final line in priceLines) {
      if (!line.price.isFinite) continue;
      minPrice = math.min(minPrice, line.price);
      maxPrice = math.max(maxPrice, line.price);
    }
    for (final band in bands) {
      if (!band.lowPrice.isFinite || !band.highPrice.isFinite) continue;
      minPrice = math.min(minPrice, band.lowPrice);
      maxPrice = math.max(maxPrice, band.highPrice);
    }
    if (!minPrice.isFinite || !maxPrice.isFinite) return;
    if ((maxPrice - minPrice).abs() < 1e-9) {
      minPrice -= 1;
      maxPrice += 1;
    }
    final pad = (maxPrice - minPrice) * 0.08;
    minPrice -= pad;
    maxPrice += pad;

    final geometry = ChartGeometry(
      plot: plot,
      volumePane: volumePane,
      candles: candles,
      viewport: clamped,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    onGeometry?.call(geometry);

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    _paintGrid(canvas, geometry, size);
    _paintBands(canvas, geometry);
    _paintCandles(canvas, geometry, first, last);
    if (volumePane != null) _paintVolume(canvas, geometry, first, last);
    _paintPriceLines(canvas, geometry, size);
    _paintMarkers(canvas, geometry);
    _paintSelection(canvas, geometry);
    if (showPriceAxis) _paintPriceAxis(canvas, geometry, size);
    if (showTimeAxis) _paintTimeAxis(canvas, geometry, size, first, last);
    if (crosshair != null) _paintCrosshair(canvas, geometry, size);

    canvas.restore();
  }

  void _paintGrid(Canvas canvas, ChartGeometry g, Size size) {
    final paint = Paint()
      ..color = colors.chartGrid
      ..strokeWidth = 1;
    const lines = 5;
    for (var i = 0; i <= lines; i++) {
      final y = g.plot.top + g.plot.height * (i / lines);
      canvas.drawLine(Offset(g.plot.left, y), Offset(g.plot.right, y), paint);
    }
  }

  void _paintBands(Canvas canvas, ChartGeometry g) {
    for (final band in bands) {
      final top = g.yForPrice(band.highPrice);
      final bottom = g.yForPrice(band.lowPrice);
      final rect = Rect.fromLTRB(
        g.plot.left,
        math.min(top, bottom),
        g.plot.right,
        math.max(top, bottom),
      );
      canvas.drawRect(rect, Paint()..color = band.color);
      canvas.drawRect(
        rect,
        Paint()
          ..color = band.color.withValues(alpha: 0.65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      if (band.label != null) {
        _text(
          canvas,
          band.label!,
          Offset(g.plot.left + 6, rect.top + 3),
          colors.textSecondary,
          10,
          bold: true,
        );
      }
    }
  }

  void _paintCandles(Canvas canvas, ChartGeometry g, int first, int last) {
    final width = g.candleWidth;
    final wickPaint = Paint()..strokeWidth = math.max(1, width * 0.14);
    final bodyPaint = Paint();

    for (var i = first; i < last; i++) {
      final c = candles[i];
      final x = g.xForIndex(i.toDouble());
      if (x < g.plot.left - width || x > g.plot.right + width) continue;

      final dim = dimAfterIndex != null && i > dimAfterIndex!;
      final bullish = c.close >= c.open;
      var color = bullish ? colors.bullish : colors.bearish;
      if (dim) color = color.withValues(alpha: 0.28);

      final highY = g.yForPrice(c.high);
      final lowY = g.yForPrice(c.low);
      wickPaint.color = color;
      canvas.drawLine(Offset(x, highY), Offset(x, lowY), wickPaint);

      final openY = g.yForPrice(c.open);
      final closeY = g.yForPrice(c.close);
      final top = math.min(openY, closeY);
      final bottom = math.max(openY, closeY);
      final rect = Rect.fromLTRB(
        x - width / 2,
        top,
        x + width / 2,
        math.max(bottom, top + 1.2),
      );

      // Bullish candles are drawn hollow and bearish ones filled, so direction
      // is readable without relying on colour.
      if (bullish) {
        bodyPaint
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1, width * 0.18);
        canvas.drawRect(rect.deflate(width * 0.09), bodyPaint);
      } else {
        bodyPaint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawRect(rect, bodyPaint);
      }
    }
  }

  void _paintVolume(Canvas canvas, ChartGeometry g, int first, int last) {
    final pane = g.volumePane;
    if (pane == null) return;
    var maxVolume = 0.0;
    for (var i = first; i < last; i++) {
      if (candles[i].volume > maxVolume) maxVolume = candles[i].volume;
    }
    if (maxVolume <= 0) return;
    final width = g.candleWidth;
    final paint = Paint();
    for (var i = first; i < last; i++) {
      final c = candles[i];
      final x = g.xForIndex(i.toDouble());
      final h = (c.volume / maxVolume) * pane.height;
      final bullish = c.close >= c.open;
      paint.color = (bullish ? colors.bullish : colors.bearish).withValues(
        alpha: 0.34,
      );
      canvas.drawRect(
        Rect.fromLTRB(
          x - width / 2,
          pane.bottom - h,
          x + width / 2,
          pane.bottom,
        ),
        paint,
      );
    }
  }

  void _paintPriceLines(Canvas canvas, ChartGeometry g, Size size) {
    for (final line in priceLines) {
      if (!line.price.isFinite) continue;
      final y = g.yForPrice(line.price);
      if (y < g.plot.top - 40 || y > g.plot.bottom + 40) continue;
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.draggable ? 2.2 : 1.6;

      if (line.dashed) {
        _dashedLine(
          canvas,
          Offset(g.plot.left, y),
          Offset(g.plot.right, y),
          paint,
        );
      } else {
        canvas.drawLine(Offset(g.plot.left, y), Offset(g.plot.right, y), paint);
      }

      // Label chip on the right edge of the plot.
      final label = '${line.label}  ${Fmt.price(line.price)}';
      final painter = _textPainter(label, Colors.white, 10, bold: true);
      final chip = Rect.fromLTWH(
        g.plot.right - painter.width - 12,
        y - painter.height / 2 - 3,
        painter.width + 10,
        painter.height + 6,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(chip, const Radius.circular(4)),
        Paint()..color = line.color,
      );
      painter.paint(canvas, Offset(chip.left + 5, chip.top + 3));

      if (line.draggable) {
        canvas.drawCircle(
          Offset(g.plot.left + 10, y),
          5.5,
          Paint()..color = line.color,
        );
        canvas.drawCircle(
          Offset(g.plot.left + 10, y),
          5.5,
          Paint()
            ..color = Colors.white.withValues(alpha: 0.85)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.6,
        );
      }
    }
  }

  void _paintMarkers(Canvas canvas, ChartGeometry g) {
    for (final marker in markers) {
      if (marker.candleIndex < 0 || marker.candleIndex >= candles.length) {
        continue;
      }
      final x = g.xForIndex(marker.candleIndex.toDouble());
      if (x < g.plot.left - 30 || x > g.plot.right + 30) continue;
      final y = g.yForPrice(marker.price);
      final color = marker.color ?? colors.textSecondary;

      final painter = _textPainter(
        marker.label,
        marker.emphasised ? colors.onAccent : Colors.white,
        10,
        bold: true,
      );
      final chipY = marker.above ? y - painter.height - 14 : y + 10;
      final chip = Rect.fromLTWH(
        x - painter.width / 2 - 5,
        chipY,
        painter.width + 10,
        painter.height + 4,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(chip, const Radius.circular(4)),
        Paint()..color = marker.emphasised ? colors.accent : color,
      );
      painter.paint(canvas, Offset(chip.left + 5, chip.top + 2));

      // Small connector so the label clearly belongs to its candle.
      canvas.drawLine(
        Offset(x, marker.above ? chip.bottom : chip.top),
        Offset(x, y),
        Paint()
          ..color = (marker.emphasised ? colors.accent : color).withValues(
            alpha: 0.7,
          )
          ..strokeWidth = 1.2,
      );
    }
  }

  void _paintSelection(Canvas canvas, ChartGeometry g) {
    void highlight(int index, Color color, double alpha) {
      if (index < 0 || index >= candles.length) return;
      final x = g.xForIndex(index.toDouble());
      if (x < g.plot.left - 20 || x > g.plot.right + 20) return;
      final w = math.max(g.slotWidth, 10.0);
      canvas.drawRect(
        Rect.fromLTRB(x - w / 2, g.plot.top, x + w / 2, g.plot.bottom),
        Paint()..color = color.withValues(alpha: alpha),
      );
    }

    if (highlightIndex != null) highlight(highlightIndex!, colors.info, 0.16);
    if (selectedIndex != null) {
      highlight(selectedIndex!, colors.accent, 0.20);
      final x = g.xForIndex(selectedIndex!.toDouble());
      canvas.drawLine(
        Offset(x, g.plot.top),
        Offset(x, g.plot.bottom),
        Paint()
          ..color = colors.accent
          ..strokeWidth = 1.4,
      );
    }
  }

  void _paintPriceAxis(Canvas canvas, ChartGeometry g, Size size) {
    const steps = 5;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final price = g.maxPrice - t * g.priceSpan;
      final y = g.plot.top + t * g.plot.height;
      _text(
        canvas,
        price.toStringAsFixed(priceDecimals),
        Offset(g.plot.right + 6, y - 6),
        colors.chartAxis,
        10,
      );
    }
  }

  void _paintTimeAxis(
    Canvas canvas,
    ChartGeometry g,
    Size size,
    int first,
    int last,
  ) {
    final count = last - first;
    if (count <= 0) return;
    final step = math.max(1, count ~/ 4);
    for (var i = first; i < last; i += step) {
      final x = g.xForIndex(i.toDouble());
      if (x < g.plot.left + 10 || x > g.plot.right - 20) continue;
      _text(
        canvas,
        '${i + 1}',
        Offset(x - 8, size.height - _timeAxisHeight + 2),
        colors.chartAxis,
        10,
      );
    }
  }

  void _paintCrosshair(Canvas canvas, ChartGeometry g, Size size) {
    final point = crosshair!;
    final paint = Paint()
      ..color = colors.chartCrosshair.withValues(alpha: 0.7)
      ..strokeWidth = 1;
    _dashedLine(
      canvas,
      Offset(g.plot.left, point.dy),
      Offset(g.plot.right, point.dy),
      paint,
    );
    _dashedLine(
      canvas,
      Offset(point.dx, g.plot.top),
      Offset(point.dx, g.plot.bottom),
      paint,
    );

    final price = g.priceForY(point.dy);
    final painter = _textPainter(
      price.toStringAsFixed(priceDecimals),
      colors.background,
      10,
      bold: true,
    );
    final chip = Rect.fromLTWH(
      g.plot.right + 2,
      point.dy - painter.height / 2 - 2,
      math.max(painter.width + 8, 50),
      painter.height + 4,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(chip, const Radius.circular(3)),
      Paint()..color = colors.chartCrosshair,
    );
    painter.paint(canvas, Offset(chip.left + 4, chip.top + 2));
  }

  void _dashedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
    const dash = 5.0;
    const gap = 4.0;
    final total = (to - from).distance;
    if (total <= 0) return;
    final dir = (to - from) / total;
    var travelled = 0.0;
    while (travelled < total) {
      final end = math.min(travelled + dash, total);
      canvas.drawLine(from + dir * travelled, from + dir * end, paint);
      travelled = end + gap;
    }
  }

  TextPainter _textPainter(
    String value,
    Color color,
    double size, {
    bool bold = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: value,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          fontFeatures: const [ui.FontFeature.tabularFigures()],
        ),
      ),
      textDirection: textDirection,
    )..layout();
    return painter;
  }

  void _text(
    Canvas canvas,
    String value,
    Offset at,
    Color color,
    double size, {
    bool bold = false,
  }) {
    _textPainter(value, color, size, bold: bold).paint(canvas, at);
  }

  @override
  bool shouldRepaint(covariant CandleChartPainter old) {
    return old.candles != candles ||
        old.viewport.start != viewport.start ||
        old.viewport.count != viewport.count ||
        old.selectedIndex != selectedIndex ||
        old.highlightIndex != highlightIndex ||
        old.crosshair != crosshair ||
        old.priceLines != priceLines ||
        old.markers != markers ||
        old.bands != bands ||
        old.showVolume != showVolume ||
        old.dimAfterIndex != dimAfterIndex ||
        old.colors != colors;
  }
}
