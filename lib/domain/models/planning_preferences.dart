final class PlanningPreferences {
  PlanningPreferences({
    this.horizonDays = 14,
    this.defaultMinimumSessionMinutes = 25,
    this.defaultMaximumSessionMinutes = 90,
    this.notificationOffsetMinutes = 0,
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
}
