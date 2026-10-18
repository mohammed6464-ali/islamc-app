import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islmac_app/features/settings/presentation/legal_document_screen.dart';
import 'package:islmac_app/l10n/app_localizations.dart';

Widget _wrap(Widget home, {Locale locale = const Locale('ar')}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: home,
  );
}

void main() {
  testWidgets('privacy policy shows on-device sections in Arabic', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_wrap(const PrivacyPolicyScreen()));
    await tester.pumpAndSettle();

    expect(find.text('سياسة الخصوصية'), findsWidgets);
    expect(find.text('البيانات على جهازك'), findsOneWidget);
    expect(find.textContaining('لا نطلب إنشاء حساب'), findsOneWidget);
  });

  testWidgets('terms show prayer-time disclaimer in English', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const TermsScreen(), locale: const Locale('en')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Terms and conditions'), findsWidgets);
    expect(find.text('Prayer times'), findsOneWidget);
    expect(find.textContaining('not a fatwa'), findsOneWidget);
  });
}
