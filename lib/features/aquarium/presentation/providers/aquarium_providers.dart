/// Riverpod providers for aquarium management in the ReefLife app.
///
/// Exposes [aquariumsProvider] as the primary async provider that loads the
/// full list of aquariums together with their current water parameters.
/// Derived providers ([currentAquariumProvider], [aquariumCountProvider],
/// [aquariumsWithAlertsCountProvider]) compose on top of it for common UI
/// queries.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:acquariumfe/features/aquarium/domain/models/aquarium.dart';
import 'package:acquariumfe/features/parameters/domain/models/aquarium_parameters.dart';
import 'package:acquariumfe/core/constants/parameter_thresholds.dart';
import 'package:acquariumfe/core/providers/service_providers.dart';
import 'package:acquariumfe/features/maintenance/data/maintenance_task_service.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';

part 'aquarium_providers.g.dart';

/// Aggregate that pairs an [Aquarium] with its most-recent [AquariumParameters].
///
/// Used internally by providers to carry aquarium data and parameters together
/// as a single immutable value, avoiding redundant state reads.
class AquariumWithParams {
  /// The aquarium this aggregate refers to.
  final Aquarium aquarium;

  /// Most-recent water parameters for this aquarium.
  ///
  /// `null` when parameters have not been loaded yet or when the last fetch
  /// returned an error.
  final AquariumParameters? parameters;

  /// Timestamp of the most-recent successful parameter fetch.
  final DateTime? lastUpdate;

  /// Creates an [AquariumWithParams] with the required [aquarium] and optional
  /// [parameters] / [lastUpdate].
  AquariumWithParams({
    required this.aquarium,
    this.parameters,
    this.lastUpdate,
  });

  /// Whether at least one monitored parameter is outside its acceptable range.
  ///
  /// Ranges come from [ParameterThresholdDefaults] (the single source of truth
  /// shared with the notification thresholds) so the dashboard alert dot and
  /// the notifications never disagree.
  ///
  /// Returns `false` when [parameters] is `null`.
  bool get hasAlert {
    if (parameters == null) return false;

    return ParameterThresholdDefaults.temperature
            .isOutOfRange(parameters!.temperature) ||
        ParameterThresholdDefaults.ph.isOutOfRange(parameters!.ph) ||
        ParameterThresholdDefaults.salinity.isOutOfRange(parameters!.salinity);
  }

  /// Returns a copy of this aggregate with the specified fields replaced.
  AquariumWithParams copyWith({
    Aquarium? aquarium,
    AquariumParameters? parameters,
    DateTime? lastUpdate,
  }) {
    return AquariumWithParams(
      aquarium: aquarium ?? this.aquarium,
      parameters: parameters ?? this.parameters,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

/// Async provider for the full list of aquariums and their current parameters.
///
/// Manages loading / error / data states automatically via [AsyncValue].
/// During the initial fetch, automatic alert checking is temporarily disabled
/// to prevent spurious notifications; it is re-enabled once loading completes.
@riverpod
class Aquariums extends _$Aquariums {
  @override
  Future<List<AquariumWithParams>> build() async {
    return await _loadAquariums();
  }

  /// Fetches all aquariums from the backend and resolves their current
  /// parameters in a single pass.
  ///
  /// If parameter loading fails for an individual aquarium, that aquarium is
  /// still included in the result with [AquariumWithParams.parameters] == `null`
  /// so the UI degrades gracefully rather than failing entirely.
  ///
  /// After all aquariums are loaded the first aquarium is set as the active one
  /// in both [ParameterService] and [TargetParametersService].
  Future<List<AquariumWithParams>> _loadAquariums() async {
    final aquariumService = ref.read(aquariumsServiceProvider);
    final parameterService = ref.read(parameterServiceProvider);

    final aquariums = await aquariumService.getAquariums();

    final aquariumsWithParams = <AquariumWithParams>[];
    for (final aquarium in aquariums) {
      AquariumParameters? params;
      DateTime? lastUpdate;

      try {
        // Disable alert checks during initial load to avoid spurious
        // notifications; polling after load re-enables them.
        parameterService.setAutoCheckAlerts(false);

        params = await parameterService.getCurrentParameters(
          id: aquarium.id,
          useMock: false,
        );
        lastUpdate = DateTime.now();
      } on AppException {
        // Silently ignore per-aquarium parameter errors.
      } catch (e) {
        // Silently ignore unexpected errors.
      }

      aquariumsWithParams.add(
        AquariumWithParams(
          aquarium: aquarium,
          parameters: params,
          lastUpdate: lastUpdate,
        ),
      );
    }

    // Re-enable alert checking now that the initial load is complete.
    parameterService.setAutoCheckAlerts(true);

    // Set the first aquarium as the active one across services.
    if (aquariumsWithParams.isNotEmpty &&
        aquariumsWithParams.first.aquarium.id != null) {
      final firstId = aquariumsWithParams.first.aquarium.id!;
      parameterService.setCurrentAquarium(firstId);
      ref.read(targetParametersServiceProvider).setCurrentAquarium(firstId);
    }

    return aquariumsWithParams;
  }

  /// Triggers a full reload of the aquarium list, typically called by
  /// pull-to-refresh gestures.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _loadAquariums();
    });
  }

