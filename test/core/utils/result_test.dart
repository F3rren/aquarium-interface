import 'package:flutter_test/flutter_test.dart';
import 'package:acquariumfe/core/utils/result.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';

void main() {
  group('Ok<T>', () {
    test('isOk is true', () {
      expect(Ok(42).isOk, isTrue);
    });

    test('isErr is false', () {
      expect(Ok(42).isErr, isFalse);
    });

    test('valueOrNull returns the value', () {
      expect(Ok('hello').valueOrNull, equals('hello'));
    });

    test('errorOrNull returns null', () {
      expect(Ok(1).errorOrNull, isNull);
    });

    test('map transforms the value', () {
      final result = Ok(10).map((v) => v * 3);
      expect(result.valueOrNull, equals(30));
    });

    test('map returns Ok', () {
      expect(Ok(1).map((v) => v), isA<Ok<int>>());
    });

    test('fold calls onOk', () {
      final out = Ok(7).fold(onOk: (v) => v * 2, onErr: (_) => -1);
      expect(out, equals(14));
    });

    test('toString contains the value', () {
      expect(Ok(99).toString(), contains('99'));
    });
  });

  group('Err<T>', () {
    final err = NetworkException('offline');

    test('isErr is true', () {
      expect(Err<int>(err).isErr, isTrue);
    });

    test('isOk is false', () {
      expect(Err<int>(err).isOk, isFalse);
    });

    test('valueOrNull returns null', () {
      expect(Err<String>(err).valueOrNull, isNull);
    });

    test('errorOrNull returns the exception', () {
      expect(Err<int>(err).errorOrNull, same(err));
    });

    test('map leaves Err unchanged', () {
      final result = Err<int>(err).map((v) => v * 2);
      expect(result.isErr, isTrue);
      expect(result.errorOrNull, same(err));
    });

    test('fold calls onErr', () {
      final out = Err<int>(err).fold(onOk: (v) => v, onErr: (_) => -99);
      expect(out, equals(-99));
    });

    test('toString contains the message', () {
      expect(Err<int>(err).toString(), contains('offline'));
    });
  });

  group('guardResult', () {
    test('wraps successful future in Ok', () async {
      final result = await guardResult(() async => 42);
      expect(result, isA<Ok<int>>());
      expect(result.valueOrNull, equals(42));
    });

    test('wraps AppException in Err', () async {
      final result = await guardResult<int>(
        () async => throw NetworkException('no internet'),
      );
      expect(result, isA<Err<int>>());
      expect(result.errorOrNull, isA<NetworkException>());
    });

    test('rethrows non-AppException errors', () {
      expect(
        guardResult<int>(() async => throw StateError('programming error')),
        throwsA(isA<StateError>()),
      );
    });

    test('wraps subclasses of AppException in Err', () async {
      final result = await guardResult<String>(
        () async => throw AuthException('expired'),
      );
      expect(result.errorOrNull, isA<AuthException>());
    });
  });
}
