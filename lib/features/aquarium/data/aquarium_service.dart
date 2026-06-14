/// CRUD service for aquariums and their water-parameter records.
library;

import 'package:acquariumfe/core/constants/api_endpoints.dart';
import 'package:acquariumfe/features/aquarium/domain/models/aquarium.dart';
import 'package:acquariumfe/features/parameters/domain/models/aquarium_parameters.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import 'package:acquariumfe/core/network/api_service.dart';

/// Handles all backend operations related to aquariums and their water
/// parameters.
///
/// Every method delegates to [ApiService] and normalises the two response
/// shapes the backend may return:
/// - **direct array** – `[{...}, {...}]`
/// - **wrapper object** – `{"data": [...]}` or `{"aquariums": [...]}`
///
/// [DataFormatException] is thrown when neither shape is recognised.
class AquariumsService {
  /// Creates an [AquariumsService] backed by [apiService].
  ///
  /// Obtain the shared instance via Riverpod ([aquariumsServiceProvider])
  /// rather than constructing directly.
  AquariumsService(this._apiService);

  final ApiService _apiService;

  /// Fetches all aquariums belonging to the authenticated user.
  ///
  /// Handles both a direct JSON array and wrapper objects keyed by
  /// `"aquariums"` or `"data"`.
  Future<List<Aquarium>> getAquariums() async {
    final response = await _apiService.get(ApiEndpoints.aquariums);

    final List<dynamic> aquariumsJson;

    if (response is List) {
      aquariumsJson = response;
    } else if (response is Map<String, dynamic>) {
      if (response.containsKey('aquariums')) {
        aquariumsJson = response['aquariums'] as List<dynamic>;
      } else if (response.containsKey('data')) {
        aquariumsJson = response['data'] as List<dynamic>;
      } else {
        throw DataFormatException(
          'Formato risposta non valido: chiave "aquariums" o "data" non trovata',
        );
      }
    } else {
      throw DataFormatException(
        'Formato risposta non valido: attesa lista o mappa',
        details: 'Ricevuto tipo: ${response.runtimeType}',
      );
    }

    return aquariumsJson
        .map((json) => Aquarium.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }

  /// Fetches a single aquarium by its integer [id].
  ///
  /// Unwraps a `"data"` wrapper if present. Returns `null` only when the
  /// response body cannot be parsed; HTTP 404 propagates as a [NetworkException]
  /// from [ApiService].
  Future<Aquarium?> getAquariumById(int id) async {
    final response = await _apiService.get(ApiEndpoints.aquarium(id));
    if (response is Map<String, dynamic>) {
      final aquariumData = response['data'] ?? response;
      return Aquarium.fromJson(Map<String, dynamic>.from(aquariumData as Map));
    } else {
      throw DataFormatException(
        'Formato risposta non valido: attesa mappa',
        details: 'Ricevuto tipo: ${response.runtimeType}',
      );
    }
  }

  /// Creates a new aquarium and returns the backend-persisted entity (with its
  /// assigned [Aquarium.id]).
  Future<Aquarium> createAquarium(Aquarium aquarium) async {
    final response = await _apiService.post(ApiEndpoints.aquariums, aquarium.toJson());
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return Aquarium.fromJson(Map<String, dynamic>.from(response['data'] as Map));
    }
    return Aquarium.fromJson(Map<String, dynamic>.from(response as Map));
  }

  /// Replaces the aquarium identified by [id] with the supplied [aquarium]
  /// data and returns the updated entity.
  Future<Aquarium> updateAquarium(int id, Aquarium aquarium) async {
    final response = await _apiService.put(ApiEndpoints.aquarium(id), aquarium.toJson());
    return Aquarium.fromJson(Map<String, dynamic>.from(response as Map));
  }

  /// Permanently deletes the aquarium with the given [id].
  Future<void> deleteAquarium(int id) async {
    await _apiService.delete(ApiEndpoints.aquarium(id));
  }

  /// Fetches the most-recent water-parameter snapshot for aquarium [aquariumId].
  ///
  /// Unwraps a `"data"` wrapper if present. The backend endpoint is
  /// `GET /aquariums/{id}/parameters`.
  Future<AquariumParameters> getAquariumParameters(int aquariumId) async {
    final response = await _apiService.get(ApiEndpoints.parameters(aquariumId));

    final Map<String, dynamic> parametersData;
    if (response is Map<String, dynamic>) {
      if (response.containsKey('data')) {
        parametersData = response['data'] as Map<String, dynamic>;
      } else {
        parametersData = response;
      }
    } else {
      throw DataFormatException(
        'Formato risposta non valido: attesa mappa',
        details: 'Ricevuto tipo: ${response.runtimeType}',
      );
    }

    return AquariumParameters.fromJson(parametersData);
  }

  /// Fetches historical parameter snapshots for aquarium [aquariumId].
  ///
  /// Optional filters:
  /// - [from] / [to] — ISO-8601 date range
  /// - [limit] — maximum number of records to return
  ///
  /// Accepts direct arrays as well as wrapper objects keyed by `"history"` or
  /// `"data"`. The backend endpoint is
  /// `GET /aquariums/{id}/parameters/history`.
  Future<List<AquariumParameters>> getAquariumParameterHistory({
    required int aquariumId,
    DateTime? from,
    DateTime? to,
    int? limit,
  }) async {
    final queryParams = <String, String>{};
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();
    if (limit != null) queryParams['limit'] = limit.toString();

    final query = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    final base = ApiEndpoints.parameterHistory(aquariumId);
    final endpoint = query.isNotEmpty ? '$base?$query' : base;

    final response = await _apiService.get(endpoint);

    final List<dynamic> historyJson;
    if (response is List) {
      historyJson = response;
    } else if (response is Map<String, dynamic>) {
      if (response.containsKey('history')) {
        historyJson = response['history'] as List<dynamic>;
      } else if (response.containsKey('data')) {
        historyJson = response['data'] as List<dynamic>;
      } else {
        throw DataFormatException(
          'Formato risposta non valido per lo storico parametri',
        );
      }
    } else {
      throw DataFormatException(
        'Formato risposta non valido: attesa lista o mappa',
        details: 'Ricevuto tipo: ${response.runtimeType}',
      );
    }

    return historyJson
        .map((json) => AquariumParameters.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
  }
}
