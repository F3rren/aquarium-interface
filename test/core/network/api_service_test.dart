import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:acquariumfe/core/network/api_service.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';
import 'package:acquariumfe/core/utils/retry_policy.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

/// Case-insensitive lookup of the Authorization header on a captured request.
String? _authHeader(http.Request request) {
  for (final entry in request.headers.entries) {
    if (entry.key.toLowerCase() == 'authorization') return entry.value;
  }
  return null;
}

void main() {
  late _MockStorage storage;

  setUp(() {
    storage = _MockStorage();
    // Default: no token persisted.
    when(() => storage.read(key: any(named: 'key')))
        .thenAnswer((_) async => null);
  });

  ApiService apiWith(MockClient client) =>
      ApiService(storage: storage, client: client);

  group('_handleResponse mapping (exercised via get)', () {
    test('decodes a 200 JSON body', () async {
      final api =
          apiWith(MockClient((_) async => http.Response('{"id":1}', 200)));
      expect(await api.get('/x'), {'id': 1});
    });

    test('normalises an empty 2xx body to {success: true}', () async {
      final api = apiWith(MockClient((_) async => http.Response('', 204)));
      expect(await api.get('/x'), {'success': true});
    });

    test('maps 401 to AuthException', () async {
      final api = apiWith(
        MockClient((_) async => http.Response('{"message":"no"}', 401)),
      );
      expect(api.get('/x'), throwsA(isA<AuthException>()));
    });

    test('maps 404 to NotFoundException', () async {
      final api = apiWith(MockClient((_) async => http.Response('{}', 404)));
      expect(api.get('/x'), throwsA(isA<NotFoundException>()));
    });

    test('maps other 4xx to ValidationException', () async {
      final api = apiWith(
        MockClient((_) async => http.Response('{"message":"bad"}', 422)),
      );
      expect(api.get('/x'), throwsA(isA<ValidationException>()));
    });

    test('maps 5xx to ServerException', () async {
      final api = apiWith(MockClient((_) async => http.Response('{}', 500)));
      // Disable retry so the test does not wait through the back-off.
      expect(
        api.get('/x', retry: RetryPolicies.none),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws DataFormatException on a non-JSON 2xx body', () async {
      final api =
          apiWith(MockClient((_) async => http.Response('not json', 200)));
      expect(api.get('/x'), throwsA(isA<DataFormatException>()));
    });
  });

  group('auth header', () {
    test('omits Authorization when no token is stored', () async {
      late http.Request seen;
      final api = apiWith(MockClient((req) async {
        seen = req;
        return http.Response('{}', 200);
      }));

      await api.get('/x');

      expect(_authHeader(seen), isNull);
    });

    test('adds a Bearer token when one is stored', () async {
      when(() => storage.read(key: any(named: 'key')))
          .thenAnswer((_) async => 'tok123');
      late http.Request seen;
      final api = apiWith(MockClient((req) async {
        seen = req;
        return http.Response('{}', 200);
      }));

      await api.get('/x');

      expect(_authHeader(seen), 'Bearer tok123');
    });
  });

  group('post', () {
    test('sends the JSON-encoded body and returns the decoded response',
        () async {
      late http.Request seen;
      final api = apiWith(MockClient((req) async {
        seen = req;
        return http.Response('{"ok":true}', 201);
      }));

      final result = await api.post('/x', {'name': 'Reef'});

      expect(seen.method, 'POST');
      expect(seen.body, '{"name":"Reef"}');
      expect(result, {'ok': true});
    });
  });
}
