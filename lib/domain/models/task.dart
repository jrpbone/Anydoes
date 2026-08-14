const _unset = Object();

enum TaskStatus { open, completed, archived }

enum TaskPriority { low, normal, high, urgent }

final class PlannerTask {
  const PlannerTask._({
    required this.id,
    required this.title,
    required this.listId,
    required this.status,
    required this.priority,
    required this.estimatedMinutes,
    required this.remainingMinutes,
    required this.allowSplit,
    required this.minimumSessionMinutes,
    required this.maximumSessionMinutes,
    required this.includeInMyPlan,
    required this.createdAt,
    required this.updatedAt,
    required this.tagIds,
    this.notes,
    this.parentTaskId,
    this.earliestStart,
    this.deadline,
    this.recurrenceRuleId,
    this.recurrenceSeriesId,
    this.occurrenceDate,
    this.assigneeProfileId,
    this.completedAt,
  });

  factory PlannerTask.create({
    required String id,
    required String title,
    required String listId,
    required DateTime createdAt,
    String? notes,
    String? parentTaskId,
    TaskStatus status = TaskStatus.open,
    TaskPriority priority = TaskPriority.normal,
    DateTime? earliestStart,
    DateTime? deadline,
    int? estimatedMinutes,
    int? remainingMinutes,
    bool allowSplit = false,
    int minimumSessionMinutes = 25,
    int maximumSessionMinutes = 90,
    String? recurrenceRuleId,
    String? recurrenceSeriesId,
    DateTime? occurrenceDate,
    String? assigneeProfileId,
    bool includeInMyPlan = false,
    DateTime? updatedAt,
    DateTime? completedAt,
    Set<String> tagIds = const {},
  }) {
    final cleanId = id.trim();
    final cleanTitle = title.trim();
    final cleanListId = listId.trim();
    if (cleanId.isEmpty) throw ArgumentError.value(id, 'id', 'Required');
    if (cleanTitle.isEmpty) {
      throw ArgumentError.value(title, 'title', 'Cannot be blank');
    }
    if (cleanListId.isEmpty) {
      throw ArgumentError.value(listId, 'listId', 'Required');
    }
    if (parentTaskId == cleanId) {
      throw ArgumentError.value(
        parentTaskId,
        'parentTaskId',
        'Cannot reference itself',
      );
    }
    if (estimatedMinutes != null && estimatedMinutes <= 0) {
      throw ArgumentError.value(
        estimatedMinutes,
        'estimatedMinutes',
        'Must be positive',
      );
    }
    final resolvedRemaining = estimatedMinutes == null
        ? null
        : remainingMinutes ?? estimatedMinutes;
    if (estimatedMinutes == null && remainingMinutes != null) {
      throw ArgumentError.value(
        remainingMinutes,
        'remainingMinutes',
        'Requires an estimate',
      );
    }
    if (resolvedRemaining != null &&
        (resolvedRemaining < 0 || resolvedRemaining > estimatedMinutes!)) {
      throw ArgumentError.value(
        resolvedRemaining,
        'remainingMinutes',
        'Must be between zero and the estimate',
      );
    }
    if (minimumSessionMinutes < 5) {
      throw ArgumentError.value(
        minimumSessionMinutes,
        'minimumSessionMinutes',
        'Minimum is five',
      );
    }
    if (maximumSessionMinutes < minimumSessionMinutes) {
      throw ArgumentError.value(
        maximumSessionMinutes,
        'maximumSessionMinutes',
        'Must meet minimum',
      );
    }
    final startUtc = earliestStart?.toUtc();
    final deadlineUtc = deadline?.toUtc();
    if (startUtc != null &&
        deadlineUtc != null &&
        deadlineUtc.isBefore(startUtc)) {
      throw ArgumentError.value(
        deadline,
        'deadline',
        'Cannot precede earliest start',
      );
    }
    final createdUtc = createdAt.toUtc();
    return PlannerTask._(
      id: cleanId,
      title: cleanTitle,
      notes: _cleanNullable(notes),
      listId: cleanListId,
      parentTaskId: _cleanNullable(parentTaskId),
      status: status,
      priority: priority,
      earliestStart: startUtc,
      deadline: deadlineUtc,
      estimatedMinutes: estimatedMinutes,
      remainingMinutes: resolvedRemaining,
      allowSplit: allowSplit,
      minimumSessionMinutes: minimumSessionMinutes,
      maximumSessionMinutes: maximumSessionMinutes,
      recurrenceRuleId: _cleanNullable(recurrenceRuleId),
      recurrenceSeriesId: _cleanNullable(recurrenceSeriesId),
      occurrenceDate: occurrenceDate?.toUtc(),
      assigneeProfileId: _cleanNullable(assigneeProfileId),
      includeInMyPlan: includeInMyPlan,
      createdAt: createdUtc,
      updatedAt: (updatedAt ?? createdAt).toUtc(),
      completedAt: completedAt?.toUtc(),
      tagIds: Set.unmodifiable(tagIds),
    );
  }

