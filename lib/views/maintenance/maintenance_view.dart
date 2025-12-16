import 'package:acquariumfe/models/maintenance_task.dart';
import 'package:acquariumfe/services/maintenance_task_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:acquariumfe/utils/responsive_breakpoints.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

class MaintenanceView extends StatefulWidget {
  final int? aquariumId;

  const MaintenanceView({super.key, this.aquariumId});

  @override
  State<MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView> {
  final MaintenanceTaskService _service = MaintenanceTaskService();
  MaintenanceCategory? _filterCategory;
  bool _showCompleted = false; // Toggle tra task in corso e completati

  List<MaintenanceTask> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    if (widget.aquariumId != null) {
      _service.setCurrentAquarium(widget.aquariumId!);
      _loadTasks();
    }
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await _service.getAllTasks();
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorLoadingTasks(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<MaintenanceTask> get _pendingTasks =>
      _tasks.where((t) => !t.isCompleted).toList();
  List<MaintenanceTask> get _completedTasks =>
      _tasks.where((t) => t.isCompleted).toList();
  List<MaintenanceTask> get _overdueTasks =>
      _pendingTasks.where((t) => t.isOverdue || (t.overdue ?? false)).toList();
  List<MaintenanceTask> get _dueTodayTasks =>
      _pendingTasks.where((t) => t.isDueToday).toList();
  List<MaintenanceTask> get _dueThisWeekTasks =>
      _pendingTasks.where((t) => t.isDueThisWeek && !t.isDueToday).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = ResponsiveBreakpoints.horizontalPadding(screenWidth);

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadTasks,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: padding,
                  right: padding,
                  top: padding,
                  bottom: padding + bottomPadding + 80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStats(theme),
                    const SizedBox(height: 20),
                    _buildSectionToggle(theme),
                    const SizedBox(height: 20),
                    _buildCategoryFilter(theme),
                    const SizedBox(height: 20),
                    _buildTasksList(theme),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const FaIcon(FontAwesomeIcons.plus),
        label: Text(AppLocalizations.of(context)!.addTask),
        backgroundColor: const Color(0xFF8b5cf6),
      ),
    );
  }

  Widget _buildSectionToggle(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _showCompleted = false),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_showCompleted
                      ? const Color(0xFF8b5cf6)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.listCheck,
                      size: 16,
                      color: !_showCompleted
                          ? Colors.white
                          : theme.textTheme.bodyMedium?.color,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.inProgress(_pendingTasks.length),
                      style: TextStyle(
                        color: !_showCompleted
                            ? Colors.white
                            : theme.textTheme.bodyMedium?.color,
                        fontWeight: !_showCompleted
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _showCompleted = true),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _showCompleted
                      ? const Color(0xFF10b981)
                      : Colors.transparent,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.circleCheck,
                      size: 16,
                      color: _showCompleted
                          ? Colors.white
                          : theme.textTheme.bodyMedium?.color,
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.completed(_completedTasks.length),
                      style: TextStyle(
                        color: _showCompleted
                            ? Colors.white
                            : theme.textTheme.bodyMedium?.color,
                        fontWeight: _showCompleted
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            l10n.overdue,
            _overdueTasks.length.toString(),
            FontAwesomeIcons.triangleExclamation,
            const Color(0xFFef4444),
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            l10n.today,
            _dueTodayTasks.length.toString(),
            FontAwesomeIcons.calendarDay,
            const Color(0xFFf59e0b),
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            l10n.week,
            _dueThisWeekTasks.length.toString(),
            FontAwesomeIcons.calendarWeek,
            const Color(0xFF3b82f6),
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          FaIcon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(l10n.all, null, theme),
          const SizedBox(width: 8),
          ...MaintenanceCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(
                _getCategoryName(category),
                category,
                theme,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    MaintenanceCategory? category,
    ThemeData theme,
  ) {
    final isSelected = _filterCategory == category;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterCategory = selected ? category : null;
        });
      },
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      selectedColor: const Color(0xFF8b5cf6),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
      ),
    );
  }

  Widget _buildTasksList(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final tasksToShow = _showCompleted ? _completedTasks : _pendingTasks;
    final filteredTasks = _filterCategory == null
        ? tasksToShow
        : tasksToShow.where((t) => t.category == _filterCategory).toList();

    if (filteredTasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              FaIcon(
                _showCompleted
                    ? FontAwesomeIcons.circleCheck
                    : FontAwesomeIcons.clipboardCheck,
                size: 48,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(_showCompleted ? l10n.noCompletedTasks : l10n.noTasksInProgress,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: filteredTasks
          .map((task) => _buildTaskCard(task, theme))
          .toList(),
    );
  }

  Widget _buildTaskCard(MaintenanceTask task, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final daysUntil = task.daysUntilDue;
    final isOverdue = task.isOverdue;
    final isDueToday = task.isDueToday;

    Color statusColor;
    String statusText;

    if (isOverdue) {
      statusColor = const Color(0xFFef4444);
      statusText = l10n.overdueDays(-daysUntil);
    } else if (isDueToday) {
      statusColor = const Color(0xFFf59e0b);
      statusText = l10n.dueToday;
    } else if (daysUntil <= 7) {
      statusColor = const Color(0xFF3b82f6);
      statusText = l10n.inDays(daysUntil);
    } else {
      statusColor = const Color(0xFF10b981);
      statusText = l10n.inDays(daysUntil);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showTaskDetails(task),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                        task.category,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FaIcon(
                      _getCategoryIcon(task.category),
                      color: _getCategoryColor(task.category),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (task.description != null)
                          Text(task.description!,
                            style: theme.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (!_showCompleted)
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.check, size: 20),
                      color: const Color(0xFF10b981),
                      onPressed: () => _completeTask(task),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FaIcon(
                        _showCompleted
                            ? FontAwesomeIcons.circleCheck
                            : FontAwesomeIcons.repeat,
                        size: 14,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 6),
                      Text(_showCompleted && task.completedAt != null
                            ? l10n.completedOn(_formatDate(task.completedAt!))
                            : l10n.everyDays(task.frequencyDays),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (!_showCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(statusText,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (_showCompleted && task.priority != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(
                          task.priority!,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.flag,
                            size: 12,
                            color: _getPriorityColor(task.priority!),
                          ),
                          const SizedBox(width: 4),
                          Text(_getPriorityLabel(task.priority!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getPriorityColor(task.priority!),
                              fontWeight: FontWeight.bold,
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
  }

  Future<void> _showAddTaskDialog() async {
    if (widget.aquariumId == null) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.aquariumIdNotAvailable),
          backgroundColor: const Color(0xFFef4444),
        ),
      );
      return;
    }

    final TextEditingController titleController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    MaintenanceCategory selectedCategory = MaintenanceCategory.water;
    String selectedFrequency = 'weekly';
    String selectedPriority = 'medium';
    DateTime? selectedDueDate;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.newTask),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Titolo'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Descrizione'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<MaintenanceCategory>(
                    value: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    items: MaintenanceCategory.values.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(_getCategoryName(cat)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedCategory = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedFrequency,
                    decoration: InputDecoration(labelText: l10n.frequency),
                    items: [
                      DropdownMenuItem(value: 'daily', child: Text(l10n.daily)),
                      DropdownMenuItem(
                        value: 'weekly',
                        child: Text(l10n.weekly),
                      ),
                      DropdownMenuItem(
                        value: 'monthly',
                        child: Text(l10n.monthly),
                      ),
                      DropdownMenuItem(
                        value: 'custom',
                        child: Text(l10n.custom),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedFrequency = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    decoration: const InputDecoration(labelText: 'PrioritÃ '),
                    items: [
                      DropdownMenuItem(value: 'low', child: Text(l10n.low)),
                      DropdownMenuItem(
                        value: 'medium',
                        child: Text(l10n.medium),
                      ),
                      DropdownMenuItem(value: 'high', child: Text(l10n.high)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedPriority = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.dueDate),
                    subtitle: Text(selectedDueDate != null
                          ? _formatDate(selectedDueDate!)
                          : l10n.notSet,
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        if (!context.mounted) return;
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                            selectedDueDate ?? DateTime.now(),
                          ),
                        );
                        if (time != null) {
                          setDialogState(() {
                            selectedDueDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(labelText: l10n.notes),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.add),
              ),
            ],
          );
        },
      ),
    );

    if (result == true && titleController.text.isNotEmpty) {
      final newTask = MaintenanceTask(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        aquariumId: widget.aquariumId.toString(),
        title: titleController.text,
        description: descController.text.isEmpty ? null : descController.text,
        category: selectedCategory,
        frequency: selectedFrequency,
        priority: selectedPriority,
        dueDate: selectedDueDate,
        notes: notesController.text.isEmpty ? null : notesController.text,
        isCustom: true,
      );

      try {
        await _service.createTask(newTask);
        await _loadTasks();
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.taskAddedSuccess)));
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorWithMessage(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showEditTaskDialog(MaintenanceTask task) async {
    final TextEditingController titleController = TextEditingController(
      text: task.title,
    );
    final TextEditingController descController = TextEditingController(
      text: task.description ?? '',
    );
    final TextEditingController notesController = TextEditingController(
      text: task.notes ?? '',
    );
    MaintenanceCategory selectedCategory = task.category;
    String selectedFrequency = task.frequency ?? 'weekly';
    String selectedPriority = task.priority ?? 'medium';
    DateTime? selectedDueDate = task.dueDate;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.editTask),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Titolo'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: 'Descrizione'),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<MaintenanceCategory>(
                    value: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    items: MaintenanceCategory.values.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Text(_getCategoryName(cat)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedCategory = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedFrequency,
                    decoration: InputDecoration(labelText: l10n.frequency),
                    items: [
                      DropdownMenuItem(value: 'daily', child: Text(l10n.daily)),
                      DropdownMenuItem(
                        value: 'weekly',
                        child: Text(l10n.weekly),
                      ),
                      DropdownMenuItem(
                        value: 'monthly',
                        child: Text(l10n.monthly),
                      ),
                      DropdownMenuItem(
                        value: 'custom',
                        child: Text(l10n.custom),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedFrequency = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    decoration: const InputDecoration(labelText: 'PrioritÃ '),
                    items: [
                      DropdownMenuItem(value: 'low', child: Text(l10n.low)),
                      DropdownMenuItem(
                        value: 'medium',
                        child: Text(l10n.medium),
                      ),
                      DropdownMenuItem(value: 'high', child: Text(l10n.high)),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => selectedPriority = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.dueDate),
                    subtitle: Text(selectedDueDate != null
                          ? _formatDate(selectedDueDate!)
                          : l10n.notSet,
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDueDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        if (!context.mounted) return;
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                            selectedDueDate ?? DateTime.now(),
                          ),
                        );
                        if (time != null) {
                          setDialogState(() {
                            selectedDueDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(labelText: l10n.notes),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.save),
              ),
            ],
          );
        },
      ),
    );

    if (result == true && titleController.text.isNotEmpty) {
      final updatedTask = task.copyWith(
        title: titleController.text,
        description: descController.text.isEmpty ? null : descController.text,
        category: selectedCategory,
        frequency: selectedFrequency,
        priority: selectedPriority,
        dueDate: selectedDueDate,
        notes: notesController.text.isEmpty ? null : notesController.text,
      );

      try {
        await _service.updateTask(task.id, updatedTask);
        await _loadTasks();
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.taskEditedSuccess)));
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorWithMessage(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _completeTask(MaintenanceTask task) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.completeTask),
        content: Text(l10n.confirmCompleteTask(task.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10b981),
            ),
            child: Text(l10n.complete),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _service.completeTask(task.id);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        await _loadTasks();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.taskCompletedSuccess(task.title)),
            backgroundColor: const Color(0xFF10b981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorWithMessage(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showTaskDetails(MaintenanceTask task) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(
                      task.category,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FaIcon(
                    _getCategoryIcon(task.category),
                    color: _getCategoryColor(task.category),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(_getCategoryName(task.category),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.penToSquare),
                  onPressed: () {
                    Navigator.pop(context);
                    _showEditTaskDialog(task);
                  },
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.trash),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteTask(task);
                  },
                ),
              ],
            ),
            if (task.description != null) ...[
              const SizedBox(height: 16),
              Text(task.description!),
            ],
            if (task.notes != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FaIcon(FontAwesomeIcons.noteSticky, size: 16),
                    const SizedBox(width: 8),
                    Expanded(child: Text(task.notes!)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            if (task.priority != null)
              _buildTaskInfo('PrioritÃ ', _getPriorityLabel(task.priority!)),
            if (task.frequency != null)
              _buildTaskInfo('Frequenza', _getFrequencyLabel(task.frequency!)),
            if (task.dueDate != null && !task.isCompleted)
              _buildTaskInfo('Scadenza', _formatDateTime(task.dueDate!)),
            if (task.isCompleted && task.completedAt != null)
              _buildTaskInfo(
                'Completato il',
                _formatDateTime(task.completedAt!),
              ),
            if (!task.isCompleted && task.lastCompleted != null)
              _buildTaskInfo(
                'Ultimo completamento',
                _formatDate(task.lastCompleted!),
              ),
            if (!task.isCompleted)
              _buildTaskInfo('Prossima scadenza', _formatDate(task.nextDue)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const FaIcon(FontAwesomeIcons.xmark, size: 16),
                    label: Text(l10n.close),
                  ),
                ),
                if (!task.isCompleted) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _completeTask(task);
                      },
                      icon: const FaIcon(FontAwesomeIcons.check, size: 16),
                      label: Text(l10n.complete),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10b981),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          Text(value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteTask(MaintenanceTask task) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTask),
        content: Text(l10n.confirmDeleteTask(task.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.deleteTask(task.id);
        await _loadTasks();
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.taskDeleted)));
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.errorWithMessage(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _getCategoryName(MaintenanceCategory category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category) {
      case MaintenanceCategory.water:
        return l10n.water;
      case MaintenanceCategory.equipment:
        return l10n.equipment;
      case MaintenanceCategory.testing:
        return l10n.testing;
      case MaintenanceCategory.cleaning:
        return l10n.cleaning;
      case MaintenanceCategory.dosing:
        return 'Dosaggio'; // TODO: add to ARB if needed
      case MaintenanceCategory.feeding:
        return l10n.feeding;
      case MaintenanceCategory.other:
        return l10n.other;
    }
  }

  IconData _getCategoryIcon(MaintenanceCategory category) {
    switch (category) {
      case MaintenanceCategory.water:
        return FontAwesomeIcons.droplet;
      case MaintenanceCategory.equipment:
        return FontAwesomeIcons.screwdriverWrench;
      case MaintenanceCategory.testing:
        return FontAwesomeIcons.vial;
      case MaintenanceCategory.cleaning:
        return FontAwesomeIcons.broom;
      case MaintenanceCategory.dosing:
        return FontAwesomeIcons.flask;
      case MaintenanceCategory.feeding:
        return FontAwesomeIcons.utensils;
      case MaintenanceCategory.other:
        return FontAwesomeIcons.ellipsis;
    }
  }

  Color _getCategoryColor(MaintenanceCategory category) {
    switch (category) {
      case MaintenanceCategory.water:
        return const Color(0xFF3b82f6);
      case MaintenanceCategory.equipment:
        return const Color(0xFF8b5cf6);
      case MaintenanceCategory.testing:
        return const Color(0xFFf59e0b);
      case MaintenanceCategory.cleaning:
        return const Color(0xFF10b981);
      case MaintenanceCategory.dosing:
        return const Color(0xFF06b6d4);
      case MaintenanceCategory.feeding:
        return const Color(0xFFec4899);
      case MaintenanceCategory.other:
        return const Color(0xFF6b7280);
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFef4444);
      case 'medium':
        return const Color(0xFFf59e0b);
      case 'low':
        return const Color(0xFF10b981);
      default:
        return const Color(0xFF6b7280);
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 'Alta';
      case 'medium':
        return 'Media';
      case 'low':
        return 'Bassa';
      default:
        return priority;
    }
  }

  String _getFrequencyLabel(String frequency) {
    switch (frequency.toLowerCase()) {
      case 'daily':
        return 'Giornaliero';
      case 'weekly':
        return 'Settimanale';
      case 'monthly':
        return 'Mensile';
      case 'custom':
        return 'Personalizzato';
      default:
        return frequency;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);

    if (dateDay == today) return 'Oggi';
    if (dateDay == today.add(const Duration(days: 1))) return 'Domani';
    if (dateDay == today.subtract(const Duration(days: 1))) return 'Ieri';

    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    final formatted = _formatDate(date);
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$formatted alle $hour:$minute';
  }
}
