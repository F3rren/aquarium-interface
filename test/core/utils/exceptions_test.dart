import 'package:flutter_test/flutter_test.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';

void main() {
  group('AppException hierarchy', () {
    test('NetworkException has correct userMessage', () {
      final e = NetworkException('socket error');
      expect(e.userMessage, contains('Connection error'));
    });

    test('AuthException has correct userMessage', () {
      final e = AuthException('401');
      expect(e.userMessage, contains('Session expired'));
    });

    test('NotFoundException has correct userMessage', () {
      final e = NotFoundException('not found');
      expect(e.userMessage, contains('not found'));
    });

    test('ServerException carries statusCode', () {
      final e = ServerException('internal', statusCode: 503);
      expect(e.statusCode, equals(503));
      expect(e.userMessage, contains('server'));
    });

    test('ValidationException carries errors map', () {
      final e = ValidationException(
        'bad request',
        statusCode: 422,
        errors: {'email': 'invalid'},
      );
      expect(e.errors?['email'], equals('invalid'));
    });

    test('TimeoutException carries timeout duration', () {
      const dur = Duration(seconds: 15);
      final e = TimeoutException('timeout', timeout: dur);
      expect(e.timeout, equals(dur));
    });

    test('NoAquariumSelectedException has correct userMessage', () {
      final e = NoAquariumSelectedException();
      expect(e.userMessage, contains('aquarium'));
    });

    test('toString includes details when present', () {
      final e = NetworkException('fail', details: '/aquariums');
      expect(e.toString(), contains('/aquariums'));
    });

    test('toString omits details when null', () {
      final e = NetworkException('fail');
      expect(e.toString(), equals('fail'));
    });

    test('all exceptions implement Exception', () {
      expect(NetworkException('x'), isA<Exception>());
      expect(AuthException('x'), isA<Exception>());
      expect(ServerException('x'), isA<Exception>());
      expect(ValidationException('x'), isA<Exception>());
    });
  });
}
