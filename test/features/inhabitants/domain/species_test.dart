import 'package:flutter_test/flutter_test.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/fish_species.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/coral_species.dart';

void main() {
  group('FishSpecies.fromJson', () {
    test('parses a camelCase payload', () {
      final fish = FishSpecies.fromJson({
        'id': 7,
        'commonName': 'Clownfish',
        'scientificName': 'Amphiprion ocellaris',
        'family': 'Pomacentridae',
        'minTankSize': 75,
        'maxSize': 11,
        'difficulty': 'beginner',
        'reefSafe': true,
        'temperament': 'peaceful',
        'diet': 'omnivore',
        'imageUrl': 'https://x/clown.png',
        'description': 'A clownfish',
        'waterType': 'Marino',
      });

      expect(fish.id, '7');
      expect(fish.commonName, 'Clownfish');
      expect(fish.minTankSize, 75);
      expect(fish.maxSize, 11.0);
      expect(fish.reefSafe, isTrue);
      expect(fish.waterType, 'Marino');
    });

    test('accepts snake_case aliases', () {
      final fish = FishSpecies.fromJson({
        'id': 1,
        'common_name': 'Yellow Tang',
        'scientific_name': 'Zebrasoma flavescens',
        'min_tank_size': 200,
        'max_size': 20,
        'reef_safe': false,
        'image_url': 'u',
        'water_type': 'Marino',
      });

      expect(fish.commonName, 'Yellow Tang');
      expect(fish.scientificName, 'Zebrasoma flavescens');
      expect(fish.minTankSize, 200);
      expect(fish.reefSafe, isFalse);
      expect(fish.imageUrl, 'u');
    });

    test('falls back to defaults for missing fields', () {
      final fish = FishSpecies.fromJson({'id': 2});

      expect(fish.commonName, '');
      expect(fish.minTankSize, 0);
      expect(fish.maxSize, 0.0);
      expect(fish.difficulty, 'intermediate');
      expect(fish.reefSafe, isTrue);
      expect(fish.temperament, 'peaceful');
      expect(fish.diet, 'omnivore');
      expect(fish.imageUrl, isNull);
    });
  });

  group('CoralSpecies.fromJson', () {
    test('parses a camelCase payload', () {
      final coral = CoralSpecies.fromJson({
        'id': 3,
        'commonName': 'Hammer Coral',
        'scientificName': 'Euphyllia ancora',
        'type': 'lps',
        'minTankSize': 100,
        'maxSize': 20,
        'difficulty': 'intermediate',
        'lightRequirement': 'medium',
        'flowRequirement': 'medium',
        'placement': 'middle',
        'aggressive': true,
        'feeding': 'both',
        'imageUrl': 'https://x/hammer.png',
        'description': 'A hammer coral',
      });

      expect(coral.id, '3');
      expect(coral.type, 'lps');
      expect(coral.minTankSize, 100);
      expect(coral.maxSize, 20);
      expect(coral.aggressive, isTrue);
      expect(coral.imageUrl, 'https://x/hammer.png');
      expect(coral.description, 'A hammer coral');
    });

    test('parses numeric sizes provided as strings', () {
      final coral = CoralSpecies.fromJson({
        'id': 4,
        'minTankSize': '50',
        'maxSize': '15',
        'aggressive': 'true',
        'description': 'x',
      });

      expect(coral.minTankSize, 50);
      expect(coral.maxSize, 15);
      expect(coral.aggressive, isTrue);
    });

    test('falls back to defaults for missing fields', () {
      final coral = CoralSpecies.fromJson({'id': 5});

      expect(coral.commonName, '');
      expect(coral.type, '');
      expect(coral.minTankSize, 0);
      expect(coral.aggressive, isFalse);
      expect(coral.description, '');
      expect(coral.imageUrl, isNull);
    });
  });
}
