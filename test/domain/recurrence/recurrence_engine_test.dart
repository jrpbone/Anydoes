import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/repositories/drift_planner_repository.dart';
import 'package:anydoes/domain/models/recurrence_rule.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/recurrence/recurrence_engine.dart';
import 'package:anydoes/domain/recurrence/recurrence_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final engine = RecurrenceEngine();

  test('daily recurrence respects its interval', () {
    final dates = engine.occurrences(
      RecurrenceRule(
        id: 'r',
        frequency: RecurrenceFrequency.daily,
        interval: 2,
      ),
      DateTime(2026, 8, 15),
      DateTime(2026, 8, 20),
    );

    expect(dates, [
      DateTime(2026, 8, 15),
      DateTime(2026, 8, 17),
      DateTime(2026, 8, 19),
    ]);
  });

  test('weekly recurrence uses selected weekdays', () {
    final dates = engine.occurrences(
      RecurrenceRule(
        id: 'r',
        frequency: RecurrenceFrequency.weekly,
        weekdays: {DateTime.friday, DateTime.monday, DateTime.tuesday},
      ),
      DateTime(2026, 8, 14),
      DateTime(2026, 8, 18),
    );

    expect(dates, [
      DateTime(2026, 8, 14),
      DateTime(2026, 8, 17),
      DateTime(2026, 8, 18),
    ]);
  });

  test('monthly recurrence clamps to each month end from the anchor', () {
    final dates = engine.occurrences(
      RecurrenceRule(id: 'r', frequency: RecurrenceFrequency.monthly),
      DateTime(2027, 1, 31),
      DateTime(2027, 3, 31),
    );

    expect(dates, [
      DateTime(2027, 1, 31),
      DateTime(2027, 2, 28),
      DateTime(2027, 3, 31),
    ]);
  });

  test('yearly recurrence restores leap day when available', () {
    final dates = engine.occurrences(
      RecurrenceRule(id: 'r', frequency: RecurrenceFrequency.yearly),
      DateTime(2028, 2, 29),
      DateTime(2032, 2, 29),
    );

    expect(dates, [
      DateTime(2028, 2, 29),
      DateTime(2029, 2, 28),
      DateTime(2030, 2, 28),
      DateTime(2031, 2, 28),
      DateTime(2032, 2, 29),
    ]);
  });

  test('end date and occurrence count are inclusive caps', () {
    final dates = engine.occurrences(
      RecurrenceRule(
        id: 'r',
        frequency: RecurrenceFrequency.daily,
        until: DateTime(2026, 8, 20),
        occurrenceCount: 3,
      ),
      DateTime(2026, 8, 15),
      DateTime(2026, 8, 30),
    );

    expect(dates, [
      DateTime(2026, 8, 15),
      DateTime(2026, 8, 16),
      DateTime(2026, 8, 17),
    ]);
  });

  test(
    'materialization is idempotent and bounded to 90 display days',
    () async {
      final database = AppDatabase.forTesting(
        NativeDatabase.memory(
          setup: (raw) => raw.execute('PRAGMA foreign_keys = ON'),
        ),
      );
      addTearDown(database.close);
      final repository = DriftPlannerRepository(database);
      await repository.initializeDefaults();
      final now = DateTime.utc(2026, 8, 15, 8);
      final rule = RecurrenceRule(
        id: 'daily-rule',
        frequency: RecurrenceFrequency.daily,
      );
      await repository.saveRecurrenceRule(rule);
      await repository.saveTask(
        PlannerTask.create(
          id: 'seed',
          title: 'Morning reset',
          listId: 'inbox',
          recurrenceRuleId: rule.id,
          recurrenceSeriesId: 'series-1',
          occurrenceDate: DateTime.utc(2026, 8, 15),
          createdAt: now,
        ),
      );
      var nextId = 0;
      final service = RecurrenceService(
        repository,
        engine,
        FixedAppClock(now),
        idFactory: () => 'occurrence-${nextId++}',
      );

      await service.materializeThrough(DateTime.utc(2027, 1, 1));
      final firstCount = (await repository.currentSnapshot()).tasks.length;
      await service.materializeThrough(DateTime.utc(2027, 1, 1));
      final snapshot = await repository.currentSnapshot();

      expect(firstCount, 90);
      expect(snapshot.tasks, hasLength(90));
      expect(
        snapshot.tasks
            .map((task) => task.occurrenceDate)
            .whereType<DateTime>()
            .reduce((a, b) => a.isAfter(b) ? a : b),
        DateTime.utc(2026, 11, 12),
      );
    },
  );
}
