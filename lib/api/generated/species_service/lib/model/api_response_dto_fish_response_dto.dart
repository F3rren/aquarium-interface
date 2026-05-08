//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ApiResponseDTOFishResponseDTO {
  /// Returns a new [ApiResponseDTOFishResponseDTO] instance.
  ApiResponseDTOFishResponseDTO({
    this.success,
    this.message,
    this.data,
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

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  FishResponseDTO? data;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? metadata;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ApiResponseDTOFishResponseDTO &&
    other.success == success &&
    other.message == message &&
    other.data == data &&
    other.metadata == metadata;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (success == null ? 0 : success!.hashCode) +
    (message == null ? 0 : message!.hashCode) +
    (data == null ? 0 : data!.hashCode) +
    (metadata == null ? 0 : metadata!.hashCode);

  @override
  String toString() => 'ApiResponseDTOFishResponseDTO[success=$success, message=$message, data=$data, metadata=$metadata]';

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
    if (this.data != null) {
      json[r'data'] = this.data;
    } else {
      json[r'data'] = null;
    }
    if (this.metadata != null) {
      json[r'metadata'] = this.metadata;
    } else {
      json[r'metadata'] = null;
    }
    return json;
  }

  /// Returns a new [ApiResponseDTOFishResponseDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ApiResponseDTOFishResponseDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return ApiResponseDTOFishResponseDTO(
        success: mapValueOfType<bool>(json, r'success'),
        message: mapValueOfType<String>(json, r'message'),
        data: FishResponseDTO.fromJson(json[r'data']),
        metadata: mapValueOfType<Object>(json, r'metadata'),
      );
    }
    return null;
  }

  static List<ApiResponseDTOFishResponseDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ApiResponseDTOFishResponseDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ApiResponseDTOFishResponseDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ApiResponseDTOFishResponseDTO> mapFromJson(dynamic json) {
    final map = <String, ApiResponseDTOFishResponseDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ApiResponseDTOFishResponseDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ApiResponseDTOFishResponseDTO-objects as value to a dart map
  static Map<String, List<ApiResponseDTOFishResponseDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ApiResponseDTOFishResponseDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ApiResponseDTOFishResponseDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

