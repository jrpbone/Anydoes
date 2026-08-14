import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/planning_preferences.dart';
import 'package:anydoes/domain/models/profile.dart';
import 'package:anydoes/domain/models/recurrence_rule.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/tag.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/task_list.dart';
import 'package:anydoes/domain/portability/dayplan_document.dart';
import 'package:anydoes/domain/portability/import_preview.dart';

enum DayplanValidationCode {
  checksum,
  schema,
  incomplete,
  duplicateId,
  reference,
  timestamp,
  value,
  taskCycle,
  recurrence,
}

final class DayplanValidationError {
  const DayplanValidationError(this.code, this.message);
  final DayplanValidationCode code;
  final String message;
}

final class DayplanValidationResult {
  const DayplanValidationResult({required this.errors, this.preview});
  final List<DayplanValidationError> errors;
  final ImportPreview? preview;
  bool get isValid => errors.isEmpty && preview != null;
}

final class DayplanValidator {
  const DayplanValidator({required this.destinationTimeZone});

  final String destinationTimeZone;

  DayplanValidationResult validate(
    DayplanDocument document,
    PlannerSnapshot localSnapshot,
  ) {
    if (!document.hasValidChecksum) {
      return const DayplanValidationResult(
        errors: [
          DayplanValidationError(
            DayplanValidationCode.checksum,
            'The payload checksum does not match.',
          ),
        ],
      );
    }
    if (document.schemaVersion != 1) {
      return DayplanValidationResult(
        errors: [
          DayplanValidationError(
            DayplanValidationCode.schema,
            'Schema ${document.schemaVersion} is not supported.',
          ),
        ],
      );
    }
    try {
      _utcInstant(document.exportedAt, 'exportedAt');
      final parsed = _parse(document);
      final transformed = document.kind == DayplanKind.sharedList
          ? _remapShared(parsed, localSnapshot)
          : _Remapped(parsed, const {});
      final snapshot = transformed.snapshot;
      final warnings = <String>[];
      if (document.sourceTimeZone != destinationTimeZone) {
        warnings.add(
          'This file was exported in ${document.sourceTimeZone}; calendar times will display in $destinationTimeZone.',
        );
      }
      return DayplanValidationResult(
        errors: const [],
        preview: ImportPreview(
          kind: document.kind,
          snapshot: snapshot,
          counts: ImportCounts(
            tasks: snapshot.tasks.length,
            blocks: snapshot.blocks.length,
            lists: snapshot.lists.length,
            tags: snapshot.tags.length,
            profiles: snapshot.profiles.length,
            recurrenceRules: snapshot.recurrenceRules.length,
          ),
          collisions: _collisions(parsed, localSnapshot),
          warnings: warnings,
          allowedModes: document.kind == DayplanKind.fullBackup
              ? const ['merge', 'replace']
              : const ['import'],
          idMaps: transformed.idMaps,
        ),
      );
    } on _ValidationException catch (error) {
      return DayplanValidationResult(
        errors: [DayplanValidationError(error.code, error.message)],
      );
    } on ArgumentError catch (error) {
      return DayplanValidationResult(
        errors: [
          DayplanValidationError(
            DayplanValidationCode.value,
            error.message?.toString() ?? 'A value is invalid.',
          ),
        ],
      );
    } on FormatException catch (error) {
      return DayplanValidationResult(
        errors: [
          DayplanValidationError(DayplanValidationCode.value, error.message),
        ],
      );
    }
  }

