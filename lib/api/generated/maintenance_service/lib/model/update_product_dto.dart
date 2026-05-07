//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateProductDTO {
  /// Returns a new [UpdateProductDTO] instance.
  UpdateProductDTO({
    this.name,
    this.category,
    this.brand,
    this.quantity,
    this.unit,
    this.cost,
    this.currency,
    this.purchaseDate,
    this.expiryDate,
    this.notes,
    this.imageUrl,
    this.isFavorite,
    this.usageFrequency,
    this.lastUsed,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  UpdateProductDTOCategoryEnum? category;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? brand;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? quantity;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? unit;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? cost;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? currency;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? purchaseDate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? expiryDate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? notes;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? imageUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isFavorite;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? usageFrequency;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? lastUsed;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UpdateProductDTO &&
    other.name == name &&
    other.category == category &&
    other.brand == brand &&
    other.quantity == quantity &&
    other.unit == unit &&
    other.cost == cost &&
    other.currency == currency &&
    other.purchaseDate == purchaseDate &&
    other.expiryDate == expiryDate &&
    other.notes == notes &&
    other.imageUrl == imageUrl &&
    other.isFavorite == isFavorite &&
    other.usageFrequency == usageFrequency &&
    other.lastUsed == lastUsed;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name == null ? 0 : name!.hashCode) +
    (category == null ? 0 : category!.hashCode) +
    (brand == null ? 0 : brand!.hashCode) +
    (quantity == null ? 0 : quantity!.hashCode) +
    (unit == null ? 0 : unit!.hashCode) +
    (cost == null ? 0 : cost!.hashCode) +
    (currency == null ? 0 : currency!.hashCode) +
    (purchaseDate == null ? 0 : purchaseDate!.hashCode) +
    (expiryDate == null ? 0 : expiryDate!.hashCode) +
    (notes == null ? 0 : notes!.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (isFavorite == null ? 0 : isFavorite!.hashCode) +
    (usageFrequency == null ? 0 : usageFrequency!.hashCode) +
    (lastUsed == null ? 0 : lastUsed!.hashCode);

  @override
  String toString() => 'UpdateProductDTO[name=$name, category=$category, brand=$brand, quantity=$quantity, unit=$unit, cost=$cost, currency=$currency, purchaseDate=$purchaseDate, expiryDate=$expiryDate, notes=$notes, imageUrl=$imageUrl, isFavorite=$isFavorite, usageFrequency=$usageFrequency, lastUsed=$lastUsed]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.category != null) {
      json[r'category'] = this.category;
    } else {
      json[r'category'] = null;
    }
    if (this.brand != null) {
      json[r'brand'] = this.brand;
    } else {
      json[r'brand'] = null;
    }
    if (this.quantity != null) {
      json[r'quantity'] = this.quantity;
    } else {
      json[r'quantity'] = null;
    }
    if (this.unit != null) {
      json[r'unit'] = this.unit;
    } else {
      json[r'unit'] = null;
    }
    if (this.cost != null) {
      json[r'cost'] = this.cost;
    } else {
      json[r'cost'] = null;
    }
    if (this.currency != null) {
      json[r'currency'] = this.currency;
    } else {
      json[r'currency'] = null;
    }
    if (this.purchaseDate != null) {
      json[r'purchaseDate'] = _dateFormatter.format(this.purchaseDate!.toUtc());
    } else {
      json[r'purchaseDate'] = null;
    }
    if (this.expiryDate != null) {
      json[r'expiryDate'] = _dateFormatter.format(this.expiryDate!.toUtc());
    } else {
      json[r'expiryDate'] = null;
    }
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
    }
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
    if (this.isFavorite != null) {
      json[r'isFavorite'] = this.isFavorite;
    } else {
      json[r'isFavorite'] = null;
    }
    if (this.usageFrequency != null) {
      json[r'usageFrequency'] = this.usageFrequency;
    } else {
      json[r'usageFrequency'] = null;
    }
    if (this.lastUsed != null) {
      json[r'lastUsed'] = _dateFormatter.format(this.lastUsed!.toUtc());
    } else {
      json[r'lastUsed'] = null;
    }
    return json;
  }

  /// Returns a new [UpdateProductDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateProductDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return UpdateProductDTO(
        name: mapValueOfType<String>(json, r'name'),
        category: UpdateProductDTOCategoryEnum.fromJson(json[r'category']),
        brand: mapValueOfType<String>(json, r'brand'),
        quantity: mapValueOfType<double>(json, r'quantity'),
        unit: mapValueOfType<String>(json, r'unit'),
        cost: mapValueOfType<double>(json, r'cost'),
        currency: mapValueOfType<String>(json, r'currency'),
        purchaseDate: mapDateTime(json, r'purchaseDate', r''),
        expiryDate: mapDateTime(json, r'expiryDate', r''),
        notes: mapValueOfType<String>(json, r'notes'),
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
        isFavorite: mapValueOfType<bool>(json, r'isFavorite'),
        usageFrequency: mapValueOfType<int>(json, r'usageFrequency'),
        lastUsed: mapDateTime(json, r'lastUsed', r''),
      );
    }
    return null;
  }

  static List<UpdateProductDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateProductDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateProductDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateProductDTO> mapFromJson(dynamic json) {
    final map = <String, UpdateProductDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateProductDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateProductDTO-objects as value to a dart map
  static Map<String, List<UpdateProductDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateProductDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateProductDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class UpdateProductDTOCategoryEnum {
  /// Instantiate a new enum with the provided [value].
  const UpdateProductDTOCategoryEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const BACTERIA = UpdateProductDTOCategoryEnum._(r'BACTERIA');
  static const FOOD = UpdateProductDTOCategoryEnum._(r'FOOD');
  static const TEST = UpdateProductDTOCategoryEnum._(r'TEST');
  static const SUPPLEMENT = UpdateProductDTOCategoryEnum._(r'SUPPLEMENT');
  static const WATER_TREATMENT = UpdateProductDTOCategoryEnum._(r'WATER_TREATMENT');
  static const EQUIPMENT = UpdateProductDTOCategoryEnum._(r'EQUIPMENT');
  static const MEDICINE = UpdateProductDTOCategoryEnum._(r'MEDICINE');
  static const OTHER = UpdateProductDTOCategoryEnum._(r'OTHER');

  /// List of all possible values in this [enum][UpdateProductDTOCategoryEnum].
  static const values = <UpdateProductDTOCategoryEnum>[
    BACTERIA,
    FOOD,
    TEST,
    SUPPLEMENT,
    WATER_TREATMENT,
    EQUIPMENT,
    MEDICINE,
    OTHER,
  ];

  static UpdateProductDTOCategoryEnum? fromJson(dynamic value) => UpdateProductDTOCategoryEnumTypeTransformer().decode(value);

  static List<UpdateProductDTOCategoryEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateProductDTOCategoryEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateProductDTOCategoryEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UpdateProductDTOCategoryEnum] to String,
/// and [decode] dynamic data back to [UpdateProductDTOCategoryEnum].
class UpdateProductDTOCategoryEnumTypeTransformer {
  factory UpdateProductDTOCategoryEnumTypeTransformer() => _instance ??= const UpdateProductDTOCategoryEnumTypeTransformer._();

  const UpdateProductDTOCategoryEnumTypeTransformer._();

  String encode(UpdateProductDTOCategoryEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UpdateProductDTOCategoryEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UpdateProductDTOCategoryEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'BACTERIA': return UpdateProductDTOCategoryEnum.BACTERIA;
        case r'FOOD': return UpdateProductDTOCategoryEnum.FOOD;
        case r'TEST': return UpdateProductDTOCategoryEnum.TEST;
        case r'SUPPLEMENT': return UpdateProductDTOCategoryEnum.SUPPLEMENT;
        case r'WATER_TREATMENT': return UpdateProductDTOCategoryEnum.WATER_TREATMENT;
        case r'EQUIPMENT': return UpdateProductDTOCategoryEnum.EQUIPMENT;
        case r'MEDICINE': return UpdateProductDTOCategoryEnum.MEDICINE;
        case r'OTHER': return UpdateProductDTOCategoryEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UpdateProductDTOCategoryEnumTypeTransformer] instance.
  static UpdateProductDTOCategoryEnumTypeTransformer? _instance;
}


