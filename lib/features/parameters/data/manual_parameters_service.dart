/// Service for saving and loading manually-entered water parameters.
library;

import 'package:acquariumfe/core/constants/api_endpoints.dart';
import 'package:acquariumfe/core/network/api_service.dart';

/// Service that persists the five parameters that are entered manually by the
/// user (i.e. not measured by electronic sensors): calcium, magnesium, KH,
/// nitrate, and phosphate.
///
/// Manual parameters are stored on the backend at
/// `POST /aquariums/{id}/parameters/manual` and retrieved with
/// `GET /aquariums/{id}/parameters/manual`. The `measuredAt` field is set to
/// the current UTC timestamp on every save.
///
/// The target aquarium is passed explicitly to every operation as
/// [aquariumId]; the service holds no mutable "current aquarium" state. On any
/// network error [loadManualParameters] falls back to [_getDefaultValues]
/// (typical marine reef reference values) so the UI always has something to
/// display.
class ManualParametersService {
  /// Creates a service backed by the shared [ApiService].
  ///
  /// Obtain the app-wide instance via Riverpod
  /// ([manualParametersServiceProvider]) rather than constructing directly.
  ManualParametersService(this._apiService);

  final ApiService _apiService;

  /// Saves the provided manual parameters for aquarium [aquariumId].
  ///
  /// Only non-null values are included in the request body. The timestamp
  /// `measuredAt` is always included.
  Future<void> saveManualParameters(
    int aquariumId, {
    double? calcium,
    double? magnesium,
    double? kh,
    double? nitrate,
    double? phosphate,
  }) async {
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
        ApiEndpoints.manualParameters(aquariumId),
        body,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Loads the most-recently saved manual parameters for aquarium [aquariumId].
  ///
  /// Falls back to [_getDefaultValues] when the backend returns an unexpected
  /// response shape or any network/parse error occurs.
  ///
  /// Default marine reference values:
  /// - calcium: 420 mg/L
  /// - magnesium: 1280 mg/L
  /// - kh: 9 dKH
  /// - nitrate: 5 mg/L
  /// - phosphate: 0.03 mg/L
  Future<Map<String, double>> loadManualParameters(int aquariumId) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.manualParameters(aquariumId),
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

  /// Returns the value of a single parameter [key] for aquarium [aquariumId].
  ///
  /// [key] must be one of `'calcium'`, `'magnesium'`, `'kh'`, `'nitrate'`,
  /// `'phosphate'`. Returns `0.0` when the key is not found.
  Future<double> getParameter(int aquariumId, String key) async {
    final params = await loadManualParameters(aquariumId);
    return params[key] ?? 0.0;
  }

  /// Updates a single parameter [key] to [value] for aquarium [aquariumId]
  /// without modifying the others.
  ///
  /// Reads the current values first, then writes back the full map with [key]
  /// replaced.
  Future<void> updateParameter(
    int aquariumId,
    String key,
    double value,
  ) async {
    final current = await loadManualParameters(aquariumId);

    await saveManualParameters(
      aquariumId,
      calcium: key == 'calcium' ? value : current['calcium'],
      magnesium: key == 'magnesium' ? value : current['magnesium'],
      kh: key == 'kh' ? value : current['kh'],
      nitrate: key == 'nitrate' ? value : current['nitrate'],
      phosphate: key == 'phosphate' ? value : current['phosphate'],
    );
  }

  /// Returns the `measuredAt` timestamp of the most-recently saved manual
  /// parameter set for aquarium [aquariumId], or `null` if none exists or on
  /// any error.
  Future<DateTime?> getLastUpdate(int aquariumId) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.manualParameters(aquariumId),
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

  /// Resets all manual parameters for aquarium [aquariumId] to backend defaults
  /// by calling `DELETE /aquariums/{id}/parameters/manual`.
  Future<void> resetToDefaults(int aquariumId) async {
    try {
      await _apiService.delete(
        ApiEndpoints.manualParameters(aquariumId),
      );
    } catch (e) {
      rethrow;
    }
  }
}
