/// Riverpod providers that expose singleton service instances to the widget tree.
///
/// Each provider returns the shared singleton of its respective service.
/// Using Riverpod providers (rather than direct instantiation) makes services
/// easily mockable in tests and ensures a single instance per app lifecycle.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:acquariumfe/services/api_service.dart';
import 'package:acquariumfe/services/aquarium_service.dart';
import 'package:acquariumfe/services/parameter_service.dart';
import 'package:acquariumfe/services/target_parameters_service.dart';
import 'package:acquariumfe/services/alert_manager.dart';

part 'service_providers.g.dart';

/// Provides the [ApiService] singleton responsible for all HTTP calls to the
/// Spring Boot backend. All other service providers depend on this indirectly.
@riverpod
ApiService apiService(ApiServiceRef ref) {
  return ApiService();
}

/// Provides the [AquariumsService] singleton for CRUD operations on aquariums.
@riverpod
AquariumsService aquariumsService(AquariumsServiceRef ref) {
  return AquariumsService();
}

/// Provides the [ParameterService] singleton for fetching current and
/// historical water parameter readings.
@riverpod
ParameterService parameterService(ParameterServiceRef ref) {
  return ParameterService();
}

/// Provides the [TargetParametersService] singleton for reading and writing
/// the user-defined target (ideal) ranges for each water parameter.
@riverpod
TargetParametersService targetParametersService(
  TargetParametersServiceRef ref,
) {
  return TargetParametersService();
}

/// Provides the [AlertManager] singleton that evaluates parameter readings
/// against configured thresholds and fires local notifications when a value
/// falls outside its acceptable range.
@riverpod
AlertManager alertManager(AlertManagerRef ref) {
  return AlertManager();
}
