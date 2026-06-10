import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/inhabitants/data/inhabitants_service.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockApiService api;
  late InhabitantsService sut;

  setUp(() {
    api = MockApiService();
    sut = InhabitantsService(api);
  });

  group('no aquarium selected', () {
    test('getFish returns [] without hitting the API', () async {
      expect(await sut.getFish(), isEmpty);
      verifyNever(() => api.get(any()));
    });

    test('getCorals returns [] without hitting the API', () async {
      expect(await sut.getCorals(), isEmpty);
      verifyNever(() => api.get(any()));
    });

    test('getStatistics reports zeros', () async {
      final stats = await sut.getStatistics();

      expect(stats['totalFish'], 0);
      expect(stats['totalCorals'], 0);
      expect(stats['avgFishSize'], 0.0);
      expect(stats['totalBioLoad'], 0.0);
    });

    test('deleteFish throws NoAquariumSelectedException', () {
      expect(sut.deleteFish('f1'), throwsA(isA<NoAquariumSelectedException>()));
    });
  });

  group('with an aquarium selected', () {
    test('getFish returns [] for an empty inhabitants list', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/inhabitants'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getFish(), isEmpty);
    });

    test('getCorals returns [] for an empty inhabitants list', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/inhabitants'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getCorals(), isEmpty);
    });

    test('getFish rethrows on network error', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/inhabitants'))
          .thenThrow(Exception('down'));

      expect(sut.getFish(), throwsA(isA<Exception>()));
    });

    test('getStatistics degrades to zeros when the fetch fails', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/inhabitants'))
          .thenThrow(Exception('down'));

      final stats = await sut.getStatistics();

      expect(stats['totalFish'], 0);
      expect(stats['totalCorals'], 0);
    });
  });
}
