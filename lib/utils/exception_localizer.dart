/// Utility for translating [AppException] instances into localised UI strings.
library;

import 'package:flutter/material.dart';
import 'package:acquariumfe/utils/exceptions.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

/// Maps typed [AppException] subclasses to the corresponding ARB-localised
/// message string from [AppLocalizations].
///
/// This keeps i18n logic out of individual widgets and service classes.
class ExceptionLocalizer {
  /// Returns the localised error message for [exception] using the
  /// [AppLocalizations] instance from the current [BuildContext].
  ///
  /// Mapping:
  /// - [NetworkException]     → `l10n.networkError`
  /// - [ServerException]      → `l10n.serverError`
  /// - [AuthException]        → `l10n.sessionExpired`
  /// - [TimeoutException]     → `l10n.requestTimeout`
  /// - [DataFormatException]  → `l10n.invalidDataFormat`
  /// - [ValidationException]  → the original `exception.message` (already user-facing)
  /// - (other)                → `exception.userMessage`
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
    } else if (exception is ValidationException) {
      // ValidationException already carries a user-facing server message.
      return exception.message;
    } else {
      // Fall back to the exception's own user message for unknown subtypes.
      return exception.userMessage;
    }
  }
}
