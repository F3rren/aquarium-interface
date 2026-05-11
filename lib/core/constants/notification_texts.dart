/// Static notification copy for use in background isolates and contexts where
/// [BuildContext] is unavailable.
///
/// This class intentionally uses hard-coded Italian strings rather than
/// [AppLocalizations] because local notification callbacks run in a background
/// isolate that has no access to the widget tree or locale.
/// For widget-tree contexts prefer [NotificationTextsL10n] instead.
library;

/// Fallback (non-localised) notification titles, messages, and suggestions
/// for every monitored water parameter and maintenance reminder type.
class NotificationTexts {
  /// Maps parameter names (Italian keys matching the backend schema) to their
  /// out-of-range notification titles.
  static const Map<String, String> parameterTitles = {
    'Temperatura': 'Temperatura Anomala',
    'pH': 'pH Fuori Range',
    'Salinità': 'Salinità Anomala',
    'ORP': 'ORP Fuori Range',
    'Calcio': 'Calcio Anomalo',
    'Magnesio': 'Magnesio Anomalo',
    'KH': 'KH Fuori Range',
    'Nitrati': 'Nitrati Elevati',
    'Fosfati': 'Fosfati Elevati',
  };

  /// Notification body text when a parameter value is too high.
  static const Map<String, String> highMessages = {
    'Temperatura': 'La temperatura è troppo alta.',
    'pH': 'Il pH è troppo alto.',
    'Salinità': 'La salinità è troppo alta.',
    'ORP': 'L\'ORP è troppo alto.',
    'Calcio': 'Il calcio è troppo alto.',
    'Magnesio': 'Il magnesio è troppo alto.',
    'KH': 'Il KH è troppo alto.',
    'Nitrati': 'I nitrati sono troppo alti.',
    'Fosfati': 'I fosfati sono troppo alti.',
  };

  /// Notification body text when a parameter value is too low.
  static const Map<String, String> lowMessages = {
    'Temperatura': 'La temperatura è troppo bassa.',
    'pH': 'Il pH è troppo basso.',
    'Salinità': 'La salinità è troppo bassa.',
    'ORP': 'L\'ORP è troppo basso.',
    'Calcio': 'Il calcio è troppo basso.',
    'Magnesio': 'Il magnesio è troppo basso.',
    'KH': 'Il KH è troppo basso.',
    'Nitrati': 'I nitrati sono troppo bassi.',
    'Fosfati': 'I fosfati sono troppo bassi.',
  };

  /// Corrective action suggestions shown when a parameter is too high.
  static const Map<String, String> highSuggestions = {
    'Temperatura': 'Verifica il riscaldatore e la temperatura ambiente.',
    'pH': 'Controlla l\'aerazione e riduci l\'illuminazione.',
    'Salinità': 'Aggiungi acqua osmotica per diluire.',
    'ORP': 'Riduci l\'ossigenazione o controlla l\'ozonizzatore.',
    'Calcio': 'Riduci il dosaggio di integratori al calcio.',
    'Magnesio': 'Riduci il dosaggio di integratori al magnesio.',
    'KH': 'Riduci il dosaggio di buffer alcalini.',
    'Nitrati': 'Effettua un cambio d\'acqua e verifica il filtro.',
    'Fosfati': 'Effettua un cambio d\'acqua e usa resine anti-fosfati.',
  };

  /// Corrective action suggestions shown when a parameter is too low.
  static const Map<String, String> lowSuggestions = {
    'Temperatura': 'Verifica il funzionamento del riscaldatore.',
    'pH': 'Aumenta l\'aerazione e controlla il KH.',
    'Salinità': 'Aggiungi sale marino di qualità.',
    'ORP': 'Aumenta l\'ossigenazione o controlla lo skimmer.',
    'Calcio': 'Integra con soluzioni di calcio.',
    'Magnesio': 'Integra con soluzioni di magnesio.',
    'KH': 'Aggiungi buffer alcalini gradualmente',
    'Nitrati': 'Normale per acquari ben bilanciati',
    'Fosfati': 'Normale per acquari ben bilanciati',
  };

  // ── Maintenance reminder strings ──────────────────────────────────────────

  /// Generic title for maintenance reminder notifications.
  static const String maintenanceTitle = 'Promemoria Manutenzione';

