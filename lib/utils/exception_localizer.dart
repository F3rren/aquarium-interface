import 'package:flutter/material.dart';
import 'package:acquariumfe/utils/exceptions.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

/// Helper per localizzare i messaggi delle eccezioni
class ExceptionLocalizer {
  /// Ottiene il messaggio localizzato per un'eccezione
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
      // ValidationException usa il suo messaggio originale
      return exception.message;
    } else {
      // Fallback al messaggio originale per altre eccezioni
      return exception.userMessage;
    }
  }
}
