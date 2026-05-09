// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$darkThemeHash() => r'583861951ed760e4856ab9ba294b110f74f1cfd6';

/// Material 3 dark [ThemeData] using an ocean-inspired deep-blue palette.
///
/// Key colour decisions:
/// - Primary `#3b82f6` — ocean blue
/// - Secondary `#06b6d4` — aqua cyan
/// - Tertiary `#8b5cf6` — coral purple
/// - Scaffold background `#0a0e27` — deep-sea navy
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

/// Material 3 light [ThemeData] using a sky-blue aquatic palette.
///
/// Key colour decisions:
/// - Primary `#0284c7` — sky blue
/// - Secondary `#06b6d4` — cyan
/// - Scaffold background `#f0f9ff` — near-white with a blue tint
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

/// Persistent Riverpod notifier that tracks whether dark mode is active.
///
/// The boolean state is saved under the key `'theme_mode'` in
/// [SharedPreferences] so the user's preference survives app restarts.
/// Default on first launch: **dark mode** (`true`).
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
