import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Stylised, fully vector stand-in for a map. No tiles are downloaded and no
/// location provider is involved — it only illustrates the selected city.
class MapPlaceholder extends StatefulWidget {
  const MapPlaceholder({super.key, required this.cityId});

  /// Used as the seed so each city gets its own stable block layout.
  final String cityId;

  @override
  State<MapPlaceholder> createState() => _MapPlaceholderState();
}

class _MapPlaceholderState extends State<MapPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.42,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AnimatedBuilder(
              animation: _pulse,
              builder: (BuildContext context, _) => CustomPaint(
                painter: _MapPainter(
                  seed: widget.cityId.hashCode,
                  pulse: _pulse.value,
                ),
              ),
            ),
            const Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(13),
                  child: Icon(
                    Icons.gps_fixed_rounded,
                    size: 24,
                    color: AppColors.surface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({required this.seed, required this.pulse});

  final int seed;
  final double pulse;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0xFFEDF2EC), Color(0xFFE3EADF)],
        ).createShader(rect),
    );

    final math.Random random = math.Random(seed);

    // Street grid.
    final Paint road = Paint()
      ..color = AppColors.surface.withValues(alpha: 0.85)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    for (int i = 1; i < 5; i++) {
      final double y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), road);
    }
    for (int i = 1; i < 7; i++) {
      final double x = size.width * i / 7;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), road);
    }

    // A diagonal highway.
    canvas.drawLine(
      Offset(0, size.height * 0.78),
      Offset(size.width, size.height * 0.34),
      Paint()
        ..color = AppColors.surface
        ..strokeWidth = 11
        ..strokeCap = StrokeCap.round,
    );

    // Building blocks.
    final Paint block = Paint();
    for (int row = 0; row < 5; row++) {
      for (int column = 0; column < 7; column++) {
        if (random.nextDouble() < 0.34) continue;
        final double x = size.width * column / 7 + 6;
        final double y = size.height * row / 5 + 6;
        final double w = size.width / 7 - 14;
        final double h = size.height / 5 - 14;
        if (w <= 0 || h <= 0) continue;
        block.color = Color.lerp(
          const Color(0xFFD7DFD4),
          const Color(0xFFC6D2C4),
          random.nextDouble(),
        )!;
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x, y, w, h),
            const Radius.circular(3),
          ),
          block,
        );
      }
    }

    // A patch of greenery to break the grid up.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.08,
          size.height * 0.08,
          size.width * 0.18,
          size.height * 0.22,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFC9DEC4),
    );

    // Accuracy halo around the centre marker.
    final Offset center = size.center(Offset.zero);
    final double base = size.shortestSide * 0.22;
    canvas.drawCircle(
      center,
      base,
      Paint()..color = AppColors.primary.withValues(alpha: 0.14),
    );
    canvas.drawCircle(
      center,
      base * (1 + pulse * 0.7),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = AppColors.primary.withValues(alpha: 0.35 * (1 - pulse)),
    );
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) =>
      oldDelegate.seed != seed || oldDelegate.pulse != pulse;
}
