import 'package:flutter/material.dart';
import 'package:acquariumfe/models/aquarium_parameter.dart';

/// Servizio singleton per gestire la localizzazione a livello di app
/// Permette ai servizi senza BuildContext di accedere alle traduzioni
class AppLocaleService {
  static final AppLocaleService _instance = AppLocaleService._internal();
  factory AppLocaleService() => _instance;
  AppLocaleService._internal();

  Locale _currentLocale = const Locale('it');
  
  /// Aggiorna la locale corrente
  void setLocale(Locale locale) {
    _currentLocale = locale;
  }

  /// Ottiene la locale corrente
  Locale get currentLocale => _currentLocale;

  /// Ottiene il titolo dell'alert per un parametro nella lingua corrente
  String getAlertTitle(AquariumParameter param) {
    switch (_currentLocale.languageCode) {
      case 'en':
        return _getEnglishTitle(param);
      case 'fr':
        return _getFrenchTitle(param);
      case 'de':
        return _getGermanTitle(param);
      case 'es':
        return _getSpanishTitle(param);
      default:
        return _getItalianTitle(param);
    }
  }

  /// Ottiene il messaggio dell'alert per un parametro nella lingua corrente
  String getAlertMessage(AquariumParameter param, bool isHigh) {
    switch (_currentLocale.languageCode) {
      case 'en':
        return _getEnglishMessage(param, isHigh);
      case 'fr':
        return _getFrenchMessage(param, isHigh);
      case 'de':
        return _getGermanMessage(param, isHigh);
      case 'es':
        return _getSpanishMessage(param, isHigh);
      default:
        return _getItalianMessage(param, isHigh);
    }
  }

  // ===== ITALIANO =====
  String _getItalianTitle(AquariumParameter param) {
    switch (param) {
      case AquariumParameter.temperature: return 'Temperatura Anomala';
      case AquariumParameter.ph: return 'pH Fuori Range';
      case AquariumParameter.salinity: return 'Salinità Anomala';
      case AquariumParameter.orp: return 'ORP Fuori Range';
      case AquariumParameter.calcium: return 'Calcio Anomalo';
      case AquariumParameter.magnesium: return 'Magnesio Anomalo';
      case AquariumParameter.kh: return 'KH Fuori Range';
      case AquariumParameter.nitrate: return 'Nitrati Elevati';
      case AquariumParameter.phosphate: return 'Fosfati Elevati';
    }
  }

  String _getItalianMessage(AquariumParameter param, bool isHigh) {
    switch (param) {
      case AquariumParameter.temperature:
        return isHigh ? 'La temperatura è troppo alta.' : 'La temperatura è troppo bassa.';
      case AquariumParameter.ph:
        return isHigh ? 'Il pH è troppo alto.' : 'Il pH è troppo basso.';
      case AquariumParameter.salinity:
        return isHigh ? 'La salinità è troppo alta.' : 'La salinità è troppo bassa.';
      case AquariumParameter.orp:
        return isHigh ? 'L\'ORP è troppo alto.' : 'L\'ORP è troppo basso.';
      case AquariumParameter.calcium:
        return isHigh ? 'Il calcio è troppo alto.' : 'Il calcio è troppo basso.';
      case AquariumParameter.magnesium:
        return isHigh ? 'Il magnesio è troppo alto.' : 'Il magnesio è troppo basso.';
      case AquariumParameter.kh:
        return isHigh ? 'Il KH è troppo alto.' : 'Il KH è troppo basso.';
      case AquariumParameter.nitrate:
        return isHigh ? 'I nitrati sono troppo alti.' : 'I nitrati sono troppo bassi.';
      case AquariumParameter.phosphate:
        return isHigh ? 'I fosfati sono troppo alti.' : 'I fosfati sono troppo bassi.';
    }
  }

