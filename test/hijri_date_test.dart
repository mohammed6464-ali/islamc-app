import 'package:flutter_test/flutter_test.dart';
import 'package:islmac_app/core/data/hijri_date.dart';

void main() {
  test('Umm Al-Qura maps 7 Sep 2026 into Rabi al-Awwal 1448', () {
    final HijriDate hijri = HijriDate.fromGregorian(DateTime(2026, 9, 7));
    expect(hijri.year, 1448);
    expect(hijri.month, 3);
    expect(hijri.monthName, 'ربيع الأول');
  });

  test('Gregorian weekday labels stay Sunday-indexed', () {
    expect(GregorianLabels.weekdayName(DateTime(2026, 9, 7)), 'الإثنين');
  });
}
