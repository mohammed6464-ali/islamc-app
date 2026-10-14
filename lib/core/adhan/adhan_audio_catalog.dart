enum AdhanMosque { makkah, madinah }

enum AdhanAudioType { fajr, regular }

/// Exact bundled recordings. Filenames are used as-is and must not be renamed.
class AdhanAudioCatalog {
  const AdhanAudioCatalog();

  static const String makkahFajr =
      'assets/audio/Adhan_Fajr_Al_Haram_Al_Maki_(أذان_الفجر_الحرم_المكي).mp3';
  static const String makkahRegular =
      'assets/audio/Ali_Ibn_Ahmad_Mala_6_-_Al_Haram_Al_Maki_(علي_بن_أحمد_ملا_-_الحرم_المكي).mp3';
  static const String madinahFajr =
      'assets/audio/Adhan_Fajr_Al_Haram_Al_Madani_(أذان_الفجر_الحرم_المدني).mp3';
  static const String madinahRegular =
      'assets/audio/Adhan_Al_Haram_Al_Madani_-_Al_Madinah_1_(أذان_الحرم_المدني_-_المدينة_المنورة).mp3';

  static const List<String> allAssets = <String>[
    makkahFajr,
    makkahRegular,
    madinahFajr,
    madinahRegular,
  ];

  String assetFor({required AdhanMosque mosque, required AdhanAudioType type}) {
    return switch ((mosque, type)) {
      (AdhanMosque.makkah, AdhanAudioType.fajr) => makkahFajr,
      (AdhanMosque.makkah, AdhanAudioType.regular) => makkahRegular,
      (AdhanMosque.madinah, AdhanAudioType.fajr) => madinahFajr,
      (AdhanMosque.madinah, AdhanAudioType.regular) => madinahRegular,
    };
  }

  AdhanAudioType typeForPrayer(String prayerId) =>
      prayerId == 'fajr' ? AdhanAudioType.fajr : AdhanAudioType.regular;

  static String mosqueLabel(AdhanMosque mosque) => switch (mosque) {
    AdhanMosque.makkah => 'أذان الحرم المكي',
    AdhanMosque.madinah => 'أذان المسجد النبوي',
  };

  static String typeLabel(AdhanAudioType type) => switch (type) {
    AdhanAudioType.fajr => 'أذان الفجر',
    AdhanAudioType.regular => 'أذان الصلوات الأخرى',
  };

  static AdhanMosque fromStored(String? value) {
    if (value == 'madinah' ||
        (value ?? '').contains('نبوي') ||
        (value ?? '').contains('مدني')) {
      return AdhanMosque.madinah;
    }
    return AdhanMosque.makkah;
  }
}
