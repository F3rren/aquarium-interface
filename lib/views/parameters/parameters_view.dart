import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/widgets/components/thermometer.dart';
import 'package:acquariumfe/widgets/components/ph.dart';
import 'package:acquariumfe/widgets/components/salinity.dart';
import 'package:acquariumfe/widgets/components/orp.dart';
import 'package:acquariumfe/widgets/components/manual_parameters.dart';
import 'package:acquariumfe/providers/parameters_provider.dart';

class ParametersView extends ConsumerWidget {
  const ParametersView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parametersAsync = ref.watch(currentParametersProvider);
    final targetsAsync = ref.watch(targetParametersProvider);
    
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(currentParametersProvider.notifier).refresh();
        ref.invalidate(targetParametersProvider);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Parametri aggiornati'),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFF34d399),
            ),
          );
        }
      },
      child: parametersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.circleExclamation,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text('Errore: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(currentParametersProvider.notifier).refresh(),
                child: const Text('Riprova'),
              ),
            ],
          ),
        ),
        data: (currentParams) {
          if (currentParams == null) {
            return const Center(
              child: Text('Nessun parametro disponibile'),
            );
          }
          
          final targetParams = targetsAsync.when(
            data: (targets) => targets,
            loading: () => <String, double>{},
            error: (_, __) => <String, double>{},
          );
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Thermometer(
                  currentTemperature: currentParams.temperature,
                  targetTemperature: targetParams['temperature'] ?? 25.0,
                ),
                const SizedBox(height: 16),
                PhMeter(
                  currentPh: currentParams.ph,
                  targetPh: targetParams['ph'] ?? 8.2,
                ),
                const SizedBox(height: 16),
                SalinityMeter(
                  currentSalinity: currentParams.salinity,
                  targetSalinity: targetParams['salinity'] ?? 1.025,
                ),
                const SizedBox(height: 16),
                OrpMeter(
                  currentOrp: currentParams.orp,
                  targetOrp: targetParams['orp'] ?? 350.0,
                ),
                const SizedBox(height: 16),
                const ManualParametersWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
