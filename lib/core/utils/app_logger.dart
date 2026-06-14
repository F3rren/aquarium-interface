/// Centralised application logger.
///
/// Thin facade over the `logger` package so every layer logs through a single
/// configured sink instead of constructing ad-hoc [Logger] instances. Use the
/// static [d] / [i] / [w] / [e] helpers and pass the caught [error] and
/// [stackTrace] so the underlying printer can render them.
///
/// This is the place to make a swallowed-but-recoverable failure *visible to
/// developers*: when a `catch` block degrades gracefully (returns a cached or
/// empty value instead of rethrowing) it should still call [AppLogger.w] / [e]
/// so the failure is never truly silent. User-facing messages are a separate
/// concern — translate those via `ExceptionLocalizer`.
library;

import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:logger/logger.dart';

/// Static facade exposing the shared [Logger] instance.
class AppLogger {
  AppLogger._();

  /// Shared logger. In release builds the threshold is raised to
  /// [Level.warning] so debug/info chatter is dropped while warnings and errors
  /// still surface in platform logs (logcat / Console).
  static final Logger _logger = Logger(
    level: kReleaseMode ? Level.warning : Level.debug,
  );

  /// Logs a debug-level [message] (development diagnostics).
  static void d(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  /// Logs an info-level [message] (notable but expected events).
  static void i(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  /// Logs a warning-level [message] — a recoverable failure that was handled
  /// (e.g. a background refresh that fell back to the last known value).
  static void w(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.w(message, error: error, stackTrace: stackTrace);

  /// Logs an error-level [message] — an unexpected failure worth investigating.
  static void e(String message, {Object? error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}