  final String id;
  final String title;
  final String? notes;
  final String listId;
  final String? parentTaskId;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? earliestStart;
  final DateTime? deadline;
  final int? estimatedMinutes;
  final int? remainingMinutes;
  final bool allowSplit;
  final int minimumSessionMinutes;
  final int maximumSessionMinutes;
  final String? recurrenceRuleId;
  final String? recurrenceSeriesId;
  final DateTime? occurrenceDate;
  final String? assigneeProfileId;
  final bool includeInMyPlan;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final Set<String> tagIds;

  bool get canAutoSchedule =>
      status == TaskStatus.open &&
      estimatedMinutes != null &&
      (remainingMinutes ?? 0) > 0;

  PlannerTask copyWith({
    String? title,
    Object? notes = _unset,
    String? listId,
    Object? parentTaskId = _unset,
    TaskStatus? status,
    TaskPriority? priority,
    Object? earliestStart = _unset,
    Object? deadline = _unset,
    Object? estimatedMinutes = _unset,
    Object? remainingMinutes = _unset,
    bool? allowSplit,
    int? minimumSessionMinutes,
    int? maximumSessionMinutes,
    Object? recurrenceRuleId = _unset,
    Object? recurrenceSeriesId = _unset,
    Object? occurrenceDate = _unset,
    Object? assigneeProfileId = _unset,
    bool? includeInMyPlan,
    DateTime? updatedAt,
    Object? completedAt = _unset,
    Set<String>? tagIds,
  }) {
    return PlannerTask.create(
      id: id,
      title: title ?? this.title,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
      listId: listId ?? this.listId,
      parentTaskId: identical(parentTaskId, _unset)
          ? this.parentTaskId
          : parentTaskId as String?,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      earliestStart: identical(earliestStart, _unset)
          ? this.earliestStart
          : earliestStart as DateTime?,
      deadline: identical(deadline, _unset)
          ? this.deadline
          : deadline as DateTime?,
      estimatedMinutes: identical(estimatedMinutes, _unset)
          ? this.estimatedMinutes
          : estimatedMinutes as int?,
      remainingMinutes: identical(remainingMinutes, _unset)
          ? this.remainingMinutes
          : remainingMinutes as int?,
      allowSplit: allowSplit ?? this.allowSplit,
      minimumSessionMinutes:
          minimumSessionMinutes ?? this.minimumSessionMinutes,
      maximumSessionMinutes:
          maximumSessionMinutes ?? this.maximumSessionMinutes,
      recurrenceRuleId: identical(recurrenceRuleId, _unset)
          ? this.recurrenceRuleId
          : recurrenceRuleId as String?,
      recurrenceSeriesId: identical(recurrenceSeriesId, _unset)
          ? this.recurrenceSeriesId
          : recurrenceSeriesId as String?,
      occurrenceDate: identical(occurrenceDate, _unset)
          ? this.occurrenceDate
          : occurrenceDate as DateTime?,
      assigneeProfileId: identical(assigneeProfileId, _unset)
          ? this.assigneeProfileId
          : assigneeProfileId as String?,
      includeInMyPlan: includeInMyPlan ?? this.includeInMyPlan,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
      completedAt: identical(completedAt, _unset)
          ? this.completedAt
          : completedAt as DateTime?,
      tagIds: tagIds ?? this.tagIds,
    );
  }
}

String? _cleanNullable(String? value) {
  final clean = value?.trim();
  return clean == null || clean.isEmpty ? null : clean;
}
