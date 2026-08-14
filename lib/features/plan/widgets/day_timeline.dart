import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/scheduling/planning_result.dart';
import 'package:anydoes/features/plan/widgets/schedule_block_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayTimeline extends StatelessWidget {
  const DayTimeline({
    required this.date,
    required this.accepted,
    required this.proposed,
    required this.tasks,
    required this.onAcceptedTap,
    required this.onProposedTap,
    super.key,
  });

  final DateTime date;
  final List<ScheduleBlock> accepted;
  final List<PlannedBlock> proposed;
  final List<PlannerTask> tasks;
  final ValueChanged<ScheduleBlock> onAcceptedTap;
  final ValueChanged<PlannedBlock> onProposedTap;

  @override
  Widget build(BuildContext context) {
    final dayAccepted = accepted
        .where((block) => _sameDay(block.start, date))
        .toList();
    final dayProposed = proposed
        .where((block) => _sameDay(block.start, date))
        .toList();
    final items = <_TimelineItem>[
      for (final block in dayAccepted) _TimelineItem.accepted(block),
      for (final block in dayProposed) _TimelineItem.proposed(block),
    ]..sort((a, b) => a.start.compareTo(b.start));

    return Card(
      key: const Key('day-timeline'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              DateFormat('EEEE, MMMM d').format(date.toLocal()),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text(
                        'No blocks yet. Plan tasks or add a fixed event.',
                      ),
                    )
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        final task = tasks
                            .where((task) => task.id == item.taskId)
                            .firstOrNull;
                        return ScheduleBlockCard(
                          title: task?.title ?? item.note ?? 'Fixed event',
                          start: item.start,
                          end: item.end,
                          proposed: item.proposal != null,
                          locked: item.locked,
                          reason: item.proposal?.reason,
                          onTap: () => item.proposal != null
                              ? onProposedTap(item.proposal!)
                              : onAcceptedTap(item.block!),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineItem {
  const _TimelineItem({
    required this.start,
    required this.end,
    required this.taskId,
    required this.locked,
    this.note,
    this.block,
    this.proposal,
  });

  factory _TimelineItem.accepted(ScheduleBlock block) => _TimelineItem(
    start: block.start,
    end: block.end,
    taskId: block.taskId,
    locked: block.isLocked,
    note: block.note,
    block: block,
  );

  factory _TimelineItem.proposed(PlannedBlock block) => _TimelineItem(
    start: block.start,
    end: block.end,
    taskId: block.taskId,
    locked: block.isLocked,
    proposal: block,
  );

  final DateTime start;
  final DateTime end;
  final String? taskId;
  final bool locked;
  final String? note;
  final ScheduleBlock? block;
  final PlannedBlock? proposal;
}

bool _sameDay(DateTime left, DateTime right) {
  final a = left.toLocal();
  final b = right.toLocal();
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
