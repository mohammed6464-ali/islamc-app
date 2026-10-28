import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'تقويم ومواقيت'**
  String get appName;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Your Calendar. Your Prayer Times. All in One Place.'**
  String get homeTagline;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'With you at every moment'**
  String get splashTagline;

  /// No description provided for @splashCompanion.
  ///
  /// In en, this message translates to:
  /// **'Official Umm Al-Qura calendar • Your daily companion'**
  String get splashCompanion;

  /// No description provided for @splashLoadingTimes.
  ///
  /// In en, this message translates to:
  /// **'Setting prayer times for your coordinates...'**
  String get splashLoadingTimes;

  /// No description provided for @splashAstronomical.
  ///
  /// In en, this message translates to:
  /// **'Astronomical data based on Umm Al-Qura'**
  String get splashAstronomical;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get navWeather;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App interface and prayer labels'**
  String get languageSubtitle;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance & language'**
  String get appearance;

  /// No description provided for @prayerAndAlerts.
  ///
  /// In en, this message translates to:
  /// **'Prayer & alerts'**
  String get prayerAndAlerts;

  /// No description provided for @locationAndWeather.
  ///
  /// In en, this message translates to:
  /// **'Location & weather'**
  String get locationAndWeather;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @prayerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Prayer and Adhan alerts'**
  String get prayerNotifications;

  /// No description provided for @prayerNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize Adhan and reminder sound for each prayer'**
  String get prayerNotificationsSubtitle;

  /// No description provided for @calculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Prayer calculation method'**
  String get calculationMethod;

  /// No description provided for @calculationMethodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Used to calculate prayer times'**
  String get calculationMethodSubtitle;

  /// No description provided for @eventAlerts.
  ///
  /// In en, this message translates to:
  /// **'Calendar and occasion alerts'**
  String get eventAlerts;

  /// No description provided for @eventAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'White days, Ashura, and the two Eids'**
  String get eventAlertsSubtitle;

  /// No description provided for @currentCity.
  ///
  /// In en, this message translates to:
  /// **'Current city'**
  String get currentCity;

  /// No description provided for @currentCitySubtitleAuto.
  ///
  /// In en, this message translates to:
  /// **'Using device GPS'**
  String get currentCitySubtitleAuto;

  /// No description provided for @currentCitySubtitleManual.
  ///
  /// In en, this message translates to:
  /// **'City selected manually'**
  String get currentCitySubtitleManual;

  /// No description provided for @useDeviceLocation.
  ///
  /// In en, this message translates to:
  /// **'Use device location'**
  String get useDeviceLocation;

  /// No description provided for @useDeviceLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update prayer times, Qibla, and weather from GPS'**
  String get useDeviceLocationSubtitle;

  /// No description provided for @gpsEnabled.
  ///
  /// In en, this message translates to:
  /// **'Device location is on.'**
  String get gpsEnabled;

  /// No description provided for @gpsManual.
  ///
  /// In en, this message translates to:
  /// **'You can choose a city manually.'**
  String get gpsManual;

  /// No description provided for @temperatureUnit.
  ///
  /// In en, this message translates to:
  /// **'Temperature unit'**
  String get temperatureUnit;

  /// No description provided for @temperatureUnitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shown on weather screens'**
  String get temperatureUnitSubtitle;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius'**
  String get celsius;

  /// No description provided for @fahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit'**
  String get fahrenheit;

  /// No description provided for @unitAdopted.
  ///
  /// In en, this message translates to:
  /// **'Unit set to {unit}.'**
  String unitAdopted(String unit);

  /// No description provided for @calendarDisplay.
  ///
  /// In en, this message translates to:
  /// **'Calendar display'**
  String get calendarDisplay;

  /// No description provided for @calendarDisplaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved and used on the calendar screen'**
  String get calendarDisplaySubtitle;

  /// No description provided for @hijri.
  ///
  /// In en, this message translates to:
  /// **'Hijri'**
  String get hijri;

  /// No description provided for @gregorian.
  ///
  /// In en, this message translates to:
  /// **'Gregorian'**
  String get gregorian;

  /// No description provided for @hijriAdopted.
  ///
  /// In en, this message translates to:
  /// **'Hijri view is on.'**
  String get hijriAdopted;

  /// No description provided for @gregorianAdopted.
  ///
  /// In en, this message translates to:
  /// **'Gregorian view is on.'**
  String get gregorianAdopted;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get aboutApp;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get terms;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share the app'**
  String get shareApp;

  /// No description provided for @legalLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: October 2026'**
  String get legalLastUpdated;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'تقويم ومواقيت is a personal companion for prayer times, Qibla, weather, and the Hijri and Gregorian calendars. We do not create accounts, and we do not run a user-data cloud for this app.'**
  String get privacyBody;

  /// No description provided for @privacyDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Data on your device'**
  String get privacyDeviceTitle;

  /// No description provided for @privacyDeviceBody.
  ///
  /// In en, this message translates to:
  /// **'Your choices — city, language, calculation method, Adhan mosque, temperature unit, calendar view, and alert preferences — are saved locally on the device so they remain after you close the app. These settings are not uploaded to our servers.'**
  String get privacyDeviceBody;

  /// No description provided for @privacyLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get privacyLocationTitle;

  /// No description provided for @privacyLocationBody.
  ///
  /// In en, this message translates to:
  /// **'If you allow location access, coordinates are used on the device to calculate prayer times and Qibla, and to request weather for your area. You can turn GPS off and pick a city manually at any time.'**
  String get privacyLocationBody;

  /// No description provided for @privacyWeatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get privacyWeatherTitle;

  /// No description provided for @privacyWeatherBody.
  ///
  /// In en, this message translates to:
  /// **'Current conditions and the forecast are requested from the Open-Meteo weather service using coordinates or the selected city. A short cache is kept on the device to limit repeat requests.'**
  String get privacyWeatherBody;

  /// No description provided for @privacyNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications and Adhan'**
  String get privacyNotificationsTitle;

  /// No description provided for @privacyNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Prayer and occasion reminders are scheduled locally through the device notification system. Adhan audio plays on your device. We do not send marketing messages.'**
  String get privacyNotificationsBody;

  /// No description provided for @privacyShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Sharing and retention'**
  String get privacyShareTitle;

  /// No description provided for @privacyShareBody.
  ///
  /// In en, this message translates to:
  /// **'We do not sell your data. We do not require your name, email, or phone number to use the app. Local settings remain until you clear the app data or uninstall it.'**
  String get privacyShareBody;

  /// No description provided for @termsBody.
  ///
  /// In en, this message translates to:
  /// **'By using تقويم ومواقيت you agree to these terms. If you do not agree, please stop using the app.'**
  String get termsBody;

  /// No description provided for @termsServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'What the app provides'**
  String get termsServiceTitle;

  /// No description provided for @termsServiceBody.
  ///
  /// In en, this message translates to:
  /// **'The app displays prayer times, Qibla, weather, a Hijri and Gregorian calendar, and Islamic and national occasions. Some features need the permissions you grant, and weather needs a network connection.'**
  String get termsServiceBody;

  /// No description provided for @termsPrayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer times'**
  String get termsPrayerTitle;

  /// No description provided for @termsPrayerBody.
  ///
  /// In en, this message translates to:
  /// **'Times are calculated on the device, by default according to the Umm Al-Qura method. You may choose another calculation method. Displayed times help you organize the day; they are not a fatwa or an official moon-sighting announcement.'**
  String get termsPrayerBody;

  /// No description provided for @termsAccuracyTitle.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get termsAccuracyTitle;

  /// No description provided for @termsAccuracyBody.
  ///
  /// In en, this message translates to:
  /// **'Qibla, weather, and calendar dates may differ because of device sensors, network delays, or later official announcements. Confirm important worship times and holidays from official sources when needed.'**
  String get termsAccuracyBody;

  /// No description provided for @termsUseTitle.
  ///
  /// In en, this message translates to:
  /// **'Your responsibilities'**
  String get termsUseTitle;

  /// No description provided for @termsUseBody.
  ///
  /// In en, this message translates to:
  /// **'Use the app lawfully. Do not rely on it as the sole source for legal or religious rulings. Keep location and notification permissions under your control.'**
  String get termsUseBody;

  /// No description provided for @termsLiabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Limitation of liability'**
  String get termsLiabilityTitle;

  /// No description provided for @termsLiabilityBody.
  ///
  /// In en, this message translates to:
  /// **'The app is provided as is. We are not liable for delays, calculation differences, missed reminders, or decisions based on the information shown.'**
  String get termsLiabilityBody;

  /// No description provided for @termsChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Changes'**
  String get termsChangesTitle;

  /// No description provided for @termsChangesBody.
  ///
  /// In en, this message translates to:
  /// **'These terms and the privacy policy may be updated inside the app. Continued use after an update means you accept the latest version.'**
  String get termsChangesBody;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'Prayer times using Umm Al-Qura, Qibla, weather, Hijri and Gregorian calendars, and Adhan from Masjid al-Haram and Al-Masjid an-Nabawi. Location stays on your device for prayer times, Qibla, and weather.'**
  String get aboutBody;

  /// No description provided for @settingsIntro.
  ///
  /// In en, this message translates to:
  /// **'Customize prayer times, alerts, and app preferences'**
  String get settingsIntro;

  /// No description provided for @countrySaudi.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get countrySaudi;

  /// No description provided for @cityRiyadh.
  ///
  /// In en, this message translates to:
  /// **'Riyadh'**
  String get cityRiyadh;

  /// No description provided for @cityMakkah.
  ///
  /// In en, this message translates to:
  /// **'Makkah'**
  String get cityMakkah;

  /// No description provided for @cityMadinah.
  ///
  /// In en, this message translates to:
  /// **'Madinah'**
  String get cityMadinah;

  /// No description provided for @cityJeddah.
  ///
  /// In en, this message translates to:
  /// **'Jeddah'**
  String get cityJeddah;

  /// No description provided for @cityDammam.
  ///
  /// In en, this message translates to:
  /// **'Dammam'**
  String get cityDammam;

  /// No description provided for @cityKhobar.
  ///
  /// In en, this message translates to:
  /// **'Khobar'**
  String get cityKhobar;

  /// No description provided for @cityTaif.
  ///
  /// In en, this message translates to:
  /// **'Taif'**
  String get cityTaif;

  /// No description provided for @cityAbha.
  ///
  /// In en, this message translates to:
  /// **'Abha'**
  String get cityAbha;

  /// No description provided for @cityTabuk.
  ///
  /// In en, this message translates to:
  /// **'Tabuk'**
  String get cityTabuk;

  /// No description provided for @cityBuraydah.
  ///
  /// In en, this message translates to:
  /// **'Buraydah'**
  String get cityBuraydah;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @prayerFajrLong.
  ///
  /// In en, this message translates to:
  /// **'Fajr prayer'**
  String get prayerFajrLong;

  /// No description provided for @prayerSunriseLong.
  ///
  /// In en, this message translates to:
  /// **'Sunrise time'**
  String get prayerSunriseLong;

  /// No description provided for @prayerDhuhrLong.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr prayer'**
  String get prayerDhuhrLong;

  /// No description provided for @prayerAsrLong.
  ///
  /// In en, this message translates to:
  /// **'Asr prayer'**
  String get prayerAsrLong;

  /// No description provided for @prayerMaghribLong.
  ///
  /// In en, this message translates to:
  /// **'Maghrib prayer'**
  String get prayerMaghribLong;

  /// No description provided for @prayerIshaLong.
  ///
  /// In en, this message translates to:
  /// **'Isha prayer'**
  String get prayerIshaLong;

  /// No description provided for @passed.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get passed;

  /// No description provided for @nextAdhan.
  ///
  /// In en, this message translates to:
  /// **'Next Adhan'**
  String get nextAdhan;

  /// No description provided for @sunriseForbidden.
  ///
  /// In en, this message translates to:
  /// **'Time when prayer is disliked'**
  String get sunriseForbidden;

  /// No description provided for @iftarTime.
  ///
  /// In en, this message translates to:
  /// **'Iftar time'**
  String get iftarTime;

  /// No description provided for @ishaFollows.
  ///
  /// In en, this message translates to:
  /// **'Followed by Shaf\'\' and Witr'**
  String get ishaFollows;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next prayer'**
  String get nextPrayer;

  /// No description provided for @todaysPrayers.
  ///
  /// In en, this message translates to:
  /// **'Today\'\'s prayer times'**
  String get todaysPrayers;

  /// No description provided for @prayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer times'**
  String get prayerTimes;

  /// No description provided for @prayerNotificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Prayer notification settings'**
  String get prayerNotificationSettings;

  /// No description provided for @enableAllPrayerAlerts.
  ///
  /// In en, this message translates to:
  /// **'Enable all prayer alerts'**
  String get enableAllPrayerAlerts;

  /// No description provided for @adhanPreviewHint.
  ///
  /// In en, this message translates to:
  /// **'Use Adhan Preview below to play the full recording.'**
  String get adhanPreviewHint;

  /// No description provided for @savePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save preferences'**
  String get savePreferences;

  /// No description provided for @prefsSaved.
  ///
  /// In en, this message translates to:
  /// **'Preferences saved and prayer alerts scheduled.'**
  String get prefsSaved;

  /// No description provided for @prefsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications could not be enabled.'**
  String get prefsBlocked;

  /// No description provided for @adhanSound.
  ///
  /// In en, this message translates to:
  /// **'Adhan and Takbir sound'**
  String get adhanSound;

  /// No description provided for @adhanSoundPicked.
  ///
  /// In en, this message translates to:
  /// **'“{name}” is now used for in-app Adhan.'**
  String adhanSoundPicked(String name);

  /// No description provided for @mosqueMakkah.
  ///
  /// In en, this message translates to:
  /// **'Masjid al-Haram (Makkah)'**
  String get mosqueMakkah;

  /// No description provided for @mosqueMadinah.
  ///
  /// In en, this message translates to:
  /// **'Al-Masjid an-Nabawi (Madinah)'**
  String get mosqueMadinah;

  /// No description provided for @mosqueMakkahShort.
  ///
  /// In en, this message translates to:
  /// **'Masjid al-Haram'**
  String get mosqueMakkahShort;

  /// No description provided for @mosqueMadinahShort.
  ///
  /// In en, this message translates to:
  /// **'The Prophet\'\'s Mosque'**
  String get mosqueMadinahShort;

  /// No description provided for @mosque.
  ///
  /// In en, this message translates to:
  /// **'Mosque'**
  String get mosque;

  /// No description provided for @adhanType.
  ///
  /// In en, this message translates to:
  /// **'Adhan type'**
  String get adhanType;

  /// No description provided for @adhanFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr Adhan'**
  String get adhanFajr;

  /// No description provided for @adhanRegular.
  ///
  /// In en, this message translates to:
  /// **'Adhan for other prayers'**
  String get adhanRegular;

  /// No description provided for @playAdhan.
  ///
  /// In en, this message translates to:
  /// **'Play Adhan'**
  String get playAdhan;

  /// No description provided for @stopAdhan.
  ///
  /// In en, this message translates to:
  /// **'Stop Adhan'**
  String get stopAdhan;

  /// No description provided for @adhanPreview.
  ///
  /// In en, this message translates to:
  /// **'Adhan Preview'**
  String get adhanPreview;

  /// No description provided for @adhanLoading.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get adhanLoading;

  /// No description provided for @adhanFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not play the selected Adhan file.'**
  String get adhanFailed;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test notification in two minutes'**
  String get testNotification;

  /// No description provided for @testNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Debug only. A real notification will fire in two minutes. Background the app or lock the device to verify.'**
  String get testNotificationBody;

  /// No description provided for @scheduleTest.
  ///
  /// In en, this message translates to:
  /// **'Schedule test notification'**
  String get scheduleTest;

  /// No description provided for @testScheduled.
  ///
  /// In en, this message translates to:
  /// **'Notification scheduled. Background the app or lock the device.'**
  String get testScheduled;

  /// No description provided for @testUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Notification scheduling is unavailable in this build.'**
  String get testUnavailable;

  /// No description provided for @exactAlarmNeeded.
  ///
  /// In en, this message translates to:
  /// **'Exact alarms are required to schedule the test.'**
  String get exactAlarmNeeded;

  /// No description provided for @testFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not schedule the test notification.'**
  String get testFailed;

  /// No description provided for @notificationAt.
  ///
  /// In en, this message translates to:
  /// **'Notification time: {time}'**
  String notificationAt(String time);

  /// No description provided for @prayerNotifyNote.
  ///
  /// In en, this message translates to:
  /// **'Times follow Umm Al-Qura in Makkah. The on-time alert uses a short system sound; the full Adhan plays inside the app.'**
  String get prayerNotifyNote;

  /// No description provided for @notificationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. You can enable them in system settings.'**
  String get notificationsDisabled;

  /// No description provided for @itsTimeForPrayer.
  ///
  /// In en, this message translates to:
  /// **'It\'\'s time for {name} prayer'**
  String itsTimeForPrayer(String name);

  /// No description provided for @itsTimeForSunrise.
  ///
  /// In en, this message translates to:
  /// **'It\'\'s sunrise'**
  String get itsTimeForSunrise;

  /// No description provided for @prayerTimeBody.
  ///
  /// In en, this message translates to:
  /// **'{longName} according to {city} time'**
  String prayerTimeBody(String longName, String city);

  /// No description provided for @sunriseBody.
  ///
  /// In en, this message translates to:
  /// **'Sunrise in {city}'**
  String sunriseBody(String city);

  /// No description provided for @minutesUntilPrayer.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes until {name} prayer'**
  String minutesUntilPrayer(int minutes, String name);

  /// No description provided for @advanceReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Advance reminder for {name} in {city}'**
  String advanceReminderBody(String name, String city);

  /// No description provided for @testNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer notification test'**
  String get testNotificationTitle;

  /// No description provided for @testNotificationMessage.
  ///
  /// In en, this message translates to:
  /// **'This is a test. Background the app or lock the device.'**
  String get testNotificationMessage;

  /// No description provided for @notificationDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Notification diagnostics'**
  String get notificationDiagnostics;

  /// No description provided for @diagPermission.
  ///
  /// In en, this message translates to:
  /// **'Notification permission: {value}'**
  String diagPermission(String value);

  /// No description provided for @diagExactAlarms.
  ///
  /// In en, this message translates to:
  /// **'Exact alarms: {value}'**
  String diagExactAlarms(String value);

  /// No description provided for @diagChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel: {id}'**
  String diagChannel(String id);

  /// No description provided for @diagOffset.
  ///
  /// In en, this message translates to:
  /// **'Reminder offset: {minutes} min'**
  String diagOffset(int minutes);

  /// No description provided for @diagMosque.
  ///
  /// In en, this message translates to:
  /// **'Mosque: {name}'**
  String diagMosque(String name);

  /// No description provided for @diagDeviceTime.
  ///
  /// In en, this message translates to:
  /// **'UTC now: {time}'**
  String diagDeviceTime(String time);

  /// No description provided for @diagTimezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone: {id}'**
  String diagTimezone(String id);

  /// No description provided for @diagNextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next prayer: {name} at {time}'**
  String diagNextPrayer(String name, String time);

  /// No description provided for @diagNextScheduled.
  ///
  /// In en, this message translates to:
  /// **'Next scheduled alert: {time}'**
  String diagNextScheduled(String time);

  /// No description provided for @diagPendingCount.
  ///
  /// In en, this message translates to:
  /// **'Pending notifications: {count}'**
  String diagPendingCount(int count);

  /// No description provided for @diagPendingIds.
  ///
  /// In en, this message translates to:
  /// **'Pending IDs: {ids}'**
  String diagPendingIds(String ids);

  /// No description provided for @diagInexact.
  ///
  /// In en, this message translates to:
  /// **'Using inexact alarms: {value}'**
  String diagInexact(String value);

  /// No description provided for @diagOn.
  ///
  /// In en, this message translates to:
  /// **'on'**
  String get diagOn;

  /// No description provided for @diagOff.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get diagOff;

  /// No description provided for @scheduleTest60s.
  ///
  /// In en, this message translates to:
  /// **'Test in 60 seconds'**
  String get scheduleTest60s;

  /// No description provided for @scheduleTest2m.
  ///
  /// In en, this message translates to:
  /// **'Test in 2 minutes'**
  String get scheduleTest2m;

  /// No description provided for @inspectPending.
  ///
  /// In en, this message translates to:
  /// **'Inspect pending notifications'**
  String get inspectPending;

  /// No description provided for @cancelTestNotifications.
  ///
  /// In en, this message translates to:
  /// **'Cancel test notifications'**
  String get cancelTestNotifications;

  /// No description provided for @testNotificationsCancelled.
  ///
  /// In en, this message translates to:
  /// **'Test notifications cancelled.'**
  String get testNotificationsCancelled;

  /// No description provided for @eventReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder: {title}'**
  String eventReminderTitle(String title);

  /// No description provided for @eventReminderBody.
  ///
  /// In en, this message translates to:
  /// **'The occasion is near. Tap to view details.'**
  String get eventReminderBody;

  /// No description provided for @inboxPrayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer alert'**
  String get inboxPrayerTitle;

  /// No description provided for @inboxEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Occasion reminder'**
  String get inboxEventTitle;

  /// No description provided for @inboxPrayerBody.
  ///
  /// In en, this message translates to:
  /// **'It\'\'s prayer time according to {city}'**
  String inboxPrayerBody(String city);

  /// No description provided for @inboxEventBody.
  ///
  /// In en, this message translates to:
  /// **'Open the details in the app'**
  String get inboxEventBody;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @calcUmmAlQura.
  ///
  /// In en, this message translates to:
  /// **'Umm Al-Qura calendar'**
  String get calcUmmAlQura;

  /// No description provided for @calcMwl.
  ///
  /// In en, this message translates to:
  /// **'Muslim World League'**
  String get calcMwl;

  /// No description provided for @calcEgyptian.
  ///
  /// In en, this message translates to:
  /// **'Egyptian General Authority of Survey'**
  String get calcEgyptian;

  /// No description provided for @calcKarachi.
  ///
  /// In en, this message translates to:
  /// **'University of Islamic Sciences, Karachi'**
  String get calcKarachi;

  /// No description provided for @weather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weather;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @weatherUpdated.
  ///
  /// In en, this message translates to:
  /// **'Weather data updated.'**
  String get weatherUpdated;

  /// No description provided for @weatherUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh weather. Last valid data is shown if available.'**
  String get weatherUpdateFailed;

  /// No description provided for @weatherIndicators.
  ///
  /// In en, this message translates to:
  /// **'Weather indicators now'**
  String get weatherIndicators;

  /// No description provided for @updating.
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get updating;

  /// No description provided for @liveAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Live accuracy'**
  String get liveAccuracy;

  /// No description provided for @forecast.
  ///
  /// In en, this message translates to:
  /// **'Upcoming days'**
  String get forecast;

  /// No description provided for @forecastDays.
  ///
  /// In en, this message translates to:
  /// **'{count} upcoming days'**
  String forecastDays(int count);

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind speed'**
  String get windSpeed;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels like'**
  String get feelsLike;

  /// No description provided for @uvIndex.
  ///
  /// In en, this message translates to:
  /// **'UV index'**
  String get uvIndex;

  /// No description provided for @kmh.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get kmh;

  /// No description provided for @warmer.
  ///
  /// In en, this message translates to:
  /// **'A couple of degrees warmer'**
  String get warmer;

  /// No description provided for @matchesTemp.
  ///
  /// In en, this message translates to:
  /// **'Matches the temperature'**
  String get matchesTemp;

  /// No description provided for @uvProtect.
  ///
  /// In en, this message translates to:
  /// **'Sun protection is recommended'**
  String get uvProtect;

  /// No description provided for @weatherSunny.
  ///
  /// In en, this message translates to:
  /// **'Sunny'**
  String get weatherSunny;

  /// No description provided for @weatherClearNight.
  ///
  /// In en, this message translates to:
  /// **'Clear night'**
  String get weatherClearNight;

  /// No description provided for @weatherFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get weatherFair;

  /// No description provided for @weatherPartlyCloudyNight.
  ///
  /// In en, this message translates to:
  /// **'Light clouds at night'**
  String get weatherPartlyCloudyNight;

  /// No description provided for @weatherPartlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get weatherPartlyCloudy;

  /// No description provided for @weatherCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherCloudy;

  /// No description provided for @weatherFog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get weatherFog;

  /// No description provided for @weatherDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Light drizzle'**
  String get weatherDrizzle;

  /// No description provided for @weatherRain.
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get weatherRain;

  /// No description provided for @weatherSnow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get weatherSnow;

  /// No description provided for @weatherThunder.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorms'**
  String get weatherThunder;

  /// No description provided for @noteClear.
  ///
  /// In en, this message translates to:
  /// **'Clear conditions, good for going out'**
  String get noteClear;

  /// No description provided for @noteFair.
  ///
  /// In en, this message translates to:
  /// **'Mostly fair and settled'**
  String get noteFair;

  /// No description provided for @noteBreeze.
  ///
  /// In en, this message translates to:
  /// **'A light breeze, suitable outdoors'**
  String get noteBreeze;

  /// No description provided for @noteOvercast.
  ///
  /// In en, this message translates to:
  /// **'Heavy cloud cover reducing sunlight'**
  String get noteOvercast;

  /// No description provided for @noteFog.
  ///
  /// In en, this message translates to:
  /// **'Low visibility, travel carefully'**
  String get noteFog;

  /// No description provided for @noteDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Light drizzle, a light umbrella helps'**
  String get noteDrizzle;

  /// No description provided for @noteRain.
  ///
  /// In en, this message translates to:
  /// **'Rain expected, prefer covered places'**
  String get noteRain;

  /// No description provided for @noteSnow.
  ///
  /// In en, this message translates to:
  /// **'Snowfall, watch for cold roads'**
  String get noteSnow;

  /// No description provided for @noteThunder.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorms, avoid open areas'**
  String get noteThunder;

  /// No description provided for @badgeStable.
  ///
  /// In en, this message translates to:
  /// **'Settled weather'**
  String get badgeStable;

  /// No description provided for @badgeCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get badgeCloudy;

  /// No description provided for @badgeFog.
  ///
  /// In en, this message translates to:
  /// **'Fog'**
  String get badgeFog;

  /// No description provided for @badgeDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Drizzle'**
  String get badgeDrizzle;

  /// No description provided for @badgeRain.
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get badgeRain;

  /// No description provided for @badgeSnow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get badgeSnow;

  /// No description provided for @badgeStorm.
  ///
  /// In en, this message translates to:
  /// **'Storms'**
  String get badgeStorm;

  /// No description provided for @qibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qibla;

  /// No description provided for @qiblaDirection.
  ///
  /// In en, this message translates to:
  /// **'Qibla direction'**
  String get qiblaDirection;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming occasions'**
  String get upcomingEvents;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

  /// No description provided for @emptyNotifications.
  ///
  /// In en, this message translates to:
  /// **'No received notifications yet. Prayer alerts and occasion reminders will appear here.'**
  String get emptyNotifications;

  /// No description provided for @customizeAlerts.
  ///
  /// In en, this message translates to:
  /// **'Customize alerts'**
  String get customizeAlerts;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your location'**
  String get locationTitle;

  /// No description provided for @locationBody.
  ///
  /// In en, this message translates to:
  /// **'We use your location for accurate prayer times, weather, and Qibla for your city.'**
  String get locationBody;

  /// No description provided for @allowLocation.
  ///
  /// In en, this message translates to:
  /// **'Allow location access'**
  String get allowLocation;

  /// No description provided for @chooseCityManually.
  ///
  /// In en, this message translates to:
  /// **'Choose a city manually'**
  String get chooseCityManually;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @highAccuracy.
  ///
  /// In en, this message translates to:
  /// **'High accuracy'**
  String get highAccuracy;

  /// No description provided for @locationPrivate.
  ///
  /// In en, this message translates to:
  /// **'Your location is stored on this device only'**
  String get locationPrivate;

  /// No description provided for @locationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not determine location. You can choose a city manually.'**
  String get locationFailed;

  /// No description provided for @changeCity.
  ///
  /// In en, this message translates to:
  /// **'Change city'**
  String get changeCity;

  /// No description provided for @adhanStarted.
  ///
  /// In en, this message translates to:
  /// **'Initializing…'**
  String get adhanStarted;

  /// No description provided for @preAlertExact.
  ///
  /// In en, this message translates to:
  /// **'Exactly at prayer time'**
  String get preAlertExact;

  /// No description provided for @preAlertMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes before'**
  String preAlertMinutes(int minutes);

  /// No description provided for @preAlertFive.
  ///
  /// In en, this message translates to:
  /// **'5 minutes before'**
  String get preAlertFive;

  /// No description provided for @preAlertTen.
  ///
  /// In en, this message translates to:
  /// **'10 minutes before'**
  String get preAlertTen;

  /// No description provided for @preAlertFifteen.
  ///
  /// In en, this message translates to:
  /// **'15 minutes before'**
  String get preAlertFifteen;

  /// No description provided for @remainingDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining'**
  String remainingDays(int days);

  /// No description provided for @eventToday.
  ///
  /// In en, this message translates to:
  /// **'The occasion is today'**
  String get eventToday;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @statusToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get statusToday;

  /// No description provided for @favoriteAdded.
  ///
  /// In en, this message translates to:
  /// **'“{title}” was added to favorites.'**
  String favoriteAdded(String title);

  /// No description provided for @favoriteRemoved.
  ///
  /// In en, this message translates to:
  /// **'“{title}” was removed from favorites.'**
  String favoriteRemoved(String title);

  /// No description provided for @addToDeviceCalendar.
  ///
  /// In en, this message translates to:
  /// **'Add to device calendar'**
  String get addToDeviceCalendar;

  /// No description provided for @calendarOpened.
  ///
  /// In en, this message translates to:
  /// **'The device calendar opened to finish adding the occasion.'**
  String get calendarOpened;

  /// No description provided for @calendarFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the device calendar.'**
  String get calendarFailed;

  /// No description provided for @enableAdvanceAlert.
  ///
  /// In en, this message translates to:
  /// **'Enable advance reminder'**
  String get enableAdvanceAlert;

  /// No description provided for @threeDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'3 days before the occasion'**
  String get threeDaysBefore;

  /// No description provided for @shareOccasion.
  ///
  /// In en, this message translates to:
  /// **'Share occasion'**
  String get shareOccasion;

  /// No description provided for @aboutOccasion.
  ///
  /// In en, this message translates to:
  /// **'About this occasion'**
  String get aboutOccasion;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Occasion date'**
  String get eventDate;

  /// No description provided for @timeUntilStart.
  ///
  /// In en, this message translates to:
  /// **'Time remaining until it begins'**
  String get timeUntilStart;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @saudiNationalDay.
  ///
  /// In en, this message translates to:
  /// **'Saudi National Day {n}'**
  String saudiNationalDay(int n);

  /// No description provided for @foundingDay.
  ///
  /// In en, this message translates to:
  /// **'Founding Day'**
  String get foundingDay;

  /// No description provided for @flagDay.
  ///
  /// In en, this message translates to:
  /// **'Flag Day'**
  String get flagDay;

  /// No description provided for @islamicNewYear.
  ///
  /// In en, this message translates to:
  /// **'Islamic New Year'**
  String get islamicNewYear;

  /// No description provided for @mawlid.
  ///
  /// In en, this message translates to:
  /// **'The Prophet\'\'s Birthday'**
  String get mawlid;

  /// No description provided for @ramadanStart.
  ///
  /// In en, this message translates to:
  /// **'Beginning of Ramadan'**
  String get ramadanStart;

  /// No description provided for @eidFitr.
  ///
  /// In en, this message translates to:
  /// **'Eid al-Fitr'**
  String get eidFitr;

  /// No description provided for @eidAdha.
  ///
  /// In en, this message translates to:
  /// **'Eid al-Adha'**
  String get eidAdha;

  /// No description provided for @nationalOccasion.
  ///
  /// In en, this message translates to:
  /// **'National occasion'**
  String get nationalOccasion;

  /// No description provided for @islamicOccasion.
  ///
  /// In en, this message translates to:
  /// **'Islamic occasion'**
  String get islamicOccasion;

  /// No description provided for @officialHoliday.
  ///
  /// In en, this message translates to:
  /// **'Official holiday'**
  String get officialHoliday;

  /// No description provided for @notPublicHoliday.
  ///
  /// In en, this message translates to:
  /// **'Working day'**
  String get notPublicHoliday;

  /// No description provided for @holidayPending.
  ///
  /// In en, this message translates to:
  /// **'Holiday per official announcement'**
  String get holidayPending;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySun;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySat;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDec;

  /// No description provided for @hijriMuharram.
  ///
  /// In en, this message translates to:
  /// **'Muharram'**
  String get hijriMuharram;

  /// No description provided for @hijriSafar.
  ///
  /// In en, this message translates to:
  /// **'Safar'**
  String get hijriSafar;

  /// No description provided for @hijriRabi1.
  ///
  /// In en, this message translates to:
  /// **'Rabi\'\' al-Awwal'**
  String get hijriRabi1;

  /// No description provided for @hijriRabi2.
  ///
  /// In en, this message translates to:
  /// **'Rabi\'\' al-Thani'**
  String get hijriRabi2;

  /// No description provided for @hijriJumada1.
  ///
  /// In en, this message translates to:
  /// **'Jumada al-Ula'**
  String get hijriJumada1;

  /// No description provided for @hijriJumada2.
  ///
  /// In en, this message translates to:
  /// **'Jumada al-Akhirah'**
  String get hijriJumada2;

  /// No description provided for @hijriRajab.
  ///
  /// In en, this message translates to:
  /// **'Rajab'**
  String get hijriRajab;

  /// No description provided for @hijriShaban.
  ///
  /// In en, this message translates to:
  /// **'Sha\'\'ban'**
  String get hijriShaban;

  /// No description provided for @hijriRamadan.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get hijriRamadan;

  /// No description provided for @hijriShawwal.
  ///
  /// In en, this message translates to:
  /// **'Shawwal'**
  String get hijriShawwal;

  /// No description provided for @hijriDhulQadah.
  ///
  /// In en, this message translates to:
  /// **'Dhul-Qa\'\'dah'**
  String get hijriDhulQadah;

  /// No description provided for @hijriDhulHijjah.
  ///
  /// In en, this message translates to:
  /// **'Dhul-Hijjah'**
  String get hijriDhulHijjah;

  /// No description provided for @dirN.
  ///
  /// In en, this message translates to:
  /// **'Northerly'**
  String get dirN;

  /// No description provided for @dirNE.
  ///
  /// In en, this message translates to:
  /// **'Northeasterly'**
  String get dirNE;

  /// No description provided for @dirE.
  ///
  /// In en, this message translates to:
  /// **'Easterly'**
  String get dirE;

  /// No description provided for @dirSE.
  ///
  /// In en, this message translates to:
  /// **'Southeasterly'**
  String get dirSE;

  /// No description provided for @dirS.
  ///
  /// In en, this message translates to:
  /// **'Southerly'**
  String get dirS;

  /// No description provided for @dirSW.
  ///
  /// In en, this message translates to:
  /// **'Southwesterly'**
  String get dirSW;

  /// No description provided for @dirW.
  ///
  /// In en, this message translates to:
  /// **'Westerly'**
  String get dirW;

  /// No description provided for @dirNW.
  ///
  /// In en, this message translates to:
  /// **'Northwesterly'**
  String get dirNW;

  /// No description provided for @uvLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get uvLow;

  /// No description provided for @uvModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get uvModerate;

  /// No description provided for @uvHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get uvHigh;

  /// No description provided for @uvVeryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very high'**
  String get uvVeryHigh;

  /// No description provided for @uvExtreme.
  ///
  /// In en, this message translates to:
  /// **'Extreme'**
  String get uvExtreme;

  /// No description provided for @humidityDry.
  ///
  /// In en, this message translates to:
  /// **'Relatively dry'**
  String get humidityDry;

  /// No description provided for @humidityComfort.
  ///
  /// In en, this message translates to:
  /// **'Comfortable'**
  String get humidityComfort;

  /// No description provided for @humidityHigh.
  ///
  /// In en, this message translates to:
  /// **'High and humid'**
  String get humidityHigh;

  /// No description provided for @celsiusUnit.
  ///
  /// In en, this message translates to:
  /// **'C'**
  String get celsiusUnit;

  /// No description provided for @fahrenheitUnit.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get fahrenheitUnit;

  /// No description provided for @celsiusLabel.
  ///
  /// In en, this message translates to:
  /// **'Celsius C°'**
  String get celsiusLabel;

  /// No description provided for @fahrenheitLabel.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit F°'**
  String get fahrenheitLabel;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language set to {name}.'**
  String languageChanged(String name);

  /// No description provided for @shareDisabled.
  ///
  /// In en, this message translates to:
  /// **'Sharing is not enabled in this build.'**
  String get shareDisabled;

  /// No description provided for @occasions.
  ///
  /// In en, this message translates to:
  /// **'Occasions'**
  String get occasions;

  /// No description provided for @imsakIftar.
  ///
  /// In en, this message translates to:
  /// **'Imsak and Iftar'**
  String get imsakIftar;

  /// No description provided for @iftarAt.
  ///
  /// In en, this message translates to:
  /// **'Iftar: {time}'**
  String iftarAt(String time);

  /// No description provided for @mondayThursdayFast.
  ///
  /// In en, this message translates to:
  /// **'Monday and Thursday fasting'**
  String get mondayThursdayFast;

  /// No description provided for @qiblaAngleLabel.
  ///
  /// In en, this message translates to:
  /// **'Qibla bearing'**
  String get qiblaAngleLabel;

  /// No description provided for @compassHighAccuracy.
  ///
  /// In en, this message translates to:
  /// **'High compass accuracy'**
  String get compassHighAccuracy;

  /// No description provided for @adhanEnabled.
  ///
  /// In en, this message translates to:
  /// **'Adhan is on'**
  String get adhanEnabled;

  /// No description provided for @adhanDisabled.
  ///
  /// In en, this message translates to:
  /// **'Adhan is off'**
  String get adhanDisabled;

  /// No description provided for @adhanTimeUmmAlQura.
  ///
  /// In en, this message translates to:
  /// **'Adhan time according to Umm Al-Qura'**
  String get adhanTimeUmmAlQura;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @periodAm.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get periodAm;

  /// No description provided for @periodPm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get periodPm;

  /// No description provided for @remainingUntilPrayer.
  ///
  /// In en, this message translates to:
  /// **'Time remaining until prayer'**
  String get remainingUntilPrayer;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @blessedDay.
  ///
  /// In en, this message translates to:
  /// **'Blessed day'**
  String get blessedDay;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @nextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get nextMonth;

  /// No description provided for @liveUpdate.
  ///
  /// In en, this message translates to:
  /// **'Live update'**
  String get liveUpdate;

  /// No description provided for @markAllReadDone.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read.'**
  String get markAllReadDone;

  /// No description provided for @customizeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Customize notifications and alerts'**
  String get customizeNotifications;

  /// No description provided for @controlAdhanAndEvents.
  ///
  /// In en, this message translates to:
  /// **'Control Adhan tone and occasion reminders'**
  String get controlAdhanAndEvents;

  /// No description provided for @receiveAdhanAll.
  ///
  /// In en, this message translates to:
  /// **'Receive Adhan and alerts for all prayer times'**
  String get receiveAdhanAll;

  /// No description provided for @dailyPrayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Daily prayer times'**
  String get dailyPrayerTimes;

  /// No description provided for @upcomingShort.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get upcomingShort;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get disabled;

  /// No description provided for @preAlertTime.
  ///
  /// In en, this message translates to:
  /// **'Advance reminder time'**
  String get preAlertTime;

  /// No description provided for @defaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// No description provided for @yourCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Your current location'**
  String get yourCurrentLocation;

  /// No description provided for @orChooseCity.
  ///
  /// In en, this message translates to:
  /// **'Or choose a city manually'**
  String get orChooseCity;

  /// No description provided for @popularHolyCities.
  ///
  /// In en, this message translates to:
  /// **'Popular and holy cities'**
  String get popularHolyCities;

  /// No description provided for @noCityMatch.
  ///
  /// In en, this message translates to:
  /// **'No city matches your search.'**
  String get noCityMatch;

  /// No description provided for @officialMethod.
  ///
  /// In en, this message translates to:
  /// **'Official calculation method: {method}'**
  String officialMethod(String method);

  /// No description provided for @officialMethodBody.
  ///
  /// In en, this message translates to:
  /// **'Fajr and Isha angles and Qibla follow official Ministry of Islamic Affairs criteria.'**
  String get officialMethodBody;

  /// No description provided for @mapPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'The map is illustrative in this build.'**
  String get mapPlaceholder;

  /// No description provided for @activeNow.
  ///
  /// In en, this message translates to:
  /// **'Active now'**
  String get activeNow;

  /// No description provided for @refreshGps.
  ///
  /// In en, this message translates to:
  /// **'Refresh location via GPS'**
  String get refreshGps;

  /// No description provided for @locationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Location updated to {city}.'**
  String locationUpdated(String city);

  /// No description provided for @locationAuto.
  ///
  /// In en, this message translates to:
  /// **'Detect location automatically'**
  String get locationAuto;

  /// No description provided for @locationAutoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update prayer times and Adhan when you travel between cities'**
  String get locationAutoSubtitle;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search for a city...'**
  String get searchCity;

  /// No description provided for @timesUpdatedForCity.
  ///
  /// In en, this message translates to:
  /// **'Prayer times updated for {city}.'**
  String timesUpdatedForCity(String city);

  /// No description provided for @qiblaCalibrate.
  ///
  /// In en, this message translates to:
  /// **'Recalibrate'**
  String get qiblaCalibrate;

  /// No description provided for @qiblaCalibrateBody.
  ///
  /// In en, this message translates to:
  /// **'Move the phone in a figure-eight away from metal and magnets, and keep it level to recalibrate the compass.'**
  String get qiblaCalibrateBody;

  /// No description provided for @distanceToMakkah.
  ///
  /// In en, this message translates to:
  /// **'Distance to Makkah: {km} km'**
  String distanceToMakkah(int km);

  /// No description provided for @holdPhoneFlat.
  ///
  /// In en, this message translates to:
  /// **'Hold the phone level on a flat surface for a more accurate reading. Keep it away from metal and magnets.'**
  String get holdPhoneFlat;

  /// No description provided for @compassAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Compass accuracy: {value}'**
  String compassAccuracy(String value);

  /// No description provided for @qiblaMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculation method'**
  String get qiblaMethodTitle;

  /// No description provided for @qiblaMethodBody.
  ///
  /// In en, this message translates to:
  /// **'Qibla is calculated by great-circle from your location to the Kaaba. {declination}Prayer calculation method: {method}.'**
  String qiblaMethodBody(String declination, String method);

  /// No description provided for @declinationNote.
  ///
  /// In en, this message translates to:
  /// **'Device heading is corrected with an approximate magnetic declination, not a certified true-north reading. '**
  String get declinationNote;

  /// No description provided for @eventDetails.
  ///
  /// In en, this message translates to:
  /// **'Occasion details'**
  String get eventDetails;

  /// No description provided for @savedInFavorites.
  ///
  /// In en, this message translates to:
  /// **'Saved in my favorite occasions'**
  String get savedInFavorites;

  /// No description provided for @saveToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Save to my favorite occasions'**
  String get saveToFavorites;

  /// No description provided for @qiblaKaaba.
  ///
  /// In en, this message translates to:
  /// **'Direction of the Kaaba'**
  String get qiblaKaaba;

  /// No description provided for @cardinalN.
  ///
  /// In en, this message translates to:
  /// **'N'**
  String get cardinalN;

  /// No description provided for @cardinalE.
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get cardinalE;

  /// No description provided for @cardinalS.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get cardinalS;

  /// No description provided for @cardinalW.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get cardinalW;

  /// No description provided for @qiblaDirN.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get qiblaDirN;

  /// No description provided for @qiblaDirNE.
  ///
  /// In en, this message translates to:
  /// **'Northeast'**
  String get qiblaDirNE;

  /// No description provided for @qiblaDirE.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get qiblaDirE;

  /// No description provided for @qiblaDirSE.
  ///
  /// In en, this message translates to:
  /// **'Southeast'**
  String get qiblaDirSE;

  /// No description provided for @qiblaDirS.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get qiblaDirS;

  /// No description provided for @qiblaDirSW.
  ///
  /// In en, this message translates to:
  /// **'Southwest'**
  String get qiblaDirSW;

  /// No description provided for @qiblaDirW.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get qiblaDirW;

  /// No description provided for @qiblaDirNW.
  ///
  /// In en, this message translates to:
  /// **'Northwest'**
  String get qiblaDirNW;

  /// No description provided for @timezoneOf.
  ///
  /// In en, this message translates to:
  /// **'{city} time'**
  String timezoneOf(String city);

  /// No description provided for @lastKnownLocation.
  ///
  /// In en, this message translates to:
  /// **'Last known location'**
  String get lastKnownLocation;

  /// No description provided for @gpsStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong, accurate GPS signal'**
  String get gpsStrong;

  /// No description provided for @manualLocation.
  ///
  /// In en, this message translates to:
  /// **'Manual location'**
  String get manualLocation;

  /// No description provided for @weatherUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating weather data...'**
  String get weatherUpdating;

  /// No description provided for @weatherLive.
  ///
  /// In en, this message translates to:
  /// **'Live update for {station}'**
  String weatherLive(String station);

  /// No description provided for @weatherUnavailableCity.
  ///
  /// In en, this message translates to:
  /// **'Weather is unavailable for this city.'**
  String get weatherUnavailableCity;

  /// No description provided for @weatherCached.
  ///
  /// In en, this message translates to:
  /// **'Saved data for {station}'**
  String weatherCached(String station);

  /// No description provided for @weatherUpdatedNow.
  ///
  /// In en, this message translates to:
  /// **'Updated just now'**
  String get weatherUpdatedNow;

  /// No description provided for @weatherUpdatedMinutes.
  ///
  /// In en, this message translates to:
  /// **'Updated {minutes} min ago'**
  String weatherUpdatedMinutes(int minutes);

  /// No description provided for @weatherUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Last update {time}'**
  String weatherUpdatedAt(String time);

  /// No description provided for @weatherStationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get weatherStationUnavailable;

  /// No description provided for @locServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are off. Turn them on in settings or choose a city manually.'**
  String get locServiceDisabled;

  /// No description provided for @locDenied.
  ///
  /// In en, this message translates to:
  /// **'Location access was denied. You can choose a city manually.'**
  String get locDenied;

  /// No description provided for @locDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is blocked. Enable it in app settings or choose a city manually.'**
  String get locDeniedForever;

  /// No description provided for @locTimeout.
  ///
  /// In en, this message translates to:
  /// **'Location timed out. Try again or choose a city manually.'**
  String get locTimeout;

  /// No description provided for @locUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Location is unavailable right now. You can choose a city manually.'**
  String get locUnavailable;

  /// No description provided for @locGeocodingFailed.
  ///
  /// In en, this message translates to:
  /// **'Coordinates were found, but the city name could not be resolved. The nearest known city will be used.'**
  String get locGeocodingFailed;

  /// No description provided for @weatherOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Last saved data is shown if available.'**
  String get weatherOffline;

  /// No description provided for @weatherTimeout.
  ///
  /// In en, this message translates to:
  /// **'The weather request timed out. Try refreshing later.'**
  String get weatherTimeout;

  /// No description provided for @weatherParse.
  ///
  /// In en, this message translates to:
  /// **'Could not read the weather data received.'**
  String get weatherParse;

  /// No description provided for @weatherUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Weather data could not be fetched right now.'**
  String get weatherUnavailable;

  /// No description provided for @compassUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The compass sensor is not available on this device. Qibla is calculated, but the needle will not follow phone rotation.'**
  String get compassUnavailable;

  /// No description provided for @compassNeedsCalibration.
  ///
  /// In en, this message translates to:
  /// **'Move in a figure-eight in the air away from metal to recalibrate the compass.'**
  String get compassNeedsCalibration;

  /// No description provided for @compassAccuracyUnknown.
  ///
  /// In en, this message translates to:
  /// **'Sensor accuracy is unavailable. Keep the phone away from magnets and hold it level.'**
  String get compassAccuracyUnknown;

  /// No description provided for @compassUnavailableShort.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get compassUnavailableShort;

  /// No description provided for @compassNeedsCalShort.
  ///
  /// In en, this message translates to:
  /// **'Needs calibration'**
  String get compassNeedsCalShort;

  /// No description provided for @compassLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get compassLow;

  /// No description provided for @compassMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get compassMedium;

  /// No description provided for @compassHigh.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get compassHigh;

  /// No description provided for @audioFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not play Adhan.'**
  String get audioFailed;

  /// No description provided for @cityFullName.
  ///
  /// In en, this message translates to:
  /// **'{city}, {country}'**
  String cityFullName(String city, String country);

  /// No description provided for @prayerSource.
  ///
  /// In en, this message translates to:
  /// **'{city} • Umm Al-Qura calendar'**
  String prayerSource(String city);

  /// No description provided for @appVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} — Version {version}'**
  String appVersionLabel(String name, String version);

  /// No description provided for @hijriDate.
  ///
  /// In en, this message translates to:
  /// **'{day} {month} {year} AH'**
  String hijriDate(int day, String month, int year);

  /// No description provided for @hijriMonthYear.
  ///
  /// In en, this message translates to:
  /// **'{month} {year} AH'**
  String hijriMonthYear(String month, int year);

  /// No description provided for @gregorianDate.
  ///
  /// In en, this message translates to:
  /// **'{day} {month} {year} CE'**
  String gregorianDate(int day, String month, int year);

  /// No description provided for @gregorianMonthYear.
  ///
  /// In en, this message translates to:
  /// **'{month} {year}'**
  String gregorianMonthYear(String month, int year);

  /// No description provided for @weekdayCommaDate.
  ///
  /// In en, this message translates to:
  /// **'{weekday}, {date}'**
  String weekdayCommaDate(String weekday, String date);

  /// No description provided for @forecastTodayWeekday.
  ///
  /// In en, this message translates to:
  /// **'Today ({weekday})'**
  String forecastTodayWeekday(String weekday);

  /// No description provided for @shareEventText.
  ///
  /// In en, this message translates to:
  /// **'{title}\n{date}\n{tagline}'**
  String shareEventText(String title, String date, String tagline);

  /// No description provided for @nationalOfficial.
  ///
  /// In en, this message translates to:
  /// **'Official national occasion'**
  String get nationalOfficial;

  /// No description provided for @holidayAllSectors.
  ///
  /// In en, this message translates to:
  /// **'Official holiday for all sectors'**
  String get holidayAllSectors;

  /// No description provided for @foundingHoliday.
  ///
  /// In en, this message translates to:
  /// **'Official Founding Day holiday'**
  String get foundingHoliday;

  /// No description provided for @flagNotHoliday.
  ///
  /// In en, this message translates to:
  /// **'National occasion, not a public holiday'**
  String get flagNotHoliday;

  /// No description provided for @islamicCalendar.
  ///
  /// In en, this message translates to:
  /// **'Hijri calendar'**
  String get islamicCalendar;

  /// No description provided for @ummAlQuraProvisional.
  ///
  /// In en, this message translates to:
  /// **'Umm Al-Qura calendar (provisional until the official sighting)'**
  String get ummAlQuraProvisional;

  /// No description provided for @fixedGregorianSep23.
  ///
  /// In en, this message translates to:
  /// **'Fixed Gregorian date (23 September)'**
  String get fixedGregorianSep23;

  /// No description provided for @fixedGregorianFeb22.
  ///
  /// In en, this message translates to:
  /// **'Fixed Gregorian date (22 February)'**
  String get fixedGregorianFeb22;

  /// No description provided for @fixedGregorianMar11.
  ///
  /// In en, this message translates to:
  /// **'Fixed Gregorian date (11 March)'**
  String get fixedGregorianMar11;

  /// No description provided for @nationalDayTagline.
  ///
  /// In en, this message translates to:
  /// **'We dream and we achieve • Glory and pride reaching the sky'**
  String get nationalDayTagline;

  /// No description provided for @foundingDayTagline.
  ///
  /// In en, this message translates to:
  /// **'Commemoration of the founding of the first Saudi state in 1727 CE'**
  String get foundingDayTagline;

  /// No description provided for @flagDayTagline.
  ///
  /// In en, this message translates to:
  /// **'A day to raise the Saudi flag and honor its symbol'**
  String get flagDayTagline;

  /// No description provided for @nationalDayDesc.
  ///
  /// In en, this message translates to:
  /// **'The day the Kingdom of Saudi Arabia was unified by King Abdulaziz bin Abdulrahman Al Saud, may God have mercy on him. The nation celebrates it every 23 September with pride.'**
  String get nationalDayDesc;

  /// No description provided for @nationalDayHighlight.
  ///
  /// In en, this message translates to:
  /// **'National events, air shows, and cultural programs are held across the Kingdom.'**
  String get nationalDayHighlight;

  /// No description provided for @foundingDayDesc.
  ///
  /// In en, this message translates to:
  /// **'Observed on 22 February each year, it commemorates the founding of the first Saudi state by Imam Muhammad bin Saud in 1727 CE.'**
  String get foundingDayDesc;

  /// No description provided for @foundingDayHighlight.
  ///
  /// In en, this message translates to:
  /// **'A fixed Gregorian date recognized as an official holiday.'**
  String get foundingDayHighlight;

  /// No description provided for @flagDayDesc.
  ///
  /// In en, this message translates to:
  /// **'Observed on 11 March each year, it honors the Saudi flag as a symbol of tawhid and sovereignty. It is not treated as a general public holiday.'**
  String get flagDayDesc;

  /// No description provided for @flagDayHighlight.
  ///
  /// In en, this message translates to:
  /// **'An informational national occasion, not an official holiday.'**
  String get flagDayHighlight;

  /// No description provided for @islamicNewYearNote.
  ///
  /// In en, this message translates to:
  /// **'Start of the Hijri year according to Umm Al-Qura'**
  String get islamicNewYearNote;

  /// No description provided for @islamicNewYearTagline.
  ///
  /// In en, this message translates to:
  /// **'A new Hijri year has begun'**
  String get islamicNewYearTagline;

  /// No description provided for @islamicNewYearDesc.
  ///
  /// In en, this message translates to:
  /// **'The first day of Muharram according to Umm Al-Qura. The calendar date may differ from the official moon-sighting announcement.'**
  String get islamicNewYearDesc;

  /// No description provided for @islamicNewYearHighlight.
  ///
  /// In en, this message translates to:
  /// **'A tabular Umm Al-Qura date, not an official sighting announcement.'**
  String get islamicNewYearHighlight;

  /// No description provided for @mawlidNote.
  ///
  /// In en, this message translates to:
  /// **'Noble biography and gatherings of remembrance'**
  String get mawlidNote;

  /// No description provided for @mawlidTagline.
  ///
  /// In en, this message translates to:
  /// **'The birth of the best of creation, peace be upon him'**
  String get mawlidTagline;

  /// No description provided for @mawlidDesc.
  ///
  /// In en, this message translates to:
  /// **'The birthday of Prophet Muhammad, peace be upon him, on 12 Rabi\'\' al-Awwal according to Umm Al-Qura. It is not a general public holiday in the Kingdom.'**
  String get mawlidDesc;

  /// No description provided for @mawlidHighlight.
  ///
  /// In en, this message translates to:
  /// **'Gatherings of remembrance and readings of the Prophetic biography are held in mosques.'**
  String get mawlidHighlight;

  /// No description provided for @ramadanNote.
  ///
  /// In en, this message translates to:
  /// **'The fasting month according to Umm Al-Qura'**
  String get ramadanNote;

  /// No description provided for @ramadanTagline.
  ///
  /// In en, this message translates to:
  /// **'Ramadan has arrived, the month of forgiveness and night prayer'**
  String get ramadanTagline;

  /// No description provided for @ramadanDesc.
  ///
  /// In en, this message translates to:
  /// **'The first day of Ramadan according to Umm Al-Qura tables. The actual start of fasting depends on the official moon-sighting announcement.'**
  String get ramadanDesc;

  /// No description provided for @ramadanHighlight.
  ///
  /// In en, this message translates to:
  /// **'A provisional calendar date that needs official confirmation.'**
  String get ramadanHighlight;

  /// No description provided for @eidFitrNote.
  ///
  /// In en, this message translates to:
  /// **'Eid holiday — provisional calendar date'**
  String get eidFitrNote;

  /// No description provided for @eidFitrTagline.
  ///
  /// In en, this message translates to:
  /// **'Eid Mubarak, and may you be well every year'**
  String get eidFitrTagline;

  /// No description provided for @eidFitrDesc.
  ///
  /// In en, this message translates to:
  /// **'The first day of Shawwal according to Umm Al-Qura. The official holiday length is announced yearly and is not invented here.'**
  String get eidFitrDesc;

  /// No description provided for @eidFitrHighlight.
  ///
  /// In en, this message translates to:
  /// **'A provisional calendar date; the official holiday is set by an annual decision.'**
  String get eidFitrHighlight;

  /// No description provided for @eidAdhaNote.
  ///
  /// In en, this message translates to:
  /// **'Eid holiday — provisional calendar date'**
  String get eidAdhaNote;

  /// No description provided for @eidAdhaTagline.
  ///
  /// In en, this message translates to:
  /// **'May God accept the rites, and may you be well every year'**
  String get eidAdhaTagline;

  /// No description provided for @eidAdhaDesc.
  ///
  /// In en, this message translates to:
  /// **'The 10th of Dhul-Hijjah according to Umm Al-Qura. The official holiday length is announced yearly.'**
  String get eidAdhaDesc;

  /// No description provided for @eidAdhaHighlight.
  ///
  /// In en, this message translates to:
  /// **'A provisional calendar date, not a final sighting announcement.'**
  String get eidAdhaHighlight;

  /// No description provided for @eventActionDuas.
  ///
  /// In en, this message translates to:
  /// **'Supplications and remembrance'**
  String get eventActionDuas;

  /// No description provided for @duasAndAdhkar.
  ///
  /// In en, this message translates to:
  /// **'Supplications and remembrance'**
  String get duasAndAdhkar;

  /// No description provided for @currentDay.
  ///
  /// In en, this message translates to:
  /// **'Current day'**
  String get currentDay;

  /// No description provided for @selectedDay.
  ///
  /// In en, this message translates to:
  /// **'Selected day'**
  String get selectedDay;

  /// No description provided for @citiesAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} cities available'**
  String citiesAvailable(int count);

  /// No description provided for @currentlySelected.
  ///
  /// In en, this message translates to:
  /// **'{city} (currently selected)'**
  String currentlySelected(String city);

  /// No description provided for @minuteOffset.
  ///
  /// In en, this message translates to:
  /// **'({signed} min difference)'**
  String minuteOffset(String signed);

  /// No description provided for @cloudCoverPct.
  ///
  /// In en, this message translates to:
  /// **'Cloud cover {cover}%'**
  String cloudCoverPct(int cover);

  /// No description provided for @highTemp.
  ///
  /// In en, this message translates to:
  /// **'High {temp}'**
  String highTemp(String temp);

  /// No description provided for @lowTemp.
  ///
  /// In en, this message translates to:
  /// **'Low {temp}'**
  String lowTemp(String temp);

  /// No description provided for @nextAdhanAt.
  ///
  /// In en, this message translates to:
  /// **'Next {name} Adhan: {time}'**
  String nextAdhanAt(String name, String time);

  /// No description provided for @nextPrayerAt.
  ///
  /// In en, this message translates to:
  /// **'{name} next at {time}'**
  String nextPrayerAt(String name, String time);

  /// No description provided for @forecastSnack.
  ///
  /// In en, this message translates to:
  /// **'Forecast for {day}: {description} ({low} / {high}).'**
  String forecastSnack(String day, String description, String low, String high);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
