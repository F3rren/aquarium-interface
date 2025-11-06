import 'package:flutter/material.dart';

class Thermometer extends StatelessWidget {
  final double currentTemperature;
  final double? targetTemperature;
  final DateTime? lastUpdated;
  final String? deviceName;

  const Thermometer({
    super.key,
    this.currentTemperature = 25.1,
    this.targetTemperature,
    this.lastUpdated,
    this.deviceName,
  });

  Color _getTemperatureColor() {
    if (currentTemperature < 20) return const Color(0xFF2196F3); // Blu freddo
    if (currentTemperature < 24) return const Color(0xFF4CAF50); // Verde chiaro
    if (currentTemperature >= 24 && currentTemperature <= 26) return const Color(0xFF8BC34A); // Verde lime - IDEALE
    if (currentTemperature < 28) return const Color(0xFFFFC107); // Giallo/Arancione
    if (currentTemperature < 30) return const Color(0xFFFF9800); // Arancione
    return const Color(0xFFF44336); // Rosso caldo
  }

  String _getTemperatureStatus() {
    if (currentTemperature < 20) return 'Troppo Freddo';
    if (currentTemperature < 24) return 'Bassa';
    if (currentTemperature >= 24 && currentTemperature <= 26) return 'Ottimale';
    if (currentTemperature < 28) return 'Leggermente Alta';
    if (currentTemperature < 30) return 'Alta';
    return 'Critica';
  }

  IconData _getStatusIcon() {
    if (currentTemperature < 20) return Icons.ac_unit;
    if (currentTemperature >= 24 && currentTemperature <= 26) return Icons.check_circle;
    if (currentTemperature < 28) return Icons.warning_amber;
    return Icons.error;
  }

  String _getMarineAdvice() {
    if (currentTemperature < 24) {
      return 'Temperatura troppo bassa per la maggior parte dei coralli';
    } else if (currentTemperature >= 24 && currentTemperature <= 26) {
      return 'Temperatura ideale per coralli e pesci tropicali';
    } else if (currentTemperature > 26 && currentTemperature < 28) {
      return 'Attenzione: stress per coralli sensibili';
    } else if (currentTemperature >= 28 && currentTemperature < 30) {
      return 'Temperatura alta: rischio per i coralli';
    } else {
      return 'PERICOLO: Sbiancamento coralli imminente!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icona termometro a sinistra
          Container(
            padding: const EdgeInsets.all(16),

            child: Icon(
              Icons.thermostat,
              size: 64,
              color: _getTemperatureColor(),
            ),
          ),
          const SizedBox(width: 24),
          // Informazioni a destra
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "Temperatura Acqua",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _getStatusIcon(),
                      size: 20,
                      color: _getTemperatureColor(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${currentTemperature.toStringAsFixed(1)}°C",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: _getTemperatureColor(),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTemperatureColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getTemperatureStatus(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getTemperatureColor(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Consigli specifici per acquario marino
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.blue[700],
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _getMarineAdvice(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (targetTemperature != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoChip(
                    'Target',
                    '${targetTemperature!.toStringAsFixed(1)}°C',
                    Icons.flag,
                  ),
                ],
                if (lastUpdated != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoChip(
                    'Ultimo aggiornamento',
                    _formatTime(lastUpdated!),
                    Icons.access_time,
                  ),
                ],
                if (deviceName != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoChip(
                    'Sensore',
                    deviceName!,
                    Icons.sensors,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) return 'Adesso';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m fa';
    if (difference.inHours < 24) return '${difference.inHours}h fa';
    return '${difference.inDays}g fa';
  }
}
