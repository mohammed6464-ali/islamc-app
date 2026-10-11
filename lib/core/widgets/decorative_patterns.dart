import 'package:flutter/material.dart';

/// Faint dot grid used inside the dark "next prayer" hero card.
class DotGridPattern extends StatelessWidget {
  const DotGridPattern({
    super.key,
    this.spacing = 12,
    this.dotRadius = 1,
    this.opacity = 0.05,
  });

  final double spacing;
  final double dotRadius;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _DotGridPainter(
          spacing: spacing,
          dotRadius: dotRadius,
          opacity: opacity,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  _DotGridPainter({
    required this.spacing,
    required this.dotRadius,
    required this.opacity,
  });

  final double spacing;
  final double dotRadius;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;
    for (double y = spacing / 2; y < size.height; y += spacing) {
      for (double x = spacing / 2; x < size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter oldDelegate) =>
      oldDelegate.spacing != spacing ||
      oldDelegate.dotRadius != dotRadius ||
      oldDelegate.opacity != opacity;
}

/// Barely-there architectural silhouette sitting at the bottom of the
/// date / weather card, as in the reference.
class SkylineDecoration extends StatelessWidget {
  const SkylineDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(painter: _SkylinePainter(), size: Size.infinite),
    );
  }
}

class _SkylinePainter extends CustomPainter {
  // Each entry: left fraction, width fraction, height fraction, radius.
  static const List<List<double>> _blocks = <List<double>>[
    <double>[0.06, 0.07, 0.42, 3],
    <double>[0.15, 0.05, 0.60, 3],
    <double>[0.24, 0.09, 0.34, 4],
    <double>[0.38, 0.06, 0.52, 3],
    <double>[0.47, 0.10, 0.38, 4],
    <double>[0.62, 0.05, 0.56, 3],
    <double>[0.70, 0.08, 0.30, 4],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF101915).withValues(alpha: 0.022)
      ..style = PaintingStyle.fill;

    for (final List<double> block in _blocks) {
      final double width = size.width * block[1];
      final double height = size.height * block[2];
      final Rect rect = Rect.fromLTWH(
        size.width * block[0],
        size.height - height,
        width,
        height,
      );
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect,
          topLeft: Radius.circular(block[3]),
          topRight: Radius.circular(block[3]),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SkylinePainter oldDelegate) => false;
}
