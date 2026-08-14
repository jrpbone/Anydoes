import 'dart:convert';

import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/profile.dart';
import 'package:anydoes/domain/models/recurrence_rule.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/tag.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/task_list.dart';
import 'package:anydoes/domain/portability/canonical_json.dart';
import 'package:anydoes/domain/portability/dayplan_document.dart';
import 'package:crypto/crypto.dart';

final class DayplanCodec {
  const DayplanCodec();

  String encode({
    required DayplanKind kind,
    required PlannerSnapshot snapshot,
    required DayplanMetadata metadata,
  }) {
    final payload = switch (kind) {
      DayplanKind.fullBackup => _fullPayload(snapshot),
      DayplanKind.sharedList => _sharedPayload(snapshot, metadata.sharedListId),
    };
    final checksum = sha256
        .convert(utf8.encode(CanonicalJson.encode(payload)))
        .toString()
        .toLowerCase();
    return CanonicalJson.encode({
      'app': {
        'name': 'Anydoes',
        'platform': metadata.platform,
        'version': metadata.appVersion,
      },
      'checksum': checksum,
      'exportedAt': _instant(metadata.exportedAt),
      'kind': kind.wireName,
      'payload': payload,
      'schemaVersion': 1,
      'sourceTimeZone': metadata.sourceTimeZone,
    });
  }

