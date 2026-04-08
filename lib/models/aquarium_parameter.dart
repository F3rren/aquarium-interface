/// Enum identifying each monitored water parameter in a ReefLife aquarium.
library;

/// Uniquely identifies one of the nine water parameters tracked by the app.
///
/// Used as a key in alert configurations, threshold maps, localisation helpers,
/// and parameter service calls to avoid stringly-typed comparisons.
enum AquariumParameter {
  /// Water temperature in °C.
  temperature,

  /// Potential of hydrogen — acidity/alkalinity scale (dimensionless).
  ph,

  /// Salt concentration; stored as specific gravity (e.g. 1.025).
  salinity,

  /// Oxidation-Reduction Potential in millivolts (mV).
  orp,

  /// Dissolved calcium concentration in mg/L.
  calcium,

  /// Dissolved magnesium concentration in mg/L.
  magnesium,

  /// Carbonate hardness / alkalinity in degrees KH (dKH).
  kh,

  /// Nitrate concentration in mg/L.
  nitrate,

  /// Phosphate concentration in mg/L.
  phosphate;

  /// Returns the display unit suffix for this parameter, including a leading
  /// space where appropriate (e.g. `' °C'`, `' mV'`).
  ///
  /// Returns an empty string for dimensionless parameters ([ph], [salinity]).
  String get unit {
    switch (this) {
      case temperature:
        return ' °C';
      case ph:
        return '';
      case salinity:
        return '';
      case orp:
        return ' mV';
      case calcium:
      case magnesium:
      case nitrate:
      case phosphate:
        return ' mg/L';
      case kh:
        return ' dKH';
    }
  }
}
