import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/scheduling/free_interval_finder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const finder = FreeIntervalFinder();

  test(
    'subtracts occupied blocks from availability in chronological order',
    () {
      final monday = DateTime.utc(2026, 8, 17, 8, 2);
      final intervals = finder.find(
        start: monday,
        end: DateTime.utc(2026, 8, 18),
        weekly: [
          AvailabilityWindow(
            weekday: DateTime.monday,
            startMinute: 9 * 60,
            endMinute: 17 * 60,
          ),
        ],
        exceptions: const [],
        occupied: [
          ScheduleBlock(
            id: 'fixed',
            start: DateTime.utc(2026, 8, 17, 10),
            end: DateTime.utc(2026, 8, 17, 11),
            isGenerated: false,
          ),
        ],
      );

      expect(intervals, hasLength(2));
      expect(intervals[0].start, DateTime.utc(2026, 8, 17, 9));
      expect(intervals[0].end, DateTime.utc(2026, 8, 17, 10));
      expect(intervals[1].start, DateTime.utc(2026, 8, 17, 11));
      expect(intervals[1].end, DateTime.utc(2026, 8, 17, 17));
    },
  );

  test('a date exception replaces the weekly rule', () {
    final date = DateTime.utc(2026, 8, 17);
    final intervals = finder.find(
      start: date,
      end: date.add(const Duration(days: 1)),
      weekly: [
        AvailabilityWindow(
          weekday: DateTime.monday,
          startMinute: 9 * 60,
          endMinute: 17 * 60,
        ),
      ],
      exceptions: [AvailabilityException(date: date, windows: const [])],
      occupied: const [],
    );

    expect(intervals, isEmpty);
  });
}
