import '../data/demo_data.dart';
import '../data/models.dart';
import '../l10n/app_copy.dart';
import '../l10n/app_language.dart';
import '../prayer/daily_prayer_times.dart';
import '../prayer/prayer_calc_method.dart';
import '../prayer/prayer_times_service.dart';
import 'notification_gateway.dart';
import 'notification_models.dart';

class PrayerSchedulePrefs {
  const PrayerSchedulePrefs({
    required this.masterEnabled,
    required this.enabledPrayerIds,
    required this.preAlertMinutes,
    required this.eventAlerts,
    required this.eventReminderIds,
    required this.cityName,
    this.languageCode = AppLanguage.arabic,
  });

  final bool masterEnabled;
  final Set<String> enabledPrayerIds;
  final int preAlertMinutes;
  final bool eventAlerts;
  final Set<String> eventReminderIds;
  final String cityName;
  final String languageCode;
}

class PrayerNotificationPlanner {
  const PrayerNotificationPlanner();

  static const int horizonDays = 3;

  List<ScheduledNotification> planPrayers({
    required DateTime nowUtc,
    required List<DailyPrayerTimes> days,
    required PrayerSchedulePrefs prefs,
  }) {
    if (!prefs.masterEnabled) {
      return const <ScheduledNotification>[];
    }
    final AppCopy copy = AppCopy.forCode(prefs.languageCode);
    final List<ScheduledNotification> items = <ScheduledNotification>[];
    for (int dayIndex = 0; dayIndex < days.length; dayIndex++) {
      final DailyPrayerTimes times = days[dayIndex];
      for (final PrayerTemplate template in DemoData.prayerTemplates) {
        if (!prefs.enabledPrayerIds.contains(template.id)) {
          continue;
        }
        if (!template.supportsAlert && template.id != 'sunrise') {
          continue;
        }
        final DateTime occursAt = times.timeOf(template.id);
        if (!occursAt.isAfter(nowUtc)) {
          continue;
        }
        final bool prayer = template.supportsAlert;
        final String name = copy.prayerName(template.id);
        final String longName = copy.prayerLongName(template.id);
        items.add(
          ScheduledNotification(
            id: NotificationIds.prayer(
              dayIndex: dayIndex,
              prayerId: template.id,
              reminder: false,
            ),
            fireAt: occursAt.toUtc(),
            title: prayer
                ? copy.l10n.itsTimeForPrayer(name)
                : copy.l10n.itsTimeForSunrise,
            body: prayer
                ? copy.l10n.prayerTimeBody(longName, prefs.cityName)
                : copy.l10n.sunriseBody(prefs.cityName),
            payload: NotificationPayload(
              kind: AppNotificationKind.prayer,
              prayerId: template.id,
            ),
          ),
        );
        if (prayer && prefs.preAlertMinutes > 0) {
          final DateTime reminderAt = occursAt.subtract(
            Duration(minutes: prefs.preAlertMinutes),
          );
          if (reminderAt.isAfter(nowUtc)) {
            items.add(
              ScheduledNotification(
                id: NotificationIds.prayer(
                  dayIndex: dayIndex,
                  prayerId: template.id,
                  reminder: true,
                ),
                fireAt: reminderAt.toUtc(),
                title: copy.l10n.minutesUntilPrayer(
                  prefs.preAlertMinutes,
                  name,
                ),
                body: copy.l10n.advanceReminderBody(name, prefs.cityName),
                payload: NotificationPayload(
                  kind: AppNotificationKind.prayer,
                  prayerId: template.id,
                ),
              ),
            );
          }
        }
      }
    }
    return items;
  }
}

class PrayerNotificationScheduler {
  PrayerNotificationScheduler({
    required NotificationGateway gateway,
    PrayerTimesService? prayerTimesService,
    PrayerNotificationPlanner? planner,
  }) : _gateway = gateway,
       _prayerTimes = prayerTimesService ?? const PrayerTimesService(),
       _planner = planner ?? const PrayerNotificationPlanner();

  final NotificationGateway _gateway;
  final PrayerTimesService _prayerTimes;
  final PrayerNotificationPlanner _planner;

  Future<void> reschedulePrayers({
    required DateTime nowUtc,
    required DateTime today,
    required double latitude,
    required double longitude,
    required String timezoneId,
    required PrayerSchedulePrefs prefs,
    required PrayerCalcMethod method,
  }) async {
    final List<int> pending = await _gateway.pendingIds();
    for (final int id in pending) {
      if (NotificationIds.isPrayer(id)) {
        await _gateway.cancel(id);
      }
    }
    final List<DailyPrayerTimes> days = <DailyPrayerTimes>[
      for (int i = 0; i < PrayerNotificationPlanner.horizonDays; i++)
        _prayerTimes.calculate(
          date: today.add(Duration(days: i)),
          latitude: latitude,
          longitude: longitude,
          timezoneId: timezoneId,
          method: method,
        ),
    ];
    final List<ScheduledNotification> planned = _planner.planPrayers(
      nowUtc: nowUtc,
      days: days,
      prefs: prefs,
    );
    for (final ScheduledNotification item in planned) {
      await _gateway.schedule(item);
    }
  }

  Future<DateTime> scheduleTestNotification({
    required DateTime nowUtc,
    Duration delay = const Duration(minutes: 2),
    String languageCode = AppLanguage.arabic,
  }) async {
    await _gateway.cancel(NotificationIds.test);
    final DateTime fireAt = nowUtc.add(delay);
    final AppCopy copy = AppCopy.forCode(languageCode);
    await _gateway.schedule(
      ScheduledNotification(
        id: NotificationIds.test,
        fireAt: fireAt,
        title: copy.l10n.testNotificationTitle,
        body: copy.l10n.testNotificationMessage,
        payload: const NotificationPayload(kind: AppNotificationKind.test),
      ),
    );
    return fireAt;
  }

  Future<void> scheduleEventReminder({
    required String eventId,
    required String title,
    required DateTime fireAtUtc,
    DateTime? nowUtc,
    String languageCode = AppLanguage.arabic,
  }) async {
    final int id = NotificationIds.event(eventId);
    await _gateway.cancel(id);
    final DateTime now = nowUtc ?? DateTime.now().toUtc();
    if (!fireAtUtc.isAfter(now)) {
      return;
    }
    final AppCopy copy = AppCopy.forCode(languageCode);
    await _gateway.schedule(
      ScheduledNotification(
        id: id,
        fireAt: fireAtUtc,
        title: copy.l10n.eventReminderTitle(title),
        body: copy.l10n.eventReminderBody,
        payload: NotificationPayload(
          kind: AppNotificationKind.event,
          eventId: eventId,
        ),
      ),
    );
  }

  Future<void> cancelEventReminder(String eventId) =>
      _gateway.cancel(NotificationIds.event(eventId));
}
