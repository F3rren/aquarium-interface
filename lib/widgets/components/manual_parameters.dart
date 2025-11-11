import 'package:flutter/material.dart';
import 'package:acquariumfe/services/manual_parameters_service.dart';

class ManualParametersWidget extends StatefulWidget {
  const ManualParametersWidget({super.key});

  @override
  State<ManualParametersWidget> createState() => _ManualParametersWidgetState();
}

class _ManualParametersWidgetState extends State<ManualParametersWidget> {
  final ManualParametersService _manualService = ManualParametersService();
  
  double calcium = 420.0;
  double magnesium = 1300.0;
  double kh = 8.0;
  double nitrates = 2.0;
  double phosphates = 0.02;
  DateTime? lastUpdate;

  @override
  void initState() {
    super.initState();
    _loadParameters();
  }

  Future<void> _loadParameters() async {
    final params = await _manualService.loadManualParameters();
    final update = await _manualService.getLastUpdate();
    
    setState(() {
      calcium = params['calcium'] ?? 420.0;
      magnesium = params['magnesium'] ?? 1300.0;
      kh = params['kh'] ?? 8.0;
      nitrates = params['nitrate'] ?? 2.0;
      phosphates = params['phosphate'] ?? 0.02;
      lastUpdate = update;
    });
  }

  Future<void> _saveParameter(String name, double value) async {
    String key = '';
    
    // Estrai il nome base (rimuovi le parti tra parentesi)
    final baseName = name.split('(').first.trim();
    
    switch (baseName) {
      case 'Calcio':
        key = 'calcium';
        break;
      case 'Magnesio':
        key = 'magnesium';
        break;
      case 'KH':
        key = 'kh';
        break;
      case 'Nitrati':
        key = 'nitrate';
        break;
      case 'Fosfati':
        key = 'phosphate';
        break;
    }
    
    if (key.isNotEmpty) {
      await _manualService.updateParameter(key, value);
      await _loadParameters(); // Ricarica per aggiornare lastUpdate
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF60a5fa).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.science, color: Color(0xFF60a5fa), size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                'Parametri Chimici',
                style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildParameter('Calcio (Ca)', calcium, 'mg/L', 400, 450, Icons.layers, (v) => setState(() => calcium = v)),
          const SizedBox(height: 12),
          _buildParameter('Magnesio (Mg)', magnesium, 'mg/L', 1250, 1350, Icons.auto_awesome, (v) => setState(() => magnesium = v)),
          const SizedBox(height: 12),
          _buildParameter('KH', kh, 'dKH', 7, 9, Icons.bar_chart, (v) => setState(() => kh = v)),
          const SizedBox(height: 12),
          _buildParameter('Nitrati (NO3)', nitrates, 'mg/L', 0.5, 5, Icons.eco, (v) => setState(() => nitrates = v)),
          const SizedBox(height: 12),
          _buildParameter('Fosfati (PO4)', phosphates, 'mg/L', 0.0, 0.03, Icons.water_damage, (v) => setState(() => phosphates = v)),
        ],
      ),
    );
  }

  Widget _buildParameter(String name, double value, String unit, double min, double max, IconData icon, Function(double) onChanged) {
    final theme = Theme.of(context);
    final isInRange = value >= min && value <= max;
    final color = isInRange ? const Color(0xFF34d399) : const Color(0xFFef4444);
    
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('$min-$max $unit', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 11)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showEditDialog(name, value, unit, (newValue) async {
              // Salva in SharedPreferences
              await _saveParameter(name, newValue);
              onChanged(newValue);
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${value.toStringAsFixed(value < 10 ? 2 : 0)}',
                    style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  Text(unit, style: TextStyle(color: color, fontSize: 11)),
                  const SizedBox(width: 6),
                  Icon(Icons.edit, color: color, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(String name, double currentValue, String unit, Function(double) onChanged) {
    final theme = Theme.of(context);
    final controller = TextEditingController(text: currentValue.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Modifica $name', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 18)),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            labelText: 'Valore ($unit)',
            labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF60a5fa)),
            ),
          ),
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
                onChanged(value);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF60a5fa),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Salva'),
          ),
        ],
      ),
    );
  }
}
