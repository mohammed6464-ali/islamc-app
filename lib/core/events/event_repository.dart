import 'package:flutter/material.dart';

import '../data/hijri_date.dart';
import '../data/models.dart';

class EventRepository {
  const EventRepository();

  List<IslamicEvent> upcoming(DateTime from, {int limit = 8}) {
    final DateTime origin = DateTime(from.year, from.month, from.day);
    final List<IslamicEvent> events =
        allForRange(origin)
            .where((IslamicEvent event) => !event.date.isBefore(origin))
            .toList()
          ..sort((IslamicEvent a, IslamicEvent b) => a.date.compareTo(b.date));
    final Set<String> seen = <String>{};
    final List<IslamicEvent> unique = <IslamicEvent>[
      for (final IslamicEvent event in events)
        if (seen.add(event.id)) event,
    ];
    if (unique.length <= limit) {
      return unique;
    }
    return unique.take(limit).toList(growable: false);
  }

  IslamicEvent? featured(DateTime from) {
    final List<IslamicEvent> events = upcoming(from, limit: 1);
    return events.isEmpty ? null : events.first;
  }

  IslamicEvent? eventOn(DateTime date) {
    final DateTime civil = DateTime(date.year, date.month, date.day);
    for (final IslamicEvent event in allForRange(civil)) {
      if (event.date.year == civil.year &&
          event.date.month == civil.month &&
          event.date.day == civil.day) {
        return event;
      }
    }
    return null;
  }

  IslamicEvent? byId(String id, DateTime from) {
    IslamicEvent? past;
    for (final IslamicEvent event in upcoming(from, limit: 20)) {
      if (event.id == id) {
        return event;
      }
    }
    for (final IslamicEvent event in allForRange(from)) {
      if (event.id == id) {
        past ??= event;
      }
    }
    return past;
  }

  List<IslamicEvent> allForRange(DateTime from) {
    final int year = from.year;
    final HijriDate hijri = HijriDate.fromGregorian(from);
    return <IslamicEvent>[
      _nationalDay(year),
      _nationalDay(year + 1),
      _foundingDay(year),
      _foundingDay(year + 1),
      _flagDay(year),
      _flagDay(year + 1),
      ..._islamicYear(hijri.year),
      ..._islamicYear(hijri.year + 1),
    ];
  }

  IslamicEvent _nationalDay(int gregorianYear) {
    final int n = gregorianYear - 1930;
    return IslamicEvent(
      id: 'national-day',
      title: 'اليوم الوطني السعودي $n',
      titleEn: 'Saudi National Day $n',
      date: DateTime(gregorianYear, 9, 23),
      kind: EventKind.national,
      icon: Icons.flag_outlined,
      badge: 'مناسبة وطنية',
      badgeEn: 'National occasion',
      note: 'إجازة رسمية لجميع القطاعات',
      noteEn: 'Official holiday for all sectors',
      actionLabel: 'التفاصيل',
      actionLabelEn: 'Details',
      tagline: 'نحلم ونحقق • مجد وعز وسؤدد يعانق السماء',
      taglineEn: 'We dream and we achieve • Glory and pride reaching the sky',
      ownerBadge: 'المملكة العربية السعودية',
      ownerBadgeEn: 'Saudi Arabia',
      statusPills: const <String>['مناسبة وطنية رسمية', 'إجازة رسمية'],
      statusPillsEn: const <String>[
        'Official national occasion',
        'Official holiday',
      ],
      description:
          'يوم توحيد المملكة العربية السعودية على يد الملك عبد العزيز بن '
          'عبد الرحمن آل سعود رحمه الله. يحتفي به الوطن في 23 سبتمبر من كل '
          'عام بمشاعر الفخر والاعتزاز.',
      descriptionEn:
          'The day the Kingdom of Saudi Arabia was unified by King Abdulaziz '
          'bin Abdulrahman Al Saud, may God have mercy on him. The nation '
          'celebrates it every 23 September with pride.',
      highlight:
          'تقام فيه الفعاليات الوطنية، العروض الجوية، والبرامج الثقافية في '
          'مختلف مناطق المملكة.',
      highlightEn:
          'National events, air shows, and cultural programs are held across '
          'the Kingdom.',
      officialHoliday: true,
      holidayVerified: true,
      dateSource: 'تاريخ ميلادي ثابت (23 سبتمبر)',
      dateSourceEn: 'Fixed Gregorian date (23 September)',
    );
  }

