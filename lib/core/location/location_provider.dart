import 'location_failure.dart';

class GeoFix {
  const GeoFix({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

class GeoPlace {
  const GeoPlace({
    required this.cityName,
    required this.countryName,
    this.isoCountryCode,
  });

  final String cityName;
  final String countryName;
  final String? isoCountryCode;
}

/// Platform GPS + reverse geocoding. Implementations must not request
/// background location.
abstract class LocationProvider {
  Future<bool> isServiceEnabled();

  Future<AppPermissionStatus> checkPermission();

  Future<AppPermissionStatus> requestPermission();

  Future<GeoFix> getCurrentPosition({
    Duration timeout = const Duration(seconds: 15),
  });

  Future<GeoPlace?> reverseGeocode(double latitude, double longitude);

  Future<void> openLocationSettings();

  Future<void> openAppSettings();
}
