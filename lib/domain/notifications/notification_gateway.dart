import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';

enum NotificationPermissionStatus {
  authorized,
  denied,
  permanentlyDenied,
  unavailable,
}

final class NotificationGatewayException implements Exception {
  const NotificationGatewayException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

abstract interface class NotificationGateway {
  Future<NotificationPermissionStatus> permissionStatus();
  Future<NotificationPermissionStatus> requestPermission();
  Future<void> scheduleBlock({
    required String notificationId,
    required ScheduleBlock block,
    required PlannerTask task,
    required Duration offset,
  });
  Future<void> scheduleDeadline({
    required String notificationId,
    required PlannerTask task,
  });
  Future<void> cancel(String notificationId);
  Future<void> openSystemSettings();
}
