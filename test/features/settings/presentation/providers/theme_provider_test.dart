import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:acquariumfe/features/settings/presentation/providers/theme_provider.dart';
import '../../../../helpers/provider_container.dart';

void main() {
  setUp(() {
    // Provide an in-memory SharedPreferences for every test
    SharedPreferences.setMockInitialValues({});
  });

  group('AppThemeMode', () {
    test('defaults to dark mode (true) on first launch', () {
      final c = makeContainer();
      expect(c.read(appThemeModeProvider), isTrue);
    });

    test('toggle switches from dark to light', () async {
      final c = makeContainer();
      await c.read(appThemeModeProvider.notifier).toggle();
      expect(c.read(appThemeModeProvider), isFalse);
    });

    test('toggle switches back from light to dark', () async {
      final c = makeContainer();
      await c.read(appThemeModeProvider.notifier).toggle();
      await c.read(appThemeModeProvider.notifier).toggle();
      expect(c.read(appThemeModeProvider), isTrue);
    });

    test('persists preference to SharedPreferences', () async {
      final c = makeContainer();
      await c.read(appThemeModeProvider.notifier).toggle(); // now light

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('theme_mode'), isFalse);
    });

    test('toggle persists light mode to SharedPreferences', () async {
      final c = makeContainer();
      await c.read(appThemeModeProvider.notifier).toggle(); // dark → light

      final prefs = await SharedPreferences.getInstance();
      // Verify the new value was written to storage
      expect(prefs.getBool('theme_mode'), isFalse);
    });
  });

  group('darkThemeProvider', () {
    test('returns ThemeData with dark brightness', () {
      final c = makeContainer();
      final theme = c.read(darkThemeProvider);
      expect(theme.brightness, equals(Brightness.dark));
    });

    test('uses Material 3', () {
      final c = makeContainer();
      final theme = c.read(darkThemeProvider);
      expect(theme.useMaterial3, isTrue);
    });

    test('primary color is ocean blue', () {
      final c = makeContainer();
      final theme = c.read(darkThemeProvider);
      expect(theme.colorScheme.primary, equals(const Color(0xFF3b82f6)));
    });
  });

  group('lightThemeProvider', () {
    test('returns ThemeData with light brightness', () {
      final c = makeContainer();
      final theme = c.read(lightThemeProvider);
      expect(theme.brightness, equals(Brightness.light));
    });

    test('primary color is sky blue', () {
      final c = makeContainer();
      final theme = c.read(lightThemeProvider);
      expect(theme.colorScheme.primary, equals(const Color(0xFF0284c7)));
    });
  });
}
