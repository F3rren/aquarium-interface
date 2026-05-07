//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateInhabitantDTO {
  /// Returns a new [CreateInhabitantDTO] instance.
  CreateInhabitantDTO({
    required this.inhabitantType,
    required this.inhabitantId,
    this.quantity,
    this.notes,
    this.customName,
  });

  CreateInhabitantDTOInhabitantTypeEnum inhabitantType;

  int inhabitantId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? quantity;

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
  String? customName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateInhabitantDTO &&
    other.inhabitantType == inhabitantType &&
    other.inhabitantId == inhabitantId &&
    other.quantity == quantity &&
    other.notes == notes &&
    other.customName == customName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (inhabitantType.hashCode) +
    (inhabitantId.hashCode) +
    (quantity == null ? 0 : quantity!.hashCode) +
    (notes == null ? 0 : notes!.hashCode) +
    (customName == null ? 0 : customName!.hashCode);

  @override
  String toString() => 'CreateInhabitantDTO[inhabitantType=$inhabitantType, inhabitantId=$inhabitantId, quantity=$quantity, notes=$notes, customName=$customName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'inhabitantType'] = this.inhabitantType;
      json[r'inhabitantId'] = this.inhabitantId;
    if (this.quantity != null) {
      json[r'quantity'] = this.quantity;
    } else {
      json[r'quantity'] = null;
    }
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
    }
    if (this.customName != null) {
      json[r'customName'] = this.customName;
    } else {
      json[r'customName'] = null;
    }
    return json;
  }

  /// Returns a new [CreateInhabitantDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateInhabitantDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'inhabitantType'), 'Required key "CreateInhabitantDTO[inhabitantType]" is missing from JSON.');
        assert(json[r'inhabitantType'] != null, 'Required key "CreateInhabitantDTO[inhabitantType]" has a null value in JSON.');
        assert(json.containsKey(r'inhabitantId'), 'Required key "CreateInhabitantDTO[inhabitantId]" is missing from JSON.');
        assert(json[r'inhabitantId'] != null, 'Required key "CreateInhabitantDTO[inhabitantId]" has a null value in JSON.');
        return true;
      }());

      return CreateInhabitantDTO(
        inhabitantType: CreateInhabitantDTOInhabitantTypeEnum.fromJson(json[r'inhabitantType'])!,
        inhabitantId: mapValueOfType<int>(json, r'inhabitantId')!,
        quantity: mapValueOfType<int>(json, r'quantity'),
        notes: mapValueOfType<String>(json, r'notes'),
        customName: mapValueOfType<String>(json, r'customName'),
      );
    }
    return null;
  }

  static List<CreateInhabitantDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateInhabitantDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateInhabitantDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateInhabitantDTO> mapFromJson(dynamic json) {
    final map = <String, CreateInhabitantDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateInhabitantDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateInhabitantDTO-objects as value to a dart map
  static Map<String, List<CreateInhabitantDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateInhabitantDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateInhabitantDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'inhabitantType',
    'inhabitantId',
  };
}


class CreateInhabitantDTOInhabitantTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const CreateInhabitantDTOInhabitantTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const fish = CreateInhabitantDTOInhabitantTypeEnum._(r'fish');
  static const coral = CreateInhabitantDTOInhabitantTypeEnum._(r'coral');

  /// List of all possible values in this [enum][CreateInhabitantDTOInhabitantTypeEnum].
  static const values = <CreateInhabitantDTOInhabitantTypeEnum>[
    fish,
    coral,
  ];

  static CreateInhabitantDTOInhabitantTypeEnum? fromJson(dynamic value) => CreateInhabitantDTOInhabitantTypeEnumTypeTransformer().decode(value);

  static List<CreateInhabitantDTOInhabitantTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateInhabitantDTOInhabitantTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateInhabitantDTOInhabitantTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [CreateInhabitantDTOInhabitantTypeEnum] to String,
/// and [decode] dynamic data back to [CreateInhabitantDTOInhabitantTypeEnum].
class CreateInhabitantDTOInhabitantTypeEnumTypeTransformer {
  factory CreateInhabitantDTOInhabitantTypeEnumTypeTransformer() => _instance ??= const CreateInhabitantDTOInhabitantTypeEnumTypeTransformer._();

  const CreateInhabitantDTOInhabitantTypeEnumTypeTransformer._();

  String encode(CreateInhabitantDTOInhabitantTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a CreateInhabitantDTOInhabitantTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  CreateInhabitantDTOInhabitantTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'fish': return CreateInhabitantDTOInhabitantTypeEnum.fish;
        case r'coral': return CreateInhabitantDTOInhabitantTypeEnum.coral;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [CreateInhabitantDTOInhabitantTypeEnumTypeTransformer] instance.
  static CreateInhabitantDTOInhabitantTypeEnumTypeTransformer? _instance;
}


