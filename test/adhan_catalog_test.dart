import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islmac_app/core/adhan/adhan_audio_catalog.dart';
import 'package:islmac_app/core/adhan/adhan_audio_service.dart';
import 'package:islmac_app/core/location/fake_location_provider.dart';
import 'package:islmac_app/core/persistence/settings_store.dart';
import 'package:islmac_app/core/state/app_state.dart';
import 'package:islmac_app/core/time/app_clock.dart';
import 'package:islmac_app/core/time/app_timezone.dart';

void main() {
  const AdhanAudioCatalog catalog = AdhanAudioCatalog();

  test('all four bundled adhan files exist on disk', () {
    for (final String asset in AdhanAudioCatalog.allAssets) {
      expect(File(asset).existsSync(), isTrue, reason: asset);
    }
  });

  test('maps mosque and prayer type to the exact recordings', () {
    expect(
      catalog.assetFor(mosque: AdhanMosque.makkah, type: AdhanAudioType.fajr),
      AdhanAudioCatalog.makkahFajr,
    );
    expect(
      catalog.assetFor(
        mosque: AdhanMosque.makkah,
        type: AdhanAudioType.regular,
      ),
      AdhanAudioCatalog.makkahRegular,
    );
    expect(
      catalog.assetFor(mosque: AdhanMosque.madinah, type: AdhanAudioType.fajr),
      AdhanAudioCatalog.madinahFajr,
    );
    expect(
      catalog.assetFor(
        mosque: AdhanMosque.madinah,
        type: AdhanAudioType.regular,
      ),
      AdhanAudioCatalog.madinahRegular,
    );
    expect(catalog.typeForPrayer('fajr'), AdhanAudioType.fajr);
    expect(catalog.typeForPrayer('dhuhr'), AdhanAudioType.regular);
  });

  test('fake player stops overlapping playback and reports errors', () async {
    final FakeAdhanAudioService audio = FakeAdhanAudioService(
      failAsset: AdhanAudioCatalog.makkahFajr,
    );
    await audio.play(mosque: AdhanMosque.madinah, type: AdhanAudioType.regular);
    expect(audio.isPlaying, isTrue);
    await audio.play(mosque: AdhanMosque.makkah, type: AdhanAudioType.fajr);
    expect(audio.playbackState, AdhanPlaybackState.error);
    expect(audio.playCount, 2);
    await audio.stop();
    expect(audio.playbackState, AdhanPlaybackState.idle);
  });

  test('selected mosque persists', () async {
    AppTimezone.ensureInitialized();
    final MemorySettingsStore store = MemorySettingsStore();
    final AppState first = AppState(
      clock: FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
      locationProvider: FakeLocationProvider(),
      store: store,
    );
    first.setAdhanMosque(AdhanMosque.madinah);
    await first.flushPersistence();
    final AppState restored = AppState(
      clock: FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
      locationProvider: FakeLocationProvider(),
      store: store,
    );
    await restored.hydrate();
    expect(restored.adhanMosque, AdhanMosque.madinah);
    expect(restored.adhanSound, 'أذان المسجد النبوي');
  });

  test('pubspec registers the audio directory', () {
    final String yaml = File('pubspec.yaml').readAsStringSync();
    expect(yaml.contains('assets/audio/'), isTrue);
  });

  testWidgets('assets are registered with Flutter', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    for (final String asset in AdhanAudioCatalog.allAssets) {
      expect(await rootBundle.load(asset), isA<ByteData>());
    }
  });
}
