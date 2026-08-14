import 'package:anydoes/core/result/app_failure.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/repositories/drift_planner_repository.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:drift/native.dart';
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

  PlannerTask task({String id = 'task-1', int minutes = 60}) {
    return PlannerTask.create(
      id: id,
      title: 'Prepare launch notes',
      listId: 'inbox',
      estimatedMinutes: minutes,
      createdAt: now,
    );
  }

  test('initialization seeds Inbox, Me, weekday hours, and defaults', () async {
    final snapshot = await repository.currentSnapshot();

    expect(snapshot.lists.single.id, 'inbox');
    expect(snapshot.lists.single.isInbox, isTrue);
    expect(snapshot.profiles.single.id, 'me');
    expect(snapshot.profiles.single.isMe, isTrue);
    expect(snapshot.weeklyAvailability, hasLength(5));
    expect(snapshot.preferences.horizonDays, 14);
    expect(snapshot.preferences.defaultMinimumSessionMinutes, 25);
    expect(snapshot.preferences.defaultMaximumSessionMinutes, 90);
  });

  test('saving a task updates the persisted snapshot and watcher', () async {
    final nextSnapshot = repository.watchSnapshot().skip(1).first;

    await repository.saveTask(task());

    final persisted = await repository.currentSnapshot();
    expect(persisted.tasks.single.id, 'task-1');
    expect((await nextSnapshot).tasks.single.title, 'Prepare launch notes');
  });

  test(
    'accepting a proposal persists all blocks as accepted atomically',
    () async {
      await repository.saveTask(task(minutes: 90));
      await repository.acceptProposal([
        ScheduleBlock(
          id: 'block-1',
          taskId: 'task-1',
          start: now.add(const Duration(hours: 1)),
          end: now.add(const Duration(hours: 1, minutes: 45)),
          state: ScheduleBlockState.proposed,
        ),
        ScheduleBlock(
          id: 'block-2',
          taskId: 'task-1',
          start: now.add(const Duration(hours: 2)),
          end: now.add(const Duration(hours: 2, minutes: 45)),
          state: ScheduleBlockState.proposed,
        ),
      ]);

      final blocks = (await repository.currentSnapshot()).blocks;
      expect(blocks, hasLength(2));
      expect(
        blocks.every((block) => block.state == ScheduleBlockState.accepted),
        isTrue,
      );
    },
  );

  test('completing a block reduces remaining task duration once', () async {
    await repository.saveTask(task());
    await repository.saveBlock(
      ScheduleBlock(
        id: 'block-1',
        taskId: 'task-1',
        start: now,
        end: now.add(const Duration(minutes: 25)),
      ),
    );

    await repository.completeBlock(
      'block-1',
      now.add(const Duration(minutes: 25)),
    );
    await repository.completeBlock(
      'block-1',
      now.add(const Duration(minutes: 25)),
    );

    final snapshot = await repository.currentSnapshot();
    expect(
      snapshot.blocks.single.completionState,
      BlockCompletionState.completed,
    );
    expect(snapshot.tasks.single.remainingMinutes, 35);
  });

  test('failed replacement rolls back deletion of existing records', () async {
    await repository.saveTask(task());
    final invalid = PlannerSnapshot(
      tasks: [
        PlannerTask.create(
          id: 'invalid-task',
          title: 'Missing list',
          listId: 'does-not-exist',
          createdAt: now,
        ),
      ],
    );

    await expectLater(
      repository.replaceSnapshot(invalid),
      throwsA(isA<AppFailure>()),
    );

    final snapshot = await repository.currentSnapshot();
    expect(snapshot.lists.single.id, 'inbox');
    expect(snapshot.tasks.single.id, 'task-1');
  });
}
