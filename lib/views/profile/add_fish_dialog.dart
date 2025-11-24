import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../models/fish.dart';
import '../../models/fish_species.dart';
import '../../services/fish_database_service.dart';

class AddFishDialog extends StatefulWidget {
  final Fish? fish;
  final Function(Fish, String? speciesId) onSave;
  final Function(List<Fish>, String? speciesId)? onSaveMultiple;
  final String? aquariumWaterType;

  const AddFishDialog({
    super.key,
    this.fish,
    required this.onSave,
    this.onSaveMultiple,
    this.aquariumWaterType,
  });

  @override
  State<AddFishDialog> createState() => _AddFishDialogState();
}

class _AddFishDialogState extends State<AddFishDialog> {
  late TextEditingController _nameController;
  late TextEditingController _speciesController;
  late TextEditingController _sizeController;
  late TextEditingController _notesController;
  late TextEditingController _quantityController;
  
  final _fishDbService = FishDatabaseService();
  List<FishSpecies> _availableFish = [];
  FishSpecies? _selectedFishSpecies;
  bool _isLoadingDatabase = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fish?.name ?? '');
    _speciesController = TextEditingController(text: widget.fish?.species ?? '');
    _sizeController = TextEditingController(text: widget.fish?.size.toString() ?? '');
    _notesController = TextEditingController(text: widget.fish?.notes ?? '');
    _quantityController = TextEditingController(text: widget.fish == null ? '1' : '1');
    
    _loadFishDatabase();
  }
  
  Future<void> _loadFishDatabase() async {
    try {
      List<FishSpecies> fish;
      
      // Se è specificato il tipo d'acqua dell'acquario, filtra i pesci compatibili
      if (widget.aquariumWaterType != null && widget.aquariumWaterType!.isNotEmpty) {
        fish = await _fishDbService.getFishByWaterType(widget.aquariumWaterType!);
      } else {
        fish = await _fishDbService.getAllFish();
      }
      
      setState(() {
        _availableFish = fish;
        _isLoadingDatabase = false;
      });
    } catch (e) {
      setState(() => _isLoadingDatabase = false);
    }
  }
  
  void _onFishSpeciesSelected(FishSpecies? species) {
    if (species == null) return;
    
    setState(() {
      _selectedFishSpecies = species;
      _nameController.text = species.commonName;
      _speciesController.text = species.scientificName;
      _sizeController.text = species.maxSize.toString();
      
      // Aggiungi info utili nelle note
      final info = StringBuffer();
      info.writeln('Difficoltà: ${_getDifficultyLabel(species.difficulty)}');
      info.writeln('Vasca minima: ${species.minTankSize}L');
      info.writeln('Temperamento: ${_getTemperamentLabel(species.temperament)}');
      info.writeln('Dieta: ${_getDietLabel(species.diet)}');
      info.writeln('Reef-safe: ${species.reefSafe ? "Sì" : "No"}');
      if (species.description != null) {
        info.writeln('\n${species.description}');
      }
      
      _notesController.text = info.toString();
    });
  }
  
  String _getDifficultyLabel(String difficulty) {
    switch (difficulty) {
      case 'beginner': return 'Principiante';
      case 'intermediate': return 'Intermedio';
      case 'expert': return 'Esperto';
      default: return difficulty;
    }
  }
  
  String _getTemperamentLabel(String temperament) {
    switch (temperament) {
      case 'peaceful': return 'Pacifico';
      case 'semi-aggressive': return 'Semi-aggressivo';
      case 'aggressive': return 'Aggressivo';
      default: return temperament;
    }
  }
  
  String _getDietLabel(String diet) {
    switch (diet) {
      case 'herbivore': return 'Erbivoro';
      case 'carnivore': return 'Carnivoro';
      case 'omnivore': return 'Onnivoro';
      default: return diet;
    }
  }
  
  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'facile':
        return const Color(0xFF34d399);
      case 'intermedio':
        return const Color(0xFFfbbf24);
      case 'difficile':
        return const Color(0xFFef4444);
      default:
        return const Color(0xFF6b7280);
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
    if (_nameController.text.isEmpty || _speciesController.text.isEmpty || _sizeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compila tutti i campi obbligatori')),
      );
      return;
    }

    final size = double.tryParse(_sizeController.text);
    if (size == null || size <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dimensione non valida')),
      );
      return;
    }

    final quantity = int.tryParse(_quantityController.text) ?? 1;
    if (quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantità non valida')),
      );
      return;
    }

    // Se è modifica, ignora quantità
    if (widget.fish != null) {
      final fish = Fish(
        id: widget.fish!.id,
        name: _nameController.text,
        species: _speciesController.text,
        size: size,
        addedDate: widget.fish!.addedDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      widget.onSave(fish, _selectedFishSpecies?.id);
      Navigator.pop(context);
      return;
    }

    // Se quantità = 1, usa il callback singolo
    if (quantity == 1) {
      final fish = Fish(
        id: const Uuid().v4(),
        name: _nameController.text,
        species: _speciesController.text,
        size: size,
        addedDate: DateTime.now(),
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      widget.onSave(fish, _selectedFishSpecies?.id);
    } else {
      // Se quantità > 1, crea lista con nomi numerati
      final fishList = List.generate(quantity, (index) {
        final fishNumber = index + 1;
        return Fish(
          id: const Uuid().v4(),
          name: quantity > 1 ? '${_nameController.text} #$fishNumber' : _nameController.text,
          species: _speciesController.text,
          size: size,
          addedDate: DateTime.now(),
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
      });
      
      if (widget.onSaveMultiple != null) {
        widget.onSaveMultiple!(fishList, _selectedFishSpecies?.id);
      } else {
        // Fallback: salva uno alla volta
        for (final fish in fishList) {
          widget.onSave(fish, _selectedFishSpecies?.id);
        }
      }
    }
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final heroTag = widget.fish != null ? 'fish_${widget.fish!.id}' : 'fish_new';
    
    return Dialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
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
                          color: theme.colorScheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: FaIcon(FontAwesomeIcons.fish, color: theme.colorScheme.primary, size: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.fish == null ? 'Aggiungi Pesce' : 'Modifica Pesce',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Dropdown per selezionare dal database
              if (widget.fish == null && !_isLoadingDatabase) ...[
                if (_availableFish.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.error.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.circleExclamation, color: theme.colorScheme.error, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.aquariumWaterType != null
                                ? 'Nessun pesce compatibile con acquario ${widget.aquariumWaterType}'
                                : 'Nessun pesce disponibile nel database',
                            style: TextStyle(color: theme.colorScheme.onErrorContainer),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<FishSpecies>(
                        isExpanded: true,
                        hint: Row(
                          children: [
                            FaIcon(FontAwesomeIcons.magnifyingGlass, color: theme.colorScheme.primary, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              'Seleziona dalla lista',
                              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                        value: _selectedFishSpecies,
                        dropdownColor: theme.colorScheme.surface,
                        icon: FaIcon(FontAwesomeIcons.caretDown, color: theme.colorScheme.primary),
                        items: _availableFish.map((species) {
                        return DropdownMenuItem<FishSpecies>(
                          value: species,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      species.commonName,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      species.scientificName,
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
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(species.difficulty),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _getDifficultyLabel(species.difficulty)[0],
                                  style: const TextStyle(
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
                      onChanged: _onFishSpeciesSelected,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'oppure inserisci manualmente',
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
                hint: 'es: Nemo',
                icon: FontAwesomeIcons.tag,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _speciesController,
                label: 'Specie *',
                hint: 'es: Amphiprion ocellaris',
                icon: FontAwesomeIcons.circleInfo,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _sizeController,
                label: 'Dimensione (cm) *',
                hint: 'es: 8.5',
                icon: FontAwesomeIcons.ruler,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              
              if (widget.fish == null) ...[
                _buildTextField(
                  controller: _quantityController,
                  label: 'Quantità',
                  hint: 'Numero di esemplari da aggiungere',
                  icon: FontAwesomeIcons.circlePlus,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                Text(
                  'Se aggiungi più esemplari, verranno numerati automaticamente',
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
                    child: Text('Annulla', style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Salva', style: TextStyle(fontWeight: FontWeight.w600)),
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
        Text(
          label,
          style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
            prefixIcon: Icon(icon, color: theme.colorScheme.primary),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}


