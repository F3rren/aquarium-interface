// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aquarium_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aquariumCountHash() => r'aa7716d0dafdf646cb90e7fc2a28eb94c14deb84';

/// Provides the total number of registered aquariums.
///
/// Returns `0` while loading or when an error occurred.
///
/// Copied from [aquariumCount].
@ProviderFor(aquariumCount)
final aquariumCountProvider = AutoDisposeProvider<int>.internal(
  aquariumCount,
  name: r'aquariumCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aquariumCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AquariumCountRef = AutoDisposeProviderRef<int>;
String _$aquariumsWithAlertsCountHash() =>
    r'2c4f9fe7df4b405b5d465f395f669ad75d3bd67c';

/// Provides the number of aquariums that have at least one parameter outside
/// its acceptable range (i.e. [AquariumWithParams.hasAlert] is `true`).
///
/// Returns `0` while loading or when an error occurred.
///
/// Copied from [aquariumsWithAlertsCount].
@ProviderFor(aquariumsWithAlertsCount)
final aquariumsWithAlertsCountProvider = AutoDisposeProvider<int>.internal(
  aquariumsWithAlertsCount,
  name: r'aquariumsWithAlertsCountProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aquariumsWithAlertsCountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AquariumsWithAlertsCountRef = AutoDisposeProviderRef<int>;
String _$aquariumsHash() => r'680c009ee0247f450013e1486252652673b0ad8f';

/// Async provider for the full list of aquariums and their current parameters.
///
/// Manages loading / error / data states automatically via [AsyncValue].
/// During the initial fetch, automatic alert checking is temporarily disabled
/// to prevent spurious notifications; it is re-enabled once loading completes.
///
/// Copied from [Aquariums].
@ProviderFor(Aquariums)
final aquariumsProvider =
    AutoDisposeAsyncNotifierProvider<
      Aquariums,
      List<AquariumWithParams>
    >.internal(
      Aquariums.new,
      name: r'aquariumsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aquariumsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Aquariums = AutoDisposeAsyncNotifier<List<AquariumWithParams>>;
String _$currentAquariumHash() => r'029dbdd9f7bef8b62d3036d7d831b6499d8c8235';

/// Provider that tracks the ID of the aquarium currently selected in the UI.
///
/// The initial value is derived from the first entry in [aquariumsProvider].
/// Use [setAquarium] to change the selection; this also synchronises the
/// underlying [ParameterService] and [TargetParametersService] singletons.
///
/// Copied from [CurrentAquarium].
@ProviderFor(CurrentAquarium)
final currentAquariumProvider =
    AutoDisposeNotifierProvider<CurrentAquarium, int?>.internal(
      CurrentAquarium.new,
      name: r'currentAquariumProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentAquariumHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentAquarium = AutoDisposeNotifier<int?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
