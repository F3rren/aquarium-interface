import 'dart:async';
import 'package:flutter/material.dart';
import 'package:acquariumfe/widgets/components/thermometer.dart';
import 'package:acquariumfe/widgets/components/ph.dart';
import 'package:acquariumfe/widgets/components/salinity.dart';
import 'package:acquariumfe/widgets/components/orp.dart';
import 'package:acquariumfe/widgets/components/manual_parameters.dart';
import 'package:acquariumfe/services/parameter_service.dart';
import 'package:acquariumfe/services/target_parameters_service.dart';
import 'package:acquariumfe/models/aquarium_parameters.dart';

class ParametersView extends StatefulWidget {
  const ParametersView({super.key});

  @override
  State<ParametersView> createState() => _ParametersViewState();
}

class _ParametersViewState extends State<ParametersView> {
  final ParameterService _parameterService = ParameterService();
  final TargetParametersService _targetService = TargetParametersService();
  Timer? _refreshTimer;
  AquariumParameters? _currentParams;
  Map<String, double> _targetParams = {};

  @override
  void initState() {
    super.initState();
    _loadParameters();
    _loadTargets();
    // Avvia auto-refresh ogni 10 secondi
    _parameterService.startAutoRefresh(interval: const Duration(seconds: 10));
    // Auto-refresh UI ogni 3 secondi
    _refreshTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _loadParameters();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _parameterService.stopAutoRefresh();
    super.dispose();
  }

  Future<void> _loadParameters() async {
    try {
      final params = await _parameterService.getCurrentParameters(useMock: false);
      setState(() {
        _currentParams = params;
      });
    } catch (e) {
      // Se il backend non risponde, usa il fallback interno
    }
  }

  Future<void> _loadTargets() async {
    final targets = await _targetService.loadAllTargets();
    setState(() {
      _targetParams = targets;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Valori di default se i dati non sono ancora caricati
    final temperature = _currentParams?.temperature ?? 25.0;
    final ph = _currentParams?.ph ?? 8.2;
    final salinity = _currentParams?.salinity ?? 1.024;
    final orp = _currentParams?.orp ?? 350.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildHeader(),
          const SizedBox(height: 24),
          Thermometer(
            currentTemperature: temperature,
            targetTemperature: _targetParams['temperature'],
            onTargetChanged: _loadTargets,
          ),
          const SizedBox(height: 16),
          PhMeter(
            currentPh: ph,
            targetPh: _targetParams['ph'],
            onTargetChanged: _loadTargets,
          ),
          const SizedBox(height: 16),
          SalinityMeter(
            currentSalinity: salinity,
            targetSalinity: _targetParams['salinity'],
            onTargetChanged: _loadTargets,
          ),
          const SizedBox(height: 16),
          OrpMeter(
            currentOrp: orp,
            targetOrp: _targetParams['orp'],
            onTargetChanged: _loadTargets,
          ),
          const SizedBox(height: 16),
          const ManualParametersWidget(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.surfaceContainerHighest, theme.colorScheme.surface],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.science, color: theme.colorScheme.primary, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Parametri Acquario', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.wifi_tethering, color: Colors.green, size: 14),
                    const SizedBox(width: 4),
                    const Text('Live • Auto-refresh 3s', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _loadParameters,
            icon: Icon(Icons.refresh, color: theme.colorScheme.primary),
            tooltip: 'Aggiorna ora',
          ),
        ],
      ),
    );
  }
}