  /// Body for a weekly maintenance reminder.
  static const String maintenanceWeekly = 'Manutenzione settimanale prevista';

  /// Body for a monthly maintenance reminder.
  static const String maintenanceMonthly = 'Manutenzione mensile prevista';

  /// Title for a water-change reminder notification.
  static const String waterChangeTitle = 'Promemoria: Cambio Acqua';

  /// Body for a water-change reminder notification.
  static const String waterChangeBody =
      'È tempo di cambiare l\'acqua dell\'acquario';

  /// Title for a filter-cleaning reminder notification.
  static const String filterCleaningTitle = 'Promemoria: Pulizia Filtro';

  /// Body for a filter-cleaning reminder notification.
  static const String filterCleaningBody =
      'Controlla e pulisci il filtro dell\'acquario';

  /// Title for a parameter-testing reminder notification.
  static const String parameterTestingTitle = 'Promemoria: Test Parametri';

  /// Body for a parameter-testing reminder notification.
  static const String parameterTestingBody =
      'Esegui i test dei parametri dell\'acqua';

  /// Title for a light-maintenance reminder notification.
  static const String lightMaintenanceTitle = 'Promemoria: Manutenzione Luci';

  /// Body for a light-maintenance reminder notification.
  static const String lightMaintenanceBody =
      'Controlla e pulisci le luci dell\'acquario';

  /// Detailed weekly maintenance checklist shown in the notification body.
  static const String maintenanceWeeklyDetails =
      'È ora di effettuare la manutenzione settimanale:\n'
      '• Cambio acqua 10-15%\n'
      '• Pulizia vetri\n'
      '• Test parametri\n'
      '• Controllo attrezzature';

  /// Detailed monthly maintenance checklist shown in the notification body.
  static const String maintenanceMonthlyDetails =
      'È ora di effettuare la manutenzione mensile:\n'
      '• Cambio acqua 20-25%\n'
      '• Pulizia filtro\n'
      '• Controllo pompe e riscaldatore\n'
      '• Verifica luci e timer\n'
      '• Test completo parametri';

  // ── Severity labels ────────────────────────────────────────────────────────

  /// Human-readable Italian labels for alert severity levels.
  static const Map<String, String> severityLabels = {
    'CRITICAL': 'CRITICO',
    'HIGH': 'ALTO',
    'MEDIUM': 'MEDIO',
    'LOW': 'BASSO',
  };

  /// Short descriptions explaining what each severity level requires.
  static const Map<String, String> severityDescriptions = {
    'CRITICAL': 'Richiede intervento immediato',
    'HIGH': 'Richiede attenzione prioritaria',
    'MEDIUM': 'Monitorare attentamente',
    'LOW': 'Situazione sotto controllo',
  };

  // ── Helper methods ─────────────────────────────────────────────────────────

  /// Returns the notification title for [parameter], falling back to a generic
  /// label if the parameter is not in [parameterTitles].
  static String getTitle(String parameter) {
    return parameterTitles[parameter] ?? 'Parametro Anomalo';
  }

  /// Returns the notification body for [parameter].
  ///
  /// [isHigh] selects between [highMessages] and [lowMessages].
  /// Falls back to a generic out-of-range message.
  static String getMessage(String parameter, bool isHigh) {
    final messages = isHigh ? highMessages : lowMessages;
    return messages[parameter] ?? 'Il parametro $parameter è fuori range';
  }

  /// Returns the corrective-action suggestion for [parameter].
  ///
  /// [isHigh] selects between [highSuggestions] and [lowSuggestions].
  static String getSuggestion(String parameter, bool isHigh) {
    final suggestions = isHigh ? highSuggestions : lowSuggestions;
    return suggestions[parameter] ??
        'Controlla il parametro e verifica le impostazioni';
  }

  /// Returns the Italian label for a severity level string (e.g. `'HIGH'`).
  /// Returns [severity] unchanged if not found in [severityLabels].
  static String getSeverityLabel(String severity) {
    return severityLabels[severity] ?? severity;
  }

  /// Returns the description for [severity]. Returns an empty string if not
  /// found in [severityDescriptions].
  static String getSeverityDescription(String severity) {
    return severityDescriptions[severity] ?? '';
  }
}
