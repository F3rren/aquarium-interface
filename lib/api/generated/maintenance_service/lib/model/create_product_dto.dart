//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateProductDTO {
  /// Returns a new [CreateProductDTO] instance.
  CreateProductDTO({
    required this.name,
    required this.category,
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
  });

  String name;

  CreateProductDTOCategoryEnum category;

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

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateProductDTO &&
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
    other.usageFrequency == usageFrequency;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (category.hashCode) +
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
    (usageFrequency == null ? 0 : usageFrequency!.hashCode);

  @override
  String toString() => 'CreateProductDTO[name=$name, category=$category, brand=$brand, quantity=$quantity, unit=$unit, cost=$cost, currency=$currency, purchaseDate=$purchaseDate, expiryDate=$expiryDate, notes=$notes, imageUrl=$imageUrl, isFavorite=$isFavorite, usageFrequency=$usageFrequency]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
      json[r'category'] = this.category;
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
    return json;
  }

  /// Returns a new [CreateProductDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateProductDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "CreateProductDTO[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "CreateProductDTO[name]" has a null value in JSON.');
        assert(json.containsKey(r'category'), 'Required key "CreateProductDTO[category]" is missing from JSON.');
        assert(json[r'category'] != null, 'Required key "CreateProductDTO[category]" has a null value in JSON.');
        return true;
      }());

      return CreateProductDTO(
        name: mapValueOfType<String>(json, r'name')!,
        category: CreateProductDTOCategoryEnum.fromJson(json[r'category'])!,
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
      );
    }
    return null;
  }

  static List<CreateProductDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateProductDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateProductDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateProductDTO> mapFromJson(dynamic json) {
    final map = <String, CreateProductDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateProductDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateProductDTO-objects as value to a dart map
  static Map<String, List<CreateProductDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateProductDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateProductDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
    'category',
  };
}


class CreateProductDTOCategoryEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateProductDTOCategoryEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const BACTERIA = CreateProductDTOCategoryEnum._(r'BACTERIA');
  static const FOOD = CreateProductDTOCategoryEnum._(r'FOOD');
  static const TEST = CreateProductDTOCategoryEnum._(r'TEST');
  static const SUPPLEMENT = CreateProductDTOCategoryEnum._(r'SUPPLEMENT');
  static const WATER_TREATMENT = CreateProductDTOCategoryEnum._(r'WATER_TREATMENT');
  static const EQUIPMENT = CreateProductDTOCategoryEnum._(r'EQUIPMENT');
  static const MEDICINE = CreateProductDTOCategoryEnum._(r'MEDICINE');
  static const OTHER = CreateProductDTOCategoryEnum._(r'OTHER');

  /// List of all possible values in this [enum][CreateProductDTOCategoryEnum].
  static const values = <CreateProductDTOCategoryEnum>[
    BACTERIA,
    FOOD,
    TEST,
    SUPPLEMENT,
    WATER_TREATMENT,
    EQUIPMENT,
    MEDICINE,
    OTHER,
  ];

  static CreateProductDTOCategoryEnum? fromJson(dynamic value) => CreateProductDTOCategoryEnumTypeTransformer().decode(value);

  static List<CreateProductDTOCategoryEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateProductDTOCategoryEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateProductDTOCategoryEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateProductDTOCategoryEnum] to String,
/// and [decode] dynamic data back to [CreateProductDTOCategoryEnum].
class CreateProductDTOCategoryEnumTypeTransformer {
  factory CreateProductDTOCategoryEnumTypeTransformer() => _instance ??= const CreateProductDTOCategoryEnumTypeTransformer._();

  const CreateProductDTOCategoryEnumTypeTransformer._();

  String encode(CreateProductDTOCategoryEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateProductDTOCategoryEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateProductDTOCategoryEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'BACTERIA': return CreateProductDTOCategoryEnum.BACTERIA;
        case r'FOOD': return CreateProductDTOCategoryEnum.FOOD;
        case r'TEST': return CreateProductDTOCategoryEnum.TEST;
        case r'SUPPLEMENT': return CreateProductDTOCategoryEnum.SUPPLEMENT;
        case r'WATER_TREATMENT': return CreateProductDTOCategoryEnum.WATER_TREATMENT;
        case r'EQUIPMENT': return CreateProductDTOCategoryEnum.EQUIPMENT;
        case r'MEDICINE': return CreateProductDTOCategoryEnum.MEDICINE;
        case r'OTHER': return CreateProductDTOCategoryEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateProductDTOCategoryEnumTypeTransformer] instance.
  static CreateProductDTOCategoryEnumTypeTransformer? _instance;
}


