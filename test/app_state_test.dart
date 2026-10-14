import 'package:flutter_test/flutter_test.dart';
import 'package:islmac_app/core/location/app_location.dart';
import 'package:islmac_app/core/location/fake_location_provider.dart';
import 'package:islmac_app/core/location/location_failure.dart';
import 'package:islmac_app/core/location/location_provider.dart';
import 'package:islmac_app/core/persistence/settings_store.dart';
import 'package:islmac_app/core/prayer/prayer_calc_method.dart';
import 'package:islmac_app/core/state/app_state.dart';
import 'package:islmac_app/core/time/app_clock.dart';
import 'package:islmac_app/core/time/app_timezone.dart';

void main() {
  setUpAll(AppTimezone.ensureInitialized);

  AppState buildState({
    FakeClock? clock,
    FakeLocationProvider? location,
    SettingsStore? store,
  }) {
    return AppState(
      clock: clock ?? FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
      locationProvider: location ?? FakeLocationProvider(),
      store: store ?? MemorySettingsStore(),
    );
  }

  test('selecting a city updates prayer times immediately', () {
    final AppState state = buildState();
    final int riyadhAsr = state.prayerById('asr').minutes;
    state.selectCity('makkah');
    expect(state.location.cityName, 'مكة المكرمة');
    expect(state.prayerById('asr').minutes, isNot(riyadhAsr));
    expect(state.location.selectionMode, LocationSelectionMode.manual);
  });

  test('settings store restores the last city and method', () async {
    final MemorySettingsStore store = MemorySettingsStore();
    final AppState first = buildState(store: store);
    first.selectCity('jeddah');
    first.setCalculationMethod(PrayerCalcMethod.egyptian.label);
    await first.flushPersistence();

    final AppState restored = buildState(store: store);
    await restored.hydrate();
    expect(restored.location.catalogId, 'jeddah');
    expect(restored.calculationMethod, PrayerCalcMethod.egyptian.label);
  });

  test('denied location permission does not crash and keeps a fallback city', () async {
    final AppState state = buildState(
      location: FakeLocationProvider(permission: AppPermissionStatus.denied),
    );
    final bool ok = await state.requestCurrentLocation();
    expect(ok, isFalse);
    expect(state.locationError?.kind, LocationFailureKind.denied);
    expect(state.location.cityName, 'الرياض');
  });

  test('civil date uses the city timezone, not the device clock zone', () {
    // 21:30 UTC on 7 Sep is already 8 Sep 00:30 in Riyadh (UTC+3).
    final AppState state = buildState(
      clock: FakeClock(DateTime.utc(2026, 9, 7, 21, 30)),
    );
    expect(state.today, DateTime(2026, 9, 8));
  });

  test('day rollover at midnight refreshes dates and the next prayer', () {
    final FakeClock clock = FakeClock(DateTime.utc(2026, 9, 7, 20, 59, 50));
    final AppState state = buildState(clock: clock);
    expect(state.today, DateTime(2026, 9, 7));
    clock.add(const Duration(seconds: 15));
    state.tick();
    expect(state.today, DateTime(2026, 9, 8));
  });

  test('GPS success stores automatic coordinates', () async {
    final AppState state = buildState(
      location: FakeLocationProvider(
        fix: const GeoFix(latitude: 21.5433, longitude: 39.1728),
        place: const GeoPlace(
          cityName: 'جدة',
          countryName: 'المملكة العربية السعودية',
          isoCountryCode: 'SA',
        ),
      ),
    );
    expect(await state.requestCurrentLocation(), isTrue);
    expect(state.location.selectionMode, LocationSelectionMode.automatic);
    expect(state.location.catalogId, 'jeddah');
    expect(state.location.cityName, 'جدة');
  });
}
