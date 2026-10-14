import 'package:package_info_plus/package_info_plus.dart';

import 'legal/app_legal.dart';

/// Reads the real package version when the platform channel is available.
class AppInfo {
  const AppInfo._();

  static String version = '1.0.0';

  static String get versionLabel =>
      '${AppLegal.appName} — الإصدار $version';

  static Future<void> load() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      version = info.version;
    } catch (_) {
      version = '1.0.0';
    }
  }
}
