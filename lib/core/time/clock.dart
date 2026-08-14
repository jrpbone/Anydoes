abstract interface class AppClock {
  DateTime now();
}

final class SystemAppClock implements AppClock {
  const SystemAppClock();

  @override
  DateTime now() => DateTime.now().toUtc();
}

final class FixedAppClock implements AppClock {
  FixedAppClock(DateTime value) : _value = value.toUtc();

  final DateTime _value;

  @override
  DateTime now() => _value;
}