  IslamicEvent _foundingDay(int gregorianYear) {
    return IslamicEvent(
      id: 'founding-day',
      title: 'يوم التأسيس',
      titleEn: 'Founding Day',
      date: DateTime(gregorianYear, 2, 22),
      kind: EventKind.national,
      icon: Icons.account_balance_outlined,
      badge: 'مناسبة وطنية',
      badgeEn: 'National occasion',
      note: 'إجازة رسمية ليوم التأسيس',
      noteEn: 'Official Founding Day holiday',
      actionLabel: 'التفاصيل',
      actionLabelEn: 'Details',
      tagline: 'ذكرى تأسيس الدولة السعودية الأولى عام 1727م',
      taglineEn:
          'Commemoration of the founding of the first Saudi state in 1727 CE',
      ownerBadge: 'المملكة العربية السعودية',
      ownerBadgeEn: 'Saudi Arabia',
      statusPills: const <String>['مناسبة وطنية رسمية', 'إجازة رسمية'],
      statusPillsEn: const <String>[
        'Official national occasion',
        'Official holiday',
      ],
      description:
          'يوافق 22 فبراير من كل عام، ويحتفي بتأسيس الدولة السعودية الأولى '
          'على يد الإمام محمد بن سعود عام 1727م.',
      descriptionEn:
          'Observed on 22 February each year, it commemorates the founding of '
          'the first Saudi state by Imam Muhammad bin Saud in 1727 CE.',
      highlight: 'تاريخ ميلادي ثابت معتمد كإجازة رسمية.',
      highlightEn: 'A fixed Gregorian date recognized as an official holiday.',
      officialHoliday: true,
      holidayVerified: true,
      dateSource: 'تاريخ ميلادي ثابت (22 فبراير)',
      dateSourceEn: 'Fixed Gregorian date (22 February)',
    );
  }

  IslamicEvent _flagDay(int gregorianYear) {
    return IslamicEvent(
      id: 'flag-day',
      title: 'يوم العلم',
      titleEn: 'Flag Day',
      date: DateTime(gregorianYear, 3, 11),
      kind: EventKind.national,
      icon: Icons.flag_outlined,
      badge: 'مناسبة وطنية',
      badgeEn: 'National occasion',
      note: 'مناسبة وطنية وليست إجازة عامة',
      noteEn: 'National occasion, not a public holiday',
      actionLabel: 'التفاصيل',
      actionLabelEn: 'Details',
      tagline: 'يوم رفع العلم السعودي والاعتزاز برمزه',
      taglineEn: 'A day to raise the Saudi flag and honor its symbol',
      ownerBadge: 'المملكة العربية السعودية',
      ownerBadgeEn: 'Saudi Arabia',
      statusPills: const <String>['مناسبة وطنية', 'يوم عمل رسمي'],
      statusPillsEn: const <String>['National occasion', 'Working day'],
      description:
          'يوافق 11 مارس من كل عام، ويحتفي بالعلم السعودي رمز التوحيد '
          'والسيادة. لا يُعامل كإجازة رسمية عامة.',
      descriptionEn:
          'Observed on 11 March each year, it honors the Saudi flag as a '
          'symbol of tawhid and sovereignty. It is not treated as a general '
          'public holiday.',
      highlight: 'مناسبة وطنية معلوماتية، وليست إجازة رسمية.',
      highlightEn: 'An informational national occasion, not an official holiday.',
      officialHoliday: false,
      holidayVerified: true,
      dateSource: 'تاريخ ميلادي ثابت (11 مارس)',
      dateSourceEn: 'Fixed Gregorian date (11 March)',
    );
  }

