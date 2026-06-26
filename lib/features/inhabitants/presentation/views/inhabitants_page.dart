/// Tabbed page listing the fish and corals inhabiting an aquarium.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/fish.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/coral.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/inhabitants_filter.dart';
import 'package:acquariumfe/features/inhabitants/data/inhabitants_service.dart';
import 'package:acquariumfe/core/providers/service_providers.dart';
import 'package:acquariumfe/core/utils/app_logger.dart';
import 'package:acquariumfe/core/utils/exception_localizer.dart';
import 'package:acquariumfe/core/widgets/animated_number.dart';
import 'package:acquariumfe/features/inhabitants/presentation/widgets/inhabitants_filter_panel.dart';
import 'package:acquariumfe/features/aquarium/presentation/providers/aquarium_providers.dart';
import 'package:acquariumfe/features/inhabitants/presentation/views/fish_tab.dart';
import 'package:acquariumfe/features/inhabitants/presentation/views/corals_tab.dart';
import 'add_fish_dialog.dart';
import 'add_coral_dialog.dart';
import 'coral_details_dialog.dart';
import 'fish_details_dialog.dart';
import 'package:acquariumfe/core/theme/app_semantic_colors.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// Two-tab page (Fish / Corals) for managing the inhabitants of [aquariumId].
///
/// **Data loading:** both lists are fetched in parallel from
/// [InhabitantsService]. The aquarium's water type is read from
/// [aquariumsProvider] to filter the species database shown in the add dialogs
/// (e.g. corals are not offered for freshwater aquariums).
///
/// **Filtering:** the [InhabitantsFilterPanel] allows filtering by difficulty,
/// date added, reef-safe flag, and a search query. Active filters are tracked
/// in [_filter] ([InhabitantsFilter]).
///
/// **CRUD:** FAB opens [AddFishDialog] or [AddCoralDialog] depending on the
/// active tab. Tapping an item opens [FishDetailsDialog] or
/// [CoralDetailsDialog]. Long-pressing shows an edit / delete action sheet.
///
/// **Stats bar:** animated counters showing total fish and coral counts.
class InhabitantsPage extends ConsumerStatefulWidget {
  final int? aquariumId;

  const InhabitantsPage({super.key, this.aquariumId});

  @override
  ConsumerState<InhabitantsPage> createState() => _InhabitantsPageState();
}

