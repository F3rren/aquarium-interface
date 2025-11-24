// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parameters_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hasParameterAlertsHash() =>
    r'35e7a5afd9b0b7012cccbe0f9a1665809dfdeaa9';

/// Provider che indica se i parametri sono fuori range
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

/// Provider per i parametri target dell'acquario corrente
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
String _$currentParametersHash() => r'4ab23c539bf7c60b16e838b7b044d7266176dc96';

/// Provider per i parametri correnti dell'acquario selezionato
/// Si aggiorna automaticamente quando cambia l'acquario corrente
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
