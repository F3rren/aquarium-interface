import 'dart:convert';
import 'dart:async';
import 'dart:io' show SocketException;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:acquariumfe/utils/exceptions.dart';
import 'package:acquariumfe/utils/retry_policy.dart';

/// Service per gestire le chiamate API al backend Spring Boot
class ApiService {
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Secure storage per il token JWT (Android Keystore / iOS Keychain)
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const _tokenKey = 'jwt_token';

  // Cache in memoria per evitare letture ripetute dallo storage
  String? _cachedToken;

  // Timeout di default per le richieste
  Duration defaultTimeout = const Duration(seconds: 15);

  // Retry policy di default
  RetryPolicy retryPolicy = RetryPolicies.network;

  /// Persiste il token JWT nello storage cifrato e aggiorna la cache
  Future<void> setToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Rimuove il token da storage e cache (logout)
  Future<void> clearToken() async {
    _cachedToken = null;
    await _storage.delete(key: _tokenKey);
  }

  /// Legge il token: usa la cache, legge lo storage al cold start
  Future<String?> getToken() async {
    _cachedToken ??= await _storage.read(key: _tokenKey);
    return _cachedToken;
  }

  // Base URL iniettato a compile-time tramite --dart-define=API_BASE_URL=...
  // Default: server di sviluppo locale (sostituire con URL di produzione in release)
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://REDACTED',
  );

  // Headers comuni per tutte le richieste con token JWT
  Future<Map<String, String>> get _headers async {
    final token = await getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
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
              .get(url, headers: await _headers)
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
            (error is ServerException &&
                error.statusCode != null &&
                error.statusCode! >= 500);
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
    final effectiveRetry =
        retry ?? RetryPolicies.none; // POST non ha retry di default

    return effectiveRetry.execute(() async {
      try {
        final url = Uri.parse('$baseUrl$endpoint');

        final response = await http
            .post(url, headers: await _headers, body: jsonEncode(body))
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
    });
  }

  /// PUT request generico con retry automatico
  Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    Duration? timeout,
    RetryPolicy? retry,
  }) async {
    final effectiveTimeout = timeout ?? defaultTimeout;
    final effectiveRetry =
        retry ?? RetryPolicies.none; // PUT non ha retry di default

    return effectiveRetry.execute(() async {
      try {
        final url = Uri.parse('$baseUrl$endpoint');

        final response = await http
            .put(url, headers: await _headers, body: jsonEncode(body))
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
    });
  }

  /// PATCH request generico con retry automatico
  Future<dynamic> patch(
    String endpoint,
    Map<String, dynamic> body, {
    Duration? timeout,
    RetryPolicy? retry,
  }) async {
    final effectiveTimeout = timeout ?? defaultTimeout;
    final effectiveRetry =
        retry ?? RetryPolicies.none; // PATCH non ha retry di default

    return effectiveRetry.execute(() async {
      try {
        final url = Uri.parse('$baseUrl$endpoint');

        final response = await http
            .patch(url, headers: await _headers, body: jsonEncode(body))
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
    });
  }

  /// DELETE request generico con retry automatico
  Future<dynamic> delete(
    String endpoint, {
    Duration? timeout,
    RetryPolicy? retry,
  }) async {
    final effectiveTimeout = timeout ?? defaultTimeout;
    final effectiveRetry =
        retry ?? RetryPolicies.none; // DELETE non ha retry di default

    return effectiveRetry.execute(() async {
      try {
        final url = Uri.parse('$baseUrl$endpoint');

        final response = await http
            .delete(url, headers: await _headers)
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
    });
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
        errorMessage =
            errorBody['message'] ??
            errorBody['error'] ??
            errorBody['errorMessage'] ??
            'Errore sconosciuto';
        errorDetails = errorBody;
      }
    } catch (e) {
      errorMessage = response.body.isNotEmpty
          ? response.body
          : 'Errore sconosciuto';
    }

    // Lancia eccezioni specifiche basate sullo status code
    final statusCode = response.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      throw AuthException(errorMessage, details: 'Status code: $statusCode');
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
      throw AppError(errorMessage, details: 'Status code: $statusCode');
    }
  }
}
