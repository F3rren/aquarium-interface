/// Configurable retry logic with exponential back-off for async operations.
///
/// Use [RetryPolicy.execute] to wrap any `Future`-returning function that
/// may fail transiently (e.g. HTTP requests). Pre-built policies are
/// available in [RetryPolicies].
library;

import 'dart:async';
import 'dart:math';

/// Executes an async operation up to [maxAttempts] times, waiting between
/// retries with exponential back-off capped at [maxDelay].
///
/// The back-off formula is:
/// ```
/// nextDelay = min(currentDelay × multiplier, maxDelay)
/// ```
class RetryPolicy {
  /// Maximum number of attempts including the first try.
  /// A value of 1 means no retries.
  final int maxAttempts;

  /// Wait time before the second attempt (first retry).
  final Duration initialDelay;

  /// Upper bound for the back-off delay.
  final Duration maxDelay;

  /// Factor by which the delay grows on each consecutive failure.
  final double multiplier;

  const RetryPolicy({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(milliseconds: 500),
    this.maxDelay = const Duration(seconds: 10),
    this.multiplier = 2.0,
  });

  /// Runs [fn] repeatedly until it succeeds or [maxAttempts] is exhausted.
  ///
  /// Parameters:
  /// - [fn] — the async operation to attempt.
  /// - [shouldRetry] — optional predicate; if provided and returns `false`
  ///   for the thrown error, the error is rethrown immediately without
  ///   consuming remaining attempts.
  ///
  /// Returns the value produced by [fn] on success.
  /// Rethrows the last error when all attempts have been consumed.
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
        // No more attempts left — propagate the error.
        if (attempt >= maxAttempts) {
          rethrow;
        }

        // Caller explicitly said not to retry for this error type.
        if (shouldRetry != null && !shouldRetry(e)) {
          rethrow;
        }

        // Wait before the next attempt.
        await Future.delayed(delay);

        // Grow the delay for the next iteration (exponential back-off).
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

/// A collection of [RetryPolicy] presets covering the most common use cases.
class RetryPolicies {
  /// Suitable for ordinary network requests: 3 attempts, 500 ms initial delay,
  /// 5 s cap.
  static const network = RetryPolicy(
    maxAttempts: 3,
    initialDelay: Duration(milliseconds: 500),
    maxDelay: Duration(seconds: 5),
  );

  /// For operations where failure has a significant impact: 5 attempts,
  /// 300 ms initial delay, 10 s cap.
  static const critical = RetryPolicy(
    maxAttempts: 5,
    initialDelay: Duration(milliseconds: 300),
    maxDelay: Duration(seconds: 10),
  );

  /// For best-effort background operations: 2 attempts, 1 s initial delay,
  /// 3 s cap.
  static const nonCritical = RetryPolicy(
    maxAttempts: 2,
    initialDelay: Duration(seconds: 1),
    maxDelay: Duration(seconds: 3),
  );

  /// Executes exactly once with no retries. Useful for POST/PUT/DELETE
  /// operations that must not be duplicated.
  static const none = RetryPolicy(maxAttempts: 1);
}
