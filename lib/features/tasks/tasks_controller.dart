import 'dart:async';

import 'package:anydoes/core/result/app_failure.dart';
import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/recurrence_rule.dart';
import 'package:anydoes/domain/models/tag.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/task_list.dart';
import 'package:anydoes/domain/recurrence/recurrence_engine.dart';
import 'package:anydoes/domain/recurrence/recurrence_service.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:anydoes/app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

enum TaskStatusFilter { open, completed, archived, all }

final class RecurrenceDraft {
  const RecurrenceDraft({
    required this.frequency,
    this.interval = 1,
    this.weekdays = const {},
    this.until,
    this.occurrenceCount,
  });

  final RecurrenceFrequency frequency;
  final int interval;
  final Set<int> weekdays;
  final DateTime? until;
  final int? occurrenceCount;
}

final class TaskQuery {
  const TaskQuery({
    this.search = '',
    this.listId,
    this.status = TaskStatusFilter.open,
    this.priority,
    this.assigneeProfileId,
    this.tagId,
  });

  final String search;
  final String? listId;
  final TaskStatusFilter status;
  final TaskPriority? priority;
  final String? assigneeProfileId;
  final String? tagId;

  TaskQuery copyWith({
    String? search,
    String? listId,
    bool clearList = false,
    TaskStatusFilter? status,
    TaskPriority? priority,
    bool clearPriority = false,
    String? assigneeProfileId,
    bool clearAssignee = false,
    String? tagId,
    bool clearTag = false,
  }) {
    return TaskQuery(
      search: search ?? this.search,
      listId: clearList ? null : listId ?? this.listId,
      status: status ?? this.status,
      priority: clearPriority ? null : priority ?? this.priority,
      assigneeProfileId: clearAssignee
          ? null
          : assigneeProfileId ?? this.assigneeProfileId,
      tagId: clearTag ? null : tagId ?? this.tagId,
    );
  }

  bool matches(PlannerTask task) {
    final needle = search.trim().toLowerCase();
    if (needle.isNotEmpty &&
        !task.title.toLowerCase().contains(needle) &&
        !(task.notes?.toLowerCase().contains(needle) ?? false)) {
      return false;
    }
    if (listId != null && task.listId != listId) return false;
    if (priority != null && task.priority != priority) return false;
    if (assigneeProfileId != null &&
        task.assigneeProfileId != assigneeProfileId) {
      return false;
    }
    if (tagId != null && !task.tagIds.contains(tagId)) return false;
    return switch (status) {
      TaskStatusFilter.open => task.status == TaskStatus.open,
      TaskStatusFilter.completed => task.status == TaskStatus.completed,
      TaskStatusFilter.archived => task.status == TaskStatus.archived,
      TaskStatusFilter.all => true,
    };
  }
}

final class TaskDraft {
  const TaskDraft({
    required this.title,
    this.notes,
    this.listId = 'inbox',
    this.parentTaskId,
    this.priority = TaskPriority.normal,
    this.earliestStart,
    this.deadline,
    this.estimatedMinutes,
    this.allowSplit = false,
    this.minimumSessionMinutes = 25,
    this.maximumSessionMinutes = 90,
    this.assigneeProfileId,
    this.includeInMyPlan = false,
    this.tagNames = const [],
    this.recurrence,
  });

  final String title;
  final String? notes;
  final String listId;
  final String? parentTaskId;
  final TaskPriority priority;
  final DateTime? earliestStart;
  final DateTime? deadline;
  final int? estimatedMinutes;
  final bool allowSplit;
  final int minimumSessionMinutes;
  final int maximumSessionMinutes;
  final String? assigneeProfileId;
  final bool includeInMyPlan;
  final List<String> tagNames;
  final RecurrenceDraft? recurrence;
}

final class TasksState {
  TasksState({
    PlannerSnapshot? snapshot,
    this.query = const TaskQuery(),
    this.isLoading = true,
    this.failure,
  }) : snapshot = snapshot ?? PlannerSnapshot();

  final PlannerSnapshot snapshot;
  final TaskQuery query;
  final bool isLoading;
  final AppFailure? failure;

  List<PlannerTask> get visibleTasks =>
      snapshot.tasks.where(query.matches).toList()..sort((a, b) {
        final priority = b.priority.index.compareTo(a.priority.index);
        return priority != 0 ? priority : a.createdAt.compareTo(b.createdAt);
      });

