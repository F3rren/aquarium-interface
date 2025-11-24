import 'dart:async';
import 'dart:math';

/// Classe per gestire retry automatici con backoff esponenziale
class RetryPolicy {
  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;
  final double multiplier;

  const RetryPolicy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(milliseconds: 500),
    this.maxDelay = const Duration(seconds: 10),
    this.multiplier = 2.0,
  });

  /// Esegue una funzione con retry automatico
  Future<T> execute<T>(
    Future<T> Function() fn, {
    bool Function(dynamic error)? shouldRetry,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (true) {
      attempt++;
      
      try {
        return await fn();
      } catch (e) {
        // Se abbiamo raggiunto il numero massimo di tentativi, rilancia l'errore
        if (attempt >= maxAttempts) {
          rethrow;
        }

        // Se c'è una funzione shouldRetry e ritorna false, rilancia
        if (shouldRetry != null && !shouldRetry(e)) {
          rethrow;
        }

        // Attendi prima di riprovare (backoff esponenziale)
        await Future.delayed(delay);
        
        // Calcola il prossimo delay con backoff esponenziale
        delay = Duration(
          milliseconds: min(
            (delay.inMilliseconds * multiplier).round(),
            maxDelay.inMilliseconds,
          ),
        );
      }
    }
  }
}

/// Policy predefinite
class RetryPolicies {
  /// Policy per richieste di rete normali
  static const network = RetryPolicy(
    maxAttempts: 3,
    initialDelay: Duration(milliseconds: 500),
    maxDelay: Duration(seconds: 5),
  );

  /// Policy per operazioni critiche
  static const critical = RetryPolicy(
    maxAttempts: 5,
    initialDelay: Duration(milliseconds: 300),
    maxDelay: Duration(seconds: 10),
  );

  /// Policy per operazioni non critiche
  static const nonCritical = RetryPolicy(
    maxAttempts: 2,
    initialDelay: Duration(seconds: 1),
    maxDelay: Duration(seconds: 3),
  );

  /// Nessun retry
  static const none = RetryPolicy(maxAttempts: 1);
}
