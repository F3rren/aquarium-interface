/// Card-style list tile for a coral inhabitant entry.
library;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/core/theme/app_semantic_colors.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/coral.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// A card displaying a [Coral] specimen with type badge, edit and delete actions.
class CoralListTile extends StatelessWidget {
  final Coral coral;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CoralListTile({
    super.key,
    required this.coral,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  Color _typeColor(BuildContext context) {
    switch (coral.type) {
      case 'SPS':
        return Colors.pink;
      case 'LPS':
        return Theme.of(context).colorScheme.primary;
      default:
        return Theme.of(context).colorScheme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final typeColor = _typeColor(context);

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
                tag: 'coral_${coral.id}',
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: FaIcon(
                      FontAwesomeIcons.seedling,
                      color: typeColor,
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
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            coral.name,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            coral.type,
                            style: TextStyle(
                              color: typeColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coral.species,
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
