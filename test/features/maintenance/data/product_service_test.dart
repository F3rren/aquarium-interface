import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/maintenance/data/product_service.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockApiService api;
  late ProductService sut;

  setUp(() {
    api = MockApiService();
    sut = ProductService(api);
  });

  group('getAllProducts', () {
    test('returns [] for an empty list response', () async {
      when(() => api.get('/products')).thenAnswer((_) async => []);

      expect(await sut.getAllProducts(), isEmpty);
    });

    test('rethrows on error when no cache exists', () async {
      when(() => api.get('/products')).thenThrow(Exception('down'));

      expect(sut.getAllProducts(), throwsA(isA<Exception>()));
    });

    test('serves the last good cache on a later error', () async {
      when(() => api.get('/products')).thenAnswer((_) async => []);
      await sut.getAllProducts(); // caches the empty (unfiltered) result

      when(() => api.get('/products')).thenThrow(Exception('down'));

      // The cache is served instead of rethrowing.
      expect(await sut.getAllProducts(), isEmpty);
    });
  });

  group('getStatistics', () {
    test('returns zeroed statistics for an empty inventory', () async {
      when(() => api.get('/products')).thenAnswer((_) async => []);

      final stats = await sut.getStatistics();

      expect(stats['totalProducts'], 0);
      expect(stats['totalCost'], 0);
      expect(stats['expiringCount'], 0);
      expect(stats['lowStockCount'], 0);
      expect(stats['favoriteCount'], 0);
    });
  });
}
