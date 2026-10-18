import 'package:flutter/material.dart';

/// Official client palette and supporting neutrals.
///
/// Brand HEX values are exact and must not be approximated:
/// primary `#114234`, darkGreen `#0C3D2E`, accentGreen `#086348`,
/// lightMint `#D1E7DF`.
class AppColors {
  const AppColors._();

  // Official brand
  static const Color primary = Color(0xFF114234);
  static const Color darkGreen = Color(0xFF0C3D2E);
  static const Color accentGreen = Color(0xFF086348);
  static const Color lightMint = Color(0xFFD1E7DF);

  /// Alias kept so existing widgets keep compiling.
  static const Color primaryDark = darkGreen;
  static const Color primaryLight = accentGreen;

  // Splash gradient (top → bottom) built from the official greens.
  static const List<Color> splashGradient = <Color>[
    primary,
    Color(0xFF0E3B2F),
    darkGreen,
    Color(0xFF0A3226),
    Color(0xFF07261D),
    Color(0xFF051C16),
    Color(0xFF03140F),
  ];
  static const List<double> splashGradientStops = <double>[
    0.0,
    0.12,
    0.28,
    0.48,
    0.68,
    0.86,
    1.0,
  ];

  // Mints derived from light mint + accent, without replacing the brand HEX.
  static const Color mint = lightMint;
  static const Color mintBorder = Color(0xFFB4D6CA);
  static const Color mintStrong = lightMint;
  static const Color mintSoft = Color(0xFFE8F3EE);
  static const Color mintMid = lightMint;
  static const Color mintText = Color(0xFF5E8A7A);

  // Neutrals — kept off-white/gray for readability. Not forced to green.
  static const Color background = Color(0xFFF7FAF8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4EDE8);
  static const Color divider = Color(0xFFE0EAE5);
  static const Color pillGray = Color(0xFFEEF3F0);
  static const Color iconCircleGray = Color(0xFFE7EEEA);
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

  static const Color notificationDot = Color(0xFFE02B2B);
  static const Color toggleOff = Color(0xFFDEE4E0);

  static const Color heroGreenStart = accentGreen;
  static const Color heroGreenEnd = darkGreen;

  static const Color progressTrack = Color(0xFFE8E8E6);
  static const Color progressAmber = Color(0xFFE3B968);
  static const Color progressOrange = Color(0xFFD5802C);

  static const Color sunOrange = Color(0xFFF2A93B);
  static const Color mintTint = Color(0xFFF3F9F6);
}
