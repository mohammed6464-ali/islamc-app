// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'تقويم ومواقيت';

  @override
  String get homeTagline =>
      'Your Calendar. Your Prayer Times. All in One Place.';

  @override
  String get welcome => 'Welcome';

  @override
  String get splashTagline => 'With you at every moment';

  @override
  String get splashCompanion =>
      'Official Umm Al-Qura calendar • Your daily companion';

  @override
  String get splashLoadingTimes =>
      'Setting prayer times for your coordinates...';

  @override
  String get splashAstronomical => 'Astronomical data based on Umm Al-Qura';

  @override
  String get navHome => 'Home';

  @override
  String get navWeather => 'Weather';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navSettings => 'Settings';

  @override
  String get back => 'Back';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get done => 'Done';

  @override
  String get retry => 'Retry';

  @override
  String get ok => 'OK';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSubtitle => 'App interface and prayer labels';

  @override
  String get appearance => 'Appearance & language';

  @override
  String get prayerAndAlerts => 'Prayer & alerts';

  @override
  String get locationAndWeather => 'Location & weather';

  @override
  String get aboutSection => 'About';

  @override
  String get prayerNotifications => 'Prayer and Adhan alerts';

  @override
  String get prayerNotificationsSubtitle =>
      'Customize Adhan and reminder sound for each prayer';

  @override
  String get calculationMethod => 'Prayer calculation method';

  @override
  String get calculationMethodSubtitle => 'Used to calculate prayer times';

  @override
  String get eventAlerts => 'Calendar and occasion alerts';

  @override
  String get eventAlertsSubtitle => 'White days, Ashura, and the two Eids';

  @override
  String get currentCity => 'Current city';

  @override
  String get currentCitySubtitleAuto => 'Using device GPS';

  @override
  String get currentCitySubtitleManual => 'City selected manually';

  @override
  String get useDeviceLocation => 'Use device location';

  @override
  String get useDeviceLocationSubtitle =>
      'Update prayer times, Qibla, and weather from GPS';

  @override
  String get gpsEnabled => 'Device location is on.';

  @override
  String get gpsManual => 'You can choose a city manually.';

  @override
  String get temperatureUnit => 'Temperature unit';

  @override
  String get temperatureUnitSubtitle => 'Shown on weather screens';

  @override
  String get celsius => 'Celsius';

  @override
  String get fahrenheit => 'Fahrenheit';

  @override
  String unitAdopted(String unit) {
    return 'Unit set to $unit.';
  }

  @override
  String get calendarDisplay => 'Calendar display';

  @override
  String get calendarDisplaySubtitle => 'Saved and used on the calendar screen';

  @override
  String get hijri => 'Hijri';

  @override
  String get gregorian => 'Gregorian';

  @override
  String get hijriAdopted => 'Hijri view is on.';

  @override
  String get gregorianAdopted => 'Gregorian view is on.';

  @override
  String get aboutApp => 'About the app';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get terms => 'Terms and conditions';

  @override
  String get shareApp => 'Share the app';

  @override
  String get legalLastUpdated => 'Last updated: October 2026';

  @override
  String get privacyBody =>
      'تقويم ومواقيت is a personal companion for prayer times, Qibla, weather, and the Hijri and Gregorian calendars. We do not create accounts, and we do not run a user-data cloud for this app.';

  @override
  String get privacyDeviceTitle => 'Data on your device';

  @override
  String get privacyDeviceBody =>
      'Your choices — city, language, calculation method, Adhan mosque, temperature unit, calendar view, and alert preferences — are saved locally on the device so they remain after you close the app. These settings are not uploaded to our servers.';

  @override
  String get privacyLocationTitle => 'Location';

  @override
  String get privacyLocationBody =>
      'If you allow location access, coordinates are used on the device to calculate prayer times and Qibla, and to request weather for your area. You can turn GPS off and pick a city manually at any time.';

  @override
  String get privacyWeatherTitle => 'Weather';

  @override
  String get privacyWeatherBody =>
      'Current conditions and the forecast are requested from the Open-Meteo weather service using coordinates or the selected city. A short cache is kept on the device to limit repeat requests.';

  @override
  String get privacyNotificationsTitle => 'Notifications and Adhan';

  @override
  String get privacyNotificationsBody =>
      'Prayer and occasion reminders are scheduled locally through the device notification system. Adhan audio plays on your device. We do not send marketing messages.';

  @override
  String get privacyShareTitle => 'Sharing and retention';

  @override
  String get privacyShareBody =>
      'We do not sell your data. We do not require your name, email, or phone number to use the app. Local settings remain until you clear the app data or uninstall it.';

  @override
  String get privacyAdsTitle => 'Advertising';

  @override
  String get privacyAdsBody =>
      'The app displays ads through Google AdMob. This service may collect the device\'s advertising ID and basic device data to serve and measure ads. We do not access this data ourselves or use it for any other purpose.';

  @override
  String get termsBody =>
      'By using تقويم ومواقيت you agree to these terms. If you do not agree, please stop using the app.';

  @override
  String get termsServiceTitle => 'What the app provides';

  @override
  String get termsServiceBody =>
      'The app displays prayer times, Qibla, weather, a Hijri and Gregorian calendar, and Islamic and national occasions. Some features need the permissions you grant, and weather needs a network connection.';

  @override
  String get termsPrayerTitle => 'Prayer times';

  @override
  String get termsPrayerBody =>
      'Times are calculated on the device, by default according to the Umm Al-Qura method. You may choose another calculation method. Displayed times help you organize the day; they are not a fatwa or an official moon-sighting announcement.';

  @override
  String get termsAccuracyTitle => 'Accuracy';

  @override
  String get termsAccuracyBody =>
      'Qibla, weather, and calendar dates may differ because of device sensors, network delays, or later official announcements. Confirm important worship times and holidays from official sources when needed.';

  @override
  String get termsUseTitle => 'Your responsibilities';

  @override
  String get termsUseBody =>
      'Use the app lawfully. Do not rely on it as the sole source for legal or religious rulings. Keep location and notification permissions under your control.';

  @override
  String get termsLiabilityTitle => 'Limitation of liability';

  @override
  String get termsLiabilityBody =>
      'The app is provided as is. We are not liable for delays, calculation differences, missed reminders, or decisions based on the information shown.';

  @override
  String get termsChangesTitle => 'Changes';

  @override
  String get termsChangesBody =>
      'These terms and the privacy policy may be updated inside the app. Continued use after an update means you accept the latest version.';

  @override
  String get aboutBody =>
      'Prayer times using Umm Al-Qura, Qibla, weather, Hijri and Gregorian calendars, and Adhan from Masjid al-Haram and Al-Masjid an-Nabawi. Location stays on your device for prayer times, Qibla, and weather.';

  @override
  String get settingsIntro =>
      'Customize prayer times, alerts, and app preferences';

  @override
  String get countrySaudi => 'Saudi Arabia';

  @override
  String get cityRiyadh => 'Riyadh';

  @override
  String get cityMakkah => 'Makkah';

  @override
  String get cityMadinah => 'Madinah';

  @override
  String get cityJeddah => 'Jeddah';

  @override
  String get cityDammam => 'Dammam';

  @override
  String get cityKhobar => 'Khobar';

  @override
  String get cityTaif => 'Taif';

  @override
  String get cityAbha => 'Abha';

  @override
  String get cityTabuk => 'Tabuk';

  @override
  String get cityBuraydah => 'Buraydah';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get prayerFajrLong => 'Fajr prayer';

  @override
  String get prayerSunriseLong => 'Sunrise time';

  @override
  String get prayerDhuhrLong => 'Dhuhr prayer';

  @override
  String get prayerAsrLong => 'Asr prayer';

  @override
  String get prayerMaghribLong => 'Maghrib prayer';

  @override
  String get prayerIshaLong => 'Isha prayer';

  @override
  String get passed => 'Passed';

  @override
  String get nextAdhan => 'Next Adhan';

  @override
  String get sunriseForbidden => 'Time when prayer is disliked';

  @override
  String get iftarTime => 'Iftar time';

  @override
  String get ishaFollows => 'Followed by Shaf\' and Witr';

  @override
  String get nextPrayer => 'Next prayer';

  @override
  String get todaysPrayers => 'Today\'s prayer times';

  @override
  String get prayerTimes => 'Prayer times';

  @override
  String get prayerNotificationSettings => 'Prayer notification settings';

  @override
  String get enableAllPrayerAlerts => 'Enable all prayer alerts';

  @override
  String get adhanPreviewHint =>
      'Use Adhan Preview below to play the full recording.';

  @override
  String get savePreferences => 'Save preferences';

  @override
  String get prefsSaved => 'Preferences saved and prayer alerts scheduled.';

  @override
  String get prefsBlocked => 'Notifications could not be enabled.';

  @override
  String get adhanSound => 'Adhan and Takbir sound';

  @override
  String adhanSoundPicked(String name) {
    return '“$name” is now used for in-app Adhan.';
  }

  @override
  String get mosqueMakkah => 'Masjid al-Haram (Makkah)';

  @override
  String get mosqueMadinah => 'Al-Masjid an-Nabawi (Madinah)';

  @override
  String get mosqueMakkahShort => 'Masjid al-Haram';

  @override
  String get mosqueMadinahShort => 'The Prophet\'s Mosque';

  @override
  String get mosque => 'Mosque';

  @override
  String get adhanType => 'Adhan type';

  @override
  String get adhanFajr => 'Fajr Adhan';

  @override
  String get adhanRegular => 'Adhan for other prayers';

  @override
  String get playAdhan => 'Play Adhan';

  @override
  String get stopAdhan => 'Stop Adhan';

  @override
  String get adhanPreview => 'Adhan Preview';

  @override
  String get adhanLoading => 'Starting…';

  @override
  String get adhanFailed => 'Could not play the selected Adhan file.';

  @override
  String get testNotification => 'Test notification in two minutes';

  @override
  String get testNotificationBody =>
      'Debug only. A real notification will fire in two minutes. Background the app or lock the device to verify.';

  @override
  String get scheduleTest => 'Schedule test notification';

  @override
  String get testScheduled =>
      'Notification scheduled. Background the app or lock the device.';

  @override
  String get testUnavailable =>
      'Notification scheduling is unavailable in this build.';

  @override
  String get exactAlarmNeeded =>
      'Exact alarms are required to schedule the test.';

  @override
  String get testFailed => 'Could not schedule the test notification.';

  @override
  String notificationAt(String time) {
    return 'Notification time: $time';
  }

  @override
  String get prayerNotifyNote =>
      'Times follow Umm Al-Qura in Makkah. The on-time alert uses a short system sound; the full Adhan plays inside the app.';

  @override
  String get notificationsDisabled =>
      'Notifications are off. You can enable them in system settings.';

  @override
  String itsTimeForPrayer(String name) {
    return 'It\'s time for $name prayer';
  }

  @override
  String get itsTimeForSunrise => 'It\'s sunrise';

  @override
  String prayerTimeBody(String longName, String city) {
    return '$longName according to $city time';
  }

  @override
  String sunriseBody(String city) {
    return 'Sunrise in $city';
  }

  @override
  String minutesUntilPrayer(int minutes, String name) {
    return '$minutes minutes until $name prayer';
  }

  @override
  String advanceReminderBody(String name, String city) {
    return 'Advance reminder for $name in $city';
  }

  @override
  String get testNotificationTitle => 'Prayer notification test';

  @override
  String get testNotificationMessage =>
      'This is a test. Background the app or lock the device.';

  @override
  String get notificationDiagnostics => 'Notification diagnostics';

  @override
  String diagPermission(String value) {
    return 'Notification permission: $value';
  }

  @override
  String diagExactAlarms(String value) {
    return 'Exact alarms: $value';
  }

  @override
  String diagChannel(String id) {
    return 'Channel: $id';
  }

  @override
  String diagOffset(int minutes) {
    return 'Reminder offset: $minutes min';
  }

  @override
  String diagMosque(String name) {
    return 'Mosque: $name';
  }

  @override
  String diagDeviceTime(String time) {
    return 'UTC now: $time';
  }

  @override
  String diagTimezone(String id) {
    return 'Timezone: $id';
  }

  @override
  String diagNextPrayer(String name, String time) {
    return 'Next prayer: $name at $time';
  }

  @override
  String diagNextScheduled(String time) {
    return 'Next scheduled alert: $time';
  }

  @override
  String diagPendingCount(int count) {
    return 'Pending notifications: $count';
  }

  @override
  String diagPendingIds(String ids) {
    return 'Pending IDs: $ids';
  }

  @override
  String diagInexact(String value) {
    return 'Using inexact alarms: $value';
  }

  @override
  String get diagOn => 'on';

  @override
  String get diagOff => 'off';

  @override
  String get scheduleTest60s => 'Test in 60 seconds';

  @override
  String get scheduleTest2m => 'Test in 2 minutes';

  @override
  String get inspectPending => 'Inspect pending notifications';

  @override
  String get cancelTestNotifications => 'Cancel test notifications';

  @override
  String get testNotificationsCancelled => 'Test notifications cancelled.';

  @override
  String eventReminderTitle(String title) {
    return 'Reminder: $title';
  }

  @override
  String get eventReminderBody => 'The occasion is near. Tap to view details.';

  @override
  String get inboxPrayerTitle => 'Prayer alert';

  @override
  String get inboxEventTitle => 'Occasion reminder';

  @override
  String inboxPrayerBody(String city) {
    return 'It\'s prayer time according to $city';
  }

  @override
  String get inboxEventBody => 'Open the details in the app';

  @override
  String get now => 'Now';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get calcUmmAlQura => 'Umm Al-Qura calendar';

  @override
  String get calcMwl => 'Muslim World League';

  @override
  String get calcEgyptian => 'Egyptian General Authority of Survey';

  @override
  String get calcKarachi => 'University of Islamic Sciences, Karachi';

  @override
  String get weather => 'Weather';

  @override
  String get refresh => 'Refresh';

  @override
  String get weatherUpdated => 'Weather data updated.';

  @override
  String get weatherUpdateFailed =>
      'Could not refresh weather. Last valid data is shown if available.';

  @override
  String get weatherIndicators => 'Weather indicators now';

  @override
  String get updating => 'Updating';

  @override
  String get liveAccuracy => 'Live accuracy';

  @override
  String get forecast => 'Upcoming days';

  @override
  String forecastDays(int count) {
    return '$count upcoming days';
  }

  @override
  String get humidity => 'Humidity';

  @override
  String get windSpeed => 'Wind speed';

  @override
  String get feelsLike => 'Feels like';

  @override
  String get uvIndex => 'UV index';

  @override
  String get kmh => 'km/h';

  @override
  String get warmer => 'A couple of degrees warmer';

  @override
  String get matchesTemp => 'Matches the temperature';

  @override
  String get uvProtect => 'Sun protection is recommended';

  @override
  String get weatherSunny => 'Sunny';

  @override
  String get weatherClearNight => 'Clear night';

  @override
  String get weatherFair => 'Fair';

  @override
  String get weatherPartlyCloudyNight => 'Light clouds at night';

  @override
  String get weatherPartlyCloudy => 'Partly cloudy';

  @override
  String get weatherCloudy => 'Cloudy';

  @override
  String get weatherFog => 'Fog';

  @override
  String get weatherDrizzle => 'Light drizzle';

  @override
  String get weatherRain => 'Rainy';

  @override
  String get weatherSnow => 'Snow';

  @override
  String get weatherThunder => 'Thunderstorms';

  @override
  String get noteClear => 'Clear conditions, good for going out';

  @override
  String get noteFair => 'Mostly fair and settled';

  @override
  String get noteBreeze => 'A light breeze, suitable outdoors';

  @override
  String get noteOvercast => 'Heavy cloud cover reducing sunlight';

  @override
  String get noteFog => 'Low visibility, travel carefully';

  @override
  String get noteDrizzle => 'Light drizzle, a light umbrella helps';

  @override
  String get noteRain => 'Rain expected, prefer covered places';

  @override
  String get noteSnow => 'Snowfall, watch for cold roads';

  @override
  String get noteThunder => 'Thunderstorms, avoid open areas';

  @override
  String get badgeStable => 'Settled weather';

  @override
  String get badgeCloudy => 'Cloudy';

  @override
  String get badgeFog => 'Fog';

  @override
  String get badgeDrizzle => 'Drizzle';

  @override
  String get badgeRain => 'Rainy';

  @override
  String get badgeSnow => 'Snow';

  @override
  String get badgeStorm => 'Storms';

  @override
  String get qibla => 'Qibla';

  @override
  String get qiblaDirection => 'Qibla direction';

  @override
  String get calendar => 'Calendar';

  @override
  String get upcomingEvents => 'Upcoming occasions';

  @override
  String get notifications => 'Notifications';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get emptyNotifications =>
      'No received notifications yet. Prayer alerts and occasion reminders will appear here.';

  @override
  String get customizeAlerts => 'Customize alerts';

  @override
  String get locationTitle => 'Choose your location';

  @override
  String get locationBody =>
      'We use your location for accurate prayer times, weather, and Qibla for your city.';

  @override
  String get allowLocation => 'Allow location access';

  @override
  String get chooseCityManually => 'Choose a city manually';

  @override
  String get skip => 'Skip';

  @override
  String get highAccuracy => 'High accuracy';

  @override
  String get locationPrivate => 'Your location is stored on this device only';

  @override
  String get locationFailed =>
      'Could not determine location. You can choose a city manually.';

  @override
  String get changeCity => 'Change city';

  @override
  String get adhanStarted => 'Initializing…';

  @override
  String get preAlertExact => 'Exactly at prayer time';

  @override
  String preAlertMinutes(int minutes) {
    return '$minutes minutes before';
  }

  @override
  String get preAlertFive => '5 minutes before';

  @override
  String get preAlertTen => '10 minutes before';

  @override
  String get preAlertFifteen => '15 minutes before';

  @override
  String remainingDays(int days) {
    return '$days days remaining';
  }

  @override
  String get eventToday => 'The occasion is today';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get statusToday => 'Today';

  @override
  String favoriteAdded(String title) {
    return '“$title” was added to favorites.';
  }

  @override
  String favoriteRemoved(String title) {
    return '“$title” was removed from favorites.';
  }

  @override
  String get addToDeviceCalendar => 'Add to device calendar';

  @override
  String get calendarOpened =>
      'The device calendar opened to finish adding the occasion.';

  @override
  String get calendarFailed => 'Could not open the device calendar.';

  @override
  String get enableAdvanceAlert => 'Enable advance reminder';

  @override
  String get threeDaysBefore => '3 days before the occasion';

  @override
  String get shareOccasion => 'Share occasion';

  @override
  String get aboutOccasion => 'About this occasion';

  @override
  String get eventDate => 'Occasion date';

  @override
  String get timeUntilStart => 'Time remaining until it begins';

  @override
  String get status => 'Status';

  @override
  String get quickActions => 'Quick actions';

  @override
  String saudiNationalDay(int n) {
    return 'Saudi National Day $n';
  }

  @override
  String get foundingDay => 'Founding Day';

  @override
  String get flagDay => 'Flag Day';

  @override
  String get islamicNewYear => 'Islamic New Year';

  @override
  String get mawlid => 'The Prophet\'s Birthday';

  @override
  String get ramadanStart => 'Beginning of Ramadan';

  @override
  String get eidFitr => 'Eid al-Fitr';

  @override
  String get eidAdha => 'Eid al-Adha';

  @override
  String get nationalOccasion => 'National occasion';

  @override
  String get islamicOccasion => 'Islamic occasion';

  @override
  String get officialHoliday => 'Official holiday';

  @override
  String get notPublicHoliday => 'Working day';

  @override
  String get holidayPending => 'Holiday per official announcement';

  @override
  String get weekdaySun => 'Sunday';

  @override
  String get weekdayMon => 'Monday';

  @override
  String get weekdayTue => 'Tuesday';

  @override
  String get weekdayWed => 'Wednesday';

  @override
  String get weekdayThu => 'Thursday';

  @override
  String get weekdayFri => 'Friday';

  @override
  String get weekdaySat => 'Saturday';

  @override
  String get monthJan => 'January';

  @override
  String get monthFeb => 'February';

  @override
  String get monthMar => 'March';

  @override
  String get monthApr => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'June';

  @override
  String get monthJul => 'July';

  @override
  String get monthAug => 'August';

  @override
  String get monthSep => 'September';

  @override
  String get monthOct => 'October';

  @override
  String get monthNov => 'November';

  @override
  String get monthDec => 'December';

  @override
  String get hijriMuharram => 'Muharram';

  @override
  String get hijriSafar => 'Safar';

  @override
  String get hijriRabi1 => 'Rabi\' al-Awwal';

  @override
  String get hijriRabi2 => 'Rabi\' al-Thani';

  @override
  String get hijriJumada1 => 'Jumada al-Ula';

  @override
  String get hijriJumada2 => 'Jumada al-Akhirah';

  @override
  String get hijriRajab => 'Rajab';

  @override
  String get hijriShaban => 'Sha\'ban';

  @override
  String get hijriRamadan => 'Ramadan';

  @override
  String get hijriShawwal => 'Shawwal';

  @override
  String get hijriDhulQadah => 'Dhul-Qa\'dah';

  @override
  String get hijriDhulHijjah => 'Dhul-Hijjah';

  @override
  String get dirN => 'Northerly';

  @override
  String get dirNE => 'Northeasterly';

  @override
  String get dirE => 'Easterly';

  @override
  String get dirSE => 'Southeasterly';

  @override
  String get dirS => 'Southerly';

  @override
  String get dirSW => 'Southwesterly';

  @override
  String get dirW => 'Westerly';

  @override
  String get dirNW => 'Northwesterly';

  @override
  String get uvLow => 'Low';

  @override
  String get uvModerate => 'Moderate';

  @override
  String get uvHigh => 'High';

  @override
  String get uvVeryHigh => 'Very high';

  @override
  String get uvExtreme => 'Extreme';

  @override
  String get humidityDry => 'Relatively dry';

  @override
  String get humidityComfort => 'Comfortable';

  @override
  String get humidityHigh => 'High and humid';

  @override
  String get celsiusUnit => 'C';

  @override
  String get fahrenheitUnit => 'F';

  @override
  String get celsiusLabel => 'Celsius C°';

  @override
  String get fahrenheitLabel => 'Fahrenheit F°';

  @override
  String languageChanged(String name) {
    return 'Language set to $name.';
  }

  @override
  String get shareDisabled => 'Sharing is not enabled in this build.';

  @override
  String get occasions => 'Occasions';

  @override
  String get imsakIftar => 'Imsak and Iftar';

  @override
  String iftarAt(String time) {
    return 'Iftar: $time';
  }

  @override
  String get mondayThursdayFast => 'Monday and Thursday fasting';

  @override
  String get qiblaAngleLabel => 'Qibla bearing';

  @override
  String get compassHighAccuracy => 'High compass accuracy';

  @override
  String get adhanEnabled => 'Adhan is on';

  @override
  String get adhanDisabled => 'Adhan is off';

  @override
  String get adhanTimeUmmAlQura => 'Adhan time according to Umm Al-Qura';

  @override
  String get morning => 'Morning';

  @override
  String get evening => 'Evening';

  @override
  String get periodAm => 'AM';

  @override
  String get periodPm => 'PM';

  @override
  String get remainingUntilPrayer => 'Time remaining until prayer';

  @override
  String get current => 'Current';

  @override
  String get blessedDay => 'Blessed day';

  @override
  String get details => 'Details';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String get liveUpdate => 'Live update';

  @override
  String get markAllReadDone => 'All notifications marked as read.';

  @override
  String get customizeNotifications => 'Customize notifications and alerts';

  @override
  String get controlAdhanAndEvents =>
      'Control Adhan tone and occasion reminders';

  @override
  String get receiveAdhanAll => 'Receive Adhan and alerts for all prayer times';

  @override
  String get dailyPrayerTimes => 'Daily prayer times';

  @override
  String get upcomingShort => 'Next';

  @override
  String get enabled => 'On';

  @override
  String get disabled => 'Off';

  @override
  String get preAlertTime => 'Advance reminder time';

  @override
  String get defaultLabel => 'Default';

  @override
  String get yourCurrentLocation => 'Your current location';

  @override
  String get orChooseCity => 'Or choose a city manually';

  @override
  String get popularHolyCities => 'Popular and holy cities';

  @override
  String get noCityMatch => 'No city matches your search.';

  @override
  String officialMethod(String method) {
    return 'Official calculation method: $method';
  }

  @override
  String get officialMethodBody =>
      'Fajr and Isha angles and Qibla follow official Ministry of Islamic Affairs criteria.';

  @override
  String get mapPlaceholder => 'The map is illustrative in this build.';

  @override
  String get activeNow => 'Active now';

  @override
  String get refreshGps => 'Refresh location via GPS';

  @override
  String locationUpdated(String city) {
    return 'Location updated to $city.';
  }

  @override
  String get locationAuto => 'Detect location automatically';

  @override
  String get locationAutoSubtitle =>
      'Update prayer times and Adhan when you travel between cities';

  @override
  String get searchCity => 'Search for a city...';

  @override
  String timesUpdatedForCity(String city) {
    return 'Prayer times updated for $city.';
  }

  @override
  String get qiblaCalibrate => 'Recalibrate';

  @override
  String get qiblaCalibrateBody =>
      'Move the phone in a figure-eight away from metal and magnets, and keep it level to recalibrate the compass.';

  @override
  String distanceToMakkah(int km) {
    return 'Distance to Makkah: $km km';
  }

  @override
  String get holdPhoneFlat =>
      'Hold the phone level on a flat surface for a more accurate reading. Keep it away from metal and magnets.';

  @override
  String compassAccuracy(String value) {
    return 'Compass accuracy: $value';
  }

  @override
  String get qiblaMethodTitle => 'Calculation method';

  @override
  String qiblaMethodBody(String declination, String method) {
    return 'Qibla is calculated by great-circle from your location to the Kaaba. ${declination}Prayer calculation method: $method.';
  }

  @override
  String get declinationNote =>
      'Device heading is corrected with an approximate magnetic declination, not a certified true-north reading. ';

  @override
  String get eventDetails => 'Occasion details';

  @override
  String get savedInFavorites => 'Saved in my favorite occasions';

  @override
  String get saveToFavorites => 'Save to my favorite occasions';

  @override
  String get qiblaKaaba => 'Direction of the Kaaba';

  @override
  String get cardinalN => 'N';

  @override
  String get cardinalE => 'E';

  @override
  String get cardinalS => 'S';

  @override
  String get cardinalW => 'W';

  @override
  String get qiblaDirN => 'North';

  @override
  String get qiblaDirNE => 'Northeast';

  @override
  String get qiblaDirE => 'East';

  @override
  String get qiblaDirSE => 'Southeast';

  @override
  String get qiblaDirS => 'South';

  @override
  String get qiblaDirSW => 'Southwest';

  @override
  String get qiblaDirW => 'West';

  @override
  String get qiblaDirNW => 'Northwest';

  @override
  String timezoneOf(String city) {
    return '$city time';
  }

  @override
  String get lastKnownLocation => 'Last known location';

  @override
  String get gpsStrong => 'Strong, accurate GPS signal';

  @override
  String get manualLocation => 'Manual location';

  @override
  String get weatherUpdating => 'Updating weather data...';

  @override
  String weatherLive(String station) {
    return 'Live update for $station';
  }

  @override
  String get weatherUnavailableCity => 'Weather is unavailable for this city.';

  @override
  String weatherCached(String station) {
    return 'Saved data for $station';
  }

  @override
  String get weatherUpdatedNow => 'Updated just now';

  @override
  String weatherUpdatedMinutes(int minutes) {
    return 'Updated $minutes min ago';
  }

  @override
  String weatherUpdatedAt(String time) {
    return 'Last update $time';
  }

  @override
  String get weatherStationUnavailable => 'Unavailable';

  @override
  String get locServiceDisabled =>
      'Location services are off. Turn them on in settings or choose a city manually.';

  @override
  String get locDenied =>
      'Location access was denied. You can choose a city manually.';

  @override
  String get locDeniedForever =>
      'Location permission is blocked. Enable it in app settings or choose a city manually.';

  @override
  String get locTimeout =>
      'Location timed out. Try again or choose a city manually.';

  @override
  String get locUnavailable =>
      'Location is unavailable right now. You can choose a city manually.';

  @override
  String get locGeocodingFailed =>
      'Coordinates were found, but the city name could not be resolved. The nearest known city will be used.';

  @override
  String get weatherOffline =>
      'No internet connection. Last saved data is shown if available.';

  @override
  String get weatherTimeout =>
      'The weather request timed out. Try refreshing later.';

  @override
  String get weatherParse => 'Could not read the weather data received.';

  @override
  String get weatherUnavailable =>
      'Weather data could not be fetched right now.';

  @override
  String get compassUnavailable =>
      'The compass sensor is not available on this device. Qibla is calculated, but the needle will not follow phone rotation.';

  @override
  String get compassNeedsCalibration =>
      'Move in a figure-eight in the air away from metal to recalibrate the compass.';

  @override
  String get compassAccuracyUnknown =>
      'Sensor accuracy is unavailable. Keep the phone away from magnets and hold it level.';

  @override
  String get compassUnavailableShort => 'Unavailable';

  @override
  String get compassNeedsCalShort => 'Needs calibration';

  @override
  String get compassLow => 'Low';

  @override
  String get compassMedium => 'Medium';

  @override
  String get compassHigh => 'Good';

  @override
  String get audioFailed => 'Could not play Adhan.';

  @override
  String cityFullName(String city, String country) {
    return '$city, $country';
  }

  @override
  String prayerSource(String city) {
    return '$city • Umm Al-Qura calendar';
  }

  @override
  String appVersionLabel(String name, String version) {
    return '$name — Version $version';
  }

  @override
  String hijriDate(int day, String month, int year) {
    return '$day $month $year AH';
  }

  @override
  String hijriMonthYear(String month, int year) {
    return '$month $year AH';
  }

  @override
  String gregorianDate(int day, String month, int year) {
    return '$day $month $year CE';
  }

  @override
  String gregorianMonthYear(String month, int year) {
    return '$month $year';
  }

  @override
  String weekdayCommaDate(String weekday, String date) {
    return '$weekday, $date';
  }

  @override
  String forecastTodayWeekday(String weekday) {
    return 'Today ($weekday)';
  }

  @override
  String get contactUs => 'Contact us';

  @override
  String get contactUnavailable =>
      'No official contact address has been provided yet.';

  @override
  String shareEventText(String title, String date, String tagline) {
    return '$title\n$date\n$tagline';
  }

  @override
  String get nationalOfficial => 'Official national occasion';

  @override
  String get holidayAllSectors => 'Official holiday for all sectors';

  @override
  String get foundingHoliday => 'Official Founding Day holiday';

  @override
  String get flagNotHoliday => 'National occasion, not a public holiday';

  @override
  String get islamicCalendar => 'Hijri calendar';

  @override
  String get ummAlQuraProvisional =>
      'Umm Al-Qura calendar (provisional until the official sighting)';

  @override
  String get fixedGregorianSep23 => 'Fixed Gregorian date (23 September)';

  @override
  String get fixedGregorianFeb22 => 'Fixed Gregorian date (22 February)';

  @override
  String get fixedGregorianMar11 => 'Fixed Gregorian date (11 March)';

  @override
  String get nationalDayTagline =>
      'We dream and we achieve • Glory and pride reaching the sky';

  @override
  String get foundingDayTagline =>
      'Commemoration of the founding of the first Saudi state in 1727 CE';

  @override
  String get flagDayTagline =>
      'A day to raise the Saudi flag and honor its symbol';

  @override
  String get nationalDayDesc =>
      'The day the Kingdom of Saudi Arabia was unified by King Abdulaziz bin Abdulrahman Al Saud, may God have mercy on him. The nation celebrates it every 23 September with pride.';

  @override
  String get nationalDayHighlight =>
      'National events, air shows, and cultural programs are held across the Kingdom.';

  @override
  String get foundingDayDesc =>
      'Observed on 22 February each year, it commemorates the founding of the first Saudi state by Imam Muhammad bin Saud in 1727 CE.';

  @override
  String get foundingDayHighlight =>
      'A fixed Gregorian date recognized as an official holiday.';

  @override
  String get flagDayDesc =>
      'Observed on 11 March each year, it honors the Saudi flag as a symbol of tawhid and sovereignty. It is not treated as a general public holiday.';

  @override
  String get flagDayHighlight =>
      'An informational national occasion, not an official holiday.';

  @override
  String get islamicNewYearNote =>
      'Start of the Hijri year according to Umm Al-Qura';

  @override
  String get islamicNewYearTagline => 'A new Hijri year has begun';

  @override
  String get islamicNewYearDesc =>
      'The first day of Muharram according to Umm Al-Qura. The calendar date may differ from the official moon-sighting announcement.';

  @override
  String get islamicNewYearHighlight =>
      'A tabular Umm Al-Qura date, not an official sighting announcement.';

  @override
  String get mawlidNote => 'Noble biography and gatherings of remembrance';

  @override
  String get mawlidTagline =>
      'The birth of the best of creation, peace be upon him';

  @override
  String get mawlidDesc =>
      'The birthday of Prophet Muhammad, peace be upon him, on 12 Rabi\' al-Awwal according to Umm Al-Qura. It is not a general public holiday in the Kingdom.';

  @override
  String get mawlidHighlight =>
      'Gatherings of remembrance and readings of the Prophetic biography are held in mosques.';

  @override
  String get ramadanNote => 'The fasting month according to Umm Al-Qura';

  @override
  String get ramadanTagline =>
      'Ramadan has arrived, the month of forgiveness and night prayer';

  @override
  String get ramadanDesc =>
      'The first day of Ramadan according to Umm Al-Qura tables. The actual start of fasting depends on the official moon-sighting announcement.';

  @override
  String get ramadanHighlight =>
      'A provisional calendar date that needs official confirmation.';

  @override
  String get eidFitrNote => 'Eid holiday — provisional calendar date';

  @override
  String get eidFitrTagline => 'Eid Mubarak, and may you be well every year';

  @override
  String get eidFitrDesc =>
      'The first day of Shawwal according to Umm Al-Qura. The official holiday length is announced yearly and is not invented here.';

  @override
  String get eidFitrHighlight =>
      'A provisional calendar date; the official holiday is set by an annual decision.';

  @override
  String get eidAdhaNote => 'Eid holiday — provisional calendar date';

  @override
  String get eidAdhaTagline =>
      'May God accept the rites, and may you be well every year';

  @override
  String get eidAdhaDesc =>
      'The 10th of Dhul-Hijjah according to Umm Al-Qura. The official holiday length is announced yearly.';

  @override
  String get eidAdhaHighlight =>
      'A provisional calendar date, not a final sighting announcement.';

  @override
  String get eventActionDuas => 'Supplications and remembrance';

  @override
  String get duasAndAdhkar => 'Supplications and remembrance';

  @override
  String get currentDay => 'Current day';

  @override
  String get selectedDay => 'Selected day';

  @override
  String citiesAvailable(int count) {
    return '$count cities available';
  }

  @override
  String currentlySelected(String city) {
    return '$city (currently selected)';
  }

  @override
  String minuteOffset(String signed) {
    return '($signed min difference)';
  }

  @override
  String cloudCoverPct(int cover) {
    return 'Cloud cover $cover%';
  }

  @override
  String highTemp(String temp) {
    return 'High $temp';
  }

  @override
  String lowTemp(String temp) {
    return 'Low $temp';
  }

  @override
  String nextAdhanAt(String name, String time) {
    return 'Next $name Adhan: $time';
  }

  @override
  String nextPrayerAt(String name, String time) {
    return '$name next at $time';
  }

  @override
  String forecastSnack(
    String day,
    String description,
    String low,
    String high,
  ) {
    return 'Forecast for $day: $description ($low / $high).';
  }
}
