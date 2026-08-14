final class AvailabilityWindow {
  AvailabilityWindow({
    required this.weekday,
    required this.startMinute,
    required this.endMinute,
  }) {
    if (weekday < DateTime.monday || weekday > DateTime.sunday) {
      throw ArgumentError.value(weekday, 'weekday', 'Must be 1 through 7');
    }
    if (startMinute < 0 || startMinute >= 1440) {
      throw ArgumentError.value(
        startMinute,
        'startMinute',
        'Must be within a day',
      );
    }
    if (endMinute <= startMinute || endMinute > 1440) {
      throw ArgumentError.value(
        endMinute,
        'endMinute',
        'Must follow start within the day',
      );
    }
  }

  final int weekday;
  final int startMinute;
  final int endMinute;
}

final class AvailabilityException {
  AvailabilityException({
    required DateTime date,
    required List<AvailabilityWindow> windows,
  }) : date = DateTime(date.year, date.month, date.day),
       windows = List.unmodifiable(windows);

  final DateTime date;
  final List<AvailabilityWindow> windows;
}
