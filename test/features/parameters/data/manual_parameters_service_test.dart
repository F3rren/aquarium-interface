import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/features/parameters/data/manual_parameters_service.dart';
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

  group('loadManualParameters', () {
    test('parses the data-wrapped response', () async {
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

      final result = await sut.loadManualParameters(1);

      expect(result['calcium'], 999.0);
      expect(result['kh'], 7.0);
    });

    test('falls back to defaults on network error', () async {
      when(() => api.get('/aquariums/1/parameters/manual'))
          .thenThrow(Exception('down'));

      final result = await sut.loadManualParameters(1);

      expect(result['calcium'], 420.0);
    });

    test('falls back to defaults on a non-map response', () async {
      when(() => api.get('/aquariums/1/parameters/manual'))
          .thenAnswer((_) async => 'bad');

      final result = await sut.loadManualParameters(1);

      expect(result['phosphate'], 0.03);
    });
  });

  group('saveManualParameters', () {
    test('posts only the non-null values plus a measuredAt timestamp',
        () async {
      when(() => api.post('/aquariums/1/parameters/manual', any()))
          .thenAnswer((_) async => {'ok': true});

      await sut.saveManualParameters(1, calcium: 410.0, kh: 8.0);

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
    test('parses measuredAt from the data envelope', () async {
      when(() => api.get('/aquariums/1/parameters/manual')).thenAnswer(
        (_) async => {
          'data': {'measuredAt': '2024-06-01T12:00:00.000'},
        },
      );

      expect(
        await sut.getLastUpdate(1),
        equals(DateTime.parse('2024-06-01T12:00:00.000')),
      );
    });
  });

  group('resetToDefaults', () {
    test('deletes the manual parameters for the aquarium', () async {
      when(() => api.delete('/aquariums/1/parameters/manual'))
          .thenAnswer((_) async => {'ok': true});

      await sut.resetToDefaults(1);

      verify(() => api.delete('/aquariums/1/parameters/manual')).called(1);
    });
  });
}
