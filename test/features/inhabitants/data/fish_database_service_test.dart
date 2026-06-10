import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/inhabitants/data/fish_database_service.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockApiService api;
  late FishDatabaseService sut;

  setUp(() {
    api = MockApiService();
    sut = FishDatabaseService(api);
  });

  group('getAllFish — response normalisation', () {
    test('returns [] for a data-wrapped empty list', () async {
      when(() => api.get('/species/fishs'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getAllFish(), isEmpty);
    });

    test('accepts a bare empty array', () async {
      when(() => api.get('/species/fishs')).thenAnswer((_) async => []);

      expect(await sut.getAllFish(), isEmpty);
    });

    test('accepts a "fishs"-wrapped empty list', () async {
      when(() => api.get('/species/fishs'))
          .thenAnswer((_) async => {'fishs': []});

      expect(await sut.getAllFish(), isEmpty);
    });

    test('returns [] on network error', () async {
      when(() => api.get('/species/fishs')).thenThrow(Exception('down'));

      expect(await sut.getAllFish(), isEmpty);
    });
  });

  group('caching', () {
    test('serves the catalogue from cache after the first fetch', () async {
      when(() => api.get('/species/fishs'))
          .thenAnswer((_) async => {'data': []});

      await sut.getAllFish();
      await sut.getAllFish();

      verify(() => api.get('/species/fishs')).called(1);
    });

    test('clearCache forces a re-fetch', () async {
      when(() => api.get('/species/fishs'))
          .thenAnswer((_) async => {'data': []});

      await sut.getAllFish();
      sut.clearCache();
      await sut.getAllFish();

      verify(() => api.get('/species/fishs')).called(2);
    });
  });

  group('lookups over an empty catalogue', () {
    test('searchFish returns the full (empty) catalogue for an empty query',
        () async {
      when(() => api.get('/species/fishs'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.searchFish(''), isEmpty);
    });

    test('getFishById returns null when the species is not found', () async {
      when(() => api.get('/species/fishs'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getFishById('nope'), isNull);
    });
  });
}
