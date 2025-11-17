import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnimatedNumber extends StatefulWidget {
  final double value;
  final int decimals;
  final TextStyle? style;
  final Duration duration;
  final String? suffix;
  final String? prefix;

  const AnimatedNumber({
    super.key,
    required this.value,
    this.decimals = 1,
    this.style,
    this.duration = const Duration(milliseconds: 800),
    this.suffix,
    this.prefix,
  });

  @override
  State<AnimatedNumber> createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: _previousValue,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      
      _controller.reset();
      _animation = Tween<double>(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentValue = _animation.value;
        final formattedValue = currentValue.toStringAsFixed(widget.decimals);
        
        return Text(
          '${widget.prefix ?? ''}$formattedValue${widget.suffix ?? ''}',
          style: widget.style,
        );
      },
    );
  }
}

// Variante per numeri interi
class AnimatedIntNumber extends StatefulWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;
  final String? suffix;
  final String? prefix;

  const AnimatedIntNumber({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 800),
    this.suffix,
    this.prefix,
  });

  @override
  State<AnimatedIntNumber> createState() => _AnimatedIntNumberState();
}

class _AnimatedIntNumberState extends State<AnimatedIntNumber> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: _previousValue.toDouble(),
      end: widget.value.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedIntNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      
      _controller.reset();
      _animation = Tween<double>(
        begin: _previousValue.toDouble(),
        end: widget.value.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentValue = _animation.value.round();
        
        return Text(
          '${widget.prefix ?? ''}$currentValue${widget.suffix ?? ''}',
          style: widget.style,
        );
      },
    );
  }
}

// Widget per mostrare il cambio di valore con indicatore up/down
class AnimatedNumberWithIndicator extends StatefulWidget {
  final double value;
  final int decimals;
  final TextStyle? style;
  final Duration duration;
  final String? suffix;
  final String? prefix;
  final Color? increaseColor;
  final Color? decreaseColor;
  final bool showIndicator;

  const AnimatedNumberWithIndicator({
    super.key,
    required this.value,
    this.decimals = 1,
    this.style,
    this.duration = const Duration(milliseconds: 800),
    this.suffix,
    this.prefix,
    this.increaseColor,
    this.decreaseColor,
    this.showIndicator = true,
  });

  @override
  State<AnimatedNumberWithIndicator> createState() => _AnimatedNumberWithIndicatorState();
}

class _AnimatedNumberWithIndicatorState extends State<AnimatedNumberWithIndicator> 
    with TickerProviderStateMixin {
  late AnimationController _numberController;
  late AnimationController _indicatorController;
  late Animation<double> _numberAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  double _previousValue = 0;
  bool _isIncreasing = false;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    
    _numberController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _numberAnimation = Tween<double>(
      begin: _previousValue,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _numberController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _indicatorController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.3),
    ).animate(CurvedAnimation(
      parent: _indicatorController,
      curve: Curves.easeOut,
    ));
    
    _numberController.forward();
  }

  @override
  void didUpdateWidget(AnimatedNumberWithIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _isIncreasing = widget.value > _previousValue;
      
      _numberController.reset();
      _numberAnimation = Tween<double>(
        begin: _previousValue,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _numberController,
        curve: Curves.easeOutCubic,
      ));
      
      _numberController.forward();
      
      if (widget.showIndicator) {
        _indicatorController.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedBuilder(
          animation: _numberAnimation,
          builder: (context, child) {
            final currentValue = _numberAnimation.value;
            final formattedValue = currentValue.toStringAsFixed(widget.decimals);
            
            return Text(
              '${widget.prefix ?? ''}$formattedValue${widget.suffix ?? ''}',
              style: widget.style,
            );
          },
        ),
        if (widget.showIndicator && _previousValue != widget.value)
          Positioned(
            right: -20,
            top: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: FaIcon(
                  _isIncreasing ? FontAwesomeIcons.arrowUp : FontAwesomeIcons.arrowDown,
                  size: 16,
                  color: _isIncreasing 
                      ? (widget.increaseColor ?? const Color(0xFF34d399))
                      : (widget.decreaseColor ?? const Color(0xFFef4444)),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
