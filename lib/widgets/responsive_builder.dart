/// Responsive layout utilities built on [ResponsiveBreakpoints].
library;

import 'package:flutter/material.dart';
import 'package:acquariumfe/utils/responsive_breakpoints.dart';

/// Provides responsive breakpoint information to a builder callback.
///
/// Reads the current screen width via [MediaQuery] and resolves it into a
/// [ResponsiveInfo] instance that exposes [ResponsiveInfo.isMobile],
/// [ResponsiveInfo.isTablet], and [ResponsiveInfo.isDesktop] flags as well as
/// the raw [ResponsiveInfo.screenWidth].
///
/// Example:
/// ```dart
/// ResponsiveBuilder(
///   builder: (context, info) => info.isMobile
///       ? const MobileLayout()
///       : const DesktopLayout(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveInfo info) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final info = ResponsiveInfo(
      isMobile: ResponsiveBreakpoints.isMobile(width),
      isTablet: ResponsiveBreakpoints.isTablet(width),
      isDesktop: ResponsiveBreakpoints.isDesktop(width),
      screenWidth: width,
    );

    return builder(context, info);
  }
}

/// Snapshot of the current responsive layout state.
///
/// Passed to [ResponsiveBuilder.builder] and used by [ResponsiveInfo.value]
/// to select the correct variant for the active screen size:
/// ```dart
/// final columns = info.value(mobile: 1, tablet: 2, desktop: 3);
/// ```
class ResponsiveInfo {
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;
  final double screenWidth;

  const ResponsiveInfo({
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
    required this.screenWidth,
  });

  /// Ritorna valore in base al device type
  T value<T>({required T mobile, T? tablet, T? desktop}) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }
}

/// Centers content within a max-width constraint on large screens.
///
/// Uses [ResponsiveBreakpoints.contentMaxWidth] and
/// [ResponsiveBreakpoints.horizontalPadding] as defaults, both of which can
/// be overridden via [maxWidth] and [padding].
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final defaultMaxWidth = ResponsiveBreakpoints.contentMaxWidth(width);
    final defaultPadding = EdgeInsets.symmetric(
      horizontal: ResponsiveBreakpoints.horizontalPadding(width),
    );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? defaultMaxWidth),
        child: Padding(padding: padding ?? defaultPadding, child: child),
      ),
    );
  }
}
