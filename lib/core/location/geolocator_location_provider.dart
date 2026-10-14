import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'location_failure.dart';
import 'location_provider.dart';

class GeolocatorLocationProvider implements LocationProvider {
  const GeolocatorLocationProvider();

  @override
  Future<bool> isServiceEnabled() => Geolocator.isLocationServiceEnabled();

  @override
  Future<AppPermissionStatus> checkPermission() async {
    return _map(await Geolocator.checkPermission());
  }

  @override
  Future<AppPermissionStatus> requestPermission() async {
    return _map(await Geolocator.requestPermission());
  }

  @override
  Future<GeoFix> getCurrentPosition({
    Duration timeout = const Duration(seconds: 15),
  }) async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: timeout,
        ),
      );
      return GeoFix(latitude: position.latitude, longitude: position.longitude);
    } on TimeoutException {
      throw LocationFailure.timeout;
    } on LocationServiceDisabledException {
      throw LocationFailure.serviceDisabled;
    } on PermissionDeniedException {
      throw LocationFailure.denied;
    } catch (_) {
      final Position? last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        return GeoFix(latitude: last.latitude, longitude: last.longitude);
      }
      throw LocationFailure.unavailable;
    }
  }

  @override
  Future<GeoPlace?> reverseGeocode(double latitude, double longitude) async {
    try {
      await setLocaleIdentifier('ar_SA');
      final List<Placemark> marks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (marks.isEmpty) {
        return null;
      }
      final Placemark mark = marks.first;
      final String city =
          (mark.locality != null && mark.locality!.trim().isNotEmpty)
          ? mark.locality!.trim()
          : (mark.subAdministrativeArea ?? mark.administrativeArea ?? '')
                .trim();
      final String country = (mark.country ?? '').trim();
      if (city.isEmpty && country.isEmpty) {
        return null;
      }
      return GeoPlace(
        cityName: city.isEmpty ? 'موقع غير مسمّى' : city,
        countryName: country.isEmpty ? 'المملكة العربية السعودية' : country,
        isoCountryCode: mark.isoCountryCode,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Future<void> openAppSettings() => Geolocator.openAppSettings();

  static AppPermissionStatus _map(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.denied => AppPermissionStatus.denied,
      LocationPermission.deniedForever => AppPermissionStatus.deniedForever,
      LocationPermission.whileInUse => AppPermissionStatus.whileInUse,
      LocationPermission.always => AppPermissionStatus.always,
      LocationPermission.unableToDetermine => AppPermissionStatus.denied,
    };
  }
}
