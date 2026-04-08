/// Service that fetches and caches the coral species catalogue from the API.
library;

import '../models/coral_species.dart';
import 'api_service.dart';

/// Singleton that provides read-only access to the coral species database.
///
/// The full catalogue is fetched from `GET /species/corals` on the first call
/// and held in [_cachedCorals] for the lifetime of the app. Call [clearCache]
/// to force a re-fetch on the next request.
///
/// **Freshwater aquariums:** corals are exclusively marine organisms. Any call
/// to [getCoralsByWaterType] with a freshwater value returns an empty list
/// immediately without hitting the network.
///
/// **Error handling:** all public methods return an empty list on network or
/// parse errors rather than propagating exceptions, so the UI can degrade
/// gracefully.
class CoralDatabaseService {
  static final CoralDatabaseService _instance =
      CoralDatabaseService._internal();
  factory CoralDatabaseService() => _instance;
  CoralDatabaseService._internal();

  final _apiService = ApiService();

  /// In-memory cache; `null` means the catalogue has not been loaded yet.
  List<CoralSpecies>? _cachedCorals;

  /// Returns all coral species from the backend catalogue.
  ///
  /// Results are cached after the first successful fetch. Individual items that
  /// fail to parse are silently skipped to avoid a single malformed record
  /// preventing the entire list from loading.
  Future<List<CoralSpecies>> getAllCorals() async {
    if (_cachedCorals != null) {
      return _cachedCorals!;
    }

    try {
      final response = await _apiService.get('/species/corals');

      // Normalise the two possible response shapes.
      List<dynamic> coralList;
      if (response is List) {
        coralList = response;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          var dataField = response['data'];
          coralList = dataField is List ? dataField : [];
        } else if (response.containsKey('corals')) {
          coralList = response['corals'] as List? ?? [];
        } else {
          coralList = [];
        }
      } else {
        coralList = [];
      }

      // Parse each item individually; log and skip on error.
      _cachedCorals = [];
      for (var i = 0; i < coralList.length; i++) {
        try {
          final coral = CoralSpecies.fromJson(coralList[i] as Map<String, dynamic>);
          _cachedCorals!.add(coral);
        } catch (e) {
          // Skip malformed entries silently.
        }
      }

      return _cachedCorals!;
    } catch (e) {
      return [];
    }
  }

  /// Returns corals whose [CoralSpecies.commonName], [CoralSpecies.scientificName],
  /// or [CoralSpecies.type] contains [query] (case-insensitive).
  ///
  /// Returns the full catalogue when [query] is empty.
  Future<List<CoralSpecies>> searchCorals(String query) async {
    final allCorals = await getAllCorals();
    if (query.isEmpty) return allCorals;

    final lowerQuery = query.toLowerCase();
    return allCorals.where((coral) {
      return coral.commonName.toLowerCase().contains(lowerQuery) ||
          coral.scientificName.toLowerCase().contains(lowerQuery) ||
          coral.type.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Returns corals whose [CoralSpecies.difficulty] exactly matches
  /// [difficulty] (e.g. `'easy'`, `'moderate'`, `'expert'`).
  Future<List<CoralSpecies>> getCoralsByDifficulty(String difficulty) async {
    final allCorals = await getAllCorals();
    return allCorals.where((coral) => coral.difficulty == difficulty).toList();
  }

  /// Returns corals of a specific [type] (e.g. `'SPS'`, `'LPS'`, `'soft'`).
  /// Comparison is case-insensitive.
  Future<List<CoralSpecies>> getCoralsByType(String type) async {
    final allCorals = await getAllCorals();
    return allCorals
        .where((coral) => coral.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  /// Returns corals compatible with [waterType].
  ///
  /// Since all corals are marine, this method returns the full catalogue for
  /// saltwater/marine/reef types and an **empty list** for freshwater types.
  ///
  /// [waterType] is normalised via [_normalizeWaterType] so that both Italian
  /// (`'marino'`, `'salata'`) and English (`'marine'`, `'saltwater'`, `'reef'`)
  /// strings are accepted.
  Future<List<CoralSpecies>> getCoralsByWaterType(String waterType) async {
    final normalizedWaterType = _normalizeWaterType(waterType);

    if (normalizedWaterType == 'salata') {
      return await getAllCorals();
    }

    // Corals do not live in freshwater.
    return [];
  }

  /// Normalises a water-type string to one of `'salata'` (saltwater) or
  /// `'dolce'` (freshwater).
  ///
  /// Accepts Italian and English variants (case-insensitive):
  /// - Saltwater: `'marin*'`, `'salt*'`, `'reef'`, `'salat*'`
  /// - Freshwater: `'dolce'`, `'fresh*'`
  String _normalizeWaterType(String waterType) {
    final normalized = waterType.toLowerCase().trim();

    if (normalized.contains('marin') ||
        normalized.contains('salt') ||
        normalized.contains('reef') ||
        normalized.contains('salat')) {
      return 'salata';
    } else if (normalized.contains('dolce') ||
               normalized.contains('fresh')) {
      return 'dolce';
    }

    return normalized;
  }

  /// Returns corals whose [CoralSpecies.lightRequirement] matches
  /// [lightRequirement] (e.g. `'low'`, `'medium'`, `'high'`).
  Future<List<CoralSpecies>> getCoralsByLightRequirement(
    String lightRequirement,
  ) async {
    final allCorals = await getAllCorals();
    return allCorals
        .where((coral) => coral.lightRequirement == lightRequirement)
        .toList();
  }

  /// Returns corals whose [CoralSpecies.minTankSize] is ≤ [tankSizeInLiters].
  Future<List<CoralSpecies>> getCoralsByTankSize(int tankSizeInLiters) async {
    final allCorals = await getAllCorals();
    return allCorals
        .where((coral) => coral.minTankSize <= tankSizeInLiters)
        .toList();
  }

  /// Looks up a coral species by its string [id]. Returns `null` when not found.
  Future<CoralSpecies?> getCoralById(String id) async {
    final allCorals = await getAllCorals();
    try {
      return allCorals.firstWhere((coral) => coral.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clears the in-memory cache so that the next call to [getAllCorals] will
  /// re-fetch from the backend.
  void clearCache() {
    _cachedCorals = null;
  }
}
