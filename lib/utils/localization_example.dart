import 'package:flutter/material.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

/// Esempio di come usare le localizzazioni nei widget
///
/// Per usare le traduzioni in un widget, importa AppLocalizations e
/// usa AppLocalizations.of(context)!.nomeChiave per ottenere la stringa tradotta.
///
/// Esempio:
/// ```dart
/// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
///
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     final l10n = AppLocalizations.of(context)!;
///
///     return Text(l10n.appTitle); // Mostra "ReefLife"
///   }
/// }
/// ```
///
/// Per stringhe con parametri:
/// ```dart
/// final l10n = AppLocalizations.of(context)!;
/// Text(l10n.noResultsDescription('query di ricerca'));
/// Text(l10n.noCompatibleFish('marino'));
/// ```

class LocalizationExample extends StatelessWidget {
  const LocalizationExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Ottieni l'istanza di AppLocalizations per il contesto corrente
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Esempio base
          Text(l10n.aquariums),
          Text(l10n.fish),
          Text(l10n.corals),

          const SizedBox(height: 20),

          // Esempio con parametri
          Text(l10n.noResultsDescription('Nemo')),
          Text(l10n.noCompatibleFish('marino')),

          const SizedBox(height: 20),

          // Esempio in un pulsante
          ElevatedButton(onPressed: () {}, child: Text(l10n.save)),

          // Esempio in un form
          TextField(
            decoration: InputDecoration(
              labelText: l10n.fishNameLabel,
              hintText: l10n.fishNameHint,
            ),
          ),
        ],
      ),
    );
  }
}
