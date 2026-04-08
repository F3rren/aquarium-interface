/// HTTP access layer for the ReefLife Spring Boot backend.
///
/// Implements the **Singleton** pattern and provides the fundamental HTTP
/// methods (GET, POST, PUT, PATCH, DELETE) with centralised handling of:
/// - JWT authentication via [FlutterSecureStorage] (Android Keystore /
///   iOS Keychain);
/// - configurable per-request timeout ([defaultTimeout]);
/// - automatic retry via [RetryPolicy];
/// - decoding and normalisation of HTTP errors into typed exceptions
///   (see `lib/utils/exceptions.dart`).
///
/// The base URL is read at compile-time from `Env.apiBaseUrl` (envied with
/// XOR obfuscation), so it cannot be extracted with `strings` from the
/// released APK/IPA binary.
library;

import 'dart:convert';
import 'dart:async';
import 'dart:io' show SocketException;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:acquariumfe/env/env.dart';
import 'package:acquariumfe/utils/exceptions.dart';
import 'package:acquariumfe/utils/retry_policy.dart';

/// Singleton HTTP client for all calls to the ReefLife backend
/// (Spring Boot on AWS ALB).
///
/// Exposes typed REST methods with timeout, automatic retry, and mapping of
/// HTTP errors to [AppException] subclasses.  The JWT token is kept in
/// encrypted storage and cached in memory to minimise I/O reads.
///
/// Obtain the single instance via the default factory constructor:
/// ```dart
/// final api = ApiService();
/// ```
class ApiService {
  /// Private singleton instance, created once at class load time.
  static final ApiService _instance = ApiService._internal();

  /// Returns the unique singleton instance of [ApiService].
  factory ApiService() => _instance;

  /// Private named constructor used by the singleton initialiser.
  ApiService._internal();

  /// Encrypted key-value storage backed by Android Keystore /
  /// iOS Keychain, used to persist the JWT token across app restarts.
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Key used to read/write the JWT token in [FlutterSecureStorage].
  static const _tokenKey = 'jwt_token';

  /// In-memory cache of the JWT token.
  ///
  /// Populated on first access via [getToken] or immediately after [setToken]
  /// is called.  Set to `null` by [clearToken] to force a storage re-read on
  /// the next request.
  String? _cachedToken;

  /// Timeout applied to every HTTP request when no explicit [timeout]
  /// parameter is supplied.
  ///
  /// Can be overridden per-call by passing the [timeout] named argument to
  /// [get], [post], [put], [patch], or [delete].
  Duration defaultTimeout = const Duration(seconds: 15);

  /// Retry policy applied by default to GET requests (network errors and 5xx).
  ///
  /// Mutating write methods (POST, PUT, PATCH, DELETE) use
  /// [RetryPolicies.none] to avoid accidental duplicate mutations.
  RetryPolicy retryPolicy = RetryPolicies.network;

  /// Base URL for the backend API, read at compile-time from the envied
  /// generated class.
  ///
  /// The value is XOR-obfuscated in the binary — it cannot be extracted with
  /// `strings` on the APK/IPA.
  static final String baseUrl = Env.apiBaseUrl;

  // ---------------------------------------------------------------------------
  // Token management
  // ---------------------------------------------------------------------------

  /// Persists [token] in encrypted storage and updates the in-memory cache.
  ///
  /// Call this immediately after a successful login so that subsequent
  /// requests include the `Authorization: Bearer` header without further
  /// storage reads.
  ///
  /// [token] must be a valid, non-empty JWT string.
  Future<void> setToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Removes the JWT token from both encrypted storage and the in-memory
  /// cache.
  ///
  /// Call this on user logout.  Subsequent requests will be sent without an
  /// `Authorization` header until [setToken] is called again.
  Future<void> clearToken() async {
    _cachedToken = null;
    await _storage.delete(key: _tokenKey);
  }

