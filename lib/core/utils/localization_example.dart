/// Developer reference widget showing how to use [AppLocalizations] in practice.
///
/// This file is **not** part of the production app flow. It exists purely as
/// an in-codebase cheat-sheet for contributors who need examples of:
/// - Basic string lookup (`l10n.appTitle`)
/// - Parameterised strings (`l10n.noResultsDescription('Nemo')`)
/// - Using localised strings inside form widgets
///
/// Usage pattern for any widget:
/// ```dart
/// import 'package:acquariumfe/core/l10n/app_localizations.dart';
///
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     final l10n = AppLocalizations.of(context)!;
///     return Text(l10n.appTitle); // → "ReefLife"
///   }
/// }
/// ```
///
/// For strings with parameters:
/// ```dart
/// Text(l10n.noResultsDescription('search query'));
/// Text(l10n.noCompatibleFish('marine'));
/// ```
library;

import 'package:flutter/material.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// A minimal screen that demonstrates every localisation pattern used in the
/// ReefLife app. Not linked from any production navigation route.
class LocalizationExample extends StatelessWidget {
  const LocalizationExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain the AppLocalizations instance for the active locale.
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Basic string lookups.
          Text(l10n.aquariums),
          Text(l10n.fish),
          Text(l10n.corals),

          const SizedBox(height: 20),

          // Parameterised string examples.
          Text(l10n.noResultsDescription('Nemo')),
          Text(l10n.noCompatibleFish('marino')),

          const SizedBox(height: 20),

          // Localised string inside a button label.
          ElevatedButton(onPressed: () {}, child: Text(l10n.save)),

          // Localised label and hint in a text field.
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
