/// Service that fetches and caches the fish species catalogue from the API.
library;

import 'package:acquariumfe/core/constants/api_endpoints.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/fish_species.dart';
import 'package:acquariumfe/core/network/api_service.dart';

/// Service that provides read-only access to the fish species database.
///
/// The full catalogue is fetched from `GET /species/fishs` and cached in
/// [_cachedFish] for [cacheTtl]; the next call after the cache expires refetches
/// it. Call [clearCache] to force an immediate re-fetch.
///
/// **Water-type filtering:** [getFishByWaterType] normalises Italian and English
/// water-type strings before comparing so that both `'Marino'` and `'saltwater'`
/// match the same set of fish.
///
/// **Error handling:** all public methods return an empty list on network or
/// parse errors so the UI degrades gracefully.
class FishDatabaseService {
  /// Creates a service backed by the shared [ApiService].
  ///
  /// Obtain the app-wide instance via Riverpod ([fishDatabaseServiceProvider])
  /// rather than constructing directly. [clock] is injectable so tests can
  /// drive the cache-expiry logic deterministically.
  FishDatabaseService(this._apiService, {DateTime Function()? clock})
      : _now = clock ?? DateTime.now;

  final ApiService _apiService;
  final DateTime Function() _now;

  /// How long a fetched catalogue is reused before the next call refetches it.
  ///
  /// Species are near-static reference data, so a generous TTL avoids redundant
  /// fetches within a session while still picking up backend changes eventually
  /// rather than caching for the entire app lifetime.
  static const Duration cacheTtl = Duration(hours: 1);

  /// In-memory cache; `null` means the catalogue has not been loaded yet.
  List<FishSpecies>? _cachedFish;

  /// Timestamp of the most-recent successful fetch; drives [cacheTtl].
  DateTime? _cachedAt;

  /// Returns all fish species from the backend catalogue.
  ///
  /// Results are cached after the first successful fetch. Accepts both a
  /// direct JSON array and wrapper objects keyed by `"data"` or `"fishs"`.
  Future<List<FishSpecies>> getAllFish() async {
    final cached = _cachedFish;
    final cachedAt = _cachedAt;
    if (cached != null &&
        cachedAt != null &&
        _now().difference(cachedAt) < cacheTtl) {
      return cached;
    }

    try {
      final response = await _apiService.get(ApiEndpoints.fishSpecies);

      // Normalise the two possible response shapes.
      List<dynamic> fishList;
      if (response is List) {
        fishList = response;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('data')) {
          var dataField = response['data'];
          fishList = dataField is List ? dataField : [];
        } else if (response.containsKey('fishs')) {
          fishList = response['fishs'] as List? ?? [];
        } else {
          fishList = [];
        }
      } else {
        fishList = [];
      }

      _cachedFish = fishList
          .map((json) => FishSpecies.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
      _cachedAt = _now();

      return _cachedFish!;
    } catch (e) {
      return [];
    }
  }

  /// Returns fish whose [FishSpecies.commonName], [FishSpecies.scientificName],
  /// or [FishSpecies.family] contains [query] (case-insensitive).
  ///
  /// Returns the full catalogue when [query] is empty.
  Future<List<FishSpecies>> searchFish(String query) async {
    final allFish = await getAllFish();
    if (query.isEmpty) return allFish;

    final lowerQuery = query.toLowerCase();
    return allFish.where((fish) {
      return fish.commonName.toLowerCase().contains(lowerQuery) ||
          fish.scientificName.toLowerCase().contains(lowerQuery) ||
          fish.family.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Returns fish whose [FishSpecies.difficulty] exactly matches [difficulty]
  /// (e.g. `'easy'`, `'moderate'`, `'expert'`).
  Future<List<FishSpecies>> getFishByDifficulty(String difficulty) async {
    final allFish = await getAllFish();
    return allFish.where((fish) => fish.difficulty == difficulty).toList();
  }

  /// Returns only reef-safe fish ([FishSpecies.reefSafe] == `true`).
  Future<List<FishSpecies>> getReefSafeFish() async {
    final allFish = await getAllFish();
    return allFish.where((fish) => fish.reefSafe).toList();
  }

  /// Returns fish whose [FishSpecies.minTankSize] is ≤ [tankSizeInLiters].
  Future<List<FishSpecies>> getFishByTankSize(int tankSizeInLiters) async {
    final allFish = await getAllFish();
    return allFish
        .where((fish) => fish.minTankSize <= tankSizeInLiters)
        .toList();
  }

  /// Looks up a fish species by its string [id]. Returns `null` when not found.
  Future<FishSpecies?> getFishById(String id) async {
    final allFish = await getAllFish();
    try {
      return allFish.firstWhere((fish) => fish.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Returns fish whose [FishSpecies.temperament] exactly matches
  /// [temperament] (e.g. `'peaceful'`, `'aggressive'`).
  Future<List<FishSpecies>> getFishByTemperament(String temperament) async {
    final allFish = await getAllFish();
    return allFish.where((fish) => fish.temperament == temperament).toList();
  }

  /// Returns fish whose [FishSpecies.family] contains [family]
  /// (case-insensitive substring match).
  Future<List<FishSpecies>> getFishByFamily(String family) async {
    final allFish = await getAllFish();
    return allFish
        .where(
          (fish) => fish.family.toLowerCase().contains(family.toLowerCase()),
        )
        .toList();
  }

  /// Returns fish compatible with [waterType].
  ///
  /// Fish with a `null` or empty [FishSpecies.waterType] are excluded. The
  /// comparison uses [_normalizeWaterType] so that Italian and English
  /// water-type strings are treated as equivalent:
  /// - Saltwater: `'marino'`, `'reef'`, `'salata'`, `'marine'`, `'saltwater'` → `'salata'`
  /// - Freshwater: `'dolce'`, `'freshwater'` → `'dolce'`
  Future<List<FishSpecies>> getFishByWaterType(String waterType) async {
    final allFish = await getAllFish();

    if (waterType.isEmpty) return allFish;

    final String normalizedWaterType = _normalizeWaterType(waterType);

    return allFish.where((fish) {
      if (fish.waterType == null || fish.waterType!.isEmpty) {
        return false;
      }
      return _normalizeWaterType(fish.waterType!) == normalizedWaterType;
    }).toList();
  }

  /// Normalises a water-type string to `'salata'` (saltwater) or `'dolce'`
  /// (freshwater) using exact lowercase matches.
  ///
  /// Accepted saltwater variants: `'marino'`, `'reef'`, `'salata'`, `'marine'`,
  /// `'saltwater'`.
  /// Accepted freshwater variants: `'dolce'`, `'freshwater'`.
  String _normalizeWaterType(String waterType) {
    final normalized = waterType.toLowerCase().trim();

    if (normalized == 'marino' ||
        normalized == 'reef' ||
        normalized == 'salata' ||
        normalized == 'marine' ||
        normalized == 'saltwater') {
      return 'salata';
    }

    if (normalized == 'dolce' || normalized == 'freshwater') {
      return 'dolce';
    }

    return normalized;
  }

  /// Returns a sorted, deduplicated list of all fish families in the catalogue.
  Future<List<String>> getAllFamilies() async {
    final allFish = await getAllFish();
    final families = allFish.map((fish) => fish.family).toSet().toList();
    families.sort();
    return families;
  }

  /// Clears the in-memory cache so that the next call to [getAllFish] will
  /// re-fetch from the backend.
  void clearCache() {
    _cachedFish = null;
    _cachedAt = null;
  }
}
