enum LocationFailureKind {
  serviceDisabled,
  denied,
  deniedForever,
  timeout,
  unavailable,
  geocodingFailed,
}

class LocationFailure implements Exception {
  const LocationFailure(this.kind, this.messageAr);

  final LocationFailureKind kind;
  final String messageAr;

  static const LocationFailure serviceDisabled = LocationFailure(
    LocationFailureKind.serviceDisabled,
    'خدمة الموقع مغلقة على الجهاز. فعّلها من الإعدادات أو اختر المدينة يدويًا.',
  );

  static const LocationFailure denied = LocationFailure(
    LocationFailureKind.denied,
    'لم يتم السماح بالوصول إلى الموقع. يمكنك اختيار المدينة يدويًا.',
  );

  static const LocationFailure deniedForever = LocationFailure(
    LocationFailureKind.deniedForever,
    'إذن الموقع مرفوض. فعّله من إعدادات التطبيق أو اختر المدينة يدويًا.',
  );

  static const LocationFailure timeout = LocationFailure(
    LocationFailureKind.timeout,
    'انتهت مهلة تحديد الموقع. حاول مجددًا أو اختر المدينة يدويًا.',
  );

  static const LocationFailure unavailable = LocationFailure(
    LocationFailureKind.unavailable,
    'تعذر تحديد الموقع حاليًا. يمكنك اختيار المدينة يدويًا.',
  );

  static const LocationFailure geocodingFailed = LocationFailure(
    LocationFailureKind.geocodingFailed,
    'تم تحديد الإحداثيات لكن تعذر معرفة اسم المدينة. سنعتمد أقرب مدينة معروفة.',
  );

  @override
  String toString() => messageAr;
}

enum AppPermissionStatus { denied, deniedForever, whileInUse, always }

extension AppPermissionStatusX on AppPermissionStatus {
  bool get isGranted =>
      this == AppPermissionStatus.whileInUse ||
      this == AppPermissionStatus.always;
}
