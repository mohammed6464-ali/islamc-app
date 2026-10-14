import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'magnetic_declination.dart';
import 'qibla_calculation_service.dart';

enum CompassAccuracy { unavailable, uncalibrated, low, medium, high, unknown }

class CompassReading {
  const CompassReading({
    required this.magneticHeading,
    required this.trueHeading,
    required this.accuracy,
    required this.declinationApplied,
    this.messageAr,
  });

  const CompassReading.unavailable()
    : magneticHeading = null,
      trueHeading = null,
      accuracy = CompassAccuracy.unavailable,
      declinationApplied = false,
      messageAr =
          'مستشعر البوصلة غير متاح على هذا الجهاز. اتجاه القبلة محسوب، '
          'لكن السهم لن يتبع دوران الهاتف.';

  final double? magneticHeading;
  final double? trueHeading;
  final CompassAccuracy accuracy;
  final bool declinationApplied;
  final String? messageAr;

  bool get hasHeading => QiblaCalculationService.isFiniteHeading(trueHeading);

  String get accuracyLabelAr => switch (accuracy) {
    CompassAccuracy.unavailable => 'غير متاحة',
    CompassAccuracy.uncalibrated => 'تحتاج معايرة',
    CompassAccuracy.low => 'ضعيفة',
    CompassAccuracy.medium => 'متوسطة',
    CompassAccuracy.high => 'جيدة',
    CompassAccuracy.unknown => 'غير متاحة',
  };
}

abstract class CompassSensor {
  Stream<CompassReading> headings({
    required double latitude,
    required double longitude,
  });
}

/// Device compass. [flutter_compass] reports magnetic heading; we add an
/// estimated declination so the Qibla (true north) is not mixed raw.
class FlutterCompassSensor implements CompassSensor {
  FlutterCompassSensor({MagneticDeclination? declination})
    : _declination = declination ?? const MagneticDeclination();

  final MagneticDeclination _declination;

  @override
  Stream<CompassReading> headings({
    required double latitude,
    required double longitude,
  }) {
    final Stream<CompassEvent>? events = FlutterCompass.events;
    if (events == null) {
      return Stream<CompassReading>.value(const CompassReading.unavailable());
    }
    final double declination = _declination.degrees(
      latitude: latitude,
      longitude: longitude,
    );
    return events.map((CompassEvent event) {
      final double? magnetic = event.heading;
      if (!QiblaCalculationService.isFiniteHeading(magnetic)) {
        return const CompassReading.unavailable();
      }
      final CompassAccuracy accuracy = mapAccuracy(event.accuracy);
      final double trueHeading = QiblaCalculationService.normalize(
        magnetic! + declination,
      );
      return CompassReading(
        magneticHeading: QiblaCalculationService.normalize(magnetic),
        trueHeading: trueHeading,
        accuracy: accuracy,
        declinationApplied: true,
        messageAr: _message(accuracy),
      );
    });
  }

  @visibleForTesting
  static CompassAccuracy mapAccuracy(double? accuracy) {
    if (accuracy == null) {
      return CompassAccuracy.unknown;
    }
    // Android SensorManager statuses are 0–3; some builds emit degrees of error.
    if (accuracy < 0) {
      return CompassAccuracy.uncalibrated;
    }
    if (accuracy <= 3) {
      return switch (accuracy.round()) {
        0 => CompassAccuracy.uncalibrated,
        1 => CompassAccuracy.low,
        2 => CompassAccuracy.medium,
        _ => CompassAccuracy.high,
      };
    }
    if (accuracy > 25) {
      return CompassAccuracy.low;
    }
    if (accuracy > 12) {
      return CompassAccuracy.medium;
    }
    return CompassAccuracy.high;
  }

  static String? _message(CompassAccuracy accuracy) {
    return switch (accuracy) {
      CompassAccuracy.unavailable =>
        'مستشعر البوصلة غير متاح على هذا الجهاز.',
      CompassAccuracy.uncalibrated || CompassAccuracy.low =>
        'حركة على شكل ∞ في الهواء بعيدًا عن المعادن لإعادة معايرة البوصلة.',
      CompassAccuracy.unknown =>
        'دقة المستشعر غير متاحة. أبعد الهاتف عن المغناطيس وضعه بشكل أفقي.',
      CompassAccuracy.medium || CompassAccuracy.high => null,
    };
  }
}

class FakeCompassSensor implements CompassSensor {
  FakeCompassSensor([this._readings = const <CompassReading>[]]);

  final List<CompassReading> _readings;
  final StreamController<CompassReading> controller =
      StreamController<CompassReading>.broadcast();

  void emit(CompassReading reading) => controller.add(reading);

  @override
  Stream<CompassReading> headings({
    required double latitude,
    required double longitude,
  }) async* {
    for (final CompassReading reading in _readings) {
      yield reading;
    }
    yield* controller.stream;
  }
}
