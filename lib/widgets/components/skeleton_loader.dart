import 'package:flutter/material.dart';

class SkeletonLoader extends StatefulWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isDark
                  ? [
                      const Color(0xFF1e293b),
                      const Color(0xFF334155),
                      const Color(0xFF1e293b),
                    ]
                  : [
                      const Color(0xFFe2e8f0),
                      const Color(0xFFf1f5f9),
                      const Color(0xFFe2e8f0),
                    ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}

// Card acquario skeleton
class AquariumCardSkeleton extends StatelessWidget {
  const AquariumCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          SkeletonLoader(width: 70, height: 70, borderRadius: BorderRadius.circular(12)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SkeletonLoader(width: 120, height: 20),
                const SizedBox(height: 8),
                const SkeletonLoader(width: 80, height: 14),
                const SizedBox(height: 4),
                SkeletonLoader(
                  width: 60,
                  height: 12,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Parameter card skeleton
class ParameterCardSkeleton extends StatelessWidget {
  const ParameterCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonLoader(width: 40, height: 40, borderRadius: BorderRadius.circular(12)),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(width: 100, height: 16),
                    SizedBox(height: 6),
                    SkeletonLoader(width: 60, height: 12),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SkeletonLoader(width: double.infinity, height: 8, borderRadius: BorderRadius.circular(4)),
        ],
      ),
    );
  }
}

// List item skeleton (fish/coral)
class ListItemSkeleton extends StatelessWidget {
  const ListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          SkeletonLoader(width: 50, height: 50, borderRadius: BorderRadius.circular(25)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 140, height: 16),
                SizedBox(height: 6),
                SkeletonLoader(width: 90, height: 12),
              ],
            ),
          ),
          const SkeletonLoader(width: 24, height: 24),
        ],
      ),
    );
  }
}
