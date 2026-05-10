// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiServiceHash() => r'03cbd33147a7058d56175e532ac47e1aa4858c6d';

/// Provides the shared [ApiService] instance for all HTTP calls.
///
/// Marked `keepAlive: true` so the in-memory JWT cache and retry state persist
/// for the full app lifetime. Pass the returned instance into every service
/// that needs HTTP access instead of calling `ApiService()` directly.
///
/// Copied from [apiService].
@ProviderFor(apiService)
final apiServiceProvider = Provider<ApiService>.internal(
  apiService,
  name: r'apiServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiServiceRef = ProviderRef<ApiService>;
String _$aquariumsServiceHash() => r'b161035fedafdfd8c0a7e211c31100fdfdb9629a';

/// Provides the [AquariumsService] instance for aquarium CRUD operations.
///
/// Copied from [aquariumsService].
@ProviderFor(aquariumsService)
final aquariumsServiceProvider = Provider<AquariumsService>.internal(
  aquariumsService,
  name: r'aquariumsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aquariumsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AquariumsServiceRef = ProviderRef<AquariumsService>;
String _$targetParametersServiceHash() =>
    r'e6882716b860412163e070d5a1e381c681fa0148';

/// Provides the [TargetParametersService] instance for reading and writing
/// user-defined target (ideal) ranges for each water parameter.
///
/// Copied from [targetParametersService].
@ProviderFor(targetParametersService)
final targetParametersServiceProvider =
    Provider<TargetParametersService>.internal(
      targetParametersService,
      name: r'targetParametersServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$targetParametersServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TargetParametersServiceRef = ProviderRef<TargetParametersService>;
String _$parameterServiceHash() => r'5043ebb75abb705630fa4c1b18db778677d7d367';

/// Provides the [ParameterService] instance for fetching current and
/// historical water parameter readings.
///
/// Copied from [parameterService].
@ProviderFor(parameterService)
final parameterServiceProvider = Provider<ParameterService>.internal(
  parameterService,
  name: r'parameterServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$parameterServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ParameterServiceRef = ProviderRef<ParameterService>;
String _$chartDataServiceHash() => r'2035136424299721b4ca137113989978936eef26';

/// Provides the [ChartDataService] instance for loading historical parameter
/// data and computing chart statistics.
///
/// Copied from [chartDataService].
@ProviderFor(chartDataService)
final chartDataServiceProvider = Provider<ChartDataService>.internal(
  chartDataService,
  name: r'chartDataServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chartDataServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChartDataServiceRef = ProviderRef<ChartDataService>;
String _$alertManagerHash() => r'67fd8ac338f94e4e44ccb2937202c8fdd3a01189';

/// Provides the [AlertManager] instance that evaluates parameter readings
/// against configured thresholds and fires local notifications when a value
/// falls outside its acceptable range.
///
/// Copied from [alertManager].
@ProviderFor(alertManager)
final alertManagerProvider = Provider<AlertManager>.internal(
  alertManager,
  name: r'alertManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$alertManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AlertManagerRef = ProviderRef<AlertManager>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
