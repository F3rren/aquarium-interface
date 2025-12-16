import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider per la gestione del locale dell'app
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

/// Notifier per gestire i cambi di lingua
class LocaleNotifier extends StateNotifier<Locale?> {
  static const String _localeKey = 'app_locale';

  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  /// Carica il locale salvato dalle preferenze
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);

    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  /// Cambia il locale e lo salva nelle preferenze
  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  /// Reimposta il locale al sistema
  Future<void> resetLocale() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
  }
}

/// Provider per le lingue supportate
final supportedLocalesProvider = Provider<List<Locale>>((ref) {
  return const [
    Locale('it'), // Italiano
    Locale('en'), // Inglese
    Locale('es'), // Spagnolo
    Locale('de'), // Tedesco
    Locale('fr'), // Francese
  ];
});

/// Helper per ottenere il nome della lingua
String getLanguageName(String languageCode) {
  switch (languageCode) {
    case 'it':
      return 'Italiano';
    case 'en':
      return 'English';
    case 'es':
      return 'Español';
    case 'de':
      return 'Deutsch';
    case 'fr':
      return 'Français';
    default:
      return languageCode;
  }
}
