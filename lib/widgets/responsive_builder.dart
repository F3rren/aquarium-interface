import 'package:flutter/material.dart';
import 'package:acquariumfe/utils/responsive_breakpoints.dart';

/// Widget builder responsive che fornisce breakpoint info
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

/// Informazioni sul layout responsive corrente
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
  T value<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }
}

/// Layout che centra il contenuto con max width su schermi grandi
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
        child: Padding(
          padding: padding ?? defaultPadding,
          child: child,
        ),
      ),
    );
  }
}
