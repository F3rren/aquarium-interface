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
    return {
      'id': id,
      'name': name,
      'category': category.index,
      'brand': brand,
      'quantity': quantity,
      'unit': unit,
      'cost': cost,
      'currency': currency,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'expiryDate': expiryDate?.toIso8601String(),
      'notes': notes,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'usageFrequency': usageFrequency,
      'lastUsed': lastUsed?.toIso8601String(),
    };
  }

  // Deserializzazione JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      category: ProductCategory.values[json['category'] as int],
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
