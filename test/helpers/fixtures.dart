/// Reusable test data (fixtures) shared across the test suite.
///
/// Every fixture is a plain Dart value — no mocking, no async.
/// Import this file wherever you need ready-made domain objects.
library;

import 'package:acquariumfe/features/aquarium/domain/models/aquarium.dart';
import 'package:acquariumfe/features/parameters/domain/models/aquarium_parameters.dart';

// ── Aquarium fixtures ─────────────────────────────────────────────────────────

/// A typical saltwater aquarium with all fields populated.
final aquariumMarine = Aquarium(
  id: 1,
  name: 'Reef Tank',
  volume: 200.0,
  type: 'saltwater',
  createdAt: DateTime(2024, 1, 15),
  description: 'Main display reef',
  imageUrl: 'https://example.com/tank.jpg',
);

/// A freshwater aquarium with minimal fields.
final aquariumFreshwater = Aquarium(
  id: 2,
  name: 'Planted Tank',
  volume: 100.0,
  type: 'freshwater',
);

/// An unsaved aquarium (id is null, as returned before first persist).
final aquariumUnsaved = Aquarium(
  name: 'New Tank',
  volume: 150.0,
  type: 'saltwater',
);

/// Raw JSON matching [aquariumMarine].
final aquariumMarineJson = <String, dynamic>{
  'id': 1,
  'name': 'Reef Tank',
  'volume': 200.0,
  'type': 'saltwater',
  'createdAt': '2024-01-15T00:00:00.000',
  'description': 'Main display reef',
  'imageUrl': 'https://example.com/tank.jpg',
};

/// Backend list response wrapping two aquariums.
final aquariumListResponse = <String, dynamic>{
  'data': [
    aquariumMarineJson,
    {'id': 2, 'name': 'Planted Tank', 'volume': 100.0, 'type': 'freshwater'},
  ],
};

// ── AquariumParameters fixtures ───────────────────────────────────────────────

/// Healthy reef parameters (all values within typical ranges).
final parametersHealthy = AquariumParameters(
  temperature: 25.5,
  ph: 8.2,
  salinity: 1.025,
  orp: 350.0,
  calcium: 420.0,
  magnesium: 1300.0,
  kh: 8.5,
  nitrate: 5.0,
  phosphate: 0.05,
  timestamp: DateTime(2024, 6, 1, 12, 0),
);

/// Parameters with temperature out of range (too high).
final parametersHighTemp = AquariumParameters(
  temperature: 29.0,
  ph: 8.2,
  salinity: 1.025,
  orp: 350.0,
  timestamp: DateTime(2024, 6, 1, 12, 0),
);

/// Raw JSON matching [parametersHealthy].
final parametersJson = <String, dynamic>{
  'temperature': 25.5,
  'ph': 8.2,
  'salinity': 1.025,
  'orp': 350.0,
  'calcium': 420.0,
  'magnesium': 1300.0,
  'kh': 8.5,
  'nitrate': 5.0,
  'phosphate': 0.05,
  'measuredAt': '2024-06-01T12:00:00.000',
};

/// Backend response wrapping the parameters in a data key.
final parametersWrappedResponse = <String, dynamic>{'data': parametersJson};
