import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Large, very low-opacity Islamic geometric watermark used behind the splash
/// brand block: concentric circles, octagonal geometry and radial detail.
class IslamicGeometricPattern extends StatelessWidget {
  const IslamicGeometricPattern({
    super.key,
    this.color = Colors.white,
    this.centerAlignment = const Alignment(0, -0.14),
  });

  final Color color;
  final Alignment centerAlignment;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _IslamicGeometricPainter(
          color: color,
          centerAlignment: centerAlignment,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _IslamicGeometricPainter extends CustomPainter {
  _IslamicGeometricPainter({
    required this.color,
    required this.centerAlignment,
  });

  final Color color;
  final Alignment centerAlignment;

  static const List<double> _circleRadii = <double>[
    0.10,
    0.19,
    0.30,
    0.44,
    0.60,
    0.78,
    0.98,
    1.22,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = centerAlignment.alongSize(size);
    final double radius = size.width * 0.56;

    final Paint stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = true;

    for (final double factor in _circleRadii) {
      stroke.color = color.withValues(alpha: factor >= 1.0 ? 0.035 : 0.055);
      canvas.drawCircle(center, radius * factor, stroke);
    }

    stroke
      ..color = color.withValues(alpha: 0.06)
      ..strokeWidth = 1;
    canvas.drawPath(_polygon(center, radius * 0.88, 8, math.pi / 8), stroke);
    canvas.drawPath(_polygon(center, radius * 0.60, 8, math.pi / 8), stroke);

    stroke.color = color.withValues(alpha: 0.045);
    canvas.drawPath(_polygon(center, radius * 1.14, 8, 0), stroke);

    _drawDottedCircle(canvas, center, radius * 0.46, 64, 0.9, 0.07);
    _drawDottedCircle(canvas, center, radius * 1.02, 96, 0.8, 0.05);

    // Short radial ties between the two octagons.
    stroke.color = color.withValues(alpha: 0.05);
    for (int i = 0; i < 8; i++) {
      final double angle = math.pi / 8 + i * math.pi / 4;
      final Offset start = center +
          Offset(math.cos(angle), math.sin(angle)) * (radius * 0.60);
      final Offset end =
          center + Offset(math.cos(angle), math.sin(angle)) * (radius * 0.88);
      canvas.drawLine(start, end, stroke);
    }
  }

  void _drawDottedCircle(
    Canvas canvas,
    Offset center,
    double radius,
    int count,
    double dotRadius,
    double opacity,
  ) {
    final Paint dot = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < count; i++) {
      final double angle = (math.pi * 2 / count) * i;
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * radius,
        dotRadius,
        dot,
      );
    }
  }

  Path _polygon(Offset center, double radius, int sides, double rotation) {
    final Path path = Path();
    for (int i = 0; i < sides; i++) {
      final double angle = rotation + (math.pi * 2 / sides) * i;
      final Offset point =
          center + Offset(math.cos(angle), math.sin(angle)) * radius;
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    return path..close();
  }

  @override
  bool shouldRepaint(_IslamicGeometricPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.centerAlignment != centerAlignment;
}
