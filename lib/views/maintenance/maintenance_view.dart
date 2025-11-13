import 'package:acquariumfe/models/maintenance_task.dart';
import 'package:acquariumfe/services/maintenance_service.dart';
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
  int _selectedIndex = 0; // 0=Task, 1=Calendario, 2=Storico

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
    _service.initialize(aquariumId: widget.aquariumId);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTabSelector(theme),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeController,
                child: _buildCurrentView(),
              ),
              const SizedBox(height: 80), // Spazio per FAB
            ],
          ),
        ),
        // FAB visibile solo nella tab Task
        if (_selectedIndex == 0)
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Aggiungi task custom - Coming soon'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Aggiungi Task'),
              backgroundColor: const Color(0xFF8b5cf6),
            ),
          ),
      ],
    );
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
          setState(() {
            _selectedIndex = index;
          });
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
            const SizedBox(height: 16),

            // Filter chips
            _buildCategoryFilters(),
            const SizedBox(height: 16),

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
        final now = DateTime.now();
        
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
                      // TODO: mese precedente
                    },
                  ),
                  Text(
                    _getMonthYear(now),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () {
                      // TODO: mese successivo
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
            _buildCalendarGrid(now, theme),

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
                            child: Text(
                              task.category.icon,
                              style: const TextStyle(fontSize: 24),
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
            final task = items.first['task'];
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task header
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  child: Row(
                    children: [
                      Text(
                        task.category.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 12),
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

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          // Filtro "Tutti"
          _buildFilterChip(
            label: 'Tutti',
            icon: Icons.grid_view_rounded,
            isSelected: _filterCategory == null,
            color: const Color(0xFF8b5cf6),
            onTap: () {
              setState(() {
                _filterCategory = null;
              });
            },
          ),
          const SizedBox(width: 8),
          // Filtri per categorie
          ...MaintenanceCategory.values.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(
                label: category.label,
                emoji: category.icon,
                isSelected: _filterCategory == category,
                color: Color(category.colorValue),
                onTap: () {
                  setState(() {
                    _filterCategory = _filterCategory == category ? null : category;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    String? emoji,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : theme.colorScheme.onSurface.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : color,
              )
            else if (emoji != null)
              Text(
                emoji,
                style: const TextStyle(fontSize: 18),
              ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
          ],
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
    
    if (overdue.isNotEmpty) {
      items.add(_buildSectionHeader('In Ritardo 🔴', overdue.length));
      items.addAll(overdue.map((task) => _buildTaskCard(task, isOverdue: true)));
      items.add(const SizedBox(height: 12));
    }
    
    if (dueToday.isNotEmpty) {
      items.add(_buildSectionHeader('Oggi', dueToday.length));
      items.addAll(dueToday.map((task) => _buildTaskCard(task, isDueToday: true)));
      items.add(const SizedBox(height: 12));
    }
    
    if (dueThisWeek.isNotEmpty) {
      items.add(_buildSectionHeader('Questa Settimana 📆', dueThisWeek.length));
      items.addAll(dueThisWeek.map((task) => _buildTaskCard(task)));
      items.add(const SizedBox(height: 12));
    }
    
    if (upcoming.isNotEmpty) {
      items.add(_buildSectionHeader('Prossimi 🗓️', upcoming.length));
      items.addAll(upcoming.map((task) => _buildTaskCard(task)));
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
              Text(
                _filterCategory!.icon,
                style: const TextStyle(fontSize: 64),
              ),
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
      children: tasks.map((task) => _buildTaskCard(task)).toList(),
    );
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
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8b5cf6), Color(0xFFec4899)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
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
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                task.category.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
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
                          Text(
                            _getDueText(task),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _getDueColor(task),
                            ),
                          ),
                        ],
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
          
          // Action button
          IconButton(
            icon: const Icon(Icons.check_circle_outline, size: 28),
            color: const Color(0xFF34d399),
            onPressed: () => _completeTask(task),
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

  void _completeTask(MaintenanceTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(task.category.icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            const Expanded(child: Text('Completa Task')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Confermi di aver completato:'),
            const SizedBox(height: 8),
            Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Prossima esecuzione: ${_formatNextDue(task)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annulla'),
          ),
          FilledButton.icon(
            onPressed: () {
              _service.completeTask(task.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${task.title} completato!'),
                  backgroundColor: const Color(0xFF34d399),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.check),
            label: const Text('Completa'),
          ),
        ],
      ),
    );
  }

  String _formatNextDue(MaintenanceTask task) {
    final nextDue = DateTime.now().add(Duration(days: task.frequencyDays));
    return '${nextDue.day}/${nextDue.month}/${nextDue.year}';
  }
}
