import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/inhabitants/data/coral_database_service.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockApiService api;
  late CoralDatabaseService sut;

  setUp(() {
    api = MockApiService();
    sut = CoralDatabaseService(api);
  });

  group('getAllCorals — response normalisation', () {
    test('returns [] for a data-wrapped empty list', () async {
      when(() => api.get('/species/corals'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getAllCorals(), isEmpty);
    });

    test('accepts a bare empty array', () async {
      when(() => api.get('/species/corals')).thenAnswer((_) async => []);

      expect(await sut.getAllCorals(), isEmpty);
    });

    test('accepts a "corals"-wrapped empty list', () async {
      when(() => api.get('/species/corals'))
          .thenAnswer((_) async => {'corals': []});

      expect(await sut.getAllCorals(), isEmpty);
    });

    test('returns [] on network error', () async {
      when(() => api.get('/species/corals')).thenThrow(Exception('down'));

      expect(await sut.getAllCorals(), isEmpty);
    });
  });

  group('caching', () {
    test('serves the catalogue from cache after the first fetch', () async {
      when(() => api.get('/species/corals'))
          .thenAnswer((_) async => {'data': []});

      await sut.getAllCorals();
      await sut.getAllCorals();

      verify(() => api.get('/species/corals')).called(1);
    });
  });

  group('getCoralsByWaterType', () {
    test('returns [] for freshwater without hitting the API', () async {
      expect(await sut.getCoralsByWaterType('dolce'), isEmpty);
      verifyNever(() => api.get(any()));
    });

    test('fetches the catalogue for a saltwater type', () async {
      when(() => api.get('/species/corals'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getCoralsByWaterType('marino'), isEmpty);
      verify(() => api.get('/species/corals')).called(1);
    });
  });

  group('lookups over an empty catalogue', () {
    test('getCoralById returns null when the species is not found', () async {
      when(() => api.get('/species/corals'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getCoralById('nope'), isNull);
    });
  });
}
