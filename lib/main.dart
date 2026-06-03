/// Entry point and root widget tree for the ReefLife application.
///
/// Initialises essential services (push notifications, alert manager) before
/// handing control to Flutter's widget tree.  The Riverpod [ProviderScope] is
/// placed at the very top so that every descendant widget can read and watch
/// providers without additional setup.
library;

import 'dart:async';

import 'package:logger/logger.dart';
import 'package:acquariumfe/core/routing/app_routes.dart';
import 'package:acquariumfe/features/aquarium/presentation/views/acquariums_view.dart';
import 'package:acquariumfe/core/widgets/navbar/navbar.dart';
import 'package:acquariumfe/features/settings/data/notification_service.dart';
import 'package:acquariumfe/features/settings/data/alert_manager.dart';
import 'package:acquariumfe/features/settings/data/app_locale_service.dart';
import 'package:acquariumfe/features/settings/domain/models/notification_settings.dart';
import 'package:acquariumfe/features/settings/presentation/providers/theme_provider.dart';
import 'package:acquariumfe/features/settings/presentation/providers/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// Shared initialisation logic called by every flavor entry point.
///
/// [flavor] is one of `'dev'`, `'staging'`, or `'prod'`. It controls the
/// debug banner visibility and the app title suffix shown in non-production
/// builds.
Future<void> bootstrap(String flavor) async {
  final logger = Logger();

  // Run the whole app inside a guarded zone so uncaught async errors are
  // logged instead of vanishing (or, during startup, leaving a blank screen).
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Forward Flutter framework (build/layout/paint) errors to the logger.
      FlutterError.onError = (details) {
        logger.e(
          'Flutter framework error',
          error: details.exception,
          stackTrace: details.stack,
        );
        FlutterError.presentError(details);
      };

      // Best-effort startup init: a failure here (e.g. a denied notification
      // permission) must not stop the app from rendering.
      try {
        await NotificationService().initialize();
        AlertManager().initialize(
          NotificationSettings(
            enabledAlerts: true,
            enabledMaintenance: true,
            enabledDaily: false,
          ),
        );
      } catch (e, st) {
        logger.e(
          'Service initialisation failed; continuing',
          error: e,
          stackTrace: st,
        );
      }

      runApp(ProviderScope(child: MyApp(flavor: flavor)));
    },
    (error, stack) {
      logger.e('Uncaught zone error', error: error, stackTrace: stack);
    },
  );
}

/// Default entry point — uses the dev flavor.
///
/// Use flavor-specific entry points for targeted builds:
/// - `lib/main_dev.dart`     → `flutter run --flavor dev`
/// - `lib/main_staging.dart` → `flutter run --flavor staging`
/// - `lib/main_prod.dart`    → `flutter build appbundle --flavor prod`
void main() => bootstrap('dev');

/// Root widget of the ReefLife application.
///
/// This [ConsumerWidget] observes two top-level Riverpod providers:
/// - [appThemeModeProvider] — switches between light and dark [ThemeMode].
/// - [localeProvider] — drives the active [Locale] for the whole app.
///
/// It configures [MaterialApp] with:
/// - Dynamically themed [ThemeData] supplied by [lightThemeProvider] and
///   [darkThemeProvider].
/// - Full i18n support for Italian, English, Spanish, German, and French via
///   the generated [AppLocalizations] delegate.
/// - Named-route navigation handled by [AppRouter.generateRoute].
///
/// Whenever the locale changes, [AppLocaleService] is updated so that
/// non-widget code (e.g. notification text builders) can access the current
/// locale without a [BuildContext].
class MyApp extends ConsumerWidget {
  const MyApp({super.key, required this.flavor});

  /// Current build flavor: `'dev'`, `'staging'`, or `'prod'`.
  final String flavor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(localeProvider);

    // Sincronizza la locale con AppLocaleService ogni volta che cambia
    if (locale != null) {
      AppLocaleService().setLocale(locale);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: flavor != 'prod',
      title: flavor == 'prod' ? 'ReefLife' : 'ReefLife (${flavor.toUpperCase()})',
      theme: ref.watch(lightThemeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // Localizzazione
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it'), // Italiano
        Locale('en'), // Inglese
        Locale('es'), // Spagnolo
        Locale('de'), // Tedesco
        Locale('fr'), // Francese
      ],

      home: const HomePage(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

/// The first screen shown after the app launches.
///
/// Wraps its content in a [Container] with an adaptive linear gradient so that
/// the background transitions smoothly between the dark navy palette (dark
/// mode) and the sky-blue/white palette (light mode).  The [Scaffold] sits on
/// top of this gradient with a transparent background so the gradient shows
/// through.
///
/// Structure:
/// - AppBar — [Navbar] (contains branding, search, and settings actions).
/// - Body — [AquariumView] (the main list/grid of the user's aquariums).
class HomePage extends StatelessWidget {
  /// Creates the home page.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF0a0e27),
                  const Color(0xFF1a1f3a),
                  const Color(0xFF252b4a),
                  const Color(0xFF1a1f3a),
                ]
              : [
                  const Color(0xFFe0f2fe),
                  const Color(0xFFf0f9ff),
                  Colors.white,
                  const Color(0xFFe0f2fe),
                ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: Navbar(),
        body: AquariumView(),
      ),
    );
  }
}
