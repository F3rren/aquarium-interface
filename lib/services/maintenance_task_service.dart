import 'package:acquariumfe/models/maintenance_task.dart';
import 'package:acquariumfe/services/api_service.dart';

/// Service per gestire i task di manutenzione tramite API
class MaintenanceTaskService {
  static final MaintenanceTaskService _instance =
      MaintenanceTaskService._internal();
  factory MaintenanceTaskService() => _instance;
  MaintenanceTaskService._internal();

  final ApiService _apiService = ApiService();

  int? _currentAquariumId;

  void setCurrentAquarium(int id) {
    _currentAquariumId = id;
  }

  /// Ottieni tutti i task
  Future<List<MaintenanceTask>> getAllTasks({String? status}) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      final queryParam = status != null ? '?status=$status' : '';
      final response = await _apiService.get(
        '/aquariums/$_currentAquariumId/tasks$queryParam',
      );

      final List<dynamic> tasksJson;
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        tasksJson = response['data'] as List<dynamic>;
      } else if (response is List) {
        tasksJson = response;
      } else {
        return [];
      }

      return tasksJson
          .map((json) => MaintenanceTask.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Ottieni solo task pendenti
  Future<List<MaintenanceTask>> getPendingTasks() async {
    return getAllTasks(status: 'pending');
  }

  /// Ottieni solo task completati
  Future<List<MaintenanceTask>> getCompletedTasks() async {
    return getAllTasks(status: 'completed');
  }

  /// Ottieni task in scadenza (oggi o in ritardo)
  Future<List<MaintenanceTask>> getUpcomingTasks() async {
    final tasks = await getPendingTasks();
    return tasks.where((task) => task.isDueToday || task.isOverdue).toList();
  }

  /// Crea nuovo task
  Future<MaintenanceTask> createTask(MaintenanceTask task) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      final response = await _apiService.post(
        '/aquariums/$_currentAquariumId/tasks',
        task.toJson(),
      );

      final Map<String, dynamic> taskJson;
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        taskJson = response['data'] as Map<String, dynamic>;
      } else if (response is Map<String, dynamic>) {
        taskJson = response;
      } else {
        throw Exception('Formato risposta non valido');
      }

      return MaintenanceTask.fromJson(taskJson);
    } catch (e) {
      rethrow;
    }
  }

  /// Aggiorna task esistente
  Future<MaintenanceTask> updateTask(
    String taskId,
    MaintenanceTask task,
  ) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      final response = await _apiService.put(
        '/aquariums/$_currentAquariumId/tasks/$taskId',
        task.toJson(),
      );

      final Map<String, dynamic> taskJson;
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        taskJson = response['data'] as Map<String, dynamic>;
      } else if (response is Map<String, dynamic>) {
        taskJson = response;
      } else {
        throw Exception('Formato risposta non valido');
      }

      return MaintenanceTask.fromJson(taskJson);
    } catch (e) {
      rethrow;
    }
  }

  /// Elimina task
  Future<void> deleteTask(String taskId) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      await _apiService.delete('/aquariums/$_currentAquariumId/tasks/$taskId');
    } catch (e) {
      rethrow;
    }
  }

  /// Marca task come completato
  Future<MaintenanceTask> completeTask(String taskId) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      final response = await _apiService.post(
        '/aquariums/$_currentAquariumId/tasks/$taskId/complete',
        {},
      );

      final Map<String, dynamic> taskJson;
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        taskJson = response['data'] as Map<String, dynamic>;
      } else if (response is Map<String, dynamic>) {
        taskJson = response;
      } else {
        throw Exception('Formato risposta non valido');
      }

      return MaintenanceTask.fromJson(taskJson);
    } catch (e) {
      rethrow;
    }
  }

  /// Abilita/disabilita task
  Future<MaintenanceTask> toggleTaskEnabled(String taskId, bool enabled) async {
    final tasks = await getAllTasks();
    final task = tasks.firstWhere((t) => t.id == taskId);

    return updateTask(taskId, task.copyWith(enabled: enabled));
  }

  /// Aggiorna frequenza task
  Future<MaintenanceTask> updateFrequency(
    String taskId,
    int frequencyDays,
  ) async {
    final tasks = await getAllTasks();
    final task = tasks.firstWhere((t) => t.id == taskId);

    return updateTask(taskId, task.copyWith(frequencyDays: frequencyDays));
  }

  /// Aggiorna orario reminder
  Future<MaintenanceTask> updateReminder(
    String taskId,
    int hour,
    int minute,
  ) async {
    final tasks = await getAllTasks();
    final task = tasks.firstWhere((t) => t.id == taskId);

    return updateTask(
      taskId,
      task.copyWith(reminderHour: hour, reminderMinute: minute),
    );
  }

  /// Inizializza task predefiniti per un nuovo acquario
  Future<void> initializeDefaultTasks() async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    final defaultTasks = MaintenanceTask.getDefaultTasks(
      _currentAquariumId.toString(),
    );

    for (final task in defaultTasks) {
      try {
        await createTask(task);
      } catch (e) {
        // Ignora errori se task già esistono
      }
    }
  }

  /// Ottieni statistiche task
  Future<Map<String, int>> getTaskStatistics() async {
    final allTasks = await getAllTasks();

    return {
      'total': allTasks.length,
      'pending': allTasks.where((t) => !t.isOverdue && t.enabled).length,
      'overdue': allTasks.where((t) => t.isOverdue && t.enabled).length,
      'dueToday': allTasks.where((t) => t.isDueToday && t.enabled).length,
      'disabled': allTasks.where((t) => !t.enabled).length,
    };
  }
}
