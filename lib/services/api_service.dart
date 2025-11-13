import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Service per gestire le chiamate API al backend
class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Base URL dinamico basato sulla piattaforma
  static String get baseUrl {
    // Per testare in sviluppo, puoi cambiare qui
    const bool useLocalBackend = true; // Cambia a false per usare un server remoto
    
    // IP del tuo PC sulla rete locale (per dispositivi fisici)
    const String localIp = '10.10.1.182';
    
    if (useLocalBackend) {
      if (Platform.isAndroid) {
        return 'http://$localIp:4000/api';
      } else if (Platform.isIOS) {
        return 'http://$localIp:4000/api';
      } else {
        return 'http://localhost:4000/api';
      }
    } 
  }
  
  // Headers comuni per tutte le richieste
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': 'Bearer $token',
  };

  /// GET request generico
  Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// POST request generico
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request generico
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.put(
        url,
        headers: _headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request generico
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.delete(url, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Ottiene i dati di manutenzione per un acquario
  Future<Map<String, dynamic>> getMaintenanceData(String aquariumId) async {
    try {
      final response = await get('/aquariumslist/$aquariumId/maintenance');
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Gestisce la risposta HTTP
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      // Decodifica il JSON senza forzare il cast a Map
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }
}

/// Eccezione personalizzata per errori API
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
