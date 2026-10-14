import 'dart:math' as math;

/// Independent Qibla geometry: initial great-circle bearing and haversine
/// distance from any coordinates to the Kaaba.
class QiblaCalculationService {
  const QiblaCalculationService();

  /// Masjid al-Haram / Kaaba, WGS84.
  static const double kaabaLatitude = 21.4225241;
  static const double kaabaLongitude = 39.8261818;
  static const double earthRadiusKm = 6371.0;

  QiblaResult calculate({
    required double latitude,
    required double longitude,
  }) {
    final double distance = distanceKm(latitude, longitude);
    if (distance < 2) {
      return const QiblaResult(
        bearing: 0,
        distanceKm: 0,
        directionLabel: 'اتجاه الكعبة',
        label: 'اتجاه الكعبة',
      );
    }
    final double bearing = normalize(
      initialBearing(
        fromLat: latitude,
        fromLng: longitude,
        toLat: kaabaLatitude,
        toLng: kaabaLongitude,
      ),
    );
    final String direction = directionLabel(bearing);
    return QiblaResult(
      bearing: bearing,
      distanceKm: distance.round(),
      directionLabel: direction,
      label: '${bearing.round()}° $direction',
    );
  }

  /// Initial great-circle bearing, clockwise from true north, 0–360.
  static double initialBearing({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) {
    final double phi1 = _rad(fromLat);
    final double phi2 = _rad(toLat);
    final double dLambda = _rad(toLng - fromLng);
    final double y = math.sin(dLambda) * math.cos(phi2);
    final double x =
        math.cos(phi1) * math.sin(phi2) -
        math.sin(phi1) * math.cos(phi2) * math.cos(dLambda);
    return normalize(_deg(math.atan2(y, x)));
  }

  static double distanceKm(double lat, double lng) {
    final double dLat = _rad(kaabaLatitude - lat);
    final double dLng = _rad(kaabaLongitude - lng);
    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_rad(lat)) *
            math.cos(_rad(kaabaLatitude)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);
    return 2 * earthRadiusKm * math.asin(math.sqrt(a.clamp(0.0, 1.0)));
  }

  static double normalize(double degrees) {
    final double mod = degrees % 360;
    return mod < 0 ? mod + 360 : mod;
  }

  /// Signed shortest turn from [from] to [to] in [-180, 180].
  static double shortestDifference(double from, double to) {
    return ((to - from + 540) % 360) - 180;
  }

  static double lerpAngle(double from, double to, double t) {
    return normalize(from + shortestDifference(from, to) * t);
  }

  static bool isFiniteHeading(double? heading) =>
      heading != null && heading.isFinite;

  static String directionLabel(double bearing) {
    const List<String> labels = <String>[
      'شمال',
      'شمال شرق',
      'شرق',
      'جنوب شرق',
      'جنوب',
      'جنوب غرب',
      'غرب',
      'شمال غرب',
    ];
    final int index = ((normalize(bearing) + 22.5) % 360 / 45).floor();
    return labels[index];
  }

  static double _rad(double degrees) => degrees * math.pi / 180;
  static double _deg(double radians) => radians * 180 / math.pi;
}

class QiblaResult {
  const QiblaResult({
    required this.bearing,
    required this.distanceKm,
    required this.directionLabel,
    required this.label,
  });

  final double bearing;
  final int distanceKm;
  final String directionLabel;
  final String label;
}
