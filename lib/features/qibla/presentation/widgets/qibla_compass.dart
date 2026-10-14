import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/l10n/app_language.dart';
import '../../../../core/theme/app_colors.dart';

/// Qibla compass. When [heading] is null the dial stays north-up (same as the
/// original layout). With a heading, the rose rotates so the top of the screen
/// is the device facing direction and the Kaaba marker stays on the true
/// bearing.
class QiblaCompass extends StatelessWidget {
  const QiblaCompass({
    super.key,
    required this.qiblaAngle,
    required this.progress,
    this.heading,
  });

  /// Degrees clockwise from true north.
  final double qiblaAngle;

  /// Device true heading, 0–360, or null when the sensor is unavailable.
  final double? heading;

  /// 0 → 1 entry animation.
  final double progress;

  @override
  Widget build(BuildContext context) {
    final double side = math.min(MediaQuery.sizeOf(context).width - 32, 340);

    return Center(
      child: SizedBox(
        width: side,
        height: side,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CustomPaint(
              size: Size.square(side),
              painter: _CompassPainter(
                qiblaAngle: qiblaAngle,
                heading: heading,
                progress: progress,
                textDirection: Directionality.of(context),
                cardinals: <String>[
                  context.l10n.cardinalN,
                  context.l10n.cardinalE,
                  context.l10n.cardinalS,
                  context.l10n.cardinalW,
                ],
              ),
            ),
            _QiblaMarker(
              side: side,
              angle: _markerAngle,
              progress: progress,
            ),
          ],
        ),
      ),
    );
  }

  double get _markerAngle {
    final double? heading = this.heading;
    if (heading == null) {
      return qiblaAngle;
    }
    var delta = (qiblaAngle - heading) % 360;
    if (delta < 0) {
      delta += 360;
    }
    return delta;
  }
}

/// Kaaba badge + accuracy ring parked on the rim at the Qibla bearing.
class _QiblaMarker extends StatelessWidget {
  const _QiblaMarker({
    required this.side,
    required this.angle,
    required this.progress,
  });

  final double side;
  final double angle;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final double radius = side * 0.385 * progress;
    final double radians = (angle - 90) * math.pi / 180;
    final double dx = math.cos(radians) * radius;
    final double dy = math.sin(radians) * radius;