class _InhabitantsPageState extends ConsumerState<InhabitantsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final InhabitantsService _service = ref.read(inhabitantsServiceProvider);

  List<Fish> _fishList = [];
  List<Coral> _coralsList = [];
  bool _isLoading = true;
  String? _aquariumWaterType;
  InhabitantsFilter _filter = InhabitantsFilter();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    String? previousWaterType = _aquariumWaterType;
    if (widget.aquariumId != null) {
      try {
        final aquariumsAsync = ref.read(aquariumsProvider);
        await aquariumsAsync.when(
          data: (aquariumsWithParams) {
            final aquarium = aquariumsWithParams
                .firstWhere((a) => a.aquarium.id == widget.aquariumId)
                .aquarium;
            _aquariumWaterType = aquarium.type;
          },
          loading: () {
            _aquariumWaterType = 'Marino';
          },
          error: (_, __) {
            _aquariumWaterType = 'Marino';
          },
        );
      } catch (e) {
        _aquariumWaterType = 'Marino';
      }
    } else {
      _aquariumWaterType = 'Marino';
    }

    if (_aquariumWaterType != previousWaterType || previousWaterType == null) {
      final currentIndex = _tabController.index;
      _tabController.dispose();
      final isDolce = _aquariumWaterType?.toLowerCase() == 'dolce';
      _tabController = TabController(
        length: isDolce ? 1 : 2,
        vsync: this,
        initialIndex: isDolce ? 0 : (currentIndex < 2 ? currentIndex : 0),
      );
    }

    try {
      final aquariumId = widget.aquariumId;
      if (aquariumId != null) {
        _fishList = await _service.getFish(aquariumId);
        _coralsList = await _service.getCorals(aquariumId);
      }
    } catch (e) {
      AppLogger.w('Failed to load inhabitants', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ExceptionLocalizer.getMessage(context, e)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _reloadDataSilently() async {
    final aquariumId = widget.aquariumId;
    if (aquariumId == null) return;
    try {
      final newFish = await _service.getFish(aquariumId);
      final newCorals = await _service.getCorals(aquariumId);
      if (!mounted) return;
      setState(() {
        _fishList = newFish;
        _coralsList = newCorals;
      });
    } catch (e) {
      AppLogger.w('Silent inhabitants reload failed; keeping current data',
          error: e);
    }
  }

  Future<void> _refreshData() async {
    final l10n = AppLocalizations.of(context)!;
    await _loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const FaIcon(FontAwesomeIcons.circleCheck, color: Colors.white),
              const SizedBox(width: 12),
              Text(l10n.inhabitantsUpdated),
            ],
          ),
          backgroundColor: context.semantic.statusOptimal,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _showFilterPanel() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) => InhabitantsFilterPanel(
            currentFilter: _filter,
            onFilterChanged: (newFilter) => setState(() => _filter = newFilter),
            onClose: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  void _showAddFishDialog() {
    showDialog(
      context: context,
      builder: (context) => AddFishDialog(
        aquariumWaterType: _aquariumWaterType,
        onSave: (fish, speciesId) async {
          final aquariumId = widget.aquariumId;
          if (aquariumId == null) return;
          await _service.addFish(aquariumId, fish, speciesId);
          await _reloadDataSilently();
        },
        onSaveMultiple: (fishList, speciesId) async {
          final aquariumId = widget.aquariumId;
          if (aquariumId == null) return;
          for (final fish in fishList) {
            await _service.addFish(aquariumId, fish, speciesId);
          }
          _loadData();
        },
      ),
    );
  }

  void _showEditFishDialog(Fish fish) {
    showDialog(
      context: context,
      builder: (context) => AddFishDialog(
        fish: fish,
        aquariumWaterType: _aquariumWaterType,
        onSave: (updatedFish, speciesId) async {
          final aquariumId = widget.aquariumId;
          if (aquariumId == null) return;
          await _service.updateFish(aquariumId, updatedFish);
          _loadData();
        },
      ),
    );
  }

  void _showAddCoralDialog() {
    showDialog(
      context: context,
      builder: (context) => AddCoralDialog(
        onSave: (coral, speciesId) async {
          final aquariumId = widget.aquariumId;
          if (aquariumId == null) return;
          await _service.addCoral(aquariumId, coral, speciesId);
          await _reloadDataSilently();
        },
        onSaveMultiple: (coralList, speciesId) async {
          final aquariumId = widget.aquariumId;
          if (aquariumId == null) return;
          for (final coral in coralList) {
            await _service.addCoral(aquariumId, coral, speciesId);
          }
          _loadData();
        },
      ),
    );
  }

  void _showEditCoralDialog(Coral coral) {
    showDialog(
      context: context,
      builder: (context) => AddCoralDialog(
        coral: coral,
        onSave: (updatedCoral, speciesId) async {
          final aquariumId = widget.aquariumId;
          if (aquariumId == null) return;
          await _service.updateCoral(aquariumId, updatedCoral);
          _loadData();
        },
      ),
    );
  }

  Future<void> _deleteFish(Fish fish) async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(l10n.confirmDeletion,
          style: TextStyle(color: theme.colorScheme.onSurface)),
        content: Text(l10n.confirmDeleteFish(fish.name),
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _fishList.removeWhere((f) => f.id == fish.id));
      await Future.delayed(const Duration(milliseconds: 100));
      final aquariumId = widget.aquariumId;
      if (aquariumId != null) {
        await _service.deleteFish(aquariumId, fish.id);
      }
      _reloadDataSilently();
    }
  }

  Future<void> _deleteCoral(Coral coral) async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(l10n.confirmDeletion,
          style: TextStyle(color: theme.colorScheme.onSurface)),
        content: Text(l10n.confirmDeleteCoral(coral.name),
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _coralsList.removeWhere((c) => c.id == coral.id));
      await Future.delayed(const Duration(milliseconds: 100));
      final aquariumId = widget.aquariumId;
      if (aquariumId != null) {
        await _service.deleteCoral(aquariumId, coral.id);
      }
      _reloadDataSilently();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final isDolce = (_aquariumWaterType ?? 'Marino').toLowerCase() == 'dolce';
    final tabCount = isDolce ? 1 : 2;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.myInhabitants,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.filter, size: 20),
                onPressed: _showFilterPanel,
                tooltip: l10n.filtersAndSearch,
              ),
              if (_filter.hasActiveFilters)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${_filter.activeFilterCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: _tabController.length == tabCount
            ? TabBar(
                controller: _tabController,
                indicatorColor: theme.colorScheme.primary,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                tabs: isDolce
                    ? [Tab(text: l10n.fish, icon: const FaIcon(FontAwesomeIcons.fish))]
                    : [
                        Tab(text: l10n.fish, icon: const FaIcon(FontAwesomeIcons.fish)),
                        Tab(text: l10n.corals, icon: const FaIcon(FontAwesomeIcons.seedling)),
                      ],
              )
            : null,
      ),
      body: _isLoading || _tabController.length != tabCount
          ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
          : RefreshIndicator(
              onRefresh: _refreshData,
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surface,
              child: Column(
                children: [
                  _InhabitantsStatsCard(
                    key: const ValueKey('stats_card'),
                    fishList: _fishList,
                    coralsList: _coralsList,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: isDolce
                          ? [
                              FishTab(
                                fishList: _fishList,
                                isLoading: _isLoading,
                                filter: _filter,
                                bottomPadding: bottomPadding,
                                onAdd: _showAddFishDialog,
                                onEdit: _showEditFishDialog,
                                onDelete: _deleteFish,
                                onTap: (fish) => showDialog(
                                  context: context,
                                  builder: (_) => FishDetailsDialog(fish: fish),
                                ),
                                onClearFilters: () =>
                                    setState(() => _filter = _filter.clearAll()),
                              ),
                            ]
                          : [
                              FishTab(
                                fishList: _fishList,
                                isLoading: _isLoading,
                                filter: _filter,
                                bottomPadding: bottomPadding,
                                onAdd: _showAddFishDialog,
                                onEdit: _showEditFishDialog,
                                onDelete: _deleteFish,
                                onTap: (fish) => showDialog(
                                  context: context,
                                  builder: (_) => FishDetailsDialog(fish: fish),
                                ),
                                onClearFilters: () =>
                                    setState(() => _filter = _filter.clearAll()),
                              ),
                              CoralsTab(
                                coralsList: _coralsList,
                                isLoading: _isLoading,
                                filter: _filter,
                                bottomPadding: bottomPadding,
                                onAdd: _showAddCoralDialog,
                                onEdit: _showEditCoralDialog,
                                onDelete: _deleteCoral,
                                onTap: (coral) => showDialog(
                                  context: context,
                                  builder: (_) => CoralDetailsDialog(coral: coral),
                                ),
                                onClearFilters: () =>
                                    setState(() => _filter = _filter.clearAll()),
                              ),
                            ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _InhabitantsStatsCard extends StatefulWidget {
  final List<Fish> fishList;
  final List<Coral> coralsList;

  const _InhabitantsStatsCard({
    super.key,
    required this.fishList,
    required this.coralsList,
  });

  @override
  State<_InhabitantsStatsCard> createState() => _InhabitantsStatsCardState();
}

class _InhabitantsStatsCardState extends State<_InhabitantsStatsCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final totalFish = widget.fishList.length;
    final totalCorals = widget.coralsList.length;
    final avgFishSize = widget.fishList.isEmpty
        ? 0.0
        : widget.fishList.map((f) => f.size).reduce((a, b) => a + b) /
              widget.fishList.length;
    final totalBioLoad =
        widget.fishList.fold<double>(0, (sum, f) => sum + f.size) +
        (totalCorals * 2.0);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.chartLine, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                l10n.inhabitantsSummary,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: FontAwesomeIcons.fish,
                  label: l10n.fish,
                  value: totalFish.toDouble(),
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
              Expanded(
                child: _buildStatItem(
                  icon: FontAwesomeIcons.seedling,
                  label: l10n.corals,
                  value: totalCorals.toDouble(),
                ),
              ),
              Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3)),
              Expanded(
                child: _buildStatItem(
                  icon: FontAwesomeIcons.ruler,
                  label: l10n.averageSize,
                  value: avgFishSize,
                  suffix: avgFishSize > 0 ? ' cm' : '',
                  decimals: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const FaIcon(FontAwesomeIcons.scaleBalanced, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.totalBioLoad,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                AnimatedNumber(
                  key: const ValueKey('bioload'),
                  value: totalBioLoad,
                  decimals: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.bioLoadFormula,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          if (totalBioLoad > 0) ...[
            const SizedBox(height: 12),
            Text(
              _getBioLoadRecommendation(totalBioLoad, l10n),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required double value,
    String suffix = '',
    int decimals = 0,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        AnimatedNumber(
          key: ValueKey('stat_$label'),
          value: value,
          decimals: decimals,
          suffix: suffix,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
        ),
      ],
    );
  }

  String _getBioLoadRecommendation(double bioLoad, AppLocalizations l10n) {
    if (bioLoad < 20) return l10n.bioLoadOptimal;
    if (bioLoad < 35) return l10n.bioLoadModerate;
    return l10n.bioLoadHigh;
  }
}
