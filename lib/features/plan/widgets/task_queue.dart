import 'package:anydoes/domain/models/task.dart';
import 'package:flutter/material.dart';

class TaskQueue extends StatelessWidget {
  const TaskQueue({required this.tasks, super.key});

  final List<PlannerTask> tasks;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.inbox_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Unscheduled',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(label: Text('${tasks.length}')),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                      child: Text('Everything with a duration is placed.'),
                    )
                  : ListView.separated(
                      itemCount: tasks.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(task.title),
                          subtitle: Text(
                            task.estimatedMinutes == null
                                ? 'Add an estimate to schedule'
                                : _remainingLabel(task.remainingMinutes!),
                          ),
                          trailing: Icon(
                            _priorityIcon(task.priority),
                            size: 18,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _priorityIcon(TaskPriority priority) => switch (priority) {
    TaskPriority.low => Icons.keyboard_arrow_down,
    TaskPriority.normal => Icons.remove,
    TaskPriority.high => Icons.keyboard_arrow_up,
    TaskPriority.urgent => Icons.priority_high,
  };

  String _remainingLabel(int minutes) {
    if (minutes >= 60 && minutes % 60 == 0) {
      final hours = minutes ~/ 60;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} remaining';
    }
    return '$minutes min remaining';
  }
}