  /// Creates a new aquarium on the backend and initialises its default
  /// maintenance tasks based on the tank type specified in [aquarium].
  ///
  /// If task initialisation fails the aquarium is still persisted; the error
  /// is swallowed so the user is not blocked.
  Future<void> addAquarium(Aquarium aquarium) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final aquariumService = ref.read(aquariumsServiceProvider);
      final created = await aquariumService.createAquarium(aquarium);

      if (created.id != null) {
        final taskService = MaintenanceTaskService();
        taskService.setCurrentAquarium(created.id!);
        try {
          await taskService.initializeDefaultTasks(type: aquarium.type);
        } catch (_) {
          // Do not block aquarium creation when task initialisation fails.
        }
      }

      return await _loadAquariums();
    });
  }

  /// Updates the backend record for the aquarium identified by [id] with the
  /// data in [aquarium], then reloads the list.
  Future<void> updateAquarium(int id, Aquarium aquarium) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final aquariumService = ref.read(aquariumsServiceProvider);
      await aquariumService.updateAquarium(id, aquarium);
      return await _loadAquariums();
    });
  }

  /// Deletes the aquarium identified by [id] from the backend and reloads the
  /// list.
  Future<void> deleteAquarium(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final aquariumService = ref.read(aquariumsServiceProvider);
      await aquariumService.deleteAquarium(id);
      return await _loadAquariums();
    });
  }

  /// Refreshes the parameters for a single aquarium identified by [aquariumId]
  /// without triggering a full list reload.
  ///
  /// The existing state is preserved when the fetch fails, so the UI continues
  /// to show the last known values.
  Future<void> refreshParameters(int aquariumId) async {
    final currentState = state.value;
    if (currentState == null) return;

    final parameterService = ref.read(parameterServiceProvider);

    try {
      final params = await parameterService.getCurrentParameters(
        id: aquariumId,
        useMock: false,
      );

      // Patch only the affected item in the list.
      final updatedList = currentState.map((item) {
        if (item.aquarium.id == aquariumId) {
          return item.copyWith(parameters: params, lastUpdate: DateTime.now());
        }
        return item;
      }).toList();

      state = AsyncValue.data(updatedList);
    } on AppException {
      // Preserve current state on error.
    }
  }
}

/// Provider that tracks the ID of the aquarium currently selected in the UI.
///
/// The initial value is derived from the first entry in [aquariumsProvider].
/// Use [setAquarium] to change the selection; this also synchronises the
/// underlying [ParameterService] and [TargetParametersService] singletons.
@riverpod
class CurrentAquarium extends _$CurrentAquarium {
  @override
  int? build() {
    final aquariums = ref.watch(aquariumsProvider);
    return aquariums.when(
      data: (list) => list.isNotEmpty ? list.first.aquarium.id : null,
      loading: () => null,
      error: (_, __) => null,
    );
  }

  /// Selects the aquarium with [id] and propagates the change to
  /// [ParameterService] and [TargetParametersService].
  void setAquarium(int id) {
    state = id;

    ref.read(parameterServiceProvider).setCurrentAquarium(id);
    ref.read(targetParametersServiceProvider).setCurrentAquarium(id);
  }
}

/// Provides the total number of registered aquariums.
///
/// Returns `0` while loading or when an error occurred.
@riverpod
int aquariumCount(Ref ref) {
  final aquariums = ref.watch(aquariumsProvider);
  return aquariums.when(
    data: (list) => list.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}

/// Provides the number of aquariums that have at least one parameter outside
/// its acceptable range (i.e. [AquariumWithParams.hasAlert] is `true`).
///
/// Returns `0` while loading or when an error occurred.
@riverpod
int aquariumsWithAlertsCount(Ref ref) {
  final aquariums = ref.watch(aquariumsProvider);
  return aquariums.when(
    data: (list) => list.where((a) => a.hasAlert).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}
