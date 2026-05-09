// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hasParameterAlertsHash() =>
    r'35e7a5afd9b0b7012cccbe0f9a1665809dfdeaa9';

/// Returns `true` when the latest parameter reading has at least one value
/// outside the acceptable range for a marine aquarium.
///
/// Checked ranges (typical saltwater values):
/// - Temperature: 24–27 °C
/// - pH: 7.8–8.5
/// - Salinity: 1.023–1.026 sg
///
/// Returns `false` while loading, on error, or when no aquarium is selected.
///
/// Copied from [hasParameterAlerts].
@ProviderFor(hasParameterAlerts)
final hasParameterAlertsProvider = AutoDisposeProvider<bool>.internal(
  hasParameterAlerts,
  name: r'hasParameterAlertsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasParameterAlertsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasParameterAlertsRef = AutoDisposeProviderRef<bool>;
String _$targetParametersHash() => r'43679cc48034b94b34615e4f6a30d0b2b7993336';

/// Fetches the user-defined target parameter values for the currently
/// selected aquarium from [TargetParametersService].
///
/// Returns an empty map when no aquarium is selected or on fetch error.
///
/// Copied from [targetParameters].
@ProviderFor(targetParameters)
final targetParametersProvider =
    AutoDisposeFutureProvider<Map<String, double>>.internal(
      targetParameters,
      name: r'targetParametersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$targetParametersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TargetParametersRef = AutoDisposeFutureProviderRef<Map<String, double>>;
String _$currentParametersHash() => r'e3dadb01d6d25e57d53f2f61cd72e52e18abf014';

/// Async Riverpod notifier that holds the latest [AquariumParameters] for
/// the currently selected aquarium.
///
/// Automatically rebuilds whenever [currentAquariumProvider] changes.
/// Returns `null` when no aquarium is selected or on fetch error (errors are
/// swallowed here so the UI can display a graceful empty state).
///
/// Copied from [CurrentParameters].
@ProviderFor(CurrentParameters)
final currentParametersProvider =
    AutoDisposeAsyncNotifierProvider<
      CurrentParameters,
      AquariumParameters?
    >.internal(
      CurrentParameters.new,
      name: r'currentParametersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentParametersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentParameters = AutoDisposeAsyncNotifier<AquariumParameters?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
