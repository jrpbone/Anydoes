import 'dart:math' as math;

import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/scheduling/free_interval_finder.dart';
import 'package:anydoes/domain/scheduling/planning_input.dart';
import 'package:anydoes/domain/scheduling/planning_result.dart';
import 'package:anydoes/domain/scheduling/task_ranker.dart';

final class SchedulingEngine {
  const SchedulingEngine({
    this.intervalFinder = const FreeIntervalFinder(),
    this.ranker = const TaskRanker(),
  });

  final FreeIntervalFinder intervalFinder;
  final TaskRanker ranker;

  PlanningResult plan(PlanningInput input) {
    final planningStart = _nextFiveMinuteBoundary(input.now);
    final planningEnd = planningStart.add(Duration(days: input.horizonDays));
    final keptBlocks = input.occupiedBlocks.where((block) {
      if (block.state != ScheduleBlockState.accepted ||
          block.completionState != BlockCompletionState.pending ||
          !block.end.isAfter(planningStart)) {
        return false;
      }
      final canReconsider =
          input.reconsiderUnlockedGeneratedBlocks &&
          block.isGenerated &&
          !block.isLocked;
      return !canReconsider;
    }).toList();
    final free = [
      ...intervalFinder.find(
        start: planningStart,
        end: planningEnd,
        weekly: input.weeklyAvailability,
        exceptions: input.availabilityExceptions,
        occupied: keptBlocks,
      ),
    ];
    final eligible = input.tasks.where((task) {
      if (!task.canAutoSchedule) return false;
      final assignmentEligible =
          task.assigneeProfileId == null ||
          task.assigneeProfileId == input.primaryProfileId ||
          task.includeInMyPlan;
      if (!assignmentEligible) return false;
      if (task.earliestStart != null &&
          !task.earliestStart!.isBefore(planningEnd)) {
        return false;
      }
      return true;
    }).toList();

    int freeMinutesForTask(PlannerTask task) {
      return free.fold(0, (total, interval) {
        final bounded = _boundInterval(
          interval,
          task.earliestStart ?? planningStart,
          task.deadline ?? planningEnd,
        );
        return total + (bounded?.duration.inMinutes ?? 0);
      });
    }

    final ranked = ranker.rank(
      eligible,
      now: planningStart,
      freeMinutesForTask: freeMinutesForTask,
    );
    final proposals = <PlannedBlock>[];
    final conflicts = <PlanningConflict>[];

    for (final rankedTask in ranked) {
      final task = rankedTask.task;
      final alreadyAllocated = keptBlocks
          .where((block) => block.taskId == task.id)
          .fold<int>(0, (total, block) => total + block.duration.inMinutes);
      var remaining = math.max(
        0,
        (task.remainingMinutes ?? 0) - alreadyAllocated,
      );
      if (remaining == 0) continue;

      if (task.allowSplit) {
        remaining = _placeSplit(
          task: task,
          remaining: remaining,
          reason: rankedTask.reason,
          planningStart: planningStart,
          planningEnd: planningEnd,
          free: free,
          proposals: proposals,
        );
      } else {
        final placed = _placeContiguous(
          task: task,
          minutes: remaining,
          reason: rankedTask.reason,
          planningStart: planningStart,
          planningEnd: planningEnd,
          free: free,
          proposals: proposals,
        );
        if (placed) remaining = 0;
      }

      if (remaining > 0) {
        conflicts.add(
          PlanningConflict(
            taskId: task.id,
            missingMinutes: remaining,
            recoveryActions: [
              if (task.deadline != null) RecoveryAction.extendDeadline,
              RecoveryAction.reduceDuration,
              if (!task.allowSplit) RecoveryAction.makeSplittable,
              RecoveryAction.nextAvailableSlot,
            ],
          ),
        );
      }
    }

    proposals.sort((a, b) {
      final startOrder = a.start.compareTo(b.start);
      return startOrder != 0 ? startOrder : a.id.compareTo(b.id);
    });
    return PlanningResult(blocks: proposals, conflicts: conflicts);
  }

