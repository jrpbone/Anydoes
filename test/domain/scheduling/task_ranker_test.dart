import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/scheduling/task_ranker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 8, 17, 8);

  PlannerTask task({
    required String id,
    TaskPriority priority = TaskPriority.normal,
    DateTime? deadline,
    int minutes = 60,
    DateTime? createdAt,
  }) => PlannerTask.create(
    id: id,
    title: id,
    listId: 'inbox',
    priority: priority,
    deadline: deadline,
    estimatedMinutes: minutes,
    createdAt: createdAt ?? now,
  );

  test('score components stay within the 50/30/20 contract', () {
    final score = const TaskRanker().score(
      task(
        id: 'urgent',
        priority: TaskPriority.urgent,
        deadline: now.add(const Duration(hours: 1)),
        minutes: 240,
      ),
      now: now,
      freeMinutesBeforeDeadline: 60,
    );

    expect(score.deadlineUrgency, inInclusiveRange(0, 50));
    expect(score.priorityWeight, inInclusiveRange(0, 30));
    expect(score.durationPressure, inInclusiveRange(0, 20));
    expect(
      score.total,
      score.deadlineUrgency + score.priorityWeight + score.durationPressure,
    );
  });

  test('higher score wins before tie breakers', () {
    final ranked = const TaskRanker().rank(
      [
        task(id: 'low', priority: TaskPriority.low),
        task(id: 'high', priority: TaskPriority.high),
      ],
      now: now,
      freeMinutesForTask: (_) => 480,
    );

    expect(ranked.map((item) => item.task.id), ['high', 'low']);
    expect(ranked.first.reason, SchedulingReason.highPriority);
  });

  test('ties use earliest deadline and then oldest creation time', () {
    final deadline = now.add(const Duration(days: 3));
    final ranked = const TaskRanker().rank(
      [
        task(id: 'new-late', deadline: deadline.add(const Duration(days: 1))),
        task(id: 'new-early', deadline: deadline, createdAt: now),
        task(
          id: 'old-early',
          deadline: deadline,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      ],
      now: now,
      freeMinutesForTask: (_) => 480,
    );

    expect(ranked.map((item) => item.task.id), [
      'old-early',
      'new-early',
      'new-late',
    ]);
  });
}