  PlannerSnapshot _parse(DayplanDocument document) {
    final payload = document.payload;
    final required = document.kind == DayplanKind.fullBackup
        ? const {
            'tasks',
            'blocks',
            'lists',
            'tags',
            'profiles',
            'recurrenceRules',
            'weeklyAvailability',
            'availabilityExceptions',
            'preferences',
          }
        : const {'tasks', 'lists', 'tags', 'profiles', 'recurrenceRules'};
    final missing = required.where((key) => !payload.containsKey(key)).toList();
    if (missing.isNotEmpty) {
      throw _ValidationException(
        DayplanValidationCode.incomplete,
        'Required payload fields are missing: ${missing.join(', ')}.',
      );
    }

    final listMaps = _maps(payload, 'lists');
    final tagMaps = _maps(payload, 'tags');
    final profileMaps = _maps(payload, 'profiles');
    final recurrenceMaps = _maps(payload, 'recurrenceRules');
    final taskMaps = _maps(payload, 'tasks');
    final blockMaps = document.kind == DayplanKind.fullBackup
        ? _maps(payload, 'blocks')
        : const <Map<String, Object?>>[];
    for (final entry in <(String, List<Map<String, Object?>>)>[
      ('list', listMaps),
      ('tag', tagMaps),
      ('profile', profileMaps),
      ('recurrence', recurrenceMaps),
      ('task', taskMaps),
      ('block', blockMaps),
    ]) {
      _rejectDuplicateIds(entry.$1, entry.$2);
    }

    final lists = [
      for (final map in listMaps)
        TaskList(
          id: _string(map, 'id'),
          name: _string(map, 'name'),
          colorValue: _integer(map, 'colorValue'),
          iconCodePoint: _integer(map, 'iconCodePoint'),
          isInbox: _boolean(map, 'isInbox'),
          createdAt: _utcInstant(_string(map, 'createdAt'), 'createdAt'),
        ),
    ];
    final tags = [
      for (final map in tagMaps)
        TaskTag(
          id: _string(map, 'id'),
          name: _string(map, 'name'),
          colorValue: _integer(map, 'colorValue'),
        ),
    ];
    final profiles = [
      for (final map in profileMaps)
        LocalProfile(
          id: _string(map, 'id'),
          name: _string(map, 'name'),
          colorValue: _integer(map, 'colorValue'),
          isMe: _boolean(map, 'isMe'),
        ),
    ];
    final recurrenceRules = <RecurrenceRule>[];
    for (final map in recurrenceMaps) {
      try {
        recurrenceRules.add(
          RecurrenceRule(
            id: _string(map, 'id'),
            frequency: _enumValue(
              RecurrenceFrequency.values,
              _string(map, 'frequency'),
              'frequency',
            ),
            interval: _integer(map, 'interval'),
            weekdays: _integers(map, 'weekdays').toSet(),
            until: _nullableDate(map['until'], 'until'),
            occurrenceCount: _nullableInteger(map['occurrenceCount']),
          ),
        );
      } on ArgumentError catch (error) {
        throw _ValidationException(
          DayplanValidationCode.recurrence,
          error.message?.toString() ?? 'Invalid recurrence rule.',
        );
      }
    }

    final listIds = lists.map((value) => value.id).toSet();
    final tagIds = tags.map((value) => value.id).toSet();
    final profileIds = profiles.map((value) => value.id).toSet();
    final recurrenceIds = recurrenceRules.map((value) => value.id).toSet();
    final tasks = <PlannerTask>[];
    for (final map in taskMaps) {
      final listId = _string(map, 'listId');
      final taskTagIds = _strings(map, 'tagIds').toSet();
      final profileId = _nullableString(map['assigneeProfileId']);
      final recurrenceId = _nullableString(map['recurrenceRuleId']);
      if (!listIds.contains(listId) ||
          !tagIds.containsAll(taskTagIds) ||
          (profileId != null && !profileIds.contains(profileId)) ||
          (recurrenceId != null && !recurrenceIds.contains(recurrenceId))) {
        throw const _ValidationException(
          DayplanValidationCode.reference,
          'A task references a missing list, tag, profile, or recurrence rule.',
        );
      }
      tasks.add(
        PlannerTask.create(
          id: _string(map, 'id'),
          title: _string(map, 'title'),
          notes: _nullableString(map['notes']),
          listId: listId,
          parentTaskId: _nullableString(map['parentTaskId']),
          status: _enumValue(
            TaskStatus.values,
            _string(map, 'status'),
            'status',
          ),
          priority: _enumValue(
            TaskPriority.values,
            _string(map, 'priority'),
            'priority',
          ),
          earliestStart: _nullableInstant(
            map['earliestStart'],
            'earliestStart',
          ),
          deadline: _nullableInstant(map['deadline'], 'deadline'),
          estimatedMinutes: _nullableInteger(map['estimatedMinutes']),
          remainingMinutes: _nullableInteger(map['remainingMinutes']),
          allowSplit: _boolean(map, 'allowSplit'),
          minimumSessionMinutes: _integer(map, 'minimumSessionMinutes'),
          maximumSessionMinutes: _integer(map, 'maximumSessionMinutes'),
          recurrenceRuleId: recurrenceId,
          recurrenceSeriesId: _nullableString(map['recurrenceSeriesId']),
          occurrenceDate: _nullableInstant(
            map['occurrenceDate'],
            'occurrenceDate',
          ),
          assigneeProfileId: profileId,
          includeInMyPlan: _boolean(map, 'includeInMyPlan'),
          createdAt: _utcInstant(_string(map, 'createdAt'), 'createdAt'),
          updatedAt: _utcInstant(_string(map, 'updatedAt'), 'updatedAt'),
          completedAt: _nullableInstant(map['completedAt'], 'completedAt'),
          tagIds: taskTagIds,
        ),
      );
    }
    final taskIds = tasks.map((value) => value.id).toSet();
    for (final task in tasks) {
      if (task.parentTaskId != null && !taskIds.contains(task.parentTaskId)) {
        throw const _ValidationException(
          DayplanValidationCode.reference,
          'A parent task reference is missing.',
        );
      }
    }
    _rejectCycles(tasks);

    final blocks = <ScheduleBlock>[];
    for (final map in blockMaps) {
      final taskId = _nullableString(map['taskId']);
      if (taskId != null && !taskIds.contains(taskId)) {
        throw const _ValidationException(
          DayplanValidationCode.reference,
          'A schedule block references a missing task.',
        );
      }
      blocks.add(
        ScheduleBlock(
          id: _string(map, 'id'),
          taskId: taskId,
          start: _utcInstant(_string(map, 'start'), 'start'),
          end: _utcInstant(_string(map, 'end'), 'end'),
          state: _enumValue(
            ScheduleBlockState.values,
            _string(map, 'state'),
            'state',
          ),
          isLocked: _boolean(map, 'isLocked'),
          completionState: _enumValue(
            BlockCompletionState.values,
            _string(map, 'completionState'),
            'completionState',
          ),
          note: _nullableString(map['note']),
          isGenerated: _boolean(map, 'isGenerated'),
        ),
      );
    }

    final weekly = document.kind == DayplanKind.fullBackup
        ? [
            for (final map in _maps(payload, 'weeklyAvailability'))
              _availability(map),
          ]
        : <AvailabilityWindow>[];
    final exceptions = document.kind == DayplanKind.fullBackup
        ? [
            for (final map in _maps(payload, 'availabilityExceptions'))
              AvailabilityException(
                date: _date(_string(map, 'date'), 'date'),
                windows: [
                  for (final window in _mapList(map, 'windows'))
                    _availability(window),
                ],
              ),
          ]
        : <AvailabilityException>[];
    final preferences = document.kind == DayplanKind.fullBackup
        ? _preferences(_object(payload, 'preferences'))
        : PlanningPreferences();
    return PlannerSnapshot(
      tasks: tasks,
      blocks: blocks,
      lists: lists,
      tags: tags,
      profiles: profiles,
      recurrenceRules: recurrenceRules,
      weeklyAvailability: weekly,
      availabilityExceptions: exceptions,
      preferences: preferences,
    );
  }

