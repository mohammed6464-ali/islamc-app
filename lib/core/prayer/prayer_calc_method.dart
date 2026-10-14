import 'package:adhan_dart/adhan_dart.dart';

/// Supported calculation methods. Labels match the existing Settings copy.
enum PrayerCalcMethod {
  ummAlQura('تقويم أم القرى'),
  muslimWorldLeague('رابطة العالم الإسلامي'),
  egyptian('الهيئة المصرية العامة للمساحة'),
  karachi('جامعة العلوم الإسلامية بكراتشي');

  const PrayerCalcMethod(this.label);

  final String label;

  static const PrayerCalcMethod defaultMethod = ummAlQura;

  static const List<String> labels = <String>[
    'تقويم أم القرى',
    'رابطة العالم الإسلامي',
    'الهيئة المصرية العامة للمساحة',
    'جامعة العلوم الإسلامية بكراتشي',
  ];

  static PrayerCalcMethod fromLabel(String label) => fromStored(label);

  static PrayerCalcMethod fromStored(String? value) {
    if (value == null || value.isEmpty) {
      return defaultMethod;
    }
    for (final PrayerCalcMethod method in values) {
      if (method.name == value || method.label == value) {
        return method;
      }
    }
    return defaultMethod;
  }

  CalculationParameters parameters() {
    final CalculationParameters params = switch (this) {
      ummAlQura => CalculationMethodParameters.ummAlQura(),
      muslimWorldLeague => CalculationMethodParameters.muslimWorldLeague(),
      egyptian => CalculationMethodParameters.egyptian(),
      karachi => CalculationMethodParameters.karachi(),
    };
    params.madhab = Madhab.shafi;
    return params;
  }
}
