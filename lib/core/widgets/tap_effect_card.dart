/// Tap-feedback wrapper widgets: scale, press, and bounce variants.
library;

import 'package:flutter/material.dart';

/// Wraps a child with configurable scale + ripple tap feedback.
///
/// When [enableScale] is true the child scales down to [scaleAmount] (default
/// 0.97) on `onTapDown` and bounces back on release.  When [enableRipple] is
/// true an [InkWell] with [rippleColor] is placed over the child.
/// Both effects can be independently disabled.  Tapping calls [onTap].
class TapEffectCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;
  final double scaleAmount;
  final bool enableScale;
  final bool enableRipple;
  final Color? rippleColor;

  const TapEffectCard({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 150),
    this.scaleAmount = 0.97,
    this.enableScale = true,
    this.enableRipple = true,
    this.rippleColor,
  });

  @override
  State<TapEffectCard> createState() => _TapEffectCardState();
}

class _TapEffectCardState extends State<TapEffectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleAmount,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enableScale) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.enableScale) {
      _controller.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.enableScale) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = widget.child;

    // Applica scale animation se abilitato
    if (widget.enableScale) {
      content = ScaleTransition(scale: _scaleAnimation, child: content);
    }

    // Applica ripple effect se abilitato
    if (widget.enableRipple && widget.onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          splashColor:
              widget.rippleColor ??
              theme.colorScheme.primary.withValues(alpha: 0.2),
          highlightColor:
              widget.rippleColor?.withValues(alpha: 0.1) ??
              theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          child: widget.child,
        ),
      );
    } else if (widget.onTap != null) {
      // Solo gesture detector senza ripple
      content = GestureDetector(
        onTap: widget.onTap,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: content,
      );
    }

    return content;
  }
}

/// A lighter press widget: scale + opacity without a ripple effect.
///
/// Scales to [pressedScale] (default 0.98) and dims to [pressedOpacity]
/// (default 0.8) for the press duration using implicit [AnimatedScale] and
/// [AnimatedOpacity] widgets (no explicit [AnimationController] needed).
class PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration duration;
  final double pressedScale;
  final double pressedOpacity;

  const PressableCard({
    super.key,
    required this.child,
    this.onPressed,
    this.duration = const Duration(milliseconds: 100),
    this.pressedScale = 0.98,
    this.pressedOpacity = 0.8,
  });

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1.0,
        duration: widget.duration,
        curve: Curves.easeInOut,
        child: AnimatedOpacity(
          opacity: _isPressed ? widget.pressedOpacity : 1.0,
          duration: widget.duration,
          child: widget.child,
        ),
      ),
    );
  }
}

/// A tap wrapper that plays a three-phase bounce animation on tap.
///
/// The sequence animates: 1.0 → 0.95 (compress) → 1.02 (overshoot) → 1.0
/// (settle) over [duration] (default 200 ms).  Calls [onTap] immediately when
/// tapped while the animation runs independently.
class BounceCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration duration;

  const BounceCard({
    super.key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<BounceCard> createState() => _BounceCardState();
}

class _BounceCardState extends State<BounceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.95),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.02),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.02, end: 1.0),
        weight: 20,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(scale: _animation, child: widget.child),
    );
  }
}
