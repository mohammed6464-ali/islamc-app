import 'package:flutter_test/flutter_test.dart';
import 'package:islmac_app/core/data/hijri_date.dart';
import 'package:islmac_app/core/events/event_repository.dart';
import 'package:islmac_app/core/location/fake_location_provider.dart';
import 'package:islmac_app/core/notifications/notification_gateway.dart';
import 'package:islmac_app/core/notifications/notification_models.dart';
import 'package:islmac_app/core/persistence/settings_store.dart';
import 'package:islmac_app/core/state/app_state.dart';
import 'package:islmac_app/core/time/app_clock.dart';
import 'package:islmac_app/core/time/app_timezone.dart';

void main() {
  setUpAll(AppTimezone.ensureInitialized);
  const EventRepository repo = EventRepository();

  test('Hijri conversion round-trips a known Umm Al-Qura date', () {
    final HijriDate hijri = HijriDate.fromGregorian(DateTime(2026, 9, 7));
    expect(hijri.year, 1448);
    expect(hijri.month, 3);
    final DateTime back = hijri.toGregorian();
    expect(back, DateTime(2026, 9, 7));
    expect(HijriDate.monthLength(1448, 3), anyOf(29, 30));
    expect(DateTime(2026, 9, 7).weekday, DateTime.monday);
  });

  test('upcoming events are chronological and include Saudi occasions', () {
    final events = repo.upcoming(DateTime(2026, 9, 7));
    expect(events, isNotEmpty);
    for (int i = 1; i < events.length; i++) {
      expect(events[i].date.isBefore(events[i - 1].date), isFalse);
    }
    expect(events.first.title, contains('اليوم الوطني السعودي 96'));
    expect(repo.eventOn(DateTime(2026, 9, 23))?.id, 'national-day');
    expect(repo.byId('founding-day', DateTime(2026, 1, 1))?.date.month, 2);
    expect(repo.byId('flag-day', DateTime(2026, 3, 1))?.officialHoliday, isFalse);
  });

  test('days remaining uses the city civil date', () {
    final AppState state = AppState(
      clock: FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
      locationProvider: FakeLocationProvider(),
      store: MemorySettingsStore(),
    );
    expect(state.daysUntil(DateTime(2026, 9, 23)), 16);
  });

  test('favorites persist', () async {
    final MemorySettingsStore store = MemorySettingsStore();
    final AppState first = AppState(
      clock: FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
      locationProvider: FakeLocationProvider(),
      store: store,
    );
    expect(first.toggleFavoriteEvent('national-day'), isTrue);
    await first.flushPersistence();
    final AppState restored = AppState(
      clock: FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
      locationProvider: FakeLocationProvider(),
      store: store,
    );
    await restored.hydrate();
    expect(restored.isFavoriteEvent('national-day'), isTrue);
  });

  test('event reminder uses a separate notification id range', () async {
    final FakeNotificationGateway gateway = FakeNotificationGateway();
    final AppState state = AppState(
      clock: FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
      locationProvider: FakeLocationProvider(),
      store: MemorySettingsStore(),
      notificationGateway: gateway,
    );
    state.setEventPreAlert('national-day', true);
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(
      gateway.scheduled.keys.any(NotificationIds.isEvent),
      isTrue,
    );
  });

  test('payload routing encodes prayer and event targets', () {
    const NotificationPayload prayer = NotificationPayload(
      kind: AppNotificationKind.prayer,
      prayerId: 'dhuhr',
    );
    expect(NotificationPayload.tryParse(prayer.encode())?.prayerId, 'dhuhr');
    const NotificationPayload event = NotificationPayload(
      kind: AppNotificationKind.event,
      eventId: 'national-day',
    );
    expect(NotificationPayload.tryParse(event.encode())?.eventId, 'national-day');
  });
}
