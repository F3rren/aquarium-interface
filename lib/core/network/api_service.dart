/// HTTP access layer for the ReefLife Spring Boot backend.
///
/// Provides the fundamental HTTP methods (GET, POST, PUT, PATCH, DELETE) with
/// centralised handling of:
/// - JWT authentication via [FlutterSecureStorage] (Android Keystore /
///   iOS Keychain);
/// - configurable per-request timeout ([defaultTimeout]);
/// - automatic retry via [RetryPolicy];
/// - decoding and normalisation of HTTP errors into typed exceptions
///   (see `core/utils/exceptions.dart`).
///
/// The base URL is composed from [Env.apiHost] / [Env.apiPort], injected at
/// build time via `--dart-define` (see `core/env/env.dart`). It is a public
/// endpoint, not a secret.
///
/// Instantiate once and share via Riverpod ([apiServiceProvider]) so that the
/// in-memory token cache and retry state are shared across all callers.
library;

import 'dart:convert';
import 'dart:async' as da;
import 'dart:io' show SocketException;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:acquariumfe/core/constants/api_endpoints.dart';
import 'package:acquariumfe/core/env/env.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import 'package:acquariumfe/core/utils/retry_policy.dart';

/// HTTP client for all calls to the ReefLife backend (Spring Boot on AWS ALB).
///
/// Exposes typed REST methods with timeout, automatic retry, and mapping of
/// HTTP errors to [AppException] subclasses. The JWT token is kept in
/// encrypted storage and cached in memory to minimise I/O reads.
///
/// Obtain via Riverpod — do not instantiate directly in service classes:
/// ```dart
/// final api = ref.read(apiServiceProvider);
/// ```
class ApiService {
  /// Creates an [ApiService] with optional custom [storage] and HTTP [client]
  /// backends.
  ///
  /// Production code should omit both to use the default [FlutterSecureStorage]
  /// (Android Keystore / iOS Keychain) and a real [http.Client]. Tests may pass
  /// mocks to avoid filesystem and network side-effects.
  ApiService({FlutterSecureStorage? storage, http.Client? client})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            ),
        _client = client ?? http.Client();

  /// Encrypted key-value storage backed by Android Keystore / iOS Keychain.
  final FlutterSecureStorage _storage;

  /// HTTP client used for every request. Injectable so tests can supply a
  /// `MockClient` instead of hitting the network.
  final http.Client _client;

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

  /// Base URL for the backend API, composed from [Env.apiHost] and
  /// [Env.apiPort] (injected at build time via `--dart-define`).
  ///
  /// This is a public endpoint, not a secret: it is visible in every TLS
  /// handshake and packet capture, so do not rely on obfuscation to hide it.
  static final String baseUrl = '${Env.apiHost}:${Env.apiPort}';

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

  NetworkException _toNetworkException(SocketException e, String endpoint) {
    final code = e.osError?.errorCode;
    final msg = e.osError?.message ?? e.message;
    // ECONNREFUSED (111 Linux, 61 macOS/iOS, 10061 Windows): server up but port not open.
    final isRefused = code == 111 || code == 61 || code == 10061 ||
        msg.toLowerCase().contains('connection refused');
    return NetworkException(
      isRefused
          ? 'Connection refused at $endpoint — check server port'
          : 'Cannot reach server at $endpoint',
      details: endpoint,
      originalError: e,
    );
  }

  /// Centralised request pipeline shared by [get], [post], [put], [patch] and
  /// [delete]: builds the URL and headers, dispatches the HTTP [method], applies
  /// the per-request [timeout] and [retry] policy, and maps transport failures
  /// (socket errors, timeouts, malformed JSON) to typed [AppException]s.
  Future<dynamic> _send(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Duration? timeout,
    required RetryPolicy retry,
    bool Function(dynamic error)? shouldRetry,
  }) {
    final effectiveTimeout = timeout ?? defaultTimeout;

    return retry.execute(
      () async {
        try {
          final url = Uri.parse('$baseUrl$endpoint');
          final headers = await _headers;
          final encodedBody = body == null ? null : jsonEncode(body);

          final response = await (switch (method) {
            'GET' => _client.get(url, headers: headers),
            'POST' => _client.post(url, headers: headers, body: encodedBody),
            'PUT' => _client.put(url, headers: headers, body: encodedBody),
            'PATCH' => _client.patch(url, headers: headers, body: encodedBody),
            'DELETE' => _client.delete(url, headers: headers),
            _ => throw ArgumentError('Unsupported HTTP method: $method'),
          }).timeout(effectiveTimeout);

          return _handleResponse(response);
        } on SocketException catch (e) {
          throw _toNetworkException(e, endpoint);
        } on da.TimeoutException catch (e) {
          throw TimeoutException(
            'Request timed out',
            timeout: effectiveTimeout,
            details: endpoint,
            originalError: e,
          );
        } on FormatException catch (e) {
          throw DataFormatException(
            'Invalid data format',
            details: endpoint,
            originalError: e,
          );
        }
      },
      shouldRetry: shouldRetry,
    );
  }

  /// Retry predicate for transient failures: network errors, timeouts, and 5xx
  /// server errors. 4xx client errors are never retried (they would fail again).
  static bool _retryOnTransient(dynamic error) {
    return error is NetworkException ||
        error is TimeoutException ||
        (error is ServerException &&
            error.statusCode != null &&
            error.statusCode! >= 500);
  }

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
  }) {
    return _send(
      'GET',
      endpoint,
      timeout: timeout,
      retry: retry ?? retryPolicy,
      shouldRetry: _retryOnTransient,
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
  }) {
    return _send(
      'POST',
      endpoint,
      body: body,
      timeout: timeout,
      retry: retry ?? RetryPolicies.none,
    );
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
  }) {
    return _send(
      'PUT',
      endpoint,
      body: body,
      timeout: timeout,
      retry: retry ?? RetryPolicies.none,
    );
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
  }) {
    return _send(
      'PATCH',
      endpoint,
      body: body,
      timeout: timeout,
      retry: retry ?? RetryPolicies.none,
    );
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
  }) {
    return _send(
      'DELETE',
      endpoint,
      timeout: timeout,
      retry: retry ?? RetryPolicies.none,
    );
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
  Future<Map<String, dynamic>> getMaintenanceData(int aquariumId) async {
    final response = await get(ApiEndpoints.maintenance(aquariumId));
    return response as Map<String, dynamic>;
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
          'Server response is not valid JSON',
          originalError: e,
        );
      }
    }

    // HTTP error — attempt to extract a human-readable message from the body.
    String errorMessage = 'Server error';
    Map<String, dynamic>? errorDetails;

    try {
      final errorBody = jsonDecode(response.body);
      if (errorBody is Map<String, dynamic>) {
        errorMessage =
            errorBody['message'] ??
            errorBody['error'] ??
            errorBody['errorMessage'] ??
            'Unknown error';
        errorDetails = errorBody;
      }
    } catch (e) {
      errorMessage = response.body.isNotEmpty
          ? response.body
          : 'Unknown error';
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
        details: 'Internal server error',
      );
    } else {
      throw AppError(errorMessage, details: 'Status code: $statusCode');
    }
  }
}
