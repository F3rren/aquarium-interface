// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiServiceHash() => r'ce72c4f572ea14a273b01086cdc8905a2e469468';

/// Provides the [ApiService] singleton responsible for all HTTP calls to the
/// Spring Boot backend. All other service providers depend on this indirectly.
///
/// Copied from [apiService].
@ProviderFor(apiService)
final apiServiceProvider = AutoDisposeProvider<ApiService>.internal(
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
typedef ApiServiceRef = AutoDisposeProviderRef<ApiService>;
String _$aquariumsServiceHash() => r'99d14b8a40682e51b01d7c65296ec0f395aa8322';

/// Provides the [AquariumsService] singleton for CRUD operations on aquariums.
///
/// Copied from [aquariumsService].
@ProviderFor(aquariumsService)
final aquariumsServiceProvider = AutoDisposeProvider<AquariumsService>.internal(
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
typedef AquariumsServiceRef = AutoDisposeProviderRef<AquariumsService>;
String _$parameterServiceHash() => r'b6d4eb47ef4be4c8a2ecf601f5024d64e950f485';

/// Provides the [ParameterService] singleton for fetching current and
/// historical water parameter readings.
///
/// Copied from [parameterService].
@ProviderFor(parameterService)
final parameterServiceProvider = AutoDisposeProvider<ParameterService>.internal(
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
typedef ParameterServiceRef = AutoDisposeProviderRef<ParameterService>;
String _$targetParametersServiceHash() =>
    r'a25a5193f61337673679cac909c80fd04bd6893e';

/// Provides the [TargetParametersService] singleton for reading and writing
/// the user-defined target (ideal) ranges for each water parameter.
///
/// Copied from [targetParametersService].
@ProviderFor(targetParametersService)
final targetParametersServiceProvider =
    AutoDisposeProvider<TargetParametersService>.internal(
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
typedef TargetParametersServiceRef =
    AutoDisposeProviderRef<TargetParametersService>;
String _$alertManagerHash() => r'a2aa43328ae16a6bff51e9a7565bb4bf0ab0b127';

/// Provides the [AlertManager] singleton that evaluates parameter readings
/// against configured thresholds and fires local notifications when a value
/// falls outside its acceptable range.
///
/// Copied from [alertManager].
@ProviderFor(alertManager)
final alertManagerProvider = AutoDisposeProvider<AlertManager>.internal(
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
typedef AlertManagerRef = AutoDisposeProviderRef<AlertManager>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
