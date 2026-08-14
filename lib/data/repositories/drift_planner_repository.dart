import 'dart:async';
import 'dart:math' as math;

import 'package:anydoes/core/result/app_failure.dart';
import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/data/mappers/domain_mappers.dart';
import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/planning_preferences.dart';
import 'package:anydoes/domain/models/profile.dart';
import 'package:anydoes/domain/models/recurrence_rule.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/tag.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/task_list.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:drift/drift.dart';

final class DriftPlannerRepository implements PlannerRepository {
  DriftPlannerRepository(this.database);

  final AppDatabase database;
  final StreamController<void> _changes = StreamController<void>.broadcast();

  @override
  Stream<PlannerSnapshot> watchSnapshot() {
    late StreamController<PlannerSnapshot> controller;
    StreamSubscription<void>? subscription;
    controller = StreamController<PlannerSnapshot>(
      onListen: () {
        subscription = _changes.stream.listen((_) async {
          controller.add(await currentSnapshot());
        });
        currentSnapshot().then(controller.add, onError: controller.addError);
      },
      onCancel: () => subscription?.cancel(),
    );
    return controller.stream;
  }

  @override
  Future<PlannerSnapshot> currentSnapshot() async {
    final taskRows = await (database.select(
      database.taskEntries,
    )..orderBy([(row) => OrderingTerm.asc(row.createdAtMicros)])).get();
    final blockRows = await (database.select(
      database.scheduleBlockEntries,
    )..orderBy([(row) => OrderingTerm.asc(row.startMicros)])).get();
    final listRows = await (database.select(
      database.taskListEntries,
    )..orderBy([(row) => OrderingTerm.asc(row.createdAtMicros)])).get();
    final tagRows = await (database.select(
      database.tagEntries,
    )..orderBy([(row) => OrderingTerm.asc(row.name)])).get();
    final taskTagRows = await database.select(database.taskTagEntries).get();
    final profileRows =
        await (database.select(database.profileEntries)..orderBy([
              (row) => OrderingTerm.desc(row.isMe),
              (row) => OrderingTerm.asc(row.name),
            ]))
            .get();
    final recurrenceRows = await database
        .select(database.recurrenceRuleEntries)
        .get();
    final weeklyRows =
        await (database.select(database.weeklyAvailabilityEntries)..orderBy([
              (row) => OrderingTerm.asc(row.weekday),
              (row) => OrderingTerm.asc(row.startMinute),
            ]))
            .get();
    final exceptionRows =
        await (database.select(database.availabilityExceptionEntries)..orderBy([
              (row) => OrderingTerm.asc(row.date),
              (row) => OrderingTerm.asc(row.startMinute),
            ]))
            .get();
    final settingRows = await database.select(database.settingEntries).get();

    final tagsByTask = <String, Set<String>>{};
    for (final link in taskTagRows) {
      tagsByTask.putIfAbsent(link.taskId, () => <String>{}).add(link.tagId);
    }

    final exceptionGroups = <String, List<AvailabilityWindow>>{};
    for (final row in exceptionRows) {
      final windows = exceptionGroups.putIfAbsent(row.date, () => []);
      if (row.startMinute != null && row.endMinute != null) {
        final date = _parseDate(row.date);
        windows.add(
          AvailabilityWindow(
            weekday: date.weekday,
            startMinute: row.startMinute!,
            endMinute: row.endMinute!,
          ),
        );
      }
    }
    final settings = {for (final row in settingRows) row.key: row.value};

    return PlannerSnapshot(
      tasks: [
        for (final row in taskRows)
          row.toDomain(tagsByTask[row.id] ?? const {}),
      ],
      blocks: [for (final row in blockRows) row.toDomain()],
      lists: [for (final row in listRows) row.toDomain()],
      tags: [for (final row in tagRows) row.toDomain()],
      profiles: [for (final row in profileRows) row.toDomain()],
      recurrenceRules: [for (final row in recurrenceRows) row.toDomain()],
      weeklyAvailability: [for (final row in weeklyRows) row.toDomain()],
      availabilityExceptions: [
        for (final entry in exceptionGroups.entries)
          AvailabilityException(
            date: _parseDate(entry.key),
            windows: entry.value,
          ),
      ],
      preferences: PlanningPreferences(
        horizonDays: int.tryParse(settings['horizonDays'] ?? '') ?? 14,
        defaultMinimumSessionMinutes:
            int.tryParse(settings['minimumSessionMinutes'] ?? '') ?? 25,
        defaultMaximumSessionMinutes:
            int.tryParse(settings['maximumSessionMinutes'] ?? '') ?? 90,
        notificationOffsetMinutes:
            int.tryParse(settings['notificationOffsetMinutes'] ?? '') ?? 0,
      ),
    );
  }

