/// Static helper for resolving localised notification strings from
/// [AquariumParameter] enum values.
library;

import 'package:acquariumfe/core/l10n/app_localizations.dart';
import 'package:acquariumfe/features/parameters/domain/models/aquarium_parameter.dart';

/// Provides localised notification copy (parameter names, alert titles,
/// alert body messages) driven by [AppLocalizations].
///
/// All methods are static so callers do not need to instantiate this class.
class NotificationL10nHelper {
  /// Returns the localised display name for [parameter]
  /// (e.g. `"Temperature"`, `"pH"`, `"Salinity"`).
  static String getParameterName(
    AppLocalizations l10n,
    AquariumParameter parameter,
  ) {
    switch (parameter) {
      case AquariumParameter.temperature:
        return l10n.temperatureParam;
      case AquariumParameter.ph:
        return l10n.phParam;
      case AquariumParameter.salinity:
        return l10n.salinityParam;
      case AquariumParameter.orp:
        return l10n.orpParam;
      case AquariumParameter.calcium:
        return l10n.calciumParam;
      case AquariumParameter.magnesium:
        return l10n.magnesiumParam;
      case AquariumParameter.kh:
        return l10n.khParam;
      case AquariumParameter.nitrate:
        return l10n.nitrateParam;
      case AquariumParameter.phosphate:
        return l10n.phosphateParam;
    }
  }

  /// Returns the localised notification title for an out-of-range alert on
  /// [parameter] (e.g. `"Temperature Anomaly"`, `"pH Out of Range"`).
  static String getAlertTitle(
    AppLocalizations l10n,
    AquariumParameter parameter,
  ) {
    switch (parameter) {
      case AquariumParameter.temperature:
        return l10n.temperatureAnomalous;
      case AquariumParameter.ph:
        return l10n.phOutOfRange;
      case AquariumParameter.salinity:
        return l10n.salinityAnomalous;
      case AquariumParameter.orp:
        return l10n.orpOutOfRange;
      case AquariumParameter.calcium:
        return l10n.calciumAnomalous;
      case AquariumParameter.magnesium:
        return l10n.magnesiumAnomalous;
      case AquariumParameter.kh:
        return l10n.khOutOfRange;
      case AquariumParameter.nitrate:
        return l10n.nitrateHigh;
      case AquariumParameter.phosphate:
        return l10n.phosphateHigh;
    }
  }

  /// Returns the localised notification body for [parameter] given whether the
  /// value is too high ([isHigh] == `true`) or too low ([isHigh] == `false`).
  ///
  /// Example: `getAlertMessage(l10n, AquariumParameter.temperature, true)`
  /// → `"Temperature is too high."`
  static String getAlertMessage(
    AppLocalizations l10n,
    AquariumParameter parameter,
    bool isHigh,
  ) {
    switch (parameter) {
      case AquariumParameter.temperature:
        return isHigh ? l10n.temperatureTooHigh : l10n.temperatureTooLow;
      case AquariumParameter.ph:
        return isHigh ? l10n.phTooHigh : l10n.phTooLow;
      case AquariumParameter.salinity:
        return isHigh ? l10n.salinityTooHigh : l10n.salinityTooLow;
      case AquariumParameter.orp:
        return isHigh ? l10n.orpTooHigh : l10n.orpTooLow;
      case AquariumParameter.calcium:
        return isHigh ? l10n.calciumTooHigh : l10n.calciumTooLow;
      case AquariumParameter.magnesium:
        return isHigh ? l10n.magnesiumTooHigh : l10n.magnesiumTooLow;
      case AquariumParameter.kh:
        return isHigh ? l10n.khTooHigh : l10n.khTooLow;
      case AquariumParameter.nitrate:
        return isHigh ? l10n.nitrateTooHigh : l10n.nitrateTooLow;
      case AquariumParameter.phosphate:
        return isHigh ? l10n.phosphateTooHigh : l10n.phosphateTooLow;
    }
  }
}
