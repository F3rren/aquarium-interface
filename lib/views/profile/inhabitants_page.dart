import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/fish.dart';
import '../../models/coral.dart';
import '../../models/inhabitants_filter.dart';
import '../../services/inhabitants_service.dart';
import '../../widgets/components/skeleton_loader.dart';
import '../../widgets/animated_number.dart';
import '../../widgets/inhabitants_filter_panel.dart';
import '../../providers/aquarium_providers.dart';
import 'add_fish_dialog.dart';
import 'add_coral_dialog.dart';
import 'coral_details_dialog.dart';
import 'fish_details_dialog.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

class InhabitantsPage extends ConsumerStatefulWidget {
  final int? aquariumId;

  const InhabitantsPage({super.key, this.aquariumId});

  @override
  ConsumerState<InhabitantsPage> createState() => _InhabitantsPageState();
}

class _InhabitantsPageState extends ConsumerState<InhabitantsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final InhabitantsService _service = InhabitantsService();

  List<Fish> _fishList = [];
  List<Coral> _coralsList = [];
  bool _isLoading = true;
  String? _aquariumWaterType;
  InhabitantsFilter _filter = InhabitantsFilter();

  @override
  void initState() {
    super.initState();
    // Inizia con 1 tab, verrà aggiornato dopo aver caricato i dati
    _tabController = TabController(length: 1, vsync: this);
    if (widget.aquariumId != null) {
      _service.setCurrentAquarium(widget.aquariumId!);
    }
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Recupera il waterType dell'acquario se disponibile
    String? previousWaterType = _aquariumWaterType;
    if (widget.aquariumId != null) {
      try {
        // Usa il provider invece del servizio diretto
        final aquariumsAsync = ref.read(aquariumsProvider);
        await aquariumsAsync.when(
          data: (aquariumsWithParams) {
            final aquarium = aquariumsWithParams
                .firstWhere((a) => a.aquarium.id == widget.aquariumId)
                .aquarium;
            _aquariumWaterType = aquarium.type;
          },
          loading: () {
            _aquariumWaterType = 'Marino'; // Default durante caricamento
          },
          error: (_, __) {
            _aquariumWaterType = 'Marino'; // Default in caso di errore
          },
        );
      } catch (e) {
        // Se fallisce, continua senza waterType (default marino)
        _aquariumWaterType = 'Marino';
      }
    } else {
      // Se non c'è aquariumId, default marino
      _aquariumWaterType = 'Marino';
    }

    // Ricrea TabController se il tipo d'acqua è cambiato o è la prima volta
    if (_aquariumWaterType != previousWaterType || previousWaterType == null) {
      final currentIndex = _tabController.index;
      _tabController.dispose();
      // Solo 1 tab (pesci) per acquari dolci, 2 tab (pesci + coralli) per marini/reef
      final isDolce = _aquariumWaterType?.toLowerCase() == 'dolce';
      _tabController = TabController(
        length: isDolce ? 1 : 2,
        vsync: this,
        initialIndex: isDolce ? 0 : (currentIndex < 2 ? currentIndex : 0),
      );
    }

    _fishList = await _service.getFish();
    _coralsList = await _service.getCorals();
    setState(() => _isLoading = false);
  }

  Future<void> _reloadDataSilently() async {
    final newFish = await _service.getFish();
    final newCorals = await _service.getCorals();
    setState(() {
      _fishList = newFish;
      _coralsList = newCorals;
    });
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
          backgroundColor: const Color(0xFF34d399),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  List<Fish> _getFilteredAndSortedFish() {
    List<Fish> filtered = _fishList;

    // Filtra per nome
    if (_filter.searchText.isNotEmpty) {
      filtered = filtered.where((fish) {
        final searchLower = _filter.searchText.toLowerCase();
        return fish.name.toLowerCase().contains(searchLower) ||
            fish.species.toLowerCase().contains(searchLower);
      }).toList();
    }

    // Filtra per difficoltà
    if (_filter.difficultyFilter != null) {
      filtered = filtered.where((fish) {
        return fish.difficulty == _filter.difficultyFilter;
      }).toList();
    }

    // Filtra per data
    if (_filter.dateFilter != null && _filter.dateValue != null) {
      filtered = filtered.where((fish) {
        if (_filter.dateFilter == DateFilterType.before) {
          return fish.addedDate.isBefore(_filter.dateValue!);
        } else {
          return fish.addedDate.isAfter(_filter.dateValue!);
        }
      }).toList();
    }

    // Ordina
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_filter.sortBy) {
        case SortType.name:
          comparison = a.name.compareTo(b.name);
          break;
        case SortType.dateAdded:
          comparison = a.addedDate.compareTo(b.addedDate);
          break;
        case SortType.size:
          comparison = a.size.compareTo(b.size);
          break;
        case SortType.difficulty:
          final difficultyOrder = {
            'Facile': 1,
            'Intermedio': 2,
            'Difficile': 3,
          };
          final aVal = difficultyOrder[a.difficulty] ?? 0;
          final bVal = difficultyOrder[b.difficulty] ?? 0;
          comparison = aVal.compareTo(bVal);
          break;
      }
      return _filter.sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  List<Coral> _getFilteredAndSortedCorals() {
    List<Coral> filtered = _coralsList;

    // Filtra per nome
    if (_filter.searchText.isNotEmpty) {
      filtered = filtered.where((coral) {
        final searchLower = _filter.searchText.toLowerCase();
        return coral.name.toLowerCase().contains(searchLower) ||
            coral.species.toLowerCase().contains(searchLower);
      }).toList();
    }

    // Filtra per difficoltà
    if (_filter.difficultyFilter != null) {
      filtered = filtered.where((coral) {
        return coral.difficulty == _filter.difficultyFilter;
      }).toList();
    }

    // Filtra per data
    if (_filter.dateFilter != null && _filter.dateValue != null) {
      filtered = filtered.where((coral) {
        if (_filter.dateFilter == DateFilterType.before) {
          return coral.addedDate.isBefore(_filter.dateValue!);
        } else {
          return coral.addedDate.isAfter(_filter.dateValue!);
        }
      }).toList();
    }

    // Ordina
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_filter.sortBy) {
        case SortType.name:
          comparison = a.name.compareTo(b.name);
          break;
        case SortType.dateAdded:
          comparison = a.addedDate.compareTo(b.addedDate);
          break;
        case SortType.size:
          comparison = a.size.compareTo(b.size);
          break;
        case SortType.difficulty:
          final difficultyOrder = {
            'Facile': 1,
            'Intermedio': 2,
            'Difficile': 3,
          };
          final aVal = difficultyOrder[a.difficulty] ?? 0;
          final bVal = difficultyOrder[b.difficulty] ?? 0;
          comparison = aVal.compareTo(bVal);
          break;
      }
      return _filter.sortAscending ? comparison : -comparison;
    });

    return filtered;
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
            onFilterChanged: (newFilter) {
              setState(() {
                _filter = newFilter;
              });
            },
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
          // Salva sul server
          await _service.addFish(fish, speciesId);

          // Ricarica i dati dall'API senza loading
          await _reloadDataSilently();
        },
        onSaveMultiple: (fishList, speciesId) async {
          for (final fish in fishList) {
            await _service.addFish(fish, speciesId);
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
          await _service.updateFish(updatedFish);
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
          // Salva sul server
          await _service.addCoral(coral, speciesId);

          // Ricarica i dati dall'API senza loading
          await _reloadDataSilently();
        },
        onSaveMultiple: (coralList, speciesId) async {
          for (final coral in coralList) {
            await _service.addCoral(coral, speciesId);
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
          await _service.updateCoral(updatedCoral);
          _loadData();
        },
      ),
    );
  }

  void _showCoralDetailsDialog(Coral coral) {
    showDialog(
      context: context,
      builder: (context) => CoralDetailsDialog(coral: coral),
    );
  }

  void _showFishDetailsDialog(Fish fish) {
    showDialog(
      context: context,
      builder: (context) => FishDetailsDialog(fish: fish),
    );
  }

  Future<void> _deleteFish(Fish fish) async {
    final theme = Theme.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Conferma eliminazione',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Text(
          'Vuoi eliminare "${fish.name}"?',
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Rimuovi localmente per attivare le animazioni
      setState(() {
        _fishList.removeWhere((f) => f.id == fish.id);
      });

      // Attendi un attimo per le animazioni
      await Future.delayed(const Duration(milliseconds: 100));

      // Elimina dal server
      await _service.deleteFish(fish.id);

      // Ricarica silenziosamente per sincronizzare
      _reloadDataSilently();
    }
  }

  Future<void> _deleteCoral(Coral coral) async {
    final theme = Theme.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Conferma eliminazione',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Text(
          'Vuoi eliminare "${coral.name}"?',
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Rimuovi localmente per attivare le animazioni
      setState(() {
        _coralsList.removeWhere((c) => c.id == coral.id);
      });

      // Attendi un attimo per le animazioni
      await Future.delayed(const Duration(milliseconds: 100));

      // Elimina dal server
      await _service.deleteCoral(coral.id);

      // Ricarica silenziosamente per sincronizzare
      _reloadDataSilently();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Determina il numero di tab in base al tipo d'acqua
    // Marino e Reef hanno 2 tab (pesci + coralli), Dolce ha solo 1 tab (pesci)
    final isDolce = (_aquariumWaterType ?? 'Marino').toLowerCase() == 'dolce';
    final tabCount = isDolce ? 1 : 2;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'I Miei Abitanti',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
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
                tooltip: 'Filtri e ricerca',
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
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
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
                    ? const [
                        Tab(text: 'Pesci', icon: FaIcon(FontAwesomeIcons.fish)),
                      ]
                    : const [
                        Tab(text: 'Pesci', icon: FaIcon(FontAwesomeIcons.fish)),
                        Tab(
                          text: 'Coralli',
                          icon: FaIcon(FontAwesomeIcons.seedling),
                        ),
                      ],
              )
            : null,
      ),
      body: _isLoading || _tabController.length != tabCount
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
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
                          ? [_buildFishTab(bottomPadding)]
                          : [
                              _buildFishTab(bottomPadding),
                              _buildCoralsTab(bottomPadding),
                            ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Se acquario dolce, mostra sempre dialog pesci (no coralli)
          final isDolce =
              (_aquariumWaterType ?? 'Marino').toLowerCase() == 'dolce';
          if (isDolce || _tabController.index == 0) {
            _showAddFishDialog();
          } else {
            _showAddCoralDialog();
          }
        },
        backgroundColor: theme.colorScheme.primary,
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }

  Widget _buildFishTab(double bottomPadding) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return ListView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + bottomPadding,
        ),
        children: List.generate(5, (index) => const ListItemSkeleton()),
      );
    }

    if (_fishList.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.fish,
                size: 64,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Nessun pesce aggiunto',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tocca + per aggiungere il tuo primo pesce',
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

    final filteredFish = _getFilteredAndSortedFish();

    if (filteredFish.isEmpty) {
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
                'Nessun risultato trovato',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Prova a modificare i filtri',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _filter = _filter.clearAll();
                  });
                },
                icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
                label: const Text('Cancella filtri'),
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

    return ListView.builder(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + bottomPadding,
      ),
      itemCount: filteredFish.length,
      itemBuilder: (context, index) {
        final fish = filteredFish[index];
        final theme = Theme.of(context);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _showFishDetailsDialog(fish),
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
                      if (value == 'edit') {
                        _showEditFishDialog(fish);
                      } else if (value == 'delete') {
                        _deleteFish(fish);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.pen,
                              color: const Color(0xFF60a5fa),
                              size: 16,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Modifica',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
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
                              'Elimina',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
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
      },
    );
  }

  Widget _buildCoralsTab(double bottomPadding) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return ListView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16 + bottomPadding,
        ),
        children: List.generate(5, (index) => const ListItemSkeleton()),
      );
    }

    if (_coralsList.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.seedling,
                size: 64,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Nessun corallo aggiunto',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tocca + per aggiungere il tuo primo corallo',
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

    final filteredCorals = _getFilteredAndSortedCorals();

    if (filteredCorals.isEmpty) {
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
                'Nessun risultato trovato',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Prova a modificare i filtri',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _filter = _filter.clearAll();
                  });
                },
                icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
                label: const Text('Cancella filtri'),
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

    return ListView.builder(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + bottomPadding,
      ),
      itemCount: filteredCorals.length,
      itemBuilder: (context, index) {
        final coral = filteredCorals[index];
        final theme = Theme.of(context);

        Color typeColor;
        switch (coral.type) {
          case 'SPS':
            typeColor = Colors.pink;
            break;
          case 'LPS':
            typeColor = theme.colorScheme.primary;
            break;
          default:
            typeColor = theme.colorScheme.secondary;
        }

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _showCoralDetailsDialog(coral),
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
                      if (value == 'edit') {
                        _showEditCoralDialog(coral);
                      } else if (value == 'delete') {
                        _deleteCoral(coral);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.pen,
                              color: const Color(0xFF60a5fa),
                              size: 16,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Modifica',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
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
                              'Elimina',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
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
      },
    );
  }
}

