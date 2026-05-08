/// Snapshot of all water parameter readings for a single measurement event.
library;

import 'package:aquariums_service/api.dart';

/// A complete set of water-quality readings taken at a specific [timestamp].
///
/// The four core parameters ([temperature], [ph], [salinity], [orp]) are
/// always present. The remaining five ([calcium], [magnesium], [kh],
/// [nitrate], [phosphate]) are optional because some freshwater setups do
/// not track them.
///
/// **Salinity note:** values are stored as specific gravity (e.g. `1.025`),
/// not PSU or PPT, to match the backend schema.
class AquariumParameters {
  /// Water temperature in °C.
  final double temperature;

  /// pH value (dimensionless; typical marine range 8.0–8.4).
  final double ph;

  /// Salinity expressed as specific gravity (e.g. `1.025`).
  final double salinity;

  /// Oxidation-Reduction Potential in millivolts.
  final double orp;

  /// Dissolved calcium in mg/L. Optional; `null` if not measured.
  final double? calcium;

  /// Dissolved magnesium in mg/L. Optional; `null` if not measured.
  final double? magnesium;

  /// Carbonate hardness in dKH. Optional; `null` if not measured.
  final double? kh;

  /// Nitrate concentration in mg/L. Optional; `null` if not measured.
  final double? nitrate;

  /// Phosphate concentration in mg/L. Optional; `null` if not measured.
  final double? phosphate;

  /// UTC timestamp of when this measurement set was recorded.
  final DateTime timestamp;

  const AquariumParameters({
    required this.temperature,
    required this.ph,
    required this.salinity,
    required this.orp,
    this.calcium,
    this.magnesium,
    this.kh,
    this.nitrate,
    this.phosphate,
    required this.timestamp,
  });

  /// Creates from a [WaterParameterDTO] (sensor readings: temp, ph, salinity).
  factory AquariumParameters.fromWaterParameterDto(WaterParameterDTO dto) {
    return AquariumParameters(
      temperature: dto.temperature ?? 0.0,
      ph: dto.ph ?? 0.0,
      salinity: dto.salinity ?? 0.0,
      orp: 0.0,
      timestamp: dto.measuredAt ?? DateTime.now(),
    );
  }

  /// Creates from a [ManualParameterDTO] (manually measured: calcium, kh, etc.).
  factory AquariumParameters.fromManualParameterDto(ManualParameterDTO dto) {
    return AquariumParameters(
      temperature: 0.0,
      ph: 0.0,
      salinity: 0.0,
      orp: 0.0,
      calcium: dto.calcium,
      magnesium: dto.magnesium,
      kh: dto.kh,
      nitrate: dto.nitrate,
      phosphate: dto.phosphate,
      timestamp: dto.measuredAt,
    );
  }

  /// Creates from a [TargetParameterDTO] (all target values).
  factory AquariumParameters.fromTargetParameterDto(TargetParameterDTO dto) {
    return AquariumParameters(
      temperature: dto.temperature ?? 0.0,
      ph: dto.ph ?? 0.0,
      salinity: dto.salinity ?? 0.0,
      orp: dto.orp ?? 0.0,
      calcium: dto.calcium,
      magnesium: dto.magnesium,
      kh: dto.kh,
      nitrate: dto.nitrate,
      phosphate: dto.phosphate,
      timestamp: DateTime.now(),
    );
  }

  /// Deserialises an [AquariumParameters] snapshot from a backend JSON map.
  ///
  /// Accepts either `'measuredAt'` or `'timestamp'` as the timestamp key to
  /// handle both legacy and current backend response schemas. Falls back to
  /// [DateTime.now] if neither key is present.
  factory AquariumParameters.fromJson(Map<String, dynamic> json) {
    double salinity = (json['salinity'] ?? 0).toDouble();

    return AquariumParameters(
      temperature: (json['temperature'] ?? 0).toDouble(),
      ph: (json['ph'] ?? 0).toDouble(),
      salinity: salinity,
      orp: (json['orp'] ?? 0).toDouble(),
      calcium: json['calcium'] != null
          ? (json['calcium'] as num).toDouble()
          : null,
      magnesium: json['magnesium'] != null
          ? (json['magnesium'] as num).toDouble()
          : null,
      kh: json['kh'] != null ? (json['kh'] as num).toDouble() : null,
      nitrate: json['nitrate'] != null
          ? (json['nitrate'] as num).toDouble()
          : null,
      phosphate: json['phosphate'] != null
          ? (json['phosphate'] as num).toDouble()
          : null,
      timestamp: json['measuredAt'] != null
          ? DateTime.parse(json['measuredAt'])
          : (json['timestamp'] != null
                ? DateTime.parse(json['timestamp'])
                : DateTime.now()),
    );
  }

  /// Serialises this snapshot to a JSON map for API requests.
  ///
  /// Optional fields are omitted when `null` to avoid sending unnecessary
  /// null values to the backend.
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'ph': ph,
      'salinity': salinity,
      'orp': orp,
      if (calcium != null) 'calcium': calcium,
      if (magnesium != null) 'magnesium': magnesium,
      if (kh != null) 'kh': kh,
      if (nitrate != null) 'nitrate': nitrate,
      if (phosphate != null) 'phosphate': phosphate,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Returns a flat `Map<String, double>` containing only the non-null
  /// parameter values, keyed by parameter name.
  ///
  /// Useful for feeding data into chart services and legacy code that expects
  /// a plain map rather than a typed object.
  Map<String, double> toMap() {
    return {
      'temperature': temperature,
      'ph': ph,
      'salinity': salinity,
      'orp': orp,
      if (calcium != null) 'calcium': calcium!,
      if (magnesium != null) 'magnesium': magnesium!,
      if (kh != null) 'kh': kh!,
      if (nitrate != null) 'nitrate': nitrate!,
      if (phosphate != null) 'phosphate': phosphate!,
    };
  }
}
