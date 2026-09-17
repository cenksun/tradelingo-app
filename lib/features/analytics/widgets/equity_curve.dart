import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/formatters.dart';
import '../../../design_system/palette.dart';
import '../../../domain/repositories/repositories.dart';

/// The virtual equity curve, drawn with a [CustomPainter] like every other
/// chart in the app.
class EquityCurveChart extends StatelessWidget {
  const EquityCurveChart({
    super.key,
    required this.points,
    required this.startingBalance,
  });

  final List<EquityPoint> points;
  final double startingBalance;

  @override
  Widget build(BuildContext context) {
    final c = context.tp;
    if (points.isEmpty) {
      return Center(
        child: Text('No completed trades yet.', style: context.texts.bodySmall),
      );
    }
    return Semantics(
      label:
          'Virtual equity curve across ${points.length} trades, ending at '
          '${Fmt.money(points.last.balance)}.',
      child: CustomPaint(
        painter: _EquityPainter(
          points: points,
          startingBalance: startingBalance,
          colors: c,
          textDirection: Directionality.of(context),
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _EquityPainter extends CustomPainter {
  _EquityPainter({
    required this.points,
    required this.startingBalance,
    required this.colors,
    required this.textDirection,
  });

  final List<EquityPoint> points;
  final double startingBalance;
  final TpColors colors;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || size.width <= 0 || size.height <= 0) return;

    const leftPad = 4.0;
    const rightPad = 62.0;
    const topPad = 8.0;
    const bottomPad = 8.0;
    final plot = Rect.fromLTRB(
      leftPad,
      topPad,
      math.max(leftPad + 1, size.width - rightPad),
      math.max(topPad + 1, size.height - bottomPad),
    );

    final values = [startingBalance, ...points.map((p) => p.balance)];
    var min = values.reduce(math.min);
    var max = values.reduce(math.max);
    if ((max - min).abs() < 1e-9) {
      min -= 1;
      max += 1;
    }
    final pad = (max - min) * 0.12;
    min -= pad;
    max += pad;
    final span = max - min;

    double xFor(int i) =>
        plot.left +
        (values.length == 1 ? 0 : i / (values.length - 1)) * plot.width;
    double yFor(double v) => plot.top + ((max - v) / span) * plot.height;

    // Starting balance reference line.
    final refY = yFor(startingBalance);
    final refPaint = Paint()
      ..color = colors.border
      ..strokeWidth = 1;
    var x = plot.left;
    while (x < plot.right) {
      canvas.drawLine(
        Offset(x, refY),
        Offset(math.min(x + 5, plot.right), refY),
        refPaint,
      );
      x += 9;
    }

    final path = Path();
    final fill = Path();
    for (var i = 0; i < values.length; i++) {
      final px = xFor(i);
      final py = yFor(values[i]);
      if (i == 0) {
        path.moveTo(px, py);
        fill.moveTo(px, plot.bottom);
        fill.lineTo(px, py);
      } else {
        path.lineTo(px, py);
        fill.lineTo(px, py);
      }
    }
    fill.lineTo(xFor(values.length - 1), plot.bottom);
    fill.close();

    final up = values.last >= startingBalance;
    final lineColor = up ? colors.bullish : colors.bearish;

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            lineColor.withValues(alpha: 0.28),
            lineColor.withValues(alpha: 0.02),
          ],
        ).createShader(plot),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawCircle(
      Offset(xFor(values.length - 1), yFor(values.last)),
      4,
      Paint()..color = lineColor,
    );

    _label(canvas, Fmt.compact(max), Offset(plot.right + 6, plot.top - 5));
    _label(canvas, Fmt.compact(min), Offset(plot.right + 6, plot.bottom - 9));
    _label(
      canvas,
      Fmt.compact(startingBalance),
      Offset(plot.right + 6, refY - 7),
      color: colors.textTertiary,
    );
  }

  void _label(Canvas canvas, String text, Offset at, {Color? color}) {
    TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color ?? colors.chartAxis,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: textDirection,
      )
      ..layout()
      ..paint(canvas, at);
  }

  @override
  bool shouldRepaint(covariant _EquityPainter old) =>
      old.points != points ||
      old.startingBalance != startingBalance ||
      old.colors != colors;
}
