import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/recurrence/recurrence_engine.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:uuid/uuid.dart';

typedef RecurrenceIdFactory = String Function();

final class RecurrenceService {
  RecurrenceService(
    this._repository,
    this._engine,
    this._clock, {
    RecurrenceIdFactory? idFactory,
  }) : _idFactory = idFactory ?? const Uuid().v4;

  final PlannerRepository _repository;
  final RecurrenceEngine _engine;
  final AppClock _clock;
  final RecurrenceIdFactory _idFactory;

  Future<void> materializeThrough(DateTime horizon) async {
    final now = _clock.now();
    final cap = DateTime.utc(now.year, now.month, now.day + 89);
    final requested = DateTime.utc(horizon.year, horizon.month, horizon.day);
    final through = requested.isBefore(cap) ? requested : cap;
    final snapshot = await _repository.currentSnapshot();
    final rules = {for (final rule in snapshot.recurrenceRules) rule.id: rule};
    final tasksToCreate = <PlannerTask>[];

    final bySeries = <String, List<PlannerTask>>{};
    for (final task in snapshot.tasks) {
      if (task.recurrenceRuleId == null) continue;
      final seriesId = task.recurrenceSeriesId ?? task.id;
      bySeries.putIfAbsent(seriesId, () => []).add(task);
    }

    for (final entry in bySeries.entries) {
      final tasks = entry.value;
      tasks.sort((a, b) => _occurrenceDate(a).compareTo(_occurrenceDate(b)));
      final seed = tasks.first;
      final rule = rules[seed.recurrenceRuleId];
      if (rule == null) continue;
      final anchor = _occurrenceDate(seed);
      final existingDates = {
        for (final task in tasks) _dateKey(_occurrenceDate(task)),
      };
      for (final occurrence in _engine.occurrences(rule, anchor, through)) {
        if (!existingDates.add(_dateKey(occurrence))) continue;
        tasksToCreate.add(_copyOccurrence(seed, entry.key, occurrence, anchor));
      }
    }

    if (tasksToCreate.isNotEmpty) {
      await _repository.saveTasks(tasksToCreate);
    }
  }

  PlannerTask _copyOccurrence(
    PlannerTask seed,
    String seriesId,
    DateTime occurrence,
    DateTime anchor,
  ) {
    final shift = occurrence.difference(anchor);
    return PlannerTask.create(
      id: _idFactory(),
      title: seed.title,
      notes: seed.notes,
      listId: seed.listId,
      parentTaskId: seed.parentTaskId,
      priority: seed.priority,
      earliestStart: seed.earliestStart?.add(shift),
      deadline: seed.deadline?.add(shift),
      estimatedMinutes: seed.estimatedMinutes,
      remainingMinutes: seed.estimatedMinutes,
      allowSplit: seed.allowSplit,
      minimumSessionMinutes: seed.minimumSessionMinutes,
      maximumSessionMinutes: seed.maximumSessionMinutes,
      recurrenceRuleId: seed.recurrenceRuleId,
      recurrenceSeriesId: seriesId,
      occurrenceDate: occurrence,
      assigneeProfileId: seed.assigneeProfileId,
      includeInMyPlan: seed.includeInMyPlan,
      createdAt: _clock.now(),
      tagIds: seed.tagIds,
    );
  }
}

DateTime _occurrenceDate(PlannerTask task) {
  final value = task.occurrenceDate ?? task.createdAt;
  return DateTime.utc(value.year, value.month, value.day);
}

String _dateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
