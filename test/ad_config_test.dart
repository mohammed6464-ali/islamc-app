import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:islmac_app/core/ads/ad_config.dart';

void main() {
  test('ads are only supported on Android and iOS', () {
    // Tests run on the host machine, never on Android/iOS.
    expect(AdConfig.isSupported, isFalse);
  });

  test('debug builds always use Google test ad IDs', () {
    expect(AdConfig.appId, AdConfig.testAppId);
    expect(AdConfig.bannerAdUnitId, AdConfig.testBannerAdUnitId);
  });

  test('AndroidManifest declares the real AdMob application ID', () {
    final String manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    expect(manifest, contains('com.google.android.gms.ads.APPLICATION_ID'));
    expect(manifest, contains(AdConfig.releaseAppId));
  });
}