  @override
  Future<void> initializeDefaults() => _guard(() async {
    await database.transaction(() async {
      final now = DateTime.now().toUtc();
      await database
          .into(database.taskListEntries)
          .insert(
            TaskList(
              id: 'inbox',
              name: 'Inbox',
              createdAt: now,
              isInbox: true,
            ).toCompanion(),
            mode: InsertMode.insertOrIgnore,
          );
      await database
          .into(database.profileEntries)
          .insert(
            LocalProfile(id: 'me', name: 'Me', isMe: true).toCompanion(),
            mode: InsertMode.insertOrIgnore,
          );
      for (
        var weekday = DateTime.monday;
        weekday <= DateTime.friday;
        weekday++
      ) {
        await database
            .into(database.weeklyAvailabilityEntries)
            .insert(
              AvailabilityWindow(
                weekday: weekday,
                startMinute: 9 * 60,
                endMinute: 17 * 60,
              ).toCompanion(),
              mode: InsertMode.insertOrIgnore,
            );
      }
      await _writeSetting('horizonDays', '14', InsertMode.insertOrIgnore);
      await _writeSetting(
        'minimumSessionMinutes',
        '25',
        InsertMode.insertOrIgnore,
      );
      await _writeSetting(
        'maximumSessionMinutes',
        '90',
        InsertMode.insertOrIgnore,
      );
      await _writeSetting(
        'notificationOffsetMinutes',
        '0',
        InsertMode.insertOrIgnore,
      );
    });
    _notify();
  });

  @override
  Future<void> saveTask(PlannerTask task) => _guard(() async {
    await database.transaction(() async {
      await _validateParentChain(task);
      await database
          .into(database.taskEntries)
          .insertOnConflictUpdate(task.toCompanion());
      await (database.delete(
        database.taskTagEntries,
      )..where((row) => row.taskId.equals(task.id))).go();
      for (final tagId in task.tagIds) {
        await database
            .into(database.taskTagEntries)
            .insert(
              TaskTagEntriesCompanion.insert(taskId: task.id, tagId: tagId),
              mode: InsertMode.insertOrIgnore,
            );
      }
    });
    _notify();
  });

  @override
  Future<void> saveTasks(Iterable<PlannerTask> tasks) => _guard(() async {
    await database.transaction(() async {
      for (final task in tasks) {
        await _validateParentChain(task);
        await database
            .into(database.taskEntries)
            .insertOnConflictUpdate(task.toCompanion());
        await (database.delete(
          database.taskTagEntries,
        )..where((row) => row.taskId.equals(task.id))).go();
        for (final tagId in task.tagIds) {
          await database
              .into(database.taskTagEntries)
              .insert(
                TaskTagEntriesCompanion.insert(taskId: task.id, tagId: tagId),
                mode: InsertMode.insertOrIgnore,
              );
        }
      }
    });
    _notify();
  });

  @override
  Future<void> saveList(TaskList list) => _write(
    () => database
        .into(database.taskListEntries)
        .insertOnConflictUpdate(list.toCompanion()),
  );

  @override
  Future<void> saveTag(TaskTag tag) => _write(
    () => database
        .into(database.tagEntries)
        .insertOnConflictUpdate(tag.toCompanion()),
  );

  @override
  Future<void> saveProfile(LocalProfile profile) => _write(
    () => database
        .into(database.profileEntries)
        .insertOnConflictUpdate(profile.toCompanion()),
  );

