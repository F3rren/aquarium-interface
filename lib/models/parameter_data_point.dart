/// Models for historical parameter data points and derived statistics.
library;

import 'package:flutter/material.dart';
import 'package:acquariumfe/l10n/app_localizations.dart';

/// A single timestamped measurement for one water parameter.
///
/// Used by [ChartDataService] and the charts view to plot historical trends.
class ParameterDataPoint {
  /// UTC timestamp of when this measurement was recorded.
  final DateTime timestamp;

  /// The measured value (units depend on [parameterName]).
  final double value;

  /// The parameter being measured (e.g. `'temperature'`, `'ph'`).
  final String parameterName;

  ParameterDataPoint({
    required this.timestamp,
    required this.value,
    required this.parameterName,
  });

  /// Deserialises a [ParameterDataPoint] from a JSON map.
  factory ParameterDataPoint.fromJson(Map<String, dynamic> json) {
    return ParameterDataPoint(
      timestamp: DateTime.parse(json['timestamp']),
      value: (json['value'] as num).toDouble(),
      parameterName: json['parameterName'] as String,
    );
  }

  /// Serialises this data point to a JSON map.
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

/// Derived statistical summary computed from a set of [ParameterDataPoint]s.
///
/// Typically returned by [ChartDataService] alongside the raw data points.
class ParameterStats {
  /// Minimum value observed in the dataset.
  final double min;

  /// Maximum value observed in the dataset.
  final double max;

  /// Mean (arithmetic average) of all values.
  final double average;

  /// Most recent (latest) value in the dataset.
  final double current;

  /// Direction of the short-term trend derived from the last few readings.
  final TrendDirection trend;

  /// Total number of data points used to compute these statistics.
  final int dataPoints;

  ParameterStats({
    required this.min,
    required this.max,
    required this.average,
    required this.current,
    required this.trend,
    required this.dataPoints,
  });

  /// Returns the percentage deviation of [current] from [average].
  ///
  /// Positive values mean the current reading is above average; negative
  /// values mean it is below average.
  double get variationFromAverage => ((current - average) / average) * 100;

  /// Returns `true` when [current] is within ±5 % of [average], indicating
  /// the parameter is effectively stable.
  bool get isStable => variationFromAverage.abs() < 5;
}

/// Describes the direction of a parameter's short-term trend.
enum TrendDirection {
  /// The parameter is increasing over recent readings.
  rising,

  /// The parameter is decreasing over recent readings.
  falling,

  /// The parameter has remained roughly constant.
  stable,
}

/// Adds display helpers to [TrendDirection].
extension TrendDirectionExtension on TrendDirection {
  /// Unicode arrow emoji representing the trend direction.
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

  /// Non-localised Italian fallback label.
  ///
  /// Prefer [getLocalizedLabel] when a [BuildContext] is available.
  String get label {
    switch (this) {
      case TrendDirection.rising:
        return 'In Aumento';
      case TrendDirection.falling:
        return 'In Diminuzione';
      case TrendDirection.stable:
        return 'Stabile';
    }
  }

  /// Returns the ARB-localised label for the trend direction.
  ///
  /// Requires a valid [BuildContext] with [AppLocalizations] present.
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
