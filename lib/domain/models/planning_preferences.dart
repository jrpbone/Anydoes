enum AppThemeMode { system, light, dark }

final class PlanningPreferences {
  PlanningPreferences({
    this.horizonDays = 14,
    this.defaultMinimumSessionMinutes = 25,
    this.defaultMaximumSessionMinutes = 90,
    this.notificationOffsetMinutes = 0,
    this.notificationsEnabled = true,
    this.themeMode = AppThemeMode.system,
    this.highContrast = false,
    this.reduceMotion = false,
  }) {
    if (horizonDays < 7 || horizonDays > 30) {
      throw ArgumentError.value(
        horizonDays,
        'horizonDays',
        'Must be 7 through 30',
      );
    }
    if (defaultMinimumSessionMinutes < 5) {
      throw ArgumentError.value(
        defaultMinimumSessionMinutes,
        'defaultMinimumSessionMinutes',
        'Minimum is five',
      );
    }
    if (defaultMaximumSessionMinutes < defaultMinimumSessionMinutes) {
      throw ArgumentError.value(
        defaultMaximumSessionMinutes,
        'defaultMaximumSessionMinutes',
        'Must meet minimum',
      );
    }
  }

  final int horizonDays;
  final int defaultMinimumSessionMinutes;
  final int defaultMaximumSessionMinutes;
  final int notificationOffsetMinutes;
  final bool notificationsEnabled;
  final AppThemeMode themeMode;
  final bool highContrast;
  final bool reduceMotion;

  PlanningPreferences copyWith({
    int? horizonDays,
    int? defaultMinimumSessionMinutes,
    int? defaultMaximumSessionMinutes,
    int? notificationOffsetMinutes,
    bool? notificationsEnabled,
    AppThemeMode? themeMode,
    bool? highContrast,
    bool? reduceMotion,
  }) => PlanningPreferences(
    horizonDays: horizonDays ?? this.horizonDays,
    defaultMinimumSessionMinutes:
        defaultMinimumSessionMinutes ?? this.defaultMinimumSessionMinutes,
    defaultMaximumSessionMinutes:
        defaultMaximumSessionMinutes ?? this.defaultMaximumSessionMinutes,
    notificationOffsetMinutes:
        notificationOffsetMinutes ?? this.notificationOffsetMinutes,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    themeMode: themeMode ?? this.themeMode,
    highContrast: highContrast ?? this.highContrast,
    reduceMotion: reduceMotion ?? this.reduceMotion,
  );
}
