/// Service for managing aquarium maintenance tasks via the backend API.
library;

import 'package:maintenance_service/api.dart';
import 'package:acquariumfe/core/utils/dto_parsing.dart';
import 'package:acquariumfe/core/constants/api_endpoints.dart';
import 'package:acquariumfe/features/maintenance/domain/models/maintenance_task.dart';
import 'package:acquariumfe/core/network/api_service.dart';

/// Singleton that performs CRUD operations on [MaintenanceTask] records and
/// provides convenience accessors for task subsets (pending, overdue, etc.).
///
/// [setCurrentAquarium] must be called when the active aquarium changes. All
/// task operations target the endpoint
/// `…/aquariums/{currentAquariumId}/tasks`.
///
/// **Response normalisation:** the backend may return `{"data": [...]}` or a
/// bare JSON array; both shapes are handled consistently.
class MaintenanceTaskService {
  static final MaintenanceTaskService _instance =
      MaintenanceTaskService._internal();
  factory MaintenanceTaskService() => _instance;
  MaintenanceTaskService._internal();

  final ApiService _apiService = ApiService();

  /// ID of the currently selected aquarium.
  int? _currentAquariumId;

  /// Sets the aquarium context for all subsequent task operations.
  void setCurrentAquarium(int id) {
    _currentAquariumId = id;
  }

  /// Returns all tasks for the current aquarium, optionally filtered by
  /// [status] (`'pending'` or `'completed'`).
  ///
  /// Throws if no aquarium has been set. Propagates API exceptions so the
  /// caller can display an error.
  Future<List<MaintenanceTask>> getAllTasks({String? status}) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      final base = ApiEndpoints.tasks(_currentAquariumId!);
      final queryParam = status != null ? '?status=$status' : '';
      final response = await _apiService.get('$base$queryParam');

      final List<dynamic> tasksJson;
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        tasksJson = response['data'] as List<dynamic>;
      } else if (response is List) {
        tasksJson = response;
      } else {
        return [];
      }

      return tasksJson
          .map((json) => MaintenanceTask.fromDto(requireParsed(MaintenanceTaskDTO.fromJson(json), context: 'MaintenanceTaskDTO')))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Returns tasks in the `'pending'` status.
  Future<List<MaintenanceTask>> getPendingTasks() async {
    return getAllTasks(status: 'pending');
  }

  /// Returns tasks in the `'completed'` status.
  Future<List<MaintenanceTask>> getCompletedTasks() async {
    return getAllTasks(status: 'completed');
  }

  /// Returns pending tasks that are either due today or already overdue.
  Future<List<MaintenanceTask>> getUpcomingTasks() async {
    final tasks = await getPendingTasks();
    return tasks.where((task) => task.isDueToday || task.isOverdue).toList();
  }

  /// Creates a new task in the current aquarium and returns the persisted
  /// entity (with its backend-assigned [MaintenanceTask.id]).
  Future<MaintenanceTask> createTask(MaintenanceTask task) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      final response = await _apiService.post(
        ApiEndpoints.tasks(_currentAquariumId!),
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

      return MaintenanceTask.fromDto(requireParsed(MaintenanceTaskDTO.fromJson(taskJson), context: 'MaintenanceTaskDTO'));
    } catch (e) {
      rethrow;
    }
  }

  /// Replaces the task identified by [taskId] with [task] and returns the
  /// updated entity.
  Future<MaintenanceTask> updateTask(
    String taskId,
    MaintenanceTask task,
  ) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      final response = await _apiService.put(
        ApiEndpoints.task(_currentAquariumId!, taskId),
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

      return MaintenanceTask.fromDto(requireParsed(MaintenanceTaskDTO.fromJson(taskJson), context: 'MaintenanceTaskDTO'));
    } catch (e) {
      rethrow;
    }
  }

  /// Permanently deletes the task identified by [taskId].
  Future<void> deleteTask(String taskId) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      await _apiService.delete(ApiEndpoints.task(_currentAquariumId!, taskId));
    } catch (e) {
      rethrow;
    }
  }

  /// Marks the task [taskId] as completed by calling the backend
  /// `POST …/tasks/{id}/complete` endpoint and returns the updated entity.
  Future<MaintenanceTask> completeTask(String taskId) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      final response = await _apiService.post(
        ApiEndpoints.completeTask(_currentAquariumId!, taskId),
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

      return MaintenanceTask.fromDto(requireParsed(MaintenanceTaskDTO.fromJson(taskJson), context: 'MaintenanceTaskDTO'));
    } catch (e) {
      rethrow;
    }
  }

  /// Enables or disables the task [taskId] without modifying any other field.
  Future<MaintenanceTask> toggleTaskEnabled(String taskId, bool enabled) async {
    final tasks = await getAllTasks();
    final task = tasks.firstWhere((t) => t.id == taskId);
    return updateTask(taskId, task.copyWith(enabled: enabled));
  }

  /// Updates the recurrence interval of task [taskId] to [frequencyDays] days.
  Future<MaintenanceTask> updateFrequency(
    String taskId,
    int frequencyDays,
  ) async {
    final tasks = await getAllTasks();
    final task = tasks.firstWhere((t) => t.id == taskId);
    return updateTask(taskId, task.copyWith(frequencyDays: frequencyDays));
  }

  /// Updates the reminder time of task [taskId] to the specified [hour] and
  /// [minute] (24-hour clock).
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

  /// Creates the default set of maintenance tasks for the current aquarium.
  ///
  /// [type] must be `'saltwater'` (default) or `'freshwater'`. Saltwater tanks
  /// get 10 tasks; freshwater tanks get 6 (the saltwater-specific tasks are
  /// omitted). Duplicate-creation errors from the backend are silently ignored
  /// so this method is safe to call on an already-initialised aquarium.
  Future<void> initializeDefaultTasks({String type = 'saltwater'}) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    final defaultTasks = MaintenanceTask.getDefaultTasks(
      _currentAquariumId.toString(),
      type: type,
    );

    for (final task in defaultTasks) {
      try {
        await createTask(task);
      } catch (e) {
        // Silently skip if the task already exists.
      }
    }
  }

  /// Returns task counts grouped by status.
  ///
  /// The returned map contains:
  /// - `'total'` — all tasks
  /// - `'pending'` — enabled tasks that are not overdue
  /// - `'overdue'` — enabled tasks that are past their due date
  /// - `'dueToday'` — enabled tasks due today
  /// - `'disabled'` — tasks with [MaintenanceTask.enabled] == `false`
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
