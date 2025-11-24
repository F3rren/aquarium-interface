// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$darkThemeHash() => r'583861951ed760e4856ab9ba294b110f74f1cfd6';

/// Provider per il tema dark
///
/// Copied from [darkTheme].
@ProviderFor(darkTheme)
final darkThemeProvider = AutoDisposeProvider<ThemeData>.internal(
  darkTheme,
  name: r'darkThemeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$darkThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DarkThemeRef = AutoDisposeProviderRef<ThemeData>;
String _$lightThemeHash() => r'1990c18a92050889429ab16ac30ca0d8a0ef0bf8';

/// Provider per il tema light
///
/// Copied from [lightTheme].
@ProviderFor(lightTheme)
final lightThemeProvider = AutoDisposeProvider<ThemeData>.internal(
  lightTheme,
  name: r'lightThemeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lightThemeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LightThemeRef = AutoDisposeProviderRef<ThemeData>;
String _$appThemeModeHash() => r'a162b27c7326a9989ce0b1d450dac21b5404c16f';

/// Provider per gestire il tema dell'app (dark/light mode)
///
/// Copied from [AppThemeMode].
@ProviderFor(AppThemeMode)
final appThemeModeProvider =
    AutoDisposeNotifierProvider<AppThemeMode, bool>.internal(
      AppThemeMode.new,
      name: r'appThemeModeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$appThemeModeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AppThemeMode = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
