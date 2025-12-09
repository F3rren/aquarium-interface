import 'package:acquariumfe/services/parameter_service.dart';
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
      // Mappa il nome parametro italiano a quello del backend
      final paramName = _mapParameterName(parameter);

      // Carica dati specifici del parametro dal backend
      final historyData = await _parameterService.getParameterHistoryForChart(
        aquariumId: 1,
        parameterName: paramName,
        hours: Duration(hours: hours),
      );

      // Converti in ParameterDataPoint
      final dataPoints = historyData.map((item) {
        return ParameterDataPoint(
          timestamp: DateTime.parse(item['timestamp'] as String),
          value: item['value'] as double,
          parameterName: parameter,
        );
      }).toList();

      return dataPoints;
    } catch (e) {
      // Ritorna lista vuota invece di mock
      return [];
    }
  }

  /// Mappa i nomi dei parametri italiani a quelli del backend
  String _mapParameterName(String italianName) {
    switch (italianName) {
      case 'Temperatura':
        return 'temperature';
      case 'pH':
        return 'ph';
      case 'Salinità':
        return 'salinity';
      case 'ORP':
        return 'orp';
      case 'Calcio':
        return 'calcium';
      case 'Magnesio':
        return 'magnesium';
      case 'KH':
        return 'kh';
      case 'Nitrati':
        return 'nitrate';
      case 'Fosfati':
        return 'phosphate';
      default:
        return italianName.toLowerCase();
    }
  }

  /// Calcola statistiche dai dati
  Map<String, double> calculateStats(List<ParameterDataPoint> data) {
    if (data.isEmpty) {
      return {'min': 0.0, 'max': 0.0, 'avg': 0.0, 'current': 0.0};
    }

    final values = data.map((p) => p.value).toList();
    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final avg = values.reduce((a, b) => a + b) / values.length;
    final current = data.last.value;

    return {'min': min, 'max': max, 'avg': avg, 'current': current};
  }
}