  PlanningPreferences _preferences(
    Map<String, Object?> map,
  ) => PlanningPreferences(
    horizonDays: _integer(map, 'horizonDays'),
    defaultMinimumSessionMinutes: _integer(map, 'defaultMinimumSessionMinutes'),
    defaultMaximumSessionMinutes: _integer(map, 'defaultMaximumSessionMinutes'),
    notificationOffsetMinutes: _integer(map, 'notificationOffsetMinutes'),
    notificationsEnabled: _boolean(map, 'notificationsEnabled'),
    themeMode: _enumValue(
      AppThemeMode.values,
      _string(map, 'themeMode'),
      'themeMode',
    ),
    highContrast: _boolean(map, 'highContrast'),
    reduceMotion: _boolean(map, 'reduceMotion'),
  );

  AvailabilityWindow _availability(Map<String, Object?> map) =>
      AvailabilityWindow(
        weekday: _integer(map, 'weekday'),
        startMinute: _integer(map, 'startMinute'),
        endMinute: _integer(map, 'endMinute'),
      );

  _Remapped _remapShared(PlannerSnapshot source, PlannerSnapshot local) {
    String remap(String type, String id, Set<String> occupied) {
      var candidate = 'imported-$type-$id';
      var suffix = 2;
      while (occupied.contains(candidate)) {
        candidate = 'imported-$type-$id-${suffix++}';
      }
      occupied.add(candidate);
      return candidate;
    }

    Map<String, String> ids<T>(
      String type,
      Iterable<T> values,
      String Function(T) id,
      Iterable<T> localValues,
    ) {
      final occupied = localValues.map(id).toSet();
      return {
        for (final value in values) id(value): remap(type, id(value), occupied),
      };
    }

    final listIds = ids('list', source.lists, (value) => value.id, local.lists);
    final tagIds = ids('tag', source.tags, (value) => value.id, local.tags);
    final profileIds = ids(
      'profile',
      source.profiles,
      (value) => value.id,
      local.profiles,
    );
    final recurrenceIds = ids(
      'recurrence',
      source.recurrenceRules,
      (value) => value.id,
      local.recurrenceRules,
    );
    final taskIds = ids('task', source.tasks, (value) => value.id, local.tasks);
    final remapped = PlannerSnapshot(
      lists: [
        for (final list in source.lists)
          TaskList(
            id: listIds[list.id]!,
            name: list.name,
            createdAt: list.createdAt,
            colorValue: list.colorValue,
            iconCodePoint: list.iconCodePoint,
          ),
      ],
      tags: [
        for (final tag in source.tags)
          TaskTag(
            id: tagIds[tag.id]!,
            name: tag.name,
            colorValue: tag.colorValue,
          ),
      ],
      profiles: [
        for (final profile in source.profiles)
          LocalProfile(
            id: profileIds[profile.id]!,
            name: profile.name,
            colorValue: profile.colorValue,
          ),
      ],
      recurrenceRules: [
        for (final rule in source.recurrenceRules)
          RecurrenceRule(
            id: recurrenceIds[rule.id]!,
            frequency: rule.frequency,
            interval: rule.interval,
            weekdays: rule.weekdays,
            until: rule.until,
            occurrenceCount: rule.occurrenceCount,
          ),
      ],
      tasks: [
        for (final task in source.tasks)
          PlannerTask.create(
            id: taskIds[task.id]!,
            title: task.title,
            notes: task.notes,
            listId: listIds[task.listId]!,
            parentTaskId: task.parentTaskId == null
                ? null
                : taskIds[task.parentTaskId],
            status: task.status,
            priority: task.priority,
            earliestStart: task.earliestStart,
            deadline: task.deadline,
            estimatedMinutes: task.estimatedMinutes,
            remainingMinutes: task.remainingMinutes,
            allowSplit: task.allowSplit,
            minimumSessionMinutes: task.minimumSessionMinutes,
            maximumSessionMinutes: task.maximumSessionMinutes,
            recurrenceRuleId: task.recurrenceRuleId == null
                ? null
                : recurrenceIds[task.recurrenceRuleId],
            recurrenceSeriesId: task.recurrenceSeriesId == null
                ? null
                : taskIds[task.recurrenceSeriesId] ?? task.recurrenceSeriesId,
            occurrenceDate: task.occurrenceDate,
            assigneeProfileId: task.assigneeProfileId == null
                ? null
                : profileIds[task.assigneeProfileId],
            includeInMyPlan: task.includeInMyPlan,
            createdAt: task.createdAt,
            updatedAt: task.updatedAt,
            completedAt: task.completedAt,
            tagIds: {for (final id in task.tagIds) tagIds[id]!},
          ),
      ],
    );
    return _Remapped(remapped, {
      'lists': listIds,
      'tags': tagIds,
      'profiles': profileIds,
      'recurrenceRules': recurrenceIds,
      'tasks': taskIds,
    });
  }

