import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/repositories/drift_planner_repository.dart';
import 'package:anydoes/data/notifications/local_notification_gateway.dart';
import 'package:anydoes/data/notifications/notification_reconciler.dart';
import 'package:anydoes/domain/notifications/notification_gateway.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appClockProvider = Provider<AppClock>((ref) => const SystemAppClock());

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final plannerRepositoryProvider = Provider<PlannerRepository>(
  (ref) => DriftPlannerRepository(ref.watch(databaseProvider)),
);

final notificationGatewayProvider = Provider<NotificationGateway>(
  (ref) => LocalNotificationGateway(),
);

final notificationReconcilerProvider = Provider<NotificationReconciler>(
  (ref) => NotificationReconciler(ref.watch(notificationGatewayProvider)),
);

final notificationCoordinatorProvider =
    StateNotifierProvider<NotificationCoordinator, String?>((ref) {
      return NotificationCoordinator(
        ref.watch(plannerRepositoryProvider),
        ref.watch(notificationReconcilerProvider),
      );
    });
