import 'dart:async';

import 'package:anydoes/app/providers.dart';
import 'package:anydoes/core/result/app_failure.dart';
import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/scheduling/free_interval_finder.dart';
import 'package:anydoes/domain/scheduling/planning_input.dart';
import 'package:anydoes/domain/scheduling/planning_result.dart';
import 'package:anydoes/domain/scheduling/scheduling_engine.dart';
import 'package:anydoes/domain/scheduling/task_ranker.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:anydoes/features/plan/plan_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schedulingEngineProvider = Provider<SchedulingEngine>(
  (ref) => const SchedulingEngine(),
);

final planControllerProvider = StateNotifierProvider<PlanController, PlanState>(
  (ref) => PlanController(
    ref.watch(plannerRepositoryProvider),
    ref.watch(schedulingEngineProvider),
    ref.watch(appClockProvider),
  ),
);

final class PlanController extends StateNotifier<PlanState> {
  PlanController(this._repository, this._engine, this._clock)
    : super(PlanState()) {
    _start();
  }

  final PlannerRepository _repository;
  final SchedulingEngine _engine;
  final AppClock _clock;
  StreamSubscription<PlannerSnapshot>? _subscription;

  Future<void> _start() async {
    try {
      await _repository.initializeDefaults();
      _subscription = _repository.watchSnapshot().listen(
        (snapshot) => state = state.copyWith(
          snapshot: snapshot,
          isLoading: false,
          clearFailure: true,
        ),
        onError: (Object error) => _setFailure(error),
      );
    } catch (error) {
      _setFailure(error);
    }
  }

  Future<void> createProposal({bool reconsiderAccepted = false}) async {
    state = state.copyWith(isPlanning: true, clearFailure: true);
    try {
      final snapshot = await _repository.currentSnapshot();
      final result = _engine.plan(
        PlanningInput(
          now: _clock.now(),
          horizonDays: snapshot.preferences.horizonDays,
          tasks: snapshot.tasks,
          occupiedBlocks: snapshot.blocks,
          weeklyAvailability: snapshot.weeklyAvailability,
          availabilityExceptions: snapshot.availabilityExceptions,
          reconsiderUnlockedGeneratedBlocks: reconsiderAccepted,
        ),
      );
      state = state.copyWith(
        snapshot: snapshot,
        proposalBlocks: result.blocks,
        conflicts: result.conflicts,
        isLoading: false,
        isPlanning: false,
      );
    } catch (error) {
      _setFailure(error);
    }
  }

  void moveProposalBlock(String id, DateTime newStart) {
    final current = state.proposalBlocks
        .where((block) => block.id == id)
        .firstOrNull;
    if (current == null) return;
    final candidate = current.copyWith(
      start: newStart.toUtc(),
      end: newStart.toUtc().add(current.duration),
      isLocked: true,
    );
    _applyEdit(candidate);
  }

  void resizeProposalBlock(String id, Duration duration) {
    final current = state.proposalBlocks
        .where((block) => block.id == id)
        .firstOrNull;
    if (current == null) return;
    if (duration.inMinutes < 5) {
      _setFailure(
        const AppFailure(
          code: AppFailureCode.validation,
          message: 'A schedule block must be at least five minutes.',
          recovery: 'Choose a longer duration.',
        ),
      );
      return;
    }
    _applyEdit(
      current.copyWith(end: current.start.add(duration), isLocked: true),
    );
  }

  void _applyEdit(PlannedBlock candidate) {
    if (!_isValidPlacement(candidate)) {
      _setFailure(
        const AppFailure(
          code: AppFailureCode.validation,
          message: 'That time is unavailable or overlaps another block.',
          recovery: 'Choose an open time within your availability.',
        ),
      );
      return;
    }
    state = state.copyWith(
      proposalBlocks: [
        for (final block in state.proposalBlocks)
          if (block.id == candidate.id) candidate else block,
      ],
      clearFailure: true,
    );
  }

  bool _isValidPlacement(
    PlannedBlock candidate, {
    String? ignoredAcceptedBlockId,
  }) {
    final occupied = <ScheduleBlock>[
      ...state.snapshot.blocks.where(
        (block) =>
            block.id != ignoredAcceptedBlockId &&
            block.completionState == BlockCompletionState.pending,
      ),
      for (final block in state.proposalBlocks)
        if (block.id != candidate.id) block.toScheduleBlock(),
    ];
    final free = const FreeIntervalFinder().find(
      start: candidate.start,
      end: candidate.end,
      weekly: state.snapshot.weeklyAvailability,
      exceptions: state.snapshot.availabilityExceptions,
      occupied: occupied,
    );
    return free.any(
      (interval) =>
          !interval.start.isAfter(candidate.start) &&
          !interval.end.isBefore(candidate.end),
    );
  }

