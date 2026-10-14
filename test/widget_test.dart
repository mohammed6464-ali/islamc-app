import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:islmac_app/core/location/fake_location_provider.dart';
import 'package:islmac_app/core/location/location_failure.dart';
import 'package:islmac_app/core/persistence/settings_store.dart';
import 'package:islmac_app/core/state/app_state.dart';
import 'package:islmac_app/core/time/app_clock.dart';
import 'package:islmac_app/core/time/app_timezone.dart';
import 'package:islmac_app/features/home/presentation/widgets/next_prayer_card.dart';
import 'package:islmac_app/main.dart';

/// The bundled Arabic family has to be loaded explicitly, otherwise the test
/// font measures every glyph as a square and layout assertions are meaningless.
Future<void> _loadAppFonts() async {
  final FontLoader loader = FontLoader('IBMPlexSansArabic');
  for (final String weight in <String>[
    'Regular',
    'Medium',
    'SemiBold',
    'Bold',
  ]) {
    loader.addFont(
      rootBundle.load('assets/fonts/IBMPlexSansArabic-$weight.ttf'),
    );
  }
  await loader.load();
}

/// Runs the splash sequence (2900ms) plus the 250ms hold and the transition.
Future<void> _runSplash(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 16));
  await tester.pump(const Duration(milliseconds: 2900));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle();
}

Future<AppState> _pumpApp(
  WidgetTester tester, {
  FakeLocationProvider? location,
  SettingsStore? store,
}) async {
  AppTimezone.ensureInitialized();
  final AppState state = AppState(
    clock: FakeClock(DateTime.utc(2026, 9, 7, 7, 27, 24)),
    locationProvider: location ?? FakeLocationProvider(),
    store: store ?? MemorySettingsStore(),
  );
  await tester.pumpWidget(MawaqeetnaApp(state: state));
  return state;
}

/// Splash → permission → shell.
Future<AppState> _openShell(WidgetTester tester) async {
  final AppState state = await _pumpApp(tester);
  await _runSplash(tester);
  await tester.tap(find.text('السماح بتحديد الموقع'));
  await tester.pumpAndSettle();
  return state;
}