  // ===== INGLESE =====
  String _getEnglishTitle(AquariumParameter param) {
    switch (param) {
      case AquariumParameter.temperature: return 'Anomalous Temperature';
      case AquariumParameter.ph: return 'pH Out of Range';
      case AquariumParameter.salinity: return 'Anomalous Salinity';
      case AquariumParameter.orp: return 'ORP Out of Range';
      case AquariumParameter.calcium: return 'Anomalous Calcium';
      case AquariumParameter.magnesium: return 'Anomalous Magnesium';
      case AquariumParameter.kh: return 'KH Out of Range';
      case AquariumParameter.nitrate: return 'High Nitrates';
      case AquariumParameter.phosphate: return 'High Phosphates';
    }
  }

  String _getEnglishMessage(AquariumParameter param, bool isHigh) {
    switch (param) {
      case AquariumParameter.temperature:
        return isHigh ? 'Temperature is too high.' : 'Temperature is too low.';
      case AquariumParameter.ph:
        return isHigh ? 'pH is too high.' : 'pH is too low.';
      case AquariumParameter.salinity:
        return isHigh ? 'Salinity is too high.' : 'Salinity is too low.';
      case AquariumParameter.orp:
        return isHigh ? 'ORP is too high.' : 'ORP is too low.';
      case AquariumParameter.calcium:
        return isHigh ? 'Calcium is too high.' : 'Calcium is too low.';
      case AquariumParameter.magnesium:
        return isHigh ? 'Magnesium is too high.' : 'Magnesium is too low.';
      case AquariumParameter.kh:
        return isHigh ? 'KH is too high.' : 'KH is too low.';
      case AquariumParameter.nitrate:
        return isHigh ? 'Nitrates are too high.' : 'Nitrates are too low.';
      case AquariumParameter.phosphate:
        return isHigh ? 'Phosphates are too high.' : 'Phosphates are too low.';
    }
  }

  // ===== FRANCESE =====
  String _getFrenchTitle(AquariumParameter param) {
    switch (param) {
      case AquariumParameter.temperature: return 'Température Anormale';
      case AquariumParameter.ph: return 'pH Hors Limites';
      case AquariumParameter.salinity: return 'Salinité Anormale';
      case AquariumParameter.orp: return 'ORP Hors Limites';
      case AquariumParameter.calcium: return 'Calcium Anormal';
      case AquariumParameter.magnesium: return 'Magnésium Anormal';
      case AquariumParameter.kh: return 'KH Hors Limites';
      case AquariumParameter.nitrate: return 'Nitrates Élevés';
      case AquariumParameter.phosphate: return 'Phosphates Élevés';
    }
  }

  String _getFrenchMessage(AquariumParameter param, bool isHigh) {
    switch (param) {
      case AquariumParameter.temperature:
        return isHigh ? 'La température est trop élevée.' : 'La température est trop basse.';
      case AquariumParameter.ph:
        return isHigh ? 'Le pH est trop élevé.' : 'Le pH est trop bas.';
      case AquariumParameter.salinity:
        return isHigh ? 'La salinité est trop élevée.' : 'La salinité est trop basse.';
      case AquariumParameter.orp:
        return isHigh ? 'L\'ORP est trop élevé.' : 'L\'ORP est trop bas.';
      case AquariumParameter.calcium:
        return isHigh ? 'Le calcium est trop élevé.' : 'Le calcium est trop bas.';
      case AquariumParameter.magnesium:
        return isHigh ? 'Le magnésium est trop élevé.' : 'Le magnésium est trop bas.';
      case AquariumParameter.kh:
        return isHigh ? 'Le KH est trop élevé.' : 'Le KH est trop bas.';
      case AquariumParameter.nitrate:
        return isHigh ? 'Les nitrates sont trop élevés.' : 'Les nitrates sont trop bas.';
      case AquariumParameter.phosphate:
        return isHigh ? 'Les phosphates sont trop élevés.' : 'Les phosphates sont trop bas.';
    }
  }

  // ===== TEDESCO =====
  String _getGermanTitle(AquariumParameter param) {
    switch (param) {
      case AquariumParameter.temperature: return 'Anomale Temperatur';
      case AquariumParameter.ph: return 'pH Außerhalb des Bereichs';
      case AquariumParameter.salinity: return 'Anomaler Salzgehalt';
      case AquariumParameter.orp: return 'ORP Außerhalb des Bereichs';
      case AquariumParameter.calcium: return 'Anomales Kalzium';
      case AquariumParameter.magnesium: return 'Anomales Magnesium';
      case AquariumParameter.kh: return 'KH Außerhalb des Bereichs';
      case AquariumParameter.nitrate: return 'Hohe Nitrate';
      case AquariumParameter.phosphate: return 'Hohe Phosphate';
    }
  }

