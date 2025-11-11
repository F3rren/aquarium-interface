import 'package:flutter/material.dart';
import 'package:acquariumfe/services/target_parameters_service.dart';

class Thermometer extends StatelessWidget {
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
    if (currentTemperature < 24) return const Color(0xFF60a5fa);
    if (currentTemperature >= 24 && currentTemperature <= 26) return const Color(0xFF34d399);
    return const Color(0xFFef4444);
  }

  String _getStatus() {
    if (currentTemperature < 24) return 'Bassa';
    if (currentTemperature >= 24 && currentTemperature <= 26) return 'Ottimale';
    return 'Alta';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getTemperatureColor();
    final status = _getStatus();

    return GestureDetector(
      onTap: () => _showEditTargetDialog(context),
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
                  child: Icon(Icons.thermostat, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Temperatura', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          Icon(Icons.edit_outlined, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
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
                  child: Text(
                    '${currentTemperature.toStringAsFixed(1)}°C',
                    style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (targetTemperature != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.track_changes, color: theme.colorScheme.onSurfaceVariant, size: 18),
                        const SizedBox(width: 8),
                        Text('Target', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                      ],
                    ),
                    Text(
                      '${targetTemperature!.toStringAsFixed(1)}°C',
                      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            _buildProgressBar(color, theme),
          ],
        ),
      ),
    );
  }

  void _showEditTargetDialog(BuildContext context) async {
    final theme = Theme.of(context);
    final controller = TextEditingController(
      text: targetTemperature?.toStringAsFixed(1) ?? TargetParametersService.defaultTemperature.toStringAsFixed(1),
    );

    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.thermostat, color: Color(0xFFef4444)),
            const SizedBox(width: 12),
            Text('Target Temperatura', style: TextStyle(color: theme.colorScheme.onSurface)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Imposta la temperatura desiderata:',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18),
              decoration: InputDecoration(
                suffixText: '°C',
                suffixStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: '25.0',
                hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Range tipico: 24-26°C',
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
              backgroundColor: const Color(0xFFef4444),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Salva', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result != null) {
      await TargetParametersService().saveTarget('temperature', result);
      onTargetChanged?.call();
    }
  }

  Widget _buildProgressBar(Color color, ThemeData theme) {
    final progress = ((currentTemperature - 20) / (30 - 20)).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('20°C', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 11)),
            Text('30°C', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
