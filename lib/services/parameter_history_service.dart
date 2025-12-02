import 'dart:math';
import '../models/parameter_data_point.dart';

/// Servizio per generare e gestire dati storici dei parametri
class ParameterHistoryService {
  static final ParameterHistoryService _instance = ParameterHistoryService._internal();
  factory ParameterHistoryService() => _instance;
  ParameterHistoryService._internal();

  final Random _random = Random();
  
  // Storage in-memory per i dati storici
  final Map<String, List<ParameterDataPoint>> _history = {};

  /// Genera dati storici per un parametro
  List<ParameterDataPoint> generateHistory({
    required String parameterName,
    required double baseValue,
    required int hours,
    double variationPercent = 5.0,
  }) {
    // Se già esiste, restituisci quello cached
    final cacheKey = '${parameterName}_${hours}h';
    if (_history.containsKey(cacheKey)) {
      return _history[cacheKey]!;
    }

    final dataPoints = <ParameterDataPoint>[];
    final now = DateTime.now();
    final interval = hours > 48 ? 60 : 15; // 1h per periodi lunghi, 15min per 24h
    final pointsCount = (hours * 60) ~/ interval;

    double currentValue = baseValue;
    
    for (int i = pointsCount; i >= 0; i--) {
      final timestamp = now.subtract(Duration(minutes: i * interval));
      
      // Aggiungi variazione casuale con smooth transition
      final variation = (baseValue * variationPercent / 100) * (_random.nextDouble() * 2 - 1);
      currentValue = baseValue + variation;
      
      // Aggiungi trend leggero (ciclo giorno/notte per temperatura)
      if (parameterName == 'Temperatura') {
        final hourOfDay = timestamp.hour;
        final nightVariation = hourOfDay < 6 || hourOfDay > 20 ? -0.5 : 0.3;
        currentValue += nightVariation;
      }

      dataPoints.add(ParameterDataPoint(
        timestamp: timestamp,
        value: double.parse(currentValue.toStringAsFixed(2)),
        parameterName: parameterName,
      ));
    }

    _history[cacheKey] = dataPoints;
    return dataPoints;
  }

  /// Calcola statistiche da una lista di punti dati
  ParameterStats calculateStats(List<ParameterDataPoint> dataPoints) {
    if (dataPoints.isEmpty) {
      return ParameterStats(
        min: 0,
        max: 0,
        average: 0,
        current: 0,
        trend: TrendDirection.stable,
        dataPoints: 0,
      );
    }

    final values = dataPoints.map((p) => p.value).toList();
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final average = values.reduce((a, b) => a + b) / values.length;
    final current = values.last;

    // Calcola trend confrontando media prima metà vs seconda metà
    final halfPoint = values.length ~/ 2;
    final firstHalfAvg = values.sublist(0, halfPoint).reduce((a, b) => a + b) / halfPoint;
    final secondHalfAvg = values.sublist(halfPoint).reduce((a, b) => a + b) / (values.length - halfPoint);
    
    final TrendDirection trend;
    final diff = secondHalfAvg - firstHalfAvg;
    if (diff.abs() < average * 0.02) { // Meno del 2% = stabile
      trend = TrendDirection.stable;
    } else if (diff > 0) {
      trend = TrendDirection.rising;
    } else {
      trend = TrendDirection.falling;
    }

    return ParameterStats(
      min: double.parse(min.toStringAsFixed(2)),
      max: double.parse(max.toStringAsFixed(2)),
      average: double.parse(average.toStringAsFixed(2)),
      current: double.parse(current.toStringAsFixed(2)),
      trend: trend,
      dataPoints: dataPoints.length,
    );
  }

  /// Ottieni dati per tutti i parametri principali
  Map<String, List<ParameterDataPoint>> getAllParametersHistory({int hours = 24}) {
    return {
      'Temperatura': generateHistory(
        parameterName: 'Temperatura',
        baseValue: 25.0,
        hours: hours,
        variationPercent: 3,
      ),
      'pH': generateHistory(
        parameterName: 'pH',
        baseValue: 8.2,
        hours: hours,
        variationPercent: 2,
      ),
      'Salinità': generateHistory(
        parameterName: 'Salinità',
        baseValue: 1.024,
        hours: hours,
        variationPercent: 0.5,
      ),
      'ORP': generateHistory(
        parameterName: 'ORP',
        baseValue: 350.0,
        hours: hours,
        variationPercent: 8,
      ),
    };
  }

  /// Pulisce la cache dello storico
  void clearCache() {
    _history.clear();
  }

  /// Aggiunge un nuovo punto dati in tempo reale
  void addDataPoint(ParameterDataPoint point) {
    final key = '${point.parameterName}_24h';
    if (!_history.containsKey(key)) {
      _history[key] = [];
    }
    
    _history[key]!.add(point);
    
    // Mantieni solo ultime 24h (max 96 punti se interval 15min)
    if (_history[key]!.length > 96) {
      _history[key]!.removeAt(0);
    }
  }
}