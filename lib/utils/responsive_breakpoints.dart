/// Breakpoint constants and helper utilities for responsive layout decisions.
///
/// Use [ResponsiveBreakpoints] static methods anywhere you need to adapt
/// padding, grid columns, or values to the current screen width without
/// pulling in a full responsive-framework dependency.
library;

/// Defines the three-tier breakpoint system (mobile / tablet / desktop) and
/// provides static helpers to query the current tier or pick tier-appropriate
/// values.
class ResponsiveBreakpoints {
  /// Maximum width (exclusive) treated as a mobile screen, in logical pixels.
  static const double mobile = 600;

  /// Minimum width (inclusive) treated as a tablet screen.
  static const double tablet = 900;

  /// Minimum width (inclusive) treated as a desktop screen.
  static const double desktop = 1200;

  /// Returns `true` when [width] is below [mobile] (< 600 px).
  static bool isMobile(double width) => width < mobile;

  /// Returns `true` when [width] is in the tablet range [600, 1200).
  static bool isTablet(double width) => width >= mobile && width < desktop;

  /// Returns `true` when [width] is at or above [desktop] (≥ 1200 px).
  static bool isDesktop(double width) => width >= desktop;

  /// Returns a tier-appropriate value given the current [width].
  ///
  /// Falls back to the next smaller tier if a larger-tier value is not
  /// provided: desktop → tablet → mobile.
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

  /// Returns the recommended number of grid columns for the given [width].
  ///
  /// | Tier    | Columns |
  /// |---------|---------|
  /// | Desktop | 4       |
  /// | Tablet  | 3       |
  /// | Mobile  | 2       |
  static int gridColumns(double width) {
    if (isDesktop(width)) return 4;
    if (isTablet(width)) return 3;
    return 2;
  }

  /// Returns the maximum content width to prevent overly wide layouts on large
  /// screens. Returns [double.infinity] on mobile (fill available width).
  static double contentMaxWidth(double width) {
    if (isDesktop(width)) return 1400;
    if (isTablet(width)) return 1000;
    return double.infinity;
  }

  /// Returns the recommended horizontal padding for the given [width].
  ///
  /// | Tier    | Padding |
  /// |---------|---------|
  /// | Desktop | 40 px   |
  /// | Tablet  | 24 px   |
  /// | Mobile  | 16 px   |
  static double horizontalPadding(double width) {
    if (isDesktop(width)) return 40;
    if (isTablet(width)) return 24;
    return 16;
  }
}
