/// Model per i parametri dell'acquario
class AquariumParameters {
  final double temperature;
  final double ph;
  final double salinity;
  final double orp;
  final double? calcium;
  final double? magnesium;
  final double? kh;
  final double? nitrate;
  final double? phosphate;
  final DateTime timestamp;

  AquariumParameters({
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

  /// Factory per creare da JSON
  factory AquariumParameters.fromJson(Map<String, dynamic> json) {
    // Salinità viene mantenuta come PPT (1024, 1025, ecc.)
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

  /// Converti in JSON
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

  /// Converti in Map per compatibilità con MockDataService
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
