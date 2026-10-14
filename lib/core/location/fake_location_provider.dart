import 'location_failure.dart';
import 'location_provider.dart';

/// Deterministic GPS used by tests. Never talks to the device.
class FakeLocationProvider implements LocationProvider {
  FakeLocationProvider({
    this.serviceEnabled = true,
    this.permission = AppPermissionStatus.whileInUse,
    this.fix = const GeoFix(latitude: 24.7136, longitude: 46.6753),
    this.place = const GeoPlace(
      cityName: 'الرياض',
      countryName: 'المملكة العربية السعودية',
      isoCountryCode: 'SA',
    ),
    this.throwOnPosition,
  });

  bool serviceEnabled;
  AppPermissionStatus permission;
  GeoFix? fix;
  GeoPlace? place;
  LocationFailure? throwOnPosition;

  @override
  Future<bool> isServiceEnabled() async => serviceEnabled;

  @override
  Future<AppPermissionStatus> checkPermission() async => permission;

  @override
  Future<AppPermissionStatus> requestPermission() async => permission;

  @override
  Future<GeoFix> getCurrentPosition({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (!serviceEnabled) {
      throw LocationFailure.serviceDisabled;
    }
    if (!permission.isGranted) {
      throw permission == AppPermissionStatus.deniedForever
          ? LocationFailure.deniedForever
          : LocationFailure.denied;
    }
    if (throwOnPosition != null) {
      throw throwOnPosition!;
    }
    final GeoFix? current = fix;
    if (current == null) {
      throw LocationFailure.unavailable;
    }
    return current;
  }

  @override
  Future<GeoPlace?> reverseGeocode(double latitude, double longitude) async {
    return place;
  }

  @override
  Future<void> openAppSettings() async {}

  @override
  Future<void> openLocationSettings() async {}
}
