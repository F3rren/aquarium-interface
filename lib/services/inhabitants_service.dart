import '../models/fish.dart';
import '../models/coral.dart';
import 'api_service.dart';

class InhabitantsService {
  static final InhabitantsService _instance = InhabitantsService._internal();
  factory InhabitantsService() => _instance;
  
  InhabitantsService._internal();

  final ApiService _apiService = ApiService();
  int? _currentAquariumId;

  void setCurrentAquarium(int aquariumId) {
    _currentAquariumId = aquariumId;
  }

  // Fish operations
  Future<List<Fish>> getFish() async {
    if (_currentAquariumId == null) {
      return [];
    }

    try {
      final response = await _apiService.get('/aquariums/$_currentAquariumId/inhabitants');
      
      if (response['data'] == null) return [];
      
      final List<dynamic> inhabitants = response['data'] as List;
      
      // Filtra solo i pesci (type == 'fish')
      return inhabitants
          .where((item) => item['type'] == 'fish')
          .map((item) {
            // Estrai la dimensione dai dettagli o usa un valore di default
            final size = item['details']?['size'] ?? item['details']?['maxSize'] ?? 10.0;
            
            return Fish.fromJson({
              'id': item['id'].toString(),
              'name': item['commonName'] ?? '',
              'species': item['scientificName'] ?? '',
              'size': size is int ? size.toDouble() : (size as double),
              'addedDate': item['addedDate'] ?? DateTime.now().toIso8601String(),
              'notes': item['details']?['notes'] ?? '',
              'imageUrl': null,
            });
          })
          .toList();
    } catch (e) {
      return [];
    }
  }

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

    await _apiService.post(
      '/aquariums/$_currentAquariumId/inhabitants',
      body,
    );
  }

  Future<void> updateFish(Fish fish) async {
    if (_currentAquariumId == null) {
      throw Exception('No aquarium selected');
    }

    final body = {
      'quantity': fish.size.toInt(),
      'notes': fish.notes ?? '',
    };

    await _apiService.put(
      '/aquariums/$_currentAquariumId/inhabitants/${fish.id}',
      body,
    );
  }

  Future<void> deleteFish(String id) async {
    if (_currentAquariumId == null) {
      throw Exception('No aquarium selected');
    }

    await _apiService.delete('/aquariums/$_currentAquariumId/inhabitants/$id');
  }

  // Coral operations
  Future<List<Coral>> getCorals() async {
    if (_currentAquariumId == null) {
      return [];
    }

    try {
      final response = await _apiService.get('/aquariums/$_currentAquariumId/inhabitants');
      
      if (response['data'] == null) return [];
      
      final List<dynamic> inhabitants = response['data'] as List;
      
      // Filtra solo i coralli (type == 'coral')
      return inhabitants
          .where((item) => item['type'] == 'coral')
          .map((item) {
            // Estrai la dimensione dai dettagli o usa un valore di default
            final size = item['details']?['size'] ?? item['details']?['maxSize'] ?? 5.0;
            
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
            });
          })
          .toList();
    } catch (e) {
      return [];
    }
  }

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

    await _apiService.post(
      '/aquariums/$_currentAquariumId/inhabitants',
      body,
    );
  }

  Future<void> updateCoral(Coral coral) async {
    if (_currentAquariumId == null) {
      throw Exception('No aquarium selected');
    }

    final body = {
      'quantity': coral.size.toInt(),
      'notes': coral.notes ?? '',
    };

    await _apiService.put(
      '/aquariums/$_currentAquariumId/inhabitants/${coral.id}',
      body,
    );
  }

  Future<void> deleteCoral(String id) async {
    if (_currentAquariumId == null) {
      throw Exception('No aquarium selected');
    }

    await _apiService.delete('/aquariums/$_currentAquariumId/inhabitants/$id');
  }

  // Statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final fish = await getFish();
    final corals = await getCorals();
    
    final totalFish = fish.length;
    final totalCorals = corals.length;
    final avgFishSize = fish.isEmpty ? 0.0 : fish.map((f) => f.size).reduce((a, b) => a + b) / fish.length;
    final totalBioLoad = fish.fold<double>(0, (sum, f) => sum + f.size) + (corals.length * 2.0);
    
    return {
      'totalFish': totalFish,
      'totalCorals': totalCorals,
      'avgFishSize': avgFishSize,
      'totalBioLoad': totalBioLoad,
    };
  }
}