  DayplanDocument decode(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map) throw const FormatException('Expected JSON object');
    final map = Map<String, Object?>.from(decoded);
    final kindName = map['kind'];
    final kind = DayplanKind.values
        .where((value) => value.wireName == kindName)
        .firstOrNull;
    if (kind == null) throw FormatException('Unknown dayplan kind: $kindName');
    final appValue = map['app'];
    final payloadValue = map['payload'];
    if (appValue is! Map || payloadValue is! Map) {
      throw const FormatException('Missing app or payload object');
    }
    return DayplanDocument(
      schemaVersion: map['schemaVersion'] is int
          ? map['schemaVersion']! as int
          : -1,
      kind: kind,
      exportedAt: map['exportedAt']?.toString() ?? '',
      sourceTimeZone: map['sourceTimeZone']?.toString() ?? '',
      app: Map<String, Object?>.from(appValue),
      payload: Map<String, Object?>.from(payloadValue),
      checksum: map['checksum']?.toString() ?? '',
    );
  }

  Map<String, Object?> _fullPayload(PlannerSnapshot snapshot) => {
    'availabilityExceptions': [
      for (final exception in snapshot.availabilityExceptions)
        {
          'date': _date(exception.date),
          'windows': [for (final window in exception.windows) _window(window)],
        },
    ],
    'blocks': [
      for (final block in _byId(snapshot.blocks, (value) => value.id))
        _block(block),
    ],
    'lists': [
      for (final list in _byId(snapshot.lists, (value) => value.id))
        _list(list),
    ],
    'preferences': {
      'defaultMaximumSessionMinutes':
          snapshot.preferences.defaultMaximumSessionMinutes,
      'defaultMinimumSessionMinutes':
          snapshot.preferences.defaultMinimumSessionMinutes,
      'highContrast': snapshot.preferences.highContrast,
      'horizonDays': snapshot.preferences.horizonDays,
      'notificationOffsetMinutes':
          snapshot.preferences.notificationOffsetMinutes,
      'notificationsEnabled': snapshot.preferences.notificationsEnabled,
      'reduceMotion': snapshot.preferences.reduceMotion,
      'themeMode': snapshot.preferences.themeMode.name,
    },
    'profiles': [
      for (final profile in _byId(snapshot.profiles, (value) => value.id))
        _profile(profile),
    ],
    'recurrenceRules': [
      for (final rule in _byId(snapshot.recurrenceRules, (value) => value.id))
        _recurrence(rule),
    ],
    'tags': [
      for (final tag in _byId(snapshot.tags, (value) => value.id)) _tag(tag),
    ],
    'tasks': [
      for (final task in _byId(snapshot.tasks, (value) => value.id))
        _task(task),
    ],
    'weeklyAvailability': [
      for (final window in snapshot.weeklyAvailability) _window(window),
    ],
  };

  Map<String, Object?> _sharedPayload(
    PlannerSnapshot snapshot,
    String? listId,
  ) {
    if (listId == null ||
        snapshot.lists.where((list) => list.id == listId).isEmpty) {
      throw ArgumentError.value(listId, 'sharedListId', 'List not found');
    }
    final tasks = snapshot.tasks
        .where((task) => task.listId == listId)
        .toList();
    final tagIds = tasks.expand((task) => task.tagIds).toSet();
    final profileIds = tasks
        .map((task) => task.assigneeProfileId)
        .nonNulls
        .toSet();
    final recurrenceIds = tasks
        .map((task) => task.recurrenceRuleId)
        .nonNulls
        .toSet();
    return {
      'lists': [_list(snapshot.lists.singleWhere((list) => list.id == listId))],
      'profiles': [
        for (final profile in snapshot.profiles.where(
          (profile) => profileIds.contains(profile.id),
        ))
          _profile(profile),
      ],
      'recurrenceRules': [
        for (final rule in snapshot.recurrenceRules.where(
          (rule) => recurrenceIds.contains(rule.id),
        ))
          _recurrence(rule),
      ],
      'tags': [
        for (final tag in snapshot.tags.where((tag) => tagIds.contains(tag.id)))
          _tag(tag),
      ],
      'tasks': [
        for (final task in _byId(tasks, (value) => value.id)) _task(task),
      ],
    };
  }

  Map<String, Object?> _task(PlannerTask task) {
    return {
      'allowSplit': task.allowSplit,
      'assigneeProfileId': task.assigneeProfileId,
      'completedAt': _nullableInstant(task.completedAt),
      'createdAt': _instant(task.createdAt),
      'deadline': _nullableInstant(task.deadline),
      'earliestStart': _nullableInstant(task.earliestStart),
      'estimatedMinutes': task.estimatedMinutes,
      'id': task.id,
      'includeInMyPlan': task.includeInMyPlan,
      'listId': task.listId,
      'maximumSessionMinutes': task.maximumSessionMinutes,
      'minimumSessionMinutes': task.minimumSessionMinutes,
      'notes': task.notes,
      'occurrenceDate': _nullableInstant(task.occurrenceDate),
      'parentTaskId': task.parentTaskId,
      'priority': task.priority.name,
      'recurrenceRuleId': task.recurrenceRuleId,
      'recurrenceSeriesId': task.recurrenceSeriesId,
      'remainingMinutes': task.remainingMinutes,
      'status': task.status.name,
      'tagIds': task.tagIds.toList()..sort(),
      'title': task.title,
      'updatedAt': _instant(task.updatedAt),
    };
  }

  Map<String, Object?> _block(ScheduleBlock block) => {
    'completionState': block.completionState.name,
    'end': _instant(block.end),
    'id': block.id,
    'isGenerated': block.isGenerated,
    'isLocked': block.isLocked,
    'note': block.note,
    'start': _instant(block.start),
    'state': block.state.name,
    'taskId': block.taskId,
  };

  Map<String, Object?> _list(TaskList list) => {
    'colorValue': list.colorValue,
    'createdAt': _instant(list.createdAt),
    'iconCodePoint': list.iconCodePoint,
    'id': list.id,
    'isInbox': list.isInbox,
    'name': list.name,
  };

  Map<String, Object?> _tag(TaskTag tag) => {
    'colorValue': tag.colorValue,
    'id': tag.id,
    'name': tag.name,
  };

  Map<String, Object?> _profile(LocalProfile profile) => {
    'colorValue': profile.colorValue,
    'id': profile.id,
    'isMe': profile.isMe,
    'name': profile.name,
  };

  Map<String, Object?> _recurrence(RecurrenceRule rule) => {
    'frequency': rule.frequency.name,
    'id': rule.id,
    'interval': rule.interval,
    'occurrenceCount': rule.occurrenceCount,
    'until': rule.until == null ? null : _date(rule.until!),
    'weekdays': rule.weekdays.toList()..sort(),
  };

  Map<String, Object?> _window(AvailabilityWindow window) => {
    'endMinute': window.endMinute,
    'startMinute': window.startMinute,
    'weekday': window.weekday,
  };

  List<T> _byId<T>(List<T> values, String Function(T) id) =>
      [...values]..sort((left, right) => id(left).compareTo(id(right)));

  String _instant(DateTime value) => value.toUtc().toIso8601String();
  String? _nullableInstant(DateTime? value) =>
      value == null ? null : _instant(value);
  String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
