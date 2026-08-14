enum RecurrenceFrequency { daily, weekly, monthly, yearly }

final class RecurrenceRule {
  RecurrenceRule({
    required String id,
    required this.frequency,
    this.interval = 1,
    Set<int> weekdays = const {},
    DateTime? until,
    this.occurrenceCount,
  }) : id = id.trim(),
       weekdays = Set.unmodifiable(weekdays),
       until = until == null
           ? null
           : DateTime(until.year, until.month, until.day) {
    if (this.id.isEmpty) {
      throw ArgumentError.value(id, 'id', 'Required');
    }
    if (interval < 1) {
      throw ArgumentError.value(interval, 'interval', 'Must be positive');
    }
    if (this.weekdays.any((day) => day < 1 || day > 7)) {
      throw ArgumentError.value(
        weekdays,
        'weekdays',
        'Must contain values 1 through 7',
      );
    }
    if (occurrenceCount != null && occurrenceCount! < 1) {
      throw ArgumentError.value(
        occurrenceCount,
        'occurrenceCount',
        'Must be positive',
      );
    }
  }

  final String id;
  final RecurrenceFrequency frequency;
  final int interval;
  final Set<int> weekdays;
  final DateTime? until;
  final int? occurrenceCount;
}
