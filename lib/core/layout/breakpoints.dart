enum AppLayoutClass { compact, medium, expanded }

abstract final class AppBreakpoints {
  static const double compact = 600;
  static const double expanded = 1024;

  static AppLayoutClass layoutFor(double width) {
    if (width < compact) return AppLayoutClass.compact;
    if (width < expanded) return AppLayoutClass.medium;
    return AppLayoutClass.expanded;
  }
}
