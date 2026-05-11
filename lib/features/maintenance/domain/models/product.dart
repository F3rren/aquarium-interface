/// Domain model for aquarium products tracked in the user's inventory.
library;

import 'package:maintenance_service/api.dart';

/// Classifies an aquarium product for display, filtering, and backend mapping.
///
/// Backend serialisation uses UPPERCASE strings (e.g. `'WATER_TREATMENT'`);
/// the enum uses camelCase. Conversion is handled by [Product.toJson] and
/// [Product.fromJson].
enum ProductCategory {
  /// Live bacteria cultures and biological additives.
  bacteria,

  /// Fish and coral food.
  food,

  /// Water-quality test kits and reagents.
  test,

  /// Chemical supplements (e.g. calcium, alkalinity, magnesium).
  supplement,

  /// Water conditioners and dechlorinators.
  waterTreatment,

  /// Physical equipment (pumps, lights, heaters, etc.).
  equipment,

  /// Medications and disease treatments.
  medicine,

  /// Products that do not fit the above categories.
  other,
}

/// An aquarium product in the user's inventory.
///
/// Tracks purchase details, stock level, usage frequency, and expiry so the
/// app can surface low-stock and expiry warnings. The [id] is a string to
/// support both integer backend IDs and client-generated UUIDs.
class Product {
  /// Unique identifier. Stored as a string even when the backend sends an int.
  final String id;

  /// Product display name (e.g. `"Seachem Stability"`).
  final String name;

  /// Functional category of the product.
  final ProductCategory category;

  /// Optional manufacturer or brand name.
  final String? brand;

  /// Remaining quantity in the unit specified by [unit].
  final double? quantity;

  /// Unit of measure for [quantity] (e.g. `'ml'`, `'g'`, `'pcs'`).
  final String? unit;

  /// Purchase price.
  final double? cost;

  /// Currency symbol for [cost]. Defaults to `'€'`.
  final String? currency;

  /// Date the product was purchased.
  final DateTime? purchaseDate;

  /// Date after which the product should no longer be used.
  final DateTime? expiryDate;

  /// Optional free-text notes.
  final String? notes;

  /// Optional URL to a product image.
  final String? imageUrl;

  /// Whether the user has starred this product as a favourite.
  final bool isFavorite;

  /// How many days should pass between uses. Used with [lastUsed] to
  /// compute [shouldUseAgain].
  final int? usageFrequency;

  /// Date the product was last used.
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

  /// Creates a [Product] from a generated [ProductDTO].
  factory Product.fromDto(ProductDTO dto) {
    ProductCategory parseCategory(String? raw) {
      switch ((raw ?? '').toUpperCase()) {
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
        default:
          return ProductCategory.other;
      }
    }

    return Product(
      id: dto.id?.toString() ?? '',
      name: dto.name ?? '',
      category: parseCategory(dto.category?.value),
      brand: dto.brand,
      quantity: dto.quantity,
      unit: dto.unit,
      cost: dto.cost,
      currency: dto.currency ?? '€',
      purchaseDate: dto.purchaseDate,
      expiryDate: dto.expiryDate,
      notes: dto.notes,
      imageUrl: dto.imageUrl,
      isFavorite: dto.isFavorite ?? false,
      usageFrequency: dto.usageFrequency,
      lastUsed: dto.lastUsed,
    );
  }

  /// Returns a copy with the specified fields replaced.
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

  /// Serialises to a JSON map for API requests.
  ///
  /// [category] is mapped to the backend UPPERCASE string.
  /// Dates for [purchaseDate], [expiryDate], and [lastUsed] are serialised as
  /// date-only strings (`YYYY-MM-DD`) because the backend does not use time.
  /// [id] is sent as an integer when it parses as one.
  Map<String, dynamic> toJson() {
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
      if (id.isNotEmpty) 'id': int.tryParse(id) ?? id,
      'name': name,
      'category': getCategoryString(category),
      'brand': brand,
      'quantity': quantity,
      'unit': unit,
      'cost': cost,
      'currency': currency,
      'purchaseDate': purchaseDate?.toIso8601String().split('T')[0],
      'expiryDate': expiryDate?.toIso8601String().split('T')[0],
      'notes': notes,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'usageFrequency': usageFrequency,
      'lastUsed': lastUsed?.toIso8601String().split('T')[0],
    };
  }

  /// Deserialises a [Product] from a backend JSON map.
  ///
  /// The backend sends category as an UPPERCASE string; this is mapped back
  /// to the [ProductCategory] enum. [id] is always coerced to [String].
  factory Product.fromJson(Map<String, dynamic> json) {
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
      id: json['id'].toString(),
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

  // ── Computed status helpers ────────────────────────────────────────────────

  /// Returns `true` if [expiryDate] is set and in the past.
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// Returns `true` if the product expires within the next 30 days (but has
  /// not yet expired).
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  /// Returns `true` when [quantity] is below 20 units (hard-coded low-stock
  /// threshold). Returns `false` when [quantity] is `null`.
  bool get isLowStock {
    if (quantity == null) return false;
    return quantity! < 20;
  }

  /// Number of days since the product was last used, or `null` if [lastUsed]
  /// is not set.
  int? get daysSinceLastUse {
    if (lastUsed == null) return null;
    return DateTime.now().difference(lastUsed!).inDays;
  }

  /// Returns `true` when the product's [usageFrequency] has elapsed since
  /// [lastUsed], meaning it is time to use it again.
  bool get shouldUseAgain {
    if (usageFrequency == null || lastUsed == null) return false;
    return daysSinceLastUse! >= usageFrequency!;
  }
}
