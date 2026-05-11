/// A [PageRouteBuilder] subclass that supports several named transition styles.
///
/// Use [CustomPageRoute] when you need to push a route with a non-default
/// animation without writing a full [PageRouteBuilder] inline. Pick the desired
/// style via [PageTransitionType].
library;

import 'package:flutter/material.dart';

/// Enumeration of the available page transition animations.
enum PageTransitionType {
  /// Simple cross-fade between old and new page.
  fade,

  /// Slides the new page in from the right (standard forward navigation).
  slideFromRight,

  /// Slides the new page in from the bottom (modal-style presentation).
  slideFromBottom,

  /// Combines a short horizontal slide (3 % of screen width) with a fade.
  /// This is the default — feels smooth without being distracting.
  fadeSlide,

  /// Scales the new page from 92 % to 100 % combined with a fade.
  scale,
}

/// A custom [PageRouteBuilder] with configurable transition animation.
///
/// Example:
/// ```dart
/// Navigator.of(context).push(
///   CustomPageRoute(
///     page: const MyScreen(),
///     transitionType: PageTransitionType.slideFromBottom,
///   ),
/// );
/// ```
class CustomPageRoute extends PageRouteBuilder {
  /// The widget to display as the destination page.
  final Widget page;

  /// The animation style to use when the route enters/exits.
  final PageTransitionType transitionType;

  /// Duration of both the forward and reverse transitions.
  final Duration duration;

  /// The easing curve applied to the transition animation.
  final Curve curve;

  /// Creates a [CustomPageRoute].
  ///
  /// [page] is required; all other parameters have sensible defaults
  /// ([PageTransitionType.fadeSlide], 350 ms, [Curves.easeOutCubic]).
  CustomPageRoute({
    required this.page,
    this.transitionType = PageTransitionType.fadeSlide,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOutCubic,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           switch (transitionType) {
             case PageTransitionType.fade:
               return FadeTransition(opacity: animation, child: child);

             case PageTransitionType.slideFromRight:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(1.0, 0.0),
                   end: Offset.zero,
                 ).animate(CurvedAnimation(parent: animation, curve: curve)),
                 child: child,
               );

             case PageTransitionType.slideFromBottom:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(0.0, 1.0),
                   end: Offset.zero,
                 ).animate(CurvedAnimation(parent: animation, curve: curve)),
                 child: child,
               );

             case PageTransitionType.fadeSlide:
               return SlideTransition(
                 position: Tween<Offset>(
                   begin: const Offset(0.03, 0.0),
                   end: Offset.zero,
                 ).animate(CurvedAnimation(parent: animation, curve: curve)),
                 child: FadeTransition(opacity: animation, child: child),
               );

             case PageTransitionType.scale:
               return ScaleTransition(
                 scale: Tween<double>(
                   begin: 0.92,
                   end: 1.0,
                 ).animate(CurvedAnimation(parent: animation, curve: curve)),
                 child: FadeTransition(opacity: animation, child: child),
               );
           }
         },
       );
}
