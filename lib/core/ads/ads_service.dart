import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';

/// Thin wrapper so the rest of the app never imports the ads SDK directly.
class AdsService {
  const AdsService._();

  static Future<void> initialize() async {
    if (!AdConfig.isSupported) {
      return;
    }
    await MobileAds.instance.initialize();
  }
}
