import '../models/fish_species.dart';
import 'api_service.dart';

/// Servizio per gestire il database delle specie di pesci disponibili
class FishDatabaseService {
  static final FishDatabaseService _instance = FishDatabaseService._internal();
  factory FishDatabaseService() => _instance;
  FishDatabaseService._internal();

  final _apiService = ApiService();
  List<FishSpecies>? _cachedFish;

  /// Carica il database dei pesci dall'API
  Future<List<FishSpecies>> getAllFish() async {
    if (_cachedFish != null) {
      return _cachedFish!;
    }

    try {
      final response = await _apiService.get('/species/fish');
      
      // Gestisci sia formato array diretto che con wrapper
      List<dynamic> fishList;
      if (response is List) {
        fishList = response;
      } else if (response is Map<String, dynamic>) {
        var dataField = response['data'] ?? response['fishs'] ?? [];
        // Se data contiene un array annidato, prendi il primo elemento
        if (dataField is List && dataField.isNotEmpty && dataField[0] is List) {
          fishList = dataField[0];
        } else {
          fishList = dataField;
        }
      } else {
        fishList = [];
      }
      
      _cachedFish = fishList.map((json) => FishSpecies.fromJson(json as Map<String, dynamic>)).toList();
      return _cachedFish!;
    } catch (e) {
      return [];
    }
  }

  /// Cerca pesci per nome comune o scientifico
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

  /// Filtra pesci per difficoltà
  Future<List<FishSpecies>> getFishByDifficulty(String difficulty) async {
    final allFish = await getAllFish();
    return allFish.where((fish) => fish.difficulty == difficulty).toList();
  }

  /// Filtra pesci sicuri per reef
  Future<List<FishSpecies>> getReefSafeFish() async {
    final allFish = await getAllFish();
    return allFish.where((fish) => fish.reefSafe).toList();
  }

  /// Filtra pesci per dimensione vasca minima
  Future<List<FishSpecies>> getFishByTankSize(int tankSizeInLiters) async {
    final allFish = await getAllFish();
    return allFish.where((fish) => fish.minTankSize <= tankSizeInLiters).toList();
  }

  /// Ottieni un pesce per ID
  Future<FishSpecies?> getFishById(String id) async {
    final allFish = await getAllFish();
    try {
      return allFish.firstWhere((fish) => fish.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filtra per temperamento
  Future<List<FishSpecies>> getFishByTemperament(String temperament) async {
    final allFish = await getAllFish();
    return allFish.where((fish) => fish.temperament == temperament).toList();
  }

  /// Filtra per famiglia
  Future<List<FishSpecies>> getFishByFamily(String family) async {
    final allFish = await getAllFish();
    return allFish.where((fish) => fish.family.toLowerCase().contains(family.toLowerCase())).toList();
  }

  /// Filtra pesci per tipo d'acqua (es. "Marino", "Dolce")
  Future<List<FishSpecies>> getFishByWaterType(String waterType) async {
    final allFish = await getAllFish();
    if (waterType.isEmpty) return allFish;
    
    // Normalizza il tipo d'acqua per il confronto
    String normalizedWaterType = _normalizeWaterType(waterType);
    
    return allFish.where((fish) {
      // Se il pesce non ha un waterType specificato, NON lo mostra
      if (fish.waterType == null || fish.waterType!.isEmpty) return false;
      
      // Normalizza e confronta
      String fishWaterType = _normalizeWaterType(fish.waterType!);
      return fishWaterType == normalizedWaterType;
    }).toList();
  }
  
  /// Normalizza il tipo d'acqua per il confronto
  /// "Marino" / "Reef" / "salata" / "marino" / "reef" -> "salata"
  /// "Dolce" / "dolce" -> "dolce"
  String _normalizeWaterType(String waterType) {
    final normalized = waterType.toLowerCase().trim();
    
    // Mappa tutte le varianti di acqua salata (Marino e Reef sono entrambi salati)
    if (normalized == 'marino' || normalized == 'reef' || normalized == 'salata') {
      return 'salata';
    }
    
    // Mappa "dolce" a "dolce"
    if (normalized == 'dolce') {
      return 'dolce';
    }
    
    return normalized;
  }

  /// Ottieni tutte le famiglie disponibili
  Future<List<String>> getAllFamilies() async {
    final allFish = await getAllFish();
    final families = allFish.map((fish) => fish.family).toSet().toList();
    families.sort();
    return families;
  }

  /// Ricarica cache
  void clearCache() {
    _cachedFish = null;
  }
}
