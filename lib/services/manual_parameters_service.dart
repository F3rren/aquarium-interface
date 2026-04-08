/// Service for saving and loading manually-entered water parameters.
library;

import 'package:acquariumfe/services/api_service.dart';

/// Singleton that persists the five parameters that are entered manually by the
/// user (i.e. not measured by electronic sensors): calcium, magnesium, KH,
/// nitrate, and phosphate.
///
/// Manual parameters are stored on the backend at
/// `POST /aquariums/{id}/parameters/manual` and retrieved with
/// `GET /aquariums/{id}/parameters/manual`. The `measuredAt` field is set to
/// the current UTC timestamp on every save.
///
/// When no aquarium is selected, or on any network error, [loadManualParameters]
/// falls back to [_getDefaultValues] (typical marine reef reference values) so
/// the UI always has something to display.
class ManualParametersService {
  static final ManualParametersService _instance =
      ManualParametersService._internal();
  factory ManualParametersService() => _instance;
  ManualParametersService._internal();

  final ApiService _apiService = ApiService();

  /// ID of the currently selected aquarium.
  int? _currentAquariumId;

  /// Sets the aquarium context for all subsequent operations.
  void setCurrentAquarium(int id) {
    _currentAquariumId = id;
  }

  /// Saves the provided manual parameters to the backend.
  ///
  /// Only non-null values are included in the request body. The timestamp
  /// `measuredAt` is always included. Throws if no aquarium has been selected.
  Future<void> saveManualParameters({
    double? calcium,
    double? magnesium,
    double? kh,
    double? nitrate,
    double? phosphate,
  }) async {
    if (_currentAquariumId == null) {
      throw Exception('Nessun acquario selezionato');
    }

    try {
      final body = <String, dynamic>{
        if (calcium != null) 'calcium': calcium,
        if (magnesium != null) 'magnesium': magnesium,
        if (kh != null) 'kh': kh,
        if (nitrate != null) 'nitrate': nitrate,
        if (phosphate != null) 'phosphate': phosphate,
        'measuredAt': DateTime.now().toIso8601String(),
      };

      await _apiService.post(
        '/aquariums/$_currentAquariumId/parameters/manual',
        body,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Loads the most-recently saved manual parameters for the current aquarium.
  ///
  /// Falls back to [_getDefaultValues] when:
  /// - no aquarium has been selected
  /// - the backend returns an unexpected response shape
  /// - any network or parse error occurs
  ///
  /// Default marine reference values:
  /// - calcium: 420 mg/L
  /// - magnesium: 1280 mg/L
  /// - kh: 9 dKH
  /// - nitrate: 5 mg/L
  /// - phosphate: 0.03 mg/L
  Future<Map<String, double>> loadManualParameters() async {
    if (_currentAquariumId == null) {
      return _getDefaultValues();
    }

    try {
      final response = await _apiService.get(
        '/aquariums/$_currentAquariumId/parameters/manual',
      );

      final Map<String, dynamic> data;
      if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          final dataValue = response['data'];
          if (dataValue is Map<String, dynamic>) {
            data = dataValue;
          } else {
            return _getDefaultValues();
          }
        } else {
          data = response;
        }
      } else {
        return _getDefaultValues();
      }

      return {
        'calcium': (data['calcium'] ?? 420.0).toDouble(),
        'magnesium': (data['magnesium'] ?? 1280.0).toDouble(),
        'kh': (data['kh'] ?? 9.0).toDouble(),
        'nitrate': (data['nitrate'] ?? 5.0).toDouble(),
        'phosphate': (data['phosphate'] ?? 0.03).toDouble(),
      };
    } catch (e) {
      return _getDefaultValues();
    }
  }

  /// Returns the value of a single parameter [key].
  ///
  /// [key] must be one of `'calcium'`, `'magnesium'`, `'kh'`, `'nitrate'`,
  /// `'phosphate'`. Returns `0.0` when the key is not found.
  Future<double> getParameter(String key) async {
    final params = await loadManualParameters();
    return params[key] ?? 0.0;
  }

  /// Updates a single parameter [key] to [value] without modifying the others.
  ///
  /// Reads the current values first, then writes back the full map with [key]
  /// replaced.
  Future<void> updateParameter(String key, double value) async {
    final current = await loadManualParameters();

    await saveManualParameters(
      calcium: key == 'calcium' ? value : current['calcium'],
      magnesium: key == 'magnesium' ? value : current['magnesium'],
      kh: key == 'kh' ? value : current['kh'],
      nitrate: key == 'nitrate' ? value : current['nitrate'],
      phosphate: key == 'phosphate' ? value : current['phosphate'],
    );
  }

  /// Returns the `measuredAt` timestamp of the most-recently saved manual
  /// parameter set, or `null` if none exists or on any error.
  Future<DateTime?> getLastUpdate() async {
    if (_currentAquariumId == null) return null;

    try {
      final response = await _apiService.get(
        '/aquariums/$_currentAquariumId/parameters/manual',
      );

      if (response is Map<String, dynamic> && response.containsKey('data')) {
        final data = response['data'];
        if (data is Map<String, dynamic> && data.containsKey('measuredAt')) {
          return DateTime.parse(data['measuredAt']);
        }
      }
    } catch (e) {
      // Ignore; return null below.
    }

    return null;
  }

  /// Returns the default marine reference values used as a fallback when no
  /// stored data is available.
  Map<String, double> _getDefaultValues() {
    return {
      'calcium': 420.0,
      'magnesium': 1280.0,
      'kh': 9.0,
      'nitrate': 5.0,
      'phosphate': 0.03,
    };
  }

  /// Resets all manual parameters to backend defaults by calling
  /// `DELETE /aquariums/{id}/parameters/manual`. Throws if no aquarium has
  /// been selected.
  Future<void> resetToDefaults() async {
    if (_currentAquariumId == null) return;

    try {
      await _apiService.delete(
        '/aquariums/$_currentAquariumId/parameters/manual',
      );
    } catch (e) {
      rethrow;
    }
  }
}
