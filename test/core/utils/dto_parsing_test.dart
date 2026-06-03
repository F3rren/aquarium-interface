import 'package:flutter_test/flutter_test.dart';
import 'package:acquariumfe/core/utils/dto_parsing.dart';
import 'package:acquariumfe/core/utils/exceptions.dart';

void main() {
  group('requireParsed', () {
    test('returns the value when non-null', () {
      expect(requireParsed<int>(42), 42);
      expect(requireParsed<String>('ok', context: 'X'), 'ok');
    });

    test('throws DataFormatException when null', () {
      expect(
        () => requireParsed<int>(null, context: 'AquariumResponseDTO'),
        throwsA(isA<DataFormatException>()),
      );
    });

    test('carries the context in the exception details', () {
      try {
        requireParsed<int>(null, context: 'WaterParameterDTO');
        fail('expected a DataFormatException');
      } on DataFormatException catch (e) {
        expect(e.details, 'WaterParameterDTO');
      }
    });
  });
}
