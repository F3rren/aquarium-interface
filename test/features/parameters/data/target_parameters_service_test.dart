import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/parameters/data/target_parameters_service.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockApiService api;
  late TargetParametersService sut;

  setUp(() {
    api = MockApiService();
    sut = TargetParametersService(api);
  });

  // ── loadAllTargets ──────────────────────────────────────────────────────────

  group('loadAllTargets', () {
    test('returns defaults when no aquarium is selected', () async {
      final result = await sut.loadAllTargets();

      expect(result['temperature'], equals(TargetParametersService.defaultTemperature));
      expect(result['ph'], equals(TargetParametersService.defaultPh));
      expect(result['salinity'], equals(TargetParametersService.defaultSalinity));
      expect(result['orp'], equals(TargetParametersService.defaultOrp));
      verifyNever(() => api.get(any()));
    });

    test('fetches from backend when aquarium is selected', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/settings/targets')).thenAnswer(
        (_) async => {
          'data': {
            'temperature': 26.0,
            'ph': 8.3,
            'salinity': 1023.0,
            'orp': 370.0,
          },
        },
      );

      final result = await sut.loadAllTargets();

      expect(result['temperature'], equals(26.0));
      expect(result['ph'], equals(8.3));
    });

    test('returns defaults on network error', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/settings/targets'))
          .thenThrow(Exception('network error'));

      final result = await sut.loadAllTargets();

      expect(result['temperature'], equals(TargetParametersService.defaultTemperature));
    });

    test('serves from cache on subsequent calls without re-fetching', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/settings/targets')).thenAnswer(
        (_) async => {'data': {'temperature': 25.0, 'ph': 8.1, 'salinity': 1024.0, 'orp': 360.0}},
      );

      await sut.loadAllTargets();
      await sut.loadAllTargets(); // second call — should not hit API again

      verify(() => api.get('/aquariums/1/settings/targets')).called(1);
    });

    test('clears cache when setCurrentAquarium is called', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/settings/targets')).thenAnswer(
        (_) async => {'data': {'temperature': 25.0, 'ph': 8.1, 'salinity': 1024.0, 'orp': 360.0}},
      );
      await sut.loadAllTargets();

      sut.setCurrentAquarium(2); // switch aquarium → cache cleared
      when(() => api.get('/aquariums/2/settings/targets')).thenAnswer(
        (_) async => {'data': {'temperature': 24.0, 'ph': 8.0, 'salinity': 1025.0, 'orp': 340.0}},
      );
      await sut.loadAllTargets();

      verify(() => api.get('/aquariums/1/settings/targets')).called(1);
      verify(() => api.get('/aquariums/2/settings/targets')).called(1);
    });
  });

  // ── saveTarget ──────────────────────────────────────────────────────────────

  group('saveTarget', () {
    test('throws when no aquarium is selected', () {
      expect(
        sut.saveTarget('temperature', 26.0),
        throwsA(isA<Exception>()),
      );
    });

    test('posts merged targets to /aquariums/{id}/settings/targets', () async {
      sut.setCurrentAquarium(1);
      // First load defaults (no data key → returns defaults)
      when(() => api.get('/aquariums/1/settings/targets'))
          .thenAnswer((_) async => {});
      when(() => api.post('/aquariums/1/settings/targets', any()))
          .thenAnswer((_) async => {'success': true});

      await sut.saveTarget('temperature', 27.0);

      final captured = verify(
        () => api.post('/aquariums/1/settings/targets', captureAny()),
      ).captured.single as Map<String, double>;

      expect(captured['temperature'], equals(27.0));
    });

    test('updates cache after successful save', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/settings/targets'))
          .thenAnswer((_) async => {});
      when(() => api.post('/aquariums/1/settings/targets', any()))
          .thenAnswer((_) async => {'success': true});

      await sut.saveTarget('ph', 8.4);

      // Cache should be updated — no new API call
      when(() => api.get('/aquariums/1/settings/targets'))
          .thenAnswer((_) async => {});
      final result = await sut.loadAllTargets();
      expect(result['ph'], equals(8.4));
      verify(() => api.get(any())).called(1); // only the initial load
    });
  });

  // ── individual getters ──────────────────────────────────────────────────────

  group('individual getters', () {
    setUp(() {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/settings/targets')).thenAnswer(
        (_) async => {
          'data': {
            'temperature': 26.0,
            'ph': 8.3,
            'salinity': 1024.0,
            'orp': 365.0,
          },
        },
      );
    });

    test('getTargetTemperature returns temperature', () async {
      expect(await sut.getTargetTemperature(), equals(26.0));
    });

    test('getTargetPh returns ph', () async {
      expect(await sut.getTargetPh(), equals(8.3));
    });

    test('getTargetSalinity returns salinity', () async {
      expect(await sut.getTargetSalinity(), equals(1024.0));
    });

    test('getTargetOrp returns orp', () async {
      expect(await sut.getTargetOrp(), equals(365.0));
    });
  });
}
