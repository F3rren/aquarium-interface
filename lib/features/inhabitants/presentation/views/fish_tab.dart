/// Fish tab content for the inhabitants page.
library;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/core/theme/app_semantic_colors.dart';
import 'package:acquariumfe/core/widgets/skeleton_loader_card.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/fish.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/inhabitants_filter.dart';
import 'package:acquariumfe/features/inhabitants/domain/utils/inhabitants_filter_utils.dart';
import 'package:acquariumfe/features/inhabitants/presentation/widgets/fish_list_tile.dart';
import 'package:acquariumfe/features/inhabitants/presentation/widgets/inhabitant_empty_filter_result.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// Displays the full fish tab: skeleton, empty state, filtered list, and FAB.
class FishTab extends StatelessWidget {
  final List<Fish> fishList;
  final bool isLoading;
  final InhabitantsFilter filter;
  final double bottomPadding;
  final VoidCallback onAdd;
  final void Function(Fish) onEdit;
  final void Function(Fish) onDelete;
  final void Function(Fish) onTap;
  final VoidCallback onClearFilters;

  const FishTab({
    super.key,
    required this.fishList,
    required this.isLoading,
    required this.filter,
    required this.bottomPadding,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        _buildBody(context, l10n),
        Positioned(
          right: 16,
          bottom: bottomPadding + 16,
          child: FloatingActionButton.extended(
            onPressed: onAdd,
            backgroundColor: context.semantic.statusLow,
            foregroundColor: Colors.white,
            icon: const FaIcon(FontAwesomeIcons.plus),
            label: Text(l10n.addFish),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);

    if (isLoading) {
      return ListView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + bottomPadding,
        ),
        children: List.generate(5, (_) => const ListItemSkeleton()),
      );
    }

    if (fishList.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 8, bottom: bottomPadding + 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.fish,
                size: 48,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.noFishAdded,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.tapToAddFirstFish,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final filtered = applyInhabitantsFilter(fishList, filter);

    if (filtered.isEmpty) {
      return InhabitantEmptyFilterResult(onClearFilters: onClearFilters);
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + bottomPadding,
      ),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final fish = filtered[index];
        return FishListTile(
          key: ValueKey(fish.id),
          fish: fish,
          onTap: () => onTap(fish),
          onEdit: () => onEdit(fish),
          onDelete: () => onDelete(fish),
        );
      },
    );
  }
}
