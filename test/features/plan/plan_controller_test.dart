import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/repositories/drift_planner_repository.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/scheduling/scheduling_engine.dart';
import 'package:anydoes/features/plan/plan_controller.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;
  late DriftPlannerRepository repository;
  late PlanController controller;
  final now = DateTime.utc(2026, 8, 17, 8, 2);

  setUp(() async {
    database = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (raw) => raw.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    repository = DriftPlannerRepository(database);
    await repository.initializeDefaults();
    await repository.saveTask(
      PlannerTask.create(
        id: 'task-1',
        title: 'Draft proposal',
        listId: 'inbox',
        estimatedMinutes: 60,
        allowSplit: true,
        createdAt: now,
      ),
    );
    controller = PlanController(
      repository,
      const SchedulingEngine(),
      FixedAppClock(now),
    );
  });

  tearDown(() async {
    controller.dispose();
    await database.close();
  });

  test(
    'creating and discarding a proposal never writes schedule blocks',
    () async {
      await controller.createProposal();

      expect(controller.state.proposalBlocks, hasLength(1));
      expect((await repository.currentSnapshot()).blocks, isEmpty);

      controller.discard();

      expect(controller.state.proposalBlocks, isEmpty);
      expect((await repository.currentSnapshot()).blocks, isEmpty);
    },
  );

  test(
    'manual fixed events are persisted locked and reject overlaps',
    () async {
      await controller.createFixedEvent(
        note: 'School pickup',
        start: DateTime.utc(2026, 8, 17, 12),
        end: DateTime.utc(2026, 8, 17, 12, 30),
      );

      final saved = (await repository.currentSnapshot()).blocks.single;
      expect(saved.taskId, isNull);
      expect(saved.note, 'School pickup');
      expect(saved.isLocked, isTrue);
      expect(saved.isGenerated, isFalse);

      await controller.createFixedEvent(
        note: 'Overlapping event',
        start: DateTime.utc(2026, 8, 17, 12, 15),
        end: DateTime.utc(2026, 8, 17, 12, 45),
      );

      expect((await repository.currentSnapshot()).blocks, hasLength(1));
      expect(controller.state.failure?.message, contains('overlaps'));
    },
  );

  test('moving and resizing a proposal stays ephemeral and locks it', () async {
    await controller.createProposal();
    final id = controller.state.proposalBlocks.single.id;

    controller.moveProposalBlock(id, DateTime.utc(2026, 8, 17, 10));
    controller.resizeProposalBlock(id, const Duration(minutes: 45));

    final block = controller.state.proposalBlocks.single;
    expect(block.start, DateTime.utc(2026, 8, 17, 10));
    expect(block.duration, const Duration(minutes: 45));
    expect(block.isLocked, isTrue);
    expect((await repository.currentSnapshot()).blocks, isEmpty);
  });

  test(
    'accept all persists accepted blocks in one action and clears proposal',
    () async {
      await controller.createProposal();

      await controller.acceptAll();

      expect(controller.state.proposalBlocks, isEmpty);
      final blocks = (await repository.currentSnapshot()).blocks;
      expect(blocks.single.state, ScheduleBlockState.accepted);
    },
  );

  test('accepting one proposal preserves remaining suggestions', () async {
    await repository.saveTask(
      PlannerTask.create(
        id: 'task-2',
        title: 'Review budget',
        listId: 'inbox',
        estimatedMinutes: 30,
        createdAt: now,
      ),
    );
    await controller.createProposal();
    final acceptedId = controller.state.proposalBlocks.first.id;

    await controller.acceptBlock(acceptedId);

    expect(controller.state.proposalBlocks, hasLength(1));
    expect((await repository.currentSnapshot()).blocks, hasLength(1));
  });

  test(
    'accepted replan atomically removes obsolete generated sessions',
    () async {
      final original = (await repository.currentSnapshot()).tasks.single;
      await repository.saveTask(
        original.copyWith(estimatedMinutes: 120, remainingMinutes: 120),
      );
      await controller.createProposal();
      await controller.acceptAll();
      expect((await repository.currentSnapshot()).blocks, hasLength(2));

      final expanded = (await repository.currentSnapshot()).tasks.single;
      await repository.saveTask(
        expanded.copyWith(estimatedMinutes: 30, remainingMinutes: 30),
      );
      await controller.replan();
      expect(controller.state.proposalBlocks, hasLength(1));

      await controller.acceptAll();

      final replanned = await repository.currentSnapshot();
      expect(replanned.blocks, hasLength(1));
      expect(replanned.blocks.single.duration, const Duration(minutes: 30));
    },
  );

  test(
    'completion reduces remaining duration while skip leaves it queued',
    () async {
      await controller.createProposal();
      await controller.acceptAll();
      final accepted = (await repository.currentSnapshot()).blocks.single;

      await controller.skipBlock(accepted);
      expect(
        (await repository.currentSnapshot()).tasks.single.remainingMinutes,
        60,
      );

      await repository.saveBlock(
        accepted.copyWith(completionState: BlockCompletionState.pending),
      );
      await controller.completeBlock(accepted.id);
      expect(
        (await repository.currentSnapshot()).tasks.single.remainingMinutes,
        0,
      );
    },
  );
}
