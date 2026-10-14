/// Injectable clock so tests can freeze or advance time without the device.
abstract class AppClock {
  const AppClock();

  /// Current instant in UTC.
  DateTime nowUtc();
}

class SystemClock implements AppClock {
  const SystemClock();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();
}

/// Mutable clock used by unit and widget tests.
class FakeClock implements AppClock {
  FakeClock(DateTime nowUtc) : _nowUtc = nowUtc.toUtc();

  DateTime _nowUtc;

  @override
  DateTime nowUtc() => _nowUtc;

  void setUtc(DateTime value) => _nowUtc = value.toUtc();

  void add(Duration duration) => _nowUtc = _nowUtc.add(duration);
}
