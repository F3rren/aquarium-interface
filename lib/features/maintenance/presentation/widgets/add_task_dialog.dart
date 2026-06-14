/// Dialog widget for creating custom maintenance tasks.
library;

import 'package:acquariumfe/features/maintenance/domain/models/maintenance_task.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/core/theme/app_semantic_colors.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// A modal dialog that lets the user define a new custom [MaintenanceTask].
///
/// The form collects: title (required), optional description, category
/// (dropdown over [MaintenanceCategory] values), frequency in days
/// (1–90, with quick-select chips for 1/3/7/14/30), and an optional daily
/// reminder time (defaults to 09:00, toggled by a switch).
///
/// On confirmation the dialog pops with the constructed [MaintenanceTask]
/// whose [MaintenanceTask.id] is `'task_custom_<millisecondsSinceEpoch>'`
/// and [MaintenanceTask.isCustom] is `true`.  Cancelling pops with `null`.
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
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          gradient: LinearGradient(
                            colors: [
                              context.semantic.accentViolet,
                              context.semantic.accentPink,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const FaIcon(
                          FontAwesomeIcons.listCheck,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(    l10n.newTask,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(l10n.createCustomMaintenance,
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
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.taskTitle,
                      hintText: l10n.taskTitleHint,
                      prefixIcon: const FaIcon(FontAwesomeIcons.heading),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.enterTaskTitle;
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
                      labelText: l10n.taskDescription,
                      hintText: l10n.notesHint,
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
                    initialValue: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: l10n.category,
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
                          Text(l10n.frequency,
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
                              label:
                                  '$_frequencyDays ${_frequencyDays == 1 ? l10n.day : l10n.days}',
                              onChanged: (value) {
                                setState(() => _frequencyDays = value.toInt());
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: context.semantic.accentViolet.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('$_frequencyDays ${_frequencyDays == 1 ? l10n.day : l10n.days}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: context.semantic.accentViolet,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Preset rapidi
                      Wrap(
                        spacing: 8,
                        children: [
                          _buildFrequencyChip('1 ${l10n.day}', 1),
                          _buildFrequencyChip('3 ${l10n.days}', 3),
                          _buildFrequencyChip('7 ${l10n.days}', 7),
                          _buildFrequencyChip('14 ${l10n.days}', 14),
                          _buildFrequencyChip('30 ${l10n.days}', 30),
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
                    title: Text(l10n.enableReminder),
                    subtitle: _enableReminder
                        ? Text('${l10n.at} ${_reminderTime.format(context)}')
                        : Text(l10n.noReminder),
                    secondary: const FaIcon(FontAwesomeIcons.bell),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.1,
                        ),
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
                        label: Text(l10n.changeTime(_reminderTime.format(context)),
                        ),
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
                          child: Text(l10n.cancel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _saveTask,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.semantic.accentViolet,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(FontAwesomeIcons.check, size: 20),
                              const SizedBox(width: 8),
                              Text(l10n.createTask,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
      selectedColor: context.semantic.accentViolet.withValues(alpha: 0.2),
      checkmarkColor: context.semantic.accentViolet,
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? context.semantic.accentViolet : null,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
