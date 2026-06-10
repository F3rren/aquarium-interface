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
/// The target aquarium is passed explicitly to every operation as
/// [aquariumId]; the service holds no mutable "current aquarium" state.
class InhabitantsService {
  /// Creates a service backed by the shared [ApiService].
  ///
  /// Obtain the app-wide instance via Riverpod ([inhabitantsServiceProvider])
  /// rather than constructing directly.
  InhabitantsService(this._apiService);

  final ApiService _apiService;

  // ── Fish ──────────────────────────────────────────────────────────────────

  /// Returns all fish inhabitants of aquarium [aquariumId].
  ///
  /// Fetches the unified `/inhabitants` endpoint and filters for
  /// `type == 'fish'`. Returns an empty list when the response carries no
  /// `data`; rethrows on any network error.
  Future<List<Fish>> getFish(int aquariumId) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.inhabitants(aquariumId),
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

  /// Adds [fish] to aquarium [aquariumId] using the species identified by
  /// [speciesId].
  ///
  /// [speciesId] is required — throws if `null`. The body posted to
  /// `POST /aquariums/{id}/inhabitants` uses `inhabitantType: 'fish'` and
  /// `quantity: 1`.
  Future<void> addFish(int aquariumId, Fish fish, String? speciesId) async {
    if (speciesId == null) {
      throw ValidationException('Species ID is required');
    }

    final body = {
      'inhabitantType': 'fish',
      'inhabitantId': int.parse(speciesId),
      'quantity': 1,
      'notes': fish.notes ?? '',
    };

    await _apiService.post(ApiEndpoints.inhabitants(aquariumId), body);
  }

  /// Updates [fish] (size and notes) via
  /// `PUT /aquariums/{id}/inhabitants/{fishId}`.
  Future<void> updateFish(int aquariumId, Fish fish) async {
    final body = {'quantity': fish.size.toInt(), 'notes': fish.notes ?? ''};

    await _apiService.put(
      ApiEndpoints.inhabitant(aquariumId, int.parse(fish.id)),
      body,
    );
  }

  /// Permanently removes the fish [id] from aquarium [aquariumId].
  Future<void> deleteFish(int aquariumId, String id) async {
    await _apiService.delete(
      ApiEndpoints.inhabitant(aquariumId, int.parse(id)),
    );
  }

  // ── Corals ────────────────────────────────────────────────────────────────

  /// Returns all coral inhabitants of aquarium [aquariumId].
  ///
  /// Fetches the unified `/inhabitants` endpoint and filters for
  /// `type == 'coral'`. Returns an empty list when the response carries no
  /// `data`; rethrows on any network error.
  Future<List<Coral>> getCorals(int aquariumId) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.inhabitants(aquariumId),
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

  /// Adds [coral] to aquarium [aquariumId] using the species identified by
  /// [speciesId].
  ///
  /// [speciesId] is required — throws if `null`. The body posted uses
  /// `inhabitantType: 'coral'` and `quantity: 1`.
  Future<void> addCoral(int aquariumId, Coral coral, String? speciesId) async {
    if (speciesId == null) {
      throw ValidationException('Species ID is required');
    }

    final body = {
      'inhabitantType': 'coral',
      'inhabitantId': int.parse(speciesId),
      'quantity': 1,
      'notes': coral.notes ?? '',
    };

    await _apiService.post(ApiEndpoints.inhabitants(aquariumId), body);
  }

  /// Updates [coral] (size and notes) via
  /// `PUT /aquariums/{id}/inhabitants/{coralId}`.
  Future<void> updateCoral(int aquariumId, Coral coral) async {
    final body = {'quantity': coral.size.toInt(), 'notes': coral.notes ?? ''};

    await _apiService.put(
      ApiEndpoints.inhabitant(aquariumId, int.parse(coral.id)),
      body,
    );
  }

  /// Permanently removes the coral [id] from aquarium [aquariumId].
  Future<void> deleteCoral(int aquariumId, String id) async {
    await _apiService.delete(
      ApiEndpoints.inhabitant(aquariumId, int.parse(id)),
    );
  }

  // ── Statistics ────────────────────────────────────────────────────────────

  /// Computes population statistics for aquarium [aquariumId].
  ///
  /// Returns a map with:
  /// - `'totalFish'` — number of fish
  /// - `'totalCorals'` — number of corals
  /// - `'avgFishSize'` — average fish size in cm (0.0 if no fish)
  /// - `'totalBioLoad'` — sum of all fish sizes plus (coral count × 2.0),
  ///   representing the relative biological load on the filtration system
  Future<Map<String, dynamic>> getStatistics(int aquariumId) async {
    // Statistics degrade gracefully: a fetch failure reports zeros rather than
    // propagating, so a stats panel never breaks the surrounding screen.
    List<Fish> fish;
    List<Coral> corals;
    try {
      fish = await getFish(aquariumId);
      corals = await getCorals(aquariumId);
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
