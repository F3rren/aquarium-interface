/// Riverpod providers that expose service instances to the widget tree.
///
/// Each provider is marked `keepAlive: true` so that the instance is never
/// garbage-collected while the app is running, giving it true application-scope
/// lifetime. Dependencies are wired via constructor injection — no service
/// instantiates another service internally.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:acquariumfe/core/network/api_service.dart';
import 'package:acquariumfe/features/aquarium/data/aquarium_service.dart';
import 'package:acquariumfe/features/charts/data/chart_data_service.dart';
import 'package:acquariumfe/features/parameters/data/parameter_service.dart';
import 'package:acquariumfe/features/parameters/data/target_parameters_service.dart';
import 'package:acquariumfe/features/settings/data/alert_manager.dart';

part 'service_providers.g.dart';

/// Provides the shared [ApiService] instance for all HTTP calls.
///
/// Marked `keepAlive: true` so the in-memory JWT cache and retry state persist
/// for the full app lifetime. Pass the returned instance into every service
/// that needs HTTP access instead of calling `ApiService()` directly.
@Riverpod(keepAlive: true)
ApiService apiService(ApiServiceRef ref) {
  return ApiService();
}

/// Provides the [AquariumsService] instance for aquarium CRUD operations.
@Riverpod(keepAlive: true)
AquariumsService aquariumsService(AquariumsServiceRef ref) {
  return AquariumsService(ref.read(apiServiceProvider));
}

/// Provides the [TargetParametersService] instance for reading and writing
/// user-defined target (ideal) ranges for each water parameter.
@Riverpod(keepAlive: true)
TargetParametersService targetParametersService(
  TargetParametersServiceRef ref,
) {
  return TargetParametersService(ref.read(apiServiceProvider));
}

/// Provides the [ParameterService] instance for fetching current and
/// historical water parameter readings.
@Riverpod(keepAlive: true)
ParameterService parameterService(ParameterServiceRef ref) {
  return ParameterService(
    ref.read(apiServiceProvider),
    ref.read(targetParametersServiceProvider),
  );
}

/// Provides the [ChartDataService] instance for loading historical parameter
/// data and computing chart statistics.
@Riverpod(keepAlive: true)
ChartDataService chartDataService(ChartDataServiceRef ref) {
  return ChartDataService(ref.read(parameterServiceProvider));
}

/// Provides the [AlertManager] instance that evaluates parameter readings
/// against configured thresholds and fires local notifications when a value
/// falls outside its acceptable range.
@Riverpod(keepAlive: true)
AlertManager alertManager(AlertManagerRef ref) {
  return AlertManager();
}
