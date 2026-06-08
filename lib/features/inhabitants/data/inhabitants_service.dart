/// Service for managing the fish and coral inhabitants of an aquarium.
library;

import 'package:acquariumfe/core/constants/api_endpoints.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/fish.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/coral.dart';
import 'package:acquariumfe/core/network/api_service.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import 'package:acquariumfe/core/utils/app_logger.dart';

/// Service that performs CRUD operations on aquarium inhabitants and
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
  /// Creates a service backed by the shared [ApiService].
  ///
  /// Obtain the app-wide instance via Riverpod ([inhabitantsServiceProvider])
  /// rather than constructing directly.
  InhabitantsService(this._apiService);

  final ApiService _apiService;

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
        ApiEndpoints.inhabitants(_currentAquariumId!),
      );

      if (response['data'] == null) return [];

      final List<dynamic> inhabitants = response['data'] as List;

      return inhabitants
          .where((item) => item['type'] == 'fish')
          .map((item) =>
              Fish.fromInhabitantJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      // Surface the failure: log it and let the caller decide how to react
      // (the inhabitants page shows an error SnackBar and keeps last data).
      AppLogger.w('Failed to load fish', error: e);
      rethrow;
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
      throw NoAquariumSelectedException();
    }
    if (speciesId == null) {
      throw ValidationException('Species ID is required');
    }

    final body = {
      'inhabitantType': 'fish',
      'inhabitantId': int.parse(speciesId),
      'quantity': 1,
      'notes': fish.notes ?? '',
    };

    await _apiService.post(ApiEndpoints.inhabitants(_currentAquariumId!), body);
  }

  /// Updates [fish] (size and notes) via
  /// `PUT /aquariums/{id}/inhabitants/{fishId}`.
  Future<void> updateFish(Fish fish) async {
    if (_currentAquariumId == null) {
      throw NoAquariumSelectedException();
    }

    final body = {'quantity': fish.size.toInt(), 'notes': fish.notes ?? ''};

    await _apiService.put(
      ApiEndpoints.inhabitant(_currentAquariumId!, int.parse(fish.id)),
      body,
    );
  }

  /// Permanently removes the fish with the given [id] from the current aquarium.
  Future<void> deleteFish(String id) async {
    if (_currentAquariumId == null) {
      throw NoAquariumSelectedException();
    }

    await _apiService.delete(
      ApiEndpoints.inhabitant(_currentAquariumId!, int.parse(id)),
    );
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
        ApiEndpoints.inhabitants(_currentAquariumId!),
      );

      if (response['data'] == null) return [];

      final List<dynamic> inhabitants = response['data'] as List;

      return inhabitants
          .where((item) => item['type'] == 'coral')
          .map((item) =>
              Coral.fromInhabitantJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      AppLogger.w('Failed to load corals', error: e);
      rethrow;
    }
  }

  /// Adds [coral] to the current aquarium using the species identified by
  /// [speciesId].
  ///
  /// [speciesId] is required — throws if `null`. The body posted uses
  /// `inhabitantType: 'coral'` and `quantity: 1`.
  Future<void> addCoral(Coral coral, String? speciesId) async {
    if (_currentAquariumId == null) {
      throw NoAquariumSelectedException();
    }
    if (speciesId == null) {
      throw ValidationException('Species ID is required');
    }

    final body = {
      'inhabitantType': 'coral',
      'inhabitantId': int.parse(speciesId),
      'quantity': 1,
      'notes': coral.notes ?? '',
    };

    await _apiService.post(ApiEndpoints.inhabitants(_currentAquariumId!), body);
  }

  /// Updates [coral] (size and notes) via
  /// `PUT /aquariums/{id}/inhabitants/{coralId}`.
  Future<void> updateCoral(Coral coral) async {
    if (_currentAquariumId == null) {
      throw NoAquariumSelectedException();
    }

    final body = {'quantity': coral.size.toInt(), 'notes': coral.notes ?? ''};

    await _apiService.put(
      ApiEndpoints.inhabitant(_currentAquariumId!, int.parse(coral.id)),
      body,
    );
  }

  /// Permanently removes the coral with the given [id] from the current
  /// aquarium.
  Future<void> deleteCoral(String id) async {
    if (_currentAquariumId == null) {
      throw NoAquariumSelectedException();
    }

    await _apiService.delete(
      ApiEndpoints.inhabitant(_currentAquariumId!, int.parse(id)),
    );
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
    // Statistics degrade gracefully: a fetch failure reports zeros rather than
    // propagating, so a stats panel never breaks the surrounding screen.
    List<Fish> fish;
    List<Coral> corals;
    try {
      fish = await getFish();
      corals = await getCorals();
    } catch (e) {
      AppLogger.w('getStatistics: inhabitant fetch failed; reporting zeros',
          error: e);
      fish = [];
      corals = [];
    }

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
