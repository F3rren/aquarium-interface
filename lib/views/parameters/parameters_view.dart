import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/widgets/components/thermometer.dart';
import 'package:acquariumfe/widgets/components/ph.dart';
import 'package:acquariumfe/widgets/components/salinity.dart';
import 'package:acquariumfe/widgets/components/orp.dart';
import 'package:acquariumfe/widgets/components/manual_parameters.dart';
import 'package:acquariumfe/widgets/components/skeleton_loader.dart';
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
  bool _isLoading = true;

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
      if (mounted) {
        setState(() {
          _currentParams = params;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Se il backend non risponde, usa il fallback interno
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadTargets() async {
    final targets = await _targetService.loadAllTargets();
    setState(() {
      _targetParams = targets;
    });
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await Future.wait([
      _loadParameters(),
      _loadTargets(),
    ]);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              FaIcon(FontAwesomeIcons.circleCheck, color: Colors.white),
              SizedBox(width: 12),
              Text('Parametri aggiornati!'),
            ],
          ),
          backgroundColor: const Color(0xFF34d399),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Valori di default se i dati non sono ancora caricati
    final temperature = _currentParams?.temperature ?? 25.0;
    final ph = _currentParams?.ph ?? 8.2;
    final salinity = _currentParams?.salinity ?? 1024.0;
    final orp = _currentParams?.orp ?? 350.0;

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
      child: _isLoading
        ? ListView(
            padding: const EdgeInsets.all(20),
            children: List.generate(4, (index) => const ParameterCardSkeleton()),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
          const SizedBox(height: 20),
          const ManualParametersWidget(),
        ],
        ),
      ),
    );
  }
}


