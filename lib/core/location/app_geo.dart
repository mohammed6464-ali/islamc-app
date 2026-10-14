import 'dart:math' as math;

import '../qibla/qibla_calculation_service.dart';

/// Geometry helpers for Qibla and distance. This is not a compass sensor.
class AppGeo {
  const AppGeo._();

  static const QiblaCalculationService _qibla = QiblaCalculationService();

  static int qiblaAngle(double latitude, double longitude) {
    return _qibla
            .calculate(latitude: latitude, longitude: longitude)
            .bearing
            .round() %
        360;
  }

  static String qiblaDirection(double latitude, double longitude) {
    return _qibla
        .calculate(latitude: latitude, longitude: longitude)
        .directionLabel;
  }

  static String qiblaLabel(double latitude, double longitude) {
    return _qibla.calculate(latitude: latitude, longitude: longitude).label;
  }

  static int distanceToMakkah(double latitude, double longitude) {
    return _qibla
        .calculate(latitude: latitude, longitude: longitude)
        .distanceKm;
  }

  static double haversineKm(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final double dLat = _rad(lat2 - lat1);
    final double dLng = _rad(lng2 - lng1);
    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(lat1)) *
            math.cos(_rad(lat2)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return 2 *
        QiblaCalculationService.earthRadiusKm *
        math.asin(math.sqrt(a.clamp(0.0, 1.0)));
  }

  static String coordinatesLabel(double latitude, double longitude) {
    final String ns = latitude >= 0 ? 'N' : 'S';
    final String ew = longitude >= 0 ? 'E' : 'W';
    return '${latitude.abs().toStringAsFixed(4)}° $ns, '
        '${longitude.abs().toStringAsFixed(4)}° $ew';
  }

  static double _rad(double degrees) => degrees * math.pi / 180;
}
