import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/parameters/data/target_parameters_service.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockApiService api;
  late TargetParametersService sut;

  setUpAll(() {
    // saveTarget posts a Map body matched with any()/captureAny().
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    api = MockApiService();
    sut = TargetParametersService(api);
  });

  group('loadAllTargets', () {
    test('parses the data-wrapped response', () async {
      when(() => api.get('/aquariums/1/settings/targets')).thenAnswer(
        (_) async => {
          'data': {
            'temperature': 26.0,
            'ph': 8.3,
            'salinity': 36.0,
            'orp': 370.0,
          },
        },
      );

      final result = await sut.loadAllTargets(1);

      expect(result['temperature'], 26.0);
      expect(result['ph'], 8.3);
    });

    test('returns defaults when the response has no data map', () async {
      when(() => api.get('/aquariums/1/settings/targets'))
          .thenAnswer((_) async => {});

      final result = await sut.loadAllTargets(1);

      expect(result['temperature'], TargetParametersService.defaultTemperature);
    });

    test('returns defaults on network error', () async {
      when(() => api.get('/aquariums/1/settings/targets'))
          .thenThrow(Exception('down'));

      final result = await sut.loadAllTargets(1);

      expect(result['ph'], TargetParametersService.defaultPh);
    });

    test('serves from cache on subsequent calls', () async {
      when(() => api.get('/aquariums/1/settings/targets')).thenAnswer(
        (_) async => {
          'data': {'temperature': 25.0, 'ph': 8.1, 'salinity': 35.0, 'orp': 360.0},
        },
      );

      await sut.loadAllTargets(1);
      await sut.loadAllTargets(1);

      verify(() => api.get('/aquariums/1/settings/targets')).called(1);
    });

    test('caches each aquarium independently', () async {
      when(() => api.get('/aquariums/1/settings/targets')).thenAnswer(
        (_) async => {
          'data': {'temperature': 25.0, 'ph': 8.1, 'salinity': 35.0, 'orp': 360.0},
        },
      );
      when(() => api.get('/aquariums/2/settings/targets')).thenAnswer(
        (_) async => {
          'data': {'temperature': 24.0, 'ph': 8.0, 'salinity': 34.0, 'orp': 340.0},
        },
      );

      await sut.loadAllTargets(1);
      await sut.loadAllTargets(2);
      await sut.loadAllTargets(1); // served from aquarium 1's cache

      verify(() => api.get('/aquariums/1/settings/targets')).called(1);
      verify(() => api.get('/aquariums/2/settings/targets')).called(1);
    });
  });

  group('saveTarget', () {
    test('posts the merged targets to the aquarium endpoint', () async {
      when(() => api.get('/aquariums/1/settings/targets'))
          .thenAnswer((_) async => {});
      when(() => api.post('/aquariums/1/settings/targets', any()))
          .thenAnswer((_) async => {'ok': true});

      await sut.saveTarget(1, 'temperature', 27.0);

      final body = verify(
        () => api.post('/aquariums/1/settings/targets', captureAny()),
      ).captured.single as Map<String, double>;

      expect(body['temperature'], 27.0);
    });

    test('updates the cache after a successful save', () async {
      when(() => api.get('/aquariums/1/settings/targets'))
          .thenAnswer((_) async => {});
      when(() => api.post('/aquariums/1/settings/targets', any()))
          .thenAnswer((_) async => {'ok': true});

      await sut.saveTarget(1, 'ph', 8.4);
      final result = await sut.loadAllTargets(1);

      expect(result['ph'], 8.4);
      // Only the load inside saveTarget hit the API; the read above is cached.
      verify(() => api.get('/aquariums/1/settings/targets')).called(1);
    });
  });

  group('individual getters', () {
    setUp(() {
      when(() => api.get('/aquariums/1/settings/targets')).thenAnswer(
        (_) async => {
          'data': {
            'temperature': 26.0,
            'ph': 8.3,
            'salinity': 36.0,
            'orp': 365.0,
          },
        },
      );
    });

    test('getTargetTemperature returns temperature', () async {
      expect(await sut.getTargetTemperature(1), 26.0);
    });

    test('getTargetPh returns ph', () async {
      expect(await sut.getTargetPh(1), 8.3);
    });

    test('getTargetSalinity returns salinity', () async {
      expect(await sut.getTargetSalinity(1), 36.0);
    });

    test('getTargetOrp returns orp', () async {
      expect(await sut.getTargetOrp(1), 365.0);
    });
  });
}