  @override
  Future<void> saveRecurrenceRule(RecurrenceRule rule) => _write(
    () => database
        .into(database.recurrenceRuleEntries)
        .insertOnConflictUpdate(rule.toCompanion()),
  );

  @override
  Future<void> saveAvailability({
    required List<AvailabilityWindow> weekly,
    required List<AvailabilityException> exceptions,
  }) => _guard(() async {
    _validateWindows(weekly);
    for (final exception in exceptions) {
      _validateWindows(exception.windows);
    }
    await database.transaction(() async {
      await database.delete(database.weeklyAvailabilityEntries).go();
      await database.delete(database.availabilityExceptionEntries).go();
      for (final window in weekly) {
        await database
            .into(database.weeklyAvailabilityEntries)
            .insert(window.toCompanion());
      }
      for (final exception in exceptions) {
        final key = _dateKey(exception.date);
        if (exception.windows.isEmpty) {
          await database
              .into(database.availabilityExceptionEntries)
              .insert(
                AvailabilityExceptionEntriesCompanion.insert(
                  date: key,
                  startMinute: const Value(null),
                  endMinute: const Value(null),
                ),
              );
        }
        for (final window in exception.windows) {
          await database
              .into(database.availabilityExceptionEntries)
              .insert(
                AvailabilityExceptionEntriesCompanion.insert(
                  date: key,
                  startMinute: Value(window.startMinute),
                  endMinute: Value(window.endMinute),
                ),
              );
        }
      }
    });
    _notify();
  });

  @override
  Future<void> acceptProposal(Iterable<ScheduleBlock> blocks) =>
      _guard(() async {
        await database.transaction(() async {
          for (final block in blocks) {
            await database
                .into(database.scheduleBlockEntries)
                .insertOnConflictUpdate(
                  block.toCompanion(forceState: ScheduleBlockState.accepted),
                );
          }
        });
        _notify();
      });

  @override
  Future<void> saveBlock(ScheduleBlock block) => _write(
    () => database
        .into(database.scheduleBlockEntries)
        .insertOnConflictUpdate(block.toCompanion()),
  );

  @override
  Future<void> completeBlock(String blockId, DateTime completedAt) =>
      _guard(() async {
        await database.transaction(() async {
          final block = await (database.select(
            database.scheduleBlockEntries,
          )..where((row) => row.id.equals(blockId))).getSingleOrNull();
          if (block == null) {
            throw const AppFailure(
              code: AppFailureCode.validation,
              message: 'Schedule block not found.',
              recovery: 'Refresh the plan and try again.',
            );
          }
          if (block.completionState == BlockCompletionState.completed.name) {
            return;
          }
          await (database.update(
            database.scheduleBlockEntries,
          )..where((row) => row.id.equals(blockId))).write(
            const ScheduleBlockEntriesCompanion(
              completionState: Value('completed'),
              state: Value('accepted'),
            ),
          );
          if (block.taskId != null) {
            final task = await (database.select(
              database.taskEntries,
            )..where((row) => row.id.equals(block.taskId!))).getSingleOrNull();
            if (task != null && task.remainingMinutes != null) {
              final durationMinutes =
                  (block.endMicros - block.startMicros) ~/
                  Duration.microsecondsPerMinute;
              await (database.update(
                database.taskEntries,
              )..where((row) => row.id.equals(task.id))).write(
                TaskEntriesCompanion(
                  remainingMinutes: Value(
                    math.max(0, task.remainingMinutes! - durationMinutes),
                  ),
                  updatedAtMicros: Value(
                    completedAt.toUtc().microsecondsSinceEpoch,
                  ),
                ),
              );
            }
          }
        });
        _notify();
      });

