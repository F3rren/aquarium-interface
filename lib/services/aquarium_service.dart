import '../models/aquarium.dart';
import '../models/aquarium_parameters.dart';
import '../utils/exceptions.dart';
import 'api_service.dart';

/// Service per gestire le operazioni CRUD sugli acquari
class AquariumsService {
  final ApiService _apiService = ApiService();

  Future<List<Aquarium>> getAquariums() async {
    final response = await _apiService.get('/aquariums');

    // La risposta può essere un oggetto con una chiave 'aquariums' o 'data', oppure un array diretto
    final List<dynamic> aquariumsJson;

    if (response is List) {
      // Risposta diretta come array
      aquariumsJson = response;
    } else if (response is Map<String, dynamic>) {
      // Risposta con wrapper object
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
        .map((json) => Aquarium.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Recupera un singolo acquario per ID
  Future<Aquarium?> getAquariumById(int id) async {
    final response = await _apiService.get('/aquariums/$id');
    if (response is Map<String, dynamic>) {
      // Estrai i dati dall'oggetto wrapper se presente
      final aquariumData = response['data'] ?? response;
      return Aquarium.fromJson(aquariumData as Map<String, dynamic>);
    } else {
      throw DataFormatException(
        'Formato risposta non valido: attesa mappa',
        details: 'Ricevuto tipo: ${response.runtimeType}',
      );
    }
  }

  /// Crea un nuovo acquario
  Future<Aquarium> createAquarium(Aquarium aquarium) async {
    // Non serve più rimuovere l'ID, toJson() lo gestisce automaticamente
    final response = await _apiService.post('/aquariums', aquarium.toJson());
    return Aquarium.fromJson(response);
  }

  /// Aggiorna un acquario esistente
  Future<Aquarium> updateAquarium(int id, Aquarium aquarium) async {
    final response = await _apiService.put('/aquariums/$id', aquarium.toJson());
    return Aquarium.fromJson(response);
  }

  /// Elimina un acquario
  Future<void> deleteAquarium(int id) async {
    await _apiService.delete('/aquariums/$id');
  }

  /// Recupera i parametri attuali di una vasca specifica
  Future<AquariumParameters> getAquariumParameters(int aquariumId) async {
    final response = await _apiService.get('/aquariums/$aquariumId/parameters');

    // Gestisci il caso in cui la risposta abbia un wrapper "data"
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

  /// Recupera lo storico dei parametri di una vasca specifica
  Future<List<AquariumParameters>> getAquariumParameterHistory({
    required int aquariumId,
    DateTime? from,
    DateTime? to,
    int? limit,
  }) async {
    // Costruisci query parameters
    final queryParams = <String, String>{};
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();
    if (limit != null) queryParams['limit'] = limit.toString();

    final query = queryParams.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    final endpoint =
        '/aquariums/$aquariumId/parameters/history${query.isNotEmpty ? '?$query' : ''}';

    final response = await _apiService.get(endpoint);

    // Gestisci diversi formati di risposta
    final List<dynamic> historyJson;
    if (response is List) {
      // Risposta diretta come array
      historyJson = response;
    } else if (response is Map<String, dynamic>) {
      // Risposta con wrapper object
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
        .map(
          (json) => AquariumParameters.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }
}
