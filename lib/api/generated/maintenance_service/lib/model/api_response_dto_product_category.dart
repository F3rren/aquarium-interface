//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ApiResponseDTOProductCategory {
  /// Returns a new [ApiResponseDTOProductCategory] instance.
  ApiResponseDTOProductCategory({
    this.success,
    this.message,
    this.data = const [],
    this.metadata,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? success;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? message;

  List<ApiResponseDTOProductCategoryDataEnum> data;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? metadata;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiResponseDTOProductCategory &&
    other.success == success &&
    other.message == message &&
    _deepEquality.equals(other.data, data) &&
    other.metadata == metadata;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (success == null ? 0 : success!.hashCode) +
    (message == null ? 0 : message!.hashCode) +
    (data.hashCode) +
    (metadata == null ? 0 : metadata!.hashCode);

  @override
  String toString() => 'ApiResponseDTOProductCategory[success=$success, message=$message, data=$data, metadata=$metadata]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.success != null) {
      json[r'success'] = this.success;
    } else {
      json[r'success'] = null;
    }
    if (this.message != null) {
      json[r'message'] = this.message;
    } else {
      json[r'message'] = null;
    }
      json[r'data'] = this.data;
    if (this.metadata != null) {
      json[r'metadata'] = this.metadata;
    } else {
      json[r'metadata'] = null;
    }
    return json;
  }

  /// Returns a new [ApiResponseDTOProductCategory] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApiResponseDTOProductCategory? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return ApiResponseDTOProductCategory(
        success: mapValueOfType<bool>(json, r'success'),
        message: mapValueOfType<String>(json, r'message'),
        data: ApiResponseDTOProductCategoryDataEnum.listFromJson(json[r'data']),
        metadata: mapValueOfType<Object>(json, r'metadata'),
      );
    }
    return null;
  }

  static List<ApiResponseDTOProductCategory> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiResponseDTOProductCategory>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiResponseDTOProductCategory.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApiResponseDTOProductCategory> mapFromJson(dynamic json) {
    final map = <String, ApiResponseDTOProductCategory>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApiResponseDTOProductCategory.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApiResponseDTOProductCategory-objects as value to a dart map
  static Map<String, List<ApiResponseDTOProductCategory>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApiResponseDTOProductCategory>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApiResponseDTOProductCategory.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class ApiResponseDTOProductCategoryDataEnum {
  /// Instantiate a new enum with the provided [value].
  const ApiResponseDTOProductCategoryDataEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const BACTERIA = ApiResponseDTOProductCategoryDataEnum._(r'BACTERIA');
  static const FOOD = ApiResponseDTOProductCategoryDataEnum._(r'FOOD');
  static const TEST = ApiResponseDTOProductCategoryDataEnum._(r'TEST');
  static const SUPPLEMENT = ApiResponseDTOProductCategoryDataEnum._(r'SUPPLEMENT');
  static const WATER_TREATMENT = ApiResponseDTOProductCategoryDataEnum._(r'WATER_TREATMENT');
  static const EQUIPMENT = ApiResponseDTOProductCategoryDataEnum._(r'EQUIPMENT');
  static const MEDICINE = ApiResponseDTOProductCategoryDataEnum._(r'MEDICINE');
  static const OTHER = ApiResponseDTOProductCategoryDataEnum._(r'OTHER');

  /// List of all possible values in this [enum][ApiResponseDTOProductCategoryDataEnum].
  static const values = <ApiResponseDTOProductCategoryDataEnum>[
    BACTERIA,
    FOOD,
    TEST,
    SUPPLEMENT,
    WATER_TREATMENT,
    EQUIPMENT,
    MEDICINE,
    OTHER,
  ];

  static ApiResponseDTOProductCategoryDataEnum? fromJson(dynamic value) => ApiResponseDTOProductCategoryDataEnumTypeTransformer().decode(value);

  static List<ApiResponseDTOProductCategoryDataEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiResponseDTOProductCategoryDataEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiResponseDTOProductCategoryDataEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ApiResponseDTOProductCategoryDataEnum] to String,
/// and [decode] dynamic data back to [ApiResponseDTOProductCategoryDataEnum].
class ApiResponseDTOProductCategoryDataEnumTypeTransformer {
  factory ApiResponseDTOProductCategoryDataEnumTypeTransformer() => _instance ??= const ApiResponseDTOProductCategoryDataEnumTypeTransformer._();

  const ApiResponseDTOProductCategoryDataEnumTypeTransformer._();

  String encode(ApiResponseDTOProductCategoryDataEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ApiResponseDTOProductCategoryDataEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ApiResponseDTOProductCategoryDataEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'BACTERIA': return ApiResponseDTOProductCategoryDataEnum.BACTERIA;
        case r'FOOD': return ApiResponseDTOProductCategoryDataEnum.FOOD;
        case r'TEST': return ApiResponseDTOProductCategoryDataEnum.TEST;
        case r'SUPPLEMENT': return ApiResponseDTOProductCategoryDataEnum.SUPPLEMENT;
        case r'WATER_TREATMENT': return ApiResponseDTOProductCategoryDataEnum.WATER_TREATMENT;
        case r'EQUIPMENT': return ApiResponseDTOProductCategoryDataEnum.EQUIPMENT;
        case r'MEDICINE': return ApiResponseDTOProductCategoryDataEnum.MEDICINE;
        case r'OTHER': return ApiResponseDTOProductCategoryDataEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ApiResponseDTOProductCategoryDataEnumTypeTransformer] instance.
  static ApiResponseDTOProductCategoryDataEnumTypeTransformer? _instance;
}


