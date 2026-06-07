/// Salinity sensor display card widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/core/providers/service_providers.dart';
import 'package:acquariumfe/features/parameters/data/target_parameters_service.dart';
import 'package:acquariumfe/core/widgets/animated_number.dart';
import 'package:acquariumfe/core/widgets/tap_effect_card.dart';
import 'package:acquariumfe/features/parameters/presentation/widgets/target_progress_bar.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// Displays the current salinity value (PSU/ppt) with target-relative colour
/// coding and an optional [TargetProgressBar].
///
/// Colour logic (relative to [targetSalinity]):
/// - Difference ≤ 1 ppt → green (optimal)
/// - Difference ≤ 2 ppt → amber (attention)
/// - Difference > 2 ppt → red (low/high)
/// - No target set → green (monitoring mode)
///
/// Tapping the card opens a dialog to update the target salinity, which is
/// persisted via [TargetParametersService.saveTarget] with key `'salinity'`
/// and triggers [onTargetChanged] so the parent can refresh.
class SalinityMeter extends ConsumerWidget {
  final double currentSalinity;
  final double? targetSalinity;
  final VoidCallback? onTargetChanged;

  const SalinityMeter({
    super.key,
    this.currentSalinity = 35.0,
    this.targetSalinity,
    this.onTargetChanged,
  });

  Color _getSalinityColor() {
    if (targetSalinity == null) return const Color(0xFF34d399);

    final diff = (currentSalinity - targetSalinity!).abs();
    if (diff <= 1) return const Color(0xFF34d399); // Vicino al target (±1 ppt)
    if (diff <= 2) return const Color(0xFFfbbf24); // Poco distante (±2 ppt)
    return const Color(0xFFef4444); // Molto distante
  }

  String _getStatus(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (targetSalinity == null) return l10n.monitoring;

    final diff = (currentSalinity - targetSalinity!).abs();
    if (diff <= 1) return l10n.optimal;
    if (diff <= 2) return l10n.attention;
    return currentSalinity < targetSalinity! ? l10n.low : l10n.high;
  }

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final color = _getSalinityColor();
    final status = _getStatus(context);

    return TapEffectCard(
      onTap: () => _showEditTargetDialog(context, ref),
      rippleColor: color,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FaIcon(FontAwesomeIcons.water, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(  l10n.salinity,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          FaIcon(
                            FontAwesomeIcons.pen,
                            size: 14,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(status,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.4)),
                  ),
                  child: AnimatedNumberWithIndicator(
                    value: currentSalinity,
                    decimals: 0,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (targetSalinity != null) ...[
              const SizedBox(height: 16),
              TargetProgressBar(
                currentValue: currentSalinity,
                targetValue: targetSalinity!,
                minValue: 30,
                maxValue: 40,
                unit: ' PPT',
              ),
            ] else ...[
              const SizedBox(height: 12),
            ],
            //_buildProgressBar(color, theme),
          ],
        ),
      ),
    );
  }

  void _showEditTargetDialog(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(
      text:
          targetSalinity?.toStringAsFixed(0) ??
          TargetParametersService.defaultSalinity.toStringAsFixed(0),
    );

    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const FaIcon(FontAwesomeIcons.water, color: Color(0xFF60a5fa)),
            const SizedBox(width: 12),
            Text(l10n.targetSalinity,
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.setDesiredSalinity,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autofocus: true,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: '35',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.typicalRangeSalinity,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel,
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null) {
                Navigator.pop(context, value);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF60a5fa),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.save, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result != null) {
      await ref.read(targetParametersServiceProvider).saveTarget('salinity', result);
      onTargetChanged?.call();
    }
  }
}
