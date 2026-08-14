import 'package:anydoes/domain/models/task.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.onTap,
    required this.onComplete,
    required this.onArchive,
    super.key,
  });

  final PlannerTask task;
  final VoidCallback onTap;
  final ValueChanged<bool> onComplete;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: Checkbox(
          value: task.status == TaskStatus.completed,
          onChanged: (value) => onComplete(value ?? false),
          semanticLabel: 'Complete ${task.title}',
        ),
        title: Text(
          task.title,
          style: task.status == TaskStatus.completed
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Wrap(
          spacing: 10,
          runSpacing: 4,
          children: [
            if (task.estimatedMinutes != null)
              _Meta(
                icon: Icons.schedule,
                label: '${task.remainingMinutes} min',
              ),
            if (task.deadline != null)
              _Meta(
                icon: Icons.flag_outlined,
                label: MaterialLocalizations.of(
                  context,
                ).formatShortDate(task.deadline!.toLocal()),
              ),
            if (task.priority.index >= TaskPriority.high.index)
              _Meta(icon: Icons.priority_high, label: task.priority.name),
          ],
        ),
        trailing: IconButton(
          tooltip: 'Archive ${task.title}',
          onPressed: onArchive,
          icon: Icon(Icons.archive_outlined, color: colors.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14),
        const SizedBox(width: 3),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