  @override
  Future<void> completeTask(
    String taskId,
    DateTime completedAt, {
    required bool removeFutureBlocks,
  }) => _guard(() async {
    await database.transaction(() async {
      await (database.update(
        database.taskEntries,
      )..where((row) => row.id.equals(taskId))).write(
        TaskEntriesCompanion(
          status: Value(TaskStatus.completed.name),
          remainingMinutes: const Value(0),
          completedAtMicros: Value(completedAt.toUtc().microsecondsSinceEpoch),
          updatedAtMicros: Value(completedAt.toUtc().microsecondsSinceEpoch),
        ),
      );
      if (removeFutureBlocks) {
        await (database.delete(database.scheduleBlockEntries)..where(
              (row) =>
                  row.taskId.equals(taskId) &
                  row.startMicros.isBiggerThanValue(
                    completedAt.toUtc().microsecondsSinceEpoch,
                  ),
            ))
            .go();
      }
    });
    _notify();
  });

  @override
  Future<void> deleteList(String listId, ListDeletionPolicy policy) =>
      _guard(() async {
        if (listId == 'inbox') {
          throw const AppFailure(
            code: AppFailureCode.validation,
            message: 'Inbox cannot be deleted.',
            recovery: 'Choose another list.',
          );
        }
        await database.transaction(() async {
          if (policy == ListDeletionPolicy.moveTasksToInbox) {
            await (database.update(database.taskEntries)
                  ..where((row) => row.listId.equals(listId)))
                .write(const TaskEntriesCompanion(listId: Value('inbox')));
          } else {
            await (database.delete(
              database.taskEntries,
            )..where((row) => row.listId.equals(listId))).go();
          }
          await (database.delete(
            database.taskListEntries,
          )..where((row) => row.id.equals(listId))).go();
        });
        _notify();
      });

  @override
  Future<void> deleteProfile(String profileId) => _guard(() async {
    if (profileId == 'me') {
      throw const AppFailure(
        code: AppFailureCode.validation,
        message: 'The Me profile cannot be deleted.',
        recovery: 'Edit the profile instead.',
      );
    }
    await database.transaction(() async {
      await (database.update(database.taskEntries)
            ..where((row) => row.assigneeProfileId.equals(profileId)))
          .write(const TaskEntriesCompanion(assigneeProfileId: Value(null)));
      await (database.delete(
        database.profileEntries,
      )..where((row) => row.id.equals(profileId))).go();
    });
    _notify();
  });

  @override
  Future<void> replaceSnapshot(PlannerSnapshot snapshot) => _guard(() async {
    await database.transaction(() async {
      await _clearAll();
      await _insertSnapshot(snapshot);
    });
    _notify();
  });

  @override
  Future<void> mergeSnapshot(PlannerSnapshot snapshot) => _guard(() async {
    await database.transaction(() => _insertSnapshot(snapshot));
    _notify();
  });

