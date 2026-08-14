import 'package:anydoes/app/anydoes_app.dart';
import 'package:anydoes/app/providers.dart';
import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/repositories/drift_planner_repository.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/recurrence_rule.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
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

  testWidgets('full editor exposes planning, subtask, and recurrence fields', (
    tester,
  ) async {
    await repository.saveTask(
      PlannerTask.create(
        id: 'parent',
        title: 'Launch project',
        listId: 'inbox',
        createdAt: now,
      ),
    );
    await pumpTasks(tester);

    await tester.tap(find.byKey(const Key('open-task-editor')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('task-parent-field')), findsOneWidget);
    expect(find.byKey(const Key('task-earliest-field')), findsOneWidget);
    expect(find.byKey(const Key('task-deadline-field')), findsOneWidget);
    expect(find.byKey(const Key('task-recurrence-interval')), findsNothing);

    await tester.ensureVisible(find.byKey(const Key('task-repeat-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('task-repeat-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('weekly').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('task-recurrence-interval')), findsOneWidget);
    expect(find.byKey(const Key('task-weekday-1')), findsOneWidget);
    expect(find.byKey(const Key('task-recurrence-end')), findsOneWidget);
  });

  testWidgets('tapping a task opens an editor that updates the same record', (
    tester,
  ) async {
    await repository.saveTask(
      PlannerTask.create(
        id: 'editable',
        title: 'Original title',
        listId: 'inbox',
        createdAt: now,
      ),
    );
    await pumpTasks(tester);

    await tester.tap(find.text('Original title'));
    await tester.pumpAndSettle();
    expect(find.text('Edit task'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('task-title-field')),
      'Updated title',
    );
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final tasks = (await repository.currentSnapshot()).tasks;
    expect(tasks, hasLength(1));
    expect(tasks.single.id, 'editable');
    expect(tasks.single.title, 'Updated title');
  });

  test('combined priority, assignee, and tag filters are intersected', () {
    const query = TaskQuery(
      status: TaskStatusFilter.all,
      priority: TaskPriority.high,
      assigneeProfileId: 'me',
      tagId: 'focus',
    );
    final matching = PlannerTask.create(
      id: 'match',
      title: 'Matching',
      listId: 'inbox',
      priority: TaskPriority.high,
      assigneeProfileId: 'me',
      tagIds: const {'focus'},
      createdAt: now,
    );
    final wrongTag = PlannerTask.create(
      id: 'wrong',
      title: 'Wrong tag',
      listId: 'inbox',
      priority: TaskPriority.high,
      assigneeProfileId: 'me',
      tagIds: const {'errands'},
      createdAt: now,
    );

    expect(query.matches(matching), isTrue);
    expect(query.matches(wrongTag), isFalse);
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
        snapshot.tasks.every(
          (task) => task.recurrenceRuleId == snapshot.recurrenceRules.single.id,
        ),
        isTrue,
      );
      expect(snapshot.tasks.length, greaterThan(1));
      expect(
        snapshot.tasks.every((task) => task.recurrenceSeriesId != null),
        isTrue,
      );
      expect(
        snapshot.tasks.map((task) => task.occurrenceDate),
        contains(DateTime.utc(2026, 8, 15)),
      );
      expect(
        snapshot.tasks
            .map((task) => task.occurrenceDate!)
            .reduce((left, right) => left.isAfter(right) ? left : right)
            .isAfter(DateTime.utc(2026, 11, 13)),
        isFalse,
      );
    },
  );

  testWidgets('completing a task with a future block requires a choice', (
    tester,
  ) async {
    final task = PlannerTask.create(
      id: 'scheduled',
      title: 'Scheduled work',
      listId: 'inbox',
      estimatedMinutes: 60,
      createdAt: now,
    );
    await repository.saveTask(task);
    await repository.saveBlock(
      ScheduleBlock(
        id: 'future-block',
        taskId: task.id,
        start: now.add(const Duration(days: 1)),
        end: now.add(const Duration(days: 1, hours: 1)),
      ),
    );
    await pumpTasks(tester);

    await tester.tap(find.byType(Checkbox).last);
    await tester.pumpAndSettle();
    expect(find.text('Complete Scheduled work?'), findsOneWidget);
    expect(
      (await repository.currentSnapshot()).tasks.single.status,
      TaskStatus.open,
    );

    await tester.tap(find.text('Complete and remove blocks'));
    await tester.pumpAndSettle();
    final snapshot = await repository.currentSnapshot();
    expect(snapshot.tasks.single.status, TaskStatus.completed);
    expect(snapshot.blocks, isEmpty);
  });

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
