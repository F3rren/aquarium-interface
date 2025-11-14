import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/services/target_parameters_service.dart';
import 'package:acquariumfe/widgets/animated_number.dart';
import 'package:acquariumfe/widgets/tap_effect_card.dart';
import 'package:acquariumfe/widgets/components/target_progress_bar.dart';

class OrpMeter extends StatelessWidget {
  final double currentOrp;
  final double? targetOrp;
  final VoidCallback? onTargetChanged;

  const OrpMeter({
    super.key,
    this.currentOrp = 350.0,
    this.targetOrp,
    this.onTargetChanged,
  });

  Color _getOrpColor() {
    if (currentOrp < 300) return const Color(0xFFef4444);
    if (currentOrp >= 300 && currentOrp <= 400) return const Color(0xFF34d399);
    return const Color(0xFFef4444);
  }

  String _getStatus() {
    if (currentOrp < 300) return 'Basso';
    if (currentOrp >= 300 && currentOrp <= 400) return 'Ottimale';
    return 'Alto';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getOrpColor();
    final status = _getStatus();

    return TapEffectCard(
      onTap: () => _showEditTargetDialog(context),
      rippleColor: color,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
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
                          Text('ORP/Redox', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          FaIcon(FontAwesomeIcons.pen, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: color.withValues(alpha: 0.4)),
                  ),
                  child: AnimatedNumberWithIndicator(
                    value: currentOrp,
                    decimals: 0,
                    suffix: ' mV',
                    style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
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

  void _showEditTargetDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final controller = TextEditingController(
      text: targetOrp?.toStringAsFixed(0) ?? TargetParametersService.defaultOrp.toStringAsFixed(0),
    );

    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const FaIcon(FontAwesomeIcons.flask, color: Color(0xFF60a5fa)),
            const SizedBox(width: 12),
            Text('Target ORP', style: TextStyle(color: theme.colorScheme.onSurface)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Imposta il valore ORP desiderato:',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18),
              decoration: InputDecoration(
                suffixText: 'mV',
                suffixStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: '360',
                hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Range tipico: 300-400 mV',
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annulla', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Salva', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result != null) {
      await TargetParametersService().saveTarget('orp', result);
      onTargetChanged?.call();
    }
  }

}
