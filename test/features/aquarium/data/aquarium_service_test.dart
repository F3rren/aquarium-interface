import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/aquarium/data/aquarium_service.dart';
import 'package:acquariumfe/features/aquarium/domain/models/aquarium.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import '../../../helpers/mocks.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late MockApiService api;
  late AquariumsService sut;

  setUp(() {
    api = MockApiService();
    sut = AquariumsService(api);
  });

  // ── getAquariums ────────────────────────────────────────────────────────────

  group('getAquariums', () {
    test('returns list when response is a bare JSON array', () async {
      when(() => api.get('/aquariums')).thenAnswer(
        (_) async => [aquariumMarineJson],
      );

      final result = await sut.getAquariums();

      expect(result, hasLength(1));
      expect(result.first.name, equals('Reef Tank'));
      expect(result.first.id, equals(1));
    });

    test('returns list when response is wrapped in "data" key', () async {
      when(() => api.get('/aquariums')).thenAnswer(
        (_) async => aquariumListResponse,
      );

      final result = await sut.getAquariums();

      expect(result, hasLength(2));
      expect(result.first.type, equals('saltwater'));
    });

    test('returns list when response is wrapped in "aquariums" key', () async {
      when(() => api.get('/aquariums')).thenAnswer(
        (_) async => {'aquariums': [aquariumMarineJson]},
      );

      final result = await sut.getAquariums();
      expect(result, hasLength(1));
    });

    test('throws DataFormatException on unknown response shape', () async {
      when(() => api.get('/aquariums')).thenAnswer((_) async => 'invalid');

      expect(sut.getAquariums(), throwsA(isA<DataFormatException>()));
    });

    test('propagates NetworkException from ApiService', () async {
      when(() => api.get('/aquariums'))
          .thenThrow(NetworkException('no connection'));

      expect(sut.getAquariums(), throwsA(isA<NetworkException>()));
    });

    test('propagates AuthException from ApiService', () async {
      when(() => api.get('/aquariums'))
          .thenThrow(AuthException('401 unauthorized'));

      expect(sut.getAquariums(), throwsA(isA<AuthException>()));
    });
  });

  // ── getAquariumById ─────────────────────────────────────────────────────────

  group('getAquariumById', () {
    test('returns aquarium from direct map response', () async {
      when(() => api.get('/aquariums/1')).thenAnswer(
        (_) async => aquariumMarineJson,
      );

      final result = await sut.getAquariumById(1);
      expect(result?.name, equals('Reef Tank'));
    });

    test('unwraps "data" key when present', () async {
      when(() => api.get('/aquariums/1')).thenAnswer(
        (_) async => {'data': aquariumMarineJson},
      );

      final result = await sut.getAquariumById(1);
      expect(result?.id, equals(1));
    });

    test('throws DataFormatException when response is not a map', () async {
      when(() => api.get('/aquariums/1')).thenAnswer((_) async => []);

      expect(sut.getAquariumById(1), throwsA(isA<DataFormatException>()));
    });
  });

  // ── createAquarium ──────────────────────────────────────────────────────────

  group('createAquarium', () {
    test('posts to /aquariums and returns created entity', () async {
      when(() => api.post('/aquariums', any())).thenAnswer(
        (_) async => aquariumMarineJson,
      );

      final result = await sut.createAquarium(aquariumUnsaved);

      expect(result, isA<Aquarium>());
      expect(result.name, equals('Reef Tank'));
      verify(() => api.post('/aquariums', any())).called(1);
    });

    test('unwraps "data" key from creation response', () async {
      when(() => api.post('/aquariums', any())).thenAnswer(
        (_) async => {'data': aquariumMarineJson},
      );

      final result = await sut.createAquarium(aquariumUnsaved);
      expect(result.id, equals(1));
    });
  });

  // ── updateAquarium ──────────────────────────────────────────────────────────

  group('updateAquarium', () {
    test('puts to /aquariums/{id} and returns updated entity', () async {
      when(() => api.put('/aquariums/1', any())).thenAnswer(
        (_) async => aquariumMarineJson,
      );

      final result = await sut.updateAquarium(1, aquariumMarine);

      expect(result.name, equals('Reef Tank'));
      verify(() => api.put('/aquariums/1', any())).called(1);
    });
  });

  // ── deleteAquarium ──────────────────────────────────────────────────────────

  group('deleteAquarium', () {
    test('deletes /aquariums/{id}', () async {
      when(() => api.delete('/aquariums/1'))
          .thenAnswer((_) async => {'success': true});

      await sut.deleteAquarium(1);

      verify(() => api.delete('/aquariums/1')).called(1);
    });

    test('propagates ServerException on 5xx', () async {
      when(() => api.delete('/aquariums/1'))
          .thenThrow(ServerException('server error', statusCode: 500));

      expect(sut.deleteAquarium(1), throwsA(isA<ServerException>()));
    });
  });

  // ── getAquariumParameters ───────────────────────────────────────────────────

  group('getAquariumParameters', () {
    test('returns AquariumParameters from wrapped response', () async {
      when(() => api.get('/aquariums/1/parameters')).thenAnswer(
        (_) async => parametersWrappedResponse,
      );

      final result = await sut.getAquariumParameters(1);

      expect(result.temperature, equals(25.5));
      expect(result.ph, equals(8.2));
    });

    test('returns AquariumParameters from direct map response', () async {
      when(() => api.get('/aquariums/1/parameters')).thenAnswer(
        (_) async => parametersJson,
      );

      final result = await sut.getAquariumParameters(1);
      expect(result.salinity, equals(1.025));
    });

    test('throws DataFormatException when response is not a map', () async {
      when(() => api.get('/aquariums/1/parameters'))
          .thenAnswer((_) async => 'bad');

      expect(
        sut.getAquariumParameters(1),
        throwsA(isA<DataFormatException>()),
      );
    });
  });
}
