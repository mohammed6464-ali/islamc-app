// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'تقويم ومواقيت';

  @override
  String get homeTagline => 'تقويمك .. مواقيتك .. في مكان واحد';

  @override
  String get welcome => 'مرحبًا بك';

  @override
  String get splashTagline => 'معك في كل وقت';

  @override
  String get splashCompanion => 'تقويم أم القرى المعتمد • رفيقك اليومي';

  @override
  String get splashLoadingTimes => 'جاري ضبط المواقيت حسب إحداثيات موقعك...';

  @override
  String get splashAstronomical => 'بيانات فلكية موثقة وفق تقويم أم القرى';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navWeather => 'الطقس';

  @override
  String get navCalendar => 'التقويم';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get back => 'رجوع';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get done => 'تم';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get ok => 'حسنًا';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSubtitle => 'واجهة المستخدم والمواقيت';

  @override
  String get appearance => 'المظهر واللغة';

  @override
  String get prayerAndAlerts => 'الصلاة والتنبيهات';

  @override
  String get locationAndWeather => 'الموقع والطقس';

  @override
  String get aboutSection => 'عن التطبيق';

  @override
  String get prayerNotifications => 'تنبيهات الصلاة والأذان';

  @override
  String get prayerNotificationsSubtitle =>
      'تخصيص الأذان وصوت التنبيه لكل فريضة';

  @override
  String get calculationMethod => 'طريقة حساب المواقيت';

  @override
  String get calculationMethodSubtitle => 'المعتمد في حساب أوقات الفرائض';

  @override
  String get eventAlerts => 'تنبيهات المناسبات والتقويم';

  @override
  String get eventAlertsSubtitle =>
      'الأيام البيض، صيام عاشوراء، والأعياد المباركة';

  @override
  String get currentCity => 'المدينة الحالية';

  @override
  String get currentCitySubtitleAuto => 'الموقع الحالي عبر GPS';

  @override
  String get currentCitySubtitleManual => 'مدينة محددة يدويًا';

  @override
  String get useDeviceLocation => 'استخدام موقع الجهاز';

  @override
  String get useDeviceLocationSubtitle =>
      'تحديث المواقيت والقبلة والطقس حسب GPS';

  @override
  String get gpsEnabled => 'تم اعتماد موقع الجهاز.';

  @override
  String get gpsManual => 'يمكنك اختيار المدينة يدويًا.';

  @override
  String get temperatureUnit => 'وحدة قياس درجة الحرارة';

  @override
  String get temperatureUnitSubtitle => 'عرض درجات الحرارة في شاشات الطقس';

  @override
  String get celsius => 'مئوية';

  @override
  String get fahrenheit => 'فهرنهايت';

  @override
  String unitAdopted(String unit) {
    return 'تم اعتماد وحدة $unit.';
  }

  @override
  String get calendarDisplay => 'عرض التقويم';

  @override
  String get calendarDisplaySubtitle => 'التفضيل يُحفظ ويظهر في شاشة التقويم';

  @override
  String get hijri => 'هجري';

  @override
  String get gregorian => 'ميلادي';

  @override
  String get hijriAdopted => 'تم اعتماد العرض الهجري.';

  @override
  String get gregorianAdopted => 'تم اعتماد العرض الميلادي.';

  @override
  String get aboutApp => 'حول التطبيق';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get terms => 'الشروط والأحكام';

  @override
  String get shareApp => 'مشاركة التطبيق';

  @override
  String get legalLastUpdated => 'آخر تحديث: أكتوبر 2026';

  @override
  String get privacyBody =>
      'تطبيق «تقويم ومواقيت» رفيق شخصي لمواقيت الصلاة والقبلة والطقس والتقويمين الهجري والميلادي. لا نطلب إنشاء حساب، ولا نشغّل سحابة لبيانات المستخدمين.';

  @override
  String get privacyDeviceTitle => 'البيانات على جهازك';

  @override
  String get privacyDeviceBody =>
      'تُحفظ اختياراتك — المدينة، اللغة، طريقة الحساب، جامع الأذان، وحدة الحرارة، عرض التقويم، وإعدادات التنبيه — محليًا على الجهاز حتى تبقى بعد إغلاق التطبيق. لا تُرفع هذه الإعدادات إلى خوادمنا.';

  @override
  String get privacyLocationTitle => 'الموقع';

  @override
  String get privacyLocationBody =>
      'إذا سمحت بالوصول إلى الموقع، تُستخدم الإحداثيات على الجهاز لحساب مواقيت الصلاة واتجاه القبلة، ولطلب طقس منطقتك. يمكنك إيقاف تحديد الموقع واختيار المدينة يدويًا في أي وقت.';

  @override
  String get privacyWeatherTitle => 'الطقس';

  @override
  String get privacyWeatherBody =>
      'يُطلب الطقس الحالي والتوقعات من خدمة Open-Meteo باستخدام الإحداثيات أو المدينة المختارة. يُحتفظ بنسخة مؤقتة قصيرة على الجهاز لتقليل الطلبات المتكررة.';

  @override
  String get privacyNotificationsTitle => 'التنبيهات والأذان';

  @override
  String get privacyNotificationsBody =>
      'تُجدول تذكيرات الصلاة والمناسبات محليًا عبر نظام إشعارات الجهاز. تشغيل الأذان يتم على جهازك. لا نرسل رسائل تسويقية.';

  @override
  String get privacyShareTitle => 'المشاركة والاحتفاظ';

  @override
  String get privacyShareBody =>
      'لا نبيع بياناتك. لا نطلب اسمك أو بريدك أو رقم هاتفك لاستخدام التطبيق. تبقى الإعدادات المحلية إلى أن تمسح بيانات التطبيق أو تزيله.';

  @override
  String get privacyAdsTitle => 'الإعلانات';

  @override
  String get privacyAdsBody =>
      'يعرض التطبيق إعلانات عبر خدمة Google AdMob. وقد تجمع هذه الخدمة معرّف الإعلانات وبيانات أساسية عن الجهاز لعرض الإعلانات وقياس أدائها. لا نطّلع على هذه البيانات بأنفسنا ولا نستخدمها لأي غرض آخر.';

  @override
  String get termsBody =>
      'باستخدامك تطبيق «تقويم ومواقيت» فإنك توافق على هذه الشروط. إن لم توافق فيُرجى التوقف عن استخدام التطبيق.';

  @override
  String get termsServiceTitle => 'ما يقدّمه التطبيق';

  @override
  String get termsServiceBody =>
      'يعرض التطبيق مواقيت الصلاة، واتجاه القبلة، والطقس، والتقويم الهجري والميلادي، والمناسبات الإسلامية والوطنية. بعض الميزات تحتاج إلى الأذونات التي تمنحها، والطقس يحتاج إلى اتصال بالشبكة.';

  @override
  String get termsPrayerTitle => 'مواقيت الصلاة';

  @override
  String get termsPrayerBody =>
      'تُحسب المواقيت على الجهاز، وافتراضيًا وفق طريقة أم القرى. يمكنك اختيار طريقة حساب أخرى. المواقيت المعروضة معينة لتنظيم اليوم، وليست فتوى ولا إعلان رؤية رسمي.';

  @override
  String get termsAccuracyTitle => 'الدقة';

  @override
  String get termsAccuracyBody =>
      'قد يختلف اتجاه القبلة أو الطقس أو تواريخ التقويم بسبب مستشعرات الجهاز أو تأخر الشبكة أو إعلانات رسمية لاحقة. عند الحاجة أكّد أوقات العبادة والإجازات من مصادر رسمية.';

  @override
  String get termsUseTitle => 'مسؤولياتك';

  @override
  String get termsUseBody =>
      'استخدم التطبيق وفق النظام. لا تعتمد عليه مصدرًا وحيدًا للأحكام الشرعية أو القانونية. أبقِ أذونات الموقع والتنبيهات تحت سيطرتك.';

  @override
  String get termsLiabilityTitle => 'حدود المسؤولية';

  @override
  String get termsLiabilityBody =>
      'يُقدَّم التطبيق بحالته. لا نتحمل المسؤولية عن التأخير أو اختلاف الحساب أو فوات تنبيه أو قرارات بُنيت على المعلومات المعروضة.';

  @override
  String get termsChangesTitle => 'التعديلات';

  @override
  String get termsChangesBody =>
      'قد تُحدَّث هذه الشروط وسياسة الخصوصية داخل التطبيق. استمرارك في الاستخدام بعد التحديث يعني قبولك للنسخة الأحدث.';

  @override
  String get aboutBody =>
      'مواقيت صلاة حسب أم القرى، قبلة، طقس، تقويم هجري وميلادي، وتنبيهات مع أذان الحرم المكي والمسجد النبوي. الموقع يُستخدم محليًا لحساب المواقيت والقبلة والطقس.';

  @override
  String get settingsIntro =>
      'تخصيص مواقيت الصلاة، التنبيهات، وتفضيلات التطبيق';

  @override
  String get countrySaudi => 'المملكة العربية السعودية';

  @override
  String get cityRiyadh => 'الرياض';

  @override
  String get cityMakkah => 'مكة المكرمة';

  @override
  String get cityMadinah => 'المدينة المنورة';

  @override
  String get cityJeddah => 'جدة';

  @override
  String get cityDammam => 'الدمام';

  @override
  String get cityKhobar => 'الخبر';

  @override
  String get cityTaif => 'الطائف';

  @override
  String get cityAbha => 'أبها';

  @override
  String get cityTabuk => 'تبوك';

  @override
  String get cityBuraydah => 'بريدة';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerSunrise => 'الشروق';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String get prayerFajrLong => 'صلاة الفجر';

  @override
  String get prayerSunriseLong => 'وقت الشروق';

  @override
  String get prayerDhuhrLong => 'صلاة الظهر';

  @override
  String get prayerAsrLong => 'صلاة العصر';

  @override
  String get prayerMaghribLong => 'صلاة المغرب';

  @override
  String get prayerIshaLong => 'صلاة العشاء';

  @override
  String get passed => 'انقضت';

  @override
  String get nextAdhan => 'الأذان القادم';

  @override
  String get sunriseForbidden => 'وقت النهي عن الصلاة';

  @override
  String get iftarTime => 'وقت الإفطار';

  @override
  String get ishaFollows => 'يليها الشفع والوتر';

  @override
  String get nextPrayer => 'الصلاة القادمة';

  @override
  String get todaysPrayers => 'مواقيت صلاة اليوم';

  @override
  String get prayerTimes => 'مواقيت الصلاة';

  @override
  String get prayerNotificationSettings => 'إعدادات تنبيهات الصلاة';

  @override
  String get enableAllPrayerAlerts => 'تفعيل تنبيهات الصلوات كافة';

  @override
  String get adhanPreviewHint =>
      'استخدم قسم «تجربة الأذان» بالأسفل لتشغيل الملف الكامل.';

  @override
  String get savePreferences => 'حفظ التفضيلات';

  @override
  String get prefsSaved => 'تم حفظ التفضيلات وجدولة تنبيهات الصلاة.';

  @override
  String get prefsBlocked => 'تعذر تفعيل الإشعارات.';

  @override
  String get adhanSound => 'صوت الأذان والتكبير';

  @override
  String adhanSoundPicked(String name) {
    return 'تم اعتماد «$name» للأذان داخل التطبيق.';
  }

  @override
  String get mosqueMakkah => 'أذان الحرم المكي';

  @override
  String get mosqueMadinah => 'أذان المسجد النبوي';

  @override
  String get mosqueMakkahShort => 'الحرم المكي';

  @override
  String get mosqueMadinahShort => 'المسجد النبوي';

  @override
  String get mosque => 'المسجد';

  @override
  String get adhanType => 'نوع الأذان';

  @override
  String get adhanFajr => 'أذان الفجر';

  @override
  String get adhanRegular => 'أذان الصلوات الأخرى';

  @override
  String get playAdhan => 'تشغيل الأذان';

  @override
  String get stopAdhan => 'إيقاف الأذان';

  @override
  String get adhanPreview => 'تجربة الأذان';

  @override
  String get adhanLoading => 'جاري التشغيل...';

  @override
  String get adhanFailed => 'تعذر تشغيل ملف الأذان المحدد.';

  @override
  String get testNotification => 'اختبار إشعار بعد دقيقتين';

  @override
  String get testNotificationBody =>
      'هذا الخيار يظهر في نسخة التطوير فقط. سيُجدول إشعارًا حقيقيًا بعد دقيقتين. ضع التطبيق في الخلفية أو أقفل الجهاز للتحقق.';

  @override
  String get scheduleTest => 'جدولة إشعار تجريبي';

  @override
  String get testScheduled =>
      'تم جدولة الإشعار. ضع التطبيق في الخلفية أو أقفل الجهاز.';

  @override
  String get testUnavailable => 'جدولة الإشعارات غير متاحة في هذا البناء.';

  @override
  String get exactAlarmNeeded =>
      'يحتاج التطبيق إلى إذن التنبيهات الدقيقة لجدولة الاختبار.';

  @override
  String get testFailed => 'تعذر جدولة إشعار الاختبار.';

  @override
  String notificationAt(String time) {
    return 'موعد الإشعار: $time';
  }

  @override
  String get prayerNotifyNote =>
      'يتم احتساب المواقيت وفق تقويم أم القرى بمكة المكرمة. الإشعار عند دخول الوقت يستخدم نغمة قصيرة متوافقة مع النظام، بينما الأذان الكامل يُشغَّل من داخل التطبيق.';

  @override
  String get notificationsDisabled =>
      'لم يُسمح بالإشعارات. يمكنك تفعيلها من إعدادات النظام.';

  @override
  String itsTimeForPrayer(String name) {
    return 'حان وقت صلاة $name';
  }

  @override
  String get itsTimeForSunrise => 'حان وقت الشروق';

  @override
  String prayerTimeBody(String longName, String city) {
    return '$longName حسب توقيت $city';
  }

  @override
  String sunriseBody(String city) {
    return 'وقت الشروق في $city';
  }

  @override
  String minutesUntilPrayer(int minutes, String name) {
    return 'تبقى $minutes دقيقة على صلاة $name';
  }

  @override
  String advanceReminderBody(String name, String city) {
    return 'تنبيه مسبق لصلاة $name في $city';
  }

  @override
  String get testNotificationTitle => 'اختبار إشعار الصلاة';

  @override
  String get testNotificationMessage =>
      'هذا إشعار تجريبي. ضع التطبيق في الخلفية أو أقفل الجهاز.';

  @override
  String get notificationDiagnostics => 'تشخيص الإشعارات';

  @override
  String diagPermission(String value) {
    return 'إذن الإشعارات: $value';
  }

  @override
  String diagExactAlarms(String value) {
    return 'التنبيهات الدقيقة: $value';
  }

  @override
  String diagChannel(String id) {
    return 'القناة: $id';
  }

  @override
  String diagOffset(int minutes) {
    return 'التذكير المسبق: $minutes د';
  }

  @override
  String diagMosque(String name) {
    return 'الجامع: $name';
  }

  @override
  String diagDeviceTime(String time) {
    return 'الوقت UTC: $time';
  }

  @override
  String diagTimezone(String id) {
    return 'المنطقة الزمنية: $id';
  }

  @override
  String diagNextPrayer(String name, String time) {
    return 'الصلاة التالية: $name عند $time';
  }

  @override
  String diagNextScheduled(String time) {
    return 'أقرب إشعار مجدول: $time';
  }

  @override
  String diagPendingCount(int count) {
    return 'الإشعارات المعلقة: $count';
  }

  @override
  String diagPendingIds(String ids) {
    return 'المعرّفات: $ids';
  }

  @override
  String diagInexact(String value) {
    return 'استخدام تنبيه غير دقيق: $value';
  }

  @override
  String get diagOn => 'مفعّل';

  @override
  String get diagOff => 'غير مفعّل';

  @override
  String get scheduleTest60s => 'اختبار بعد 60 ثانية';

  @override
  String get scheduleTest2m => 'اختبار بعد دقيقتين';

  @override
  String get inspectPending => 'عرض الإشعارات المعلقة';

  @override
  String get cancelTestNotifications => 'إلغاء إشعارات الاختبار';

  @override
  String get testNotificationsCancelled => 'تم إلغاء إشعارات الاختبار.';

  @override
  String eventReminderTitle(String title) {
    return 'تذكير: $title';
  }

  @override
  String get eventReminderBody => 'المناسبة تقترب. اضغط لعرض التفاصيل.';

  @override
  String get inboxPrayerTitle => 'تنبيه صلاة';

  @override
  String get inboxEventTitle => 'تذكير مناسبة';

  @override
  String inboxPrayerBody(String city) {
    return 'حان وقت الصلاة حسب توقيت $city';
  }

  @override
  String get inboxEventBody => 'افتح التفاصيل من التطبيق';

  @override
  String get now => 'الآن';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get calcUmmAlQura => 'تقويم أم القرى';

  @override
  String get calcMwl => 'رابطة العالم الإسلامي';

  @override
  String get calcEgyptian => 'الهيئة المصرية العامة للمساحة';

  @override
  String get calcKarachi => 'جامعة العلوم الإسلامية بكراتشي';

  @override
  String get weather => 'الطقس';

  @override
  String get refresh => 'تحديث';

  @override
  String get weatherUpdated => 'تم تحديث بيانات الطقس.';

  @override
  String get weatherUpdateFailed =>
      'تعذر تحديث الطقس. تُعرض آخر بيانات صالحة إن وُجدت.';

  @override
  String get weatherIndicators => 'مؤشرات الطقس الآن';

  @override
  String get updating => 'جاري التحديث';

  @override
  String get liveAccuracy => 'دقة لحظية';

  @override
  String get forecast => 'توقعات الأيام القادمة';

  @override
  String forecastDays(int count) {
    return '$count أيام مقبلة';
  }

  @override
  String get humidity => 'الرطوبة';

  @override
  String get windSpeed => 'سرعة الرياح';

  @override
  String get feelsLike => 'الإحساس الفعلي';

  @override
  String get uvIndex => 'مؤشر الأشعة (UV)';

  @override
  String get kmh => 'كم/س';

  @override
  String get warmer => 'أدفأ بدرجتين';

  @override
  String get matchesTemp => 'مطابق لدرجة الحرارة';

  @override
  String get uvProtect => 'يوصى بالحماية شمسياً';

  @override
  String get weatherSunny => 'مشمس';

  @override
  String get weatherClearNight => 'صافٍ ليلاً';

  @override
  String get weatherFair => 'صحو ومستقر';

  @override
  String get weatherPartlyCloudyNight => 'غائم خفيف ليلاً';

  @override
  String get weatherPartlyCloudy => 'غائم جزئيًا';

  @override
  String get weatherCloudy => 'غائم';

  @override
  String get weatherFog => 'ضباب';

  @override
  String get weatherDrizzle => 'رذاذ خفيف';

  @override
  String get weatherRain => 'ممطر';

  @override
  String get weatherSnow => 'ثلوج';

  @override
  String get weatherThunder => 'عواصف رعدية';

  @override
  String get noteClear => 'أجواء صافية مناسبة للخروج';

  @override
  String get noteFair => 'أجواء مستقرة مع صحو غالب';

  @override
  String get noteBreeze => 'نسيم عليل مناسب للأنشطة الخارجية';

  @override
  String get noteOvercast => 'غطاء سحابي كثيف يقلل أشعة الشمس';

  @override
  String get noteFog => 'رؤية منخفضة، تمهّل في التنقل';

  @override
  String get noteDrizzle => 'رذاذ خفيف، يُفضل مظلة خفيفة';

  @override
  String get noteRain => 'أمطار متوقعة، يُفضل البقاء في مكان مغطى';

  @override
  String get noteSnow => 'تساقط ثلوج، انتبه لبرودة الطريق';

  @override
  String get noteThunder => 'عواصف رعدية، تجنّب الأماكن المكشوفة';

  @override
  String get badgeStable => 'أجواء مستقرة';

  @override
  String get badgeCloudy => 'غائم';

  @override
  String get badgeFog => 'ضباب';

  @override
  String get badgeDrizzle => 'رذاذ';

  @override
  String get badgeRain => 'ممطر';

  @override
  String get badgeSnow => 'ثلوج';

  @override
  String get badgeStorm => 'عواصف';

  @override
  String get qibla => 'القبلة';

  @override
  String get qiblaDirection => 'اتجاه القبلة';

  @override
  String get calendar => 'التقويم';

  @override
  String get upcomingEvents => 'المناسبات القادمة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get markAllRead => 'تحديد الكل كمقروء';

  @override
  String get emptyNotifications =>
      'لا توجد إشعارات مستلمة بعد. ستظهر هنا بعد وصول تنبيه الصلاة أو تذكير المناسبة.';

  @override
  String get customizeAlerts => 'تخصيص التنبيهات';

  @override
  String get locationTitle => 'حدد موقعك';

  @override
  String get locationBody =>
      'نستخدم موقعك لعرض مواقيت الصلاة والطقس واتجاه القبلة بدقة متناهية وفق توقيت مدينتك.';

  @override
  String get allowLocation => 'السماح بتحديد الموقع';

  @override
  String get chooseCityManually => 'اختيار المدينة يدويًا';

  @override
  String get skip => 'تخطي';

  @override
  String get highAccuracy => 'دقة متناهية';

  @override
  String get locationPrivate => 'بيانات موقعك محمية ومحفوظة على جهازك فقط';

  @override
  String get locationFailed =>
      'تعذر تحديد الموقع. يمكنك اختيار المدينة يدويًا.';

  @override
  String get changeCity => 'تغيير المدينة';

  @override
  String get adhanStarted => 'جاري التشغيل...';

  @override
  String get preAlertExact => 'عند دخول وقت الصلاة تمامًا';

  @override
  String preAlertMinutes(int minutes) {
    return 'قبل $minutes دقيقة';
  }

  @override
  String get preAlertFive => 'قبل 5 دقائق';

  @override
  String get preAlertTen => 'قبل 10 دقائق';

  @override
  String get preAlertFifteen => 'قبل 15 دقيقة';

  @override
  String remainingDays(int days) {
    return 'متبقي $days يومًا';
  }

  @override
  String get eventToday => 'حلّت المناسبة اليوم';

  @override
  String get upcoming => 'قادمة';

  @override
  String get statusToday => 'اليوم';

  @override
  String favoriteAdded(String title) {
    return 'تمت إضافة «$title» إلى مناسباتك المفضلة.';
  }

  @override
  String favoriteRemoved(String title) {
    return 'تمت إزالة «$title» من مناسباتك المفضلة.';
  }

  @override
  String get addToDeviceCalendar => 'إضافة إلى تقويم الهاتف';

  @override
  String get calendarOpened => 'تم فتح تقويم الجهاز لإكمال إضافة المناسبة.';

  @override
  String get calendarFailed => 'تعذر فتح تقويم الجهاز.';

  @override
  String get enableAdvanceAlert => 'تفعيل التنبيه المسبق';

  @override
  String get threeDaysBefore => 'قبل 3 أيام من المناسبة';

  @override
  String get shareOccasion => 'مشاركة المناسبة';

  @override
  String get aboutOccasion => 'عن المناسبة';

  @override
  String get eventDate => 'تاريخ المناسبة';

  @override
  String get timeUntilStart => 'الوقت المتبقي حتى الانطلاق';

  @override
  String get status => 'الحالة';

  @override
  String get quickActions => 'الإجراءات السريعة';

  @override
  String saudiNationalDay(int n) {
    return 'اليوم الوطني السعودي $n';
  }

  @override
  String get foundingDay => 'يوم التأسيس';

  @override
  String get flagDay => 'يوم العلم';

  @override
  String get islamicNewYear => 'رأس السنة الهجرية';

  @override
  String get mawlid => 'المولد النبوي الشريف';

  @override
  String get ramadanStart => 'بداية شهر رمضان المبارك';

  @override
  String get eidFitr => 'عيد الفطر المبارك';

  @override
  String get eidAdha => 'عيد الأضحى المبارك';

  @override
  String get nationalOccasion => 'مناسبة وطنية';

  @override
  String get islamicOccasion => 'مناسبة إسلامية';

  @override
  String get officialHoliday => 'إجازة رسمية';

  @override
  String get notPublicHoliday => 'يوم عمل رسمي';

  @override
  String get holidayPending => 'إجازة وفق الإعلان الرسمي';

  @override
  String get weekdaySun => 'الأحد';

  @override
  String get weekdayMon => 'الإثنين';

  @override
  String get weekdayTue => 'الثلاثاء';

  @override
  String get weekdayWed => 'الأربعاء';

  @override
  String get weekdayThu => 'الخميس';

  @override
  String get weekdayFri => 'الجمعة';

  @override
  String get weekdaySat => 'السبت';

  @override
  String get monthJan => 'يناير';

  @override
  String get monthFeb => 'فبراير';

  @override
  String get monthMar => 'مارس';

  @override
  String get monthApr => 'أبريل';

  @override
  String get monthMay => 'مايو';

  @override
  String get monthJun => 'يونيو';

  @override
  String get monthJul => 'يوليو';

  @override
  String get monthAug => 'أغسطس';

  @override
  String get monthSep => 'سبتمبر';

  @override
  String get monthOct => 'أكتوبر';

  @override
  String get monthNov => 'نوفمبر';

  @override
  String get monthDec => 'ديسمبر';

  @override
  String get hijriMuharram => 'محرم';

  @override
  String get hijriSafar => 'صفر';

  @override
  String get hijriRabi1 => 'ربيع الأول';

  @override
  String get hijriRabi2 => 'ربيع الآخر';

  @override
  String get hijriJumada1 => 'جمادى الأولى';

  @override
  String get hijriJumada2 => 'جمادى الآخرة';

  @override
  String get hijriRajab => 'رجب';

  @override
  String get hijriShaban => 'شعبان';

  @override
  String get hijriRamadan => 'رمضان';

  @override
  String get hijriShawwal => 'شوال';

  @override
  String get hijriDhulQadah => 'ذو القعدة';

  @override
  String get hijriDhulHijjah => 'ذو الحجة';

  @override
  String get dirN => 'شمالية';

  @override
  String get dirNE => 'شمالية شرقية';

  @override
  String get dirE => 'شرقية';

  @override
  String get dirSE => 'جنوبية شرقية';

  @override
  String get dirS => 'جنوبية';

  @override
  String get dirSW => 'جنوبية غربية';

  @override
  String get dirW => 'غربية';

  @override
  String get dirNW => 'شمالية غربية';

  @override
  String get uvLow => 'منخفض';

  @override
  String get uvModerate => 'متوسط';

  @override
  String get uvHigh => 'معتدل';

  @override
  String get uvVeryHigh => 'مرتفع';

  @override
  String get uvExtreme => 'شديد';

  @override
  String get humidityDry => 'جافة نسبيًا';

  @override
  String get humidityComfort => 'مناسبة ومريحة';

  @override
  String get humidityHigh => 'مرتفعة وشعور بالرطوبة';

  @override
  String get celsiusUnit => 'م';

  @override
  String get fahrenheitUnit => 'ف';

  @override
  String get celsiusLabel => 'مئوية C°';

  @override
  String get fahrenheitLabel => 'فهرنهايت F°';

  @override
  String languageChanged(String name) {
    return 'تم اعتماد لغة $name.';
  }

  @override
  String get shareDisabled => 'المشاركة غير مفعّلة في النسخة التجريبية.';

  @override
  String get occasions => 'المناسبات';

  @override
  String get imsakIftar => 'الإمساك والإفطار';

  @override
  String iftarAt(String time) {
    return 'الإفطار: $time';
  }

  @override
  String get mondayThursdayFast => 'صيام الاثنين والخميس';

  @override
  String get qiblaAngleLabel => 'زاوية القبلة';

  @override
  String get compassHighAccuracy => 'دقة البوصلة عالية';

  @override
  String get adhanEnabled => 'الأذان مفعّل';

  @override
  String get adhanDisabled => 'الأذان متوقف';

  @override
  String get adhanTimeUmmAlQura => 'موعد الأذان حسب أم القرى';

  @override
  String get morning => 'صباحًا';

  @override
  String get evening => 'مساءً';

  @override
  String get periodAm => 'ص';

  @override
  String get periodPm => 'م';

  @override
  String get remainingUntilPrayer => 'متبقي على الصلاة';

  @override
  String get current => 'الحالي';

  @override
  String get blessedDay => 'يوم مبارك';

  @override
  String get details => 'التفاصيل';

  @override
  String get previousMonth => 'الشهر السابق';

  @override
  String get nextMonth => 'الشهر التالي';

  @override
  String get liveUpdate => 'تحديث فوري';

  @override
  String get markAllReadDone => 'تم تحديد جميع الإشعارات كمقروءة.';

  @override
  String get customizeNotifications => 'تخصيص الإشعارات والتنبيهات';

  @override
  String get controlAdhanAndEvents => 'تحكم في نغمة الأذان وتنبيهات المناسبات';

  @override
  String get receiveAdhanAll => 'تلقي نداء الأذان والإشعارات لجميع الأوقات';

  @override
  String get dailyPrayerTimes => 'مواقيت الصلوات اليومية';

  @override
  String get upcomingShort => 'القادمة';

  @override
  String get enabled => 'مفعل';

  @override
  String get disabled => 'غير مفعل';

  @override
  String get preAlertTime => 'وقت التنبيه المسبق';

  @override
  String get defaultLabel => 'الافتراضي';

  @override
  String get yourCurrentLocation => 'موقعك الحالي';

  @override
  String get orChooseCity => 'أو اختر مدينة يدويًا';

  @override
  String get popularHolyCities => 'المدن الشائعة والمقدسة';

  @override
  String get noCityMatch => 'لا توجد مدينة مطابقة لبحثك.';

  @override
  String officialMethod(String method) {
    return 'طريقة الحساب المعتمدة: $method';
  }

  @override
  String get officialMethodBody =>
      'تتم مطابقة زوايا الفجر والعشاء واتجاه القبلة مع المعايير الرسمية لوزارة الشؤون الإسلامية.';

  @override
  String get mapPlaceholder => 'الخريطة تمثيلية فقط في النسخة التجريبية.';

  @override
  String get activeNow => 'نشط الآن';

  @override
  String get refreshGps => 'تحديث الموقع عبر GPS';

  @override
  String locationUpdated(String city) {
    return 'تم تحديث الموقع إلى $city.';
  }

  @override
  String get locationAuto => 'تحديد الموقع تلقائيًا';

  @override
  String get locationAutoSubtitle =>
      'تحديث مواقيت الصلاة والأذان عند التنقل بين المدن';

  @override
  String get searchCity => 'ابحث عن مدينة...';

  @override
  String timesUpdatedForCity(String city) {
    return 'تم تحديث المواقيت على مدينة $city.';
  }

  @override
  String get qiblaCalibrate => 'إعادة المعايرة';

  @override
  String get qiblaCalibrateBody =>
      'حرّك الهاتف على شكل ∞ بعيدًا عن المعادن والمغناطيس، وضعه أفقيًا لإعادة معايرة البوصلة.';

  @override
  String distanceToMakkah(int km) {
    return 'المسافة إلى مكة المكرمة: $km كم';
  }

  @override
  String get holdPhoneFlat =>
      'ضع الهاتف بشكل أفقي على سطح مستوٍ للحصول على قراءة أكثر دقة. أبعده عن المعادن والمغناطيس.';

  @override
  String compassAccuracy(String value) {
    return 'دقة البوصلة: $value';
  }

  @override
  String get qiblaMethodTitle => 'طريقة الحساب';

  @override
  String qiblaMethodBody(String declination, String method) {
    return 'اتجاه القبلة محسوب بالدائرة العظمى من موقعك إلى الكعبة. $declinationطريقة مواقيت الصلاة: $method.';
  }

  @override
  String get declinationNote =>
      'اتجاه الجهاز مصحح بانحراف مغناطيسي تقريبي، وليست قراءة شمال حقيقي معتمدة. ';

  @override
  String get eventDetails => 'تفاصيل المناسبة';

  @override
  String get savedInFavorites => 'محفوظة في مناسباتي المفضلة';

  @override
  String get saveToFavorites => 'حفظ في مناسباتي المفضلة';

  @override
  String get qiblaKaaba => 'اتجاه الكعبة';

  @override
  String get cardinalN => 'ش';

  @override
  String get cardinalE => 'ق';

  @override
  String get cardinalS => 'ج';

  @override
  String get cardinalW => 'غ';

  @override
  String get qiblaDirN => 'شمال';

  @override
  String get qiblaDirNE => 'شمال شرق';

  @override
  String get qiblaDirE => 'شرق';

  @override
  String get qiblaDirSE => 'جنوب شرق';

  @override
  String get qiblaDirS => 'جنوب';

  @override
  String get qiblaDirSW => 'جنوب غرب';

  @override
  String get qiblaDirW => 'غرب';

  @override
  String get qiblaDirNW => 'شمال غرب';

  @override
  String timezoneOf(String city) {
    return 'توقيت $city';
  }

  @override
  String get lastKnownLocation => 'آخر موقع معروف';

  @override
  String get gpsStrong => 'إشارة GPS قوية دقيقة';

  @override
  String get manualLocation => 'موقع يدوي';

  @override
  String get weatherUpdating => 'جاري تحديث بيانات الطقس...';

  @override
  String weatherLive(String station) {
    return 'تحديث مباشر لـ$station';
  }

  @override
  String get weatherUnavailableCity => 'بيانات الطقس غير متاحة لهذه المدينة.';

  @override
  String weatherCached(String station) {
    return 'بيانات محفوظة لـ$station';
  }

  @override
  String get weatherUpdatedNow => 'آخر تحديث الآن';

  @override
  String weatherUpdatedMinutes(int minutes) {
    return 'آخر تحديث قبل $minutes د';
  }

  @override
  String weatherUpdatedAt(String time) {
    return 'آخر تحديث $time';
  }

  @override
  String get weatherStationUnavailable => 'غير متاح';

  @override
  String get locServiceDisabled =>
      'خدمة الموقع مغلقة على الجهاز. فعّلها من الإعدادات أو اختر المدينة يدويًا.';

  @override
  String get locDenied =>
      'لم يتم السماح بالوصول إلى الموقع. يمكنك اختيار المدينة يدويًا.';

  @override
  String get locDeniedForever =>
      'إذن الموقع مرفوض. فعّله من إعدادات التطبيق أو اختر المدينة يدويًا.';

  @override
  String get locTimeout =>
      'انتهت مهلة تحديد الموقع. حاول مجددًا أو اختر المدينة يدويًا.';

  @override
  String get locUnavailable =>
      'تعذر تحديد الموقع حاليًا. يمكنك اختيار المدينة يدويًا.';

  @override
  String get locGeocodingFailed =>
      'تم تحديد الإحداثيات لكن تعذر معرفة اسم المدينة. سنعتمد أقرب مدينة معروفة.';

  @override
  String get weatherOffline =>
      'لا يوجد اتصال بالإنترنت. تُعرض آخر بيانات محفوظة إن وُجدت.';

  @override
  String get weatherTimeout => 'انتهت مهلة طلب الطقس. حاول التحديث لاحقًا.';

  @override
  String get weatherParse => 'تعذر قراءة بيانات الطقس المستلمة.';

  @override
  String get weatherUnavailable => 'تعذر جلب بيانات الطقس حاليًا.';

  @override
  String get compassUnavailable =>
      'مستشعر البوصلة غير متاح على هذا الجهاز. اتجاه القبلة محسوب، لكن السهم لن يتبع دوران الهاتف.';

  @override
  String get compassNeedsCalibration =>
      'حركة على شكل ∞ في الهواء بعيدًا عن المعادن لإعادة معايرة البوصلة.';

  @override
  String get compassAccuracyUnknown =>
      'دقة المستشعر غير متاحة. أبعد الهاتف عن المغناطيس وضعه بشكل أفقي.';

  @override
  String get compassUnavailableShort => 'غير متاحة';

  @override
  String get compassNeedsCalShort => 'تحتاج معايرة';

  @override
  String get compassLow => 'ضعيفة';

  @override
  String get compassMedium => 'متوسطة';

  @override
  String get compassHigh => 'جيدة';

  @override
  String get audioFailed => 'تعذر تشغيل الأذان.';

  @override
  String cityFullName(String city, String country) {
    return '$city، $country';
  }

  @override
  String prayerSource(String city) {
    return '$city • تقويم أم القرى';
  }

  @override
  String appVersionLabel(String name, String version) {
    return '$name — الإصدار $version';
  }

  @override
  String hijriDate(int day, String month, int year) {
    return '$day $month $year هـ';
  }

  @override
  String hijriMonthYear(String month, int year) {
    return '$month $year هـ';
  }

  @override
  String gregorianDate(int day, String month, int year) {
    return '$day $month $year م';
  }

  @override
  String gregorianMonthYear(String month, int year) {
    return '$month $year';
  }

  @override
  String weekdayCommaDate(String weekday, String date) {
    return '$weekday، $date';
  }

  @override
  String forecastTodayWeekday(String weekday) {
    return 'اليوم ($weekday)';
  }

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get contactUnavailable => 'لم يُوفَّر عنوان تواصل رسمي بعد.';

  @override
  String shareEventText(String title, String date, String tagline) {
    return '$title\n$date\n$tagline';
  }

  @override
  String get nationalOfficial => 'مناسبة وطنية رسمية';

  @override
  String get holidayAllSectors => 'إجازة رسمية لجميع القطاعات';

  @override
  String get foundingHoliday => 'إجازة رسمية ليوم التأسيس';

  @override
  String get flagNotHoliday => 'مناسبة وطنية وليست إجازة عامة';

  @override
  String get islamicCalendar => 'التقويم الهجري';

  @override
  String get ummAlQuraProvisional => 'تقويم أم القرى (مبدئي حتى إعلان الرؤية)';

  @override
  String get fixedGregorianSep23 => 'تاريخ ميلادي ثابت (23 سبتمبر)';

  @override
  String get fixedGregorianFeb22 => 'تاريخ ميلادي ثابت (22 فبراير)';

  @override
  String get fixedGregorianMar11 => 'تاريخ ميلادي ثابت (11 مارس)';

  @override
  String get nationalDayTagline => 'نحلم ونحقق • مجد وعز وسؤدد يعانق السماء';

  @override
  String get foundingDayTagline =>
      'ذكرى تأسيس الدولة السعودية الأولى عام 1727م';

  @override
  String get flagDayTagline => 'يوم رفع العلم السعودي والاعتزاز برمزه';

  @override
  String get nationalDayDesc =>
      'يوم توحيد المملكة العربية السعودية على يد الملك عبد العزيز بن عبد الرحمن آل سعود رحمه الله. يحتفي به الوطن في 23 سبتمبر من كل عام بمشاعر الفخر والاعتزاز.';

  @override
  String get nationalDayHighlight =>
      'تقام فيه الفعاليات الوطنية، العروض الجوية، والبرامج الثقافية في مختلف مناطق المملكة.';

  @override
  String get foundingDayDesc =>
      'يوافق 22 فبراير من كل عام، ويحتفي بتأسيس الدولة السعودية الأولى على يد الإمام محمد بن سعود عام 1727م.';

  @override
  String get foundingDayHighlight => 'تاريخ ميلادي ثابت معتمد كإجازة رسمية.';

  @override
  String get flagDayDesc =>
      'يوافق 11 مارس من كل عام، ويحتفي بالعلم السعودي رمز التوحيد والسيادة. لا يُعامل كإجازة رسمية عامة.';

  @override
  String get flagDayHighlight => 'مناسبة وطنية معلوماتية، وليست إجازة رسمية.';

  @override
  String get islamicNewYearNote => 'بداية العام الهجري حسب تقويم أم القرى';

  @override
  String get islamicNewYearTagline => 'أهلّ علينا عام هجري جديد';

  @override
  String get islamicNewYearDesc =>
      'أول أيام محرم حسب تقويم أم القرى. التاريخ تقويمي وقد يختلف عن إعلان الرؤية.';

  @override
  String get islamicNewYearHighlight =>
      'تاريخ تقويمي من جداول أم القرى، وليس إعلان رؤية رسمي.';

  @override
  String get mawlidNote => 'سيرة عطرة ومجالس ذكر';

  @override
  String get mawlidTagline => 'ذكرى مولد خير الأنام صلى الله عليه وسلم';

  @override
  String get mawlidDesc =>
      'ذكرى مولد النبي محمد صلى الله عليه وسلم في الثاني عشر من ربيع الأول حسب تقويم أم القرى. ليست إجازة رسمية عامة في المملكة.';

  @override
  String get mawlidHighlight =>
      'تُعقد فيها مجالس الذكر وقراءة السيرة النبوية في المساجد.';

  @override
  String get ramadanNote => 'شهر الصيام حسب تقويم أم القرى';

  @override
  String get ramadanTagline => 'أهلّ رمضان، شهر المغفرة والقيام';

  @override
  String get ramadanDesc =>
      'أول أيام رمضان حسب جداول أم القرى. بدء الصيام الفعلي يعتمد على إعلان الرؤية الرسمي.';

  @override
  String get ramadanHighlight =>
      'تاريخ تقويمي مبدئي يحتاج تحقق الإعلان الرسمي.';

  @override
  String get eidFitrNote => 'إجازة العيد — التاريخ تقويمي مبدئي';

  @override
  String get eidFitrTagline => 'عيد مبارك وكل عام وأنتم بخير';

  @override
  String get eidFitrDesc =>
      'أول أيام شوال حسب تقويم أم القرى. مدة الإجازة الرسمية تُعلن سنويًا ولا تُخترع هنا.';

  @override
  String get eidFitrHighlight =>
      'تاريخ تقويمي مبدئي، والإجازة الرسمية تُحدد بقرار سنوي.';

  @override
  String get eidAdhaNote => 'إجازة العيد — التاريخ تقويمي مبدئي';

  @override
  String get eidAdhaTagline => 'تقبّل الله النسك وكل عام وأنتم بخير';

  @override
  String get eidAdhaDesc =>
      'العاشر من ذي الحجة حسب تقويم أم القرى. مدة الإجازة الرسمية تُعلن سنويًا.';

  @override
  String get eidAdhaHighlight => 'تاريخ تقويمي مبدئي، وليس إعلان رؤية نهائي.';

  @override
  String get eventActionDuas => 'الأدعية والأذكار';

  @override
  String get duasAndAdhkar => 'الأدعية والأذكار';

  @override
  String get currentDay => 'اليوم الحالي';

  @override
  String get selectedDay => 'يوم محدد';

  @override
  String citiesAvailable(int count) {
    return '$count مدن متوفرة';
  }

  @override
  String currentlySelected(String city) {
    return '$city (محدد حاليًا)';
  }

  @override
  String minuteOffset(String signed) {
    return '(فارق $signed دقيقة)';
  }

  @override
  String cloudCoverPct(int cover) {
    return 'غطاء سحابي $cover%';
  }

  @override
  String highTemp(String temp) {
    return 'العظمى $temp';
  }

  @override
  String lowTemp(String temp) {
    return 'الصغرى $temp';
  }

  @override
  String nextAdhanAt(String name, String time) {
    return 'أذان $name القادم: $time';
  }

  @override
  String nextPrayerAt(String name, String time) {
    return '$name القادمة في $time';
  }

  @override
  String forecastSnack(
    String day,
    String description,
    String low,
    String high,
  ) {
    return 'توقعات $day: $description ($low / $high).';
  }
}
