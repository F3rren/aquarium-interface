import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// Provider per gestire il tema dell'app (dark/light mode)
@riverpod
class AppThemeMode extends _$AppThemeMode {
  static const String _themeKey = 'theme_mode';

  @override
  bool build() {
    // Carica il tema salvato in modo asincrono
    _loadTheme();
    // Default: dark mode
    return true;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? true;
    state = isDark;
  }

  Future<void> toggle() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, state);
  }
}

/// Provider per il tema dark
@riverpod
ThemeData darkTheme(DarkThemeRef ref) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0a0e27),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3b82f6), // Blu oceano
      secondary: Color(0xFF06b6d4), // Cyan acqua
      tertiary: Color(0xFF8b5cf6), // Viola corallo
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

/// Provider per il tema light
@riverpod
ThemeData lightTheme(LightThemeRef ref) {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFf0f9ff),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF0284c7), // Blu sky
      secondary: Color(0xFF06b6d4), // Cyan
      tertiary: Color(0xFF8b5cf6), // Viola
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
