import 'package:acquariumfe/components/thermometer.dart';
import 'package:flutter/material.dart';

class AquariumDetails extends StatefulWidget {

  const AquariumDetails({super.key});

  @override
  State<StatefulWidget> createState()  => _AquariumDetailsState();

}

class _AquariumDetailsState extends State<AquariumDetails> {
  double currentTemperature = 25.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aquarium Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF3ac3cb), Color(0xFFf85187)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Termometro con informazioni complete
                Thermometer(
                  currentTemperature: currentTemperature,
                  targetTemperature: 25.0,
                  lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
                  deviceName: 'Sensore Principale',
                ),
                
                const SizedBox(height: 20),
                
                const SizedBox(height: 40),
                
                // Altre informazioni
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: Colors.white.withOpacity(0.9),
                //     borderRadius: BorderRadius.circular(12),
                //   ),
                //   child: const Column(
                //     children: [
                //       Text("pH: 7.2", style: TextStyle(fontSize: 18)),
                //       SizedBox(height: 8),
                //       Text("Salinità: 1.025", style: TextStyle(fontSize: 18)),
                //       SizedBox(height: 8),
                //       Text("Conducibilità: 53 mS/cm", style: TextStyle(fontSize: 18)),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

}