/// Service for managing the fish and coral inhabitants of an aquarium.
library;

import '../models/fish.dart';
import '../models/coral.dart';
import 'api_service.dart';

/// Singleton that performs CRUD operations on aquarium inhabitants and
/// computes bio-load statistics.
///
/// Both fish and corals share a single unified endpoint:
/// `GET /aquariums/{id}/inhabitants` returns a list of inhabitant records
/// tagged with a `"type"` field (`"fish"` or `"coral"`). Each method filters
/// the response by type before mapping to the domain model.
///
/// [setCurrentAquarium] must be called whenever the selected aquarium changes;
/// all operations silently return empty results or throw if no aquarium is set.
class InhabitantsService {
  static final InhabitantsService _instance = InhabitantsService._internal();
  factory InhabitantsService() => _instance;

  InhabitantsService._internal();

  final ApiService _apiService = ApiService();

  /// ID of the currently selected aquarium. `null` means no aquarium is active.
  int? _currentAquariumId;

  /// Updates the currently active aquarium.
  ///
  /// All subsequent CRUD calls will target [aquariumId].
  void setCurrentAquarium(int aquariumId) {
    _currentAquariumId = aquariumId;
  }

  // ── Fish ──────────────────────────────────────────────────────────────────

  /// Returns all fish inhabitants of the current aquarium.
  ///
  /// Fetches the unified `/inhabitants` endpoint and filters for
  /// `type == 'fish'`. Fish size is sourced from `details.size`, falling back
  /// to `details.maxSize` or `10.0` if absent. Returns an empty list when no
  /// aquarium is selected or on any network error.
  Future<List<Fish>> getFish() async {
    if (_currentAquariumId == null) {
      return [];
    }

    try {
      final response = await _apiService.get(
        '/aquariums/$_currentAquariumId/inhabitants',
      );

      if (response['data'] == null) return [];

      final List<dynamic> inhabitants = response['data'] as List;

      return inhabitants.where((item) => item['type'] == 'fish').map((item) {
        final size =
            item['details']?['size'] ?? item['details']?['maxSize'] ?? 10.0;

        return Fish.fromJson({
          'id': item['id'].toString(),
          'name': item['commonName'] ?? '',
          'species': item['scientificName'] ?? '',
          'size': size is int ? size.toDouble() : (size as double),
          'addedDate': item['addedDate'] ?? DateTime.now().toIso8601String(),
          'notes': item['details']?['notes'] ?? '',
          'imageUrl': item['details']?['imageUrl'],
          'family': item['details']?['family'],
          'minTankSize': item['details']?['minTankSize'],
          'maxSize': item['details']?['maxSize']?.toDouble(),
          'difficulty': item['details']?['difficulty'],
          'temperament': item['details']?['temperament'],
          'diet': item['details']?['diet'],
          'description': item['details']?['description'],
          'reefSafe': item['details']?['reefSafe'],
        });
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Adds [fish] to the current aquarium using the species identified by
  /// [speciesId].
  ///
  /// [speciesId] is required — throws if `null`. The body posted to
  /// `POST /aquariums/{id}/inhabitants` uses `inhabitantType: 'fish'` and
  /// `quantity: 1`.
  Future<void> addFish(Fish fish, String? speciesId) async {
    if (_currentAquariumId == null) {
      throw Exception('No aquarium selected');
    }
    if (speciesId == null) {
      throw Exception('Species ID is required');
    }

    final body = {
      'inhabitantType': 'fish',
      'inhabitantId': int.parse(speciesId),
      'quantity': 1,
      'notes': fish.notes ?? '',
    };

    await _apiService.post('/aquariums/$_currentAquariumId/inhabitants', body);
  }

  /// Updates [fish] (size and notes) via
  /// `PUT /aquariums/{id}/inhabitants/{fishId}`.
  Future<void> updateFish(Fish fish) async {
    if (_currentAquariumId == null) {
      throw Exception('No aquarium selected');
    }

    final body = {'quantity': fish.size.toInt(), 'notes': fish.notes ?? ''};

    await _apiService.put(
      '/aquariums/$_currentAquariumId/inhabitants/${fish.id}',
      body,
    );
  }

  /// Permanently removes the fish with the given [id] from the current aquarium.
  Future<void> deleteFish(String id) async {
    if (_currentAquariumId == null) {
      throw Exception('No aquarium selected');
    }

    await _apiService.delete('/aquariums/$_currentAquariumId/inhabitants/$id');
  }

  // ── Corals ────────────────────────────────────────────────────────────────

  /// Returns all coral inhabitants of the current aquarium.
  ///
  /// Fetches the unified `/inhabitants` endpoint and filters for
  /// `type == 'coral'`. Coral size is sourced from `details.size`, falling
  /// back to `details.maxSize` or `5.0` if absent. Returns an empty list when
  /// no aquarium is selected or on any network error.
  Future<List<Coral>> getCorals() async {
    if (_currentAquariumId == null) {
      return [];
    }

    try {
      final response = await _apiService.get(
        '/aquariums/$_currentAquariumId/inhabitants',
      );

      if (response['data'] == null) return [];

      final List<dynamic> inhabitants = response['data'] as List;

      return inhabitants.where((item) => item['type'] == 'coral').map((item) {
        final size =
            item['details']?['size'] ?? item['details']?['maxSize'] ?? 5.0;

        return Coral.fromJson({
          'id': item['id'].toString(),
          'name': item['commonName'] ?? '',
          'species': item['scientificName'] ?? '',
          'type': item['details']?['type'] ?? 'SPS',
          'size': size is int ? size.toDouble() : (size as double),
          'addedDate': item['addedDate'] ?? DateTime.now().toIso8601String(),
          'placement': item['details']?['placement'] ?? 'Medio',
          'notes': item['details']?['notes'] ?? '',
          'imageUrl': null,
          'difficulty': item['details']?['difficulty'],
          'lightRequirement': item['details']?['lightRequirement'],
          'flowRequirement': item['details']?['flowRequirement'],
          'feeding': item['details']?['feeding'],
          'description': item['details']?['description'],
          'aggressive': item['details']?['aggressive'],
          'minTankSize': item['details']?['minTankSize'],
          'maxSize': item['details']?['maxSize'],
        });
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Adds [coral] to the current aquarium using the species identified by
  /// [speciesId].
  ///
  /// [speciesId] is required — throws if `null`. The body posted uses
  /// `inhabitantType: 'coral'` and `quantity: 1`.
  Future<void> addCoral(Coral coral, String? speciesId) async {
    if (_currentAquariumId == null) {
      throw Exception('No aquarium selected');
    }
    if (speciesId == null) {
      throw Exception('Species ID is required');
    }

    final body = {
      'inhabitantType': 'coral',
      'inhabitantId': int.parse(speciesId),
      'quantity': 1,
      'notes': coral.notes ?? '',
    };

    await _apiService.post('/aquariums/$_currentAquariumId/inhabitants', body);
  }

  /// Updates [coral] (size and notes) via
  /// `PUT /aquariums/{id}/inhabitants/{coralId}`.
  Future<void> updateCoral(Coral coral) async {
    if (_currentAquariumId == null) {
      throw Exception('No aquarium selected');
    }

    final body = {'quantity': coral.size.toInt(), 'notes': coral.notes ?? ''};

    await _apiService.put(
      '/aquariums/$_currentAquariumId/inhabitants/${coral.id}',
      body,
    );
  }

  /// Permanently removes the coral with the given [id] from the current
  /// aquarium.
  Future<void> deleteCoral(String id) async {
    if (_currentAquariumId == null) {
      throw Exception('No aquarium selected');
    }

    await _apiService.delete('/aquariums/$_currentAquariumId/inhabitants/$id');
  }

  // ── Statistics ────────────────────────────────────────────────────────────

  /// Computes population statistics for the current aquarium.
  ///
  /// Returns a map with:
  /// - `'totalFish'` — number of fish
  /// - `'totalCorals'` — number of corals
  /// - `'avgFishSize'` — average fish size in cm (0.0 if no fish)
  /// - `'totalBioLoad'` — sum of all fish sizes plus (coral count × 2.0),
  ///   representing the relative biological load on the filtration system
  Future<Map<String, dynamic>> getStatistics() async {
    final fish = await getFish();
    final corals = await getCorals();

    final totalFish = fish.length;
    final totalCorals = corals.length;
    final avgFishSize = fish.isEmpty
        ? 0.0
        : fish.map((f) => f.size).reduce((a, b) => a + b) / fish.length;
    final totalBioLoad =
        fish.fold<double>(0, (sum, f) => sum + f.size) + (corals.length * 2.0);

    return {
      'totalFish': totalFish,
      'totalCorals': totalCorals,
      'avgFishSize': avgFishSize,
      'totalBioLoad': totalBioLoad,
    };
  }
}
