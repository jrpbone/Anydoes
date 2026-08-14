import 'package:anydoes/domain/models/planning_preferences.dart';
import 'package:flutter/material.dart';

class AppearanceSettings extends StatelessWidget {
  const AppearanceSettings({
    required this.preferences,
    required this.onChanged,
    super.key,
  });

  final PlanningPreferences preferences;
  final Future<void> Function({
    AppThemeMode? themeMode,
    bool? highContrast,
    bool? reduceMotion,
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
            'Appearance & accessibility',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          const Text('Changes apply immediately on this device.'),
          const SizedBox(height: 14),
          SegmentedButton<AppThemeMode>(
            segments: const [
              ButtonSegment(
                value: AppThemeMode.system,
                icon: Icon(Icons.brightness_auto_outlined),
                label: Text('System'),
              ),
              ButtonSegment(
                value: AppThemeMode.light,
                icon: Icon(Icons.light_mode_outlined),
                label: Text('Light'),
              ),
              ButtonSegment(
                value: AppThemeMode.dark,
                icon: Icon(Icons.dark_mode_outlined),
                label: Text('Dark', key: Key('theme-dark')),
              ),
            ],
            selected: {preferences.themeMode},
            onSelectionChanged: (value) => onChanged(themeMode: value.single),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('High contrast'),
            subtitle: const Text('Strengthen borders and color contrast.'),
            value: preferences.highContrast,
            onChanged: (value) => onChanged(highContrast: value),
          ),
          SwitchListTile(
            key: const Key('reduce-motion'),
            contentPadding: EdgeInsets.zero,
            title: const Text('Reduce motion'),
            subtitle: const Text('Minimize non-essential interface animation.'),
            value: preferences.reduceMotion,
            onChanged: (value) => onChanged(reduceMotion: value),
          ),
        ],
      ),
    ),
  );
}