  Future<void> _insertSnapshot(PlannerSnapshot snapshot) async {
    for (final list in snapshot.lists) {
      await database
          .into(database.taskListEntries)
          .insertOnConflictUpdate(list.toCompanion());
    }
    for (final profile in snapshot.profiles) {
      await database
          .into(database.profileEntries)
          .insertOnConflictUpdate(profile.toCompanion());
    }
    for (final tag in snapshot.tags) {
      await database
          .into(database.tagEntries)
          .insertOnConflictUpdate(tag.toCompanion());
    }
    for (final rule in snapshot.recurrenceRules) {
      await database
          .into(database.recurrenceRuleEntries)
          .insertOnConflictUpdate(rule.toCompanion());
    }
    for (final task in snapshot.tasks) {
      await database
          .into(database.taskEntries)
          .insertOnConflictUpdate(task.toCompanion());
      for (final tagId in task.tagIds) {
        await database
            .into(database.taskTagEntries)
            .insert(
              TaskTagEntriesCompanion.insert(taskId: task.id, tagId: tagId),
              mode: InsertMode.insertOrReplace,
            );
      }
    }
    for (final block in snapshot.blocks) {
      await database
          .into(database.scheduleBlockEntries)
          .insertOnConflictUpdate(block.toCompanion());
    }
    for (final window in snapshot.weeklyAvailability) {
      await database
          .into(database.weeklyAvailabilityEntries)
          .insert(window.toCompanion(), mode: InsertMode.insertOrReplace);
    }
    for (final exception in snapshot.availabilityExceptions) {
      final key = _dateKey(exception.date);
      if (exception.windows.isEmpty) {
        await database
            .into(database.availabilityExceptionEntries)
            .insert(
              AvailabilityExceptionEntriesCompanion.insert(
                date: key,
                startMinute: const Value(null),
                endMinute: const Value(null),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final window in exception.windows) {
        await database
            .into(database.availabilityExceptionEntries)
            .insert(
              AvailabilityExceptionEntriesCompanion.insert(
                date: key,
                startMinute: Value(window.startMinute),
                endMinute: Value(window.endMinute),
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
    }
    await _writeSetting(
      'horizonDays',
      '${snapshot.preferences.horizonDays}',
      InsertMode.insertOrReplace,
    );
    await _writeSetting(
      'minimumSessionMinutes',
      '${snapshot.preferences.defaultMinimumSessionMinutes}',
      InsertMode.insertOrReplace,
    );
    await _writeSetting(
      'maximumSessionMinutes',
      '${snapshot.preferences.defaultMaximumSessionMinutes}',
      InsertMode.insertOrReplace,
    );
    await _writeSetting(
      'notificationOffsetMinutes',
      '${snapshot.preferences.notificationOffsetMinutes}',
      InsertMode.insertOrReplace,
    );
  }

  Future<void> _clearAll() async {
    await database.delete(database.taskTagEntries).go();
    await database.delete(database.scheduleBlockEntries).go();
    await database.delete(database.taskEntries).go();
    await database.delete(database.tagEntries).go();
    await database.delete(database.recurrenceRuleEntries).go();
    await database.delete(database.profileEntries).go();
    await database.delete(database.taskListEntries).go();
    await database.delete(database.weeklyAvailabilityEntries).go();
    await database.delete(database.availabilityExceptionEntries).go();
    await database.delete(database.settingEntries).go();
  }

  Future<void> _validateParentChain(PlannerTask task) async {
    if (task.parentTaskId == null) return;
    final rows = await database.select(database.taskEntries).get();
    final parents = {for (final row in rows) row.id: row.parentTaskId};
    parents[task.id] = task.parentTaskId;
    String? cursor = task.parentTaskId;
    final visited = <String>{task.id};
    while (cursor != null) {
      if (!visited.add(cursor)) {
        throw const AppFailure(
          code: AppFailureCode.validation,
          message: 'A task cannot contain a subtask cycle.',
          recovery: 'Choose a parent outside this task chain.',
        );
      }
      cursor = parents[cursor];
    }
  }

  void _validateWindows(List<AvailabilityWindow> windows) {
    final byWeekday = <int, List<AvailabilityWindow>>{};
    for (final window in windows) {
      byWeekday.putIfAbsent(window.weekday, () => []).add(window);
    }
    for (final dayWindows in byWeekday.values) {
      dayWindows.sort((a, b) => a.startMinute.compareTo(b.startMinute));
      for (var index = 1; index < dayWindows.length; index++) {
        if (dayWindows[index].startMinute < dayWindows[index - 1].endMinute) {
          throw const AppFailure(
            code: AppFailureCode.validation,
            message: 'Availability windows cannot overlap.',
            recovery: 'Adjust the start or end time.',
          );
        }
      }
    }
  }

  Future<void> _writeSetting(String key, String value, InsertMode mode) =>
      database
          .into(database.settingEntries)
          .insert(
            SettingEntriesCompanion.insert(key: key, value: value),
            mode: mode,
          );

  Future<void> _write(Future<Object?> Function() operation) => _guard(() async {
    await operation();
    _notify();
  });

  Future<void> _guard(Future<void> Function() operation) async {
    try {
      await operation();
    } on AppFailure {
      rethrow;
    } catch (error) {
      throw AppFailure(
        code: AppFailureCode.persistence,
        message: 'The local planner data could not be updated.',
        recovery: 'Nothing was partially saved. Try again.',
        cause: error,
      );
    }
  }

  void _notify() => _changes.add(null);
}

String _dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

DateTime _parseDate(String value) {
  final parts = value.split('-').map(int.parse).toList();
  return DateTime(parts[0], parts[1], parts[2]);
}
