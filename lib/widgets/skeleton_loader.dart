/// Generic shimmer skeleton loader and pre-built composite skeletons.
library;

import 'package:flutter/material.dart';

/// A single animated shimmer block used as a loading placeholder.
///
/// Renders a rectangle (or circle when [isCircle] is true) filled with a
/// sweeping left-to-right highlight gradient that repeats every 1.5 s.
/// Dark-mode colours: grey 800 → 700 → 800.
/// Light-mode colours: grey 300 → 200 → 300.
class SkeletonLoader extends StatefulWidget {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final bool isCircle;

  const SkeletonLoader({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
    this.isCircle = false,
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

    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: widget.isCircle
                ? null
                : (widget.borderRadius ?? BorderRadius.circular(8)),
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: isDark
                  ? [Colors.grey[800]!, Colors.grey[700]!, Colors.grey[800]!]
                  : [Colors.grey[300]!, Colors.grey[200]!, Colors.grey[300]!],
              stops: [
                (_animation.value - 0.5).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.5).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Composite skeleton that mimics the layout of an aquarium list card.
class AquariumCardSkeleton extends StatelessWidget {
  const AquariumCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonLoader(height: 50, width: 50, isCircle: true),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(
                        height: 20,
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      SkeletonLoader(
                        height: 16,
                        width: MediaQuery.of(context).size.width * 0.4,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SkeletonLoader(
                    height: 40,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SkeletonLoader(
                    height: 40,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SkeletonLoader(
                    height: 40,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Composite skeleton for a scrollable list of parameter rows.
///
/// Renders [itemCount] (default 5) placeholder rows, each with an icon block
/// on the left, two text lines in the centre, and a chip on the right.
class ParameterListSkeleton extends StatelessWidget {
  final int itemCount;

  const ParameterListSkeleton({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            const SkeletonLoader(
              height: 40,
              width: 40,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader(
                    height: 16,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 6),
                  SkeletonLoader(
                    height: 14,
                    width: MediaQuery.of(context).size.width * 0.3,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SkeletonLoader(
              height: 30,
              width: 60,
              borderRadius: BorderRadius.circular(15),
            ),
          ],
        ),
      ),
    );
  }
}

/// Composite skeleton that mimics a bar chart with axis labels.
class ChartSkeleton extends StatelessWidget {
  final double height;

  const ChartSkeleton({super.key, this.height = 250});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonLoader(
            height: 20,
            width: MediaQuery.of(context).size.width * 0.4,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                7,
                (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SkeletonLoader(
                      height: (index % 3 + 1) * 50.0,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              7,
              (index) => Expanded(
                child: Center(
                  child: SkeletonLoader(
                    height: 12,
                    width: 20,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Composite skeleton for a 2-column grid of fish/coral cards.
///
/// Renders [itemCount] (default 6) placeholder cards in a 2-column grid with
/// a large image block and two text lines per card.
class GridCardSkeleton extends StatelessWidget {
  final int itemCount;

  const GridCardSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: SkeletonLoader(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SkeletonLoader(
                      height: 16,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    SkeletonLoader(
                      height: 14,
                      width: MediaQuery.of(context).size.width * 0.25,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-page skeleton for the health dashboard while data is loading.
///
/// Renders a header row, two stat cards side by side, a chart skeleton,
/// and four parameter-row placeholders.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const SkeletonLoader(height: 60, width: 60, isCircle: true),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader(
                      height: 24,
                      width: double.infinity,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 8),
                    SkeletonLoader(
                      height: 16,
                      width: MediaQuery.of(context).size.width * 0.4,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats cards
          Row(
            children: [
              Expanded(
                child: SkeletonLoader(
                  height: 80,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SkeletonLoader(
                  height: 80,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Chart
          const ChartSkeleton(height: 200),
          const SizedBox(height: 24),

          // Parameters list
          ...List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SkeletonLoader(
                height: 60,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
