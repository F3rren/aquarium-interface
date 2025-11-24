import 'package:acquariumfe/routes/app_routes.dart';
import 'package:acquariumfe/views/home/acquariums_view.dart';
import 'package:acquariumfe/views/shared/navbar/navbar.dart';
import 'package:acquariumfe/services/notification_service.dart';
import 'package:acquariumfe/services/alert_manager.dart';
import 'package:acquariumfe/models/notification_settings.dart';
import 'package:acquariumfe/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inizializza il servizio notifiche
  await NotificationService().initialize();
  
  // Inizializza l'alert manager con impostazioni di default
  AlertManager().initialize(NotificationSettings(
    enabledAlerts: true,
    enabledMaintenance: true,
    enabledDaily: false,
  ));
  
  runApp(
    // ProviderScope è il root di Riverpod
    const ProviderScope(
      child: MyApp(),
      
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appThemeModeProvider);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReefLife',
      theme: ref.watch(lightThemeProvider),
      darkTheme: ref.watch(darkThemeProvider),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

class HomePage extends StatelessWidget {
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
