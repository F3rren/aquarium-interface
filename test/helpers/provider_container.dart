/// Factory helpers for building Riverpod [ProviderContainer] in tests.
///
/// Use [makeContainer] to create an isolated container with optional
/// provider overrides. The container is automatically disposed via
/// [addTearDown] so you never leak state between tests.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Creates a [ProviderContainer] with [overrides] and registers auto-disposal.
///
/// Example:
/// ```dart
/// final container = makeContainer(overrides: [
///   aquariumsServiceProvider.overrideWithValue(mockService),
/// ]);
/// ```
ProviderContainer makeContainer({List<Override> overrides = const []}) {
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  return container;
}
