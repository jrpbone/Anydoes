import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlockEditor extends StatelessWidget {
  const BlockEditor({
    required this.title,
    required this.start,
    required this.end,
    required this.proposed,
    required this.onMove,
    required this.onResize,
    this.onAccept,
    this.onRemove,
    this.onComplete,
    this.onSkip,
    super.key,
  });

  final String title;
  final DateTime start;
  final DateTime end;
  final bool proposed;
  final ValueChanged<DateTime> onMove;
  final ValueChanged<Duration> onResize;
  final VoidCallback? onAccept;
  final VoidCallback? onRemove;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final duration = end.difference(start);
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${DateFormat.jm().format(start.toLocal())} – ${DateFormat.jm().format(end.toLocal())}',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () =>
                    onMove(start.subtract(const Duration(minutes: 30))),
                icon: const Icon(Icons.arrow_upward),
                label: const Text('Earlier 30 min'),
              ),
              OutlinedButton.icon(
                onPressed: () => onMove(start.add(const Duration(minutes: 30))),
                icon: const Icon(Icons.arrow_downward),
                label: const Text('Later 30 min'),
              ),
              OutlinedButton(
                onPressed: duration.inMinutes <= 15
                    ? null
                    : () => onResize(duration - const Duration(minutes: 15)),
                child: const Text('Shorter 15 min'),
              ),
              OutlinedButton(
                onPressed: () =>
                    onResize(duration + const Duration(minutes: 15)),
                child: const Text('Longer 15 min'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (proposed && onRemove != null)
          TextButton(onPressed: onRemove, child: const Text('Remove')),
        if (!proposed && onSkip != null)
          TextButton(onPressed: onSkip, child: const Text('Skip')),
        if (!proposed && onComplete != null)
          FilledButton.tonal(
            onPressed: onComplete,
            child: const Text('Complete block'),
          ),
        if (proposed && onAccept != null)
          FilledButton(onPressed: onAccept, child: const Text('Accept block')),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
