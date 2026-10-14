import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islmac_app/core/adhan/adhan_audio_catalog.dart';
import 'package:islmac_app/core/data/demo_data.dart';
import 'package:islmac_app/core/legal/app_legal.dart';
import 'package:islmac_app/core/location/fake_location_provider.dart';
import 'package:islmac_app/core/notifications/notification_gateway.dart';
import 'package:islmac_app/core/notifications/notification_models.dart';
import 'package:islmac_app/core/persistence/settings_store.dart';
import 'package:islmac_app/core/state/app_state.dart';
import 'package:islmac_app/core/theme/app_colors.dart';
import 'package:islmac_app/core/time/app_clock.dart';
import 'package:islmac_app/core/time/app_timezone.dart';

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

  test('official brand HEX values are exact', () {
    expect(AppColors.primary, const Color(0xFF114234));
    expect(AppColors.darkGreen, const Color(0xFF0C3D2E));
    expect(AppColors.accentGreen, const Color(0xFF086348));
    expect(AppColors.lightMint, const Color(0xFFD1E7DF));
  });

  test('home tagline source of truth', () {
    expect(DemoData.greeting, AppLegal.tagline);
    expect(DemoData.greeting, 'تقويمك .. مواقيتك .. في مكان واحد');
  });

  test('temperature unit, calendar, theme and mosque persist', () async {
    final MemorySettingsStore store = MemorySettingsStore();
    final AppState first = buildState(store: store);
    first.setUseFahrenheit(true);
    first.setHijriView(true);
    first.setDarkMode(true);
    first.setAdhanMosque(AdhanMosque.madinah);
    await first.flushPersistence();

    final AppState restored = buildState(store: store);
    await restored.hydrate();
    expect(restored.useFahrenheit, isTrue);
    expect(restored.hijriView, isTrue);
    expect(restored.darkMode, isTrue);
    expect(restored.adhanMosque, AdhanMosque.madinah);
    expect(restored.formatTemperature(10), '50°');
  });

  test('city change updates prayer times and rebuilds notifications', () async {
    final FakeNotificationGateway gateway = FakeNotificationGateway();
    final AppState state = buildState(notifications: gateway);
    await state.resyncNotifications();
    final int riyadhAsr = state.prayerById('asr').minutes;
    state.selectCity('makkah');
    await Future<void>.delayed(const Duration(milliseconds: 40));
    expect(state.prayerById('asr').minutes, isNot(riyadhAsr));
    expect(
      gateway.scheduled.values.any(
        (ScheduledNotification item) => item.body.contains('مكة'),
      ),
      isTrue,
    );
  });

  test('fajr uses a different recording than other prayers', () {
    const AdhanAudioCatalog catalog = AdhanAudioCatalog();
    expect(
      catalog.assetFor(mosque: AdhanMosque.makkah, type: AdhanAudioType.fajr),
      isNot(
        catalog.assetFor(
          mosque: AdhanMosque.makkah,
          type: AdhanAudioType.regular,
        ),
      ),
    );
  });
}
