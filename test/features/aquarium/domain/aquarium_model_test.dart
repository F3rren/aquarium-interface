import 'package:flutter_test/flutter_test.dart';
import 'package:acquariumfe/features/aquarium/domain/models/aquarium.dart';
import '../../../helpers/fixtures.dart';

void main() {
  group('Aquarium.fromJson', () {
    test('parses all fields correctly', () {
      final a = Aquarium.fromJson(aquariumMarineJson);

      expect(a.id, equals(1));
      expect(a.name, equals('Reef Tank'));
      expect(a.volume, equals(200.0));
      expect(a.type, equals('saltwater'));
      expect(a.description, equals('Main display reef'));
      expect(a.imageUrl, equals('https://example.com/tank.jpg'));
    });

    test('falls back to "Senza nome" when name is missing', () {
      final a = Aquarium.fromJson({'id': 5, 'volume': 100.0, 'type': 'marine'});
      expect(a.name, equals('Senza nome'));
    });

    test('falls back to 0.0 when volume is missing', () {
      final a = Aquarium.fromJson({'id': 5, 'name': 'X', 'type': 'marine'});
      expect(a.volume, equals(0.0));
    });

    test('falls back to "Marino" when type is missing', () {
      final a = Aquarium.fromJson({'id': 5, 'name': 'X', 'volume': 100.0});
      expect(a.type, equals('Marino'));
    });

    test('parses ISO-8601 createdAt', () {
      final a = Aquarium.fromJson({'createdAt': '2024-01-15T00:00:00.000'});
      expect(a.createdAt?.year, equals(2024));
    });

    test('handles invalid createdAt without crashing', () {
      final a = Aquarium.fromJson({'createdAt': 'not-a-date'});
      expect(a.createdAt, isNull);
    });

    test('leaves id null when missing', () {
      final a = Aquarium.fromJson({'name': 'Test', 'volume': 50.0, 'type': 'fresh'});
      expect(a.id, isNull);
    });
  });

  group('Aquarium.toJson', () {
    test('includes required fields', () {
      final json = aquariumMarine.toJson();
      expect(json['name'], equals('Reef Tank'));
      expect(json['volume'], equals(200.0));
      expect(json['type'], equals('saltwater'));
    });

    test('includes id when set', () {
      final json = aquariumMarine.toJson();
      expect(json['id'], equals(1));
    });

    test('omits id when null', () {
      final json = aquariumUnsaved.toJson();
      expect(json.containsKey('id'), isFalse);
    });

    test('omits optional fields when null', () {
      final json = aquariumUnsaved.toJson();
      expect(json.containsKey('description'), isFalse);
      expect(json.containsKey('imageUrl'), isFalse);
    });

    test('includes description when set', () {
      final json = aquariumMarine.toJson();
      expect(json['description'], equals('Main display reef'));
    });
  });

  group('Aquarium.copyWith', () {
    test('replaces name only', () {
      final updated = aquariumMarine.copyWith(name: 'Renamed');
      expect(updated.name, equals('Renamed'));
      expect(updated.id, equals(aquariumMarine.id));
      expect(updated.volume, equals(aquariumMarine.volume));
      expect(updated.type, equals(aquariumMarine.type));
    });

    test('replaces volume only', () {
      final updated = aquariumMarine.copyWith(volume: 300.0);
      expect(updated.volume, equals(300.0));
      expect(updated.name, equals(aquariumMarine.name));
    });

    test('calling with no args returns equivalent object', () {
      final copy = aquariumMarine.copyWith();
      expect(copy.id, equals(aquariumMarine.id));
      expect(copy.name, equals(aquariumMarine.name));
      expect(copy.volume, equals(aquariumMarine.volume));
    });
  });

  group('Aquarium fromJson ↔ toJson roundtrip', () {
    test('roundtrip preserves all fields', () {
      final original = aquariumMarine;
      final restored = Aquarium.fromJson(original.toJson());

      expect(restored.name, equals(original.name));
      expect(restored.volume, equals(original.volume));
      expect(restored.type, equals(original.type));
      expect(restored.description, equals(original.description));
      expect(restored.imageUrl, equals(original.imageUrl));
    });
  });
}
