import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:acquariumfe/utils/exceptions.dart';
import 'package:acquariumfe/utils/retry_policy.dart';

/// Service per gestire le chiamate API al backend Spring Boot
class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Token JWT per autenticazione
  String? _token;
  
  // Timeout di default per le richieste
  Duration defaultTimeout = const Duration(seconds: 15);
  
  // Retry policy di default
  RetryPolicy retryPolicy = RetryPolicies.network;
  
  void setToken(String token) => _token = token;
  void clearToken() => _token = null;

  // Base URL dinamico basato sulla piattaforma
  static String get baseUrl {
    // Per Android dispositivo fisico, usa l'IP del PC
    if (Platform.isAndroid) {
      return 'http://10.10.1.182:8080';
    } else if (Platform.isIOS) {
      // iOS Simulator può usare localhost
      return 'http://localhost:8080';
    } else {
      // Desktop/Web
      return 'http://localhost:8080';
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

  /// GET request generico con timeout e retry automatico
  Future<dynamic> get(
    String endpoint, {
    Duration? timeout,
    RetryPolicy? retry,
  }) async {
    final effectiveTimeout = timeout ?? defaultTimeout;
    final effectiveRetry = retry ?? retryPolicy;

    return effectiveRetry.execute(
      () async {
        try {
          final url = Uri.parse('$baseUrl$endpoint');
          
          final response = await http
              .get(url, headers: _headers)
              .timeout(effectiveTimeout);
              
          return _handleResponse(response);
        } on SocketException catch (e) {
          throw NetworkException(
            'Impossibile connettersi al server',
            details: endpoint,
            originalError: e,
          );
        } on TimeoutException catch (e) {
          throw TimeoutException(
            'La richiesta ha impiegato troppo tempo',
            timeout: effectiveTimeout,
            details: endpoint,
            originalError: e,
          );
        } on FormatException catch (e) {
          throw DataFormatException(
            'Errore nel formato dei dati',
            details: endpoint,
            originalError: e,
          );
        }
      },
      shouldRetry: (error) {
        // Retry solo per errori di rete, non per errori 4xx
        return error is NetworkException || 
               error is TimeoutException ||
               (error is ServerException && error.statusCode != null && error.statusCode! >= 500);
      },
    );
  }

  /// POST request generico con retry automatico
  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    Duration? timeout,
    RetryPolicy? retry,
  }) async {
    final effectiveTimeout = timeout ?? defaultTimeout;
    final effectiveRetry = retry ?? RetryPolicies.none; // POST non ha retry di default

    return effectiveRetry.execute(
      () async {
        try {
          final url = Uri.parse('$baseUrl$endpoint');
          
          final response = await http
              .post(
                url,
                headers: _headers,
                body: jsonEncode(body),
              )
              .timeout(effectiveTimeout);
              
          return _handleResponse(response);
        } on SocketException catch (e) {
          throw NetworkException(
            'Impossibile connettersi al server',
            details: endpoint,
            originalError: e,
          );
        } on TimeoutException catch (e) {
          throw TimeoutException(
            'La richiesta ha impiegato troppo tempo',
            timeout: effectiveTimeout,
            details: endpoint,
            originalError: e,
          );
        } on FormatException catch (e) {
          throw DataFormatException(
            'Errore nel formato dei dati',
            details: endpoint,
            originalError: e,
          );
        }
      },
    );
  }

  /// PUT request generico con retry automatico
  Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    Duration? timeout,
    RetryPolicy? retry,
  }) async {
    final effectiveTimeout = timeout ?? defaultTimeout;
    final effectiveRetry = retry ?? RetryPolicies.none; // PUT non ha retry di default

    return effectiveRetry.execute(
      () async {
        try {
          final url = Uri.parse('$baseUrl$endpoint');
          
          final response = await http
              .put(
                url,
                headers: _headers,
                body: jsonEncode(body),
              )
              .timeout(effectiveTimeout);
              
          return _handleResponse(response);
        } on SocketException catch (e) {
          throw NetworkException(
            'Impossibile connettersi al server',
            details: endpoint,
            originalError: e,
          );
        } on TimeoutException catch (e) {
          throw TimeoutException(
            'La richiesta ha impiegato troppo tempo',
            timeout: effectiveTimeout,
            details: endpoint,
            originalError: e,
          );
        } on FormatException catch (e) {
          throw DataFormatException(
            'Errore nel formato dei dati',
            details: endpoint,
            originalError: e,
          );
        }
      },
    );
  }

  /// DELETE request generico con retry automatico
  Future<dynamic> delete(
    String endpoint, {
    Duration? timeout,
    RetryPolicy? retry,
  }) async {
    final effectiveTimeout = timeout ?? defaultTimeout;
    final effectiveRetry = retry ?? RetryPolicies.none; // DELETE non ha retry di default

    return effectiveRetry.execute(
      () async {
        try {
          final url = Uri.parse('$baseUrl$endpoint');
          
          final response = await http
              .delete(url, headers: _headers)
              .timeout(effectiveTimeout);
              
          return _handleResponse(response);
        } on SocketException catch (e) {
          throw NetworkException(
            'Impossibile connettersi al server',
            details: endpoint,
            originalError: e,
          );
        } on TimeoutException catch (e) {
          throw TimeoutException(
            'La richiesta ha impiegato troppo tempo',
            timeout: effectiveTimeout,
            details: endpoint,
            originalError: e,
          );
        } on FormatException catch (e) {
          throw DataFormatException(
            'Errore nel formato dei dati',
            details: endpoint,
            originalError: e,
          );
        }
      },
    );
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
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw DataFormatException(
          'Risposta dal server non in formato JSON valido',
          originalError: e,
        );
      }
    }

    // Gestione errori HTTP
    String errorMessage = 'Errore del server';
    Map<String, dynamic>? errorDetails;
    
    try {
      final errorBody = jsonDecode(response.body);
      if (errorBody is Map<String, dynamic>) {
        errorMessage = errorBody['message'] ?? 
                      errorBody['error'] ?? 
                      errorBody['errorMessage'] ??
                      'Errore sconosciuto';
        errorDetails = errorBody;
      }
    } catch (e) {
      errorMessage = response.body.isNotEmpty ? response.body : 'Errore sconosciuto';
    }
    
    // Lancia eccezioni specifiche basate sullo status code
    final statusCode = response.statusCode;
    
    if (statusCode == 401 || statusCode == 403) {
      throw AuthException(
        errorMessage,
        details: 'Status code: $statusCode',
      );
    } else if (statusCode == 404) {
      throw NotFoundException(
        errorMessage,
        details: 'Status code: $statusCode',
      );
    } else if (statusCode >= 400 && statusCode < 500) {
      throw ValidationException(
        errorMessage,
        statusCode: statusCode,
        errors: errorDetails,
      );
    } else if (statusCode >= 500) {
      throw ServerException(
        errorMessage,
        statusCode: statusCode,
        details: 'Errore interno del server',
      );
    } else {
      throw AppError(
        errorMessage,
        details: 'Status code: $statusCode',
      );
    }
  }
}