/// A collection of pre-built [PageRouteBuilder] factory methods for common
/// screen transition animations.
///
/// All routes use [PageRouteBuilder] so they are compatible with
/// [Navigator.push]. Choose the method that best matches the navigation intent:
/// - Forward navigation → [slideFromRight] or [slideAndFade]
/// - Modal/overlay → [slideFromBottom]
/// - Subtle transitions → [fade] or [fadeSlide] (via [CustomPageRoute])
/// - Special actions → [scale] or [rotateAndFade]
library;

import 'package:flutter/material.dart';

/// Provides static factory methods that each return a configured [Route]
/// for the given destination [Widget].
class RouteAnimations {
  /// Slides the new page in from the right — the standard forward-navigation
  /// feel on Android. Uses [Curves.easeInOutCubic] at 350 ms.
  static Route<T> slideFromRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  /// Slides the new page in from the left — gives a "back" feel and can be
  /// used for lateral sibling navigation.
  static Route<T> slideFromLeft<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  /// Slides the new page up from the bottom — suitable for modals, action
  /// sheets, and detail overlays. Uses [Curves.easeOutCubic] at 400 ms.
  static Route<T> slideFromBottom<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  /// Cross-fades between the current and new page.
  ///
  /// [duration] defaults to 300 ms but can be overridden.
  static Route<T> fade<T>(Widget page, {Duration? duration}) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: duration ?? const Duration(milliseconds: 300),
    );
  }

  /// Scales the new page from 80 % to 100 % combined with a fade.
  /// Useful for drill-down transitions (e.g. card → detail).
  static Route<T> scale<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: 0.8, end: 1.0).chain(CurveTween(curve: curve));

        return ScaleTransition(
          scale: animation.drive(tween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  /// Combines a slight rotation (-2 °), scale, and fade. Designed for
  /// high-emphasis actions or celebratory moments.
  static Route<T> rotateAndFade<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;

        var rotationTween = Tween(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: curve));

        return RotationTransition(
          turns: animation.drive(Tween(begin: -0.02, end: 0.0)),
          child: ScaleTransition(
            scale: animation.drive(rotationTween),
            child: FadeTransition(opacity: animation, child: child),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  /// Slides and fades simultaneously in the given [direction].
  ///
  /// This is the most versatile option — smooth without being distracting.
  /// Defaults to [SlideDirection.right] (standard forward navigation).
  static Route<T> slideAndFade<T>(
    Widget page, {
    SlideDirection direction = SlideDirection.right,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final Offset begin;
        switch (direction) {
          case SlideDirection.right:
            begin = const Offset(1.0, 0.0);
            break;
          case SlideDirection.left:
            begin = const Offset(-1.0, 0.0);
            break;
          case SlideDirection.up:
            begin = const Offset(0.0, -1.0);
            break;
          case SlideDirection.down:
            begin = const Offset(0.0, 1.0);
            break;
        }

        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var slideTween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  /// Mimics the Material shared-axis pattern in one of three axes.
  ///
  /// Horizontal and vertical axes slide + fade; scaled axis zooms + fades.
  /// Use [SharedAxisTransitionType] to select the axis.
  static Route<T> sharedAxis<T>(
    Widget page, {
    SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;

        final enterAnimation = CurvedAnimation(parent: animation, curve: curve);

        switch (type) {
          case SharedAxisTransitionType.horizontal:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.3, 0.0),
                end: Offset.zero,
              ).animate(enterAnimation),
              child: FadeTransition(opacity: enterAnimation, child: child),
            );
          case SharedAxisTransitionType.vertical:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.3),
                end: Offset.zero,
              ).animate(enterAnimation),
              child: FadeTransition(opacity: enterAnimation, child: child),
            );
          case SharedAxisTransitionType.scaled:
            return ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(enterAnimation),
              child: FadeTransition(opacity: enterAnimation, child: child),
            );
        }
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  /// Replicates the native iOS push animation: page slides from the right
  /// using [Curves.linearToEaseOut] (forward) and [Curves.easeInToLinear]
  /// (reverse), at 400 ms.
  static Route<T> cupertinoStyle<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.linearToEaseOut,
                  reverseCurve: Curves.easeInToLinear,
                ),
              ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

/// The four cardinal directions a slide transition can originate from.
enum SlideDirection {
  /// Page enters from the right (default forward navigation).
  right,

  /// Page enters from the left (back navigation feel).
  left,

  /// Page enters from above.
  up,

  /// Page enters from below (modal feel).
  down,
}

/// Axis type for [RouteAnimations.sharedAxis].
enum SharedAxisTransitionType {
  /// Horizontal slide + fade (most common).
  horizontal,

  /// Vertical slide + fade.
  vertical,

  /// Scale zoom + fade.
  scaled,
}
