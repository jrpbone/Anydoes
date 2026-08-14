import 'dart:async';

import 'package:anydoes/core/result/app_failure.dart';
import 'package:anydoes/core/time/clock.dart';
import 'package:anydoes/domain/models/planner_snapshot.dart';
import 'package:anydoes/domain/models/tag.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/models/task_list.dart';
import 'package:anydoes/domain/repositories/planner_repository.dart';
import 'package:anydoes/app/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

enum TaskStatusFilter { open, completed, archived, all }

final class TaskQuery {
  const TaskQuery({
    this.search = '',
    this.listId,
    this.status = TaskStatusFilter.open,
    this.priority,
    this.assigneeProfileId,
  });

  final String search;
  final String? listId;
  final TaskStatusFilter status;
  final TaskPriority? priority;
  final String? assigneeProfileId;

  TaskQuery copyWith({
    String? search,
    String? listId,
    bool clearList = false,
    TaskStatusFilter? status,
    TaskPriority? priority,
    bool clearPriority = false,
    String? assigneeProfileId,
    bool clearAssignee = false,
  }) {
    return TaskQuery(
      search: search ?? this.search,
      listId: clearList ? null : listId ?? this.listId,
      status: status ?? this.status,
      priority: clearPriority ? null : priority ?? this.priority,
      assigneeProfileId: clearAssignee
          ? null
          : assigneeProfileId ?? this.assigneeProfileId,
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
  TasksController(this._repository, this._clock, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid(),
      super(TasksState()) {
    _start();
  }

  final PlannerRepository _repository;
  final AppClock _clock;
  final Uuid _uuid;
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
      final tagIds = <String>{};
      for (final rawName in draft.tagNames) {
        final name = rawName.trim();
        if (name.isEmpty) continue;
        final existing = state.snapshot.tags
            .where((tag) => tag.name.toLowerCase() == name.toLowerCase())
            .firstOrNull;
        final tag = existing ?? TaskTag(id: _uuid.v4(), name: name);
        if (existing == null) await _repository.saveTag(tag);
        tagIds.add(tag.id);
      }
      final now = _clock.now();
      await _repository.saveTask(
        PlannerTask.create(
          id: _uuid.v4(),
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
          createdAt: now,
          tagIds: tagIds,
        ),
      );
    } catch (error) {
      _setFailure(error);
      rethrow;
    }
  }

  Future<void> createList(String name) => _repository.saveList(
    TaskList(id: _uuid.v4(), name: name, createdAt: _clock.now()),
  );

  Future<void> toggleComplete(PlannerTask task, bool complete) =>
      _repository.saveTask(
        task.copyWith(
          status: complete ? TaskStatus.completed : TaskStatus.open,
          remainingMinutes: complete ? 0 : task.estimatedMinutes,
          completedAt: complete ? _clock.now() : null,
          updatedAt: _clock.now(),
        ),
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
