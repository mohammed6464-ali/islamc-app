/// Lightweight Hijri conversion for the demo content.
///
/// It is anchored on the single mapping the reference screens state
/// (7 September 2026 = 15 Rabi' al-Awwal 1448) and uses the classic
/// alternating 30/29 month pattern. Good enough for a demo calendar, and it
/// keeps every screen showing the same pair of dates.
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

  static const List<int> _monthLengths = <int>[
    30,
    29,
    30,
    29,
    30,
    29,
    30,
    29,
    30,
    29,
    30,
    29,
  ];

  static const int _yearLength = 354;

  /// 1 Rabi' al-Awwal 1448 — derived from the reference mapping above.
  static final DateTime _anchor = DateTime(2026, 8, 24);
  static const int _anchorYear = 1448;

  /// Days elapsed inside year 1448 before 1 Rabi' al-Awwal (30 + 29).
  static const int _anchorDayOfYear = 59;

  static HijriDate fromGregorian(DateTime date) {
    final DateTime day = DateTime(date.year, date.month, date.day);
    final int total = _anchorDayOfYear + day.difference(_anchor).inDays;
    final int years = (total / _yearLength).floor();
    int remainder = total - years * _yearLength;
    int month = 0;
    while (remainder >= _monthLengths[month]) {
      remainder -= _monthLengths[month];
      month++;
    }
    return HijriDate(_anchorYear + years, month + 1, remainder + 1);
  }

  static int monthLength(int month) => _monthLengths[month - 1];

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
