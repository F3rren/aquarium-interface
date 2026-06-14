/// Service for managing user-defined target values for water parameters.
library;

import 'package:acquariumfe/core/constants/api_endpoints.dart';
import 'package:acquariumfe/core/network/api_service.dart';

/// Persists and retrieves the four target parameter values
/// (temperature, pH, salinity, ORP) for a given aquarium.
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
/// **Caching:** loaded targets are cached per aquarium in [_cache]; the target
/// aquarium is passed explicitly to every call, so the service holds no mutable
/// "current aquarium" state.
///
/// **Default values** (used on a missing `"data"` map or any network error):
/// - temperature: 25.0 °C
/// - ph: 8.2
/// - salinity: 35.0 (PSU/ppt)
/// - orp: 360.0 mV
class TargetParametersService {
  /// Creates a [TargetParametersService] backed by [apiService].
  ///
  /// Obtain the shared instance via Riverpod ([targetParametersServiceProvider])
  /// rather than constructing directly.
  TargetParametersService(this._apiService);

  final ApiService _apiService;

  /// Per-aquarium in-memory cache of loaded targets.
  final Map<int, Map<String, double>> _cache = {};

  // ── Defaults ─────────────────────────────────────────────────────────────

  /// Default target temperature in °C.
  static const double defaultTemperature = 25.0;

  /// Default target pH.
  static const double defaultPh = 8.2;

  /// Default target salinity in PSU/ppt (~35 = standard seawater).
  static const double defaultSalinity = 35.0;

  /// Default target ORP in mV.
  static const double defaultOrp = 360.0;

  Map<String, double> _getDefaults() {
    return {
      'temperature': defaultTemperature,
      'ph': defaultPh,
      'salinity': defaultSalinity,
      'orp': defaultOrp,
    };
  }

  /// Loads all target values for aquarium [aquariumId] from the backend.
  ///
  /// Returns [_getDefaults] when the backend response does not contain a
  /// `"data"` map or any network/parse error occurs. Serves from the
  /// per-aquarium cache on subsequent calls.
  Future<Map<String, double>> loadAllTargets(int aquariumId) async {
    final cached = _cache[aquariumId];
    if (cached != null) {
      return cached;
    }

    try {
      final response = await _apiService.get(
        ApiEndpoints.targetSettings(aquariumId),
      );

      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final data = response['data'] as Map<String, dynamic>;
        final Map<String, double> targets = {
          'temperature': (data['temperature'] ?? defaultTemperature).toDouble(),
          'ph': (data['ph'] ?? defaultPh).toDouble(),
          'salinity': (data['salinity'] ?? defaultSalinity).toDouble(),
          'orp': (data['orp'] ?? defaultOrp).toDouble(),
        };
        _cache[aquariumId] = targets;
        return targets;
      }

      return _getDefaults();
    } catch (e) {
      return _getDefaults();
    }
  }

  /// Updates a single [parameter] to [value] for aquarium [aquariumId] and
  /// persists all four targets.
  ///
  /// The full-replace strategy is used: all existing targets are loaded,
  /// [parameter] is updated in-memory, and the complete map is POSTed back.
  /// [parameter] must be a lowercase key: `'temperature'`, `'ph'`,
  /// `'salinity'`, or `'orp'`.
  Future<void> saveTarget(
    int aquariumId,
    String parameter,
    double value,
  ) async {
    final allTargets = await loadAllTargets(aquariumId);
    allTargets[parameter.toLowerCase()] = value;

    await _apiService.post(
      ApiEndpoints.targetSettings(aquariumId),
      allTargets,
    );

    _cache[aquariumId] = allTargets;
  }

  /// Returns the target temperature, falling back to [defaultTemperature].
  Future<double> getTargetTemperature(int aquariumId) async {
    final targets = await loadAllTargets(aquariumId);
    return targets['temperature'] ?? defaultTemperature;
  }

  /// Returns the target pH, falling back to [defaultPh].
  Future<double> getTargetPh(int aquariumId) async {
    final targets = await loadAllTargets(aquariumId);
    return targets['ph'] ?? defaultPh;
  }

  /// Returns the target salinity in PSU/ppt, falling back to [defaultSalinity].
  Future<double> getTargetSalinity(int aquariumId) async {
    final targets = await loadAllTargets(aquariumId);
    return targets['salinity'] ?? defaultSalinity;
  }

  /// Returns the target ORP in mV, falling back to [defaultOrp].
  Future<double> getTargetOrp(int aquariumId) async {
    final targets = await loadAllTargets(aquariumId);
    return targets['orp'] ?? defaultOrp;
  }

  /// Resets all targets for aquarium [aquariumId] to [_getDefaults] by posting
  /// the default map to the backend and updating the cache.
  Future<void> resetToDefaults(int aquariumId) async {
    await _apiService.post(
      ApiEndpoints.targetSettings(aquariumId),
      _getDefaults(),
    );

    _cache[aquariumId] = _getDefaults();
  }
}