  List<String> _collisions(PlannerSnapshot source, PlannerSnapshot local) {
    final result = <String>[];
    void collect(
      String type,
      Iterable<String> sourceIds,
      Iterable<String> localIds,
    ) {
      final localSet = localIds.toSet();
      for (final id in sourceIds.where(localSet.contains)) {
        result.add('$type:$id');
      }
    }

    collect(
      'task',
      source.tasks.map((value) => value.id),
      local.tasks.map((value) => value.id),
    );
    collect(
      'block',
      source.blocks.map((value) => value.id),
      local.blocks.map((value) => value.id),
    );
    collect(
      'list',
      source.lists.map((value) => value.id),
      local.lists.map((value) => value.id),
    );
    collect(
      'tag',
      source.tags.map((value) => value.id),
      local.tags.map((value) => value.id),
    );
    collect(
      'profile',
      source.profiles.map((value) => value.id),
      local.profiles.map((value) => value.id),
    );
    collect(
      'recurrence',
      source.recurrenceRules.map((value) => value.id),
      local.recurrenceRules.map((value) => value.id),
    );
    return result..sort();
  }

  void _rejectCycles(List<PlannerTask> tasks) {
    final parents = {for (final task in tasks) task.id: task.parentTaskId};
    for (final task in tasks) {
      final seen = <String>{task.id};
      var cursor = task.parentTaskId;
      while (cursor != null) {
        if (!seen.add(cursor)) {
          throw const _ValidationException(
            DayplanValidationCode.taskCycle,
            'The imported tasks contain a parent cycle.',
          );
        }
        cursor = parents[cursor];
      }
    }
  }