  bool _placeContiguous({
    required PlannerTask task,
    required int minutes,
    required SchedulingReason reason,
    required DateTime planningStart,
    required DateTime planningEnd,
    required List<FreeInterval> free,
    required List<PlannedBlock> proposals,
  }) {
    for (final interval in [...free]) {
      final bounded = _boundInterval(
        interval,
        task.earliestStart ?? planningStart,
        task.deadline ?? planningEnd,
      );
      if (bounded == null || bounded.duration.inMinutes < minutes) continue;
      final end = bounded.start.add(Duration(minutes: minutes));
      _addProposal(task, bounded.start, end, reason, free, proposals);
      return true;
    }
    return false;
  }

  int _placeSplit({
    required PlannerTask task,
    required int remaining,
    required SchedulingReason reason,
    required DateTime planningStart,
    required DateTime planningEnd,
    required List<FreeInterval> free,
    required List<PlannedBlock> proposals,
  }) {
    var workLeft = remaining;
    while (workLeft > 0) {
      FreeInterval? chosen;
      int chosenMinutes = 0;
      for (final interval in free) {
        final bounded = _boundInterval(
          interval,
          task.earliestStart ?? planningStart,
          task.deadline ?? planningEnd,
        );
        if (bounded == null) continue;
        final available = bounded.duration.inMinutes;
        if (available <= 0) continue;
        final candidate = math.min(
          workLeft,
          math.min(task.maximumSessionMinutes, available),
        );
        final isFinal = candidate == workLeft;
        if (!isFinal && candidate < task.minimumSessionMinutes) continue;
        chosen = bounded;
        chosenMinutes = candidate;
        break;
      }
      if (chosen == null || chosenMinutes == 0) break;
      final end = chosen.start.add(Duration(minutes: chosenMinutes));
      _addProposal(task, chosen.start, end, reason, free, proposals);
      workLeft -= chosenMinutes;
    }
    return workLeft;
  }

  void _addProposal(
    PlannerTask task,
    DateTime start,
    DateTime end,
    SchedulingReason reason,
    List<FreeInterval> free,
    List<PlannedBlock> proposals,
  ) {
    final sequence = proposals.where((block) => block.taskId == task.id).length;
    proposals.add(
      PlannedBlock(
        id: 'proposal-${task.id}-$sequence',
        taskId: task.id,
        start: start,
        end: end,
        reason: reason,
      ),
    );
    _consume(free, start, end);
  }

  void _consume(List<FreeInterval> free, DateTime start, DateTime end) {
    final updated = <FreeInterval>[];
    for (final interval in free) {
      if (!end.isAfter(interval.start) || !start.isBefore(interval.end)) {
        updated.add(interval);
        continue;
      }
      if (start.isAfter(interval.start)) {
        updated.add(FreeInterval(interval.start, start));
      }
      if (end.isBefore(interval.end)) {
        updated.add(FreeInterval(end, interval.end));
      }
    }
    updated.sort((a, b) => a.start.compareTo(b.start));
    free
      ..clear()
      ..addAll(updated);
  }
}

FreeInterval? _boundInterval(
  FreeInterval interval,
  DateTime lowerBound,
  DateTime upperBound,
) {
  final start = interval.start.isAfter(lowerBound)
      ? interval.start
      : lowerBound;
  final end = interval.end.isBefore(upperBound) ? interval.end : upperBound;
  return end.isAfter(start) ? FreeInterval(start, end) : null;
}

DateTime _nextFiveMinuteBoundary(DateTime value) {
  final utc = value.toUtc();
  final remainder = utc.minute % 5;
  final alreadyOnBoundary =
      remainder == 0 &&
      utc.second == 0 &&
      utc.millisecond == 0 &&
      utc.microsecond == 0;
  if (alreadyOnBoundary) return utc;
  final minutesToAdd = remainder == 0 ? 5 : 5 - remainder;
  return DateTime.utc(
    utc.year,
    utc.month,
    utc.day,
    utc.hour,
    utc.minute,
  ).add(Duration(minutes: minutesToAdd));
}
