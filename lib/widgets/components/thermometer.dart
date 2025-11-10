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
    final color = _getTemperatureColor();
    final status = _getStatus();

    return GestureDetector(
      onTap: () => _showEditTargetDialog(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF3a3a3a),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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
                          const Text('Temperatura', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          Icon(Icons.edit_outlined, size: 14, color: Colors.white.withValues(alpha: 0.4)),
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
                  color: const Color(0xFF2d2d2d),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.track_changes, color: Colors.white60, size: 18),
                        SizedBox(width: 8),
                        Text('Target', style: TextStyle(color: Colors.white60, fontSize: 13)),
                      ],
                    ),
                    Text(
                      '${targetTemperature!.toStringAsFixed(1)}°C',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            _buildProgressBar(color),
          ],
        ),
      ),
    );
  }

  void _showEditTargetDialog(BuildContext context) async {
    final controller = TextEditingController(
      text: targetTemperature?.toStringAsFixed(1) ?? TargetParametersService.defaultTemperature.toStringAsFixed(1),
    );

    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d2d),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.thermostat, color: Color(0xFF60a5fa)),
            SizedBox(width: 12),
            Text('Target Temperatura', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Imposta la temperatura desiderata:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                suffixText: '°C',
                suffixStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: const Color(0xFF3a3a3a),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: '25.0',
                hintStyle: const TextStyle(color: Colors.white30),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Range tipico: 24-26°C',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla', style: TextStyle(color: Colors.white60)),
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
      await TargetParametersService().saveTarget('temperature', result);
      onTargetChanged?.call();
    }
  }

  Widget _buildProgressBar(Color color) {
    final progress = ((currentTemperature - 20) / (30 - 20)).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('20°C', style: TextStyle(color: Colors.white60, fontSize: 11)),
            const Text('30°C', style: TextStyle(color: Colors.white60, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFF2d2d2d),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
