import 'package:flutter_test/flutter_test.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/fish.dart';
import 'package:acquariumfe/features/inhabitants/domain/models/coral.dart';

void main() {
  group('Fish.fromInhabitantJson', () {
    test('maps fields, with nested details taking precedence', () {
      final fish = Fish.fromInhabitantJson({
        'id': 42,
        'type': 'fish',
        'commonName': 'Clownfish',
        'scientificName': 'Amphiprion ocellaris',
        'customName': 'Nemo',
        'currentSize': 6,
        'addedDate': '2024-06-01T10:00:00.000',
        'notes': 'top-note',
        'customMinTankSize': 75,
        'customDifficulty': 'expert',
        'isReefSafe': false,
        'details': {
          'size': 8,
          'family': 'Pomacentridae',
          'difficulty': 'beginner',
          'reefSafe': true,
          'notes': 'detail-note',
          'minTankSize': 100,
        },
      });

      expect(fish.id, '42');
      expect(fish.name, 'Nemo'); // customName wins over commonName
      expect(fish.species, 'Amphiprion ocellaris');
      expect(fish.size, 8.0); // details.size wins
      expect(fish.addedDate, DateTime.parse('2024-06-01T10:00:00.000'));
      expect(fish.notes, 'detail-note'); // details.notes wins
      expect(fish.family, 'Pomacentridae');
      expect(fish.minTankSize, 100); // details wins
      expect(fish.difficulty, 'beginner'); // details wins over customDifficulty
      expect(fish.reefSafe, isTrue); // details.reefSafe wins
    });

    test('falls back to top-level fields and size default when no details', () {
      final fish = Fish.fromInhabitantJson({
        'id': 1,
        'commonName': 'Tang',
        'customDifficulty': 'intermediate',
        'isReefSafe': true,
        'customMinTankSize': 200,
      });

      expect(fish.name, 'Tang'); // commonName fallback
      expect(fish.species, 'Tang');
      expect(fish.size, 10.0); // fish default size
      expect(fish.difficulty, 'intermediate');
      expect(fish.minTankSize, 200);
      expect(fish.reefSafe, isTrue);
      expect(fish.addedDate, isA<DateTime>()); // missing -> now()
    });
  });

  group('Coral.fromInhabitantJson', () {
    test('maps fields with details precedence; size falls back to maxSize', () {
      final coral = Coral.fromInhabitantJson({
        'id': 9,
        'type': 'coral',
        'commonName': 'Hammer',
        'scientificName': 'Euphyllia ancora',
        'customName': 'Thor',
        'currentSize': 4,
        'addedDate': '2024-05-20T09:30:00.000',
        'customMinTankSize': 80,
        'details': {
          'maxSize': 12,
          'type': 'LPS',
          'placement': 'Basso',
          'aggressive': true,
          'difficulty': 'intermediate',
        },
      });

      expect(coral.id, '9');
      expect(coral.name, 'Thor');
      expect(coral.size, 12.0); // details.maxSize used as size
      expect(coral.type, 'LPS');
      expect(coral.placement, 'Basso');
      expect(coral.aggressive, isTrue);
      expect(coral.minTankSize, 80);
      expect(coral.maxSize, 12);
    });

    test('uses coral defaults when details absent', () {
      final coral = Coral.fromInhabitantJson({
        'id': 2,
        'commonName': 'Zoa',
      });

      expect(coral.name, 'Zoa');
      expect(coral.size, 5.0); // coral default size
      expect(coral.type, 'SPS'); // default
      expect(coral.placement, 'Medio'); // default
    });
  });
}
