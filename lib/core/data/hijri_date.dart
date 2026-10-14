import 'package:general_datetime_core/general_datetime_core.dart' as umm;

/// Hijri date backed by the published Umm Al-Qura table
/// (`general_datetime_core`).
///
/// Official coverage is the verified Umm Al-Qura range (AH
/// [umm.HijriDateTime.minimumOfficialYear]–[umm.HijriDateTime.maximumOfficialYear]).
/// Dates outside that range throw and are not silently extrapolated.
class HijriDate {
  const HijriDate(this.year, this.month, this.day);

  final int year;

  /// 1 = محرم ... 12 = ذو الحجة
  final int month;
  final int day;

  static const List<String> monthNames = <String>[
    'محرم',
    'صفر',
    'ربيع الأول',
    'ربيع الآخر',
    'جمادى الأولى',
    'جمادى الآخرة',
    'رجب',
    'شعبان',
    'رمضان',
    'شوال',
    'ذو القعدة',
    'ذو الحجة',
  ];

  static HijriDate fromGregorian(DateTime date) {
    final DateTime civil = DateTime(date.year, date.month, date.day);
    final umm.HijriDateTime hijri = umm.HijriDateTime.fromDateTime(civil);
    return HijriDate(hijri.year, hijri.month, hijri.day);
  }

  /// Civil Gregorian date for this Umm Al-Qura day. Throws [RangeError] outside
  /// the published table.
  DateTime toGregorian() {
    final umm.HijriDateTime hijri = umm.HijriDateTime(year, month, day);
    final DateTime local = DateTime.fromMicrosecondsSinceEpoch(
      hijri.microsecondsSinceEpoch,
    );
    return DateTime(local.year, local.month, local.day);
  }

  static int monthLength(int year, int month) {
    final umm.HijriDateTime first = umm.HijriDateTime(year, month, 1);
    final umm.HijriDateTime next = month == 12
        ? umm.HijriDateTime(year + 1, 1, 1)
        : umm.HijriDateTime(year, month + 1, 1);
    return next.difference(first).inDays;
  }

  String get monthName => monthNames[month - 1];

  /// `15 ربيع الأول 1448 هـ`
  String get formatted => '$day $monthName $year هـ';

  /// `ربيع الأول 1448 هـ`
  String get monthFormatted => '$monthName $year هـ';

  @override
  bool operator ==(Object other) =>
      other is HijriDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);
}

/// Gregorian helpers shared by the calendar / event screens.
class GregorianLabels {
  const GregorianLabels._();

  static const List<String> months = <String>[
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  /// Index 0 = Sunday, matching the reference calendar header order.
  static const List<String> weekdays = <String>[
    'الأحد',
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  static String monthName(DateTime date) => months[date.month - 1];

  static String weekdayName(DateTime date) => weekdays[date.weekday % 7];

  /// `7 سبتمبر 2026 م`
  static String formatted(DateTime date) =>
      '${date.day} ${monthName(date)} ${date.year} م';

  /// `الأربعاء، 23 سبتمبر 2026 م`
  static String withWeekday(DateTime date) =>
      '${weekdayName(date)}، ${formatted(date)}';
}
