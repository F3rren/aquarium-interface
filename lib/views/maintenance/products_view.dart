import 'package:acquariumfe/models/product.dart';
import 'package:acquariumfe/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/utils/responsive_breakpoints.dart';

class ProductsView extends StatefulWidget {
  final int? aquariumId;

  const ProductsView({super.key, this.aquariumId});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final ProductService _service = ProductService();
  List<Product> _products = [];
  ProductCategory? _filterCategory;
  bool _showFavoritesOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.aquariumId != null) {
      _service.setCurrentAquarium(widget.aquariumId!);
      _loadProducts();
    }
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _service.getAllProducts();
      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore nel caricamento: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Product> get _filteredProducts {
    var filtered = _products;

    if (_filterCategory != null) {
      filtered = filtered.where((p) => p.category == _filterCategory).toList();
    }

    if (_showFavoritesOnly) {
      filtered = filtered.where((p) => p.isFavorite).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = ResponsiveBreakpoints.horizontalPadding(screenWidth);

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProducts,
              child: Column(
                children: [
                  // Header con statistiche
                  _buildHeaderStats(theme, padding),

                  // Filtri
                  _buildFilters(theme, padding),

                  // Lista prodotti
                  Expanded(
                    child: _filteredProducts.isEmpty
                        ? _buildEmptyState(theme)
                        : _buildProductsList(theme, padding),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductDialog(),
        icon: const FaIcon(FontAwesomeIcons.plus, size: 18),
        label: const Text('Aggiungi Prodotto'),
      ),
    );
  }

  Widget _buildHeaderStats(ThemeData theme, double padding) {
    final stats = _calculateStats();

    return Container(
      margin: EdgeInsets.all(padding),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            theme,
            FontAwesomeIcons.boxesStacked,
            '${stats['total']}',
            'Prodotti',
          ),
          _buildStatItem(
            theme,
            FontAwesomeIcons.euroSign,
            '${stats['totalCost'].toStringAsFixed(2)}',
            'Totale',
          ),
          _buildStatItem(
            theme,
            FontAwesomeIcons.triangleExclamation,
            '${stats['alerts']}',
            'Avvisi',
            color: stats['alerts'] > 0 ? Colors.orange : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    ThemeData theme,
    IconData icon,
    String value,
    String label, {
    Color? color,
  }) {
    return Column(
      children: [
        FaIcon(icon, size: 24, color: color ?? theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }

  Widget _buildFilters(ThemeData theme, double padding) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        children: [
          // Filtro categorie
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryChip(theme, null, 'Tutte'),
                ...ProductCategory.values.map(
                  (cat) =>
                      _buildCategoryChip(theme, cat, _getCategoryName(cat)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Filtro preferiti
          Row(
            children: [
              FilterChip(
                label: const Text('Solo Preferiti'),
                selected: _showFavoritesOnly,
                onSelected: (selected) {
                  setState(() => _showFavoritesOnly = selected);
                },
                avatar: FaIcon(
                  _showFavoritesOnly
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    ThemeData theme,
    ProductCategory? category,
    String label,
  ) {
    final isSelected = _filterCategory == category;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _filterCategory = selected ? category : null;
          });
        },
        avatar: category != null
            ? FaIcon(_getCategoryIcon(category), size: 16)
            : null,
      ),
    );
  }

  Widget _buildProductsList(ThemeData theme, double padding) {
    return ListView.builder(
      padding: EdgeInsets.all(padding),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return _buildProductCard(theme, product);
      },
    );
  }

  Widget _buildProductCard(ThemeData theme, Product product) {
    final hasWarning =
        product.isExpired ||
        product.isExpiringSoon ||
        product.isLowStock ||
        product.shouldUseAgain;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showProductDetails(product),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Icona categoria
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      _getCategoryIcon(product.category),
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nome e brand
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (product.isFavorite)
                              const FaIcon(
                                FontAwesomeIcons.solidHeart,
                                size: 16,
                                color: Colors.red,
                              ),
                          ],
                        ),
                        if (product.brand != null)
                          Text(
                            product.brand!,
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  // Menu azioni
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () => _toggleFavorite(product),
                        child: Row(
                          children: [
                            FaIcon(
                              product.isFavorite
                                  ? FontAwesomeIcons.heart
                                  : FontAwesomeIcons.solidHeart,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              product.isFavorite
                                  ? 'Rimuovi preferito'
                                  : 'Aggiungi a preferiti',
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => Future.delayed(
                          Duration.zero,
                          () => _editProduct(product),
                        ),
                        child: const Row(
                          children: [
                            FaIcon(FontAwesomeIcons.penToSquare, size: 16),
                            SizedBox(width: 8),
                            Text('Modifica'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => Future.delayed(
                          Duration.zero,
                          () => _recordUsage(product),
                        ),
                        child: const Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.handHoldingDroplet,
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text('Registra utilizzo'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () => Future.delayed(
                          Duration.zero,
                          () => _deleteProduct(product),
                        ),
                        child: const Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.trash,
                              size: 16,
                              color: Colors.red,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Elimina',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Info prodotto
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  if (product.quantity != null)
                    _buildInfoChip(
                      theme,
                      FontAwesomeIcons.boxOpen,
                      '${product.quantity} ${product.unit ?? ''}',
                      isWarning: product.isLowStock,
                    ),
                  if (product.cost != null)
                    _buildInfoChip(
                      theme,
                      FontAwesomeIcons.euroSign,
                      '${product.cost} ${product.currency}',
                    ),
                  if (product.expiryDate != null)
                    _buildInfoChip(
                      theme,
                      FontAwesomeIcons.calendar,
                      _formatDate(product.expiryDate!),
                      isWarning: product.isExpiringSoon,
                      isDanger: product.isExpired,
                    ),
                  if (product.lastUsed != null)
                    _buildInfoChip(
                      theme,
                      FontAwesomeIcons.clock,
                      'Usato ${product.daysSinceLastUse} gg fa',
                      isWarning: product.shouldUseAgain,
                    ),
                ],
              ),
              // Avvisi
              if (hasWarning) ...[
                const SizedBox(height: 12),
                _buildWarnings(theme, product),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    ThemeData theme,
    IconData icon,
    String label, {
    bool isWarning = false,
    bool isDanger = false,
  }) {
    Color? color;
    if (isDanger) {
      color = Colors.red;
    } else if (isWarning) {
      color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? theme.colorScheme.primary).withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: (color ?? theme.colorScheme.primary).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 12, color: color ?? theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: color)),
        ],
      ),
    );
  }

  Widget _buildWarnings(ThemeData theme, Product product) {
    final warnings = <String>[];

    if (product.isExpired) {
      warnings.add('⚠️ SCADUTO!');
    } else if (product.isExpiringSoon) {
      warnings.add('⚠️ In scadenza');
    }

    if (product.isLowStock) {
      warnings.add('📦 Scorte basse');
    }

    if (product.shouldUseAgain) {
      warnings.add('🔔 Da utilizzare');
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Text(
        warnings.join(' • '),
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.orange.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.boxOpen,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text('Nessun prodotto trovato', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Aggiungi il tuo primo prodotto\nper iniziare a gestire l\'inventario',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateStats() {
    double totalCost = 0;
    int alerts = 0;

    for (var product in _products) {
      if (product.cost != null) {
        totalCost += product.cost!;
      }

      if (product.isExpired ||
          product.isExpiringSoon ||
          product.isLowStock ||
          product.shouldUseAgain) {
        alerts++;
      }
    }

    return {
      'total': _products.length,
      'totalCost': totalCost,
      'alerts': alerts,
    };
  }

  String _getCategoryName(ProductCategory category) {
    switch (category) {
      case ProductCategory.bacteria:
        return 'Batteri';
      case ProductCategory.food:
        return 'Cibo';
      case ProductCategory.test:
        return 'Test';
      case ProductCategory.supplement:
        return 'Integratori';
      case ProductCategory.waterTreatment:
        return 'Trattamento';
      case ProductCategory.equipment:
        return 'Attrezzatura';
      case ProductCategory.medicine:
        return 'Medicinali';
      case ProductCategory.other:
        return 'Altro';
    }
  }

  IconData _getCategoryIcon(ProductCategory category) {
    switch (category) {
      case ProductCategory.bacteria:
        return FontAwesomeIcons.bacteria;
      case ProductCategory.food:
        return FontAwesomeIcons.fishFins;
      case ProductCategory.test:
        return FontAwesomeIcons.vial;
      case ProductCategory.supplement:
        return FontAwesomeIcons.pills;
      case ProductCategory.waterTreatment:
        return FontAwesomeIcons.droplet;
      case ProductCategory.equipment:
        return FontAwesomeIcons.screwdriverWrench;
      case ProductCategory.medicine:
        return FontAwesomeIcons.kitMedical;
      case ProductCategory.other:
        return FontAwesomeIcons.boxesStacked;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;

    if (diff < 0) {
      return 'Scaduto';
    } else if (diff == 0) {
      return 'Scade oggi';
    } else if (diff <= 30) {
      return 'Scade tra $diff gg';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // Dialoghi e azioni
  void _showProductDetails(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (product.brand != null) ...[
                const Text(
                  'Brand:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(product.brand!),
                const SizedBox(height: 8),
              ],
              const Text(
                'Categoria:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(_getCategoryName(product.category)),
              if (product.notes != null) ...[
                const SizedBox(height: 8),
                const Text(
                  'Note:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(product.notes!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    // TODO: Implementare dialog completo per aggiunta prodotto
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductView(
          aquariumId: widget.aquariumId!,
          onSaved: _loadProducts,
        ),
      ),
    );
  }

  void _editProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditProductView(
          aquariumId: widget.aquariumId!,
          product: product,
          onSaved: _loadProducts,
        ),
      ),
    );
  }

  void _deleteProduct(Product product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Conferma eliminazione'),
        content: Text('Vuoi eliminare "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Elimina', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _service.deleteProduct(product.id);
      _loadProducts();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Prodotto eliminato')));
      }
    }
  }

  void _toggleFavorite(Product product) async {
    await _service.toggleFavorite(product.id);
    _loadProducts();
  }

  void _recordUsage(Product product) {
    // Dialog per registrare utilizzo con quantità
    showDialog(
      context: context,
      builder: (context) {
        double? quantity;
        return AlertDialog(
          title: const Text('Registra utilizzo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Prodotto: ${product.name}'),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Quantità utilizzata (${product.unit ?? 'unità'})',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  quantity = double.tryParse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () async {
                await _service.recordUsage(product.id, quantityUsed: quantity);
                if (context.mounted) Navigator.pop(context);
                _loadProducts();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Utilizzo registrato')),
                  );
                }
              },
              child: const Text('Registra'),
            ),
          ],
        );
      },
    );
  }
}

// Form per aggiungere/modificare prodotto
class AddEditProductView extends StatefulWidget {
  final int aquariumId;
  final Product? product;
  final VoidCallback onSaved;

  const AddEditProductView({
    super.key,
    required this.aquariumId,
    this.product,
    required this.onSaved,
  });

  @override
  State<AddEditProductView> createState() => _AddEditProductViewState();
}

class _AddEditProductViewState extends State<AddEditProductView> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProductService();

  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _quantityController;
  late TextEditingController _unitController;
  late TextEditingController _costController;
  late TextEditingController _notesController;
  late TextEditingController _usageFrequencyController;

  ProductCategory _selectedCategory = ProductCategory.other;
  DateTime? _purchaseDate;
  DateTime? _expiryDate;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _service.setCurrentAquarium(widget.aquariumId);

    final product = widget.product;
    _nameController = TextEditingController(text: product?.name);
    _brandController = TextEditingController(text: product?.brand);
    _quantityController = TextEditingController(
      text: product?.quantity?.toString(),
    );
    _unitController = TextEditingController(text: product?.unit);
    _costController = TextEditingController(text: product?.cost?.toString());
    _notesController = TextEditingController(text: product?.notes);
    _usageFrequencyController = TextEditingController(
      text: product?.usageFrequency?.toString(),
    );

    if (product != null) {
      _selectedCategory = product.category;
      _purchaseDate = product.purchaseDate;
      _expiryDate = product.expiryDate;
      _isFavorite = product.isFavorite;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _costController.dispose();
    _notesController.dispose();
    _usageFrequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEdit = widget.product != null;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Modifica Prodotto' : 'Nuovo Prodotto'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
            children: [
              // Nome
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome prodotto *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Inserisci il nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Categoria
              DropdownButtonFormField<ProductCategory>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: ProductCategory.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(_getCategoryName(cat)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Brand
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
              ),
              const SizedBox(height: 16),

              // Quantità e Unità
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantità',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.inventory),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unità',
                        border: OutlineInputBorder(),
                        hintText: 'ml, g, pz',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Costo
              TextFormField(
                controller: _costController,
                decoration: const InputDecoration(
                  labelText: 'Costo (€)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.euro),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Date
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _purchaseDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() => _purchaseDate = date);
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _purchaseDate != null
                            ? 'Acquisto: ${_purchaseDate!.day}/${_purchaseDate!.month}/${_purchaseDate!.year}'
                            : 'Data acquisto',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _expiryDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          setState(() => _expiryDate = date);
                        }
                      },
                      icon: const Icon(Icons.event_busy),
                      label: Text(
                        _expiryDate != null
                            ? 'Scadenza: ${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'
                            : 'Data scadenza',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Frequenza utilizzo
              TextFormField(
                controller: _usageFrequencyController,
                decoration: const InputDecoration(
                  labelText: 'Frequenza utilizzo (giorni)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.repeat),
                  helperText: 'Es: 7 per uso settimanale',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Note
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Note',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Preferito
              SwitchListTile(
                title: const Text('Aggiungi ai preferiti'),
                value: _isFavorite,
                onChanged: (value) {
                  setState(() => _isFavorite = value);
                },
                secondary: FaIcon(
                  _isFavorite
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  color: _isFavorite ? Colors.red : null,
                ),
              ),
              const SizedBox(height: 24),

              // Bottone salva
              ElevatedButton.icon(
                onPressed: _saveProduct,
                icon: const Icon(Icons.save),
                label: Text(isEdit ? 'Salva Modifiche' : 'Aggiungi Prodotto'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final product = Product(
      id:
          widget.product?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      category: _selectedCategory,
      brand: _brandController.text.isEmpty ? null : _brandController.text,
      quantity: _quantityController.text.isEmpty
          ? null
          : double.parse(_quantityController.text),
      unit: _unitController.text.isEmpty ? null : _unitController.text,
      cost: _costController.text.isEmpty
          ? null
          : double.parse(_costController.text),
      purchaseDate: _purchaseDate,
      expiryDate: _expiryDate,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      isFavorite: _isFavorite,
      usageFrequency: _usageFrequencyController.text.isEmpty
          ? null
          : int.parse(_usageFrequencyController.text),
      lastUsed: widget.product?.lastUsed,
    );

    try {
      if (widget.product == null) {
        await _service.addProduct(product);
      } else {
        await _service.updateProduct(product);
      }

      widget.onSaved();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.product == null
                  ? 'Prodotto aggiunto'
                  : 'Prodotto modificato',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  String _getCategoryName(ProductCategory category) {
    switch (category) {
      case ProductCategory.bacteria:
        return 'Batteri';
      case ProductCategory.food:
        return 'Cibo';
      case ProductCategory.test:
        return 'Test';
      case ProductCategory.supplement:
        return 'Integratori';
      case ProductCategory.waterTreatment:
        return 'Trattamento Acqua';
      case ProductCategory.equipment:
        return 'Attrezzatura';
      case ProductCategory.medicine:
        return 'Medicinali';
      case ProductCategory.other:
        return 'Altro';
    }
  }
}
