/// Progress bar and circular gauge widgets showing distance from a target value.
library;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/core/theme/app_semantic_colors.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// An animated horizontal progress bar showing how close [currentValue] is to
/// [targetValue] within the [minValue]–[maxValue] range.
///
/// A vertical marker pin is drawn at the target position on the track.  The
/// fill colour follows distance-from-target thresholds:
/// - ≤ 5 % of range → green (optimal)
/// - ≤ 15 % of range → amber (acceptable)
/// - > 15 % of range → red (to correct)
///
/// The bar fill animates with `easeOutCubic` on each [currentValue] change
/// over [animationDuration] (default 800 ms).  Min/max labels are shown below
/// the track.
class TargetProgressBar extends StatefulWidget {
  final double currentValue;
  final double targetValue;
  final double minValue;
  final double maxValue;
  final String unit;
  final Duration animationDuration;

  const TargetProgressBar({
    super.key,
    required this.currentValue,
    required this.targetValue,
    required this.minValue,
    required this.maxValue,
    this.unit = '',
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  State<TargetProgressBar> createState() => _TargetProgressBarState();
}

class _TargetProgressBarState extends State<TargetProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.currentValue;

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: _normalizeValue(_previousValue),
      end: _normalizeValue(widget.currentValue),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void didUpdateWidget(TargetProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentValue != widget.currentValue) {
      _previousValue = oldWidget.currentValue;

      _controller.reset();
      _animation =
          Tween<double>(
            begin: _normalizeValue(_previousValue),
            end: _normalizeValue(widget.currentValue),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          );

      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Normalizza il valore tra 0 e 1
  double _normalizeValue(double value) {
    if (widget.maxValue == widget.minValue) return 0.5;
    return ((value - widget.minValue) / (widget.maxValue - widget.minValue))
        .clamp(0.0, 1.0);
  }

  // Calcola la distanza percentuale dal target
  double _getDistanceFromTarget() {
    final range = widget.maxValue - widget.minValue;
    if (range == 0) return 0;

    final distance = (widget.currentValue - widget.targetValue).abs();
    return (distance / range) * 100;
  }

  // Determina il colore in base alla distanza dal target
  Color _getProgressColor(AppSemanticColors c) {
    final distance = _getDistanceFromTarget();

    if (distance <= 5) {
      return c.statusOptimal; // Verde - molto vicino
    } else if (distance <= 15) {
      return c.statusWarning; // Giallo - medio
    } else {
      return c.statusError; // Rosso - lontano
    }
  }

  String _getStatusText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final distance = _getDistanceFromTarget();

    if (distance <= 5) {
      return l10n.optimal;
    } else if (distance <= 15) {
      return l10n.acceptable;
    } else {
      return l10n.toCorrect;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final color = _getProgressColor(context.semantic);
    final targetNormalized = _normalizeValue(widget.targetValue);
    final status = _getStatusText(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.flag,
                  size: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text('${l10n.target}: ${widget.targetValue.toStringAsFixed(1)}${widget.unit}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(status,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            // Sfondo della barra
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainerHighest
                    : theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Indicatore target (linea verticale)
            Positioned(
              left: targetNormalized * MediaQuery.of(context).size.width * 0.85,
              child: Container(
                width: 2,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
            // Barra di progresso animata
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return FractionallySizedBox(
                  widthFactor: _animation.value,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${widget.minValue.toStringAsFixed(0)}${widget.unit}',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
            Text('${widget.maxValue.toStringAsFixed(0)}${widget.unit}',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A compact circular gauge for tight layouts.
///
/// Draws a full-circle track with a progress arc painted from the top using
/// [_CircularProgressPainter].  Colour thresholds are the same as
/// [TargetProgressBar].  The arc animates from 0 to the normalised progress
/// over 1 second on first build; it does **not** re-animate on subsequent
/// value changes.
class CircularTargetProgress extends StatefulWidget {
  final double currentValue;
  final double targetValue;
  final double minValue;
  final double maxValue;
  final double size;
  final String unit;

  const CircularTargetProgress({
    super.key,
    required this.currentValue,
    required this.targetValue,
    required this.minValue,
    required this.maxValue,
    this.size = 60,
    this.unit = '',
  });

  @override
  State<CircularTargetProgress> createState() => _CircularTargetProgressState();
}

class _CircularTargetProgressState extends State<CircularTargetProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getProgress() {
    final range = widget.maxValue - widget.minValue;
    if (range == 0) return 0.5;
    return ((widget.currentValue - widget.minValue) / range).clamp(0.0, 1.0);
  }

  Color _getColor(AppSemanticColors c) {
    final distance =
        ((widget.currentValue - widget.targetValue).abs() /
        (widget.maxValue - widget.minValue) *
        100);

    if (distance <= 5) return c.statusOptimal;
    if (distance <= 15) return c.statusWarning;
    return c.statusError;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _getProgress();
    final color = _getColor(context.semantic);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _CircularProgressPainter(
              progress: progress * _animation.value,
              color: color,
            ),
            child: Center(
              child: Text('${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontSize: widget.size * 0.25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    canvas.drawCircle(center, radius - 3, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 3),
      -90 * 3.14159 / 180, // Start from top
      progress * 2 * 3.14159, // Progress in radians
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
