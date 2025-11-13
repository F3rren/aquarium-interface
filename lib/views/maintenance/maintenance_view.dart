import 'package:acquariumfe/models/maintenance_task.dart';
import 'package:acquariumfe/services/maintenance_service.dart';
import 'package:acquariumfe/widgets/add_task_dialog.dart';
import 'package:flutter/material.dart';

class MaintenanceView extends StatefulWidget {
  final String? aquariumId;
  
  const MaintenanceView({super.key, this.aquariumId});

  @override
  State<MaintenanceView> createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView> with TickerProviderStateMixin {
  final MaintenanceService _service = MaintenanceService();
  MaintenanceCategory? _filterCategory;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _listController;
  int _selectedIndex = 0; // 0=Task, 1=Calendario, 2=Storico
  DateTime _currentMonth = DateTime.now(); // Mese visualizzato nel calendario

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _listController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _service.initialize(aquariumId: widget.aquariumId);
    _fadeController.forward();
    _listController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 20 + bottomPadding + 80, // Spazio per FAB + barra navigazione
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabSelector(theme),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeController,
                child: _buildCurrentView(),
              ),
            ],
          ),
        ),
        // FAB visibile solo nella tab Task
        if (_selectedIndex == 0)
          Positioned(
            right: 20,
            bottom: 20 + bottomPadding,
            child: FloatingActionButton.extended(
              onPressed: _showAddTaskDialog,
              icon: const Icon(Icons.add),
              label: const Text('Aggiungi Task'),
              backgroundColor: const Color(0xFF8b5cf6),
            ),
          ),
      ],
    );
  }

  Future<void> _showAddTaskDialog() async {
    if (widget.aquariumId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Errore: ID acquario non disponibile'),
          backgroundColor: Color(0xFFef4444),
        ),
      );
      return;
    }

    final newTask = await showDialog<MaintenanceTask>(
      context: context,
      builder: (context) => AddTaskDialog(aquariumId: widget.aquariumId!),
    );

    if (newTask != null) {
      await _service.addTask(newTask);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "${newTask.title}" creata con successo!'),
          backgroundColor: const Color(0xFF10b981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  Widget _buildTabSelector(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          _buildTabButton('Task', Icons.checklist_rounded, 0, theme),
          _buildTabButton('Calendario', Icons.calendar_month, 1, theme),
          _buildTabButton('Storico', Icons.history, 2, theme),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, IconData icon, int index, ThemeData theme) {
    final isSelected = _selectedIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedIndex != index) {
            _fadeController.reset();
            setState(() {
              _selectedIndex = index;
            });
            _fadeController.forward();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF8b5cf6), Color(0xFFec4899)],
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_selectedIndex) {
      case 0:
        return _buildTasksView();
      case 1:
        return _buildCalendarView();
      case 2:
        return _buildHistoryView();
      default:
        return _buildTasksView();
    }
  }

  Widget _buildTasksView() {
    return ListenableBuilder(
      listenable: _service,
      builder: (context, child) {
        final theme = Theme.of(context);
        final overdue = _service.overdueTasks;
        final dueToday = _service.dueTodayTasks;
        final dueThisWeek = _service.dueThisWeekTasks;
        final upcoming = _service.upcomingTasks;

        return Column(
          children: [
            // Summary badges
            _buildSummaryBadges(theme, overdue.length, dueToday.length),
            const SizedBox(height: 20),

            // Category filter
            _buildCategorySegmentedButton(theme),
            const SizedBox(height: 20),

            // Task list
            _filterCategory != null
                ? _buildFilteredList()
                : _buildGroupedList(overdue, dueToday, dueThisWeek, upcoming),
          ],
        );
      },
    );
  }

  Widget _buildCalendarView() {
    return ListenableBuilder(
      listenable: _service,
      builder: (context, child) {
        final theme = Theme.of(context);
        
        return Column(
          children: [
            // Header mese/anno
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8b5cf6), Color(0xFFec4899)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                      });
                    },
                  ),
                  Text(
                    _getMonthYear(_currentMonth),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Giorni della settimana
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['L', 'M', 'M', 'G', 'V', 'S', 'D']
                    .map((day) => SizedBox(
                          width: 40,
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),

            // Griglia calendario
            _buildCalendarGrid(_currentMonth, theme),

            const SizedBox(height: 16),

            // Legenda task
            _buildTaskLegend(theme),
          ],
        );
      },
    );
  }

  Widget _buildCalendarGrid(DateTime month, ThemeData theme) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final firstWeekday = firstDayOfMonth.weekday; // 1 = Lunedì, 7 = Domenica
    
    final totalCells = daysInMonth + (firstWeekday - 1);
    final rows = (totalCells / 7).ceil();

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.8,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: rows * 7,
      itemBuilder: (context, index) {
        final dayNumber = index - (firstWeekday - 1) + 1;
        
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(month.year, month.month, dayNumber);
        final isToday = date.day == DateTime.now().day &&
            date.month == DateTime.now().month &&
            date.year == DateTime.now().year;
        
        final tasksForDay = _getTasksForDate(date);
        
        return _buildDayCell(
          dayNumber,
          isToday,
          tasksForDay,
          theme,
          date,
        );
      },
    );
  }

  Widget _buildDayCell(
    int day,
    bool isToday,
    List<MaintenanceTask> tasks,
    ThemeData theme,
    DateTime date,
  ) {
    final hasOverdue = tasks.any((t) => t.isOverdue && t.nextDue.day == day);
    final hasDueToday = tasks.any((t) => t.isDueToday && t.nextDue.day == day);
    final hasTasks = tasks.isNotEmpty;

    return GestureDetector(
      onTap: tasks.isNotEmpty
          ? () => _showTasksForDay(date, tasks)
          : null,
      child: Container(
        decoration: BoxDecoration(
          gradient: isToday
              ? const LinearGradient(
                  colors: [Color(0xFF8b5cf6), Color(0xFFec4899)],
                )
              : null,
          color: isToday ? null : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isToday
                ? Colors.transparent
                : hasOverdue
                    ? const Color(0xFFef4444).withValues(alpha: 0.5)
                    : hasDueToday
                        ? const Color(0xFFf59e0b).withValues(alpha: 0.5)
                        : theme.colorScheme.onSurface.withValues(alpha: 0.1),
            width: hasOverdue || hasDueToday ? 2 : 1,
          ),
          boxShadow: isToday || hasOverdue || hasDueToday
              ? [
                  BoxShadow(
                    color: isToday
                        ? const Color(0xFF8b5cf6).withValues(alpha: 0.3)
                        : hasOverdue
                            ? const Color(0xFFef4444).withValues(alpha: 0.3)
                            : const Color(0xFFf59e0b).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 16,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
                color: isToday
                    ? Colors.white
                    : theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            if (hasTasks) _buildTaskDots(tasks),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskDots(List<MaintenanceTask> tasks) {
    // Raggruppa task per categoria
    final categoryCount = <MaintenanceCategory, int>{};
    for (final task in tasks) {
      categoryCount[task.category] = (categoryCount[task.category] ?? 0) + 1;
    }

    // Prendi max 3 categorie più frequenti
    final topCategories = categoryCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final displayCategories = topCategories.take(3).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: displayCategories.map((entry) {
        final color = Color(entry.key.colorValue);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 3,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<MaintenanceTask> _getTasksForDate(DateTime date) {
    return _service.enabledTasks.where((task) {
      final nextDue = task.nextDue;
      return nextDue.year == date.year &&
          nextDue.month == date.month &&
          nextDue.day == date.day;
    }).toList();
  }

  String _getMonthYear(DateTime date) {
    const months = [
      'Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
      'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  Widget _buildTaskLegend(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legenda',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: MaintenanceCategory.values.map((category) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(category.colorValue),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    category.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showTasksForDay(DateTime date, List<MaintenanceTask> tasks) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8b5cf6), Color(0xFFec4899)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.event, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${date.day} ${_getMonthYear(date).split(' ')[0]}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${tasks.length} task programmati',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Task list
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final categoryColor = Color(task.category.colorValue);
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            categoryColor.withValues(alpha: 0.1),
                            categoryColor.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: categoryColor.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: categoryColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (task.description != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    task.description!,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            color: const Color(0xFF34d399),
                            onPressed: () {
                              Navigator.pop(context);
                              _completeTask(task);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryView() {
    return ListenableBuilder(
      listenable: _service,
      builder: (context, child) {
        final theme = Theme.of(context);
        final logs = _service.logs;
        
        if (logs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Nessuno Storico',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Completa task per vedere lo storico',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Raggruppa logs per task
        final taskGroups = <String, List<dynamic>>{};
        for (final log in logs) {
          final task = _service.tasks.firstWhere(
            (t) => t.id == log.taskId,
            orElse: () => _service.tasks.first,
          );
          final key = task.title;
          if (!taskGroups.containsKey(key)) {
            taskGroups[key] = [];
          }
          taskGroups[key]!.add({'log': log, 'task': task});
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: taskGroups.entries.map((entry) {
            final taskTitle = entry.key;
            final items = entry.value;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task header
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          taskTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8b5cf6), Color(0xFFec4899)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${items.length}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Logs
                ...items.map((item) {
                  final log = item['log'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 20,
                          color: const Color(0xFF34d399),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatLogDate(log.completedAt),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (log.notes != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  log.notes!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Text(
                          _formatLogTime(log.completedAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  String _formatLogDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) return 'Oggi';
    if (diff.inDays == 1) return 'Ieri';
    if (diff.inDays < 7) return '${diff.inDays} giorni fa';
    
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatLogTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildSummaryBadges(ThemeData theme, int overdueCount, int dueTodayCount) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFef4444).withValues(alpha: 0.15),
                  const Color(0xFFef4444).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFef4444).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: const Color(0xFFef4444),
                  size: 32,
                ),
                const SizedBox(height: 12),
                TweenAnimationBuilder<int>(
                  duration: const Duration(milliseconds: 800),
                  tween: IntTween(begin: 0, end: overdueCount),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFef4444),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  'In Ritardo',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFf59e0b).withValues(alpha: 0.15),
                  const Color(0xFFf59e0b).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFf59e0b).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.today,
                  color: const Color(0xFFf59e0b),
                  size: 32,
                ),
                const SizedBox(height: 12),
                TweenAnimationBuilder<int>(
                  duration: const Duration(milliseconds: 800),
                  tween: IntTween(begin: 0, end: dueTodayCount),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Text(
                      '$value',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFf59e0b),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                Text(
                  'Oggi',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySegmentedButton(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<MaintenanceCategory?>(
          value: _filterCategory,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          borderRadius: BorderRadius.circular(12),
          hint: Text(
            'Tutte le categorie',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          items: [
            DropdownMenuItem<MaintenanceCategory?>(
              value: null,
              child: Text(
                'Tutte le categorie',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...MaintenanceCategory.values.map((category) {
              return DropdownMenuItem<MaintenanceCategory?>(
                value: category,
                child: Text(
                  category.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ],
          onChanged: (MaintenanceCategory? newValue) {
            setState(() {
              _filterCategory = newValue;
            });
          },
          icon: Icon(
            Icons.arrow_drop_down,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupedList(
    List<MaintenanceTask> overdue,
    List<MaintenanceTask> dueToday,
    List<MaintenanceTask> dueThisWeek,
    List<MaintenanceTask> upcoming,
  ) {
    final items = <Widget>[];
    int cardIndex = 0;
    
    if (overdue.isNotEmpty) {
      items.add(_buildSectionHeader('In Ritardo 🔴', overdue.length));
      items.addAll(overdue.map((task) => _buildAnimatedTaskCard(task, cardIndex++, isOverdue: true)));
      items.add(const SizedBox(height: 12));
    }
    
    if (dueToday.isNotEmpty) {
      items.add(_buildSectionHeader('Oggi', dueToday.length));
      items.addAll(dueToday.map((task) => _buildAnimatedTaskCard(task, cardIndex++, isDueToday: true)));
      items.add(const SizedBox(height: 12));
    }
    
    if (dueThisWeek.isNotEmpty) {
      items.add(_buildSectionHeader('Questa Settimana', dueThisWeek.length));
      items.addAll(dueThisWeek.map((task) => _buildAnimatedTaskCard(task, cardIndex++)));
      items.add(const SizedBox(height: 12));
    }
    
    if (upcoming.isNotEmpty) {
      items.add(_buildSectionHeader('Questo mese', upcoming.length));
      items.addAll(upcoming.map((task) => _buildAnimatedTaskCard(task, cardIndex++)));
    }
    
    if (items.isEmpty) {
      return _buildEmptyState();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  Widget _buildFilteredList() {
    final tasks = _service.getTasksByCategory(_filterCategory!);
    
    if (tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Text(
                'Nessun task in ${_filterCategory!.label}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: tasks.asMap().entries.map((entry) {
        return _buildAnimatedTaskCard(entry.value, entry.key);
      }).toList(),
    );
  }

  void _rescheduleTask(MaintenanceTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifica scadenza'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.today),
              title: const Text('Posticipa 1 giorno'),
              onTap: () {
                Navigator.pop(context);
                _updateTaskSchedule(task, 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Posticipa 3 giorni'),
              onTap: () {
                Navigator.pop(context);
                _updateTaskSchedule(task, 3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Posticipa 1 settimana'),
              onTap: () {
                Navigator.pop(context);
                _updateTaskSchedule(task, 7);
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Data personalizzata'),
              onTap: () async {
                Navigator.pop(context);
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: task.nextDue,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (pickedDate != null) {
                  _updateTaskScheduleToDate(task, pickedDate);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
        ],
      ),
    );
  }

  void _updateTaskSchedule(MaintenanceTask task, int daysToPostpone) {
    final daysUntilDue = task.daysUntilDue;
    final newDaysUntil = daysUntilDue + daysToPostpone;
    final newLastCompleted = DateTime.now().subtract(Duration(days: task.frequencyDays - newDaysUntil));
    
    final updatedTask = MaintenanceTask(
      id: task.id,
      title: task.title,
      description: task.description,
      category: task.category,
      frequencyDays: task.frequencyDays,
      lastCompleted: newLastCompleted,
      enabled: task.enabled,
      aquariumId: task.aquariumId,
      reminderHour: task.reminderHour,
      reminderMinute: task.reminderMinute,
      isCustom: task.isCustom,
    );

    _service.updateTask(updatedTask);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Scadenza spostata al ${_formatDate(updatedTask.nextDue)}',
        ),
        backgroundColor: const Color(0xFF8b5cf6),
      ),
    );
  }

  void _updateTaskScheduleToDate(MaintenanceTask task, DateTime targetDate) {
    final daysUntilTarget = targetDate.difference(DateTime.now()).inDays;
    final newLastCompleted = DateTime.now().subtract(Duration(days: task.frequencyDays - daysUntilTarget));
    
    final updatedTask = MaintenanceTask(
      id: task.id,
      title: task.title,
      description: task.description,
      category: task.category,
      frequencyDays: task.frequencyDays,
      lastCompleted: newLastCompleted,
      enabled: task.enabled,
      aquariumId: task.aquariumId,
      reminderHour: task.reminderHour,
      reminderMinute: task.reminderMinute,
      isCustom: task.isCustom,
    );

    _service.updateTask(updatedTask);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Scadenza spostata al ${_formatDate(updatedTask.nextDue)}',
        ),
        backgroundColor: const Color(0xFF8b5cf6),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Jul', 'Ago', 'Set', 'Ott', 'Nov', 'Dic'];
    return '${date.day} ${months[date.month - 1]}';
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
        ],
      ),
    );
  }

  void _deleteTask(MaintenanceTask task) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina Task'),
        content: Text(
          'Sei sicuro di voler eliminare "${task.title}"?\n\n'
          'Questa azione non può essere annullata.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFef4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    await _service.removeTask(task.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" eliminata'),
        backgroundColor: const Color(0xFFef4444),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildAnimatedTaskCard(
    MaintenanceTask task,
    int index, {
    bool isOverdue = false,
    bool isDueToday = false,
  }) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _listController,
        curve: Interval(
          (index * 0.1).clamp(0.0, 1.0),
          ((index * 0.1) + 0.3).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(animation),
        child: _buildTaskCard(task, isOverdue: isOverdue, isDueToday: isDueToday),
      ),
    );
  }

  Widget _buildTaskCard(MaintenanceTask task, {bool isOverdue = false, bool isDueToday = false}) {
    final theme = Theme.of(context);
    final categoryColor = Color(task.category.colorValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOverdue
              ? const Color(0xFFef4444).withValues(alpha: 0.5)
              : isDueToday
                  ? const Color(0xFFf59e0b).withValues(alpha: 0.5)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.1),
          width: isOverdue || isDueToday ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    // Badge "Custom" per task personalizzate
                    if (task.isCustom)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8b5cf6).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFF8b5cf6).withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Text(
                          'CUSTOM',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8b5cf6),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),
                if (task.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDueColor(task).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getDueIcon(task),
                              size: 12,
                              color: _getDueColor(task),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                _getDueText(task),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _getDueColor(task),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Ogni ${task.frequencyDays}g',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: categoryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pulsante elimina (solo per task custom)
              if (task.isCustom)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 22),
                  color: const Color(0xFFef4444),
                  tooltip: 'Elimina',
                  onPressed: () => _deleteTask(task),
                ),
              IconButton(
                icon: const Icon(Icons.schedule, size: 24),
                color: const Color(0xFF8b5cf6),
                tooltip: 'Modifica scadenza',
                onPressed: () => _rescheduleTask(task),
              ),
              IconButton(
                icon: const Icon(Icons.check_circle_outline, size: 28),
                color: const Color(0xFF34d399),
                tooltip: 'Completa',
                onPressed: () => _completeTask(task),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getDueIcon(MaintenanceTask task) {
    if (task.isOverdue) return Icons.warning_amber_rounded;
    if (task.isDueToday) return Icons.today;
    return Icons.calendar_today;
  }

  Color _getDueColor(MaintenanceTask task) {
    if (task.isOverdue) return const Color(0xFFef4444);
    if (task.isDueToday) return const Color(0xFFf59e0b);
    return Colors.grey;
  }

  String _getDueText(MaintenanceTask task) {
    if (task.isOverdue) {
      final days = task.daysUntilDue.abs();
      return 'In ritardo di $days ${days == 1 ? 'giorno' : 'giorni'}';
    }
    if (task.isDueToday) return 'Dovuto oggi';
    
    final days = task.daysUntilDue;
    if (days == 1) return 'Domani';
    if (days <= 7) return 'Tra $days giorni';
    
    return 'Tra ${(days / 7).round()} settimane';
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Tutto fatto!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nessun task di manutenzione in scadenza',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _completeTask(MaintenanceTask task) async {
    final notesController = TextEditingController();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF34d399)),
            SizedBox(width: 12),
            Expanded(child: Text('Completa Task')),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Confermi di aver completato:'),
              const SizedBox(height: 8),
              Text(
                task.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Prossima esecuzione: ${_formatNextDue(task)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                'Note (opzionale)',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                decoration: InputDecoration(
                  hintText: 'es. Cambiati 30 litri, pH stabile',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.notes, size: 20),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF34d399),
            ),
            icon: const Icon(Icons.check),
            label: const Text('Completa'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      notesController.dispose();
      return;
    }

    final notes = notesController.text.trim();
    notesController.dispose();

    await _service.completeTask(
      task.id,
      notes: notes.isEmpty ? null : notes,
    );

    // Riavvia l'animazione della lista
    _listController.reset();
    _listController.forward();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('${task.title} completato!')),
          ],
        ),
        backgroundColor: const Color(0xFF34d399),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatNextDue(MaintenanceTask task) {
    final nextDue = DateTime.now().add(Duration(days: task.frequencyDays));
    return '${nextDue.day}/${nextDue.month}/${nextDue.year}';
  }
}
