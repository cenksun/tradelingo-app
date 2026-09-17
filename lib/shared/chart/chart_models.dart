import 'package:flutter/material.dart';

import '../../domain/models/enums.dart';

/// A horizontal line drawn across the chart.
@immutable
class ChartPriceLine {
  const ChartPriceLine({
    required this.price,
    required this.color,
    required this.label,
    this.dashed = true,
    this.draggable = false,
    this.id,
  });

  final double price;
  final Color color;
  final String label;
  final bool dashed;

  /// Draggable lines show a grab handle and report drags to the parent.
  final bool draggable;
  final String? id;
}

/// A marker attached to a specific candle, used for structure labels.
@immutable
class ChartMarker {
  const ChartMarker({
    required this.candleIndex,
    required this.price,
    required this.label,
    required this.above,
    this.color,
    this.emphasised = false,
  });

  final int candleIndex;
  final double price;
  final String label;

  /// Draw above the candle (for highs) or below it (for lows).
  final bool above;
  final Color? color;
  final bool emphasised;
}

/// A shaded horizontal band.
@immutable
class ChartBand {
  const ChartBand({
    required this.lowPrice,
    required this.highPrice,
    required this.color,
    this.label,
  });

  final double lowPrice;
  final double highPrice;
  final Color color;
  final String? label;
}

/// What the learner tapped when picking a price point.
@immutable
class PricePointHit {
  const PricePointHit(this.candleIndex, this.part, this.price);

  final int candleIndex;
  final PricePart part;
  final double price;
}

/// Viewport state: which slice of the series is on screen.
@immutable
class ChartViewport {
  const ChartViewport({required this.start, required this.count});

  /// Fractional index of the leftmost visible candle.
  final double start;

  /// How many candles fit on screen.
  final double count;

  ChartViewport copyWith({double? start, double? count}) =>
      ChartViewport(start: start ?? this.start, count: count ?? this.count);

  /// Keeps the viewport inside the data, allowing a small margin on the right
  /// so the newest candle is never flush against the price axis.
  ChartViewport clampTo(int length) {
    final minCount = 8.0;
    final maxCount = length.toDouble().clamp(minCount, double.infinity);
    final c = count.clamp(minCount, maxCount);
    final maxStart = (length - c).clamp(0.0, double.infinity);
    return ChartViewport(start: start.clamp(0.0, maxStart), count: c);
  }
}
