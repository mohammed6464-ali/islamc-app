import 'qibla_calculation_service.dart';

/// Approximate magnetic declination using the WMM2020 geomagnetic dipole pole.
///
/// This is an estimate (often a few degrees, larger near the magnetic equator),
/// not a full spherical-harmonic World Magnetic Model. The UI must not present
/// it as a certified true-north reading.
class MagneticDeclination {
  const MagneticDeclination();

  /// Geomagnetic dipole pole, WMM2020 (80.65°N, 72.68°W).
  static const double _poleLat = 80.65;
  static const double _poleLng = -72.68;

  /// East-positive degrees in (-180, 180]: magnetic north is this many degrees
  /// east of true north. `trueHeading ≈ magneticHeading + declination`.
  double degrees({required double latitude, required double longitude}) {
    final double bearingToPole = QiblaCalculationService.initialBearing(
      fromLat: latitude,
      fromLng: longitude,
      toLat: _poleLat,
      toLng: _poleLng,
    );
    return QiblaCalculationService.shortestDifference(0, bearingToPole);
  }
}
