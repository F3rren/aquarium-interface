import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:acquariumfe/models/aquarium_parameters.dart';
import 'package:acquariumfe/providers/service_providers.dart';
import 'package:acquariumfe/providers/aquarium_providers.dart';

part 'parameters_provider.g.dart';

/// Provider per i parametri correnti dell'acquario selezionato
/// Si aggiorna automaticamente quando cambia l'acquario corrente
@riverpod
class CurrentParameters extends _$CurrentParameters {
  @override
  Future<AquariumParameters?> build() async {
    final currentAquariumId = ref.watch(currentAquariumProvider);
    
    if (currentAquariumId == null) {
      return null;
    }
    
    final parameterService = ref.watch(parameterServiceProvider);
    
    try {
      // IMPORTANTE: Abilita alert per le notifiche in tempo reale
      parameterService.setAutoCheckAlerts(true);
      
      final parameters = await parameterService.getCurrentParameters(
        id: currentAquariumId,
        useMock: false,
      );
      
      return parameters;
    } catch (e) {
      // In caso di errore, ritorna null invece di propagare l'errore
      return null;
    }
  }
  
  /// Refresh manuale dei parametri
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentAquariumId = ref.read(currentAquariumProvider);
      
      if (currentAquariumId == null) {
        return null;
      }
      
      final parameterService = ref.read(parameterServiceProvider);
      
      // IMPORTANTE: Abilita check alert per notifiche in tempo reale
      parameterService.setAutoCheckAlerts(true);
      
      return await parameterService.getCurrentParameters(
        id: currentAquariumId,
        useMock: false,
      );
    });
  }
}

/// Provider che indica se i parametri sono fuori range
@riverpod
bool hasParameterAlerts(HasParameterAlertsRef ref) {
  final parametersAsync = ref.watch(currentParametersProvider);
  
  return parametersAsync.when(
    data: (parameters) {
      if (parameters == null) return false;
      
      // Verifica parametri fuori range (valori tipici per acquario marino)
      final tempOk = parameters.temperature >= 24.0 && parameters.temperature <= 27.0;
      final phOk = parameters.ph >= 7.8 && parameters.ph <= 8.5;
      final salinityOk = parameters.salinity >= 1.023 && parameters.salinity <= 1.026;
      
      return !tempOk || !phOk || !salinityOk;
    },
    loading: () => false,
    error: (_, __) => false,
  );
}

/// Provider per i parametri target dell'acquario corrente
@riverpod
Future<Map<String, double>> targetParameters(TargetParametersRef ref) async {
  final currentAquariumId = ref.watch(currentAquariumProvider);
  
  if (currentAquariumId == null) {
    return {};
  }
  
  final targetService = ref.watch(targetParametersServiceProvider);
  
  try {
    return await targetService.loadAllTargets();
  } catch (e) {
    return {};
  }
}
