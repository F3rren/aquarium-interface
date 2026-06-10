/// Service for managing aquarium maintenance tasks via the backend API.
library;

import 'package:acquariumfe/core/constants/api_endpoints.dart';
import 'package:acquariumfe/features/maintenance/domain/models/maintenance_task.dart';
import 'package:acquariumfe/core/network/api_service.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';

/// Service that performs CRUD operations on [MaintenanceTask] records and
/// provides convenience accessors for task subsets (pending, overdue, etc.).
///
/// Every operation takes the target [aquariumId] explicitly and addresses the
/// endpoint `…/aquariums/{aquariumId}/tasks`; the service holds no mutable
/// "current aquarium" state.
///
/// **Response normalisation:** the backend may return `{"data": [...]}` or a
/// bare JSON array; both shapes are handled consistently.
class MaintenanceTaskService {
  /// Creates a service backed by the shared [ApiService].
  ///
  /// Obtain the app-wide instance via Riverpod
  /// ([maintenanceTaskServiceProvider]) rather than constructing directly.
  MaintenanceTaskService(this._apiService);

  final ApiService _apiService;

  /// Returns all tasks for aquarium [aquariumId], optionally filtered by
  /// [status] (`'pending'` or `'completed'`).
  ///
  /// Propagates API exceptions so the caller can display an error.
  Future<List<MaintenanceTask>> getAllTasks(
    int aquariumId, {
    String? status,
  }) async {
    try {
      final base = ApiEndpoints.tasks(aquariumId);
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
          .map((json) => MaintenanceTask.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Returns tasks in the `'pending'` status.
  Future<List<MaintenanceTask>> getPendingTasks(int aquariumId) async {
    return getAllTasks(aquariumId, status: 'pending');
  }

  /// Returns tasks in the `'completed'` status.
  Future<List<MaintenanceTask>> getCompletedTasks(int aquariumId) async {
    return getAllTasks(aquariumId, status: 'completed');
  }

  /// Returns pending tasks that are either due today or already overdue.
  Future<List<MaintenanceTask>> getUpcomingTasks(int aquariumId) async {
    final tasks = await getPendingTasks(aquariumId);
    return tasks.where((task) => task.isDueToday || task.isOverdue).toList();
  }

  /// Creates a new task in aquarium [aquariumId] and returns the persisted
  /// entity (with its backend-assigned [MaintenanceTask.id]).
  Future<MaintenanceTask> createTask(
    int aquariumId,
    MaintenanceTask task,
  ) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.tasks(aquariumId),
        task.toJson(),
      );

      final Map<String, dynamic> taskJson;
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        taskJson = response['data'] as Map<String, dynamic>;
      } else if (response is Map<String, dynamic>) {
        taskJson = response;
      } else {
        throw DataFormatException('Invalid response format');
      }

      return MaintenanceTask.fromJson(taskJson);
    } catch (e) {
      rethrow;
    }
  }

  /// Replaces the task identified by [taskId] with [task] and returns the
  /// updated entity.
  Future<MaintenanceTask> updateTask(
    int aquariumId,
    String taskId,
    MaintenanceTask task,
  ) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.task(aquariumId, taskId),
        task.toJson(),
      );

      final Map<String, dynamic> taskJson;
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        taskJson = response['data'] as Map<String, dynamic>;
      } else if (response is Map<String, dynamic>) {
        taskJson = response;
      } else {
        throw DataFormatException('Invalid response format');
      }

      return MaintenanceTask.fromJson(taskJson);
    } catch (e) {
      rethrow;
    }
  }

  /// Permanently deletes the task identified by [taskId].
  Future<void> deleteTask(int aquariumId, String taskId) async {
    try {
      await _apiService.delete(ApiEndpoints.task(aquariumId, taskId));
    } catch (e) {
      rethrow;
    }
  }

  /// Marks the task [taskId] as completed by calling the backend
  /// `POST …/tasks/{id}/complete` endpoint and returns the updated entity.
  Future<MaintenanceTask> completeTask(int aquariumId, String taskId) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.completeTask(aquariumId, taskId),
        {},
      );

      final Map<String, dynamic> taskJson;
      if (response is Map<String, dynamic> && response.containsKey('data')) {
        taskJson = response['data'] as Map<String, dynamic>;
      } else if (response is Map<String, dynamic>) {
        taskJson = response;
      } else {
        throw DataFormatException('Invalid response format');
      }

      return MaintenanceTask.fromJson(taskJson);
    } catch (e) {
      rethrow;
    }
  }

  /// Enables or disables the task [taskId] without modifying any other field.
  Future<MaintenanceTask> toggleTaskEnabled(
    int aquariumId,
    String taskId,
    bool enabled,
  ) async {
    final tasks = await getAllTasks(aquariumId);
    final task = tasks.firstWhere((t) => t.id == taskId);
    return updateTask(aquariumId, taskId, task.copyWith(enabled: enabled));
  }

  /// Updates the recurrence interval of task [taskId] to [frequencyDays] days.
  Future<MaintenanceTask> updateFrequency(
    int aquariumId,
    String taskId,
    int frequencyDays,
  ) async {
    final tasks = await getAllTasks(aquariumId);
    final task = tasks.firstWhere((t) => t.id == taskId);
    return updateTask(
      aquariumId,
      taskId,
      task.copyWith(frequencyDays: frequencyDays),
    );
  }

  /// Updates the reminder time of task [taskId] to the specified [hour] and
  /// [minute] (24-hour clock).
  Future<MaintenanceTask> updateReminder(
    int aquariumId,
    String taskId,
    int hour,
    int minute,
  ) async {
    final tasks = await getAllTasks(aquariumId);
    final task = tasks.firstWhere((t) => t.id == taskId);
    return updateTask(
      aquariumId,
      taskId,
      task.copyWith(reminderHour: hour, reminderMinute: minute),
    );
  }

  /// Creates the default set of maintenance tasks for aquarium [aquariumId].
  ///
  /// [type] must be `'saltwater'` (default) or `'freshwater'`. Saltwater tanks
  /// get 10 tasks; freshwater tanks get 6 (the saltwater-specific tasks are
  /// omitted). Duplicate-creation errors from the backend are silently ignored
  /// so this method is safe to call on an already-initialised aquarium.
  Future<void> initializeDefaultTasks(
    int aquariumId, {
    String type = 'saltwater',
  }) async {
    final defaultTasks = MaintenanceTask.getDefaultTasks(
      aquariumId.toString(),
      type: type,
    );

    for (final task in defaultTasks) {
      try {
        await createTask(aquariumId, task);
      } catch (e) {
        // Silently skip if the task already exists.
      }
    }
  }

  /// Returns task counts grouped by status for aquarium [aquariumId].
  ///
  /// The returned map contains:
  /// - `'total'` — all tasks
  /// - `'pending'` — enabled tasks that are not overdue
  /// - `'overdue'` — enabled tasks that are past their due date
  /// - `'dueToday'` — enabled tasks due today
  /// - `'disabled'` — tasks with [MaintenanceTask.enabled] == `false`
  Future<Map<String, int>> getTaskStatistics(int aquariumId) async {
    final allTasks = await getAllTasks(aquariumId);

    return {
      'total': allTasks.length,
      'pending': allTasks.where((t) => !t.isOverdue && t.enabled).length,
      'overdue': allTasks.where((t) => t.isOverdue && t.enabled).length,
      'dueToday': allTasks.where((t) => t.isDueToday && t.enabled).length,
      'disabled': allTasks.where((t) => !t.enabled).length,
    };
  }
}
