/// Service for managing user-defined target values for water parameters.
library;

import 'api_service.dart';

/// Singleton that persists and retrieves the four target parameter values
/// (temperature, pH, salinity, ORP) for the current aquarium.
///
/// Target values represent the ideal set-points the user is aiming for, as
/// opposed to the acceptable min/max ranges stored in [NotificationSettings].
/// They are used by the dashboard progress bars and health indicators.
///
/// **Storage strategy:** all four targets are stored together as a single JSON
/// object at `POST /aquariums/{id}/settings/targets`. [saveTarget] reads all
/// current values, patches the one being changed, and writes the full object
/// back (full-replace strategy).
///
/// **Caching:** [_cachedTargets] is populated on the first [loadAllTargets]
/// call. The cache is cleared when the active aquarium changes. Call
/// [loadAllTargets] again to refresh.
///
/// **Default values** (used when no aquarium is selected or on network error):
/// - temperature: 25.0 °C
/// - ph: 8.2
/// - salinity: 1024.0 (specific gravity × 1000)
/// - orp: 360.0 mV
class TargetParametersService {
  static final TargetParametersService _instance =
      TargetParametersService._internal();
  factory TargetParametersService() => _instance;
  TargetParametersService._internal();

  final ApiService _apiService = ApiService();

  /// ID of the currently active aquarium.
  int? _currentAquariumId;

  /// In-memory cache; `null` means targets have not been loaded yet.
  Map<String, double>? _cachedTargets;

  // ── Defaults ─────────────────────────────────────────────────────────────

  /// Default target temperature in °C.
  static const double defaultTemperature = 25.0;

  /// Default target pH.
  static const double defaultPh = 8.2;

  /// Default target salinity (stored as specific gravity × 1000, e.g. 1024 for
  /// a value of 1.024).
  static const double defaultSalinity = 1024.0;

  /// Default target ORP in mV.
  static const double defaultOrp = 360.0;

  /// Sets the active aquarium and clears the target cache.
  void setCurrentAquarium(int id) {
    _currentAquariumId = id;
    _cachedTargets = null;
  }

  Map<String, double> _getDefaults() {
    return {
      'temperature': defaultTemperature,
      'ph': defaultPh,
      'salinity': defaultSalinity,
      'orp': defaultOrp,
    };
  }

  /// Loads all target values from the backend.
  ///
  /// Returns [_getDefaults] when:
  /// - no aquarium is selected
  /// - the backend response does not contain a `"data"` map
  /// - any network or parse error occurs
  ///
  /// Serves from [_cachedTargets] on subsequent calls until the cache is
  /// invalidated.
  Future<Map<String, double>> loadAllTargets() async {
    if (_currentAquariumId == null) {
      return _getDefaults();
    }

    if (_cachedTargets != null) {
      return _cachedTargets!;
    }

    try {
      final response = await _apiService.get(
        '/aquariums/$_currentAquariumId/settings/targets',
      );

      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final data = response['data'] as Map<String, dynamic>;
        _cachedTargets = {
          'temperature': (data['temperature'] ?? defaultTemperature).toDouble(),
          'ph': (data['ph'] ?? defaultPh).toDouble(),
          'salinity': (data['salinity'] ?? defaultSalinity).toDouble(),
          'orp': (data['orp'] ?? defaultOrp).toDouble(),
        };
        return _cachedTargets!;
      }

      return _getDefaults();
    } catch (e) {
      return _getDefaults();
    }
  }

  /// Updates a single [parameter] to [value] and persists all four targets.
  ///
  /// The full-replace strategy is used: all existing targets are loaded,
  /// [parameter] is updated in-memory, and the complete map is POSTed back.
  /// [parameter] must be a lowercase key: `'temperature'`, `'ph'`,
  /// `'salinity'`, or `'orp'`.
  ///
  /// Throws if no aquarium has been selected.
  Future<void> saveTarget(String parameter, double value) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      final allTargets = await loadAllTargets();

      allTargets[parameter.toLowerCase()] = value;

      await _apiService.post(
        '/aquariums/$_currentAquariumId/settings/targets',
        allTargets,
      );

      _cachedTargets = allTargets;
    } catch (e) {
      rethrow;
    }
  }

  /// Returns the target temperature, falling back to [defaultTemperature].
  Future<double> getTargetTemperature() async {
    final targets = await loadAllTargets();
    return targets['temperature'] ?? defaultTemperature;
  }

  /// Returns the target pH, falling back to [defaultPh].
  Future<double> getTargetPh() async {
    final targets = await loadAllTargets();
    return targets['ph'] ?? defaultPh;
  }

  /// Returns the target salinity (as specific gravity × 1000), falling back to
  /// [defaultSalinity].
  Future<double> getTargetSalinity() async {
    final targets = await loadAllTargets();
    return targets['salinity'] ?? defaultSalinity;
  }

  /// Returns the target ORP in mV, falling back to [defaultOrp].
  Future<double> getTargetOrp() async {
    final targets = await loadAllTargets();
    return targets['orp'] ?? defaultOrp;
  }

  /// Resets all targets to [_getDefaults] by posting the default map to the
  /// backend and updating the local cache.
  ///
  /// Throws if no aquarium has been selected.
  Future<void> resetToDefaults() async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    await _apiService.post(
      '/aquariums/$_currentAquariumId/settings/targets',
      _getDefaults(),
    );

    _cachedTargets = _getDefaults();
  }
}
