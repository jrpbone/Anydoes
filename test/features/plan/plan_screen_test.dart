import 'package:anydoes/app/anydoes_app.dart';
import 'package:anydoes/app/providers.dart';
import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/repositories/drift_planner_repository.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 8, 17, 8, 2);

  Future<DriftPlannerRepository> pumpPlan(
    WidgetTester tester,
    double width, {
    int taskMinutes = 60,
  }) async {
    final database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (raw) => raw.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    addTearDown(database.close);
    final repository = DriftPlannerRepository(database);
    await repository.initializeDefaults();
    await repository.saveTask(
      PlannerTask.create(
        id: 'task-1',
        title: 'Draft proposal',
        listId: 'inbox',
        estimatedMinutes: taskMinutes,
        createdAt: now,
      ),
    );
    await tester.binding.setSurfaceSize(Size(width, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          plannerRepositoryProvider.overrideWithValue(repository),
          appClockProvider.overrideWithValue(FixedAppClock(now)),
        ],
        child: const AnydoesApp(),
      ),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('compact plan uses a day timeline and queue sheet action', (
    tester,
  ) async {
    await pumpPlan(tester, 390);

    expect(find.byKey(const Key('day-timeline')), findsOneWidget);
    expect(find.byKey(const Key('open-task-queue')), findsOneWidget);
    expect(find.byKey(const Key('week-calendar')), findsNothing);
  });

  testWidgets('medium plan keeps day timeline and task queue side by side', (
    tester,
  ) async {
    await pumpPlan(tester, 800);

    expect(find.byKey(const Key('day-timeline')), findsOneWidget);
    expect(find.byKey(const Key('persistent-task-queue')), findsOneWidget);
  });

  testWidgets('expanded plan shows a seven-day week and persistent queue', (
    tester,
  ) async {
    await pumpPlan(tester, 1440);

    expect(find.byKey(const Key('week-calendar')), findsOneWidget);
    expect(find.byKey(const Key('persistent-task-queue')), findsOneWidget);
    for (var day = 0; day < 7; day++) {
      expect(find.byKey(Key('week-day-$day')), findsOneWidget);
    }
  });

  testWidgets(
    'proposal is visibly distinct and remains optional until accepted',
    (tester) async {
      final repository = await pumpPlan(tester, 800);

      await tester.tap(find.widgetWithText(FilledButton, 'Plan my tasks'));
      await tester.pumpAndSettle();

      expect(find.text('Proposed'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Accept all'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Discard'), findsOneWidget);
      expect((await repository.currentSnapshot()).blocks, isEmpty);

      await tester.tap(find.widgetWithText(FilledButton, 'Accept all'));
      await tester.pumpAndSettle();
      expect((await repository.currentSnapshot()).blocks, hasLength(1));
    },
  );

  testWidgets('impossible work displays missing time and recovery actions', (
    tester,
  ) async {
    await pumpPlan(tester, 800, taskMinutes: 600);

    await tester.tap(find.widgetWithText(FilledButton, 'Plan my tasks'));
    await tester.pumpAndSettle();

    expect(find.textContaining('600 min'), findsOneWidget);
    expect(find.text('Make splittable'), findsOneWidget);
    expect(find.text('Find next slot'), findsOneWidget);
  });
}