  void _rejectDuplicateIds(String type, List<Map<String, Object?>> maps) {
    final seen = <String>{};
    for (final map in maps) {
      final id = _string(map, 'id');
      if (!seen.add(id)) {
        throw _ValidationException(
          DayplanValidationCode.duplicateId,
          'Duplicate $type id: $id.',
        );
      }
    }
  }

  List<Map<String, Object?>> _maps(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! List) {
      throw _ValidationException(
        DayplanValidationCode.incomplete,
        '$key must be an array.',
      );
    }
    return [
      for (final item in value)
        if (item is Map)
          Map<String, Object?>.from(item)
        else
          throw _ValidationException(
            DayplanValidationCode.value,
            '$key contains a non-object value.',
          ),
    ];
  }

  List<Map<String, Object?>> _mapList(Map<String, Object?> map, String key) =>
      _maps(map, key);

  Map<String, Object?> _object(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! Map) {
      throw _ValidationException(
        DayplanValidationCode.incomplete,
        '$key must be an object.',
      );
    }
    return Map<String, Object?>.from(value);
  }

  String _string(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! String || value.isEmpty) {
      throw _ValidationException(
        DayplanValidationCode.value,
        '$key must be a non-empty string.',
      );
    }
    return value;
  }

  String? _nullableString(Object? value) => value == null
      ? null
      : value is String
      ? value
      : throw const _ValidationException(
          DayplanValidationCode.value,
          'Expected a string or null.',
        );

  int _integer(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! int) {
      throw _ValidationException(
        DayplanValidationCode.value,
        '$key must be an integer.',
      );
    }
    return value;
  }

  int? _nullableInteger(Object? value) => value == null
      ? null
      : value is int
      ? value
      : throw const _ValidationException(
          DayplanValidationCode.value,
          'Expected an integer or null.',
        );

  bool _boolean(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! bool) {
      throw _ValidationException(
        DayplanValidationCode.value,
        '$key must be true or false.',
      );
    }
    return value;
  }

  List<String> _strings(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! List || value.any((item) => item is! String)) {
      throw _ValidationException(
        DayplanValidationCode.value,
        '$key must be a string array.',
      );
    }
    return value.cast<String>();
  }

  List<int> _integers(Map<String, Object?> map, String key) {
    final value = map[key];
    if (value is! List || value.any((item) => item is! int)) {
      throw _ValidationException(
        DayplanValidationCode.value,
        '$key must be an integer array.',
      );
    }
    return value.cast<int>();
  }

  DateTime _utcInstant(String value, String field) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null || !value.endsWith('Z') || !parsed.isUtc) {
      throw _ValidationException(
        DayplanValidationCode.timestamp,
        '$field must be an ISO-8601 UTC timestamp.',
      );
    }
    return parsed;
  }

  DateTime? _nullableInstant(Object? value, String field) => value == null
      ? null
      : value is String
      ? _utcInstant(value, field)
      : throw _ValidationException(
          DayplanValidationCode.timestamp,
          '$field must be a UTC timestamp or null.',
        );

  DateTime _date(String value, String field) {
    final match = RegExp(r'^\d{4}-\d{2}-\d{2}$').firstMatch(value);
    final parsed = DateTime.tryParse(value);
    if (match == null || parsed == null) {
      throw _ValidationException(
        DayplanValidationCode.timestamp,
        '$field must be a calendar date.',
      );
    }
    return parsed;
  }

  DateTime? _nullableDate(Object? value, String field) => value == null
      ? null
      : value is String
      ? _date(value, field)
      : throw _ValidationException(
          DayplanValidationCode.timestamp,
          '$field must be a date or null.',
        );

  T _enumValue<T extends Enum>(List<T> values, String name, String field) =>
      values.where((value) => value.name == name).firstOrNull ??
      (throw _ValidationException(
        DayplanValidationCode.value,
        '$field has an unsupported value.',
      ));
}

final class _Remapped {
  const _Remapped(this.snapshot, this.idMaps);
  final PlannerSnapshot snapshot;
  final Map<String, Map<String, String>> idMaps;
}

final class _ValidationException implements Exception {
  const _ValidationException(this.code, this.message);
  final DayplanValidationCode code;
  final String message;
}
