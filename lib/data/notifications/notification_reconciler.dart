import 'dart:async';

import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/notifications/notification_gateway.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class NotificationReconcileResult {
  const NotificationReconcileResult({
    this.scheduled = 0,
    this.cancelled = 0,
    this.warning,
  });

  final int scheduled;
  final int cancelled;
  final String? warning;
}

final class NotificationReconciler {
  const NotificationReconciler(this._gateway);

  final NotificationGateway _gateway;

  Future<NotificationReconcileResult> reconcile(
    PlannerSnapshot before,
    PlannerSnapshot after,
  ) async {
    final previous = _desired(before);
    final next = _desired(after);
    var cancelled = 0;
    var scheduled = 0;

    for (final entry in previous.entries) {
      if (!next.containsKey(entry.key) ||
          next[entry.key]!.fingerprint != entry.value.fingerprint) {
        try {
          await _gateway.cancel(entry.key);
          cancelled++;
        } catch (_) {
          // Persistence is authoritative; stale reminders are retried later.
        }
      }
    }

    final additions = next.entries.where(
      (entry) =>
          !previous.containsKey(entry.key) ||
          previous[entry.key]!.fingerprint != entry.value.fingerprint,
    );
    if (additions.isEmpty) {
      return NotificationReconcileResult(cancelled: cancelled);
    }

    final permission = await _gateway.permissionStatus();
    if (permission != NotificationPermissionStatus.authorized) {
      return NotificationReconcileResult(
        cancelled: cancelled,
        warning:
            'Notification permission is unavailable. Planning and saving still work; enable reminders in system settings.',
      );
    }

    try {
      for (final entry in additions) {
        final reminder = entry.value;
        if (reminder.block != null) {
          await _gateway.scheduleBlock(
            notificationId: entry.key,
            block: reminder.block!,
            task: reminder.task,
            offset: Duration(
              minutes: after.preferences.notificationOffsetMinutes,
            ),
          );
        } else {
          await _gateway.scheduleDeadline(
            notificationId: entry.key,
            task: reminder.task,
          );
        }
        scheduled++;
      }
    } on NotificationGatewayException catch (error) {
      return NotificationReconcileResult(
        scheduled: scheduled,
        cancelled: cancelled,
        warning: '${error.message} Your planner changes were saved.',
      );
    }
    return NotificationReconcileResult(
      scheduled: scheduled,
      cancelled: cancelled,
    );
  }

  Map<String, _DesiredReminder> _desired(PlannerSnapshot snapshot) {
    if (!snapshot.preferences.notificationsEnabled) return const {};
    final tasks = {for (final task in snapshot.tasks) task.id: task};
    final result = <String, _DesiredReminder>{};
    final tasksWithBlocks = <String>{};
    for (final block in snapshot.blocks) {
      if (block.state != ScheduleBlockState.accepted ||
          block.completionState != BlockCompletionState.pending ||
          block.taskId == null) {
        continue;
      }
      final task = tasks[block.taskId];
      if (task == null || task.status != TaskStatus.open) continue;
      tasksWithBlocks.add(task.id);
      result['block:${block.id}'] = _DesiredReminder.block(
        task,
        block,
        snapshot.preferences.notificationOffsetMinutes,
      );
    }
    for (final task in snapshot.tasks) {
      if (task.status == TaskStatus.open &&
          task.deadline != null &&
          !tasksWithBlocks.contains(task.id)) {
        result['deadline:${task.id}'] = _DesiredReminder.deadline(task);
      }
    }
    return result;
  }
}

final class NotificationCoordinator extends StateNotifier<String?> {
  NotificationCoordinator(this._repository, this._reconciler) : super(null) {
    _start();
  }

  final PlannerRepository _repository;
  final NotificationReconciler _reconciler;
  StreamSubscription<PlannerSnapshot>? _subscription;
  PlannerSnapshot? _previous;
  Future<void> _queue = Future.value();

  void _start() {
    _subscription = _repository.watchSnapshot().listen((snapshot) {
      final before = _previous ?? PlannerSnapshot();
      _previous = snapshot;
      _queue = _queue
          .then((_) async {
            final result = await _reconciler.reconcile(before, snapshot);
            state = result.warning;
          })
          .catchError((Object _) {
            state =
                'Reminders could not be refreshed. Your planner data is still saved.';
          });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final class _DesiredReminder {
  const _DesiredReminder({
    required this.task,
    required this.fingerprint,
    this.block,
  });

  factory _DesiredReminder.block(
    PlannerTask task,
    ScheduleBlock block,
    int offsetMinutes,
  ) => _DesiredReminder(
    task: task,
    block: block,
    fingerprint:
        'block|${block.start.microsecondsSinceEpoch}|${block.end.microsecondsSinceEpoch}|$offsetMinutes|${task.title}',
  );

  factory _DesiredReminder.deadline(PlannerTask task) => _DesiredReminder(
    task: task,
    fingerprint:
        'deadline|${task.deadline!.microsecondsSinceEpoch}|${task.title}',
  );

  final PlannerTask task;
  final ScheduleBlock? block;
  final String fingerprint;
}
