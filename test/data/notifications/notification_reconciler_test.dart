import 'package:anydoes/data/notifications/notification_reconciler.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/planning_preferences.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/notifications/notification_gateway.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 8, 15, 8);
  late PlannerTask task;
  late ScheduleBlock block;

  setUp(() {
    task = PlannerTask.create(
      id: 'task-1',
      title: 'Draft proposal',
      listId: 'inbox',
      createdAt: now,
      estimatedMinutes: 60,
      deadline: now.add(const Duration(days: 2)),
    );
    block = ScheduleBlock(
      id: 'block-1',
      taskId: task.id,
      start: now.add(const Duration(hours: 2)),
      end: now.add(const Duration(hours: 3)),
    );
  });

  test('accept schedules a block and deadline-only work', () async {
    final gateway = FakeNotificationGateway();
    final reconciler = NotificationReconciler(gateway);
    final after = PlannerSnapshot(tasks: [task], blocks: [block]);

    final result = await reconciler.reconcile(PlannerSnapshot(), after);

    expect(gateway.scheduledBlocks, ['block:block-1']);
    expect(gateway.scheduledDeadlines, isEmpty);
    expect(result.warning, isNull);

    gateway.clear();
    await reconciler.reconcile(
      PlannerSnapshot(),
      PlannerSnapshot(tasks: [task]),
    );
    expect(gateway.scheduledDeadlines, ['deadline:task-1']);
  });

  test('moving a block cancels and reschedules its stable id', () async {
    final gateway = FakeNotificationGateway();
    final reconciler = NotificationReconciler(gateway);
    final before = PlannerSnapshot(tasks: [task], blocks: [block]);
    final moved = block.copyWith(
      start: block.start.add(const Duration(hours: 1)),
      end: block.end.add(const Duration(hours: 1)),
    );

    await reconciler.reconcile(
      before,
      PlannerSnapshot(tasks: [task], blocks: [moved]),
    );

    expect(gateway.cancelled, ['block:block-1']);
    expect(gateway.scheduledBlocks, ['block:block-1']);
  });

  test('deleting or completing a block cancels its reminder', () async {
    final gateway = FakeNotificationGateway();
    final reconciler = NotificationReconciler(gateway);
    final before = PlannerSnapshot(tasks: [task], blocks: [block]);

    await reconciler.reconcile(before, PlannerSnapshot(tasks: [task]));

    expect(gateway.cancelled, ['block:block-1']);
    expect(gateway.scheduledDeadlines, ['deadline:task-1']);
  });

  test('disabled or denied reminders return a non-blocking warning', () async {
    final gateway = FakeNotificationGateway(
      status: NotificationPermissionStatus.denied,
    );
    final reconciler = NotificationReconciler(gateway);

    final result = await reconciler.reconcile(
      PlannerSnapshot(),
      PlannerSnapshot(tasks: [task], blocks: [block]),
    );

    expect(result.warning, contains('permission'));
    expect(gateway.scheduledBlocks, isEmpty);

    final disabled = PlannerSnapshot(
      tasks: [task],
      blocks: [block],
      preferences: PlanningPreferences(notificationsEnabled: false),
    );
    final disabledResult = await reconciler.reconcile(
      PlannerSnapshot(),
      disabled,
    );
    expect(disabledResult.warning, isNull);
  });
}

final class FakeNotificationGateway implements NotificationGateway {
  FakeNotificationGateway({
    this.status = NotificationPermissionStatus.authorized,
  });

  NotificationPermissionStatus status;
  final scheduledBlocks = <String>[];
  final scheduledDeadlines = <String>[];
  final cancelled = <String>[];

  void clear() {
    scheduledBlocks.clear();
    scheduledDeadlines.clear();
    cancelled.clear();
  }

  @override
  Future<NotificationPermissionStatus> permissionStatus() async => status;

  @override
  Future<NotificationPermissionStatus> requestPermission() async => status;

  @override
  Future<void> scheduleBlock({
    required String notificationId,
    required ScheduleBlock block,
    required PlannerTask task,
    required Duration offset,
  }) async => scheduledBlocks.add(notificationId);

  @override
  Future<void> scheduleDeadline({
    required String notificationId,
    required PlannerTask task,
  }) async => scheduledDeadlines.add(notificationId);

  @override
  Future<void> cancel(String notificationId) async =>
      cancelled.add(notificationId);

  @override
  Future<void> openSystemSettings() async {}
}
