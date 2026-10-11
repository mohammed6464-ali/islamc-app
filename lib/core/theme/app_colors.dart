import 'package:flutter/material.dart';

/// Palette sampled directly from the three reference designs.
class AppColors {
  const AppColors._();

  // Brand greens
  static const Color primary = Color(0xFF085E45);
  static const Color primaryDark = Color(0xFF064B38);
  static const Color primaryLight = Color(0xFF0B634A);
  static const Color accentGreen = Color(0xFF1C7A5A);

  // Splash gradient stops (top -> bottom)
  static const List<Color> splashGradient = <Color>[
    Color(0xFF115540),
    Color(0xFF105139),
    Color(0xFF0C4B36),
    Color(0xFF074432),
    Color(0xFF043428),
    Color(0xFF03241D),
    Color(0xFF02201A),
  ];
  static const List<double> splashGradientStops = <double>[
    0.0,
    0.10,
    0.30,
    0.50,
    0.68,
    0.88,
    1.0,
  ];

  // Mints
  static const Color mint = Color(0xFFD8F8EB);
  static const Color mintBorder = Color(0xFFA9DEC6);
  static const Color mintStrong = Color(0xFF98F0CD);
  static const Color mintSoft = Color(0xFFE9F8F0);
  static const Color mintMid = Color(0xFFD2F2E2);
  static const Color mintText = Color(0xFF9CC6B6);

  // Neutrals
  static const Color background = Color(0xFFF9FAF5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFEDEFE8);
  static const Color divider = Color(0xFFE8EAE3);
  static const Color pillGray = Color(0xFFEEEFEA);
  static const Color iconCircleGray = Color(0xFFE9EDE6);
  static const Color iconCircleNeutral = Color(0xFFEDEDEA);

  // Text
  static const Color textPrimary = Color(0xFF101915);
  static const Color textSecondary = Color(0xFF6E7872);
  static const Color textMuted = Color(0xFF9AA19C);

  // Gold
  static const Color gold = Color(0xFFD5AF66);
  static const Color goldText = Color(0xFFDDBB74);
  static const Color goldDeep = Color(0xFFC79A4A);

  // Event (warm amber)
  static const Color amberBg = Color(0xFFFFF5E3);
  static const Color amberIcon = Color(0xFFFBDFA3);
  static const Color amberPill = Color(0xFFFAE7C0);
  static const Color amberText = Color(0xFF6B5526);

  // Notification dot
  static const Color notificationDot = Color(0xFFE02B2B);

  // Switches
  static const Color toggleOff = Color(0xFFDEE4E0);

  // Hero gradients used by the event / prayer detail cards
  static const Color heroGreenStart = Color(0xFF22573B);
  static const Color heroGreenEnd = Color(0xFF014432);

  // Metric progress bars
  static const Color progressTrack = Color(0xFFE8E8E6);
  static const Color progressAmber = Color(0xFFE3B968);
  static const Color progressOrange = Color(0xFFD5802C);

  // Weather illustration
  static const Color sunOrange = Color(0xFFF2A93B);
  static const Color mintTint = Color(0xFFF1FDF9);
}
