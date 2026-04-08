/// Locale management providers for the ReefLife app.
///
/// Exposes [localeProvider] for persisting and reacting to language changes,
/// [supportedLocalesProvider] for the list of supported languages, and the
/// [getLanguageName] helper to get a human-readable language name from a BCP-47
/// language code.
///
/// Supported locales: Italian (it), English (en), Spanish (es),
/// German (de), French (fr).  Italian is the default when no preference is
/// stored yet.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:acquariumfe/services/app_locale_service.dart';

/// Riverpod provider that exposes the current [Locale] and allows it to be
/// changed at runtime.
///
/// The state is `null` only between app launch and the moment the persisted
/// preference is loaded; once loaded it is always a non-null [Locale].
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

/// State notifier responsible for loading, persisting, and broadcasting locale
/// changes across the app.
///
/// On construction the previously saved language code is read from
/// [SharedPreferences] and applied to both this notifier and the singleton
/// [AppLocaleService]. If no preference exists, Italian (`it`) is used as the
/// default locale.
class LocaleNotifier extends StateNotifier<Locale?> {
  /// [SharedPreferences] key used to persist the selected language code.
  static const String _localeKey = 'app_locale';

  /// Creates the notifier and immediately initiates an asynchronous load of the
  /// persisted locale preference.
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  /// Reads the saved language code from [SharedPreferences] and updates the
  /// state. Also synchronises [AppLocaleService] so that non-widget code can
  /// access the current locale without a [BuildContext].
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);

    if (languageCode != null) {
      final locale = Locale(languageCode);
      state = locale;
      // Synchronise with AppLocaleService for context-free access.
      AppLocaleService().setLocale(locale);
    } else {
      // No saved preference — fall back to Italian.
      const defaultLocale = Locale('it');
      state = defaultLocale;
      AppLocaleService().setLocale(defaultLocale);
    }
  }

  /// Persists [locale] to [SharedPreferences] and updates the app-wide locale
  /// immediately, including the [AppLocaleService] singleton.
  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    // Synchronise with AppLocaleService.
    AppLocaleService().setLocale(locale);
  }

  /// Removes the persisted locale preference so that the app reverts to the
  /// system default on the next cold start.
  ///
  /// Because [AppLocaleService] requires an explicit locale at all times, it is
  /// reset to Italian (`it`) rather than left undefined.
  Future<void> resetLocale() async {
    state = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeKey);
    // Reset AppLocaleService to the Italian default.
    AppLocaleService().setLocale(const Locale('it'));
  }
}

/// Provides the immutable list of [Locale]s supported by the app.
///
/// Used to populate the language selector UI and to configure
/// `MaterialApp.supportedLocales`.
final supportedLocalesProvider = Provider<List<Locale>>((ref) {
  return const [
    Locale('it'), // Italian
    Locale('en'), // English
    Locale('es'), // Spanish
    Locale('de'), // German
    Locale('fr'), // French
  ];
});

/// Returns the human-readable display name for the given BCP-47 [languageCode].
///
/// Falls back to [languageCode] itself when no mapping is found, which keeps
/// the UI functional even if an unsupported code is passed.
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
