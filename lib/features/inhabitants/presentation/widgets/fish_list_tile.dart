/// Card-style list tile for a fish inhabitant entry.
library;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/core/theme/app_semantic_colors.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/fish.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// A card displaying a [Fish] specimen with edit and delete popup actions.
class FishListTile extends StatelessWidget {
  final Fish fish;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FishListTile({
    super.key,
    required this.fish,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Hero(
                tag: 'fish_${fish.id}',
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.fish,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fish.name,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fish.species,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: FaIcon(
                  FontAwesomeIcons.ellipsisVertical,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.pen,
                          color: context.semantic.statusLow,
                          size: 16,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.edit,
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.trash,
                          color: Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.delete,
                          style: TextStyle(color: theme.colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
