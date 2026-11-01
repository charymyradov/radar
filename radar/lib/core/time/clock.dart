/// Time source abstraction so speed maths can be tested deterministically.
///
/// Speed is always derived from a *monotonic* clock (never from frame counts)
/// because a dropped frame must not change the measured speed.
abstract class Clock {
  /// Wall clock, used to stamp recorded events.
  DateTime nowUtc();

  /// Monotonic microseconds since an arbitrary epoch (process start).
  int monotonicMicros();
}

/// Production clock: `Stopwatch` is monotonic, `DateTime` is wall clock.
class SystemClock implements Clock {
  SystemClock() {
    _stopwatch.start();
  }

  final Stopwatch _stopwatch = Stopwatch();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();

  @override
  int monotonicMicros() => _stopwatch.elapsedMicroseconds;
}

/// Local wall clock (kept for display formatting).
DateTime localNow() => DateTime.now();
