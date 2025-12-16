import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acquariumfe/providers/locale_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

/// Widget per selezionare la lingua dell'applicazione
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final supportedLocales = ref.watch(supportedLocalesProvider);
    final theme = Theme.of(context);

    return PopupMenuButton<Locale>(
      icon: const FaIcon(FontAwesomeIcons.language, size: 20),
      tooltip: l10n.selectLanguage,
      onSelected: (Locale locale) {
        ref.read(localeProvider.notifier).setLocale(locale);
      },
      itemBuilder: (BuildContext context) {
        return supportedLocales.map((Locale locale) {
          final isSelected = currentLocale?.languageCode == locale.languageCode;

          return PopupMenuItem<Locale>(
            value: locale,
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? theme.colorScheme.primary : null,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text( getLanguageName(locale.languageCode),
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
    );
  }
}

/// Dialog per selezionare la lingua
class LanguageDialog extends ConsumerWidget {
  const LanguageDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final supportedLocales = ref.watch(supportedLocalesProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Row(
        children: [
          const FaIcon(FontAwesomeIcons.language, size: 20),
          const SizedBox(width: 12),
          Text(l10n.selectLanguage),
        ],
      ),
      content: SizedBox(
        width: double.minPositive,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: supportedLocales.length,
          itemBuilder: (context, index) {
            final locale = supportedLocales[index];
            final isSelected =
                currentLocale?.languageCode == locale.languageCode;

            return ListTile(
              leading: Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? theme.colorScheme.primary : null,
              ),
              title: Text(getLanguageName(locale.languageCode),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(locale);
                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Chiudi'),
        ),
      ],
    );
  }

  /// Mostra il dialog di selezione lingua
  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => const LanguageDialog(),
    );
  }
}

/// Tile per le impostazioni con icona lingua
class LanguageSettingTile extends ConsumerWidget {
  const LanguageSettingTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final languageName = currentLocale != null
        ? getLanguageName(currentLocale.languageCode)
        : 'Sistema';

    return ListTile(
      leading: const FaIcon(FontAwesomeIcons.language),
      title: Text(AppLocalizations.of(context)!.language),
      subtitle: Text(languageName),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => LanguageDialog.show(context),
    );
  }
}
