import 'dart:convert';

import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/notifications/notification_gateway.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

final class LocalNotificationGateway implements NotificationGateway {
  LocalNotificationGateway({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<bool>? _initialization;

  static const _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'planning_reminders',
      'Planning reminders',
      channelDescription: 'Accepted task blocks and task deadlines',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
    macOS: DarwinNotificationDetails(),
    windows: WindowsNotificationDetails(),
  );

  Future<bool> _initialize() => _initialization ??= _doInitialize();

  Future<bool> _doInitialize() async {
    try {
      tz_data.initializeTimeZones();
      try {
        final local = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(local.identifier));
      } catch (_) {
        // The bundled database still provides a safe UTC fallback.
      }
      final initialized = await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
          macOS: DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
          windows: WindowsInitializationSettings(
            appName: 'Anydoes',
            appUserModelId: 'Anydoes.LocalPlanner',
            guid: 'a8521543-ea7c-4e10-9701-15b9f0797c33',
          ),
        ),
      );
      return initialized ?? true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<NotificationPermissionStatus> permissionStatus() async {
    if (!await _initialize()) return NotificationPermissionStatus.unavailable;
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final enabled = await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.areNotificationsEnabled();
        return enabled == false
            ? NotificationPermissionStatus.denied
            : NotificationPermissionStatus.authorized;
      }
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final options = await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.checkPermissions();
        return options?.isEnabled == false
            ? NotificationPermissionStatus.denied
            : NotificationPermissionStatus.authorized;
      }
      if (defaultTargetPlatform == TargetPlatform.macOS) {
        final options = await _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >()
            ?.checkPermissions();
        return options?.isEnabled == false
            ? NotificationPermissionStatus.denied
            : NotificationPermissionStatus.authorized;
      }
      if (defaultTargetPlatform == TargetPlatform.windows) {
        return NotificationPermissionStatus.authorized;
      }
      return NotificationPermissionStatus.unavailable;
    } catch (_) {
      return NotificationPermissionStatus.unavailable;
    }
  }

  @override
  Future<NotificationPermissionStatus> requestPermission() async {
    if (!await _initialize()) return NotificationPermissionStatus.unavailable;
    try {
      bool? granted;
      if (defaultTargetPlatform == TargetPlatform.android) {
        granted = await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        granted = await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      } else if (defaultTargetPlatform == TargetPlatform.macOS) {
        granted = await _plugin
            .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true);
      } else if (defaultTargetPlatform == TargetPlatform.windows) {
        granted = true;
      }
      if (granted == null) return NotificationPermissionStatus.unavailable;
      return granted
          ? NotificationPermissionStatus.authorized
          : NotificationPermissionStatus.denied;
    } catch (_) {
      return NotificationPermissionStatus.unavailable;
    }
  }

  @override
  Future<void> scheduleBlock({
    required String notificationId,
    required ScheduleBlock block,
    required PlannerTask task,
    required Duration offset,
  }) async {
    final scheduled = block.start.subtract(offset);
    if (!scheduled.isAfter(DateTime.now())) return;
    await _schedule(
      notificationId,
      scheduled,
      title: task.title,
      body: offset == Duration.zero
          ? 'This planned session starts now.'
          : 'Your planned session starts in ${offset.inMinutes} minutes.',
      payload: 'block:${block.id}',
    );
  }

  @override
  Future<void> scheduleDeadline({
    required String notificationId,
    required PlannerTask task,
  }) async {
    final deadline = task.deadline;
    if (deadline == null || !deadline.isAfter(DateTime.now())) return;
    await _schedule(
      notificationId,
      deadline,
      title: task.title,
      body: 'This task is due now.',
      payload: 'task:${task.id}',
    );
  }

  Future<void> _schedule(
    String notificationId,
    DateTime instant, {
    required String title,
    required String body,
    required String payload,
  }) async {
    if (!await _initialize()) {
      throw const NotificationGatewayException(
        'Local notifications are unavailable on this platform.',
      );
    }
    try {
      await _plugin.zonedSchedule(
        id: _stableInt(notificationId),
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(instant.toUtc(), tz.local),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
    } catch (error) {
      throw NotificationGatewayException(
        'The reminder could not be scheduled.',
        cause: error,
      );
    }
  }

  @override
  Future<void> cancel(String notificationId) async {
    if (!await _initialize()) return;
    try {
      await _plugin.cancel(id: _stableInt(notificationId));
    } catch (_) {
      // Cancellation failure must never block planner persistence.
    }
  }

  @override
  Future<void> openSystemSettings() async {
    if (!await _initialize()) return;
    try {
      await _plugin.openAppNotificationSettings();
    } catch (_) {
      // Some desktop targets do not expose a settings shortcut.
    }
  }

  int _stableInt(String value) {
    final bytes = sha256.convert(utf8.encode(value)).bytes;
    return ((bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3]) &
        0x7fffffff;
  }
}
