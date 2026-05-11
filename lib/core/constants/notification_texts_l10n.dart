/// Localised counterpart of [NotificationTexts] for use inside the widget tree.
///
/// Unlike the static [NotificationTexts] class, [NotificationTextsL10n] holds
/// an [AppLocalizations] instance and exposes the same API as instance getters
/// so that every string goes through the ARB catalogue and respects the active
/// locale.  Construct it once per build pass or pass it down the tree.
library;

import 'package:acquariumfe/core/l10n/app_localizations.dart';

/// Localised notification copy powered by [AppLocalizations].
///
/// Usage:
/// ```dart
/// final texts = NotificationTextsL10n(AppLocalizations.of(context)!);
/// final title = texts.getTitle('pH');
/// ```
class NotificationTextsL10n {
  /// The [AppLocalizations] instance used for all string lookups.
  final AppLocalizations l10n;

  /// Creates a [NotificationTextsL10n] bound to [l10n].
  NotificationTextsL10n(this.l10n);

  // ── Parameter alert titles ─────────────────────────────────────────────────

  /// Maps parameter names (Italian backend keys) to their localised
  /// out-of-range notification titles.
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

  // ── Alert body messages ────────────────────────────────────────────────────

  /// Localised body text when a parameter value is too high.
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

  /// Localised body text when a parameter value is too low.
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

  // ── Corrective-action suggestions ─────────────────────────────────────────

  /// Localised corrective-action suggestions when a parameter is too high.
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

  /// Localised corrective-action suggestions when a parameter is too low.
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

  // ── Maintenance reminder strings ──────────────────────────────────────────

  /// Localised generic maintenance reminder title.
  String get maintenanceTitle => l10n.maintenanceReminder;

  /// Localised body for a weekly maintenance reminder.
  String get maintenanceWeekly => l10n.weeklyMaintenance;

  /// Localised body for a monthly maintenance reminder.
  String get maintenanceMonthly => l10n.monthlyMaintenance;

  /// Localised title for a water-change reminder.
  String get waterChangeTitle => l10n.waterChangeReminder;

  /// Localised body for a water-change reminder.
  String get waterChangeBody => l10n.waterChangeReminderBody;

  /// Localised title for a filter-cleaning reminder.
  String get filterCleaningTitle => l10n.filterCleaningReminder;

  /// Localised body for a filter-cleaning reminder.
  String get filterCleaningBody => l10n.filterCleaningReminderBody;

  /// Localised title for a parameter-testing reminder.
  String get parameterTestingTitle => l10n.parameterTestingReminder;

  /// Localised body for a parameter-testing reminder.
  String get parameterTestingBody => l10n.parameterTestingReminderBody;

  /// Localised title for a light-maintenance reminder.
  String get lightMaintenanceTitle => l10n.lightMaintenanceReminder;

  /// Localised body for a light-maintenance reminder.
  String get lightMaintenanceBody => l10n.lightMaintenanceReminderBody;

  /// Localised weekly maintenance checklist detail.
  String get maintenanceWeeklyDetails => l10n.weeklyMaintenanceDetails;

  /// Localised monthly maintenance checklist detail.
  String get maintenanceMonthlyDetails => l10n.monthlyMaintenanceDetails;

  // ── Severity labels ────────────────────────────────────────────────────────

  /// Maps severity level strings to their localised display labels.
  Map<String, String> get severityLabels => {
    'CRITICAL': l10n.severityCritical,
    'HIGH': l10n.severityHigh,
    'MEDIUM': l10n.severityMedium,
    'LOW': l10n.severityLow,
  };

  /// Maps severity level strings to their localised short descriptions.
  Map<String, String> get severityDescriptions => {
    'CRITICAL': l10n.severityCriticalDesc,
    'HIGH': l10n.severityHighDesc,
    'MEDIUM': l10n.severityMediumDesc,
    'LOW': l10n.severityLowDesc,
  };

  // ── Helper methods ─────────────────────────────────────────────────────────

  /// Returns the localised notification title for [parameter], falling back to
  /// a generic out-of-range label if the parameter is not mapped.
  String getTitle(String parameter) {
    return parameterTitles[parameter] ?? l10n.parameterAnomaly;
  }

  /// Returns the localised notification body for [parameter].
  ///
  /// [isHigh] selects between [highMessages] and [lowMessages].
  String getMessage(String parameter, bool isHigh) {
    final messages = isHigh ? highMessages : lowMessages;
    return messages[parameter] ?? l10n.parameterOutOfRange(parameter);
  }

  /// Returns the localised corrective-action suggestion for [parameter].
  ///
  /// [isHigh] selects between [highSuggestions] and [lowSuggestions].
  String getSuggestion(String parameter, bool isHigh) {
    final suggestions = isHigh ? highSuggestions : lowSuggestions;
    return suggestions[parameter] ?? l10n.checkParameterSettings;
  }

  /// Returns the localised label for [severity] (e.g. `'HIGH'` → `"Alto"`).
  /// Falls back to [severity] unchanged if not in the map.
  String getSeverityLabel(String severity) {
    return severityLabels[severity] ?? severity;
  }

  /// Returns the localised description for [severity]. Returns an empty string
  /// if [severity] is not found.
  String getSeverityDescription(String severity) {
    return severityDescriptions[severity] ?? '';
  }
}
