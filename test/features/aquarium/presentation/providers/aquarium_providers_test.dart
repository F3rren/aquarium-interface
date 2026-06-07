import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:acquariumfe/features/aquarium/presentation/providers/aquarium_providers.dart';
import 'package:acquariumfe/features/parameters/domain/models/aquarium_parameters.dart';
import 'package:acquariumfe/core/providers/service_providers.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/fixtures.dart';
import '../../../../helpers/provider_container.dart';

void main() {
  late MockAquariumsService aquariumService;
  late MockParameterService parameterService;

  setUp(() {
    aquariumService = MockAquariumsService();
    parameterService = MockParameterService();

    // Common stubs for side-effect calls inside the provider
    when(() => parameterService.setAutoCheckAlerts(any())).thenReturn(null);
    when(() => parameterService.setCurrentAquarium(any())).thenReturn(null);
  });

  ProviderContainer container() => makeContainer(overrides: [
        aquariumsServiceProvider.overrideWithValue(aquariumService),
        parameterServiceProvider.overrideWithValue(parameterService),
      ]);

  // ── aquariumsProvider ───────────────────────────────────────────────────────

  group('aquariumsProvider', () {
    test('initial state is AsyncLoading', () {
      when(() => aquariumService.getAquariums())
          .thenAnswer((_) => Completer<List>().future.then((_) => []));

      final c = container();
      expect(c.read(aquariumsProvider), isA<AsyncLoading>());
    });

    test('emits AsyncData with list after successful fetch', () async {
      when(() => aquariumService.getAquariums())
          .thenAnswer((_) async => [aquariumMarine]);
      when(() => parameterService.getCurrentParameters(
                id: aquariumMarine.id,
                useMock: false,
              ))
          .thenThrow(NetworkException('skip params'));

      final c = container();
      final list = await c.read(aquariumsProvider.future);

      expect(list, hasLength(1));
      expect(list.first.aquarium.name, equals('Reef Tank'));
    });

    test('AquariumWithParams.parameters is null when param fetch fails',
        () async {
      when(() => aquariumService.getAquariums())
          .thenAnswer((_) async => [aquariumMarine]);
      when(() => parameterService.getCurrentParameters(
                id: aquariumMarine.id,
                useMock: false,
              ))
          .thenThrow(NetworkException('offline'));

      final c = container();
      final list = await c.read(aquariumsProvider.future);

      // Aquarium is still in the list, parameters are null
      expect(list.first.parameters, isNull);
      expect(list.first.aquarium.name, equals('Reef Tank'));
    });

    test('emits AsyncError when getAquariums throws', () async {
      when(() => aquariumService.getAquariums())
          .thenThrow(NetworkException('no network'));

      final c = container();

      await expectLater(
        c.read(aquariumsProvider.future),
        throwsA(isA<NetworkException>()),
      );
      expect(c.read(aquariumsProvider), isA<AsyncError>());
    });

    test('sets first aquarium as current after load', () async {
      when(() => aquariumService.getAquariums())
          .thenAnswer((_) async => [aquariumMarine]);
      when(() => parameterService.getCurrentParameters(
                id: aquariumMarine.id,
                useMock: false,
              ))
          .thenThrow(NetworkException('skip'));

      final c = container();
      await c.read(aquariumsProvider.future);

      verify(() => parameterService.setCurrentAquarium(aquariumMarine.id!))
          .called(1);
    });
  });

  // ── aquariumCountProvider ───────────────────────────────────────────────────

  group('aquariumCountProvider', () {
    test('returns count when data is loaded', () async {
      when(() => aquariumService.getAquariums())
          .thenAnswer((_) async => [aquariumMarine, aquariumFreshwater]);
      when(() => parameterService.getCurrentParameters(
                id: any(named: 'id'),
                useMock: false,
              ))
          .thenThrow(NetworkException('skip'));

      final c = container();
      await c.read(aquariumsProvider.future);

      expect(c.read(aquariumCountProvider), equals(2));
    });

    test('returns 0 while loading', () {
      when(() => aquariumService.getAquariums())
          .thenAnswer((_) => Completer<List>().future.then((_) => []));

      final c = container();
      expect(c.read(aquariumCountProvider), equals(0));
    });
  });

  // ── AquariumWithParams.hasAlert ─────────────────────────────────────────────

  group('AquariumWithParams.hasAlert', () {
    test('returns false when parameters are null', () {
      final awp = AquariumWithParams(aquarium: aquariumMarine);
      expect(awp.hasAlert, isFalse);
    });

    test('returns false for healthy parameters', () {
      final awp = AquariumWithParams(
        aquarium: aquariumMarine,
        parameters: parametersHealthy,
      );
      expect(awp.hasAlert, isFalse);
    });

    test('returns true when temperature is out of range', () {
      final awp = AquariumWithParams(
        aquarium: aquariumMarine,
        parameters: parametersHighTemp, // 29 °C > 27 °C limit
      );
      expect(awp.hasAlert, isTrue);
    });

    test('returns true when pH is below range', () {
      final awp = AquariumWithParams(
        aquarium: aquariumMarine,
        parameters: AquariumParameters(
          temperature: 25.0,
          ph: 7.5, // below 7.8 minimum
          salinity: 35.0,
          orp: 350.0,
          timestamp: DateTime(2024),
        ),
      );
      expect(awp.hasAlert, isTrue);
    });
  });
}
