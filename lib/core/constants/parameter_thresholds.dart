/// Single source of truth for the default "healthy" range of each monitored
/// water parameter.
///
/// These ranges are shared by:
/// - the dashboard alert indicator (`AquariumWithParams.hasAlert` and
///   `hasParameterAlerts`), and
/// - the default notification thresholds ([NotificationSettings]),
///
/// so the two can never silently disagree. Before this existed the dashboard
/// flagged a tank as healthy up to 27 °C while notifications fired above 26 °C.
///
/// **Salinity is expressed in PSU/ppt** (~35 = standard seawater), matching the
/// sensor readings carried by `AquariumParameters.salinity`.
library;

/// An inclusive numeric `[min, max]` range for a water parameter.
class ParameterRange {
  /// Lower bound of the acceptable range (inclusive).
  final double min;

  /// Upper bound of the acceptable range (inclusive).
  final double max;

  const ParameterRange(this.min, this.max);

  /// Whether [value] lies within the inclusive range.
  bool contains(double value) => value >= min && value <= max;

  /// Whether [value] lies outside the inclusive range.
  bool isOutOfRange(double value) => value < min || value > max;
}

/// Canonical default ranges for a marine-reef aquarium.
///
/// Tune the whole app's "what counts as out of range" behaviour from this one
/// place. Values reflect commonly cited reef tolerances; adjust to taste.
abstract final class ParameterThresholdDefaults {
  /// Water temperature, °C.
  static const ParameterRange temperature = ParameterRange(24.0, 27.0);

  /// pH (dimensionless).
  static const ParameterRange ph = ParameterRange(7.8, 8.5);

  /// Salinity, **PSU/ppt** (~35 = standard seawater), matching the sensor scale.
  static const ParameterRange salinity = ParameterRange(33.0, 37.0);

  /// Oxidation-reduction potential, mV.
  static const ParameterRange orp = ParameterRange(300.0, 400.0);

  /// Dissolved calcium, mg/L.
  static const ParameterRange calcium = ParameterRange(400.0, 450.0);

  /// Dissolved magnesium, mg/L.
  static const ParameterRange magnesium = ParameterRange(1250.0, 1350.0);

  /// Carbonate hardness, dKH.
  static const ParameterRange kh = ParameterRange(7.0, 9.0);

  /// Nitrate, mg/L.
  static const ParameterRange nitrate = ParameterRange(0.0, 10.0);

  /// Phosphate, mg/L.
  static const ParameterRange phosphate = ParameterRange(0.0, 0.1);
}
