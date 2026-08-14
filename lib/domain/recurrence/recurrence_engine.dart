import 'dart:math' as math;

import 'package:anydoes/domain/models/recurrence_rule.dart';

final class RecurrenceEngine {
  List<DateTime> occurrences(
    RecurrenceRule rule,
    DateTime anchor,
    DateTime through,
  ) {
    final start = _dateOnly(anchor);
    final end = _dateOnly(through);
    if (end.isBefore(start)) return const [];
    final until = rule.until == null
        ? null
        : _inAnchorZone(rule.until!, start.isUtc);
    final effectiveEnd = until != null && until.isBefore(end) ? until : end;
    if (effectiveEnd.isBefore(start)) return const [];

    final results = <DateTime>[];
    var candidate = start;
    while (!candidate.isAfter(effectiveEnd)) {
      if (_matches(rule, start, candidate)) {
        results.add(candidate);
        if (rule.occurrenceCount != null &&
            results.length >= rule.occurrenceCount!) {
          break;
        }
      }
      candidate = _calendarDate(
        candidate.year,
        candidate.month,
        candidate.day + 1,
        candidate.isUtc,
      );
    }
    return List.unmodifiable(results);
  }

  bool _matches(RecurrenceRule rule, DateTime anchor, DateTime candidate) {
    return switch (rule.frequency) {
      RecurrenceFrequency.daily =>
        candidate.difference(anchor).inDays % rule.interval == 0,
      RecurrenceFrequency.weekly => _matchesWeekly(rule, anchor, candidate),
      RecurrenceFrequency.monthly => _matchesMonthly(rule, anchor, candidate),
      RecurrenceFrequency.yearly => _matchesYearly(rule, anchor, candidate),
    };
  }

  bool _matchesWeekly(
    RecurrenceRule rule,
    DateTime anchor,
    DateTime candidate,
  ) {
    final anchorWeek = _calendarDate(
      anchor.year,
      anchor.month,
      anchor.day - (anchor.weekday - DateTime.monday),
      anchor.isUtc,
    );
    final candidateWeek = _calendarDate(
      candidate.year,
      candidate.month,
      candidate.day - (candidate.weekday - DateTime.monday),
      candidate.isUtc,
    );
    final weekDifference = candidateWeek.difference(anchorWeek).inDays ~/ 7;
    final selectedDays = rule.weekdays.isEmpty
        ? {anchor.weekday}
        : rule.weekdays;
    return weekDifference % rule.interval == 0 &&
        selectedDays.contains(candidate.weekday);
  }

  bool _matchesMonthly(
    RecurrenceRule rule,
    DateTime anchor,
    DateTime candidate,
  ) {
    final monthDifference =
        (candidate.year - anchor.year) * 12 + candidate.month - anchor.month;
    final targetDay = math.min(
      anchor.day,
      _daysInMonth(candidate.year, candidate.month),
    );
    return monthDifference % rule.interval == 0 && candidate.day == targetDay;
  }

  bool _matchesYearly(
    RecurrenceRule rule,
    DateTime anchor,
    DateTime candidate,
  ) {
    final yearDifference = candidate.year - anchor.year;
    if (yearDifference % rule.interval != 0 ||
        candidate.month != anchor.month) {
      return false;
    }
    return candidate.day ==
        math.min(anchor.day, _daysInMonth(candidate.year, anchor.month));
  }
}

int _daysInMonth(int year, int month) => DateTime.utc(year, month + 1, 0).day;

DateTime _dateOnly(DateTime value) =>
    _calendarDate(value.year, value.month, value.day, value.isUtc);

DateTime _inAnchorZone(DateTime value, bool utc) =>
    _calendarDate(value.year, value.month, value.day, utc);

DateTime _calendarDate(int year, int month, int day, bool utc) =>
    utc ? DateTime.utc(year, month, day) : DateTime(year, month, day);
