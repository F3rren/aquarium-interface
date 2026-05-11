/// In-memory parameter history service used as a fallback / mock data source.
library;

import 'dart:math';
import 'package:acquariumfe/features/parameters/domain/models/parameter_data_point.dart';

/// Singleton that generates and caches synthetic parameter history data.
///
/// **Purpose:** this service provides a fallback data source when the backend
/// history endpoint returns no data. It is **not** backed by the API; all data
/// is randomly generated at call time and held in memory.
///
/// **Caching:** generated datasets are keyed by `'${parameterName}_${hours}h'`
/// (e.g. `'Temperatura_24h'`). The same key returns the same generated
/// dataset for the lifetime of the process. Call [clearCache] to regenerate
/// fresh data.
///
/// **Real-time data:** [addDataPoint] can inject real measurements into the
/// `24h` cache slot. The list is capped at 96 entries (one reading every
/// 15 minutes for 24 hours).
///
/// **Sampling interval:** 15 minutes for periods ≤ 48 hours, 60 minutes for
/// longer periods.
class ParameterHistoryService {
  static final ParameterHistoryService _instance =
      ParameterHistoryService._internal();
  factory ParameterHistoryService() => _instance;
  ParameterHistoryService._internal();

  final Random _random = Random();

  /// In-memory cache: key → list of data points.
  final Map<String, List<ParameterDataPoint>> _history = {};

  /// Generates (or returns cached) synthetic history for [parameterName] over
  /// the past [hours] hours.
  ///
  /// [baseValue] is the centre value around which the generated series
  /// fluctuates. [variationPercent] controls the maximum ± deviation as a
  /// percentage of [baseValue] (default `5 %`).
  ///
  /// For `'Temperatura'`, a day/night pattern is applied: values are lowered
  /// by 0.5 between midnight and 06:00 and between 20:00 and midnight, and
  /// raised by 0.3 during daylight hours.
  ///
  /// All generated values are rounded to 2 decimal places.
  List<ParameterDataPoint> generateHistory({
    required String parameterName,
    required double baseValue,
    required int hours,
    double variationPercent = 5.0,
  }) {
    final cacheKey = '${parameterName}_${hours}h';
    if (_history.containsKey(cacheKey)) {
      return _history[cacheKey]!;
    }

    final dataPoints = <ParameterDataPoint>[];
    final now = DateTime.now();
    final interval = hours > 48 ? 60 : 15;
    final pointsCount = (hours * 60) ~/ interval;

    double currentValue = baseValue;

    for (int i = pointsCount; i >= 0; i--) {
      final timestamp = now.subtract(Duration(minutes: i * interval));

      final variation =
          (baseValue * variationPercent / 100) * (_random.nextDouble() * 2 - 1);
      currentValue = baseValue + variation;

      if (parameterName == 'Temperatura') {
        final hourOfDay = timestamp.hour;
        final nightVariation = hourOfDay < 6 || hourOfDay > 20 ? -0.5 : 0.3;
        currentValue += nightVariation;
      }

      dataPoints.add(
        ParameterDataPoint(
          timestamp: timestamp,
          value: double.parse(currentValue.toStringAsFixed(2)),
          parameterName: parameterName,
        ),
      );
    }

    _history[cacheKey] = dataPoints;
    return dataPoints;
  }

  /// Computes [ParameterStats] from [dataPoints].
  ///
  /// When [dataPoints] is empty, returns all-zero stats with
  /// [TrendDirection.stable].
  ///
  /// **Trend calculation:** the dataset is split in half; if the mean of the
  /// second half differs from the mean of the first half by more than 2 % of
  /// the overall average, the trend is [TrendDirection.rising] or
  /// [TrendDirection.falling]; otherwise [TrendDirection.stable].
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

    final halfPoint = values.length ~/ 2;
    final firstHalfAvg =
        values.sublist(0, halfPoint).reduce((a, b) => a + b) / halfPoint;
    final secondHalfAvg =
        values.sublist(halfPoint).reduce((a, b) => a + b) /
        (values.length - halfPoint);

    final TrendDirection trend;
    final diff = secondHalfAvg - firstHalfAvg;
    if (diff.abs() < average * 0.02) {
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

  /// Returns generated history for the four sensor parameters (temperature,
  /// pH, salinity, ORP) as a named map.
  ///
  /// Uses realistic base values for a marine reef aquarium:
  /// - Temperature: 25.0 °C (±3 %)
  /// - pH: 8.2 (±2 %)
  /// - Salinity: 1.024 (±0.5 %)
  /// - ORP: 350 mV (±8 %)
  Map<String, List<ParameterDataPoint>> getAllParametersHistory({
    int hours = 24,
  }) {
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

  /// Clears all cached history data.
  ///
  /// The next call to [generateHistory] will produce a freshly randomised
  /// dataset.
  void clearCache() {
    _history.clear();
  }

  /// Appends [point] to the 24-hour cache slot for its parameter.
  ///
  /// The list is capped at 96 entries (one per 15-minute interval over 24
  /// hours); the oldest entry is dropped when the cap is exceeded.
  void addDataPoint(ParameterDataPoint point) {
    final key = '${point.parameterName}_24h';
    if (!_history.containsKey(key)) {
      _history[key] = [];
    }

    _history[key]!.add(point);

    if (_history[key]!.length > 96) {
      _history[key]!.removeAt(0);
    }
  }
}
