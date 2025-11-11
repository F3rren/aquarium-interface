import 'package:flutter/material.dart';
import '../../models/fish.dart';
import '../../models/coral.dart';
import '../../services/inhabitants_service.dart';
import 'add_fish_dialog.dart';
import 'add_coral_dialog.dart';

class InhabitantsPage extends StatefulWidget {
  const InhabitantsPage({super.key});

  @override
  State<InhabitantsPage> createState() => _InhabitantsPageState();
}

class _InhabitantsPageState extends State<InhabitantsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final InhabitantsService _service = InhabitantsService();
  
  List<Fish> _fishList = [];
  List<Coral> _coralsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _fishList = await _service.getFish();
    _coralsList = await _service.getCorals();
    setState(() => _isLoading = false);
  }

  void _showAddFishDialog() {
    showDialog(
      context: context,
      builder: (context) => AddFishDialog(
        onSave: (fish) async {
          await _service.addFish(fish);
          _loadData();
        },
        onSaveMultiple: (fishList) async {
          await _service.addMultipleFish(fishList);
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
        onSave: (updatedFish) async {
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
        onSave: (coral) async {
          await _service.addCoral(coral);
          _loadData();
        },
        onSaveMultiple: (coralList) async {
          await _service.addMultipleCorals(coralList);
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
        onSave: (updatedCoral) async {
          await _service.updateCoral(updatedCoral);
          _loadData();
        },
      ),
    );
  }

  Future<void> _deleteFish(Fish fish) async {
    final theme = Theme.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('Conferma eliminazione', style: TextStyle(color: theme.colorScheme.onSurface)),
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
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _service.deleteFish(fish.id);
      _loadData();
    }
  }

  Future<void> _deleteCoral(Coral coral) async {
    final theme = Theme.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('Conferma eliminazione', style: TextStyle(color: theme.colorScheme.onSurface)),
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
            style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _service.deleteCoral(coral.id);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('I Miei Abitanti', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(text: 'Pesci', icon: Icon(Icons.pets)),
            Tab(text: 'Coralli', icon: Icon(Icons.spa)),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: theme.colorScheme.primary))
          : Column(
              children: [
                _buildStatsCard(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFishTab(),
                      _buildCoralsTab(),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            _showAddFishDialog();
          } else {
            _showAddCoralDialog();
          }
        },
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsCard() {
    final theme = Theme.of(context);
    
    // Calcolo statistiche
    final totalFish = _fishList.length;
    final totalCorals = _coralsList.length;
    final avgFishSize = _fishList.isEmpty 
        ? 0.0 
        : _fishList.map((f) => f.size).reduce((a, b) => a + b) / _fishList.length;
    final totalBioLoad = _fishList.fold<double>(0, (sum, f) => sum + f.size) + (totalCorals * 2.0);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
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
              const Icon(Icons.analytics, color: Colors.white, size: 24),
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
                  icon: Icons.pets,
                  label: 'Pesci',
                  value: totalFish.toString(),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.spa,
                  label: 'Coralli',
                  value: totalCorals.toString(),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.straighten,
                  label: 'Dim. media',
                  value: avgFishSize > 0 ? '${avgFishSize.toStringAsFixed(1)} cm' : '-',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.scale, color: Colors.white, size: 20),
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
                Text(
                  totalBioLoad.toStringAsFixed(1),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
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

  String _getBioLoadRecommendation(double bioLoad, int fishCount, int coralCount) {
    if (fishCount == 0 && coralCount == 0) {
      return 'Aggiungi i tuoi primi abitanti!';
    }
    
    // Raccomandazioni generiche basate sul carico totale
    if (bioLoad < 20) {
      return 'Vasca poco popolata - Puoi aggiungere altri abitanti';
    } else if (bioLoad < 50) {
      return 'Popolazione equilibrata - Buona base per la vasca';
    } else if (bioLoad < 100) {
      return 'Vasca ben popolata - Monitora regolarmente i parametri';
    } else if (bioLoad < 150) {
      return 'Carico elevato - Assicurati di avere filtrazione adeguata';
    } else {
      return 'Carico molto alto - Cambio acqua frequente essenziale';
    }
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
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

  Widget _buildFishTab() {
    final theme = Theme.of(context);
    
    if (_fishList.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pets, size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                'Nessun pesce aggiunto',
                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Tocca + per aggiungere il tuo primo pesce',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _fishList.length,
      itemBuilder: (context, index) {
        final fish = _fishList[index];
        final daysInTank = DateTime.now().difference(fish.addedDate).inDays;
        final theme = Theme.of(context);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => _showEditFishDialog(fish),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.pets, color: theme.colorScheme.primary, size: 32),
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
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.straighten, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                            const SizedBox(width: 4),
                            Text(
                              '${fish.size.toStringAsFixed(1)} cm',
                              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.calendar_today, size: 14, color: Colors.white.withValues(alpha: 0.5)),
                            const SizedBox(width: 4),
                            Text(
                              '$daysInTank giorni in vasca',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _deleteFish(fish),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCoralsTab() {
    final theme = Theme.of(context);
    
    if (_coralsList.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.spa, size: 64, color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                'Nessun corallo aggiunto',
                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Tocca + per aggiungere il tuo primo corallo',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _coralsList.length,
      itemBuilder: (context, index) {
        final coral = _coralsList[index];
        final daysInTank = DateTime.now().difference(coral.addedDate).inDays;
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => _showEditCoralDialog(coral),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.spa, color: typeColor, size: 32),
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: typeColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                coral.type,
                                style: TextStyle(color: typeColor, fontSize: 11, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          coral.species,
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                            const SizedBox(width: 4),
                            Text(
                              coral.placement,
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.calendar_today, size: 14, color: Colors.white.withValues(alpha: 0.5)),
                            const SizedBox(width: 4),
                            Text(
                              '$daysInTank giorni in vasca',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _deleteCoral(coral),
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
