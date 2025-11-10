import 'package:flutter/material.dart';
import 'package:acquariumfe/widgets/components/thermometer.dart';
import 'package:acquariumfe/widgets/components/ph.dart';
import 'package:acquariumfe/widgets/components/salinity.dart';
import 'package:acquariumfe/widgets/components/orp.dart';
import 'package:acquariumfe/widgets/components/manual_parameters.dart';

class ParametersView extends StatelessWidget {
  const ParametersView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildHeader(),
          const SizedBox(height: 24),
          const Thermometer(currentTemperature: 25.3, targetTemperature: 25.0),
          const SizedBox(height: 16),
          const PhMeter(currentPh: 8.2, targetPh: 8.2),
          const SizedBox(height: 16),
          const SalinityMeter(currentSalinity: 1.024, targetSalinity: 1.024),
          const SizedBox(height: 16),
          const OrpMeter(currentOrp: 350, targetOrp: 360),
          const SizedBox(height: 16),
          const ManualParametersWidget(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4a4a4a), Color(0xFF3a3a3a)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF60a5fa).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.science, color: Color(0xFF60a5fa), size: 32),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Parametri Acquario', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Monitoraggio valori attuali', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
