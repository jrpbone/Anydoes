import 'package:flutter/material.dart';

enum AppDestination {
  plan('Plan', Icons.calendar_today_outlined, Icons.calendar_today),
  tasks('Tasks', Icons.check_circle_outline, Icons.check_circle),
  profiles('Profiles', Icons.people_outline, Icons.people),
  settings('Settings', Icons.tune_outlined, Icons.tune);

  const AppDestination(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
