enum ProductCategory {
  bacteria,
  food,
  test,
  supplement,
  waterTreatment,
  equipment,
  medicine,
  other,
}

class Product {
  final String id;
  final String name;
  final ProductCategory category;
  final String? brand;
  final double? quantity;
  final String? unit; // ml, g, pcs, etc.
  final double? cost;
  final String? currency;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;
  final String? notes;
  final String? imageUrl;
  final bool isFavorite;
  final int? usageFrequency; // giorni tra un uso e l'altro
  final DateTime? lastUsed;

  Product({
    required this.id,
    required this.name,
    required this.category,
    this.brand,
    this.quantity,
    this.unit,
    this.cost,
    this.currency = '€',
    this.purchaseDate,
    this.expiryDate,
    this.notes,
    this.imageUrl,
    this.isFavorite = false,
    this.usageFrequency,
    this.lastUsed,
  });

  // Copia con modifiche
  Product copyWith({
    String? id,
    String? name,
    ProductCategory? category,
    String? brand,
    double? quantity,
    String? unit,
    double? cost,
    String? currency,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? notes,
    String? imageUrl,
    bool? isFavorite,
    int? usageFrequency,
    DateTime? lastUsed,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      usageFrequency: usageFrequency ?? this.usageFrequency,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  // Serializzazione JSON
  Map<String, dynamic> toJson() {
    // Mappa le enum Dart alle categorie backend (UPPERCASE)
    String getCategoryString(ProductCategory category) {
      switch (category) {
        case ProductCategory.bacteria:
          return 'BACTERIA';
        case ProductCategory.food:
          return 'FOOD';
        case ProductCategory.test:
          return 'TEST';
        case ProductCategory.supplement:
          return 'SUPPLEMENT';
        case ProductCategory.waterTreatment:
          return 'WATER_TREATMENT';
        case ProductCategory.equipment:
          return 'EQUIPMENT';
        case ProductCategory.medicine:
          return 'MEDICINE';
        case ProductCategory.other:
          return 'OTHER';
      }
    }

    return {
      if (id.isNotEmpty) 'id': int.tryParse(id) ?? id, // Manda come int se possibile
      'name': name,
      'category': getCategoryString(category),
      'brand': brand,
      'quantity': quantity,
      'unit': unit,
      'cost': cost,
      'currency': currency,
      'purchaseDate': purchaseDate?.toIso8601String().split('T')[0], // Solo data
      'expiryDate': expiryDate?.toIso8601String().split('T')[0],
      'notes': notes,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'usageFrequency': usageFrequency,
      'lastUsed': lastUsed?.toIso8601String().split('T')[0],
    };
  }

  // Deserializzazione JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    // Mappa le categorie dal backend (UPPERCASE) alle enum Dart
    ProductCategory parseCategory(String categoryString) {
      switch (categoryString.toUpperCase()) {
        case 'BACTERIA':
          return ProductCategory.bacteria;
        case 'FOOD':
          return ProductCategory.food;
        case 'TEST':
          return ProductCategory.test;
        case 'SUPPLEMENT':
          return ProductCategory.supplement;
        case 'WATER_TREATMENT':
          return ProductCategory.waterTreatment;
        case 'EQUIPMENT':
          return ProductCategory.equipment;
        case 'MEDICINE':
          return ProductCategory.medicine;
        case 'OTHER':
        default:
          return ProductCategory.other;
      }
    }

    return Product(
      id: json['id'].toString(), // Converti int a String
      name: json['name'] as String,
      category: json['category'] is String
          ? parseCategory(json['category'] as String)
          : ProductCategory.values[json['category'] as int],
      brand: json['brand'] as String?,
      quantity: json['quantity'] != null
          ? (json['quantity'] as num).toDouble()
          : null,
      unit: json['unit'] as String?,
      cost: json['cost'] != null ? (json['cost'] as num).toDouble() : null,
      currency: json['currency'] as String? ?? '€',
      purchaseDate: json['purchaseDate'] != null
          ? DateTime.parse(json['purchaseDate'] as String)
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'] as String)
          : null,
      notes: json['notes'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
      usageFrequency: json['usageFrequency'] as int?,
      lastUsed: json['lastUsed'] != null
          ? DateTime.parse(json['lastUsed'] as String)
          : null,
    );
  }

  // Helper methods
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  bool get isLowStock {
    if (quantity == null) return false;
    return quantity! < 20; // Soglia personalizzabile
  }

  int? get daysSinceLastUse {
    if (lastUsed == null) return null;
    return DateTime.now().difference(lastUsed!).inDays;
  }

  bool get shouldUseAgain {
    if (usageFrequency == null || lastUsed == null) return false;
    return daysSinceLastUse! >= usageFrequency!;
  }
}
