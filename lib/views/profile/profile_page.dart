import 'package:flutter/material.dart';
import 'package:acquariumfe/views/dashboard/calculators_page.dart';
import 'package:acquariumfe/views/profile/inhabitants_page.dart';
import 'package:acquariumfe/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // SEZIONE STRUMENTI
          Text(
            'Strumenti',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          
          _buildMenuCard(
            context,
            title: 'Calcolatori',
            subtitle: 'Volume, dosaggio additivi, cambio acqua',
            icon: Icons.calculate,
            color: const Color(0xFF60a5fa),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CalculatorsPage()),
              );
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildMenuCard(
            context,
            title: 'I Miei Abitanti',
            subtitle: 'Gestisci pesci e coralli',
            icon: Icons.pets,
            color: const Color(0xFFf472b6),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InhabitantsPage()),
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // SEZIONE IMPOSTAZIONI
          Text(
            'Impostazioni',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          
          _buildMenuCard(
            context,
            title: 'Info Acquario',
            subtitle: 'Nome, volume, tipo',
            icon: Icons.info_outline,
            color: const Color(0xFF34d399),
            onTap: () {
              // TODO: Implementare
            },
          ),
          
          const SizedBox(height: 12),
          
          // THEME TOGGLE
          _buildThemeToggle(context),
          
          const SizedBox(height: 12),
          
          _buildMenuCard(
            context,
            title: 'Informazioni App',
            subtitle: 'Versione, crediti',
            icon: Icons.app_settings_alt,
            color: const Color(0xFFa855f7),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFfbbf24).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: const Color(0xFFfbbf24),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tema',
                  style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  themeProvider.isDarkMode ? 'Modalità scura' : 'Modalità chiara',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
            activeColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Row(
          children: [
            Icon(Icons.info, color: theme.colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            Text('AcquariumFE', style: theme.textTheme.headlineSmall),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versione: 1.0.0', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Sistema di monitoraggio acquario marino', style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            Text('Sviluppato con Flutter', style: theme.textTheme.bodySmall),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Chiudi', style: TextStyle(color: theme.colorScheme.primary)),
          ),
        ],
      ),
    );
  }
}

