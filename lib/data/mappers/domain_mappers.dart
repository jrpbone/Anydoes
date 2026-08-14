import 'package:anydoes/data/database/app_database.dart';
import 'package:anydoes/domain/models/availability.dart';
import 'package:anydoes/domain/models/profile.dart';
import 'package:anydoes/domain/models/recurrence_rule.dart';
import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/tag.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/task_list.dart';
import 'package:drift/drift.dart';

extension PlannerTaskDatabaseMapping on PlannerTask {
  TaskEntriesCompanion toCompanion() => TaskEntriesCompanion.insert(
    id: id,
    title: title,
    notes: Value(notes),
    listId: listId,
    parentTaskId: Value(parentTaskId),
    status: status.name,
    priority: priority.name,
    earliestStartMicros: Value(earliestStart?.microsecondsSinceEpoch),
    deadlineMicros: Value(deadline?.microsecondsSinceEpoch),
    estimatedMinutes: Value(estimatedMinutes),
    remainingMinutes: Value(remainingMinutes),
    allowSplit: allowSplit,
    minimumSessionMinutes: minimumSessionMinutes,
    maximumSessionMinutes: maximumSessionMinutes,
    recurrenceRuleId: Value(recurrenceRuleId),
    recurrenceSeriesId: Value(recurrenceSeriesId),
    occurrenceDateMicros: Value(occurrenceDate?.microsecondsSinceEpoch),
    assigneeProfileId: Value(assigneeProfileId),
    includeInMyPlan: includeInMyPlan,
    createdAtMicros: createdAt.microsecondsSinceEpoch,
    updatedAtMicros: updatedAt.microsecondsSinceEpoch,
    completedAtMicros: Value(completedAt?.microsecondsSinceEpoch),
  );
}

extension TaskEntryDomainMapping on TaskEntry {
  PlannerTask toDomain(Set<String> tagIds) => PlannerTask.create(
    id: id,
    title: title,
    notes: notes,
    listId: listId,
    parentTaskId: parentTaskId,
    status: TaskStatus.values.byName(status),
    priority: TaskPriority.values.byName(priority),
    earliestStart: _date(earliestStartMicros),
    deadline: _date(deadlineMicros),
    estimatedMinutes: estimatedMinutes,
    remainingMinutes: remainingMinutes,
    allowSplit: allowSplit,
    minimumSessionMinutes: minimumSessionMinutes,
    maximumSessionMinutes: maximumSessionMinutes,
    recurrenceRuleId: recurrenceRuleId,
    recurrenceSeriesId: recurrenceSeriesId,
    occurrenceDate: _date(occurrenceDateMicros),
    assigneeProfileId: assigneeProfileId,
    includeInMyPlan: includeInMyPlan,
    createdAt: _date(createdAtMicros)!,
    updatedAt: _date(updatedAtMicros),
    completedAt: _date(completedAtMicros),
    tagIds: tagIds,
  );
}

extension ScheduleBlockDatabaseMapping on ScheduleBlock {
  ScheduleBlockEntriesCompanion toCompanion({ScheduleBlockState? forceState}) =>
      ScheduleBlockEntriesCompanion.insert(
        id: id,
        taskId: Value(taskId),
        startMicros: start.microsecondsSinceEpoch,
        endMicros: end.microsecondsSinceEpoch,
        state: (forceState ?? state).name,
        isLocked: isLocked,
        completionState: completionState.name,
        note: Value(note),
        isGenerated: isGenerated,
      );
}

extension ScheduleBlockEntryDomainMapping on ScheduleBlockEntry {
  ScheduleBlock toDomain() => ScheduleBlock(
    id: id,
    taskId: taskId,
    start: _date(startMicros)!,
    end: _date(endMicros)!,
    state: ScheduleBlockState.values.byName(state),
    isLocked: isLocked,
    completionState: BlockCompletionState.values.byName(completionState),
    note: note,
    isGenerated: isGenerated,
  );
}

extension TaskListDatabaseMapping on TaskList {
  TaskListEntriesCompanion toCompanion() => TaskListEntriesCompanion.insert(
    id: id,
    name: name,
    colorValue: colorValue,
    iconCodePoint: iconCodePoint,
    isInbox: isInbox,
    createdAtMicros: createdAt.toUtc().microsecondsSinceEpoch,
  );
}

extension TaskListEntryDomainMapping on TaskListEntry {
  TaskList toDomain() => TaskList(
    id: id,
    name: name,
    colorValue: colorValue,
    iconCodePoint: iconCodePoint,
    isInbox: isInbox,
    createdAt: _date(createdAtMicros)!,
  );
}

extension TagDatabaseMapping on TaskTag {
  TagEntriesCompanion toCompanion() =>
      TagEntriesCompanion.insert(id: id, name: name, colorValue: colorValue);
}

extension TagEntryDomainMapping on TagEntry {
  TaskTag toDomain() => TaskTag(id: id, name: name, colorValue: colorValue);
}

extension ProfileDatabaseMapping on LocalProfile {
  ProfileEntriesCompanion toCompanion() => ProfileEntriesCompanion.insert(
    id: id,
    name: name,
    colorValue: colorValue,
    isMe: isMe,
  );
}

extension ProfileEntryDomainMapping on ProfileEntry {
  LocalProfile toDomain() =>
      LocalProfile(id: id, name: name, colorValue: colorValue, isMe: isMe);
}

extension RecurrenceRuleDatabaseMapping on RecurrenceRule {
  RecurrenceRuleEntriesCompanion toCompanion() =>
      RecurrenceRuleEntriesCompanion.insert(
        id: id,
        frequency: frequency.name,
        interval: interval,
        weekdays: (weekdays.toList()..sort()).join(','),
        untilDateMicros: Value(until?.toUtc().microsecondsSinceEpoch),
        occurrenceCount: Value(occurrenceCount),
      );
}

extension RecurrenceRuleEntryDomainMapping on RecurrenceRuleEntry {
  RecurrenceRule toDomain() => RecurrenceRule(
    id: id,
    frequency: RecurrenceFrequency.values.byName(frequency),
    interval: interval,
    weekdays: weekdays.isEmpty
        ? const {}
        : weekdays.split(',').map(int.parse).toSet(),
    until: _date(untilDateMicros),
    occurrenceCount: occurrenceCount,
  );
}

extension AvailabilityWindowDatabaseMapping on AvailabilityWindow {
  WeeklyAvailabilityEntriesCompanion toCompanion() =>
      WeeklyAvailabilityEntriesCompanion.insert(
        weekday: weekday,
        startMinute: startMinute,
        endMinute: endMinute,
      );
}

extension WeeklyAvailabilityEntryDomainMapping on WeeklyAvailabilityEntry {
  AvailabilityWindow toDomain() => AvailabilityWindow(
    weekday: weekday,
    startMinute: startMinute,
    endMinute: endMinute,
  );
}

DateTime? _date(int? micros) => micros == null
    ? null
    : DateTime.fromMicrosecondsSinceEpoch(micros, isUtc: true);
