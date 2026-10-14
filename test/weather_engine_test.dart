import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:islmac_app/core/data/demo_data.dart';
import 'package:islmac_app/core/data/models.dart';
import 'package:islmac_app/core/location/fake_location_provider.dart';
import 'package:islmac_app/core/persistence/settings_store.dart';
import 'package:islmac_app/core/state/app_state.dart';
import 'package:islmac_app/core/time/app_clock.dart';
import 'package:islmac_app/core/time/app_timezone.dart';
import 'package:islmac_app/core/weather/fake_weather_repository.dart';
import 'package:islmac_app/core/weather/open_meteo_parser.dart';
import 'package:islmac_app/core/weather/open_meteo_weather_repository.dart';
import 'package:islmac_app/core/weather/weather_api_service.dart';
import 'package:islmac_app/core/weather/weather_cache_service.dart';
import 'package:islmac_app/core/weather/weather_condition_mapper.dart';
import 'package:islmac_app/core/weather/weather_snapshot.dart';

const Map<String, Object?> _sampleForecast = <String, Object?>{
  'latitude': 24.71,
  'longitude': 46.67,
  'timezone': 'Asia/Riyadh',
  'current': <String, Object?>{
    'time': '2026-09-07T10:00',
    'temperature_2m': 32.4,
    'relative_humidity_2m': 45,
    'apparent_temperature': 34.1,
    'is_day': 1,
    'weather_code': 2,
    'cloud_cover': 35,
    'wind_speed_10m': 12.2,
    'wind_direction_10m': 45,
    'uv_index': 6.2,
  },
  'daily': <String, Object?>{
    'time': <String>[
      '2026-09-07',
      '2026-09-08',
      '2026-09-09',
      '2026-09-10',
      '2026-09-11',
    ],
    'weather_code': <int>[2, 0, 3, 61, 95],
    'temperature_2m_max': <double>[36, 37, 34, 31, 30],
    'temperature_2m_min': <double>[24, 25, 23, 22, 21],
    'uv_index_max': <double>[8, 9, 6, 4, 3],
  },
};

