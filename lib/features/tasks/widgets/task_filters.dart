import 'package:anydoes/domain/models/profile.dart';
import 'package:anydoes/domain/models/tag.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/features/tasks/tasks_controller.dart';
import 'package:flutter/material.dart';

class TaskFilters extends StatelessWidget {
  const TaskFilters({
    required this.query,
    required this.onStatusChanged,
    required this.profiles,
    required this.tags,
    required this.onPriorityChanged,
    required this.onAssigneeChanged,
    required this.onTagChanged,
    super.key,
  });

  final TaskQuery query;
  final ValueChanged<TaskStatusFilter> onStatusChanged;
  final List<LocalProfile> profiles;
  final List<TaskTag> tags;
  final ValueChanged<TaskPriority?> onPriorityChanged;
  final ValueChanged<String?> onAssigneeChanged;
  final ValueChanged<String?> onTagChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final status in TaskStatusFilter.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_label(status)),
                selected: query.status == status,
                onSelected: (_) => onStatusChanged(status),
              ),
            ),
          const SizedBox(width: 4),
          _FilterMenu<TaskPriority>(
            key: const Key('priority-filter'),
            label: query.priority?.name ?? 'Any priority',
            values: TaskPriority.values,
            valueLabel: (value) => value.name,
            onSelected: onPriorityChanged,
          ),
          const SizedBox(width: 8),
          _FilterMenu<String>(
            key: const Key('assignee-filter'),
            label: query.assigneeProfileId == null
                ? 'Any assignee'
                : profiles
                          .where(
                            (profile) => profile.id == query.assigneeProfileId,
                          )
                          .map((profile) => profile.name)
                          .firstOrNull ??
                      'Any assignee',
            values: profiles.map((profile) => profile.id).toList(),
            valueLabel: (id) => profiles
                .where((profile) => profile.id == id)
                .map((profile) => profile.name)
                .first,
            onSelected: onAssigneeChanged,
          ),
          const SizedBox(width: 8),
          _FilterMenu<String>(
            key: const Key('tag-filter'),
            label: query.tagId == null
                ? 'Any tag'
                : tags
                          .where((tag) => tag.id == query.tagId)
                          .map((tag) => tag.name)
                          .firstOrNull ??
                      'Any tag',
            values: tags.map((tag) => tag.id).toList(),
            valueLabel: (id) =>
                tags.where((tag) => tag.id == id).map((tag) => tag.name).first,
            onSelected: onTagChanged,
          ),
        ],
      ),
    );
  }

  String _label(TaskStatusFilter status) => switch (status) {
    TaskStatusFilter.open => 'Open',
    TaskStatusFilter.completed => 'Completed',
    TaskStatusFilter.archived => 'Archived',
    TaskStatusFilter.all => 'All',
  };
}

class _FilterMenu<T> extends StatelessWidget {
  const _FilterMenu({
    required this.label,
    required this.values,
    required this.valueLabel,
    required this.onSelected,
    super.key,
  });

  final String label;
  final List<T> values;
  final String Function(T value) valueLabel;
  final ValueChanged<T?> onSelected;

  @override
  Widget build(BuildContext context) => PopupMenuButton<T?>(
    tooltip: label,
    onSelected: onSelected,
    itemBuilder: (_) => [
      PopupMenuItem<T?>(value: null, child: const Text('Any')),
      for (final value in values)
        PopupMenuItem<T?>(value: value, child: Text(valueLabel(value))),
    ],
    child: Chip(
      avatar: const Icon(Icons.filter_alt_outlined, size: 18),
      label: Text(label),
    ),
  );
}
