import 'package:flutter/material.dart';

enum PageTransitionType {
  fade,
  slideFromRight,
  slideFromBottom,
  fadeSlide,
  scale,
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget page;
  final PageTransitionType transitionType;
  final Duration duration;
  final Curve curve;

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
