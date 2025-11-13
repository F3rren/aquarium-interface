import 'package:acquariumfe/models/maintenance_task.dart';
import 'package:acquariumfe/models/maintenance_log.dart';
import 'package:acquariumfe/services/alert_manager.dart';
import 'package:acquariumfe/services/maintenance_storage_service.dart';
import 'package:flutter/foundation.dart';

/// Servizio per gestione task di manutenzione
class MaintenanceService extends ChangeNotifier {
  static final MaintenanceService _instance = MaintenanceService._internal();
  factory MaintenanceService() => _instance;
  MaintenanceService._internal();

  final AlertManager _alertManager = AlertManager();
  final MaintenanceStorageService _storage = MaintenanceStorageService();
  
  List<MaintenanceTask> _tasks = [];
  List<MaintenanceLog> _logs = [];
  String? _currentAquariumId;

  List<MaintenanceTask> get tasks => List.unmodifiable(_tasks);
  List<MaintenanceLog> get logs => List.unmodifiable(_logs);

  /// Task abilitati per l'acquario corrente
  List<MaintenanceTask> get enabledTasks {
    if (_currentAquariumId == null) {
      return _tasks.where((t) => t.enabled).toList();
    }
    return _tasks.where((t) => t.enabled && t.aquariumId == _currentAquariumId).toList();
  }

  /// Task in ritardo
  List<MaintenanceTask> get overdueTasks => 
      enabledTasks.where((t) => t.isOverdue).toList();

  /// Task dovuti oggi
  List<MaintenanceTask> get dueTodayTasks => 
      enabledTasks.where((t) => t.isDueToday).toList();

  /// Task dovuti questa settimana
  List<MaintenanceTask> get dueThisWeekTasks => 
      enabledTasks.where((t) => t.isDueThisWeek && !t.isDueToday).toList();

  /// Task futuri
  List<MaintenanceTask> get upcomingTasks => 
      enabledTasks.where((t) => t.daysUntilDue > 7).toList();

  /// Numero task in ritardo
  int get overdueCount => overdueTasks.length;

  /// Numero task dovuti oggi
  int get dueTodayCount => dueTodayTasks.length;

  /// Inizializza con task predefiniti per un acquario specifico
  Future<void> initialize({String? aquariumId}) async {
    print('🚀 MaintenanceService.initialize() - aquariumId: $aquariumId');
    _currentAquariumId = aquariumId;
    
    // Carica task salvati (TODO: da storage locale)
    await _loadTasks();
    print('📋 Task caricati: ${_tasks.length}');
    
    // Se non ci sono task per questo acquario, carica quelli predefiniti
    if (aquariumId != null && !_tasks.any((t) => t.aquariumId == aquariumId)) {
      print('⚠️ Nessun task trovato per acquario $aquariumId, carico predefiniti');
      _tasks.addAll(MaintenanceTask.getDefaultTasks(aquariumId));
      await _saveTasks();
      print('✅ Aggiunti ${MaintenanceTask.getDefaultTasks(aquariumId).length} task predefiniti');
    }

    // Carica logs (TODO: da storage locale)
    await _loadLogs();
    print('📝 Log caricati: ${_logs.length}');

    // Schedula notifiche
    await _scheduleAllNotifications();

    notifyListeners();
  }

  /// Aggiunge task personalizzato
  Future<void> addTask(MaintenanceTask task) async {
    _tasks.add(task.copyWith(isCustom: true));
    await _saveTasks();
    await _scheduleAllNotifications();
    notifyListeners();
  }

  /// Aggiorna task esistente
  Future<void> updateTask(MaintenanceTask updatedTask) async {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      await _saveTasks();
      await _scheduleAllNotifications();
      notifyListeners();
    }
  }

  /// Rimuove task (solo custom)
  Future<void> removeTask(String taskId) async {
    _tasks.removeWhere((t) => t.id == taskId && t.isCustom);
    await _saveTasks();
    await _scheduleAllNotifications();
    notifyListeners();
  }

  /// Segna task come completato
  Future<void> completeTask(String taskId, {String? notes}) async {
    final taskIndex = _tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final task = _tasks[taskIndex];
    final now = DateTime.now();

    // Aggiorna task con nuova data completamento
    _tasks[taskIndex] = task.markCompleted(now);

    // Aggiungi log di completamento
    final log = MaintenanceLog(
      id: '${now.millisecondsSinceEpoch}_$taskId',
      taskId: taskId,
      completedAt: now,
      notes: notes,
    );
    _logs.add(log);

    await _saveTasks();
    await _saveLogs();
    await _scheduleAllNotifications();
    
    notifyListeners();
  }

  /// Ottiene logs per un task specifico
  List<MaintenanceLog> getLogsForTask(String taskId) {
    return _logs
        .where((log) => log.taskId == taskId)
        .toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
  }

  /// Ottiene task per categoria
  List<MaintenanceTask> getTasksByCategory(MaintenanceCategory category) {
    return enabledTasks.where((t) => t.category == category).toList();
  }

  /// Schedula tutte le notifiche usando AlertManager
  Future<void> _scheduleAllNotifications() async {
    // Usa il sistema esistente di AlertManager per le notifiche
    await _alertManager.scheduleMaintenanceReminders();
    
    // TODO: Espandi per supportare task custom
    // Per ora usa solo i 4 task predefiniti (waterChange, filterCleaning, etc.)
  }

  /// Carica task dall'API Mockoon
  Future<void> _loadTasks() async {
    if (_currentAquariumId != null) {
      _tasks = await _storage.loadTasksFromApi(_currentAquariumId!);
    } else {
      _tasks = [];
    }
  }

  /// Salva task su storage locale
  Future<void> _saveTasks() async {
    await _storage.saveTasks(_tasks);
  }

  /// Carica logs dall'API Mockoon
  Future<void> _loadLogs() async {
    if (_currentAquariumId != null) {
      _logs = await _storage.loadLogsFromApi(_currentAquariumId!);
    } else {
      _logs = [];
    }
  }

  /// Salva logs su storage
  Future<void> _saveLogs() async {
    await _storage.saveLogs(_logs);
  }

  /// Reset task per debugging
  Future<void> resetToDefaults() async {
    if (_currentAquariumId == null) return;
    
    // Rimuovi task dell'acquario corrente
    _tasks.removeWhere((t) => t.aquariumId == _currentAquariumId);
    // Aggiungi task predefiniti
    _tasks.addAll(MaintenanceTask.getDefaultTasks(_currentAquariumId!));
    _logs = [];
    await _saveTasks();
    await _saveLogs();
    await _scheduleAllNotifications();
    notifyListeners();
  }
}
