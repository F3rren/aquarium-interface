/// Temperature sensor display card widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/core/providers/service_providers.dart';
import 'package:acquariumfe/core/constants/parameter_thresholds.dart';
import 'package:acquariumfe/features/parameters/data/target_parameters_service.dart';
import 'package:acquariumfe/core/widgets/animated_number.dart';
import 'package:acquariumfe/core/widgets/tap_effect_card.dart';
import 'package:acquariumfe/features/parameters/presentation/widgets/target_progress_bar.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// Displays the current water temperature with status colour coding, a
/// directional change indicator, and an optional [TargetProgressBar].
///
/// Colour logic (bands from [ParameterThresholdDefaults.temperature]):
/// - below the range → blue (low)
/// - within 24–27 °C → green (optimal)
/// - above the range → red (high)
///
/// The [AnimatedNumberWithIndicator] shows a red up-arrow on increase and a
/// blue down-arrow on decrease.  Tapping the card opens a dialog to update
/// the target temperature, persisted via [TargetParametersService.saveTarget]
/// with key `'temperature'` and triggering [onTargetChanged].
class Thermometer extends ConsumerWidget {
  final double currentTemperature;
  final double? targetTemperature;
  final VoidCallback? onTargetChanged;

  const Thermometer({
    super.key,
    required this.currentTemperature,
    this.targetTemperature,
    this.onTargetChanged,
  });

  Color _getTemperatureColor() {
    const range = ParameterThresholdDefaults.temperature;
    if (currentTemperature < range.min) return const Color(0xFF60a5fa);
    if (range.contains(currentTemperature)) return const Color(0xFF34d399);
    return const Color(0xFFef4444);
  }

  String _getStatus(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const range = ParameterThresholdDefaults.temperature;
    if (currentTemperature < range.min) return l10n.low;
    if (range.contains(currentTemperature)) return l10n.optimal;
    return l10n.high;
  }

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final color = _getTemperatureColor();
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
                  child: FaIcon(
                    FontAwesomeIcons.temperatureHalf,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(  l10n.temperature,
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
                    value: currentTemperature,
                    decimals: 1,
                    suffix: ' °C',
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    increaseColor: const Color(0xFFef4444),
                    decreaseColor: const Color(0xFF60a5fa),
                  ),
                ),
              ],
            ),
            if (targetTemperature != null) ...[
              const SizedBox(height: 16),
              TargetProgressBar(
                currentValue: currentTemperature,
                targetValue: targetTemperature!,
                minValue: 20.0,
                maxValue: 30.0,
                unit: ' °C',
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
          targetTemperature?.toStringAsFixed(1) ??
          TargetParametersService.defaultTemperature.toStringAsFixed(1),
    );

    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.temperatureHalf,
              color: Color(0xFFef4444),
            ),
            const SizedBox(width: 12),
            Text(l10n.targetTemperature,
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.setDesiredTemperature,
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
                suffixText: ' °C',
                suffixStyle: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: '25.0',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.typicalRangeTemperature,
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
              backgroundColor: const Color(0xFFef4444),
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
      await ref.read(targetParametersServiceProvider).saveTarget('temperature', result);
      onTargetChanged?.call();
    }
  }
}
