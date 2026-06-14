/// Utility for translating [AppException] instances into localised UI strings.
library;

import 'package:flutter/material.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// Maps typed [AppException] subclasses to the corresponding ARB-localised
/// message string from [AppLocalizations].
///
/// This keeps i18n logic out of individual widgets and service classes. Prefer
/// [getMessage] in `catch` blocks (where the error is typed as `Object`); it
/// guarantees the user never sees a raw `toString()`.
class ExceptionLocalizer {
  /// Returns a localised, user-facing message for [error] regardless of its
  /// runtime type.
  ///
  /// Typed [AppException]s are routed through [getLocalizedMessage]; any other
  /// object (a plain `Exception`, a platform error, etc.) falls back to the
  /// generic localised `errorDescription`. The raw `error.toString()` is
  /// deliberately **never** returned — log it via `AppLogger` instead.
  ///
  /// Use this from catch blocks:
  /// ```dart
  /// } catch (e, st) {
  ///   AppLogger.e('save failed', error: e, stackTrace: st);
  ///   final msg = ExceptionLocalizer.getMessage(context, e);
  /// }
  /// ```
  static String getMessage(BuildContext context, Object error) {
    if (error is AppException) {
      return getLocalizedMessage(context, error);
    }
    return AppLocalizations.of(context)!.errorDescription;
  }

  /// Returns the localised error message for a typed [exception].
  ///
  /// Mapping:
  /// - [NetworkException]          → `l10n.networkError`
  /// - [ServerException]           → `l10n.serverError`
  /// - [AuthException]             → `l10n.sessionExpired`
  /// - [TimeoutException]          → `l10n.requestTimeout`
  /// - [DataFormatException]       → `l10n.invalidDataFormat`
  /// - [NoAquariumSelectedException] → `l10n.selectAquarium`
  /// - [ValidationException]        → the server-provided `message` (already
  ///   user-facing) when present, else the generic description
  /// - (any other subtype)         → `l10n.errorDescription`
  ///
  /// Note: [AppError] and other technical subtypes deliberately fall through to
  /// the generic description — their `message` is developer-facing and must not
  /// leak to the UI (log it via `AppLogger` instead).
  static String getLocalizedMessage(
    BuildContext context,
    AppException exception,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (exception is NetworkException) {
      return l10n.networkError;
    } else if (exception is ServerException) {
      return l10n.serverError;
    } else if (exception is AuthException) {
      return l10n.sessionExpired;
    } else if (exception is TimeoutException) {
      return l10n.requestTimeout;
    } else if (exception is DataFormatException) {
      return l10n.invalidDataFormat;
    } else if (exception is NoAquariumSelectedException) {
      return l10n.selectAquarium;
    } else if (exception is ValidationException) {
      // ValidationException carries a server-provided, already user-facing
      // message; prefer it when present, otherwise fall back to a generic
      // localised string rather than exposing an empty value.
      return exception.message.isNotEmpty
          ? exception.message
          : l10n.errorDescription;
    } else {
      // AppError, NotFoundException, CacheException and any unknown subtype:
      // show a generic localised message. Their `message` is technical /
      // developer-facing, so it must not be surfaced to the user.
      return l10n.errorDescription;
    }
  }
}
