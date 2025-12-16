import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/models/aquarium.dart';
import 'package:acquariumfe/providers/aquarium_providers.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

class EditAquarium extends ConsumerStatefulWidget {
  const EditAquarium({super.key});

  @override
  ConsumerState<EditAquarium> createState() => _EditAquariumState();
}

class _EditAquariumState extends ConsumerState<EditAquarium>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _volumeController = TextEditingController();

  String _selectedType = 'marine';
  List<Aquarium> _aquariums = [];
  Aquarium? _selectedAquarium;
  bool _isEditing = false;
  bool _isLoading = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _loadAquariums();
    _animationController.forward();
  }

  Future<void> _loadAquariums() async {
    setState(() => _isLoading = true);

    final aquariumsAsync = ref.read(aquariumsProvider);

    aquariumsAsync.when(
      data: (aquariumsWithParams) {
        final aquariums = aquariumsWithParams.map((a) => a.aquarium).toList();
        setState(() {
          _aquariums = aquariums;
          _isLoading = false;
        });
      },
      loading: () {
        setState(() => _isLoading = true);
      },
      error: (error, stack) {
        setState(() => _isLoading = false);
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorLoading(error.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _volumeController.dispose();
    super.dispose();
  }

  void _selectAquarium(Aquarium aquarium) {
    final l10n = AppLocalizations.of(context)!;

    // Mappa inversa: dal tipo tradotto alla chiave
    final typeToKey = {
      l10n.marine: 'marine',
      l10n.freshwater: 'freshwater',
      l10n.reef: 'reef',
    };

    setState(() {
      _selectedAquarium = aquarium;
      _isEditing = true;
      _nameController.text = aquarium.name;
      _volumeController.text = aquarium.volume.toString();
      _selectedType = typeToKey[aquarium.type] ?? 'marine';
    });
    _animationController.reset();
    _animationController.forward();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate() && _selectedAquarium != null) {
      try {
        final l10n = AppLocalizations.of(context)!;

        // Mappa la chiave al valore tradotto
        final typeMap = {
          'marine': l10n.marine,
          'freshwater': l10n.freshwater,
          'reef': l10n.reef,
        };

        // Crea l'oggetto Aquarium aggiornato
        final updatedAquarium = _selectedAquarium!.copyWith(
          name: _nameController.text,
          volume: double.parse(_volumeController.text),
          type: typeMap[_selectedType] ?? l10n.marine,
        );

        // Chiama il provider per aggiornare la vasca
        await ref
            .read(aquariumsProvider.notifier)
            .updateAquarium(_selectedAquarium!.id!, updatedAquarium);

        // Ricarica la lista
        await _loadAquariums();

        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.circleCheck,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(l10n.changesSavedFor(_nameController.text)),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF60a5fa),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );

          setState(() {
            _isEditing = false;
            _selectedAquarium = null;
            _nameController.clear();
            _volumeController.clear();
          });
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.circleExclamation,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(l10n.errorSavingChanges(e.toString()))),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.editAquarium,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: _isEditing ? _buildEditForm() : _buildAquariumList(),
        ),
      ),
    );
  }

  Widget _buildAquariumList() {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_aquariums.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.droplet,
                size: 64,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(l10n.noAquariumsFound,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: FaIcon(
                  FontAwesomeIcons.pen,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.selectAquarium,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(AppLocalizations.of(context)!.chooseAquariumToEdit,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ..._aquariums.map((aquarium) => _buildAquariumCard(aquarium)),
      ],
    );
  }

  Widget _buildAquariumCard(Aquarium aquarium) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectAquarium(aquarium),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    aquarium.type == 'Marino'
                        ? FontAwesomeIcons.droplet
                        : FontAwesomeIcons.water,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(aquarium.name,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('${aquarium.volume} L  ${aquarium.type}',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditForm() {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: FaIcon(
                      FontAwesomeIcons.penToSquare,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.editDetails,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(l10n.updateAquarium(_selectedAquarium!.name),
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildLabel(l10n.aquariumName),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: _buildInputDecoration(
                l10n.aquariumNameHint,
                FontAwesomeIcons.textHeight,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? l10n.enterName : null,
            ),
            const SizedBox(height: 20),

            _buildLabel(l10n.aquariumType),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTypeButton('marine', FontAwesomeIcons.droplet),
                  ),
                  Expanded(
                    child: _buildTypeButton(
                      'freshwater',
                      FontAwesomeIcons.water,
                    ),
                  ),
                  Expanded(
                    child: _buildTypeButton('reef', FontAwesomeIcons.atom),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel(l10n.volumeLiters),
            const SizedBox(height: 8),
            TextFormField(
              controller: _volumeController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              keyboardType: TextInputType.number,
              decoration: _buildInputDecoration(
                l10n.volumeHint,
                FontAwesomeIcons.ruler,
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? l10n.enterVolume : null,
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                          _selectedAquarium = null;
                          _nameController.clear();
                          _volumeController.clear();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurfaceVariant,
                        side: BorderSide(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(l10n.cancel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(FontAwesomeIcons.floppyDisk, size: 24),
                          const SizedBox(width: 12),
                          Text(l10n.saveChanges,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    final theme = Theme.of(context);

    return Text(text,
      style: TextStyle(
        color: theme.colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    final theme = Theme.of(context);

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
      ),
      prefixIcon: Icon(icon, color: theme.colorScheme.primary, size: 20),
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFef4444)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildTypeButton(String type, IconData icon) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final typeMap = {
      'marine': l10n.marine,
      'freshwater': l10n.freshwater,
      'reef': l10n.reef,
    };

    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(typeMap[type] ?? '',
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
