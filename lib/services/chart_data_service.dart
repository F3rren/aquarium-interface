/// Service that loads historical parameter data and computes basic statistics
/// for the charts view.
library;

import 'package:acquariumfe/services/parameter_service.dart';
import 'package:acquariumfe/models/parameter_data_point.dart';

/// Singleton that acts as a thin adapter between the charts view and
/// [ParameterService].
///
/// Responsibilities:
/// - Translates Italian parameter display names (as shown in the UI) to the
///   backend camelCase keys expected by [ParameterService.getParameterHistoryForChart].
/// - Converts the raw `List<Map<String, dynamic>>` returned by the backend
///   into typed [ParameterDataPoint] objects.
/// - Computes min / max / average / current statistics from a list of data
///   points.
///
/// On network or parse errors [loadHistoricalData] returns an empty list
/// rather than throwing, so the charts view can render gracefully without data.
class ChartDataService {
  /// Creates a [ChartDataService] backed by [parameterService].
  ///
  /// Obtain the shared instance via Riverpod ([chartDataServiceProvider])
  /// rather than constructing directly.
  ChartDataService(this._parameterService);

  final ParameterService _parameterService;

  /// Fetches historical data for [parameter] over the last [hours] hours.
  ///
  /// [parameter] must be one of the Italian display names used in the UI
  /// (e.g. `'Temperatura'`, `'Salinità'`, `'Nitrati'`). It is translated
  /// internally to the backend key via [_mapParameterName].
  ///
  /// Returns an empty list if the network request fails or if [ParameterService]
  /// returns no data for the requested range.
  Future<List<ParameterDataPoint>> loadHistoricalData({
    required String parameter,
    required int hours,
  }) async {
    try {
      final paramName = _mapParameterName(parameter);

      final historyData = await _parameterService.getParameterHistoryForChart(
        aquariumId: 1,
        parameterName: paramName,
        hours: Duration(hours: hours),
      );

      final dataPoints = historyData.map((item) {
        return ParameterDataPoint(
          timestamp: DateTime.parse(item['timestamp'] as String),
          value: item['value'] as double,
          parameterName: parameter,
        );
      }).toList();

      return dataPoints;
    } catch (e) {
      return [];
    }
  }

  /// Maps an Italian UI display name to the backend parameter key.
  ///
  /// | UI name (Italian) | Backend key   |
  /// |-------------------|---------------|
  /// | `'Temperatura'`   | `'temperature'` |
  /// | `'pH'`            | `'ph'`        |
  /// | `'Salinità'`      | `'salinity'`  |
  /// | `'ORP'`           | `'orp'`       |
  /// | `'Calcio'`        | `'calcium'`   |
  /// | `'Magnesio'`      | `'magnesium'` |
  /// | `'KH'`            | `'kh'`        |
  /// | `'Nitrati'`       | `'nitrate'`   |
  /// | `'Fosfati'`       | `'phosphate'` |
  ///
  /// Unrecognised names fall back to `italianName.toLowerCase()`.
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

  /// Computes basic statistics from a list of [ParameterDataPoint]s.
  ///
  /// Returns a map with keys `'min'`, `'max'`, `'avg'`, and `'current'` (the
  /// value of the last data point). All values are `0.0` when [data] is empty.
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
