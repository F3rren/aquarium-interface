import 'package:flutter_test/flutter_test.dart';
import 'package:acquariumfe/features/maintenance/domain/models/maintenance_task.dart';
import 'package:acquariumfe/features/maintenance/domain/models/product.dart';

void main() {
  group('MaintenanceTask.fromJson', () {
    test('coerces ids to String and infers category from keywords', () {
      final t = MaintenanceTask.fromJson({
        'id': 11,
        'aquariumId': 3,
        'title': 'Cambio acqua',
        'description': 'settimanale',
        'frequency': 'weekly',
        'priority': 'high',
        'isCompleted': false,
        'frequencyDays': 7,
      });

      expect(t.id, '11');
      expect(t.aquariumId, '3');
      expect(t.title, 'Cambio acqua');
      expect(t.category, MaintenanceCategory.water); // 'acqua' / 'cambio'
      expect(t.frequency, 'weekly');
      expect(t.frequencyDays, 7);
      expect(t.isCompleted, isFalse);
    });

    test('uses an explicit category when present', () {
      final t = MaintenanceTask.fromJson({
        'id': 1,
        'aquariumId': 1,
        'title': 'Generic',
        'category': 'dosing',
      });

      expect(t.category, MaintenanceCategory.dosing);
    });
  });

  group('Product.fromJson', () {
    test('maps an UPPERCASE category string and numeric fields', () {
      final p = Product.fromJson({
        'id': 5,
        'name': 'Coral Food',
        'category': 'FOOD',
        'brand': 'BrandX',
        'quantity': 2.5,
        'unit': 'ml',
        'cost': 12.0,
        'currency': r'$',
        'isFavorite': true,
        'usageFrequency': 7,
      });

      expect(p.id, '5');
      expect(p.name, 'Coral Food');
      expect(p.category, ProductCategory.food);
      expect(p.quantity, 2.5);
      expect(p.cost, 12.0);
      expect(p.currency, r'$');
      expect(p.isFavorite, isTrue);
    });

    test('defaults currency to € and unknown category to other', () {
      final p = Product.fromJson({'id': 1, 'name': 'X', 'category': 'OTHER'});

      expect(p.currency, '€');
      expect(p.category, ProductCategory.other);
    });
  });
}
