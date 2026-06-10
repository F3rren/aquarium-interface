import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/parameters/data/manual_parameters_service.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import '../../../helpers/mocks.dart';

void main() {
  late MockApiService api;
  late ManualParametersService sut;

  setUpAll(() {
    // saveManualParameters posts a Map body matched with any()/captureAny().
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    api = MockApiService();
    sut = ManualParametersService(api);
  });

  // The "no aquarium selected" fallbacks below are the exact behaviour the
  // upcoming setCurrentAquarium removal (#5) must preserve, so they are pinned
  // here first.

  group('loadManualParameters', () {
    test('returns service defaults when no aquarium selected (no API call)',
        () async {
      final result = await sut.loadManualParameters();

      expect(result['calcium'], 420.0);
      expect(result['magnesium'], 1280.0);
      expect(result['kh'], 9.0);
      expect(result['nitrate'], 5.0);
      expect(result['phosphate'], 0.03);
      verifyNever(() => api.get(any()));
    });

    test('parses the data-wrapped response when an aquarium is selected',
        () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/parameters/manual')).thenAnswer(
        (_) async => {
          'data': {
            'calcium': 999.0,
            'magnesium': 1234.0,
            'kh': 7.0,
            'nitrate': 1.0,
            'phosphate': 0.01,
          },
        },
      );

      final result = await sut.loadManualParameters();

      expect(result['calcium'], 999.0);
      expect(result['kh'], 7.0);
    });

    test('falls back to defaults on network error', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/parameters/manual'))
          .thenThrow(Exception('down'));

      final result = await sut.loadManualParameters();

      expect(result['calcium'], 420.0);
    });

    test('falls back to defaults on a non-map response', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/parameters/manual'))
          .thenAnswer((_) async => 'bad');

      final result = await sut.loadManualParameters();

      expect(result['phosphate'], 0.03);
    });
  });

  group('saveManualParameters', () {
    test('throws NoAquariumSelectedException when no aquarium selected', () {
      expect(
        sut.saveManualParameters(calcium: 400.0),
        throwsA(isA<NoAquariumSelectedException>()),
      );
    });

    test('posts only the non-null values plus a measuredAt timestamp',
        () async {
      sut.setCurrentAquarium(1);
      when(() => api.post('/aquariums/1/parameters/manual', any()))
          .thenAnswer((_) async => {'ok': true});

      await sut.saveManualParameters(calcium: 410.0, kh: 8.0);

      final body = verify(
        () => api.post('/aquariums/1/parameters/manual', captureAny()),
      ).captured.single as Map<String, dynamic>;

      expect(body['calcium'], 410.0);
      expect(body['kh'], 8.0);
      expect(body.containsKey('magnesium'), isFalse);
      expect(body.containsKey('measuredAt'), isTrue);
    });
  });

  group('getLastUpdate', () {
    test('returns null when no aquarium selected (no API call)', () async {
      expect(await sut.getLastUpdate(), isNull);
      verifyNever(() => api.get(any()));
    });

    test('parses measuredAt from the data envelope', () async {
      sut.setCurrentAquarium(1);
      when(() => api.get('/aquariums/1/parameters/manual')).thenAnswer(
        (_) async => {
          'data': {'measuredAt': '2024-06-01T12:00:00.000'},
        },
      );

      expect(
        await sut.getLastUpdate(),
        equals(DateTime.parse('2024-06-01T12:00:00.000')),
      );
    });
  });

  group('resetToDefaults', () {
    test('no-ops (no throw, no API call) when no aquarium selected', () async {
      await sut.resetToDefaults();
      verifyNever(() => api.delete(any()));
    });

    test('deletes the manual parameters when an aquarium is selected',
        () async {
      sut.setCurrentAquarium(1);
      when(() => api.delete('/aquariums/1/parameters/manual'))
          .thenAnswer((_) async => {'ok': true});

      await sut.resetToDefaults();

      verify(() => api.delete('/aquariums/1/parameters/manual')).called(1);
    });
  });
}
