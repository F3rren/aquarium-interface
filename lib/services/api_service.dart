import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

/// Service per gestire le chiamate API al backend Spring Boot
class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Token JWT per autenticazione
  String? _token;
  
  void setToken(String token) => _token = token;
  void clearToken() => _token = null;

  // Base URL dinamico basato sulla piattaforma
  static String get baseUrl {
    // Per testare in sviluppo, puoi cambiare qui
    const bool useLocalBackend = true; // Cambia a false per usare un server remoto
    
    if (useLocalBackend) {
      if (Platform.isAndroid) {
        // Per Android Emulator usa 10.0.2.2
        //return 'http://192.168.1.10:8080/api';
        // Per dispositivo fisico Android, decommentare e inserire IP del PC:
         return 'http://10.10.1.182:8080/api';
      } else if (Platform.isIOS) {
        // iOS Simulator può usare localhost
        return 'http://localhost:8080/api';
      } else {
        // Desktop/Web
        return 'http://localhost:8080/api';
      }
    } else {
      // Server remoto di produzione
      return 'http://192.168.1.10:8080/api';
    }
  }
  
  // Headers comuni per tutte le richieste con token JWT
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  /// GET request generico con timeout
  Future<dynamic> get(String endpoint, {Duration timeout = const Duration(seconds: 10)}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      
      final response = await http
          .get(url, headers: _headers)
          .timeout(timeout);
          
      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        statusCode: 0,
        message: 'Nessuna connessione internet',
      );
    } on TimeoutException {
      throw ApiException(
        statusCode: 0,
        message: 'Timeout - Il server non risponde',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// POST request generico
  Future<dynamic> post(String endpoint, Map<String, dynamic> body, {Duration timeout = const Duration(seconds: 10)}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      
      final response = await http
          .post(
            url,
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);
          
      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        statusCode: 0,
        message: 'Nessuna connessione internet',
      );
    } on TimeoutException {
      throw ApiException(
        statusCode: 0,
        message: 'Timeout - Il server non risponde',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request generico
  Future<dynamic> put(String endpoint, Map<String, dynamic> body, {Duration timeout = const Duration(seconds: 10)}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      
      final response = await http
          .put(
            url,
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);
          
      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        statusCode: 0,
        message: 'Nessuna connessione internet',
      );
    } on TimeoutException {
      throw ApiException(
        statusCode: 0,
        message: 'Timeout - Il server non risponde',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request generico
  Future<dynamic> delete(String endpoint, {Duration timeout = const Duration(seconds: 10)}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      
      final response = await http
          .delete(url, headers: _headers)
          .timeout(timeout);
          
      return _handleResponse(response);
    } on SocketException {
      throw ApiException(
        statusCode: 0,
        message: 'Nessuna connessione internet',
      );
    } on TimeoutException {
      throw ApiException(
        statusCode: 0,
        message: 'Timeout - Il server non risponde',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Ottiene i dati di manutenzione per un acquario
  Future<Map<String, dynamic>> getMaintenanceData(String aquariumId) async {
    try {
      final response = await get('/aquariums/$aquariumId/maintenance');
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Gestisce la risposta HTTP (gestione errori Spring Boot)
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      // Decodifica il JSON senza forzare il cast a Map
      return jsonDecode(response.body);
    } else {
      // Spring Boot restituisce errori in un formato specifico
      String errorMessage = 'Errore del server';
      
      try {
        final errorBody = jsonDecode(response.body);
        // Spring Boot standard error response
        errorMessage = errorBody['message'] ?? 
                      errorBody['error'] ?? 
                      errorBody['errorMessage'] ??
                      'Errore sconosciuto';
      } catch (e) {
        errorMessage = response.body;
      }
      
      throw ApiException(
        statusCode: response.statusCode,
        message: errorMessage,
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
  
  /// Messaggio user-friendly basato sullo status code
  String get userFriendlyMessage {
    switch (statusCode) {
      case 0:
        return message; // Errori di rete già formattati
      case 400:
        return 'Richiesta non valida: $message';
      case 401:
        return 'Non autorizzato - Effettua il login';
      case 403:
        return 'Accesso negato';
      case 404:
        return 'Risorsa non trovata';
      case 500:
        return 'Errore del server';
      default:
        return message;
    }
  }
}

