import 'package:anydoes/features/tasks/tasks_controller.dart';
import 'package:flutter/material.dart';

class TaskFilters extends StatelessWidget {
  const TaskFilters({
    required this.query,
    required this.onStatusChanged,
    super.key,
  });

  final TaskQuery query;
  final ValueChanged<TaskStatusFilter> onStatusChanged;

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
