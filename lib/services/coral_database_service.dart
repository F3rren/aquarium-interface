import '../models/coral_species.dart';
import 'api_service.dart';

/// Servizio per gestire il database delle specie di coralli disponibili
class CoralDatabaseService {
  static final CoralDatabaseService _instance =
      CoralDatabaseService._internal();
  factory CoralDatabaseService() => _instance;
  CoralDatabaseService._internal();

  final _apiService = ApiService();
  List<CoralSpecies>? _cachedCorals;

  /// Carica il database dei coralli dall'API
  Future<List<CoralSpecies>> getAllCorals() async {
    if (_cachedCorals != null) {
      return _cachedCorals!;
    }

    try {
      final response = await _apiService.get('/species/corals');

      // Gestisci sia formato array diretto che con wrapper
      List<dynamic> coralList;
      if (response is List) {
        coralList = response;
      } else if (response is Map<String, dynamic>) {
        var dataField = response['data'] ?? response['corals'] ?? [];
        // Se data contiene un array annidato, prendi il primo elemento
        if (dataField is List && dataField.isNotEmpty && dataField[0] is List) {
          coralList = dataField[0];
        } else {
          coralList = dataField;
        }
      } else {
        coralList = [];
      }

      _cachedCorals = coralList
          .map((json) => CoralSpecies.fromJson(json as Map<String, dynamic>))
          .toList();
      return _cachedCorals!;
    } catch (e) {
      return [];
    }
  }

  /// Cerca coralli per nome comune o scientifico
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

  /// Filtra coralli per difficoltà
  Future<List<CoralSpecies>> getCoralsByDifficulty(String difficulty) async {
    final allCorals = await getAllCorals();
    return allCorals.where((coral) => coral.difficulty == difficulty).toList();
  }

  /// Filtra coralli per tipo (SPS, LPS, soft, etc.)
  Future<List<CoralSpecies>> getCoralsByType(String type) async {
    final allCorals = await getAllCorals();
    return allCorals
        .where((coral) => coral.type.toLowerCase() == type.toLowerCase())
        .toList();
  }

  /// Filtra coralli per requisiti di luce
  Future<List<CoralSpecies>> getCoralsByLightRequirement(
    String lightRequirement,
  ) async {
    final allCorals = await getAllCorals();
    return allCorals
        .where((coral) => coral.lightRequirement == lightRequirement)
        .toList();
  }

  /// Filtra coralli per dimensione vasca minima
  Future<List<CoralSpecies>> getCoralsByTankSize(int tankSizeInLiters) async {
    final allCorals = await getAllCorals();
    return allCorals
        .where((coral) => coral.minTankSize <= tankSizeInLiters)
        .toList();
  }

  /// Ottieni un corallo per ID
  Future<CoralSpecies?> getCoralById(String id) async {
    final allCorals = await getAllCorals();
    try {
      return allCorals.firstWhere((coral) => coral.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Pulisci cache (utile per refresh)
  void clearCache() {
    _cachedCorals = null;
  }
}
