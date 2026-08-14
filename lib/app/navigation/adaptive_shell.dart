import 'package:anydoes/app/navigation/app_destination.dart';
import 'package:anydoes/core/layout/breakpoints.dart';
import 'package:anydoes/features/profiles/profiles_screen.dart';
import 'package:anydoes/features/plan/plan_screen.dart';
import 'package:anydoes/features/tasks/tasks_screen.dart';
import 'package:anydoes/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';

class AdaptiveShell extends StatefulWidget {
  const AdaptiveShell({super.key});

  @override
  State<AdaptiveShell> createState() => _AdaptiveShellState();
}

class _AdaptiveShellState extends State<AdaptiveShell> {
  int _selectedIndex = 0;
  final Set<int> _visited = {0};

  static const _pages = <Widget>[
    PlanScreen(),
    TasksScreen(),
    ProfilesScreen(),
    SettingsScreen(),
  ];

  void _select(int index) {
    setState(() {
      _selectedIndex = index;
      _visited.add(index);
    });
  }

  List<Widget> get _activePages => [
    for (var index = 0; index < _pages.length; index++)
      if (_visited.contains(index)) _pages[index] else const SizedBox.shrink(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) =>
          switch (AppBreakpoints.layoutFor(constraints.maxWidth)) {
            AppLayoutClass.compact => _compact(),
            AppLayoutClass.medium => _rail(expanded: false),
            AppLayoutClass.expanded => _rail(expanded: true),
          },
    );
  }

  Widget _compact() {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: _activePages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _select,
        destinations: [
          for (final destination in AppDestination.values)
            NavigationDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: destination.label,
            ),
        ],
      ),
    );
  }

  Widget _rail({required bool expanded}) {
    final rail = NavigationRail(
      extended: expanded,
      selectedIndex: _selectedIndex,
      onDestinationSelected: _select,
      minExtendedWidth: 240,
      leading: expanded
          ? const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Row(
                children: [
                  Icon(Icons.cloud_outlined, size: 30),
                  SizedBox(width: 12),
                  Text(
                    'Anydoes',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            )
          : const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 28),
              child: Tooltip(
                message: 'Anydoes',
                child: Icon(Icons.cloud_outlined, size: 30),
              ),
            ),
      destinations: [
        for (final destination in AppDestination.values)
          NavigationRailDestination(
            icon: Icon(destination.icon),
            selectedIcon: Icon(destination.selectedIcon),
            label: Text(destination.label),
          ),
      ],
    );
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Container(
              key: expanded ? const Key('expanded-sidebar') : null,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: rail,
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: _activePages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
