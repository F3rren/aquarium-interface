/// Riverpod providers for reading and reacting to live aquarium water parameters.
///
/// [CurrentParameters] fetches the latest measurement set for the currently
/// selected aquarium from [ParameterService] and enables real-time alert
/// checking. [hasParameterAlerts] derives a boolean flag from those values.
/// [targetParameters] exposes the user-defined target ranges.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:acquariumfe/models/aquarium_parameters.dart';
import 'package:acquariumfe/providers/service_providers.dart';
import 'package:acquariumfe/providers/aquarium_providers.dart';

part 'parameters_provider.g.dart';

/// Async Riverpod notifier that holds the latest [AquariumParameters] for
/// the currently selected aquarium.
///
/// Automatically rebuilds whenever [currentAquariumProvider] changes.
/// Returns `null` when no aquarium is selected or on fetch error (errors are
/// swallowed here so the UI can display a graceful empty state).
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
      // Enable real-time alert checking so parameter thresholds are evaluated.
      parameterService.setAutoCheckAlerts(true);

      final parameters = await parameterService.getCurrentParameters(
        id: currentAquariumId,
        useMock: false,
      );

      return parameters;
    } catch (e) {
      // Return null instead of propagating — callers show an empty state.
      return null;
    }
  }

  /// Forces a fresh fetch of the current parameters, resetting state to
  /// [AsyncValue.loading] first so the UI can show a spinner.
  ///
  /// Enables alert auto-check on every refresh so threshold violations are
  /// detected immediately after new data is loaded.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentAquariumId = ref.read(currentAquariumProvider);

      if (currentAquariumId == null) {
        return null;
      }

      final parameterService = ref.read(parameterServiceProvider);

      // Enable alert check so notifications fire on fresh data.
      parameterService.setAutoCheckAlerts(true);

      return await parameterService.getCurrentParameters(
        id: currentAquariumId,
        useMock: false,
      );
    });
  }
}

/// Returns `true` when the latest parameter reading has at least one value
/// outside the acceptable range for a marine aquarium.
///
/// Checked ranges (typical saltwater values):
/// - Temperature: 24–27 °C
/// - pH: 7.8–8.5
/// - Salinity: 1.023–1.026 sg
///
/// Returns `false` while loading, on error, or when no aquarium is selected.
@riverpod
bool hasParameterAlerts(HasParameterAlertsRef ref) {
  final parametersAsync = ref.watch(currentParametersProvider);

  return parametersAsync.when(
    data: (parameters) {
      if (parameters == null) return false;

      final tempOk =
          parameters.temperature >= 24.0 && parameters.temperature <= 27.0;
      final phOk = parameters.ph >= 7.8 && parameters.ph <= 8.5;
      final salinityOk =
          parameters.salinity >= 1.023 && parameters.salinity <= 1.026;

      return !tempOk || !phOk || !salinityOk;
    },
    loading: () => false,
    error: (_, __) => false,
  );
}

/// Fetches the user-defined target parameter values for the currently
/// selected aquarium from [TargetParametersService].
///
/// Returns an empty map when no aquarium is selected or on fetch error.
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
