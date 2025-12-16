/// Custom exceptions per una migliore gestione degli errori nell'app

library;

/// Exception base per errori dell'applicazione
abstract class AppException implements Exception {
  final String message;
  final String? details;
  final dynamic originalError;

  AppException(this.message, {this.details, this.originalError});

  @override
  String toString() {
    if (details != null) {
      return '$message: $details';
    }
    return message;
  }

  /// Messaggio user-friendly da mostrare all'utente
  String get userMessage => message;
}

/// Errori di rete
class NetworkException extends AppException {
  NetworkException(super.message, {super.details, super.originalError});

  @override
  String get userMessage =>
      'Errore di connessione. Verifica la tua connessione internet.';
}

/// Errori del server (5xx)
class ServerException extends AppException {
  final int? statusCode;

  ServerException(
    super.message, {
    this.statusCode,
    super.details,
    super.originalError,
  });

  @override
  String get userMessage =>
      'Il server ha riscontrato un problema. Riprova più tardi.';
}

/// Errori di validazione o richiesta errata (4xx)
class ValidationException extends AppException {
  final int? statusCode;
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

/// Errore di autenticazione
class AuthException extends AppException {
  AuthException(super.message, {super.details, super.originalError});

  @override
  String get userMessage => 'Sessione scaduta. Effettua nuovamente l\'accesso.';
}

/// Errore di timeout
class TimeoutException extends AppException {
  final Duration timeout;

  TimeoutException(
    super.message, {
    required this.timeout,
    super.details,
    super.originalError,
  });

  @override
  String get userMessage => 'La richiesta ha impiegato troppo tempo. Riprova.';
}

/// Errore di parsing dei dati
class DataFormatException extends AppException {
  DataFormatException(super.message, {super.details, super.originalError});

  @override
  String get userMessage => 'I dati ricevuti non sono nel formato atteso.';
}

/// Nessuna risorsa trovata (404)
class NotFoundException extends AppException {
  NotFoundException(super.message, {super.details, super.originalError});

  @override
  String get userMessage => 'Risorsa non trovata.';
}

/// Errore generico dell'applicazione
class AppError extends AppException {
  AppError(super.message, {super.details, super.originalError});
}

/// Errore quando nessun acquario è selezionato
class NoAquariumSelectedException extends AppException {
  NoAquariumSelectedException({
    String message = 'Nessun acquario selezionato',
    String? details,
  }) : super(message, details: details);

  @override
  String get userMessage => 'Seleziona un acquario prima di continuare.';
}

/// Errore di cache
class CacheException extends AppException {
  CacheException(super.message, {super.details, super.originalError});

  @override
  String get userMessage => 'Errore durante il caricamento dei dati locali.';
}
