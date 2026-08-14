import 'package:anydoes/domain/models/availability.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvailabilityEditor extends StatelessWidget {
  const AvailabilityEditor({
    required this.windows,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final List<AvailabilityWindow> windows;
  final Future<void> Function(int weekday, int start, int end) onAdd;
  final ValueChanged<AvailabilityWindow> onRemove;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Weekly availability',
      subtitle: 'The scheduler only proposes work inside these windows.',
      child: Column(
        children: [
          for (
            var weekday = DateTime.monday;
            weekday <= DateTime.sunday;
            weekday++
          )
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 42,
                    child: Text(
                      DateFormat.E().format(
                        DateTime(2026, 8, 17 + weekday - 1),
                      ),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final window in windows.where(
                          (item) => item.weekday == weekday,
                        ))
                          InputChip(
                            label: Text(
                              '${_time(window.startMinute)}–${_time(window.endMinute)}',
                            ),
                            onDeleted: () => onRemove(window),
                          ),
                        ActionChip(
                          avatar: const Icon(Icons.add, size: 18),
                          label: const Text('Window'),
                          onPressed: () => _showAddDialog(context, weekday),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, int weekday) async {
    var start = 9 * 60;
    var end = 17 * 60;
    final result = await showDialog<(int, int)>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add availability window'),
          content: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: start,
                  decoration: const InputDecoration(labelText: 'Start'),
                  items: _hours(allowMidnightEnd: false),
                  onChanged: (value) => setState(() => start = value!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: end,
                  decoration: const InputDecoration(labelText: 'End'),
                  items: _hours(allowMidnightEnd: true),
                  onChanged: (value) => setState(() => end = value!),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: end > start
                  ? () => Navigator.pop(context, (start, end))
                  : null,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
    if (result != null && context.mounted) {
      try {
        await onAdd(weekday, result.$1, result.$2);
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('That window overlaps another one.')),
        );
      }
    }
  }

  List<DropdownMenuItem<int>> _hours({required bool allowMidnightEnd}) => [
    for (
      var hour = allowMidnightEnd ? 1 : 0;
      hour <= (allowMidnightEnd ? 24 : 23);
      hour++
    )
      DropdownMenuItem(value: hour * 60, child: Text(_time(hour * 60))),
  ];

  String _time(int minute) {
    if (minute == 1440) return '12 AM';
    final hour = minute ~/ 60;
    final period = hour < 12 ? 'AM' : 'PM';
    final display = hour % 12 == 0 ? 12 : hour % 12;
    return '$display $period';
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(subtitle),
          const SizedBox(height: 8),
          child,
        ],
      ),
    ),
  );
}