  List<IslamicEvent> _islamicYear(int hijriYear) {
    return <IslamicEvent>[
      _hijriEvent(
        id: 'islamic-new-year',
        hijriYear: hijriYear,
        hijriMonth: 1,
        hijriDay: 1,
        title: 'رأس السنة الهجرية',
        titleEn: 'Islamic New Year',
        badge: 'مناسبة إسلامية',
        badgeEn: 'Islamic occasion',
        note: 'بداية العام الهجري حسب تقويم أم القرى',
        noteEn: 'Start of the Hijri year according to Umm Al-Qura',
        tagline: 'أهلّ علينا عام هجري جديد',
        taglineEn: 'A new Hijri year has begun',
        description:
            'أول أيام محرم حسب تقويم أم القرى. التاريخ تقويمي وقد يختلف عن '
            'إعلان الرؤية.',
        descriptionEn:
            'The first day of Muharram according to Umm Al-Qura. The calendar '
            'date may differ from the official moon-sighting announcement.',
        highlight: 'تاريخ تقويمي من جداول أم القرى، وليس إعلان رؤية رسمي.',
        highlightEn:
            'A tabular Umm Al-Qura date, not an official sighting announcement.',
        officialHoliday: true,
        holidayVerified: false,
      ),
      _hijriEvent(
        id: 'mawlid',
        hijriYear: hijriYear,
        hijriMonth: 3,
        hijriDay: 12,
        title: 'المولد النبوي الشريف',
        titleEn: "The Prophet's Birthday",
        badge: 'مناسبة إسلامية',
        badgeEn: 'Islamic occasion',
        note: 'سيرة عطرة ومجالس ذكر',
        noteEn: 'Noble biography and gatherings of remembrance',
        tagline: 'ذكرى مولد خير الأنام صلى الله عليه وسلم',
        taglineEn: 'The birth of the best of creation, peace be upon him',
        description:
            'ذكرى مولد النبي محمد صلى الله عليه وسلم في الثاني عشر من ربيع '
            'الأول حسب تقويم أم القرى. ليست إجازة رسمية عامة في المملكة.',
        descriptionEn:
            'The birthday of Prophet Muhammad, peace be upon him, on 12 Rabi\' '
            'al-Awwal according to Umm Al-Qura. It is not a general public '
            'holiday in the Kingdom.',
        highlight: 'تُعقد فيها مجالس الذكر وقراءة السيرة النبوية في المساجد.',
        highlightEn:
            'Gatherings of remembrance and readings of the Prophetic biography '
            'are held in mosques.',
        officialHoliday: false,
        holidayVerified: false,
      ),
      _hijriEvent(
        id: 'ramadan',
        hijriYear: hijriYear,
        hijriMonth: 9,
        hijriDay: 1,
        title: 'بداية شهر رمضان المبارك',
        titleEn: 'Beginning of Ramadan',
        badge: 'مناسبة إسلامية',
        badgeEn: 'Islamic occasion',
        note: 'شهر الصيام حسب تقويم أم القرى',
        noteEn: 'The fasting month according to Umm Al-Qura',
        tagline: 'أهلّ رمضان، شهر المغفرة والقيام',
        taglineEn: 'Ramadan has arrived, the month of forgiveness and night prayer',
        description:
            'أول أيام رمضان حسب جداول أم القرى. بدء الصيام الفعلي يعتمد على '
            'إعلان الرؤية الرسمي.',
        descriptionEn:
            'The first day of Ramadan according to Umm Al-Qura tables. The '
            'actual start of fasting depends on the official moon-sighting '
            'announcement.',
        highlight: 'تاريخ تقويمي مبدئي يحتاج تحقق الإعلان الرسمي.',
        highlightEn: 'A provisional calendar date that needs official confirmation.',
        officialHoliday: false,
        holidayVerified: false,
      ),
      _hijriEvent(
        id: 'eid-fitr',
        hijriYear: hijriYear,
        hijriMonth: 10,
        hijriDay: 1,
        title: 'عيد الفطر المبارك',
        titleEn: 'Eid al-Fitr',
        badge: 'مناسبة إسلامية',
        badgeEn: 'Islamic occasion',
        note: 'إجازة العيد — التاريخ تقويمي مبدئي',
        noteEn: 'Eid holiday — provisional calendar date',
        tagline: 'عيد مبارك وكل عام وأنتم بخير',
        taglineEn: 'Eid Mubarak, and may you be well every year',
        description:
            'أول أيام شوال حسب تقويم أم القرى. مدة الإجازة الرسمية تُعلن '
            'سنويًا ولا تُخترع هنا.',
        descriptionEn:
            'The first day of Shawwal according to Umm Al-Qura. The official '
            'holiday length is announced yearly and is not invented here.',
        highlight: 'تاريخ تقويمي مبدئي، والإجازة الرسمية تُحدد بقرار سنوي.',
        highlightEn:
            'A provisional calendar date; the official holiday is set by an '
            'annual decision.',
        officialHoliday: true,
        holidayVerified: false,
      ),
      _hijriEvent(
        id: 'eid-adha',
        hijriYear: hijriYear,
        hijriMonth: 12,
        hijriDay: 10,
        title: 'عيد الأضحى المبارك',
        titleEn: 'Eid al-Adha',
        badge: 'مناسبة إسلامية',
        badgeEn: 'Islamic occasion',
        note: 'إجازة العيد — التاريخ تقويمي مبدئي',
        noteEn: 'Eid holiday — provisional calendar date',
        tagline: 'تقبّل الله النسك وكل عام وأنتم بخير',
        taglineEn: 'May God accept the rites, and may you be well every year',
        description:
            'العاشر من ذي الحجة حسب تقويم أم القرى. مدة الإجازة الرسمية تُعلن '
            'سنويًا.',
        descriptionEn:
            'The 10th of Dhul-Hijjah according to Umm Al-Qura. The official '
            'holiday length is announced yearly.',
        highlight: 'تاريخ تقويمي مبدئي، وليس إعلان رؤية نهائي.',
        highlightEn:
            'A provisional calendar date, not a final sighting announcement.',
        officialHoliday: true,
        holidayVerified: false,
      ),
    ];
  }

