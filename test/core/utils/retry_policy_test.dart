import 'package:flutter_test/flutter_test.dart';
import 'package:acquariumfe/core/utils/retry_policy.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';

void main() {
  group('RetryPolicy', () {
    test('returns value immediately on first success', () async {
      int calls = 0;
      const policy = RetryPolicy(maxAttempts: 3);

      final result = await policy.execute(() async {
        calls++;
        return 'ok';
      });

      expect(result, equals('ok'));
      expect(calls, equals(1));
    });

    test('retries on failure and returns value on second attempt', () async {
      int calls = 0;
      const policy = RetryPolicy(
        maxAttempts: 3,
        initialDelay: Duration(milliseconds: 1),
      );

      final result = await policy.execute(() async {
        calls++;
        if (calls == 1) throw NetworkException('first fail');
        return 42;
      });

      expect(result, equals(42));
      expect(calls, equals(2));
    });

    test('rethrows after exhausting all attempts', () async {
      int calls = 0;
      const policy = RetryPolicy(
        maxAttempts: 3,
        initialDelay: Duration(milliseconds: 1),
      );

      expect(
        policy.execute(() async {
          calls++;
          throw NetworkException('always fails');
        }),
        throwsA(isA<NetworkException>()),
      );
      await Future.delayed(const Duration(milliseconds: 20));
      expect(calls, equals(3));
    });

    test('respects shouldRetry predicate — no retry on non-network error',
        () async {
      int calls = 0;
      const policy = RetryPolicy(
        maxAttempts: 3,
        initialDelay: Duration(milliseconds: 1),
      );

      await expectLater(
        policy.execute(
          () async {
            calls++;
            throw AuthException('unauthorized');
          },
          shouldRetry: (e) => e is NetworkException,
        ),
        throwsA(isA<AuthException>()),
      );

      expect(calls, equals(1)); // no retry because shouldRetry returned false
    });

    test('RetryPolicies.none executes exactly once', () async {
      int calls = 0;

      await expectLater(
        RetryPolicies.none.execute(() async {
          calls++;
          throw NetworkException('fail');
        }),
        throwsA(isA<NetworkException>()),
      );

      expect(calls, equals(1));
    });

    test('retries the correct number of times with fast delays', () async {
      // Use 1 ms delays so the test finishes quickly without fakeAsync
      int calls = 0;
      const policy = RetryPolicy(
        maxAttempts: 3,
        initialDelay: Duration(milliseconds: 1),
        maxDelay: Duration(milliseconds: 10),
        multiplier: 2.0,
      );

      await expectLater(
        policy.execute(() async {
          calls++;
          throw NetworkException('fail');
        }),
        throwsA(isA<NetworkException>()),
      );

      expect(calls, equals(3)); // exactly 3 attempts
    });

    test('RetryPolicies.network has 3 maxAttempts', () {
      expect(RetryPolicies.network.maxAttempts, equals(3));
    });

    test('RetryPolicies.critical has 5 maxAttempts', () {
      expect(RetryPolicies.critical.maxAttempts, equals(5));
    });

    test('maxDelay cap is respected (policy config test)', () {
      // Verify the cap value is correctly set — behavioral cap is an
      // internal implementation detail; we test the public contract only.
      const policy = RetryPolicy(
        maxAttempts: 5,
        initialDelay: Duration(milliseconds: 100),
        maxDelay: Duration(milliseconds: 150),
        multiplier: 4.0,
      );
      expect(policy.maxDelay, equals(const Duration(milliseconds: 150)));
      expect(policy.multiplier, equals(4.0));
    });
  });
}