// Widget separato per le statistiche per permettere le animazioni
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

    // Calcolo statistiche
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
              const FaIcon(
                FontAwesomeIcons.chartLine,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Riepilogo Abitanti',
                style: TextStyle(
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
                  label: 'Pesci',
                  value: totalFish.toDouble(),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: FontAwesomeIcons.seedling,
                  label: 'Coralli',
                  value: totalCorals.toDouble(),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: FontAwesomeIcons.ruler,
                  label: 'Dim. media',
                  value: avgFishSize,
                  suffix: avgFishSize > 0 ? ' cm' : '',
                  showZero: false,
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
                    const FaIcon(
                      FontAwesomeIcons.scaleBalanced,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Carico Biotico Totale',
                      style: TextStyle(
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
                  style: TextStyle(
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
            'Formula: (Σ dimensioni pesci) + (n° coralli × 2)',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          if (totalBioLoad > 0) ...[
            const SizedBox(height: 12),
            Text(
              _getBioLoadRecommendation(totalBioLoad, totalFish, totalCorals),
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
    bool showZero = true,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        AnimatedNumber(
          key: ValueKey('stat_$label'),
          value: value,
          decimals: label == 'Dim. media' ? 1 : 0,
          suffix: suffix,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _getBioLoadRecommendation(double bioLoad, int fish, int corals) {
    if (bioLoad < 20) {
      return 'Carico biotico ottimale - acquario ben bilanciato';
    } else if (bioLoad < 35) {
      return 'Carico biotico moderato - monitora i parametri dell\'acqua';
    } else {
      return 'Carico biotico elevato - considera un acquario più grande o riduci gli abitanti';
    }
  }
}
