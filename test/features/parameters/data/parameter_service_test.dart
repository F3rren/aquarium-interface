import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import 'package:acquariumfe/core/utils/retry_policy.dart';
import 'package:acquariumfe/features/parameters/data/parameter_service.dart';
import '../../../helpers/mocks.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late MockApiService api;
  late MockTargetParametersService target;
  late ParameterService sut;

  setUpAll(() {
    // ParameterService calls api.get(endpoint, retry: RetryPolicies.critical),
    // so mocktail needs a fallback for the custom RetryPolicy type.
    registerFallbackValue(RetryPolicies.none);
  });

  setUp(() {
    api = MockApiService();
    target = MockTargetParametersService();
    sut = ParameterService(api, target);
  });

  group('getCurrentParameters — no silent mock fallback', () {
    test('propagates the typed error by default (no useMock argument)',
        () async {
      when(() => api.get(any(), retry: any(named: 'retry')))
          .thenThrow(AuthException('401'));

      // The dangerous old behaviour returned fake "all good" data here.
      expect(
        sut.getCurrentParameters(id: 1),
        throwsA(isA<AuthException>()),
      );
    });

    test('rethrows when useMock is false', () async {
      when(() => api.get(any(), retry: any(named: 'retry')))
          .thenThrow(NetworkException('down'));

      expect(
        sut.getCurrentParameters(id: 1, useMock: false),
        throwsA(isA<NetworkException>()),
      );
    });

    test('returns the hardcoded fallback only when useMock is explicitly true',
        () async {
      when(() => api.get(any(), retry: any(named: 'retry')))
          .thenThrow(NetworkException('down'));

      final result = await sut.getCurrentParameters(id: 1, useMock: true);

      // Typical reef values from _getMockParameters().
      expect(result.temperature, 25.0);
      expect(result.ph, 8.20);
      expect(result.salinity, 1.024);
    });

    test('throws NoAquariumSelectedException when no aquarium is selected',
        () async {
      expect(
        sut.getCurrentParameters(),
        throwsA(isA<NoAquariumSelectedException>()),
      );
    });
  });

  group('getCurrentParameters — success path', () {
    test('merges manual parameters over sensor values (alerts disabled)',
        () async {
      final manual = MockManualParametersService();
      when(() => manual.loadManualParameters())
          .thenAnswer((_) async => {'calcium': 999.0});

      final service = ParameterService(api, target, manualService: manual);
      service.setAutoCheckAlerts(false); // isolate the merge from alerting

      when(() => api.get(any(), retry: any(named: 'retry')))
          .thenAnswer((_) async => parametersJson);

      final result =
          await service.getCurrentParameters(id: 1, useMock: false);

      expect(result.temperature, 25.5); // sensor value passes through
      expect(result.calcium, 999.0); // manual override wins
    });
  });
}
