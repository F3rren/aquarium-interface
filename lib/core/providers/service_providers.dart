/// Riverpod providers that expose service instances to the widget tree.
///
/// Each provider is marked `keepAlive: true` so that the instance is never
/// garbage-collected while the app is running, giving it true application-scope
/// lifetime. Dependencies are wired via constructor injection — no service
/// instantiates another service internally.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:acquariumfe/core/network/api_service.dart';
import 'package:acquariumfe/features/aquarium/data/aquarium_service.dart';
import 'package:acquariumfe/features/charts/data/chart_data_service.dart';
import 'package:acquariumfe/features/parameters/data/parameter_service.dart';
import 'package:acquariumfe/features/parameters/data/target_parameters_service.dart';
import 'package:acquariumfe/features/parameters/data/manual_parameters_service.dart';
import 'package:acquariumfe/features/settings/data/notification_settings_service.dart';
import 'package:acquariumfe/features/maintenance/data/maintenance_task_service.dart';
import 'package:acquariumfe/features/maintenance/data/product_service.dart';
import 'package:acquariumfe/features/inhabitants/data/inhabitants_service.dart';
import 'package:acquariumfe/features/inhabitants/data/fish_database_service.dart';
import 'package:acquariumfe/features/inhabitants/data/coral_database_service.dart';
import 'package:acquariumfe/features/settings/data/alert_manager.dart';

part 'service_providers.g.dart';

/// Provides the shared [ApiService] instance for all HTTP calls.
///
/// Marked `keepAlive: true` so the in-memory JWT cache and retry state persist
/// for the full app lifetime. Pass the returned instance into every service
/// that needs HTTP access instead of calling `ApiService()` directly.
@Riverpod(keepAlive: true)
ApiService apiService(Ref ref) {
  return ApiService();
}

/// Provides the [AquariumsService] instance for aquarium CRUD operations.
@Riverpod(keepAlive: true)
AquariumsService aquariumsService(Ref ref) {
  return AquariumsService(ref.read(apiServiceProvider));
}

/// Provides the [TargetParametersService] instance for reading and writing
/// user-defined target (ideal) ranges for each water parameter.
@Riverpod(keepAlive: true)
TargetParametersService targetParametersService(
  Ref ref,
) {
  return TargetParametersService(ref.read(apiServiceProvider));
}

/// Provides the [ParameterService] instance for fetching current and
/// historical water parameter readings.
@Riverpod(keepAlive: true)
ParameterService parameterService(Ref ref) {
  return ParameterService(
    ref.read(apiServiceProvider),
    manualService: ref.read(manualParametersServiceProvider),
    notificationService: ref.read(notificationSettingsServiceProvider),
  );
}

/// Provides the [ChartDataService] instance for loading historical parameter
/// data and computing chart statistics.
@Riverpod(keepAlive: true)
ChartDataService chartDataService(Ref ref) {
  return ChartDataService(ref.read(parameterServiceProvider));
}

/// Provides the [AlertManager] instance that evaluates parameter readings
/// against configured thresholds and fires local notifications when a value
/// falls outside its acceptable range.
@Riverpod(keepAlive: true)
AlertManager alertManager(Ref ref) {
  return AlertManager();
}

// ── Hand-written providers ───────────────────────────────────────────────────
//
// These data-layer services are exposed as plain (non-codegen) `Provider`s so
// `service_providers.g.dart` does not need to be regenerated to add them. A
// plain `Provider` is never auto-disposed, so — like the `keepAlive: true`
// providers above — each lives for the app's lifetime. Every one injects the
// shared [apiServiceProvider], so the whole app shares a single [ApiService]
// (one HTTP client + one in-memory token cache) instead of one per service.

/// Provides the shared [ManualParametersService] for the five manually-entered
/// water parameters (calcium, magnesium, KH, nitrate, phosphate).
final manualParametersServiceProvider = Provider<ManualParametersService>(
  (ref) => ManualParametersService(ref.read(apiServiceProvider)),
);

/// Provides the shared [NotificationSettingsService] for the backend-synced
/// notification settings.
final notificationSettingsServiceProvider =
    Provider<NotificationSettingsService>(
      (ref) => NotificationSettingsService(ref.read(apiServiceProvider)),
    );

/// Provides the shared [MaintenanceTaskService] for maintenance-task CRUD.
final maintenanceTaskServiceProvider = Provider<MaintenanceTaskService>(
  (ref) => MaintenanceTaskService(ref.read(apiServiceProvider)),
);

/// Provides the shared [ProductService] for the product inventory, so the
/// products view and the add/edit form share one cache.
final productServiceProvider = Provider<ProductService>(
  (ref) => ProductService(ref.read(apiServiceProvider)),
);

/// Provides the shared [InhabitantsService] for fish/coral inhabitant CRUD.
final inhabitantsServiceProvider = Provider<InhabitantsService>(
  (ref) => InhabitantsService(ref.read(apiServiceProvider)),
);

/// Provides the shared [FishDatabaseService] for the read-only fish species
/// catalogue (its in-memory cache persists for the app lifetime).
final fishDatabaseServiceProvider = Provider<FishDatabaseService>(
  (ref) => FishDatabaseService(ref.read(apiServiceProvider)),
);

/// Provides the shared [CoralDatabaseService] for the read-only coral species
/// catalogue (its in-memory cache persists for the app lifetime).
final coralDatabaseServiceProvider = Provider<CoralDatabaseService>(
  (ref) => CoralDatabaseService(ref.read(apiServiceProvider)),
);
