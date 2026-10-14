import 'package:flutter_test/flutter_test.dart';
import 'package:islmac_app/core/data/demo_data.dart';
import 'package:islmac_app/core/qibla/compass_sensor.dart';
import 'package:islmac_app/core/qibla/qibla_calculation_service.dart';

void main() {
  const QiblaCalculationService service = QiblaCalculationService();

  test('normalizes angles into 0–360', () {
    expect(QiblaCalculationService.normalize(0), 0);
    expect(QiblaCalculationService.normalize(360), 0);
    expect(QiblaCalculationService.normalize(361), 1);
    expect(QiblaCalculationService.normalize(-90), 270);
    expect(QiblaCalculationService.normalize(720.5), 0.5);
  });

  test('shortest difference crosses 0/360 without a long turn', () {
    expect(QiblaCalculationService.shortestDifference(350, 10), 20);
    expect(QiblaCalculationService.shortestDifference(10, 350), -20);
    expect(
      QiblaCalculationService.shortestDifference(0, 180).abs(),
      180,
    );
    expect(
      QiblaCalculationService.shortestDifference(180, 0).abs(),
      180,
    );
    expect(
      QiblaCalculationService.lerpAngle(350, 10, 0.5),
      closeTo(0, 0.001),
    );
  });

  test('rejects invalid sensor headings', () {
    expect(QiblaCalculationService.isFiniteHeading(null), isFalse);
    expect(QiblaCalculationService.isFiniteHeading(double.nan), isFalse);
    expect(QiblaCalculationService.isFiniteHeading(double.infinity), isFalse);
    expect(QiblaCalculationService.isFiniteHeading(244.5), isTrue);
  });

  test('Riyadh qibla is southwest of true north', () {
    final QiblaResult result = service.calculate(
      latitude: DemoData.riyadh.latitude,
      longitude: DemoData.riyadh.longitude,
    );
    expect(result.bearing, inInclusiveRange(242, 247));
    expect(result.directionLabel, 'جنوب غرب');
    expect(result.distanceKm, inInclusiveRange(780, 920));
    expect(result.label, contains('°'));
  });

  test('Jeddah qibla is east of true north', () {
    final QiblaResult result = service.calculate(
      latitude: DemoData.cityById('jeddah').latitude,
      longitude: DemoData.cityById('jeddah').longitude,
    );
    expect(result.bearing, inInclusiveRange(95, 110));
    expect(result.directionLabel, anyOf('شرق', 'جنوب شرق'));
    expect(result.distanceKm, inInclusiveRange(60, 90));
  });

  test('Madinah qibla is nearly due south', () {
    final QiblaResult result = service.calculate(
      latitude: DemoData.cityById('madinah').latitude,
      longitude: DemoData.cityById('madinah').longitude,
    );
    expect(result.bearing, inInclusiveRange(170, 185));
    expect(result.directionLabel, anyOf('جنوب', 'جنوب شرق', 'جنوب غرب'));
    expect(result.distanceKm, inInclusiveRange(320, 450));
  });

  test('Dammam qibla is southwest', () {
    final QiblaResult result = service.calculate(
      latitude: DemoData.cityById('dammam').latitude,
      longitude: DemoData.cityById('dammam').longitude,
    );
    expect(result.bearing, inInclusiveRange(244, 252));
    expect(result.directionLabel, 'جنوب غرب');
    expect(result.distanceKm, greaterThan(1000));
  });

  test('Cairo qibla is southeast', () {
    final QiblaResult result = service.calculate(
      latitude: 30.0444,
      longitude: 31.2357,
    );
    expect(result.bearing, inInclusiveRange(130, 142));
    expect(result.directionLabel, 'جنوب شرق');
    expect(result.distanceKm, inInclusiveRange(1200, 1350));
  });

  test('location changes update the bearing', () {
    final double riyadh = service
        .calculate(
          latitude: DemoData.riyadh.latitude,
          longitude: DemoData.riyadh.longitude,
        )
        .bearing;
    final double jeddah = service
        .calculate(
          latitude: DemoData.cityById('jeddah').latitude,
          longitude: DemoData.cityById('jeddah').longitude,
        )
        .bearing;
    expect((riyadh - jeddah).abs(), greaterThan(90));
  });

  test('coordinates on the Kaaba itself do not invent a fake bearing', () {
    final QiblaResult result = service.calculate(
      latitude: QiblaCalculationService.kaabaLatitude,
      longitude: QiblaCalculationService.kaabaLongitude,
    );
    expect(result.directionLabel, 'اتجاه الكعبة');
    expect(result.distanceKm, 0);
  });

  test('sensor accuracy mapping never reports a fake excellent score', () {
    expect(FlutterCompassSensor.mapAccuracy(null), CompassAccuracy.unknown);
    expect(FlutterCompassSensor.mapAccuracy(-1), CompassAccuracy.uncalibrated);
    expect(FlutterCompassSensor.mapAccuracy(0), CompassAccuracy.uncalibrated);
    expect(FlutterCompassSensor.mapAccuracy(1), CompassAccuracy.low);
    expect(FlutterCompassSensor.mapAccuracy(2), CompassAccuracy.medium);
    expect(FlutterCompassSensor.mapAccuracy(3), CompassAccuracy.high);
    expect(FlutterCompassSensor.mapAccuracy(30), CompassAccuracy.low);
    expect(
      const CompassReading.unavailable().accuracyLabelAr,
      'غير متاحة',
    );
  });
}
