import 'package:anydoes/domain/scheduling/task_ranker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleBlockCard extends StatelessWidget {
  const ScheduleBlockCard({
    required this.title,
    required this.start,
    required this.end,
    required this.proposed,
    required this.locked,
    required this.onTap,
    this.reason,
    this.onMoveBy,
    this.onResizeBy,
    super.key,
  });

  final String title;
  final DateTime start;
  final DateTime end;
  final bool proposed;
  final bool locked;
  final SchedulingReason? reason;
  final VoidCallback onTap;
  final ValueChanged<Duration>? onMoveBy;
  final ValueChanged<Duration>? onResizeBy;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label:
          '${proposed ? 'Proposed' : 'Accepted'} block for $title, ${DateFormat.jm().format(start.toLocal())} to ${DateFormat.jm().format(end.toLocal())}${locked ? ', locked' : ''}',
      child: MouseRegion(
        cursor: onMoveBy == null
            ? SystemMouseCursors.click
            : SystemMouseCursors.grab,
        child: GestureDetector(
          onVerticalDragEnd: onMoveBy == null
              ? null
              : (details) => onMoveBy!(
                  Duration(
                    minutes:
                        details.primaryVelocity != null &&
                            details.primaryVelocity! < 0
                        ? -30
                        : 30,
                  ),
                ),
          child: Card(
            color: proposed
                ? colors.primaryContainer.withValues(alpha: 0.55)
                : colors.surfaceContainerLowest,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: proposed ? colors.primary : colors.outlineVariant,
                width: proposed ? 1.5 : 1,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                        if (locked) const Icon(Icons.lock_outline, size: 16),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat.jm().format(start.toLocal())} – ${DateFormat.jm().format(end.toLocal())}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (proposed) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Proposed',
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (reason != null)
                        Text(
                          _reasonLabel(reason!),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                    ],
                    if (onResizeBy != null) ...[
                      const SizedBox(height: 4),
                      Tooltip(
                        message: 'Drag to resize',
                        child: MouseRegion(
                          cursor: SystemMouseCursors.resizeUpDown,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onVerticalDragEnd: (details) => onResizeBy!(
                              Duration(
                                minutes:
                                    details.primaryVelocity != null &&
                                        details.primaryVelocity! < 0
                                    ? -15
                                    : 15,
                              ),
                            ),
                            child: const SizedBox(
                              height: 12,
                              width: double.infinity,
                              child: Center(
                                child: Icon(Icons.drag_handle, size: 16),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _reasonLabel(SchedulingReason reason) => switch (reason) {
    SchedulingReason.urgentDeadline => 'Urgent deadline',
    SchedulingReason.highPriority => 'High priority',
    SchedulingReason.durationPressure => 'Limited free time',
  };
}
