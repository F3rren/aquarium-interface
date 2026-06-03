/// Helpers for safely unwrapping generated-DTO `fromJson` results.
library;

import 'package:acquariumfe/core/utils/exceptions.dart';

/// Returns [dto] when non-null, otherwise throws a [DataFormatException].
///
/// The openapi-generated `*.fromJson` factories return `null` for a payload
/// that does not match the expected schema. Unwrapping that with a bare `!`
/// turns a backend hiccup (missing field, unexpected shape, `null` body) into
/// an opaque `TypeError` that bypasses the app's typed-exception handling.
/// Wrapping the call in [requireParsed] instead surfaces a typed, user-facing
/// [DataFormatException].
///
/// ```dart
/// final dto = requireParsed(
///   AquariumResponseDTO.fromJson(json),
///   context: 'AquariumResponseDTO',
/// );
/// ```
T requireParsed<T>(T? dto, {String? context}) {
  if (dto == null) {
    throw DataFormatException(
      'Malformed or unexpected response payload',
      details: context,
    );
  }
  return dto;
}
