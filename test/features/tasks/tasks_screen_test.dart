import 'package:anydoes/app/anydoes_app.dart';
import 'package:anydoes/app/providers.dart';
import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/repositories/drift_planner_repository.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/recurrence_rule.dart';
import 'package:anydoes/features/tasks/tasks_controller.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DriftPlannerRepository repository;
  final now = DateTime.utc(2026, 8, 15, 8);

  setUp(() async {
    database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (raw) => raw.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    repository = DriftPlannerRepository(database);
    await repository.initializeDefaults();
  });

  tearDown(() => database.close());

  Future<void> pumpTasks(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
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
    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();
  }

  testWidgets('quick capture stores a title-only inbox task', (tester) async {
    await pumpTasks(tester);

    await tester.enterText(
      find.byKey(const Key('quick-capture-field')),
      'Plan launch',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Plan launch'), findsOneWidget);
    final saved = (await repository.currentSnapshot()).tasks.single;
    expect(saved.listId, 'inbox');
    expect(saved.estimatedMinutes, isNull);
  });

  testWidgets('search filters visible tasks without deleting them', (
    tester,
  ) async {
    await repository.saveTasks([
      PlannerTask.create(
        id: 'a',
        title: 'Buy groceries',
        listId: 'inbox',
        createdAt: now,
      ),
      PlannerTask.create(
        id: 'b',
        title: 'Review budget',
        listId: 'inbox',
        createdAt: now,
      ),
    ]);
    await pumpTasks(tester);

    await tester.enterText(
      find.byKey(const Key('task-search-field')),
      'budget',
    );
    await tester.pumpAndSettle();

    expect(find.text('Review budget'), findsOneWidget);
    expect(find.text('Buy groceries'), findsNothing);
    expect((await repository.currentSnapshot()).tasks, hasLength(2));
  });

  test('controller creates a detailed task with planning fields', () async {
    final controller = TasksController(repository, FixedAppClock(now));
    addTearDown(controller.dispose);

    await controller.createTask(
      const TaskDraft(
        title: 'Deep work',
        notes: 'Draft the proposal',
        listId: 'inbox',
        priority: TaskPriority.high,
        estimatedMinutes: 120,
        allowSplit: true,
        minimumSessionMinutes: 30,
        maximumSessionMinutes: 60,
      ),
    );

    final saved = (await repository.currentSnapshot()).tasks.single;
    expect(saved.priority, TaskPriority.high);
    expect(saved.estimatedMinutes, 120);
    expect(saved.allowSplit, isTrue);
    expect(saved.minimumSessionMinutes, 30);
    expect(saved.maximumSessionMinutes, 60);
  });

  test(
    'controller creates a recurrence rule with its first occurrence',
    () async {
      final controller = TasksController(repository, FixedAppClock(now));
      addTearDown(controller.dispose);

      await controller.createTask(
        const TaskDraft(
          title: 'Weekly review',
          recurrence: RecurrenceDraft(
            frequency: RecurrenceFrequency.weekly,
            weekdays: {DateTime.saturday},
          ),
        ),
      );

      final snapshot = await repository.currentSnapshot();
      expect(
        snapshot.recurrenceRules.single.frequency,
        RecurrenceFrequency.weekly,
      );
      expect(
        snapshot.tasks.single.recurrenceRuleId,
        snapshot.recurrenceRules.single.id,
      );
      expect(snapshot.tasks.single.recurrenceSeriesId, isNotNull);
      expect(snapshot.tasks.single.occurrenceDate, DateTime.utc(2026, 8, 15));
    },
  );

  test(
    'controller completes an unestimated task without inventing duration',
    () async {
      await repository.saveTask(
        PlannerTask.create(
          id: 'unestimated',
          title: 'Call the dentist',
          listId: 'inbox',
          createdAt: now,
        ),
      );
      final controller = TasksController(repository, FixedAppClock(now));
      addTearDown(controller.dispose);
      final task = (await repository.currentSnapshot()).tasks.single;

      await controller.toggleComplete(task, true);

      final saved = (await repository.currentSnapshot()).tasks.single;
      expect(saved.status, TaskStatus.completed);
      expect(saved.remainingMinutes, isNull);
    },
  );
}