  TasksState copyWith({
    PlannerSnapshot? snapshot,
    TaskQuery? query,
    bool? isLoading,
    AppFailure? failure,
    bool clearFailure = false,
  }) => TasksState(
    snapshot: snapshot ?? this.snapshot,
    query: query ?? this.query,
    isLoading: isLoading ?? this.isLoading,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}

final tasksControllerProvider =
    StateNotifierProvider<TasksController, TasksState>((ref) {
      return TasksController(
        ref.watch(plannerRepositoryProvider),
        ref.watch(appClockProvider),
      );
    });

final class TasksController extends StateNotifier<TasksState> {
  TasksController(
    this._repository,
    this._clock, {
    Uuid? uuid,
    RecurrenceService? recurrenceService,
  }) : _uuid = uuid ?? const Uuid(),
       _recurrenceService =
           recurrenceService ??
           RecurrenceService(_repository, RecurrenceEngine(), _clock),
       super(TasksState()) {
    _start();
  }

  final PlannerRepository _repository;
  final AppClock _clock;
  final Uuid _uuid;
  final RecurrenceService _recurrenceService;
  StreamSubscription<PlannerSnapshot>? _subscription;

  Future<void> _start() async {
    try {
      await _repository.initializeDefaults();
      _subscription = _repository.watchSnapshot().listen(
        (snapshot) => state = state.copyWith(
          snapshot: snapshot,
          isLoading: false,
          clearFailure: true,
        ),
        onError: (Object error) => _setFailure(error),
      );
    } catch (error) {
      _setFailure(error);
    }
  }

  Future<void> quickCapture(String title) =>
      createTask(TaskDraft(title: title));

