import 'package:acquariumfe/models/maintenance_task.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddTaskDialog extends StatefulWidget {
  final String aquariumId;

  const AddTaskDialog({super.key, required this.aquariumId});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  MaintenanceCategory _selectedCategory = MaintenanceCategory.water;
  int _frequencyDays = 7;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);
  bool _enableReminder = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final task = MaintenanceTask(
      id: 'task_custom_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      category: _selectedCategory,
      frequencyDays: _frequencyDays,
      lastCompleted: null, // Task nuova, mai completata
      enabled: true,
      aquariumId: widget.aquariumId,
      reminderHour: _enableReminder ? _reminderTime.hour : null,
      reminderMinute: _enableReminder ? _reminderTime.minute : null,
      isCustom: true,
    );

    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8b5cf6), Color(0xFFec4899)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const FaIcon(FontAwesomeIcons.listCheck, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nuova Task',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Crea una manutenzione personalizzata',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // Titolo
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Titolo *',
                      hintText: 'es. Pulizia schiumatoio',
                      prefixIcon: const FaIcon(FontAwesomeIcons.heading),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Il titolo è obbligatorio';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.sentences,
                  ),

                  const SizedBox(height: 16),

                  // Descrizione
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descrizione (opzionale)',
                      hintText: 'Aggiungi note o dettagli...',
                      prefixIcon: const FaIcon(FontAwesomeIcons.noteSticky),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),

                  const SizedBox(height: 16),

                  // Categoria
                  DropdownButtonFormField<MaintenanceCategory>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      prefixIcon: const FaIcon(FontAwesomeIcons.tag),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: MaintenanceCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                  ),

                  const SizedBox(height: 16),

                  // Frequenza
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.arrowsRotate, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Frequenza',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _frequencyDays.toDouble(),
                              min: 1,
                              max: 90,
                              divisions: 89,
                              label: '$_frequencyDays giorni',
                              onChanged: (value) {
                                setState(() => _frequencyDays = value.toInt());
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8b5cf6).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$_frequencyDays ${_frequencyDays == 1 ? 'giorno' : 'giorni'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF8b5cf6),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Preset rapidi
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildFrequencyChip('1 giorno', 1),
                          _buildFrequencyChip('3 giorni', 3),
                          _buildFrequencyChip('7 giorni', 7),
                          _buildFrequencyChip('14 giorni', 14),
                          _buildFrequencyChip('30 giorni', 30),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Reminder
                  SwitchListTile(
                    value: _enableReminder,
                    onChanged: (value) {
                      setState(() => _enableReminder = value);
                    },
                    title: const Text('Abilita promemoria'),
                    subtitle: _enableReminder
                        ? Text('Alle ${_reminderTime.format(context)}')
                        : const Text('Nessun promemoria'),
                    secondary: const FaIcon(FontAwesomeIcons.bell),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                  ),

                  if (_enableReminder) ...[
                    const SizedBox(height: 8),
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _reminderTime,
                          );
                          if (time != null) {
                            setState(() => _reminderTime = time);
                          }
                        },
                        icon: const FaIcon(FontAwesomeIcons.clock),
                        label: Text('Cambia orario (${_reminderTime.format(context)})'),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Annulla'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _saveTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8b5cf6),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.check, size: 20),
                              SizedBox(width: 8),
                              Text('Crea Task', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrequencyChip(String label, int days) {
    final isSelected = _frequencyDays == days;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _frequencyDays = days);
      },
      selectedColor: const Color(0xFF8b5cf6).withValues(alpha: 0.2),
      checkmarkColor: const Color(0xFF8b5cf6),
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? const Color(0xFF8b5cf6) : null,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