    return Transform.translate(
      offset: Offset(dx, dy),
      child: Opacity(
        opacity: progress,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2.5),
              ),
              child: Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(13),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.mosque_outlined,
                size: 24,
                color: AppColors.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompassPainter extends CustomPainter {
  _CompassPainter({
    required this.qiblaAngle,
    required this.progress,
    required this.cardinals,
    required this.textDirection,
    this.heading,
  });

  final double qiblaAngle;
  final double? heading;
  final double progress;
  final List<String> cardinals;
  final TextDirection textDirection;

  List<_Cardinal> get _cardinalMarks => <_Cardinal>[
    _Cardinal(cardinals[0], 0),
    _Cardinal(cardinals[1], 90),
    _Cardinal(cardinals[2], 180),
    _Cardinal(cardinals[3], 270),
  ];

  static const List<_Cardinal> _degrees = <_Cardinal>[
    _Cardinal('45°', 45),
    _Cardinal('135°', 135),
    _Cardinal('225°', 225),
    _Cardinal('315°', 315),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double r = size.width / 2;

    // Faint outer rings.
    final Paint ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.primary.withValues(alpha: 0.16);
    for (final double factor in <double>[1.0, 0.95, 0.90]) {
      canvas.drawCircle(center, r * factor, ring);
    }

    // White dial.
    canvas.drawCircle(
      center,
      r * 0.84,
      Paint()
        ..color = AppColors.textPrimary.withValues(alpha: 0.05)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    canvas.drawCircle(center, r * 0.84, Paint()..color = AppColors.surface);
    canvas.drawCircle(
      center,
      r * 0.66,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = AppColors.divider,
    );

    canvas.save();
    if (heading != null) {
      canvas.translate(center.dx, center.dy);
      canvas.rotate(-heading! * math.pi / 180);
      canvas.translate(-center.dx, -center.dy);
    }

    _drawDashedCircle(canvas, center, r * 0.50);
    _drawTicks(canvas, center, r);

    // Bearing arrow from the centre towards the Qibla.
    final double radians = (qiblaAngle - 90) * math.pi / 180;
    final double reach = r * 0.60 * progress;
    final Offset tip = center + Offset(math.cos(radians), math.sin(radians)) * reach;
    final Offset tail =
        center + Offset(math.cos(radians), math.sin(radians)) * (r * 0.12);

    canvas.drawLine(
      tail,
      tip,
      Paint()
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..shader = LinearGradient(
          colors: <Color>[
            AppColors.primary.withValues(alpha: 0.25),
            AppColors.primary,
          ],
        ).createShader(Rect.fromPoints(tail, tip)),
    );
    _drawArrowHead(canvas, tip, radians);

    if (heading == null) {
      // Idle needle, parked slightly off north — original north-up layout.
      final double needleAngle = (18 - 90) * math.pi / 180;
      final Offset needleStart =
          center +
          Offset(math.cos(needleAngle), math.sin(needleAngle)) * (r * 0.56);
      final Offset needleEnd =
          center +
          Offset(math.cos(needleAngle), math.sin(needleAngle)) * (r * 0.64);
      canvas.drawLine(
        needleStart,
        needleEnd,
        Paint()
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round
          ..color = AppColors.divider,
      );
    }

    for (final _Cardinal cardinal in _cardinalMarks) {
      _drawLabel(
        canvas,
        center,
        r * 0.745,
        cardinal,
        const TextStyle(
          fontFamily: 'IBMPlexSansArabic',
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      );
    }

    for (final _Cardinal degree in _degrees) {
      final bool active = (degree.angle - qiblaAngle).abs() < 24;
      _drawLabel(
        canvas,
        center,
        r * 0.90,
        degree,
        TextStyle(
          fontFamily: 'IBMPlexSansArabic',
          fontSize: 12,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          color: active ? AppColors.primary : AppColors.textMuted,
        ),
      );
    }

    canvas.restore();

    if (heading != null) {
      final double needleAngle = (0 - 90) * math.pi / 180;
      final Offset needleStart =
          center +
          Offset(math.cos(needleAngle), math.sin(needleAngle)) * (r * 0.56);
      final Offset needleEnd =
          center +
          Offset(math.cos(needleAngle), math.sin(needleAngle)) * (r * 0.64);
      canvas.drawLine(
        needleStart,
        needleEnd,
        Paint()
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round
          ..color = AppColors.divider,
      );
    }
  }

  void _drawTicks(Canvas canvas, Offset center, double r) {
    final Paint tick = Paint()
      ..strokeWidth = 1
      ..color = AppColors.divider;
    for (int angle = 0; angle < 360; angle += 15) {
      final double radians = (angle - 90) * math.pi / 180;
      final Offset unit = Offset(math.cos(radians), math.sin(radians));
      final bool major = angle % 45 == 0;
      canvas.drawLine(
        center + unit * (r * (major ? 0.60 : 0.63)),
        center + unit * (r * 0.66),
        tick,
      );
    }
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.textMuted.withValues(alpha: 0.45);
    const int segments = 72;
    for (int i = 0; i < segments; i += 2) {
      final double start = i * 2 * math.pi / segments;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        2 * math.pi / segments,
        false,
        paint,
      );
    }
  }

  void _drawArrowHead(Canvas canvas, Offset tip, double radians) {
    const double length = 15;
    const double spread = 0.42;
    final Path path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(
        tip.dx - math.cos(radians - spread) * length,
        tip.dy - math.sin(radians - spread) * length,
      )
      ..lineTo(
        tip.dx - math.cos(radians + spread) * length,
        tip.dy - math.sin(radians + spread) * length,
      )
      ..close();
    canvas.drawPath(path, Paint()..color = AppColors.primary);
  }

  void _drawLabel(
    Canvas canvas,
    Offset center,
    double radius,
    _Cardinal cardinal,
    TextStyle style,
  ) {
    final double radians = (cardinal.angle - 90) * math.pi / 180;
    final Offset position =
        center + Offset(math.cos(radians), math.sin(radians)) * radius;
    final TextPainter painter = TextPainter(
      text: TextSpan(text: cardinal.label, style: style),
      textDirection: textDirection,
    )..layout();
    painter.paint(
      canvas,
      position - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(_CompassPainter oldDelegate) =>
      oldDelegate.qiblaAngle != qiblaAngle ||
      oldDelegate.heading != heading ||
      oldDelegate.progress != progress ||
      oldDelegate.textDirection != textDirection ||
      !listEquals(oldDelegate.cardinals, cardinals);
}

class _Cardinal {
  const _Cardinal(this.label, this.angle);

  final String label;
  final double angle;
}
