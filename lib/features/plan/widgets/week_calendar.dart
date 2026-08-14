import 'package:anydoes/domain/models/schedule_block.dart';
import 'package:anydoes/domain/models/task.dart';
import 'package:anydoes/domain/scheduling/planning_result.dart';
import 'package:anydoes/features/plan/widgets/schedule_block_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekCalendar extends StatelessWidget {
  const WeekCalendar({
    required this.anchor,
    required this.accepted,
    required this.proposed,
    required this.tasks,
    required this.onAcceptedTap,
    required this.onProposedTap,
    super.key,
  });

  final DateTime anchor;
  final List<ScheduleBlock> accepted;
  final List<PlannedBlock> proposed;
  final List<PlannerTask> tasks;
  final ValueChanged<ScheduleBlock> onAcceptedTap;
  final ValueChanged<PlannedBlock> onProposedTap;

  @override
  Widget build(BuildContext context) {
    final local = anchor.toLocal();
    final monday = DateTime(
      local.year,
      local.month,
      local.day - (local.weekday - DateTime.monday),
    );
    return Card(
      key: const Key('week-calendar'),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < 7; index++) ...[
              Expanded(
                child: _day(context, monday.add(Duration(days: index)), index),
              ),
              if (index < 6) const VerticalDivider(width: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _day(BuildContext context, DateTime date, int index) {
    final dayAccepted = accepted
        .where((block) => _sameDay(block.start, date))
        .toList();
    final dayProposed = proposed
        .where((block) => _sameDay(block.start, date))
        .toList();
    return Column(
      key: Key('week-day-$index'),
      children: [
        Text(
          DateFormat.E().format(date),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Text('${date.day}', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: [
              for (final block in dayAccepted)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ScheduleBlockCard(
                    title: _title(block.taskId),
                    start: block.start,
                    end: block.end,
                    proposed: false,
                    locked: block.isLocked,
                    onTap: () => onAcceptedTap(block),
                  ),
                ),
              for (final block in dayProposed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: ScheduleBlockCard(
                    title: _title(block.taskId),
                    start: block.start,
                    end: block.end,
                    proposed: true,
                    locked: block.isLocked,
                    reason: block.reason,
                    onTap: () => onProposedTap(block),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _title(String? taskId) =>
      tasks.where((task) => task.id == taskId).firstOrNull?.title ??
      'Fixed event';
}

bool _sameDay(DateTime value, DateTime date) {
  final local = value.toLocal();
  return local.year == date.year &&
      local.month == date.month &&
      local.day == date.day;
}
