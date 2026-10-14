enum LocationSelectionMode { automatic, manual }

/// Single source of truth for the coordinates used in prayer calculations.
class AppLocation {
  const AppLocation({
    required this.latitude,
    required this.longitude,
    required this.cityName,
    required this.countryName,
    required this.timezoneId,
    required this.selectionMode,
    required this.lastUpdated,
    this.catalogId,
    this.fromCache = false,
  });

  final double latitude;
  final double longitude;
  final String cityName;
  final String countryName;
  final String timezoneId;
  final LocationSelectionMode selectionMode;
  final DateTime lastUpdated;

  /// Matching Saudi catalog city when the location was chosen from the list
  /// or snapped from GPS. Null for a custom GPS reading.
  final String? catalogId;

  /// True when this is the last known fix because a live refresh failed.
  final bool fromCache;

  bool get isAutomatic => selectionMode == LocationSelectionMode.automatic;

  String get fullName => '$cityName، $countryName';

  AppLocation copyWith({
    double? latitude,
    double? longitude,
    String? cityName,
    String? countryName,
    String? timezoneId,
    LocationSelectionMode? selectionMode,
    DateTime? lastUpdated,
    String? catalogId,
    bool? fromCache,
  }) {
    return AppLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
      timezoneId: timezoneId ?? this.timezoneId,
      selectionMode: selectionMode ?? this.selectionMode,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      catalogId: catalogId ?? this.catalogId,
      fromCache: fromCache ?? this.fromCache,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'latitude': latitude,
    'longitude': longitude,
    'cityName': cityName,
    'countryName': countryName,
    'timezoneId': timezoneId,
    'selectionMode': selectionMode.name,
    'lastUpdated': lastUpdated.toIso8601String(),
    'catalogId': catalogId,
  };

  static AppLocation fromJson(Map<String, Object?> json) {
    return AppLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      cityName: json['cityName'] as String,
      countryName: json['countryName'] as String,
      timezoneId: json['timezoneId'] as String? ?? 'Asia/Riyadh',
      selectionMode: LocationSelectionMode.values.firstWhere(
        (LocationSelectionMode m) => m.name == json['selectionMode'],
        orElse: () => LocationSelectionMode.manual,
      ),
      lastUpdated:
          DateTime.tryParse(json['lastUpdated'] as String? ?? '') ??
          DateTime.now().toUtc(),
      catalogId: json['catalogId'] as String?,
      fromCache: true,
    );
  }
}
