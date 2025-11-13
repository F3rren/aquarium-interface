import 'package:acquariumfe/services/parameter_service.dart';
import 'package:acquariumfe/models/aquarium_parameters.dart';
import 'package:acquariumfe/models/parameter_data_point.dart';

/// Service per gestire i dati storici dei grafici
class ChartDataService {
  static final ChartDataService _instance = ChartDataService._internal();
  factory ChartDataService() => _instance;
  ChartDataService._internal();

  final ParameterService _parameterService = ParameterService();

  /// Carica dati storici dal backend per un parametro specifico
  Future<List<ParameterDataPoint>> loadHistoricalData({
    required String parameter,
    required int hours,
  }) async {
    try {
      // Calcola range temporale
      final to = DateTime.now();
      final from = to.subtract(Duration(hours: hours));

      // Carica dati dal backend
      final history = await _parameterService.getParameterHistory(
        from: from,
        to: to,
        limit: 100, // Max 100 punti per performance
      );
      
      // Se non ci sono dati, usa mock
      if (history.isEmpty) {
        return _generateMockData(parameter, hours);
      }

      // Filtra SOLO i dati nel range temporale richiesto
      // Converti timestamp UTC in locale per confronto corretto
      var filteredHistory = history.where((param) {
        final localTimestamp = param.timestamp.toLocal();
        return localTimestamp.isAfter(from) && localTimestamp.isBefore(to.add(Duration(minutes: 1)));
      }).toList();
      
      // Se il filtro trova pochi dati (dati vecchi in MockOn), usa gli ultimi disponibili
      final minPoints = hours == 24 ? 4 : hours == 168 ? 10 : 20;
      if (filteredHistory.length < minPoints && history.length >= minPoints) {
        // Ordina per timestamp e prendi gli ultimi N
        history.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        filteredHistory = history.sublist(history.length - minPoints);
      }

      // Se non ci sono dati nel range, usa mock
      if (filteredHistory.isEmpty) {
        return _generateMockData(parameter, hours);
      }

      // Converti in ParameterDataPoint
      final dataPoints = _convertToDataPoints(filteredHistory, parameter);
     
      return dataPoints;
    } catch (e) {
      // Fallback a dati mock se backend non disponibile
      return _generateMockData(parameter, hours);
    }
  }

  /// Converte AquariumParameters in ParameterDataPoint
  List<ParameterDataPoint> _convertToDataPoints(
    List<AquariumParameters> history,
    String parameter,
  ) {
    return history.map((params) {
      double value = 0.0;

      switch (parameter) {
        case 'Temperatura':
          value = params.temperature;
          break;
        case 'pH':
          value = params.ph;
          break;
        case 'Salinità':
          value = params.salinity;
          break;
        case 'ORP':
          value = params.orp;
          break;
      }

      return ParameterDataPoint(
        timestamp: params.timestamp,
        value: value,
        parameterName: parameter,
      );
    }).toList();
  }

  /// Genera dati mock per testing (fallback)
  List<ParameterDataPoint> _generateMockData(String parameter, int hours) {
    final now = DateTime.now();
    final points = <ParameterDataPoint>[];
    
    // Valori base per ogni parametro
    final baseValues = {
      'Temperatura': 25.0,
      'pH': 8.2,
      'Salinità': 1024,
      'ORP': 350.0,
    };

    final baseValue = baseValues[parameter] ?? 25.0;
    final variationRange = parameter == 'Temperatura' ? 1 : 
                           parameter == 'pH' ? 0.3 : 
                           parameter == 'Salinità' ? 0.003 : 30.0;

    // Genera un punto ogni 30 minuti
    final pointsCount = (hours * 2).clamp(10, 100);
    final interval = Duration(minutes: (hours * 60 / pointsCount).round());

    for (int i = 0; i < pointsCount; i++) {
      final timestamp = now.subtract(interval * (pointsCount - i - 1));
      final variation = (i % 5 - 2) * variationRange * 0.1;
      final value = baseValue + variation;

      points.add(ParameterDataPoint(
        timestamp: timestamp,
        value: value,
        parameterName: parameter,
      ));
    }

    return points;
  }

  /// Calcola statistiche dai dati
  Map<String, double> calculateStats(List<ParameterDataPoint> data) {
    if (data.isEmpty) {
      return {
        'min': 0.0,
        'max': 0.0,
        'avg': 0.0,
        'current': 0.0,
      };
    }

    final values = data.map((p) => p.value).toList();
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final avg = values.reduce((a, b) => a + b) / values.length;
    final current = data.last.value;

    return {
      'min': min,
      'max': max,
      'avg': avg,
      'current': current,
    };
  }
}
