import 'package:anydoes/core/result/app_failure.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/scheduling/planning_result.dart';

final class PlanState {
  PlanState({
    PlannerSnapshot? snapshot,
    List<PlannedBlock> proposalBlocks = const [],
    List<PlanningConflict> conflicts = const [],
    this.isLoading = true,
    this.isPlanning = false,
    this.failure,
  }) : snapshot = snapshot ?? PlannerSnapshot(),
       proposalBlocks = List.unmodifiable(proposalBlocks),
       conflicts = List.unmodifiable(conflicts);

  final PlannerSnapshot snapshot;
  final List<PlannedBlock> proposalBlocks;
  final List<PlanningConflict> conflicts;
  final bool isLoading;
  final bool isPlanning;
  final AppFailure? failure;

  List<PlannerTask> get unscheduledTasks {
    final allocated = <String, int>{};
    for (final block in snapshot.blocks) {
      if (block.taskId != null &&
          block.completionState == BlockCompletionState.pending) {
        allocated.update(
          block.taskId!,
          (value) => value + block.duration.inMinutes,
          ifAbsent: () => block.duration.inMinutes,
        );
      }
    }
    for (final block in proposalBlocks) {
      allocated.update(
        block.taskId,
        (value) => value + block.duration.inMinutes,
        ifAbsent: () => block.duration.inMinutes,
      );
    }
    return snapshot.tasks.where((task) {
      if (!task.canAutoSchedule) return false;
      return (task.remainingMinutes ?? 0) > (allocated[task.id] ?? 0);
    }).toList();
  }

  PlanState copyWith({
    PlannerSnapshot? snapshot,
    List<PlannedBlock>? proposalBlocks,
    List<PlanningConflict>? conflicts,
    bool? isLoading,
    bool? isPlanning,
    AppFailure? failure,
    bool clearFailure = false,
  }) => PlanState(
    snapshot: snapshot ?? this.snapshot,
    proposalBlocks: proposalBlocks ?? this.proposalBlocks,
    conflicts: conflicts ?? this.conflicts,
    isLoading: isLoading ?? this.isLoading,
    isPlanning: isPlanning ?? this.isPlanning,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}
