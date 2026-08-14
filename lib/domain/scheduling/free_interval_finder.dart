import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/schedule_block.dart';

final class FreeInterval {
  const FreeInterval(this.start, this.end);

  final DateTime start;
  final DateTime end;
  Duration get duration => end.difference(start);
}

final class FreeIntervalFinder {
  const FreeIntervalFinder();

  List<FreeInterval> find({
    required DateTime start,
    required DateTime end,
    required List<AvailabilityWindow> weekly,
    required List<AvailabilityException> exceptions,
    required List<ScheduleBlock> occupied,
  }) {
    final exceptionByDate = {
      for (final exception in exceptions) _dateKey(exception.date): exception,
    };
    final busy = [...occupied]..sort((a, b) => a.start.compareTo(b.start));
    final free = <FreeInterval>[];
    var date = _dateOnly(start);
    final lastDate = _dateOnly(end);
    while (!date.isAfter(lastDate)) {
      final exception = exceptionByDate[_dateKey(date)];
      final windows =
          exception?.windows ??
          weekly.where((window) => window.weekday == date.weekday).toList();
      for (final window in windows) {
        var windowStart = _atMinute(date, window.startMinute);
        var windowEnd = _atMinute(date, window.endMinute);
        if (windowStart.isBefore(start)) windowStart = start;
        if (windowEnd.isAfter(end)) windowEnd = end;
        if (!windowEnd.isAfter(windowStart)) continue;
        var pieces = [FreeInterval(windowStart, windowEnd)];
        for (final block in busy) {
          if (!block.end.isAfter(windowStart) ||
              !block.start.isBefore(windowEnd)) {
            continue;
          }
          pieces = _subtract(pieces, block.start, block.end);
          if (pieces.isEmpty) break;
        }
        free.addAll(pieces);
      }
      date = _calendarDate(date.year, date.month, date.day + 1, date.isUtc);
    }
    free.sort((a, b) => a.start.compareTo(b.start));
    return List.unmodifiable(free);
  }

  List<FreeInterval> _subtract(
    List<FreeInterval> source,
    DateTime busyStart,
    DateTime busyEnd,
  ) {
    final result = <FreeInterval>[];
    for (final interval in source) {
      if (!busyEnd.isAfter(interval.start) ||
          !busyStart.isBefore(interval.end)) {
        result.add(interval);
        continue;
      }
      if (busyStart.isAfter(interval.start)) {
        result.add(FreeInterval(interval.start, busyStart));
      }
      if (busyEnd.isBefore(interval.end)) {
        result.add(FreeInterval(busyEnd, interval.end));
      }
    }
    return result;
  }
}

DateTime _dateOnly(DateTime value) =>
    _calendarDate(value.year, value.month, value.day, value.isUtc);

DateTime _atMinute(DateTime date, int minute) => _calendarDate(
  date.year,
  date.month,
  date.day,
  date.isUtc,
).add(Duration(minutes: minute));

DateTime _calendarDate(int year, int month, int day, bool utc) =>
    utc ? DateTime.utc(year, month, day) : DateTime(year, month, day);

String _dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
