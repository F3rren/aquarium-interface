import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:acquariumfe/services/api_service.dart';
import 'package:acquariumfe/services/aquarium_service.dart';
import 'package:acquariumfe/services/parameter_service.dart';
import 'package:acquariumfe/services/target_parameters_service.dart';
import 'package:acquariumfe/services/alert_manager.dart';

part 'service_providers.g.dart';

/// Provider per ApiService (singleton)
/// Gestisce tutte le chiamate HTTP al backend
@riverpod
ApiService apiService(ApiServiceRef ref) {
  return ApiService();
}

/// Provider per AquariumsService
/// Gestisce CRUD acquari
@riverpod
AquariumsService aquariumsService(AquariumsServiceRef ref) {
  return AquariumsService();
}

/// Provider per ParameterService
/// Gestisce parametri acquario e storico
@riverpod
ParameterService parameterService(ParameterServiceRef ref) {
  return ParameterService();
}

/// Provider per TargetParametersService
/// Gestisce i parametri target dell'acquario
@riverpod
TargetParametersService targetParametersService(
    TargetParametersServiceRef ref) {
  return TargetParametersService();
}

/// Provider per AlertManager
/// Gestisce notifiche e alert
@riverpod
AlertManager alertManager(AlertManagerRef ref) {
  return AlertManager();
}