  void removeProposalBlock(String id) {
    state = state.copyWith(
      proposalBlocks: state.proposalBlocks
          .where((block) => block.id != id)
          .toList(),
    );
  }

  Future<void> acceptBlock(String id) async {
    final block = state.proposalBlocks
        .where((item) => item.id == id)
        .firstOrNull;
    if (block == null) return;
    try {
      await _repository.acceptProposal([block.toScheduleBlock()]);
      removeProposalBlock(id);
    } catch (error) {
      _setFailure(error);
    }
  }

  Future<void> acceptAll() async {
    if (state.proposalBlocks.isEmpty) return;
    try {
      await _repository.acceptProposal(
        state.proposalBlocks.map((block) => block.toScheduleBlock()),
      );
      state = state.copyWith(proposalBlocks: const [], clearFailure: true);
    } catch (error) {
      _setFailure(error);
    }
  }

  void discard() {
    state = state.copyWith(
      proposalBlocks: const [],
      conflicts: const [],
      clearFailure: true,
    );
  }

  Future<void> completeBlock(String id) async {
    try {
      await _repository.completeBlock(id, _clock.now());
    } catch (error) {
      _setFailure(error);
    }
  }

  Future<void> skipBlock(ScheduleBlock block) async {
    try {
      await _repository.saveBlock(
        block.copyWith(completionState: BlockCompletionState.skipped),
      );
    } catch (error) {
      _setFailure(error);
    }
  }

  Future<void> moveAcceptedBlock(ScheduleBlock block, DateTime newStart) async {
    final candidate = PlannedBlock(
      id: block.id,
      taskId: block.taskId ?? '',
      start: newStart.toUtc(),
      end: newStart.toUtc().add(block.duration),
      reason: SchedulingReason.durationPressure,
      isLocked: true,
    );
    if (!_isValidPlacement(candidate, ignoredAcceptedBlockId: block.id)) {
      _setFailure(
        const AppFailure(
          code: AppFailureCode.validation,
          message: 'That time is unavailable or overlaps another block.',
          recovery: 'Choose an open time within your availability.',
        ),
      );
      return;
    }
    await _repository.saveBlock(
      block.copyWith(
        start: candidate.start,
        end: candidate.end,
        isLocked: true,
      ),
    );
  }

  Future<void> resizeAcceptedBlock(
    ScheduleBlock block,
    Duration duration,
  ) async {
    final candidate = PlannedBlock(
      id: block.id,
      taskId: block.taskId ?? '',
      start: block.start,
      end: block.start.add(duration),
      reason: SchedulingReason.durationPressure,
      isLocked: true,
    );
    if (!_isValidPlacement(candidate, ignoredAcceptedBlockId: block.id)) {
      _setFailure(
        const AppFailure(
          code: AppFailureCode.validation,
          message: 'That duration overlaps unavailable time.',
          recovery: 'Choose a shorter duration.',
        ),
      );
      return;
    }
    await _repository.saveBlock(
      block.copyWith(end: candidate.end, isLocked: true),
    );
  }

  Future<void> completeTask(
    String taskId, {
    required bool removeFutureBlocks,
  }) => _repository.completeTask(
    taskId,
    _clock.now(),
    removeFutureBlocks: removeFutureBlocks,
  );

  Future<void> replan() => createProposal(reconsiderAccepted: true);

  Future<void> applyRecoveryAction(
    PlanningConflict conflict,
    RecoveryAction action,
  ) async {
    final task = state.snapshot.tasks
        .where((item) => item.id == conflict.taskId)
        .firstOrNull;
    if (task == null) return;
    final now = _clock.now();
    PlannerTask updated;
    switch (action) {
      case RecoveryAction.extendDeadline:
      case RecoveryAction.nextAvailableSlot:
        updated = task.copyWith(
          deadline: (task.deadline ?? now).add(const Duration(days: 7)),
          updatedAt: now,
        );
      case RecoveryAction.reduceDuration:
        final completed =
            (task.estimatedMinutes ?? 0) - (task.remainingMinutes ?? 0);
        final remaining =
            (task.remainingMinutes ?? 0) - conflict.missingMinutes;
        final safeRemaining = remaining < 5 ? 5 : remaining;
        updated = task.copyWith(
          estimatedMinutes: completed + safeRemaining,
          remainingMinutes: safeRemaining,
          updatedAt: now,
        );
      case RecoveryAction.makeSplittable:
        updated = task.copyWith(allowSplit: true, updatedAt: now);
    }
    await _repository.saveTask(updated);
    await createProposal();
  }

  void _setFailure(Object error) {
    state = state.copyWith(
      isLoading: false,
      isPlanning: false,
      failure: error is AppFailure
          ? error
          : AppFailure(
              code: AppFailureCode.persistence,
              message: 'The plan could not be updated.',
              recovery: 'Your saved schedule is unchanged. Try again.',
              cause: error,
            ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
