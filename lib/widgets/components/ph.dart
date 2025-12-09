import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/services/target_parameters_service.dart';
import 'package:acquariumfe/widgets/animated_number.dart';
import 'package:acquariumfe/widgets/tap_effect_card.dart';
import 'package:acquariumfe/widgets/components/target_progress_bar.dart';

class PhMeter extends StatelessWidget {
  final double currentPh;
  final double? targetPh;
  final VoidCallback? onTargetChanged;

  const PhMeter({
    super.key,
    this.currentPh = 8.2,
    this.targetPh,
    this.onTargetChanged,
  });

  Color _getPhColor() {
    if (currentPh < 7.8) return const Color(0xFFef4444);
    if (currentPh >= 7.8 && currentPh <= 8.4) return const Color(0xFF34d399);
    return const Color(0xFFef4444);
  }

  String _getStatus() {
    if (currentPh < 7.8) return 'Basso';
    if (currentPh >= 7.8 && currentPh <= 8.4) return 'Ottimale';
    return 'Alto';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getPhColor();
    final status = _getStatus();

    return TapEffectCard(
      onTap: () => _showEditTargetDialog(context),
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
                    FontAwesomeIcons.droplet,
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
                          Text(
                            'pH',
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
                      Text(
                        status,
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
                    value: currentPh,
                    decimals: 2,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (targetPh != null) ...[
              const SizedBox(height: 16),
              TargetProgressBar(
                currentValue: currentPh,
                targetValue: targetPh!,
                minValue: 7.5,
                maxValue: 8.5,
                unit: '',
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
    final controller = TextEditingController(
      text:
          targetPh?.toStringAsFixed(2) ??
          TargetParametersService.defaultPh.toStringAsFixed(2),
    );

    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d2d),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            FaIcon(FontAwesomeIcons.droplet, color: Color(0xFF60a5fa)),
            SizedBox(width: 12),
            Text('Target pH', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Imposta il valore pH desiderato:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF3a3a3a),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: '8.2',
                hintStyle: const TextStyle(color: Colors.white30),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Range tipico: 8.0-8.4',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Annulla',
              style: TextStyle(color: Colors.white60),
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
            child: const Text('Salva', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result != null) {
      await TargetParametersService().saveTarget('ph', result);
      onTargetChanged?.call();
    }
  }
}
