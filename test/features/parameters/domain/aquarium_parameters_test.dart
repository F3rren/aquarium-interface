import 'package:flutter_test/flutter_test.dart';
import 'package:acquariumfe/features/parameters/domain/models/aquarium_parameters.dart';
import '../../../helpers/fixtures.dart';

void main() {
  group('AquariumParameters.fromJson', () {
    test('parses all required fields', () {
      final p = AquariumParameters.fromJson(parametersJson);

      expect(p.temperature, equals(25.5));
      expect(p.ph, equals(8.2));
      expect(p.salinity, equals(1.025));
      expect(p.orp, equals(350.0));
    });

    test('parses optional fields when present', () {
      final p = AquariumParameters.fromJson(parametersJson);

      expect(p.calcium, equals(420.0));
      expect(p.magnesium, equals(1300.0));
      expect(p.kh, equals(8.5));
      expect(p.nitrate, equals(5.0));
      expect(p.phosphate, equals(0.05));
    });

    test('leaves optional fields null when absent', () {
      final p = AquariumParameters.fromJson({
        'temperature': 25.0,
        'ph': 8.2,
        'salinity': 1.025,
        'orp': 350.0,
        'measuredAt': '2024-01-01T00:00:00.000',
      });

      expect(p.calcium, isNull);
      expect(p.magnesium, isNull);
      expect(p.kh, isNull);
      expect(p.nitrate, isNull);
      expect(p.phosphate, isNull);
    });

    test('parses timestamp from "measuredAt" key', () {
      final p = AquariumParameters.fromJson({
        'temperature': 25.0,
        'ph': 8.0,
        'salinity': 1.025,
        'orp': 350.0,
        'measuredAt': '2024-06-01T12:00:00.000',
      });
      expect(p.timestamp.year, equals(2024));
      expect(p.timestamp.month, equals(6));
    });

    test('parses timestamp from "timestamp" key as fallback', () {
      final p = AquariumParameters.fromJson({
        'temperature': 25.0,
        'ph': 8.0,
        'salinity': 1.025,
        'orp': 350.0,
        'timestamp': '2024-03-15T08:00:00.000',
      });
      expect(p.timestamp.day, equals(15));
    });

    test('falls back to now when no timestamp key is present', () {
      final before = DateTime.now().subtract(const Duration(seconds: 1));
      final p = AquariumParameters.fromJson({
        'temperature': 25.0,
        'ph': 8.0,
        'salinity': 1.025,
        'orp': 350.0,
      });
      expect(p.timestamp.isAfter(before), isTrue);
    });

    test('defaults to 0.0 when numeric fields are missing', () {
      final p = AquariumParameters.fromJson({});
      expect(p.temperature, equals(0.0));
      expect(p.ph, equals(0.0));
    });
  });

  group('AquariumParameters.toJson', () {
    test('includes all required fields', () {
      final json = parametersHealthy.toJson();

      expect(json['temperature'], equals(25.5));
      expect(json['ph'], equals(8.2));
      expect(json['salinity'], equals(1.025));
      expect(json['orp'], equals(350.0));
    });

    test('includes optional fields when not null', () {
      final json = parametersHealthy.toJson();
      expect(json['calcium'], equals(420.0));
      expect(json['kh'], equals(8.5));
    });

    test('omits optional fields when null', () {
      final json = AquariumParameters(
        temperature: 25.0,
        ph: 8.2,
        salinity: 1.025,
        orp: 350.0,
        timestamp: DateTime(2024),
      ).toJson();

      expect(json.containsKey('calcium'), isFalse);
      expect(json.containsKey('nitrate'), isFalse);
    });

    test('serialises timestamp to ISO-8601 string', () {
      final json = parametersHealthy.toJson();
      expect(json['timestamp'], isA<String>());
      expect(json['timestamp'], contains('2024-06-01'));
    });
  });

  group('AquariumParameters.toMap', () {
    test('returns flat map with non-null parameters', () {
      final map = parametersHealthy.toMap();

      expect(map['temperature'], equals(25.5));
      expect(map['calcium'], equals(420.0));
      expect(map.containsKey('phosphate'), isTrue);
    });

    test('omits null optional parameters', () {
      final p = AquariumParameters(
        temperature: 25.0,
        ph: 8.2,
        salinity: 1.025,
        orp: 350.0,
        timestamp: DateTime(2024),
      );
      final map = p.toMap();

      expect(map.containsKey('calcium'), isFalse);
      expect(map.containsKey('kh'), isFalse);
    });
  });

  group('fromJson ↔ toJson roundtrip', () {
    test('roundtrip preserves all values', () {
      final restored = AquariumParameters.fromJson(parametersHealthy.toJson());

      expect(restored.temperature, equals(parametersHealthy.temperature));
      expect(restored.ph, equals(parametersHealthy.ph));
      expect(restored.calcium, equals(parametersHealthy.calcium));
    });
  });
}
