import 'package:flutter/material.dart';

class MappedWeatherCondition {
  const MappedWeatherCondition({
    required this.labelAr,
    required this.icon,
    required this.outdoorNote,
    required this.badge,
  });

  final String labelAr;
  final IconData icon;
  final String outdoorNote;
  final String badge;
}

/// Maps official Open-Meteo / WMO weather codes. No string matching.
class WeatherConditionMapper {
  const WeatherConditionMapper();

  static IconData iconFor(int code, {required bool isDay}) {
    return switch (code) {
      0 => isDay ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
      1 => Icons.wb_sunny_outlined,
      2 => Icons.wb_cloudy_outlined,
      3 => Icons.cloud_outlined,
      45 || 48 => Icons.foggy,
      51 || 53 || 55 || 56 || 57 => Icons.grain_rounded,
      61 || 63 || 65 || 66 || 67 || 80 || 81 || 82 => Icons.umbrella_outlined,
      71 || 73 || 75 || 77 || 85 || 86 => Icons.ac_unit_rounded,
      95 || 96 || 99 => Icons.thunderstorm_outlined,
      _ => Icons.wb_cloudy_outlined,
    };
  }

  MappedWeatherCondition map(int code, {required bool isDay}) {
    return switch (code) {
      0 => isDay
          ? const MappedWeatherCondition(
              labelAr: 'مشمس',
              icon: Icons.wb_sunny_outlined,
              outdoorNote: 'أجواء صافية مناسبة للخروج',
              badge: 'أجواء مستقرة',
            )
          : const MappedWeatherCondition(
              labelAr: 'صافٍ ليلاً',
              icon: Icons.nightlight_outlined,
              outdoorNote: 'أجواء صافية مناسبة للخروج',
              badge: 'أجواء مستقرة',
            ),
      1 => isDay
          ? const MappedWeatherCondition(
              labelAr: 'صحو ومستقر',
              icon: Icons.wb_sunny_outlined,
              outdoorNote: 'أجواء مستقرة مع صحو غالب',
              badge: 'أجواء مستقرة',
            )
          : const MappedWeatherCondition(
              labelAr: 'غائم خفيف ليلاً',
              icon: Icons.wb_sunny_outlined,
              outdoorNote: 'أجواء مستقرة مع صحو غالب',
              badge: 'أجواء مستقرة',
            ),
      2 => const MappedWeatherCondition(
        labelAr: 'غائم جزئيًا',
        icon: Icons.wb_cloudy_outlined,
        outdoorNote: 'نسيم عليل مناسب للأنشطة الخارجية',
        badge: 'أجواء مستقرة',
      ),
      3 => const MappedWeatherCondition(
        labelAr: 'غائم',
        icon: Icons.cloud_outlined,
        outdoorNote: 'غطاء سحابي كثيف يقلل أشعة الشمس',
        badge: 'غائم',
      ),
      45 || 48 => const MappedWeatherCondition(
        labelAr: 'ضباب',
        icon: Icons.foggy,
        outdoorNote: 'رؤية منخفضة، تمهّل في التنقل',
        badge: 'ضباب',
      ),
      51 || 53 || 55 || 56 || 57 => const MappedWeatherCondition(
        labelAr: 'رذاذ خفيف',
        icon: Icons.grain_rounded,
        outdoorNote: 'رذاذ خفيف، يُفضل مظلة خفيفة',
        badge: 'رذاذ',
      ),
      61 || 63 || 65 || 66 || 67 || 80 || 81 || 82 =>
        const MappedWeatherCondition(
          labelAr: 'ممطر',
          icon: Icons.umbrella_outlined,
          outdoorNote: 'أمطار متوقعة، يُفضل البقاء في مكان مغطى',
          badge: 'ممطر',
        ),
      71 || 73 || 75 || 77 || 85 || 86 => const MappedWeatherCondition(
        labelAr: 'ثلوج',
        icon: Icons.ac_unit_rounded,
        outdoorNote: 'تساقط ثلوج، انتبه لبرودة الطريق',
        badge: 'ثلوج',
      ),
      95 || 96 || 99 => const MappedWeatherCondition(
        labelAr: 'عواصف رعدية',
        icon: Icons.thunderstorm_outlined,
        outdoorNote: 'عواصف رعدية، تجنّب الأماكن المكشوفة',
        badge: 'عواصف',
      ),
      _ => const MappedWeatherCondition(
        labelAr: 'غائم جزئيًا',
        icon: Icons.wb_cloudy_outlined,
        outdoorNote: 'نسيم عليل مناسب للأنشطة الخارجية',
        badge: 'أجواء مستقرة',
      ),
    };
  }

  static String windDirectionAr(int degrees) {
    const List<String> labels = <String>[
      'شمالية',
      'شمالية شرقية',
      'شرقية',
      'جنوبية شرقية',
      'جنوبية',
      'جنوبية غربية',
      'غربية',
      'شمالية غربية',
    ];
    final int index = (((degrees % 360) + 360) % 360 + 22) ~/ 45 % 8;
    return labels[index];
  }

  static String uvLabel(int index) {
    if (index <= 2) return 'منخفض';
    if (index <= 5) return 'متوسط';
    if (index <= 7) return 'معتدل';
    if (index <= 10) return 'مرتفع';
    return 'شديد';
  }

  static String humidityNote(int humidity) {
    if (humidity < 30) return 'جافة نسبيًا';
    if (humidity <= 55) return 'مناسبة ومريحة';
    return 'مرتفعة وشعور بالرطوبة';
  }
}
