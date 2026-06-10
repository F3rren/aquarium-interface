import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/inhabitants/data/inhabitants_service.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockApiService api;
  late InhabitantsService sut;

  setUp(() {
    api = MockApiService();
    sut = InhabitantsService(api);
  });

  group('getFish', () {
    test('returns [] for an empty inhabitants list', () async {
      when(() => api.get('/aquariums/1/inhabitants'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getFish(1), isEmpty);
    });

    test('rethrows on network error', () async {
      when(() => api.get('/aquariums/1/inhabitants'))
          .thenThrow(Exception('down'));

      expect(sut.getFish(1), throwsA(isA<Exception>()));
    });

    test('targets the inhabitants endpoint of the given aquarium', () async {
      when(() => api.get('/aquariums/7/inhabitants'))
          .thenAnswer((_) async => {'data': []});

      await sut.getFish(7);

      verify(() => api.get('/aquariums/7/inhabitants')).called(1);
    });
  });

  group('getCorals', () {
    test('returns [] for an empty inhabitants list', () async {
      when(() => api.get('/aquariums/1/inhabitants'))
          .thenAnswer((_) async => {'data': []});

      expect(await sut.getCorals(1), isEmpty);
    });
  });

  group('getStatistics', () {
    test('returns zeros for an empty aquarium', () async {
      when(() => api.get('/aquariums/1/inhabitants'))
          .thenAnswer((_) async => {'data': []});

      final stats = await sut.getStatistics(1);

      expect(stats['totalFish'], 0);
      expect(stats['totalCorals'], 0);
      expect(stats['avgFishSize'], 0.0);
      expect(stats['totalBioLoad'], 0.0);
    });

    test('degrades to zeros when the fetch fails', () async {
      when(() => api.get('/aquariums/1/inhabitants'))
          .thenThrow(Exception('down'));

      final stats = await sut.getStatistics(1);

      expect(stats['totalFish'], 0);
      expect(stats['totalCorals'], 0);
    });
  });
}
