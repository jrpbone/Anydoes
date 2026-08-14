import 'package:anydoes/domain/models/planning_preferences.dart';
import 'package:flutter/material.dart';

class PlanningSettings extends StatelessWidget {
  const PlanningSettings({
    required this.preferences,
    required this.onChanged,
    super.key,
  });

  final PlanningPreferences preferences;
  final Future<void> Function({
    int? horizonDays,
    int? minimumSessionMinutes,
    int? maximumSessionMinutes,
    int? notificationOffsetMinutes,
    bool? notificationsEnabled,
  })
  onChanged;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Planning defaults',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          const Text('Used for new tasks and automatic schedule proposals.'),
          const SizedBox(height: 16),
          Text('Planning horizon: ${preferences.horizonDays} days'),
          Slider(
            key: const Key('planning-horizon'),
            value: preferences.horizonDays.toDouble(),
            min: 7,
            max: 30,
            divisions: 23,
            label: '${preferences.horizonDays} days',
            onChanged: (value) => onChanged(horizonDays: value.round()),
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  isExpanded: true,
                  initialValue: preferences.defaultMinimumSessionMinutes,
                  decoration: const InputDecoration(labelText: 'Min session'),
                  items: const [5, 15, 20, 25, 30, 45, 60]
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text('$value min'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => onChanged(
                    minimumSessionMinutes: value,
                    maximumSessionMinutes:
                        preferences.defaultMaximumSessionMinutes < value!
                        ? value
                        : null,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int>(
                  isExpanded: true,
                  initialValue: preferences.defaultMaximumSessionMinutes,
                  decoration: const InputDecoration(labelText: 'Max session'),
                  items: const [25, 30, 45, 60, 90, 120, 180, 240]
                      .where(
                        (value) =>
                            value >= preferences.defaultMinimumSessionMinutes,
                      )
                      .map(
                        (value) => DropdownMenuItem(
                          value: value,
                          child: Text('$value min'),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => onChanged(maximumSessionMinutes: value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Local reminders'),
            subtitle: const Text('Remind me before accepted schedule blocks.'),
            value: preferences.notificationsEnabled,
            onChanged: (value) => onChanged(notificationsEnabled: value),
          ),
          if (preferences.notificationsEnabled)
            DropdownButtonFormField<int>(
              initialValue: preferences.notificationOffsetMinutes,
              decoration: const InputDecoration(labelText: 'Reminder time'),
              items: const [0, 5, 10, 15, 30, 60]
                  .map(
                    (value) => DropdownMenuItem(
                      value: value,
                      child: Text(
                        value == 0 ? 'At start time' : '$value min before',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) => onChanged(notificationOffsetMinutes: value),
            ),
        ],
      ),
    ),
  );
}
