import 'dart:io';

import 'package:flutter/foundation.dart';

/// Central AdMob configuration.
///
/// Before release, paste the real IDs from the AdMob console
/// (التطبيقات ← الوحدات الإعلانية) into [_releaseAppId] and
/// [_releaseBannerAdUnitId], and set the same App ID in
/// android/app/src/main/AndroidManifest.xml.
class AdConfig {
  const AdConfig._();

  /// Google Mobile Ads only exists on Android and iOS; this repo also builds
  /// for web and desktop.
  static bool get isSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Real AdMob IDs (from the AdMob console). These are not secrets — they
  /// ship in the app binary.
  static const String releaseAppId = 'ca-app-pub-9334669534536657~3820501441';
  static const String releaseBannerAdUnitId =
      'ca-app-pub-9334669534536657/2100050659';

  // Google's official AdMob test IDs (safe for development).
  static const String testAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  static String get appId => kDebugMode ? testAppId : releaseAppId;

  /// Never serve production ads in debug builds — that counts as invalid
  /// traffic and can get the AdMob account suspended.
  static String get bannerAdUnitId =>
      kDebugMode ? testBannerAdUnitId : releaseBannerAdUnitId;
}
