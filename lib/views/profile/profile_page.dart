import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/views/dashboard/calculators_page.dart';
import 'package:acquariumfe/views/profile/inhabitants_page.dart';
import 'package:acquariumfe/providers/theme_provider.dart';
import 'package:acquariumfe/providers/aquarium_providers.dart';
import 'package:acquariumfe/providers/locale_provider.dart';
import 'package:acquariumfe/utils/custom_page_route.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

class ProfilePage extends ConsumerWidget {
  final int? aquariumId;

  const ProfilePage({super.key, this.aquariumId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // SEZIONE STRUMENTI
          Text(l10n.tools, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),

          _buildMenuCard(
            context,
            title: l10n.calculators,
            subtitle: l10n.calculatorsSubtitle,
            icon: FontAwesomeIcons.calculator,
            color: const Color(0xFF60a5fa),
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  page: const CalculatorsPage(),
                  transitionType: PageTransitionType.fadeSlide,
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          _buildMenuCard(
            context,
            title: l10n.myInhabitants,
            subtitle: l10n.myInhabitantsSubtitle,
            icon: FontAwesomeIcons.fish,
            color: const Color(0xFFf472b6),
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  page: InhabitantsPage(aquariumId: aquariumId),
                  transitionType: PageTransitionType.fadeSlide,
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // SEZIONE IMPOSTAZIONI
          Text(l10n.settings, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),

          _buildMenuCard(
            context,
            title: l10n.aquariumInfo,
            subtitle: l10n.aquariumInfoSubtitle,
            icon: FontAwesomeIcons.circleInfo,
            color: const Color(0xFF34d399),
            onTap: () {
              _showAquariumInfoDialog(context, ref);
            },
          ),

          const SizedBox(height: 12),

          // THEME TOGGLE
          _buildThemeToggle(context, ref),

          const SizedBox(height: 12),

          // LANGUAGE SELECTOR
          _buildLanguageSelector(context, ref),

          const SizedBox(height: 12),

          _buildMenuCard(
            context,
            title: l10n.appInfo,
            subtitle: l10n.appInfoSubtitle,
            icon: FontAwesomeIcons.gear,
            color: const Color(0xFFa855f7),
            onTap: () {
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(appThemeModeProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
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
              isDarkMode ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
              color: const Color(0xFFfbbf24),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.theme,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(isDarkMode ? l10n.darkMode : l10n.lightMode,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: (_) => ref.read(appThemeModeProvider.notifier).toggle(),
            activeThumbColor: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Determina la lingua corrente
    final currentLanguageCode =
        currentLocale?.languageCode ??
        Localizations.localeOf(context).languageCode;
    final currentLanguageName = getLanguageName(currentLanguageCode);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3b82f6).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              FontAwesomeIcons.language,
              color: Color(0xFF3b82f6),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.language,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(currentLanguageName, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          PopupMenuButton<Locale>(
            icon: Icon(
              Icons.arrow_drop_down,
              color: theme.colorScheme.onSurface,
            ),
            onSelected: (Locale locale) {
              ref.read(localeProvider.notifier).setLocale(locale);
            },
            itemBuilder: (BuildContext context) {
              final supportedLocales = ref.read(supportedLocalesProvider);

              return supportedLocales.map((Locale locale) {
                final isSelected = currentLanguageCode == locale.languageCode;

                return PopupMenuItem<Locale>(
                  value: locale,
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(
                                alpha: 0.5,
                              ),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(getLanguageName(locale.languageCode),
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? theme.colorScheme.primary : null,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
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
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
          ),
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
                  Text(title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.appTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(l10n.appSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Description
                Text(l10n.appDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Legal & Copyright
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.scaleBalanced,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(l10n.mitLicense,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(l10n.copyright,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(l10n.openSourceMessage,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
            label: Text(l10n.close),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildTechItem(
    String name,
    String description,
    IconData icon,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: FaIcon(icon, size: 14, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAquariumInfoDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final aquariumsAsync = ref.read(aquariumsProvider);

    aquariumsAsync.when(
      data: (aquariumsWithParams) {
        if (aquariumsWithParams.isEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.triangleExclamation,
                      color: theme.colorScheme.error,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(l10n.noAquariumSelected,
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
              content: Text(l10n.noAquariumCreated,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.ok),
                ),
              ],
            ),
          );
          return;
        }

        // Se c'è un acquario corrente, mostralo, altrimenti il primo
        final currentAquariumId =
            aquariumId ?? ref.read(currentAquariumProvider);
        final aquariumData = currentAquariumId != null
            ? aquariumsWithParams.firstWhere(
                (a) => a.aquarium.id == currentAquariumId,
                orElse: () => aquariumsWithParams.first,
              )
            : aquariumsWithParams.first;

        final aquarium = aquariumData.aquarium;

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34d399).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FaIcon(
                    aquarium.type == 'Marino'
                        ? FontAwesomeIcons.droplet
                        : aquarium.type == 'Reef'
                        ? FontAwesomeIcons.atom
                        : FontAwesomeIcons.water,
                    color: const Color(0xFF34d399),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(aquarium.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(l10n.aquariumDetails,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tipo
                  _buildInfoRow(
                    'Tipo',
                    aquarium.type,
                    FontAwesomeIcons.tag,
                    theme,
                  ),
                  const SizedBox(height: 16),

                  // Volume
                  _buildInfoRow(
                    'Volume',
                    '${aquarium.volume.toInt()} Litri',
                    FontAwesomeIcons.ruler,
                    theme,
                  ),
                  const SizedBox(height: 16),

                  // Data creazione
                  if (aquarium.createdAt != null)
                    _buildInfoRow(
                      'Creato il',
                      '${aquarium.createdAt!.day}/${aquarium.createdAt!.month}/${aquarium.createdAt!.year}',
                      FontAwesomeIcons.calendar,
                      theme,
                    ),

                  if (aquarium.createdAt != null) const SizedBox(height: 16),

                  // Descrizione
                  if (aquarium.description != null &&
                      aquarium.description!.isNotEmpty) ...[
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.fileLines,
                          size: 14,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(l10n.description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(aquarium.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
                label: Text(l10n.close),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      },
      loading: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          ),
        );
      },
      error: (error, _) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            title: Text(l10n.errorTitle,
              style: TextStyle(color: theme.colorScheme.error),
            ),
            content: Text(l10n.unableToLoadInfo(error.toString())),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.ok),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: FaIcon(icon, size: 14, color: theme.colorScheme.primary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: FaIcon(
              FontAwesomeIcons.circleCheck,
              size: 12,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
        ],
      ),
    );
  }
}
