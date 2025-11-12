import '../models/aquarium.dart';
import 'api_service.dart';

/// Service per gestire le operazioni CRUD sugli acquari
class AquariumsService {
  final ApiService _apiService = ApiService();

  /// Recupera la lista di tutti gli acquari
  /// 
  /// Effettua una chiamata GET all'endpoint /aquariumslist
  /// e restituisce una lista di oggetti Aquarium
  /// 
  /// Throws [ApiException] in caso di errore nella chiamata API
  Future<List<Aquarium>> getAquariumsList() async {
    try {
      final response = await _apiService.get('/aquariumslist');
      
      // La risposta può essere un oggetto con una chiave 'aquariums' o 'data'
      final List<dynamic> aquariumsJson;
      
      if (response.containsKey('aquariums')) {
        aquariumsJson = response['aquariums'] as List<dynamic>;
      } else if (response.containsKey('data')) {
        aquariumsJson = response['data'] as List<dynamic>;
      } else {
        // Se la risposta non ha il formato atteso, assumiamo sia una lista
        throw ApiException(
          statusCode: 500,
          message: 'Formato risposta non valido: chiave "aquariums" o "data" non trovata',
        );
      }
      
      return aquariumsJson
          .map((json) => Aquarium.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Recupera un singolo acquario per ID
  Future<Aquarium?> getAquariumById(String id) async {
    try {
      final response = await _apiService.get('/aquariums/$id');
      return Aquarium.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Crea un nuovo acquario
  Future<Aquarium> createAquarium(Aquarium aquarium) async {
    try {
      final response = await _apiService.post('/aquariums', aquarium.toJson());
      return Aquarium.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Aggiorna un acquario esistente
  Future<Aquarium> updateAquarium(String id, Aquarium aquarium) async {
    try {
      final response = await _apiService.put('/aquariums/$id', aquarium.toJson());
      return Aquarium.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Elimina un acquario
  Future<void> deleteAquarium(String id) async {
    try {
      await _apiService.delete('/aquariums/$id');
    } catch (e) {
      rethrow;
    }
  }
}
