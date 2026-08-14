import 'package:anydoes/domain/models/availability.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateExceptionEditor extends StatelessWidget {
  const DateExceptionEditor({
    required this.exceptions,
    required this.onSet,
    required this.onRemove,
    super.key,
  });

  final List<AvailabilityException> exceptions;
  final Future<void> Function(DateTime, List<AvailabilityWindow>) onSet;
  final ValueChanged<DateTime> onRemove;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Date exceptions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          const Text('Mark a day unavailable or replace its normal hours.'),
          const SizedBox(height: 12),
          if (exceptions.isEmpty)
            const Text('No date-specific exceptions.')
          else
            for (final exception in exceptions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(DateFormat.yMMMd().format(exception.date)),
                subtitle: Text(
                  exception.windows.isEmpty
                      ? 'Unavailable all day'
                      : exception.windows
                            .map(
                              (window) =>
                                  '${_time(window.startMinute)}–${_time(window.endMinute)}',
                            )
                            .join(', '),
                ),
                trailing: IconButton(
                  tooltip: 'Remove date exception',
                  onPressed: () => onRemove(exception.date),
                  icon: const Icon(Icons.delete_outline),
                ),
              ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.tonalIcon(
              onPressed: () => _addUnavailable(context),
              icon: const Icon(Icons.event_busy_outlined),
              label: const Text('Add unavailable day'),
            ),
          ),
        ],
      ),
    ),
  );

  Future<void> _addUnavailable(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      initialDate: now,
    );
    if (date != null) await onSet(date, const []);
  }

  String _time(int minute) {
    final hour = minute ~/ 60;
    final period = hour < 12 ? 'AM' : 'PM';
    return '${hour % 12 == 0 ? 12 : hour % 12} $period';
  }
}
