import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

class AppLanguage {
  const AppLanguage._();

  static const String arabic = 'ar';
  static const String english = 'en';
  static const List<String> supported = <String>[arabic, english];

  static String normalize(String? raw) {
    if (raw == null || raw.isEmpty) {
      return arabic;
    }
    final String value = raw.trim().toLowerCase();
    if (value == english ||
        value == 'english' ||
        value.startsWith('en') ||
        value.contains('english')) {
      return english;
    }
    return arabic;
  }

  static Locale localeOf(String languageCode) =>
      Locale(normalize(languageCode));

  static AppLocalizations l10nOf(String languageCode) =>
      lookupAppLocalizations(localeOf(languageCode));

  static bool isEnglish(String languageCode) =>
      normalize(languageCode) == english;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
