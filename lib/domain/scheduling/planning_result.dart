import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/scheduling/task_ranker.dart';

enum RecoveryAction {
  extendDeadline,
  reduceDuration,
  makeSplittable,
  nextAvailableSlot,
}

final class PlannedBlock {
  const PlannedBlock({
    required this.id,
    required this.taskId,
    required this.start,
    required this.end,
    required this.reason,
    this.isLocked = false,
  });

  final String id;
  final String taskId;
  final DateTime start;
  final DateTime end;
  final SchedulingReason reason;
  final bool isLocked;

  Duration get duration => end.difference(start);

  PlannedBlock copyWith({DateTime? start, DateTime? end, bool? isLocked}) =>
      PlannedBlock(
        id: id,
        taskId: taskId,
        start: start ?? this.start,
        end: end ?? this.end,
        reason: reason,
        isLocked: isLocked ?? this.isLocked,
      );

  ScheduleBlock toScheduleBlock({bool? locked}) => ScheduleBlock(
    id: id,
    taskId: taskId,
    start: start,
    end: end,
    state: ScheduleBlockState.proposed,
    isLocked: locked ?? isLocked,
  );
}

final class PlanningConflict {
  const PlanningConflict({
    required this.taskId,
    required this.missingMinutes,
    required this.recoveryActions,
  });

  final String taskId;
  final int missingMinutes;
  final List<RecoveryAction> recoveryActions;
}

final class PlanningResult {
  PlanningResult({
    List<PlannedBlock> blocks = const [],
    List<PlanningConflict> conflicts = const [],
  }) : blocks = List.unmodifiable(blocks),
       conflicts = List.unmodifiable(conflicts);

  final List<PlannedBlock> blocks;
  final List<PlanningConflict> conflicts;
}
