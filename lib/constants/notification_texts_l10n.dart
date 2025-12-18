import 'package:acquariumfe/l10n/app_localizations.dart';

/// Testi e messaggi delle notifiche usando l10n
class NotificationTextsL10n {
  final AppLocalizations l10n;

  NotificationTextsL10n(this.l10n);

  // Titoli delle notifiche per parametro
  Map<String, String> get parameterTitles => {
    'Temperatura': l10n.temperatureAnomaly,
    'pH': l10n.phOutOfRange,
    'Salinità': l10n.salinityAnomaly,
    'ORP': l10n.orpOutOfRange,
    'Calcio': l10n.calciumAnomaly,
    'Magnesio': l10n.magnesiumAnomaly,
    'KH': l10n.khOutOfRange,
    'Nitrati': l10n.nitratesHigh,
    'Fosfati': l10n.phosphatesHigh,
  };

  // Messaggi per stato alto
  Map<String, String> get highMessages => {
    'Temperatura': l10n.temperatureTooHigh,
    'pH': l10n.phTooHigh,
    'Salinità': l10n.salinityTooHigh,
    'ORP': l10n.orpTooHigh,
    'Calcio': l10n.calciumTooHigh,
    'Magnesio': l10n.magnesiumTooHigh,
    'KH': l10n.khTooHigh,
    'Nitrati': l10n.nitratesTooHigh,
    'Fosfati': l10n.phosphatesTooHigh,
  };

  // Messaggi per stato basso
  Map<String, String> get lowMessages => {
    'Temperatura': l10n.temperatureTooLow,
    'pH': l10n.phTooLow,
    'Salinità': l10n.salinityTooLow,
    'ORP': l10n.orpTooLow,
    'Calcio': l10n.calciumTooLow,
    'Magnesio': l10n.magnesiumTooLow,
    'KH': l10n.khTooLow,
    'Nitrati': l10n.nitratesTooLow,
    'Fosfati': l10n.phosphatesTooLow,
  };

  // Suggerimenti per stato alto
  Map<String, String> get highSuggestions => {
    'Temperatura': l10n.suggestionTemperatureHigh,
    'pH': l10n.suggestionPhHigh,
    'Salinità': l10n.suggestionSalinityHigh,
    'ORP': l10n.suggestionOrpHigh,
    'Calcio': l10n.suggestionCalciumHigh,
    'Magnesio': l10n.suggestionMagnesiumHigh,
    'KH': l10n.suggestionKhHigh,
    'Nitrati': l10n.suggestionNitratesHigh,
    'Fosfati': l10n.suggestionPhosphatesHigh,
  };

  // Suggerimenti per stato basso
  Map<String, String> get lowSuggestions => {
    'Temperatura': l10n.suggestionTemperatureLow,
    'pH': l10n.suggestionPhLow,
    'Salinità': l10n.suggestionSalinityLow,
    'ORP': l10n.suggestionOrpLow,
    'Calcio': l10n.suggestionCalciumLow,
    'Magnesio': l10n.suggestionMagnesiumLow,
    'KH': l10n.suggestionKhLow,
    'Nitrati': l10n.suggestionNitratesLow,
    'Fosfati': l10n.suggestionPhosphatesLow,
  };

  // Manutenzione
  String get maintenanceTitle => l10n.maintenanceReminder;
  String get maintenanceWeekly => l10n.weeklyMaintenance;
  String get maintenanceMonthly => l10n.monthlyMaintenance;

  // Titoli manutenzione specifici
  String get waterChangeTitle => l10n.waterChangeReminder;
  String get waterChangeBody => l10n.waterChangeReminderBody;

  String get filterCleaningTitle => l10n.filterCleaningReminder;
  String get filterCleaningBody => l10n.filterCleaningReminderBody;

  String get parameterTestingTitle => l10n.parameterTestingReminder;
  String get parameterTestingBody => l10n.parameterTestingReminderBody;

  String get lightMaintenanceTitle => l10n.lightMaintenanceReminder;
  String get lightMaintenanceBody => l10n.lightMaintenanceReminderBody;

  String get maintenanceWeeklyDetails => l10n.weeklyMaintenanceDetails;
  String get maintenanceMonthlyDetails => l10n.monthlyMaintenanceDetails;

  // Severità
  Map<String, String> get severityLabels => {
    'CRITICAL': l10n.severityCritical,
    'HIGH': l10n.severityHigh,
    'MEDIUM': l10n.severityMedium,
    'LOW': l10n.severityLow,
  };

  Map<String, String> get severityDescriptions => {
    'CRITICAL': l10n.severityCriticalDesc,
    'HIGH': l10n.severityHighDesc,
    'MEDIUM': l10n.severityMediumDesc,
    'LOW': l10n.severityLowDesc,
  };

  // Helper methods
  String getTitle(String parameter) {
    return parameterTitles[parameter] ?? l10n.parameterAnomaly;
  }

  String getMessage(String parameter, bool isHigh) {
    final messages = isHigh ? highMessages : lowMessages;
    return messages[parameter] ?? l10n.parameterOutOfRange(parameter);
  }

  String getSuggestion(String parameter, bool isHigh) {
    final suggestions = isHigh ? highSuggestions : lowSuggestions;
    return suggestions[parameter] ?? l10n.checkParameterSettings;
  }

  String getSeverityLabel(String severity) {
    return severityLabels[severity] ?? severity;
  }

  String getSeverityDescription(String severity) {
    return severityDescriptions[severity] ?? '';
  }
}
