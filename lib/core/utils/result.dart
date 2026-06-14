/// Lightweight Result type for explicit error handling without try/catch cascades.
///
/// Use [Ok] to wrap a successful value and [Err] to wrap an [AppException].
/// Pattern-match with a `switch` expression (Dart 3+):
///
/// ```dart
/// final result = await repository.getAquariums();
/// switch (result) {
///   case Ok(:final value): state = AsyncData(value);
///   case Err(:final error): state = AsyncError(error, StackTrace.current);
/// }
/// ```
library;

import 'package:acquariumfe/core/utils/exceptions.dart';

/// Base sealed class; only [Ok] and [Err] are valid variants.
sealed class Result<T> {
  const Result();

  /// Returns the value if this is [Ok], otherwise `null`.
  T? get valueOrNull => switch (this) {
        Ok(:final value) => value,
        Err() => null,
      };

  /// Returns the error if this is [Err], otherwise `null`.
  AppException? get errorOrNull => switch (this) {
        Ok() => null,
        Err(:final error) => error,
      };

  /// `true` when this is an [Ok] variant.
  bool get isOk => this is Ok<T>;

  /// `true` when this is an [Err] variant.
  bool get isErr => this is Err<T>;

  /// Transforms the success value with [f], leaving [Err] unchanged.
  Result<R> map<R>(R Function(T value) f) => switch (this) {
        Ok(:final value) => Ok(f(value)),
        Err(:final error) => Err(error),
      };

  /// Runs [onOk] for success or [onErr] for failure and returns the result.
  R fold<R>({
    required R Function(T value) onOk,
    required R Function(AppException error) onErr,
  }) =>
      switch (this) {
        Ok(:final value) => onOk(value),
        Err(:final error) => onErr(error),
      };
}

/// Successful result carrying [value].
final class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);

  @override
  String toString() => 'Ok($value)';
}

/// Failed result carrying an [AppException].
final class Err<T> extends Result<T> {
  final AppException error;
  const Err(this.error);

  @override
  String toString() => 'Err(${error.message})';
}

/// Wraps [fn] in a try/catch and maps [AppException] to [Err].
///
/// Non-[AppException] errors are rethrown — only typed, expected errors are
/// converted to [Err] so that programming errors still surface as exceptions.
///
/// ```dart
/// final result = await guardResult(() => repo.getAquariums());
/// ```
Future<Result<T>> guardResult<T>(Future<T> Function() fn) async {
  try {
    return Ok(await fn());
  } on AppException catch (e) {
    return Err(e);
  }
}
