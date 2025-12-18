/// Breakpoint e utility per responsive design
class ResponsiveBreakpoints {
  // Breakpoint standard
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;

  // Helper methods
  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < desktop;
  static bool isDesktop(double width) => width >= desktop;

  // Responsive values
  static T responsive<T>({
    required double width,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(width)) return desktop ?? tablet ?? mobile;
    if (isTablet(width)) return tablet ?? mobile;
    return mobile;
  }

  // Grid column count
  static int gridColumns(double width) {
    if (isDesktop(width)) return 4;
    if (isTablet(width)) return 3;
    return 2;
  }

  // Content max width
  static double contentMaxWidth(double width) {
    if (isDesktop(width)) return 1400;
    if (isTablet(width)) return 1000;
    return double.infinity;
  }

  // Horizontal padding
  static double horizontalPadding(double width) {
    if (isDesktop(width)) return 40;
    if (isTablet(width)) return 24;
    return 16;
  }
}
