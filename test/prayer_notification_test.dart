import 'package:flutter_test/flutter_test.dart';
import 'package:islmac_app/core/location/fake_location_provider.dart';
import 'package:islmac_app/core/notifications/notification_gateway.dart';
import 'package:islmac_app/core/notifications/notification_models.dart';
import 'package:islmac_app/core/notifications/prayer_notification_scheduler.dart';
import 'package:islmac_app/core/persistence/settings_store.dart';
import 'package:islmac_app/core/prayer/prayer_times_service.dart';
import 'package:islmac_app/core/state/app_state.dart';
import 'package:islmac_app/core/time/app_clock.dart';
import 'package:islmac_app/core/time/app_timezone.dart';

void main() {
  setUpAll(AppTimezone.ensureInitialized);

  test('planner uses unique ids and reminder offsets', () {
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
            enabledPrayerIds: <String>{'fajr', 'dhuhr', 'asr', 'maghrib', 'isha'},
            preAlertMinutes: 10,
            eventAlerts: false,
            eventReminderIds: <String>{},
            cityName: 'الرياض',
          ),
        );
    expect(planned.map((ScheduledNotification n) => n.id).toSet().length, planned.length);
    expect(
      planned.any((ScheduledNotification n) => n.title.startsWith('حان وقت صلاة')),
      isTrue,
    );
    expect(
      planned.any((ScheduledNotification n) => n.title.contains('تبقى 10 دقيقة')),
      isTrue,
    );
    expect(
      planned.any((ScheduledNotification n) => n.title.contains('حان وقت الصلاة') && n.title.contains('تبقى')),
      isFalse,
    );
    for (final ScheduledNotification item in planned) {
      expect(item.fireAt.isAfter(DateTime.utc(2026, 9, 7, 4, 0)), isTrue);
    }
  });

  test('changing city rebuilds the schedule and drops stale ids', () async {
    final FakeNotificationGateway gateway = FakeNotificationGateway();
    final AppState state = AppState(
      clock: FakeClock(DateTime.utc(2026, 9, 7, 4, 0)),
      locationProvider: FakeLocationProvider(),
      store: MemorySettingsStore(),
      notificationGateway: gateway,
    );
    await state.resyncNotifications();
    final int firstCount = gateway.scheduled.length;
    expect(firstCount, greaterThan(0));
    state.selectCity('jeddah');
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(gateway.scheduled.length, greaterThan(0));
  });

  test('disabling the master switch cancels prayer notifications', () async {
    final FakeNotificationGateway gateway = FakeNotificationGateway();
    final AppState state = AppState(
      clock: FakeClock(DateTime.utc(2026, 9, 7, 4, 0)),
      locationProvider: FakeLocationProvider(),
      store: MemorySettingsStore(),
      notificationGateway: gateway,
    );
    await state.resyncNotifications();
    expect(gateway.scheduled, isNotEmpty);
    state.setMasterPrayerAlerts(false);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(
      gateway.scheduled.keys.where(NotificationIds.isPrayer),
      isEmpty,
    );
  });

  test('denied permission does not crash scheduling', () async {
    final FakeNotificationGateway gateway = FakeNotificationGateway(
      permissionGranted: false,
    );
    final AppState state = AppState(
      clock: FakeClock(DateTime.utc(2026, 9, 7, 4, 0)),
      locationProvider: FakeLocationProvider(),
      store: MemorySettingsStore(),
      notificationGateway: gateway,
    );
    final bool allowed = await state.requestNotificationPermission();
    expect(allowed, isFalse);
    await state.resyncNotifications();
    expect(gateway.scheduled, isEmpty);
  });

  test('test notification uses a dedicated id', () async {
    final FakeNotificationGateway gateway = FakeNotificationGateway();
    final PrayerNotificationScheduler scheduler = PrayerNotificationScheduler(
      gateway: gateway,
    );
    final DateTime at = await scheduler.scheduleTestNotification(
      nowUtc: DateTime.utc(2026, 9, 7, 7, 0),
    );
    expect(gateway.scheduled.containsKey(NotificationIds.test), isTrue);
    expect(at.difference(DateTime.utc(2026, 9, 7, 7, 0)).inMinutes, 2);
    await scheduler.scheduleTestNotification(
      nowUtc: DateTime.utc(2026, 9, 7, 7, 5),
    );
    expect(
      gateway.scheduled.values.where((ScheduledNotification n) => n.id == NotificationIds.test),
      hasLength(1),
    );
  });
}
