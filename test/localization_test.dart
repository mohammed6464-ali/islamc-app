import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islmac_app/core/events/event_repository.dart';
import 'package:islmac_app/core/l10n/app_copy.dart';
import 'package:islmac_app/core/l10n/app_language.dart';
import 'package:islmac_app/core/location/fake_location_provider.dart';
import 'package:islmac_app/core/notifications/notification_gateway.dart';
import 'package:islmac_app/core/notifications/notification_models.dart';
import 'package:islmac_app/core/notifications/prayer_notification_scheduler.dart';
import 'package:islmac_app/core/persistence/settings_store.dart';
import 'package:islmac_app/core/prayer/prayer_calc_method.dart';
import 'package:islmac_app/core/prayer/prayer_times_service.dart';
import 'package:islmac_app/core/state/app_state.dart';
import 'package:islmac_app/core/theme/app_colors.dart';
import 'package:islmac_app/core/time/app_clock.dart';
import 'package:islmac_app/core/time/app_timezone.dart';
import 'package:islmac_app/main.dart';

void main() {
  setUpAll(AppTimezone.ensureInitialized);

  AppState buildState({
    SettingsStore? store,
    NotificationGateway? notifications,
  }) {
    return AppState(
      clock: FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
      locationProvider: FakeLocationProvider(),
      store: store ?? MemorySettingsStore(),
      notificationGateway: notifications,
    );
  }

  test('Arabic is the default language and English is a valid code', () {
    expect(AppLanguage.normalize(null), 'ar');
    expect(AppLanguage.normalize('العربية'), 'ar');
    expect(AppLanguage.normalize('English'), 'en');
    expect(AppLanguage.normalize('en'), 'en');
    expect(buildState().languageCode, 'ar');
  });

  test('language preference persists independently of temperature unit', () async {
    final MemorySettingsStore store = MemorySettingsStore();
    final AppState first = buildState(store: store);
    first.setLanguage('en');
    first.setUseFahrenheit(false);
    first.setCalculationMethodEnum(PrayerCalcMethod.ummAlQura);
    await first.flushPersistence();

    final AppState restored = buildState(store: store);
    await restored.hydrate();
    expect(restored.languageCode, 'en');
    expect(restored.useFahrenheit, isFalse);
    expect(restored.calculationMethodEnum, PrayerCalcMethod.ummAlQura);
    expect(restored.formatTemperature(10), '10°');
  });

  test('home taglines are exact in both languages', () {
    expect(
      AppLanguage.l10nOf('ar').homeTagline,
      'تقويمك .. مواقيتك .. في مكان واحد',
    );
    expect(
      AppLanguage.l10nOf('en').homeTagline,
      'Your Calendar. Your Prayer Times. All in One Place.',
    );
  });

  test('prayer names localize without changing calculation IDs', () {
    final AppCopy ar = AppCopy.forCode('ar');
    final AppCopy en = AppCopy.forCode('en');
    expect(ar.prayerName('fajr'), 'الفجر');
    expect(en.prayerName('fajr'), 'Fajr');
    expect(en.prayerName('sunrise'), 'Sunrise');
    expect(en.prayerName('dhuhr'), 'Dhuhr');
    expect(en.prayerName('asr'), 'Asr');
    expect(en.prayerName('maghrib'), 'Maghrib');
    expect(en.prayerName('isha'), 'Isha');
  });

  test('weather conditions localize from WMO codes, not string replace', () {
    final AppCopy en = AppCopy.forCode('en');
    final AppCopy ar = AppCopy.forCode('ar');
    expect(ar.weatherCondition(0, isDay: true), 'مشمس');
    expect(en.weatherCondition(0, isDay: true), 'Sunny');
    expect(en.weatherCondition(2, isDay: true), 'Partly cloudy');
    expect(en.weatherCondition(3, isDay: true), 'Cloudy');
    expect(en.weatherCondition(61, isDay: true), 'Rainy');
    expect(en.weatherCondition(45, isDay: true), 'Fog');
    expect(en.weatherCondition(0, isDay: true), isNot(ar.weatherCondition(0, isDay: true)));
  });

  test('Hijri and Gregorian month names are bilingual', () {
    final AppCopy en = AppCopy.forCode('en');
    final AppCopy ar = AppCopy.forCode('ar');
    expect(ar.hijriMonth(9), 'رمضان');
    expect(en.hijriMonth(9), 'Ramadan');
    expect(ar.gregorianMonth(9), 'سبتمبر');
    expect(en.gregorianMonth(9), 'September');
    expect(en.weekday(DateTime.friday), 'Friday');
    expect(ar.weekday(DateTime.friday), 'الجمعة');
  });

  test('events store bilingual titles structurally', () {
    const EventRepository repo = EventRepository();
    final event = repo.eventOn(DateTime(2026, 9, 23))!;
    expect(event.title, contains('اليوم الوطني السعودي'));
    expect(event.titleEn, contains('Saudi National Day'));
    expect(event.titleFor('en'), event.titleEn);
    expect(event.date, DateTime(2026, 9, 23));
    expect(event.officialHoliday, isTrue);
    expect(repo.byId('founding-day', DateTime(2026, 1, 1))!.titleEn, 'Founding Day');
    expect(repo.byId('eid-fitr', DateTime(2026, 1, 1))!.titleEn, 'Eid al-Fitr');
  });

  test('language switch rebuilds pending notifications without duplicates', () async {
    final FakeNotificationGateway gateway = FakeNotificationGateway();
    final AppState state = buildState(notifications: gateway);
    await state.resyncNotifications();
    final int firstCount = gateway.scheduled.length;
    expect(firstCount, greaterThan(0));
    expect(
      gateway.scheduled.values.any(
        (ScheduledNotification n) => n.title.contains('حان وقت صلاة'),
      ),
      isTrue,
    );

    state.setLanguage('en');
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(gateway.scheduled.length, firstCount);
    expect(
      gateway.scheduled.values.any(
        (ScheduledNotification n) => n.title.contains("It's time for"),
      ),
      isTrue,
    );
    expect(
      gateway.scheduled.values.any(
        (ScheduledNotification n) => n.title.contains('حان وقت صلاة'),
      ),
      isFalse,
    );
    expect(
      gateway.scheduled.keys.toSet().length,
      gateway.scheduled.length,
    );
  });

  test('planner English copy keeps unique ids', () {
    final times = const PrayerTimesService().calculate(
      date: DateTime(2026, 9, 7),
      latitude: 24.7136,
      longitude: 46.6753,
      timezoneId: 'Asia/Riyadh',
    );
    final List<ScheduledNotification> planned =
        const PrayerNotificationPlanner().planPrayers(
          nowUtc: DateTime.utc(2026, 9, 7, 4, 0),
          days: [times],
          prefs: const PrayerSchedulePrefs(
            masterEnabled: true,
            enabledPrayerIds: <String>{
              'fajr',
              'dhuhr',
              'asr',
              'maghrib',
              'isha',
            },
            preAlertMinutes: 10,
            eventAlerts: false,
            eventReminderIds: <String>{},
            cityName: 'Riyadh',
            languageCode: 'en',
          ),
        );
    expect(planned.map((ScheduledNotification n) => n.id).toSet().length, planned.length);
    expect(
      planned.any((ScheduledNotification n) => n.title.contains("It's time for")),
      isTrue,
    );
  });

  testWidgets('switching language immediately updates the home tagline and direction', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 3;
    tester.view.physicalSize = const Size(390, 844) * 3;
    addTearDown(tester.view.reset);

    final AppState state = buildState();
    await tester.pumpWidget(MawaqeetnaApp(state: state));
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 2900));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('السماح بتحديد الموقع'));
    await tester.pumpAndSettle();

    expect(find.text('تقويمك .. مواقيتك .. في مكان واحد'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('تقويمك .. مواقيتك .. في مكان واحد'))),
      TextDirection.rtl,
    );

    state.setLanguage('en');
    await tester.pumpAndSettle();

    expect(
      find.text('Your Calendar. Your Prayer Times. All in One Place.'),
      findsWidgets,
    );
    expect(find.text('Fajr'), findsWidgets);
    expect(
      Directionality.of(
        tester.element(
          find.text('Your Calendar. Your Prayer Times. All in One Place.').first,
        ),
      ),
      TextDirection.ltr,
    );

    state.setLanguage('ar');
    await tester.pumpAndSettle();
    expect(find.text('تقويمك .. مواقيتك .. في مكان واحد'), findsOneWidget);
  });

  testWidgets('dark mode still renders after switching to English', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 3;
    tester.view.physicalSize = const Size(390, 844) * 3;
    addTearDown(tester.view.reset);

    final AppState state = buildState();
    state.setDarkMode(true);
    state.setLanguage('en');
    await tester.pumpWidget(MawaqeetnaApp(state: state));
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 2900));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Allow location access'));
    await tester.pumpAndSettle();

    expect(state.darkMode, isTrue);
    expect(AppColors.primary, const Color(0xFF114234));
    expect(find.text('Your Calendar. Your Prayer Times. All in One Place.'), findsOneWidget);
  });
}
