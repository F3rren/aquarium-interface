import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/fish.dart';

class AddFishDialog extends StatefulWidget {
  final Fish? fish;
  final Function(Fish) onSave;
  final Function(List<Fish>)? onSaveMultiple;

  const AddFishDialog({
    super.key,
    this.fish,
    required this.onSave,
    this.onSaveMultiple,
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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.fish?.name ?? '');
    _speciesController = TextEditingController(text: widget.fish?.species ?? '');
    _sizeController = TextEditingController(text: widget.fish?.size.toString() ?? '');
    _notesController = TextEditingController(text: widget.fish?.notes ?? '');
    _quantityController = TextEditingController(text: widget.fish == null ? '1' : '1');
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
      widget.onSave(fish);
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
      widget.onSave(fish);
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
        widget.onSaveMultiple!(fishList);
      } else {
        // Fallback: salva uno alla volta
        for (final fish in fishList) {
          widget.onSave(fish);
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
                          color: theme.colorScheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.pets, color: theme.colorScheme.primary, size: 28),
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
              
              _buildTextField(
                controller: _nameController,
                label: 'Nome *',
                hint: 'es: Nemo',
                icon: Icons.label,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _speciesController,
                label: 'Specie *',
                hint: 'es: Amphiprion ocellaris',
                icon: Icons.info_outline,
              ),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _sizeController,
                label: 'Dimensione (cm) *',
                hint: 'es: 8.5',
                icon: Icons.straighten,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              
              if (widget.fish == null) ...[
                _buildTextField(
                  controller: _quantityController,
                  label: 'Quantità',
                  hint: 'Numero di esemplari da aggiungere',
                  icon: Icons.add_circle_outline,
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
                icon: Icons.note,
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