  IslamicEvent _hijriEvent({
    required String id,
    required int hijriYear,
    required int hijriMonth,
    required int hijriDay,
    required String title,
    required String titleEn,
    required String badge,
    required String badgeEn,
    required String note,
    required String noteEn,
    required String tagline,
    required String taglineEn,
    required String description,
    required String descriptionEn,
    required String highlight,
    required String highlightEn,
    required bool officialHoliday,
    required bool holidayVerified,
  }) {
    final DateTime date = HijriDate(
      hijriYear,
      hijriMonth,
      hijriDay,
    ).toGregorian();
    return IslamicEvent(
      id: id,
      title: title,
      titleEn: titleEn,
      date: date,
      kind: EventKind.islamic,
      icon: Icons.mosque_outlined,
      badge: badge,
      badgeEn: badgeEn,
      note: note,
      noteEn: noteEn,
      actionLabel: 'التفاصيل',
      actionLabelEn: 'Details',
      tagline: tagline,
      taglineEn: taglineEn,
      ownerBadge: 'التقويم الهجري',
      ownerBadgeEn: 'Hijri calendar',
      statusPills: <String>[
        'مناسبة إسلامية',
        officialHoliday
            ? (holidayVerified ? 'إجازة رسمية' : 'إجازة وفق الإعلان الرسمي')
            : 'يوم عمل رسمي',
      ],
      statusPillsEn: <String>[
        'Islamic occasion',
        officialHoliday
            ? (holidayVerified
                  ? 'Official holiday'
                  : 'Holiday per official announcement')
            : 'Working day',
      ],
      description: description,
      descriptionEn: descriptionEn,
      highlight: highlight,
      highlightEn: highlightEn,
      officialHoliday: officialHoliday,
      holidayVerified: holidayVerified,
      dateSource: 'تقويم أم القرى (مبدئي حتى إعلان الرؤية)',
      dateSourceEn: 'Umm Al-Qura calendar (provisional until the official sighting)',
    );
  }
}
