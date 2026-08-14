import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/scheduling/planning_input.dart';
import 'package:anydoes/domain/scheduling/planning_result.dart';
import 'package:anydoes/domain/scheduling/scheduling_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = SchedulingEngine();
  final monday = DateTime.utc(2026, 8, 17, 8, 2);

  PlannerTask task({
    required String id,
    required int minutes,
    bool split = false,
    int minimum = 25,
    int maximum = 90,
    DateTime? earliest,
    DateTime? deadline,
    String? assignee,
    bool includeInPlan = false,
  }) => PlannerTask.create(
    id: id,
    title: id,
    listId: 'inbox',
    estimatedMinutes: minutes,
    allowSplit: split,
    minimumSessionMinutes: minimum,
    maximumSessionMinutes: maximum,
    earliestStart: earliest,
    deadline: deadline,
    assigneeProfileId: assignee,
    includeInMyPlan: includeInPlan,
    createdAt: monday,
  );

  PlanningInput input(
    List<PlannerTask> tasks, {
    List<AvailabilityWindow>? availability,
    List<ScheduleBlock> occupied = const [],
    bool reconsider = false,
  }) => PlanningInput(
    now: monday,
    horizonDays: 7,
    tasks: tasks,
    occupiedBlocks: occupied,
    weeklyAvailability:
        availability ??
        [
          AvailabilityWindow(
            weekday: DateTime.monday,
            startMinute: 9 * 60,
            endMinute: 17 * 60,
          ),
        ],
    availabilityExceptions: const [],
    reconsiderUnlockedGeneratedBlocks: reconsider,
  );

  test('splits three hours into legal sessions totaling the task duration', () {
    final result = engine.plan(
      input([task(id: 'deep-work', minutes: 180, split: true)]),
    );

    expect(result.conflicts, isEmpty);
    expect(result.blocks, hasLength(2));
    expect(
      result.blocks.fold<int>(
        0,
        (total, block) => total + block.duration.inMinutes,
      ),
      180,
    );
    expect(
      result.blocks.every((block) => block.duration.inMinutes <= 90),
      isTrue,
    );
  });

  test('non-splittable work needs one contiguous interval', () {
    final result = engine.plan(
      input(
        [task(id: 'contiguous', minutes: 120)],
        availability: [
          AvailabilityWindow(
            weekday: DateTime.monday,
            startMinute: 9 * 60,
            endMinute: 10 * 60,
          ),
          AvailabilityWindow(
            weekday: DateTime.monday,
            startMinute: 11 * 60,
            endMinute: 12 * 60,
          ),
        ],
      ),
    );

    expect(result.blocks, isEmpty);
    expect(result.conflicts.single.taskId, 'contiguous');
    expect(result.conflicts.single.missingMinutes, 120);
    expect(
      result.conflicts.single.recoveryActions,
      contains(RecoveryAction.makeSplittable),
    );
  });

  test(
    'respects earliest start, deadline, availability, and locked blocks',
    () {
      final result = engine.plan(
        input(
          [
            task(
              id: 'bounded',
              minutes: 60,
              earliest: DateTime.utc(2026, 8, 17, 10),
              deadline: DateTime.utc(2026, 8, 17, 12),
            ),
          ],
          occupied: [
            ScheduleBlock(
              id: 'locked',
              start: DateTime.utc(2026, 8, 17, 10),
              end: DateTime.utc(2026, 8, 17, 10, 30),
              isLocked: true,
            ),
          ],
        ),
      );

      expect(result.blocks.single.start, DateTime.utc(2026, 8, 17, 10, 30));
      expect(result.blocks.single.end, DateTime.utc(2026, 8, 17, 11, 30));
    },
  );

  test('excludes other assignees unless explicitly included', () {
    final result = engine.plan(
      input([
        task(id: 'other', minutes: 30, assignee: 'alex'),
        task(
          id: 'included',
          minutes: 30,
          assignee: 'alex',
          includeInPlan: true,
        ),
      ]),
    );

    expect(result.blocks.map((block) => block.taskId), ['included']);
  });

  test('explicit replan can reconsider unlocked generated accepted blocks', () {
    final old = ScheduleBlock(
      id: 'old',
      taskId: 'task',
      start: DateTime.utc(2026, 8, 17, 15),
      end: DateTime.utc(2026, 8, 17, 16),
      isGenerated: true,
      isLocked: false,
    );
    final kept = engine.plan(
      input([task(id: 'task', minutes: 60)], occupied: [old]),
    );
    final replanned = engine.plan(
      input([task(id: 'task', minutes: 60)], occupied: [old], reconsider: true),
    );

    expect(kept.blocks, isEmpty);
    expect(replanned.blocks.single.start, DateTime.utc(2026, 8, 17, 9));
  });

  test('identical input produces identical ordered output', () {
    final planningInput = input([
      task(id: 'a', minutes: 45, split: true),
      task(id: 'b', minutes: 30),
    ]);
    final first = engine.plan(planningInput);
    final second = engine.plan(planningInput);

    expect(
      first.blocks.map(
        (block) =>
            '${block.id}|${block.start.toIso8601String()}|${block.end.toIso8601String()}',
      ),
      second.blocks.map(
        (block) =>
            '${block.id}|${block.start.toIso8601String()}|${block.end.toIso8601String()}',
      ),
    );
    expect(
      first.conflicts.map((conflict) => conflict.taskId),
      second.conflicts.map((conflict) => conflict.taskId),
    );
  });
}
