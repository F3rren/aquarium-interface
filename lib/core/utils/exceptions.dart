/// Custom exception hierarchy for structured error handling across the app.
///
/// All exceptions extend [AppException] which carries a human-readable
/// [message], optional [details] for debugging, and the [originalError] that
/// caused this exception. Callers can pattern-match on the subtype to decide
/// whether to show a retry UI, redirect to login, etc.
library;

/// Base class for all application-level exceptions.
///
/// Implements [Exception] so it can be thrown and caught like a standard Dart
/// exception. Subclasses override [userMessage] to return a localised,
/// user-facing string safe to show in the UI.
abstract class AppException implements Exception {
  /// Technical error description (may include endpoint or internal details).
  final String message;

  /// Additional context useful for debugging (e.g. HTTP status code, path).
  final String? details;

  /// The original underlying error or exception, if any.
  final dynamic originalError;

  AppException(this.message, {this.details, this.originalError});

  @override
  String toString() {
    if (details != null) {
      return '$message: $details';
    }
    return message;
  }

  /// User-facing message safe to display in the UI.
  ///
  /// Override in subclasses to return a localised, friendly string.
  String get userMessage => message;
}

/// Thrown when the device cannot reach the backend (no network, DNS failure,
/// refused connection, etc.).
class NetworkException extends AppException {
  NetworkException(super.message, {super.details, super.originalError});

  @override
  String get userMessage =>
      'Connection error. Please check your internet connection.';
}

/// Thrown when the backend returns a 5xx response, indicating a server-side
/// failure unrelated to the client request.
class ServerException extends AppException {
  /// HTTP status code returned by the server (e.g. 500, 503).
  final int? statusCode;

  ServerException(
    super.message, {
    this.statusCode,
    super.details,
    super.originalError,
  });

  @override
  String get userMessage =>
      'The server encountered a problem. Please try again later.';
}

/// Thrown when the backend returns a 4xx response (except 401/403/404),
/// typically indicating a bad request or business-rule violation.
class ValidationException extends AppException {
  /// HTTP status code (e.g. 400, 422).
  final int? statusCode;

  /// Field-level validation errors returned by the backend, if present.
  final Map<String, dynamic>? errors;

  ValidationException(
    super.message, {
    this.statusCode,
    this.errors,
    super.details,
    super.originalError,
  });

  @override
  String get userMessage => message;
}

/// Thrown when the backend returns 401 or 403, meaning the JWT token is
/// invalid, expired, or the user lacks the required permissions.
class AuthException extends AppException {
  AuthException(super.message, {super.details, super.originalError});

  @override
  String get userMessage => 'Session expired. Please log in again.';
}

/// Thrown when an HTTP request exceeds [ApiService.defaultTimeout].
class TimeoutException extends AppException {
  /// The timeout duration that was exceeded.
  final Duration timeout;

  TimeoutException(
    super.message, {
    required this.timeout,
    super.details,
    super.originalError,
  });

  @override
  String get userMessage => 'The request took too long. Please try again.';
}

/// Thrown when a JSON response cannot be decoded or a required field is
/// missing / has an unexpected type.
class DataFormatException extends AppException {
  DataFormatException(super.message, {super.details, super.originalError});

  @override
  String get userMessage => 'The data received was in an unexpected format.';
}

/// Thrown when the backend returns 404 for a specific resource.
class NotFoundException extends AppException {
  NotFoundException(super.message, {super.details, super.originalError});

  @override
  String get userMessage => 'Resource not found.';
}

/// Generic application-level error for cases not covered by the specific
/// subclasses above.
class AppError extends AppException {
  AppError(super.message, {super.details, super.originalError});
}

/// Thrown when an operation requires a selected aquarium but none is currently
/// active in [currentAquariumProvider].
class NoAquariumSelectedException extends AppException {
  NoAquariumSelectedException({
    String message = 'No aquarium selected',
    String? details,
  }) : super(message, details: details);

  @override
  String get userMessage => 'Please select an aquarium before continuing.';
}

/// Thrown when reading from or writing to a local cache fails.
class CacheException extends AppException {
  CacheException(super.message, {super.details, super.originalError});

  @override
  String get userMessage => 'Error loading local data.';
}