  Future<void> createTask(TaskDraft draft) async {
    try {
      final tagIds = await _resolveTagIds(draft.tagNames);
      final now = _clock.now();
      final taskId = _uuid.v4();
      final recurrenceRuleId = draft.recurrence == null ? null : _uuid.v4();
      final task = PlannerTask.create(
        id: taskId,
        title: draft.title,
        notes: draft.notes,
        listId: draft.listId,
        parentTaskId: draft.parentTaskId,
        priority: draft.priority,
        earliestStart: draft.earliestStart,
        deadline: draft.deadline,
        estimatedMinutes: draft.estimatedMinutes,
        allowSplit: draft.allowSplit,
        minimumSessionMinutes: draft.minimumSessionMinutes,
        maximumSessionMinutes: draft.maximumSessionMinutes,
        assigneeProfileId: draft.assigneeProfileId,
        includeInMyPlan: draft.includeInMyPlan,
        recurrenceRuleId: recurrenceRuleId,
        recurrenceSeriesId: draft.recurrence == null ? null : taskId,
        occurrenceDate: draft.recurrence == null
            ? null
            : DateTime.utc(now.year, now.month, now.day),
        createdAt: now,
        tagIds: tagIds,
      );
      if (draft.recurrence == null) {
        await _repository.saveTask(task);
      } else {
        final recurrence = draft.recurrence!;
        await _repository.saveTaskWithRecurrence(
          task,
          RecurrenceRule(
            id: recurrenceRuleId!,
            frequency: recurrence.frequency,
            interval: recurrence.interval,
            weekdays: recurrence.weekdays,
            until: recurrence.until,
            occurrenceCount: recurrence.occurrenceCount,
          ),
        );
        await _materializeRecurrences();
      }
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<void> updateTask(PlannerTask existing, TaskDraft draft) async {
    try {
      final tagIds = await _resolveTagIds(draft.tagNames);
      final now = _clock.now();
      final estimatedChanged =
          existing.estimatedMinutes != draft.estimatedMinutes;
      final remaining = estimatedChanged
          ? draft.estimatedMinutes == null
                ? null
                : existing.status == TaskStatus.completed
                ? 0
                : draft.estimatedMinutes
          : existing.remainingMinutes;
      final recurrenceId = draft.recurrence == null
          ? null
          : existing.recurrenceRuleId ?? _uuid.v4();
      final updated = existing.copyWith(
        title: draft.title,
        notes: draft.notes,
        listId: draft.listId,
        parentTaskId: draft.parentTaskId,
        priority: draft.priority,
        earliestStart: draft.earliestStart,
        deadline: draft.deadline,
        estimatedMinutes: draft.estimatedMinutes,
        remainingMinutes: remaining,
        allowSplit: draft.allowSplit,
        minimumSessionMinutes: draft.minimumSessionMinutes,
        maximumSessionMinutes: draft.maximumSessionMinutes,
        assigneeProfileId: draft.assigneeProfileId,
        includeInMyPlan: draft.includeInMyPlan,
        recurrenceRuleId: recurrenceId,
        recurrenceSeriesId: draft.recurrence == null
            ? null
            : existing.recurrenceSeriesId ?? existing.id,
        occurrenceDate: draft.recurrence == null
            ? null
            : existing.occurrenceDate ??
                  DateTime.utc(now.year, now.month, now.day),
        updatedAt: now,
        tagIds: tagIds,
      );
      if (draft.recurrence == null) {
        await _repository.saveTask(updated);
      } else {
        final recurrence = draft.recurrence!;
        await _repository.saveTaskWithRecurrence(
          updated,
          RecurrenceRule(
            id: recurrenceId!,
            frequency: recurrence.frequency,
            interval: recurrence.interval,
            weekdays: recurrence.weekdays,
            until: recurrence.until,
            occurrenceCount: recurrence.occurrenceCount,
          ),
        );
        await _materializeRecurrences();
      }
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<Set<String>> _resolveTagIds(Iterable<String> rawNames) async {
    final tagIds = <String>{};
    for (final rawName in rawNames) {
      final name = rawName.trim();
      if (name.isEmpty) continue;
      final existing = state.snapshot.tags
          .where((tag) => tag.name.toLowerCase() == name.toLowerCase())
          .firstOrNull;
      final tag = existing ?? TaskTag(id: _uuid.v4(), name: name);
      if (existing == null) await _repository.saveTag(tag);
      tagIds.add(tag.id);
    }
    return tagIds;
  }

  Future<void> createList(String name) => _repository.saveList(
    TaskList(id: _uuid.v4(), name: name, createdAt: _clock.now()),
  );

  Future<void> deleteList(String id, ListDeletionPolicy policy) async {
    try {
      await _repository.deleteList(id, policy);
      if (state.query.listId == id) selectList(null);
    } catch (error) {
      _setFailure(error);
    }
  }

  Future<void> toggleComplete(PlannerTask task, bool complete) =>
      _repository.saveTask(
        task.copyWith(
          status: complete ? TaskStatus.completed : TaskStatus.open,
          remainingMinutes: task.estimatedMinutes == null
              ? null
              : complete
              ? 0
              : task.estimatedMinutes,
          completedAt: complete ? _clock.now() : null,
          updatedAt: _clock.now(),
        ),
      );

  Future<void> completeTask(
    PlannerTask task, {
    required bool removeFutureBlocks,
  }) => _repository.completeTask(
    task.id,
    _clock.now(),
    removeFutureBlocks: removeFutureBlocks,
  );

  Future<void> archive(PlannerTask task) => _repository.saveTask(
    task.copyWith(status: TaskStatus.archived, updatedAt: _clock.now()),
  );

  void setSearch(String value) {
    state = state.copyWith(query: state.query.copyWith(search: value));
  }

  void selectList(String? id) {
    state = state.copyWith(
      query: id == null
          ? state.query.copyWith(clearList: true)
          : state.query.copyWith(listId: id),
    );
  }

  void setStatus(TaskStatusFilter status) {
    state = state.copyWith(query: state.query.copyWith(status: status));
  }

  void setPriority(TaskPriority? priority) {
    state = state.copyWith(
      query: priority == null
          ? state.query.copyWith(clearPriority: true)
          : state.query.copyWith(priority: priority),
    );
  }

  void setAssignee(String? profileId) {
    state = state.copyWith(
      query: profileId == null
          ? state.query.copyWith(clearAssignee: true)
          : state.query.copyWith(assigneeProfileId: profileId),
    );
  }

  void setTag(String? tagId) {
    state = state.copyWith(
      query: tagId == null
          ? state.query.copyWith(clearTag: true)
          : state.query.copyWith(tagId: tagId),
    );
  }

  void _setFailure(Object error) {
    state = state.copyWith(
      isLoading: false,
      failure: error is AppFailure
          ? error
          : AppFailure(
              code: AppFailureCode.persistence,
              message: 'Tasks could not be refreshed.',
              recovery: 'Try again.',
              cause: error,
            ),
    );
  }

  Future<void> _materializeRecurrences() => _recurrenceService
      .materializeThrough(_clock.now().add(const Duration(days: 90)));

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