void main() {
  setUpAll(AppTimezone.ensureInitialized);

  group('Open-Meteo parser', () {
    test('parses current weather and a five-day forecast', () {
      final WeatherSnapshot snapshot = const OpenMeteoParser().parse(
        _sampleForecast,
        latitude: 24.7136,
        longitude: 46.6753,
        timezoneId: 'Asia/Riyadh',
        today: DateTime(2026, 9, 7),
        fetchedAt: DateTime.utc(2026, 9, 7, 7),
      );
      expect(snapshot.data.temperature, 32);
      expect(snapshot.data.feelsLike, 34);
      expect(snapshot.data.humidity, 45);
      expect(snapshot.data.windSpeed, 12);
      expect(snapshot.data.cloudCover, 35);
      expect(snapshot.data.uvIndex, 6);
      expect(snapshot.data.condition, 'غائم جزئيًا');
      expect(snapshot.data.forecast, hasLength(5));
      expect(snapshot.data.forecast.first.isToday, isTrue);
      expect(snapshot.data.forecast.first.day, contains('اليوم'));
      expect(snapshot.data.forecast[3].description, 'ممطر');
      expect(snapshot.data.forecast[4].description, 'عواصف رعدية');
    });

    test('throws on missing current fields', () {
      expect(
        () => const OpenMeteoParser().parse(
          <String, Object?>{'daily': <String, Object?>{}},
          latitude: 24,
          longitude: 46,
          timezoneId: 'Asia/Riyadh',
          today: DateTime(2026, 9, 7),
          fetchedAt: DateTime.utc(2026, 9, 7),
        ),
        throwsA(isA<WeatherFailure>()),
      );
    });
  });

  group('condition mapper', () {
    const WeatherConditionMapper mapper = WeatherConditionMapper();

    test('maps official WMO codes to Arabic labels', () {
      expect(mapper.map(0, isDay: true).labelAr, 'مشمس');
      expect(mapper.map(0, isDay: false).labelAr, 'صافٍ ليلاً');
      expect(mapper.map(2, isDay: true).labelAr, 'غائم جزئيًا');
      expect(mapper.map(3, isDay: true).labelAr, 'غائم');
      expect(mapper.map(45, isDay: true).labelAr, 'ضباب');
      expect(mapper.map(61, isDay: true).labelAr, 'ممطر');
      expect(mapper.map(71, isDay: true).labelAr, 'ثلوج');
      expect(mapper.map(95, isDay: true).labelAr, 'عواصف رعدية');
    });
  });

  group('cache and API', () {
    test('reuses a fresh cache and falls back after an API failure', () async {
      int calls = 0;
      final MemoryWeatherCache cache = MemoryWeatherCache();
      final OpenMeteoWeatherRepository repo = OpenMeteoWeatherRepository(
        api: WeatherApiService(
          get: (Uri uri) async {
            calls += 1;
            if (calls == 1) {
              return http.Response(jsonEncode(_sampleForecast), 200);
            }
            return http.Response('nope', 500);
          },
        ),
        cache: cache,
        nowUtc: () => DateTime.utc(2026, 9, 7, 8),
      );

      final WeatherSnapshot first = await repo.fetch(
        latitude: 24.7136,
        longitude: 46.6753,
        timezoneId: 'Asia/Riyadh',
        today: DateTime(2026, 9, 7),
      );
      expect(first.data.temperature, 32);
      expect(first.isFromCache, isFalse);

      final WeatherSnapshot cached = await repo.fetch(
        latitude: 24.7136,
        longitude: 46.6753,
        timezoneId: 'Asia/Riyadh',
        today: DateTime(2026, 9, 7),
      );
      expect(cached.isFromCache, isTrue);
      expect(calls, 1);

      final WeatherSnapshot fallback = await repo.fetch(
        latitude: 24.7136,
        longitude: 46.6753,
        timezoneId: 'Asia/Riyadh',
        today: DateTime(2026, 9, 7),
        forceRefresh: true,
      );
      expect(fallback.isFromCache, isTrue);
      expect(fallback.data.temperature, 32);
      expect(calls, 2);
    });

    test('cache keys do not mix different cities', () async {
      final MemoryWeatherCache cache = MemoryWeatherCache();
      await cache.write(
        WeatherSnapshot.cacheKey(24.71, 46.68),
        WeatherSnapshot(
          latitude: 24.71,
          longitude: 46.68,
          timezoneId: 'Asia/Riyadh',
          fetchedAt: DateTime.utc(2026, 9, 7),
          data: DemoData.weatherFor(DemoData.riyadh),
        ),
      );
      expect(
        await cache.read(WeatherSnapshot.cacheKey(21.54, 39.17)),
        isNull,
      );
    });

    test('maps HTTP failures to typed errors', () async {
      final WeatherApiService api = WeatherApiService(
        get: (Uri uri) async => http.Response('{}', 503),
      );
      expect(
        () => api.fetchForecast(
          latitude: 24,
          longitude: 46,
          timezoneId: 'Asia/Riyadh',
        ),
        throwsA(WeatherFailure.unavailable),
      );
    });

    test('maps invalid JSON to a parse failure', () async {
      final WeatherApiService api = WeatherApiService(
        get: (Uri uri) async => http.Response('not-json', 200),
      );
      expect(
        () => api.fetchForecast(
          latitude: 24,
          longitude: 46,
          timezoneId: 'Asia/Riyadh',
        ),
        throwsA(WeatherFailure.parse),
      );
    });
  });

  group('app state weather', () {
    test('temperature conversion does not drop weather data', () async {
      final FakeWeatherRepository repo = FakeWeatherRepository();
      final AppState state = AppState(
        clock: FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
        locationProvider: FakeLocationProvider(),
        store: MemorySettingsStore(),
        weatherRepository: repo,
      );
      await state.refreshWeather();
      final int celsius = state.weather.temperature;
      state.setUseFahrenheit(true);
      expect(state.convertTemperature(celsius), (celsius * 9 / 5 + 32).round());
      expect(state.weather.temperature, celsius);
      expect(state.location.cityName, 'الرياض');
    });

    test('changing city refetches that city and ignores a stale response', () async {
      final FakeWeatherRepository repo = FakeWeatherRepository(
        delay: const Duration(milliseconds: 40),
      );
      final AppState state = AppState(
        clock: FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
        locationProvider: FakeLocationProvider(),
        store: MemorySettingsStore(),
        weatherRepository: repo,
      );
      state.selectCity('jeddah');
      state.selectCity('makkah');
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(state.location.cityName, 'مكة المكرمة');
      expect(
        state.weather.condition,
        DemoData.weatherFor(DemoData.cityById('makkah')).condition,
      );
      expect(repo.requestedKeys.last, contains('21.42'));
    });

    test('refresh ignores a second concurrent request', () async {
      final FakeWeatherRepository repo = FakeWeatherRepository(
        delay: const Duration(milliseconds: 80),
      );
      final AppState state = AppState(
        clock: FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
        locationProvider: FakeLocationProvider(),
        store: MemorySettingsStore(),
        weatherRepository: repo,
      );
      final Future<bool> first = state.refreshWeather();
      final bool ignored = await state.refreshWeather();
      expect(ignored, isFalse);
      await first;
      expect(repo.fetchCount, 1);
    });

    test('keeps last weather and prayer state when the API fails', () async {
      final FakeWeatherRepository repo = FakeWeatherRepository();
      final AppState state = AppState(
        clock: FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
        locationProvider: FakeLocationProvider(),
        store: MemorySettingsStore(),
        weatherRepository: repo,
      );
      await state.refreshWeather();
      final WeatherData previous = state.weather;
      final String nextPrayer = state.nextPrayer.name;
      repo.failure = WeatherFailure.offline;
      final bool ok = await state.refreshWeather();
      expect(ok, isFalse);
      expect(state.weatherError, WeatherFailure.offline.messageAr);
      expect(state.weather.temperature, previous.temperature);
      expect(state.nextPrayer.name, nextPrayer);
    });
  });
}
