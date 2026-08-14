import 'package:anydoes/app/anydoes_app.dart';
import 'package:anydoes/app/providers.dart';
import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/portability/dayplan_file_service.dart';
import 'package:anydoes/data/repositories/drift_planner_repository.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/notifications/notification_gateway.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final fixedTestNow = DateTime.utc(2026, 8, 17, 8);

Future<DriftPlannerRepository> pumpTestApp(
  WidgetTester tester, {
  required double width,
  double height = 900,
  double textScale = 1,
  Future<void> Function(DriftPlannerRepository repository)? seed,
}) async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(database.close);
  final repository = DriftPlannerRepository(database);
  await repository.initializeDefaults();
  await seed?.call(repository);
  await tester.binding.setSurfaceSize(Size(width, height));
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(() async {
    await tester.binding.setSurfaceSize(null);
    tester.platformDispatcher.clearTextScaleFactorTestValue();
  });
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        plannerRepositoryProvider.overrideWithValue(repository),
        appClockProvider.overrideWithValue(FixedAppClock(fixedTestNow)),
        notificationGatewayProvider.overrideWithValue(
          const TestNotificationGateway(),
        ),
        dayplanFileServiceProvider.overrideWithValue(TestDayplanFileGateway()),
      ],
      child: const AnydoesApp(),
    ),
  );
  await tester.pumpAndSettle();
  return repository;
}

final class TestNotificationGateway implements NotificationGateway {
  const TestNotificationGateway();

  @override
  Future<void> cancel(String notificationId) async {}

  @override
  Future<void> openSystemSettings() async {}

  @override
  Future<NotificationPermissionStatus> permissionStatus() async =>
      NotificationPermissionStatus.authorized;

  @override
  Future<NotificationPermissionStatus> requestPermission() async =>
      NotificationPermissionStatus.authorized;

  @override
  Future<void> scheduleBlock({
    required String notificationId,
    required ScheduleBlock block,
    required PlannerTask task,
    required Duration offset,
  }) async {}

  @override
  Future<void> scheduleDeadline({
    required String notificationId,
    required PlannerTask task,
  }) async {}
}

final class TestDayplanFileGateway implements DayplanFileGateway {
  @override
  Future<String> localTimeZone() async => 'UTC';

  @override
  Future<String?> read() async => null;

  @override
  Future<bool> saveFullBackup(
    String source, {
    required String suggestedName,
  }) async => false;

  @override
  Future<bool> saveSharedList(
    String source, {
    required String suggestedName,
  }) async => false;
}
