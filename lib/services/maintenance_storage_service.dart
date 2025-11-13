import 'dart:convert';
import 'package:acquariumfe/models/maintenance_task.dart';
import 'package:acquariumfe/models/maintenance_log.dart';
import 'package:acquariumfe/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servizio di storage per task e log di manutenzione
class MaintenanceStorageService {
  static const String _tasksKey = 'maintenance_tasks';
  static const String _logsKey = 'maintenance_logs';
  final ApiService _apiService = ApiService();

  /// Carica task dall'API di Mockoon per un acquario specifico
  Future<List<MaintenanceTask>> loadTasksFromApi(String aquariumId) async {
    try {
      print('🔄 Caricamento task da API per acquario: $aquariumId');
      final data = await _apiService.getMaintenanceData(aquariumId);
      
      print('📦 Risposta API ricevuta: ${data.keys}');
      
      if (data['tasks'] == null) {
        print('⚠️ Nessun campo "tasks" nella risposta API');
        return [];
      }

      final List<dynamic> tasksJson = data['tasks'];
      print('✅ Caricati ${tasksJson.length} task da API');
      return tasksJson.map((json) => MaintenanceTask.fromJson(json)).toList();
    } catch (e) {
      print('❌ Errore caricamento task da API: $e');
      print('⚠️ Fallback: uso storage locale');
      // Fallback a storage locale se API non disponibile
      return await loadTasks();
    }
  }

  /// Carica log dall'API di Mockoon per un acquario specifico
  Future<List<MaintenanceLog>> loadLogsFromApi(String aquariumId) async {
    try {
      print('🔄 Caricamento log da API per acquario: $aquariumId');
      final data = await _apiService.getMaintenanceData(aquariumId);
      
      if (data['logs'] == null) {
        print('⚠️ Nessun campo "logs" nella risposta API');
        return [];
      }

      final List<dynamic> logsJson = data['logs'];
      print('✅ Caricati ${logsJson.length} log da API');
      return logsJson.map((json) => MaintenanceLog.fromJson(json)).toList();
    } catch (e) {
      print('❌ Errore caricamento log da API: $e');
      print('⚠️ Fallback: uso storage locale');
      // Fallback a storage locale se API non disponibile
      return await loadLogs();
    }
  }

  /// Carica tutti i task salvati localmente (deprecato - usa loadTasksFromApi)
  Future<List<MaintenanceTask>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getString(_tasksKey);
      
      if (tasksJson == null || tasksJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(tasksJson);
      return decoded.map((json) => MaintenanceTask.fromJson(json)).toList();
    } catch (e) {
      print('Errore caricamento task: $e');
      return [];
    }
  }

  /// Carica task di un acquario specifico
  Future<List<MaintenanceTask>> loadTasksByAquarium(String aquariumId) async {
    final allTasks = await loadTasks();
    return allTasks.where((task) => task.aquariumId == aquariumId).toList();
  }

  /// Salva tutti i task
  Future<bool> saveTasks(List<MaintenanceTask> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = jsonEncode(tasks.map((t) => t.toJson()).toList());
      return await prefs.setString(_tasksKey, tasksJson);
    } catch (e) {
      print('Errore salvataggio task: $e');
      return false;
    }
  }

  /// Carica tutti i log
  Future<List<MaintenanceLog>> loadLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logsJson = prefs.getString(_logsKey);
      
      if (logsJson == null || logsJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(logsJson);
      return decoded.map((json) => MaintenanceLog.fromJson(json)).toList();
    } catch (e) {
      print('Errore caricamento log: $e');
      return [];
    }
  }

  /// Carica log di un task specifico
  Future<List<MaintenanceLog>> loadLogsByTask(String taskId) async {
    final allLogs = await loadLogs();
    return allLogs.where((log) => log.taskId == taskId).toList();
  }

  /// Salva tutti i log
  Future<bool> saveLogs(List<MaintenanceLog> logs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logsJson = jsonEncode(logs.map((l) => l.toJson()).toList());
      return await prefs.setString(_logsKey, logsJson);
    } catch (e) {
      print('Errore salvataggio log: $e');
      return false;
    }
  }

  /// Cancella tutti i task (per reset)
  Future<bool> clearTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_tasksKey);
    } catch (e) {
      print('Errore cancellazione task: $e');
      return false;
    }
  }

  /// Cancella tutti i log (per reset)
  Future<bool> clearLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_logsKey);
    } catch (e) {
      print('Errore cancellazione log: $e');
      return false;
    }
  }

  /// Cancella dati di un acquario specifico
  Future<bool> clearAquariumData(String aquariumId) async {
    try {
      // Carica task e rimuovi quelli dell'acquario
      final allTasks = await loadTasks();
      final remainingTasks = allTasks.where((t) => t.aquariumId != aquariumId).toList();
      await saveTasks(remainingTasks);

      // Carica log e rimuovi quelli relativi ai task dell'acquario
      final allLogs = await loadLogs();
      final taskIds = allTasks.where((t) => t.aquariumId == aquariumId).map((t) => t.id).toSet();
      final remainingLogs = allLogs.where((l) => !taskIds.contains(l.taskId)).toList();
      await saveLogs(remainingLogs);

      return true;
    } catch (e) {
      print('Errore cancellazione dati acquario: $e');
      return false;
    }
  }

  /// Esporta dati in formato JSON (per backup/debug)
  Future<Map<String, dynamic>> exportData() async {
    final tasks = await loadTasks();
    final logs = await loadLogs();
    
    return {
      'version': '1.0.0',
      'exportDate': DateTime.now().toIso8601String(),
      'tasks': tasks.map((t) => t.toJson()).toList(),
      'logs': logs.map((l) => l.toJson()).toList(),
    };
  }

  /// Importa dati da JSON (per restore/debug)
  Future<bool> importData(Map<String, dynamic> data) async {
    try {
      final tasksData = data['tasks'] as List<dynamic>;
      final logsData = data['logs'] as List<dynamic>;
      
      final tasks = tasksData.map((json) => MaintenanceTask.fromJson(json)).toList();
      final logs = logsData.map((json) => MaintenanceLog.fromJson(json)).toList();
      
      await saveTasks(tasks);
      await saveLogs(logs);
      
      return true;
    } catch (e) {
      print('Errore import dati: $e');
      return false;
    }
  }
}
