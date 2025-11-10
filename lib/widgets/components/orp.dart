import 'package:flutter/material.dart';
import 'package:acquariumfe/services/target_parameters_service.dart';

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
    final color = _getOrpColor();
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
                  child: Icon(Icons.science, color: color, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('ORP/Redox', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
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
                    '${currentOrp.toStringAsFixed(0)} mV',
                    style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (targetOrp != null) ...[
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
                      '${targetOrp!.toStringAsFixed(0)} mV',
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
      text: targetOrp?.toStringAsFixed(0) ?? TargetParametersService.defaultOrp.toStringAsFixed(0),
    );

    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2d2d2d),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.science, color: Color(0xFF60a5fa)),
            SizedBox(width: 12),
            Text('Target ORP', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Imposta il valore ORP desiderato:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                suffixText: 'mV',
                suffixStyle: const TextStyle(color: Colors.white60),
                filled: true,
                fillColor: const Color(0xFF3a3a3a),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                hintText: '360',
                hintStyle: const TextStyle(color: Colors.white30),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Range tipico: 300-400 mV',
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
      await TargetParametersService().saveTarget('orp', result);
      onTargetChanged?.call();
    }
  }

  Widget _buildProgressBar(Color color) {
    final progress = ((currentOrp - 200) / (500 - 200)).clamp(0.0, 1.0);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('200 mV', style: TextStyle(color: Colors.white60, fontSize: 11)),
            const Text('500 mV', style: TextStyle(color: Colors.white60, fontSize: 11)),
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
