/// Empty-state widget shown when active filters produce no results.
library;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// Shows a "no results" message with a button to reset all active filters.
class InhabitantEmptyFilterResult extends StatelessWidget {
  final VoidCallback onClearFilters;

  const InhabitantEmptyFilterResult({
    super.key,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.magnifyingGlass,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noResultsFound,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tryModifyingFilters,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onClearFilters,
              icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
              label: Text(l10n.clearFilters),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
