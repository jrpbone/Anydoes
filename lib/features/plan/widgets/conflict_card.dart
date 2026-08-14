import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/scheduling/planning_result.dart';
import 'package:flutter/material.dart';

class ConflictCard extends StatelessWidget {
  const ConflictCard({
    required this.conflict,
    required this.task,
    required this.onAction,
    super.key,
  });

  final PlanningConflict conflict;
  final PlannerTask? task;
  final ValueChanged<RecoveryAction> onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: colors.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task?.title ?? 'Task conflict',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              '${conflict.missingMinutes} min could not fit in the planning horizon.',
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final action in conflict.recoveryActions)
                  TextButton(
                    onPressed: () => onAction(action),
                    child: Text(_label(action)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _label(RecoveryAction action) => switch (action) {
    RecoveryAction.extendDeadline => 'Extend deadline',
    RecoveryAction.reduceDuration => 'Reduce duration',
    RecoveryAction.makeSplittable => 'Make splittable',
    RecoveryAction.nextAvailableSlot => 'Find next slot',
  };
}
