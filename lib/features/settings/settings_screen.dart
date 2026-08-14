import 'package:anydoes/features/settings/settings_controller.dart';
import 'package:anydoes/app/providers.dart';
import 'package:anydoes/features/settings/widgets/appearance_settings.dart';
import 'package:anydoes/features/settings/widgets/availability_editor.dart';
import 'package:anydoes/features/settings/widgets/date_exception_editor.dart';
import 'package:anydoes/features/settings/widgets/data_portability_section.dart';
import 'package:anydoes/features/settings/widgets/planning_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final reminderWarning = ref.watch(notificationCoordinatorProvider);
    final cards = [
      AvailabilityEditor(
        windows: state.snapshot.weeklyAvailability,
        onAdd: controller.addWeeklyWindow,
        onRemove: controller.removeWeeklyWindow,
      ),
      DateExceptionEditor(
        exceptions: state.snapshot.availabilityExceptions,
        onSet: controller.setDateException,
        onRemove: controller.removeDateException,
      ),
      PlanningSettings(
        preferences: state.snapshot.preferences,
        onChanged: controller.updatePlanning,
      ),
      AppearanceSettings(
        preferences: state.snapshot.preferences,
        onChanged: controller.setAppearance,
      ),
      const DataPortabilitySection(),
    ];
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const Text('Shape Anydoes around the way you work.'),
                        ],
                      ),
                    ),
                    if (state.isLoading)
                      const CircularProgressIndicator(strokeWidth: 2),
                  ],
                ),
              ),
            ),
            if (state.failure != null || reminderWarning != null)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(state.failure ?? reminderWarning!),
                    ),
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              sliver: constraints.maxWidth >= 950
                  ? SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            mainAxisExtent: 430,
                          ),
                      delegate: SliverChildListDelegate(cards),
                    )
                  : SliverList.separated(
                      itemCount: cards.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (_, index) => cards[index],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
