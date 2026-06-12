/// ORP/Redox sensor display card widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/core/providers/service_providers.dart';
import 'package:acquariumfe/features/aquarium/presentation/providers/aquarium_providers.dart';
import 'package:acquariumfe/core/constants/parameter_thresholds.dart';
import 'package:acquariumfe/core/theme/app_semantic_colors.dart';
import 'package:acquariumfe/features/parameters/data/target_parameters_service.dart';
import 'package:acquariumfe/core/widgets/animated_number.dart';
import 'package:acquariumfe/core/widgets/tap_effect_card.dart';
import 'package:acquariumfe/features/parameters/presentation/widgets/target_progress_bar.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// Displays the current ORP/Redox value with status colour coding and an
/// optional [TargetProgressBar].
///
/// Colour logic (bands from [ParameterThresholdDefaults.orp]):
/// - below the range → red (low)
/// - within 300–400 mV → green (optimal)
/// - above the range → red (high)
///
/// Tapping the card opens a dialog to update the target ORP, which is
/// persisted via [TargetParametersService.saveTarget] with key `'orp'` and
/// triggers [onTargetChanged] so the parent can refresh.
class OrpMeter extends ConsumerWidget {
  final double currentOrp;
  final double? targetOrp;
  final VoidCallback? onTargetChanged;

  const OrpMeter({
    super.key,
    this.currentOrp = 350.0,
    this.targetOrp,
    this.onTargetChanged,
  });

  Color _getOrpColor(AppSemanticColors c) {
    if (ParameterThresholdDefaults.orp.contains(currentOrp)) {
      return c.statusOptimal;
    }
    return c.statusError;
  }

  String _getStatus(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const range = ParameterThresholdDefaults.orp;
    if (currentOrp < range.min) return l10n.low;
    if (range.contains(currentOrp)) return l10n.optimal;
    return l10n.high;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final color = _getOrpColor(context.semantic);
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
                  child: FaIcon(FontAwesomeIcons.flask, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(l10n.orpRedox,
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
                    value: currentOrp,
                    decimals: 0,
                    suffix: ' mV',
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (targetOrp != null) ...[
              const SizedBox(height: 16),
              TargetProgressBar(
                currentValue: currentOrp,
                targetValue: targetOrp!,
                minValue: 300.0,
                maxValue: 450.0,
                unit: ' mV',
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
    final accent = context.semantic.orpAccent;
    final controller = TextEditingController(
      text:
          targetOrp?.toStringAsFixed(0) ??
          TargetParametersService.defaultOrp.toStringAsFixed(0),
    );

    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            FaIcon(FontAwesomeIcons.flask, color: accent),
            const SizedBox(width: 12),
            Text(l10n.targetOrp,
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.setDesiredOrp,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 18,
              ),
              decoration: InputDecoration(
                suffixText: 'mV',
                suffixStyle: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: '360',
                hintStyle: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.typicalRangeOrp,
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
              backgroundColor: accent,
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
      final aquariumId = ref.read(currentAquariumProvider);
      if (aquariumId == null) return;
      await ref
          .read(targetParametersServiceProvider)
          .saveTarget(aquariumId, 'orp', result);
      onTargetChanged?.call();
    }
  }
}
