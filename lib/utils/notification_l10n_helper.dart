import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:acquariumfe/models/aquarium_parameter.dart';

/// Helper class per ottenere i testi tradotti delle notifiche
class NotificationL10nHelper {
  /// Ottiene il nome tradotto di un parametro
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

  /// Ottiene il titolo tradotto dell'alert per un parametro
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

  /// Ottiene il messaggio tradotto dell'alert per un parametro
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