  /// Returns the current JWT token, reading it from storage on cold start.
  ///
  /// Uses [_cachedToken] when available to avoid repeated encrypted-storage
  /// reads.  Returns `null` if no token has been persisted yet.
  Future<String?> getToken() async {
    _cachedToken ??= await _storage.read(key: _tokenKey);
    return _cachedToken;
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  /// Builds the common request headers for every outgoing request.
  ///
  /// Always includes `Content-Type: application/json` and
  /// `Accept: application/json`.  Appends `Authorization: Bearer <token>` if a
  /// token is available in cache or storage.
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

  // ---------------------------------------------------------------------------
  // HTTP verbs
  // ---------------------------------------------------------------------------

  /// Sends an HTTP GET request to [endpoint] and returns the decoded response.
  ///
  /// The request is automatically retried according to [retry] (defaults to
  /// [retryPolicy], which is [RetryPolicies.network]).  Retries are triggered
  /// for [NetworkException], [TimeoutException], and [ServerException] with a
  /// 5xx status code; they are **not** triggered for 4xx client errors.
  ///
  /// Parameters:
  /// - [endpoint]: path relative to [baseUrl] (e.g. `/aquariums/1/parameters`).
  /// - [timeout]: per-request timeout; falls back to [defaultTimeout].
  /// - [retry]: per-request retry policy; falls back to [retryPolicy].
  ///
  /// Returns the JSON-decoded response body (`Map`, `List`, or a scalar).
  ///
  /// Throws:
  /// - [NetworkException] if a [SocketException] occurs.
  /// - [TimeoutException] if the request exceeds [timeout].
  /// - [DataFormatException] if the response body is not valid JSON.
  /// - [AuthException] on HTTP 401/403.
  /// - [NotFoundException] on HTTP 404.
  /// - [ValidationException] on other 4xx responses.
  /// - [ServerException] on 5xx responses.
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
        // Retry only for network/timeout errors and 5xx server errors,
        // never for 4xx client errors which would fail again.
        return error is NetworkException ||
            error is TimeoutException ||
            (error is ServerException &&
                error.statusCode != null &&
                error.statusCode! >= 500);
      },
    );
  }

  /// Sends an HTTP POST request to [endpoint] with the JSON-encoded [body].
  ///
  /// Uses [RetryPolicies.none] by default to avoid accidental duplicate
  /// resource creation.  Pass an explicit [retry] policy to override this.
  ///
  /// Parameters:
  /// - [endpoint]: path relative to [baseUrl].
  /// - [body]: request payload; will be JSON-encoded.
  /// - [timeout]: per-request timeout; falls back to [defaultTimeout].
  /// - [retry]: per-request retry policy; defaults to [RetryPolicies.none].
  ///
  /// Returns the JSON-decoded response body.
  ///
  /// Throws:
  /// - [NetworkException], [TimeoutException], [DataFormatException],
  ///   [AuthException], [NotFoundException], [ValidationException],
  ///   [ServerException] — same semantics as [get].
  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    Duration? timeout,
    RetryPolicy? retry,
  }) async {
    final effectiveTimeout = timeout ?? defaultTimeout;
    final effectiveRetry =
        retry ?? RetryPolicies.none; // POST has no retry by default

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

  /// Sends an HTTP PUT request to [endpoint] with the JSON-encoded [body].
  ///
  /// Uses [RetryPolicies.none] by default; pass an explicit [retry] policy to
  /// override.  Intended for full resource replacements.
  ///
  /// Parameters:
  /// - [endpoint]: path relative to [baseUrl].
  /// - [body]: complete replacement payload; will be JSON-encoded.
  /// - [timeout]: per-request timeout; falls back to [defaultTimeout].
  /// - [retry]: per-request retry policy; defaults to [RetryPolicies.none].
  ///
  /// Returns the JSON-decoded response body.
  ///
  /// Throws the same exception types as [get].
  Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> body, {
    Duration? timeout,
    RetryPolicy? retry,
  }) async {
    final effectiveTimeout = timeout ?? defaultTimeout;
    final effectiveRetry =
        retry ?? RetryPolicies.none; // PUT has no retry by default

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

  /// Sends an HTTP PATCH request to [endpoint] with the JSON-encoded [body].
  ///
  /// Uses [RetryPolicies.none] by default; pass an explicit [retry] policy to
  /// override.  Intended for partial resource updates (e.g. toggling a flag,
  /// updating a single field).
  ///
  /// Parameters:
  /// - [endpoint]: path relative to [baseUrl].
  /// - [body]: partial update payload; will be JSON-encoded.
  /// - [timeout]: per-request timeout; falls back to [defaultTimeout].
  /// - [retry]: per-request retry policy; defaults to [RetryPolicies.none].
  ///
  /// Returns the JSON-decoded response body.
  ///
  /// Throws the same exception types as [get].
  Future<dynamic> patch(
    String endpoint,
    Map<String, dynamic> body, {
    Duration? timeout,
    RetryPolicy? retry,
  }) async {
    final effectiveTimeout = timeout ?? defaultTimeout;
    final effectiveRetry =
        retry ?? RetryPolicies.none; // PATCH has no retry by default

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

  /// Sends an HTTP DELETE request to [endpoint].
  ///
  /// Uses [RetryPolicies.none] by default; pass an explicit [retry] policy to
  /// override.
  ///
  /// Parameters:
  /// - [endpoint]: path relative to [baseUrl].
  /// - [timeout]: per-request timeout; falls back to [defaultTimeout].
  /// - [retry]: per-request retry policy; defaults to [RetryPolicies.none].
  ///
  /// Returns the JSON-decoded response body (or `{'success': true}` on empty
  /// 2xx bodies).
  ///
  /// Throws the same exception types as [get].
  Future<dynamic> delete(
    String endpoint, {
    Duration? timeout,
    RetryPolicy? retry,
  }) async {
    final effectiveTimeout = timeout ?? defaultTimeout;
    final effectiveRetry =
        retry ?? RetryPolicies.none; // DELETE has no retry by default

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

  // ---------------------------------------------------------------------------
  // Convenience helpers
  // ---------------------------------------------------------------------------

  /// Fetches the aggregated maintenance data for the aquarium identified by
  /// [aquariumId].
  ///
  /// Delegates to [get] with the endpoint `/aquariums/{aquariumId}/maintenance`.
  ///
  /// Returns a [Map] containing maintenance summary fields as returned by the
  /// backend.
  ///
  /// Throws any exception that [get] may throw.
  Future<Map<String, dynamic>> getMaintenanceData(String aquariumId) async {
    try {
      final response = await get('/aquariums/$aquariumId/maintenance');
      return response as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Response handling
  // ---------------------------------------------------------------------------

  /// Parses an [http.Response] and returns the decoded body on success, or
  /// throws a typed exception on error.
  ///
  /// Success is defined as HTTP status codes in the 200–299 range.  An empty
  /// body is normalised to `{'success': true}`.
  ///
  /// HTTP error mapping:
  /// - 401 / 403 → [AuthException]
  /// - 404       → [NotFoundException]
  /// - 4xx       → [ValidationException] (carries raw [errorDetails] map)
  /// - 5xx       → [ServerException] (carries [statusCode])
  /// - Other     → [AppError]
  ///
  /// The error message is extracted from the Spring Boot error body by probing
  /// the keys `message`, `error`, and `errorMessage` in that order.
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

    // HTTP error — attempt to extract a human-readable message from the body.
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
