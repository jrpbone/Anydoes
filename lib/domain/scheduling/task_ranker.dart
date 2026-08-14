import 'dart:math' as math;

import 'package:anydoes/domain/models/task.dart';

enum SchedulingReason { urgentDeadline, highPriority, durationPressure }

final class TaskScore {
  const TaskScore({
    required this.deadlineUrgency,
    required this.priorityWeight,
    required this.durationPressure,
  });

  final double deadlineUrgency;
  final double priorityWeight;
  final double durationPressure;

  double get total => deadlineUrgency + priorityWeight + durationPressure;

  SchedulingReason get dominantReason {
    if (deadlineUrgency >= priorityWeight &&
        deadlineUrgency >= durationPressure) {
      return SchedulingReason.urgentDeadline;
    }
    if (priorityWeight >= durationPressure) {
      return SchedulingReason.highPriority;
    }
    return SchedulingReason.durationPressure;
  }
}

final class RankedTask {
  const RankedTask({required this.task, required this.score});

  final PlannerTask task;
  final TaskScore score;
  SchedulingReason get reason => score.dominantReason;
}

typedef FreeMinutesForTask = int Function(PlannerTask task);

final class TaskRanker {
  const TaskRanker();

  TaskScore score(
    PlannerTask task, {
    required DateTime now,
    required int freeMinutesBeforeDeadline,
  }) {
    final minutesUntilDeadline = task.deadline?.difference(now).inMinutes;
    final deadlineUrgency = minutesUntilDeadline == null
        ? 0.0
        : minutesUntilDeadline <= 0
        ? 50.0
        : 50 *
              (1 - minutesUntilDeadline / const Duration(days: 14).inMinutes)
                  .clamp(0.0, 1.0);
    final priorityWeight = switch (task.priority) {
      TaskPriority.low => 0.0,
      TaskPriority.normal => 10.0,
      TaskPriority.high => 20.0,
      TaskPriority.urgent => 30.0,
    };
    final remaining = task.remainingMinutes ?? 0;
    final pressureRatio = freeMinutesBeforeDeadline <= 0
        ? (remaining > 0 ? 1.0 : 0.0)
        : remaining / freeMinutesBeforeDeadline;
    final durationPressure = 20.0 * math.min(1.0, pressureRatio).toDouble();
    return TaskScore(
      deadlineUrgency: deadlineUrgency,
      priorityWeight: priorityWeight,
      durationPressure: durationPressure,
    );
  }

  List<RankedTask> rank(
    Iterable<PlannerTask> tasks, {
    required DateTime now,
    required FreeMinutesForTask freeMinutesForTask,
  }) {
    final ranked = [
      for (final task in tasks)
        RankedTask(
          task: task,
          score: score(
            task,
            now: now,
            freeMinutesBeforeDeadline: freeMinutesForTask(task),
          ),
        ),
    ];
    ranked.sort((a, b) {
      final scoreOrder = b.score.total.compareTo(a.score.total);
      if (scoreOrder != 0) return scoreOrder;
      final aDeadline = a.task.deadline;
      final bDeadline = b.task.deadline;
      if (aDeadline != null || bDeadline != null) {
        if (aDeadline == null) return 1;
        if (bDeadline == null) return -1;
        final deadlineOrder = aDeadline.compareTo(bDeadline);
        if (deadlineOrder != 0) return deadlineOrder;
      }
      final createdOrder = a.task.createdAt.compareTo(b.task.createdAt);
      return createdOrder != 0 ? createdOrder : a.task.id.compareTo(b.task.id);
    });
    return List.unmodifiable(ranked);
  }
}
