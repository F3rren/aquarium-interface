/// Riverpod providers for app theming (dark/light mode) and Material 3 theme data.
///
/// [AppThemeMode] is a persistent notifier: it reads the last chosen mode from
/// [SharedPreferences] on startup and writes back on every toggle.
/// [darkTheme] and [lightTheme] expose fully configured [ThemeData] objects
/// using an ocean/aquarium-inspired colour palette.
library;

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// Persistent Riverpod notifier that tracks whether dark mode is active.
///
/// The boolean state is saved under the key `'theme_mode'` in
/// [SharedPreferences] so the user's preference survives app restarts.
/// Default on first launch: **dark mode** (`true`).
@riverpod
class AppThemeMode extends _$AppThemeMode {
  static const String _themeKey = 'theme_mode';

  @override
  bool build() {
    // Load persisted preference asynchronously; default to dark in the meantime.
    _loadTheme();
    return true;
  }

  /// Reads the persisted theme preference from [SharedPreferences] and updates
  /// [state] accordingly. Called once during [build].
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? true;
    state = isDark;
  }

  /// Toggles between dark and light mode and persists the new value.
  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, state);
  }
}

/// Material 3 dark [ThemeData] using an ocean-inspired deep-blue palette.
///
/// Key colour decisions:
/// - Primary `#3b82f6` — ocean blue
/// - Secondary `#06b6d4` — aqua cyan
/// - Tertiary `#8b5cf6` — coral purple
/// - Scaffold background `#0a0e27` — deep-sea navy
@riverpod
ThemeData darkTheme(DarkThemeRef ref) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0a0e27),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3b82f6),
      secondary: Color(0xFF06b6d4),
      tertiary: Color(0xFF8b5cf6),
      surface: Color(0xFF1a1f3a),
      surfaceContainerHighest: Color(0xFF252b4a),
      error: Color(0xFFef4444),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onSurfaceVariant: Color(0xFFa1a9c9),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1a1f3a),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1a1f3a),
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF3b82f6),
      foregroundColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3b82f6),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF252b4a),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3b82f6), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3b82f6), width: 2),
      ),
    ),

    iconTheme: const IconThemeData(color: Color(0xFF3b82f6)),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Color(0xFFa1a9c9)),
    ),
  );
}

/// Material 3 light [ThemeData] using a sky-blue aquatic palette.
///
/// Key colour decisions:
/// - Primary `#0284c7` — sky blue
/// - Secondary `#06b6d4` — cyan
/// - Scaffold background `#f0f9ff` — near-white with a blue tint
@riverpod
ThemeData lightTheme(LightThemeRef ref) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFf0f9ff),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0284c7),
      secondary: Color(0xFF06b6d4),
      tertiary: Color(0xFF8b5cf6),
      surface: Colors.white,
      surfaceContainerHighest: Color(0xFFe0f2fe),
      error: Color(0xFFdc2626),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF0f172a),
      onSurfaceVariant: Color(0xFF64748b),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0f172a),
      elevation: 0,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF0284c7),
      foregroundColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0284c7),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFe0f2fe),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0284c7), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0284c7), width: 2),
      ),
    ),

    iconTheme: const IconThemeData(color: Color(0xFF0284c7)),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF0f172a),
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF0f172a),
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: Color(0xFF0f172a),
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(color: Color(0xFF0f172a)),
      bodyMedium: TextStyle(color: Color(0xFF64748b)),
    ),
  );
}