  String _getGermanMessage(AquariumParameter param, bool isHigh) {
    switch (param) {
      case AquariumParameter.temperature:
        return isHigh ? 'Die Temperatur ist zu hoch.' : 'Die Temperatur ist zu niedrig.';
      case AquariumParameter.ph:
        return isHigh ? 'Der pH-Wert ist zu hoch.' : 'Der pH-Wert ist zu niedrig.';
      case AquariumParameter.salinity:
        return isHigh ? 'Der Salzgehalt ist zu hoch.' : 'Der Salzgehalt ist zu niedrig.';
      case AquariumParameter.orp:
        return isHigh ? 'Das ORP ist zu hoch.' : 'Das ORP ist zu niedrig.';
      case AquariumParameter.calcium:
        return isHigh ? 'Das Kalzium ist zu hoch.' : 'Das Kalzium ist zu niedrig.';
      case AquariumParameter.magnesium:
        return isHigh ? 'Das Magnesium ist zu hoch.' : 'Das Magnesium ist zu niedrig.';
      case AquariumParameter.kh:
        return isHigh ? 'Der KH ist zu hoch.' : 'Der KH ist zu niedrig.';
      case AquariumParameter.nitrate:
        return isHigh ? 'Die Nitrate sind zu hoch.' : 'Die Nitrate sind zu niedrig.';
      case AquariumParameter.phosphate:
        return isHigh ? 'Die Phosphate sind zu hoch.' : 'Die Phosphate sind zu niedrig.';
    }
  }

  // ===== SPAGNOLO =====
  String _getSpanishTitle(AquariumParameter param) {
    switch (param) {
      case AquariumParameter.temperature: return 'Temperatura Anómala';
      case AquariumParameter.ph: return 'pH Fuera de Rango';
      case AquariumParameter.salinity: return 'Salinidad Anómala';
      case AquariumParameter.orp: return 'ORP Fuera de Rango';
      case AquariumParameter.calcium: return 'Calcio Anómalo';
      case AquariumParameter.magnesium: return 'Magnesio Anómalo';
      case AquariumParameter.kh: return 'KH Fuera de Rango';
      case AquariumParameter.nitrate: return 'Nitratos Elevados';
      case AquariumParameter.phosphate: return 'Fosfatos Elevados';
    }
  }

  String _getSpanishMessage(AquariumParameter param, bool isHigh) {
    switch (param) {
      case AquariumParameter.temperature:
        return isHigh ? 'La temperatura es demasiado alta.' : 'La temperatura es demasiado baja.';
      case AquariumParameter.ph:
        return isHigh ? 'El pH es demasiado alto.' : 'El pH es demasiado bajo.';
      case AquariumParameter.salinity:
        return isHigh ? 'La salinidad es demasiado alta.' : 'La salinidad es demasiado baja.';
      case AquariumParameter.orp:
        return isHigh ? 'El ORP es demasiado alto.' : 'El ORP es demasiado bajo.';
      case AquariumParameter.calcium:
        return isHigh ? 'El calcio es demasiado alto.' : 'El calcio es demasiado bajo.';
      case AquariumParameter.magnesium:
        return isHigh ? 'El magnesio es demasiado alto.' : 'El magnesio es demasiado bajo.';
      case AquariumParameter.kh:
        return isHigh ? 'El KH es demasiado alto.' : 'El KH es demasiado bajo.';
      case AquariumParameter.nitrate:
        return isHigh ? 'Los nitratos son demasiado altos.' : 'Los nitratos son demasiado bajos.';
      case AquariumParameter.phosphate:
        return isHigh ? 'Los fosfatos son demasiado altos.' : 'Los fosfatos son demasiado bajos.';
    }
  }
}
