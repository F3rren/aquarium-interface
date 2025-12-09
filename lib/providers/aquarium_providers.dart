import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:acquariumfe/models/aquarium.dart';
import 'package:acquariumfe/models/aquarium_parameters.dart';
import 'package:acquariumfe/providers/service_providers.dart';
import 'package:acquariumfe/utils/exceptions.dart';

part 'aquarium_providers.g.dart';

/// Classe helper per combinare acquario + parametri
class AquariumWithParams {
  final Aquarium aquarium;
  final AquariumParameters? parameters;
  final DateTime? lastUpdate;

  AquariumWithParams({
    required this.aquarium,
    this.parameters,
    this.lastUpdate,
  });

  bool get hasAlert {
    if (parameters == null) return false;

    // Verifica parametri fuori range (valori tipici per acquario marino)
    final tempOk =
        parameters!.temperature >= 24.0 && parameters!.temperature <= 27.0;
    final phOk = parameters!.ph >= 7.8 && parameters!.ph <= 8.5;
    final salinityOk =
        parameters!.salinity >= 1.023 && parameters!.salinity <= 1.026;

    return !tempOk || !phOk || !salinityOk;
  }

  AquariumWithParams copyWith({
    Aquarium? aquarium,
    AquariumParameters? parameters,
    DateTime? lastUpdate,
  }) {
    return AquariumWithParams(
      aquarium: aquarium ?? this.aquarium,
      parameters: parameters ?? this.parameters,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

/// Provider per lista acquari con parametri
/// Gestisce automaticamente loading/error/data
@riverpod
class Aquariums extends _$Aquariums {
  @override
  Future<List<AquariumWithParams>> build() async {
    // Carica acquari iniziali
    return await _loadAquariums();
  }

  /// Carica tutti gli acquari con i loro parametri
  Future<List<AquariumWithParams>> _loadAquariums() async {
    final aquariumService = ref.read(aquariumsServiceProvider);
    final parameterService = ref.read(parameterServiceProvider);

    // Carica lista acquari
    final aquariums = await aquariumService.getAquariums();

    // Carica parametri per ogni acquario
    final aquariumsWithParams = <AquariumWithParams>[];
    for (final aquarium in aquariums) {
      AquariumParameters? params;
      DateTime? lastUpdate;

      try {
        // Carica parametri senza trigger di alert (primo caricamento)
        // Gli alert saranno gestiti dal polling successivo
        parameterService.setAutoCheckAlerts(false);

        params = await parameterService.getCurrentParameters(
          id: aquarium.id,
          useMock: false,
        );
        lastUpdate = DateTime.now();
      } on AppException {
        // Ignora errori per parametri singoli
      } catch (e) {
        // Ignora errori generici
      }

      aquariumsWithParams.add(
        AquariumWithParams(
          aquarium: aquarium,
          parameters: params,
          lastUpdate: lastUpdate,
        ),
      );
    }

    // Riabilita alert dopo il caricamento iniziale
    parameterService.setAutoCheckAlerts(true);

    // Imposta il primo acquario come corrente se disponibile
    if (aquariumsWithParams.isNotEmpty &&
        aquariumsWithParams.first.aquarium.id != null) {
      final firstId = aquariumsWithParams.first.aquarium.id!;
      parameterService.setCurrentAquarium(firstId);
      ref.read(targetParametersServiceProvider).setCurrentAquarium(firstId);
    }

    return aquariumsWithParams;
  }

  /// Ricarica la lista (per pull-to-refresh)
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _loadAquariums();
    });
  }

  /// Aggiunge un nuovo acquario
  Future<void> addAquarium(Aquarium aquarium) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final aquariumService = ref.read(aquariumsServiceProvider);
      await aquariumService.createAquarium(aquarium);
      return await _loadAquariums();
    });
  }

  /// Aggiorna un acquario esistente
  Future<void> updateAquarium(int id, Aquarium aquarium) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final aquariumService = ref.read(aquariumsServiceProvider);
      await aquariumService.updateAquarium(id, aquarium);
      return await _loadAquariums();
    });
  }

  /// Elimina un acquario
  Future<void> deleteAquarium(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final aquariumService = ref.read(aquariumsServiceProvider);
      await aquariumService.deleteAquarium(id);
      return await _loadAquariums();
    });
  }

  /// Aggiorna i parametri di un acquario specifico
  Future<void> refreshParameters(int aquariumId) async {
    final currentState = state.value;
    if (currentState == null) return;

    final parameterService = ref.read(parameterServiceProvider);

    try {
      final params = await parameterService.getCurrentParameters(
        id: aquariumId,
        useMock: false,
      );

      // Aggiorna solo l'acquario specifico
      final updatedList = currentState.map((item) {
        if (item.aquarium.id == aquariumId) {
          return item.copyWith(parameters: params, lastUpdate: DateTime.now());
        }
        return item;
      }).toList();

      state = AsyncValue.data(updatedList);
    } on AppException {
      // Ignora errori, mantieni stato corrente
    }
  }
}

/// Provider per l'acquario correntemente selezionato
@riverpod
class CurrentAquarium extends _$CurrentAquarium {
  @override
  int? build() {
    // Cerca di leggere l'ID del primo acquario se disponibile
    final aquariums = ref.watch(aquariumsProvider);
    return aquariums.when(
      data: (list) => list.isNotEmpty ? list.first.aquarium.id : null,
      loading: () => null,
      error: (_, __) => null,
    );
  }

  /// Imposta l'acquario corrente
  void setAquarium(int id) {
    state = id;

    // Aggiorna anche i servizi
    ref.read(parameterServiceProvider).setCurrentAquarium(id);
    ref.read(targetParametersServiceProvider).setCurrentAquarium(id);
  }
}

/// Provider per contare gli acquari
@riverpod
int aquariumCount(AquariumCountRef ref) {
  final aquariums = ref.watch(aquariumsProvider);
  return aquariums.when(
    data: (list) => list.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}

/// Provider per acquari con alert
@riverpod
int aquariumsWithAlertsCount(AquariumsWithAlertsCountRef ref) {
  final aquariums = ref.watch(aquariumsProvider);
  return aquariums.when(
    data: (list) => list.where((a) => a.hasAlert).length,
    loading: () => 0,
    error: (_, __) => 0,
  );
}