void _useScreenSize(WidgetTester tester, Size logicalSize) {
  tester.view.devicePixelRatio = 3;
  tester.view.physicalSize = logicalSize * 3;
  addTearDown(tester.view.reset);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _loadAppFonts();
  });

  testWidgets('splash -> location -> home flow', (WidgetTester tester) async {
    _useScreenSize(tester, const Size(390, 844));
    await _pumpApp(tester);

    expect(find.text('تقويم ومواقيت'), findsOneWidget);
    expect(find.text('معك في كل وقت'), findsOneWidget);

    await _runSplash(tester);

    // Reached automatically, and the splash route is gone for good.
    expect(find.text('تقويم ومواقيت'), findsNothing);
    expect(find.text('حدد موقعك'), findsOneWidget);

    await tester.tap(find.text('السماح بتحديد الموقع'));
    await tester.pumpAndSettle();

    expect(find.text('حدد موقعك'), findsNothing);
    expect(find.text('تقويمك .. مواقيتك .. في مكان واحد'), findsOneWidget);
    expect(find.text('صلاة الظهر'), findsOneWidget);
    expect(find.text('مواقيت صلاة اليوم'), findsOneWidget);

    await tester.drag(find.byType(ListView).first, const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('اليوم الوطني السعودي 96'), findsOneWidget);
    expect(find.text('زاوية القبلة'), findsOneWidget);
  });

  testWidgets('bottom navigation switches tabs without stacking routes', (
    WidgetTester tester,
  ) async {
    _useScreenSize(tester, const Size(390, 844));
    await _openShell(tester);

    await tester.tap(find.text('الطقس').last);
    await tester.pumpAndSettle();
    expect(find.text('مؤشرات الطقس الآن'), findsOneWidget);

    await tester.tap(find.text('التقويم').last);
    await tester.pumpAndSettle();
    expect(find.text('المناسبات القادمة'), findsOneWidget);

    await tester.tap(find.text('الإعدادات').last);
    await tester.pumpAndSettle();
    expect(find.text('الصلاة والتنبيهات'), findsOneWidget);

    await tester.tap(find.text('الرئيسية').last);
    await tester.pumpAndSettle();
    expect(find.text('تقويمك .. مواقيتك .. في مكان واحد'), findsOneWidget);
  });

  testWidgets('home opens the prayer times screen and its alert settings', (
    WidgetTester tester,
  ) async {
    _useScreenSize(tester, const Size(390, 844));
    await _openShell(tester);

    await tester.tap(find.text('مواقيت صلاة اليوم'));
    await tester.pumpAndSettle();
    expect(find.text('مواقيت الصلاة'), findsOneWidget);

    await tester.tap(find.text('إعدادات تنبيهات الصلاة'));
    await tester.pumpAndSettle();
    expect(find.text('تفعيل تنبيهات الصلوات كافة'), findsOneWidget);

    await tester.tap(find.byTooltip('رجوع'));
    await tester.pumpAndSettle();
    expect(find.text('مواقيت الصلاة'), findsOneWidget);
  });

  testWidgets('the next prayer hero card opens the prayer times screen', (
    WidgetTester tester,
  ) async {
    _useScreenSize(tester, const Size(390, 844));
    await _openShell(tester);

    await tester.tap(find.byType(NextPrayerCard));
    await tester.pumpAndSettle();
    expect(find.text('مواقيت الصلاة'), findsOneWidget);
  });

  testWidgets('changing the city updates every screen', (
    WidgetTester tester,
  ) async {
    _useScreenSize(tester, const Size(390, 844));
    final AppState state = await _openShell(tester);

    expect(state.city.name, 'الرياض');
    final String riyadhAsr = state.prayerById('asr').timeWithPeriod;

    state.selectCity('makkah');
    await tester.pumpAndSettle();

    expect(state.prayerById('asr').timeWithPeriod, isNot(riyadhAsr));
    expect(find.text('مكة المكرمة، المملكة العربية السعودية'), findsWidgets);

    await tester.tap(find.text('الطقس').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('مكة المكرمة'), findsWidgets);
  });

  testWidgets('denying location permission keeps the user on the picker', (
    WidgetTester tester,
  ) async {
    _useScreenSize(tester, const Size(390, 844));
    await _pumpApp(
      tester,
      location: FakeLocationProvider(permission: AppPermissionStatus.denied),
    );
    await _runSplash(tester);
    await tester.tap(find.text('السماح بتحديد الموقع'));
    await tester.pumpAndSettle();
    expect(find.text('حدد موقعك'), findsOneWidget);
    expect(find.textContaining('يمكنك اختيار المدينة يدويًا'), findsWidgets);
  });

  testWidgets('qibla screen renders the computed bearing', (
    WidgetTester tester,
  ) async {
    _useScreenSize(tester, const Size(390, 844));
    final AppState state = await _openShell(tester);

    await tester.tap(find.text('اتجاه القبلة').first);
    await tester.pumpAndSettle();

    expect(find.text(state.city.qiblaLabel), findsOneWidget);
    expect(find.textContaining('دقة البوصلة:'), findsOneWidget);
  });

  for (final Size size in <Size>[
    const Size(320, 568),
    const Size(360, 640),
    const Size(430, 932),
  ]) {
    testWidgets('no overflow on ${size.width.toInt()}x${size.height.toInt()}', (
      WidgetTester tester,
    ) async {
      _useScreenSize(tester, size);

      await _pumpApp(tester);
      expect(tester.takeException(), isNull);

      await _runSplash(tester);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('السماح بتحديد الموقع'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Only the selected destination is laid out, so each tab is visited.
      for (final String tab in <String>[
        'الرئيسية',
        'الطقس',
        'التقويم',
        'الإعدادات',
      ]) {
        await tester.tap(find.text(tab).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);

        await tester.drag(
          find.byType(ListView).hitTestable().first,
          const Offset(0, -900),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  }
}
