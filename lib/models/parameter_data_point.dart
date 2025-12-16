/// Rappresenta un singolo punto dati per un parametro dell'acquario
import 'package:flutter/material.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

class ParameterDataPoint {
  final DateTime timestamp;
  final double value;
  final String parameterName;

  ParameterDataPoint({
    required this.timestamp,
    required this.value,
    required this.parameterName,
  });

  /// Crea un punto dati da JSON
  factory ParameterDataPoint.fromJson(Map<String, dynamic> json) {
    return ParameterDataPoint(
      timestamp: DateTime.parse(json['timestamp']),
      value: (json['value'] as num).toDouble(),
      parameterName: json['parameterName'] as String,
    );
  }

  /// Converte il punto dati in JSON
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'value': value,
      'parameterName': parameterName,
    };
  }

  @override
  String toString() =>
      'ParameterDataPoint($parameterName: $value @ ${timestamp.toLocal()})';
}

/// Statistiche per un set di dati storici
class ParameterStats {
  final double min;
  final double max;
  final double average;
  final double current;
  final TrendDirection trend;
  final int dataPoints;

  ParameterStats({
    required this.min,
    required this.max,
    required this.average,
    required this.current,
    required this.trend,
    required this.dataPoints,
  });

  /// Calcola la variazione percentuale dal valore medio
  double get variationFromAverage => ((current - average) / average) * 100;

  /// Indica se il valore corrente è stabile (entro ±5% dalla media)
  bool get isStable => variationFromAverage.abs() < 5;
}

/// Direzione del trend di un parametro
enum TrendDirection {
  rising, // ↗️ In aumento
  falling, // ↘️ In diminuzione
  stable, // ➡️ Stabile
}

extension TrendDirectionExtension on TrendDirection {
  String get emoji {
    switch (this) {
      case TrendDirection.rising:
        return '↗️';
      case TrendDirection.falling:
        return '↘️';
      case TrendDirection.stable:
        return '➡️';
    }
  }

  String get label {
    switch (this) {
      case TrendDirection.rising:
        return 'In Aumento'; // Fallback, usa getLocalizedLabel(context)
      case TrendDirection.falling:
        return 'In Diminuzione'; // Fallback, usa getLocalizedLabel(context)
      case TrendDirection.stable:
        return 'Stabile'; // Fallback, usa getLocalizedLabel(context)
    }
  }

  /// Ottiene l'etichetta localizzata per il trend
  String getLocalizedLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case TrendDirection.rising:
        return l10n.chartTrendRising;
      case TrendDirection.falling:
        return l10n.chartTrendFalling;
      case TrendDirection.stable:
        return l10n.chartTrendStable;
    }
  }
}
