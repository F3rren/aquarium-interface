import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../models/coral.dart';
import '../../models/coral_species.dart';
import '../../services/coral_database_service.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

class AddCoralDialog extends StatefulWidget {
  final Coral? coral;
  final Function(Coral, String? speciesId) onSave;
  final Function(List<Coral>, String? speciesId)? onSaveMultiple;

  const AddCoralDialog({
    super.key,
    this.coral,
    required this.onSave,
    this.onSaveMultiple,
  });

  @override
  State<AddCoralDialog> createState() => _AddCoralDialogState();
}

class _AddCoralDialogState extends State<AddCoralDialog> {
  final _coralDatabaseService = CoralDatabaseService();
  List<CoralSpecies> _coralDatabase = [];
  CoralSpecies? _selectedCoralSpecies;

  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _sizeController;
  late TextEditingController _notesController;
  late TextEditingController _quantityController;

  String _selectedType = 'LPS';
  String _selectedPlacement = 'Medio';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.coral?.name ?? '');
    _speciesController = TextEditingController(
      text: widget.coral?.species ?? '',
    );
    _sizeController = TextEditingController(
      text: widget.coral?.size.toString() ?? '',
    );
    _notesController = TextEditingController(text: widget.coral?.notes ?? '');
    _quantityController = TextEditingController(
      text: widget.coral == null ? '1' : '1',
    );

    if (widget.coral != null) {
      _selectedType = widget.coral!.type;
      _selectedPlacement = _mapPlacementToItalian(widget.coral!.placement);
    }

    _loadCoralDatabase();
  }

  Future<void> _loadCoralDatabase() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final corals = await _coralDatabaseService.getAllCorals();
      setState(() {
        _coralDatabase = corals;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.databaseLoadError(e.toString()))),
        );
      }
    }
  }

  void _onCoralSpeciesSelected(CoralSpecies? species) {
    if (species == null) return;

    setState(() {
      _selectedCoralSpecies = species;
      _nameController.text = species.commonName;
      _speciesController.text = species.scientificName;
      _selectedType = _mapTypeToItalian(species.type);
      _selectedPlacement = _mapPlacementToItalian(species.placement);
      _sizeController.text = species.maxSize.toString();
      _notesController.text = species.description;
    });
  }

  String _mapTypeToItalian(String type) {
    switch (type.toLowerCase()) {
      case 'sps':
        return 'SPS';
      case 'lps':
        return 'LPS';
      case 'soft':
      case 'zoa':
        return 'Molle';
      default:
        return 'LPS';
    }
  }

  String _mapPlacementToItalian(String placement) {
    switch (placement.toLowerCase()) {
      case 'top':
        return 'Alto';
      case 'middle':
        return 'Medio';
      case 'bottom':
        return 'Basso';
      default:
        return 'Medio';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _sizeController.dispose();
    _notesController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _save() {
    final l10n = AppLocalizations.of(context)!;
    if (_nameController.text.isEmpty ||
        _speciesController.text.isEmpty ||
        _sizeController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.fillAllRequiredFields)));
      return;
    }

    final size = double.tryParse(_sizeController.text);
    if (size == null || size <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.invalidSize)));
      return;
    }

    final quantity = int.tryParse(_quantityController.text) ?? 1;
    if (quantity <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.invalidQuantity)));
      return;
    }

    // Se è modifica, ignora quantità
    if (widget.coral != null) {
      final coral = Coral(
        id: widget.coral!.id,
        name: _nameController.text,
        species: _speciesController.text,
        type: _selectedType,
        size: size,
        addedDate: widget.coral!.addedDate,
        placement: _selectedPlacement,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      widget.onSave(coral, _selectedCoralSpecies?.id);
      Navigator.pop(context);
      return;
    }

    // Se quantità = 1, usa il callback singolo
    if (quantity == 1) {
      final coral = Coral(
        id: const Uuid().v4(),
        name: _nameController.text,
        species: _speciesController.text,
        type: _selectedType,
        size: size,
        addedDate: DateTime.now(),
        placement: _selectedPlacement,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      widget.onSave(coral, _selectedCoralSpecies?.id);
    } else {
      // Se quantità > 1, crea lista con nomi numerati
      final coralList = List.generate(quantity, (index) {
        final coralNumber = index + 1;
        return Coral(
          id: const Uuid().v4(),
          name: quantity > 1
              ? '${_nameController.text} #$coralNumber'
              : _nameController.text,
          species: _speciesController.text,
          type: _selectedType,
          size: size,
          addedDate: DateTime.now(),
          placement: _selectedPlacement,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
      });

      if (widget.onSaveMultiple != null) {
        widget.onSaveMultiple!(coralList, _selectedCoralSpecies?.id);
      } else {
        // Fallback: salva uno alla volta
        for (final coral in coralList) {
          widget.onSave(coral, _selectedCoralSpecies?.id);
        }
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final heroTag = widget.coral != null
        ? 'coral_${widget.coral!.id}'
        : 'coral_new';

    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Hero(
                    tag: heroTag,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34d399).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.seedling,
                          color: Color(0xFF34d399),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text( widget.coral == null
                        ? 'Aggiungi Corallo'
                        : 'Modifica Corallo',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Dropdown database coralli
              if (widget.coral == null) ...[
                _buildCoralDatabaseDropdown(theme),
                const SizedBox(height: 16),
                Center(
                  child: Text(l10n.orEnterManually,
                    style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              _buildTextField(
                controller: _nameController,
                label: 'Nome *',
                hint: 'es: Montipora arancione',
                icon: FontAwesomeIcons.tag,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _speciesController,
                label: 'Specie *',
                hint: 'es: Montipora digitata',
                icon: FontAwesomeIcons.circleInfo,
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: 'Tipo *',
                value: _selectedType,
                items: ['SPS', 'LPS', 'Molle'],
                icon: FontAwesomeIcons.tag,
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _sizeController,
                label: 'Dimensione (cm) *',
                hint: 'es: 5.0',
                icon: FontAwesomeIcons.ruler,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: 'Posizionamento *',
                value: _selectedPlacement,
                items: ['Alto', 'Medio', 'Basso'],
                icon: FontAwesomeIcons.locationDot,
                onChanged: (value) =>
                    setState(() => _selectedPlacement = value!),
              ),
              const SizedBox(height: 16),

              if (widget.coral == null) ...[
                _buildTextField(
                  controller: _quantityController,
                  label: 'Quantità',
                  hint: 'Numero di esemplari da aggiungere',
                  icon: FontAwesomeIcons.circlePlus,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                Text(l10n.multipleSpecimensNote,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              _buildTextField(
                controller: _notesController,
                label: 'Note',
                hint: 'Aggiungi note opzionali',
                icon: FontAwesomeIcons.noteSticky,
                maxLines: 3,
              ),

              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel,
                      style: TextStyle(color: Colors.white60),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF34d399),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(l10n.save,
                      style: TextStyle(fontWeight: FontWeight.w600),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF34d399)),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF34d399)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2d2d2d),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: DropdownButtonFormField<String>(
            initialValue: value,
            dropdownColor: const Color(0xFF3a3a3a),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: const Color(0xFF34d399)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: TextStyle(color: Colors.white, fontSize: 15),
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildCoralDatabaseDropdown(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF34d399).withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CoralSpecies>(
          isExpanded: true,
          hint: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: const Color(0xFF34d399),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(l10n.selectFromList,
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          value: _selectedCoralSpecies,
          dropdownColor: theme.colorScheme.surface,
          icon: FaIcon(
            FontAwesomeIcons.caretDown,
            color: const Color(0xFF34d399),
          ),
          items: _coralDatabase.map((coral) {
            // Funzione helper per ottenere il colore della difficoltà
            Color getDifficultyColor(String difficulty) {
              switch (difficulty.toLowerCase()) {
                case 'facile':
                  return const Color(0xFF34d399);
                case 'medio':
                  return const Color(0xFFfbbf24);
                case 'difficile':
                  return const Color(0xFFef4444);
                default:
                  return const Color.fromARGB(255, 0, 0, 0);
              }
            }

            return DropdownMenuItem<CoralSpecies>(
              value: coral,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(coral.commonName,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(coral.scientificName,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Badge difficoltà
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: getDifficultyColor(coral.difficulty),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(coral.difficultyLabel[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: _onCoralSpeciesSelected,
        ),
      ),
    );
  }
}
