//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateManualParameterDTO {
  /// Returns a new [CreateManualParameterDTO] instance.
  CreateManualParameterDTO({
    this.calcium,
    this.magnesium,
    this.kh,
    this.nitrate,
    this.phosphate,
    this.notes,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? calcium;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? magnesium;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? kh;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? nitrate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? phosphate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? notes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateManualParameterDTO &&
    other.calcium == calcium &&
    other.magnesium == magnesium &&
    other.kh == kh &&
    other.nitrate == nitrate &&
    other.phosphate == phosphate &&
    other.notes == notes;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (calcium == null ? 0 : calcium!.hashCode) +
    (magnesium == null ? 0 : magnesium!.hashCode) +
    (kh == null ? 0 : kh!.hashCode) +
    (nitrate == null ? 0 : nitrate!.hashCode) +
    (phosphate == null ? 0 : phosphate!.hashCode) +
    (notes == null ? 0 : notes!.hashCode);

  @override
  String toString() => 'CreateManualParameterDTO[calcium=$calcium, magnesium=$magnesium, kh=$kh, nitrate=$nitrate, phosphate=$phosphate, notes=$notes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.calcium != null) {
      json[r'calcium'] = this.calcium;
    } else {
      json[r'calcium'] = null;
    }
    if (this.magnesium != null) {
      json[r'magnesium'] = this.magnesium;
    } else {
      json[r'magnesium'] = null;
    }
    if (this.kh != null) {
      json[r'kh'] = this.kh;
    } else {
      json[r'kh'] = null;
    }
    if (this.nitrate != null) {
      json[r'nitrate'] = this.nitrate;
    } else {
      json[r'nitrate'] = null;
    }
    if (this.phosphate != null) {
      json[r'phosphate'] = this.phosphate;
    } else {
      json[r'phosphate'] = null;
    }
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
    }
    return json;
  }

  /// Returns a new [CreateManualParameterDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateManualParameterDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return CreateManualParameterDTO(
        calcium: mapValueOfType<double>(json, r'calcium'),
        magnesium: mapValueOfType<double>(json, r'magnesium'),
        kh: mapValueOfType<double>(json, r'kh'),
        nitrate: mapValueOfType<double>(json, r'nitrate'),
        phosphate: mapValueOfType<double>(json, r'phosphate'),
        notes: mapValueOfType<String>(json, r'notes'),
      );
    }
    return null;
  }

  static List<CreateManualParameterDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateManualParameterDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateManualParameterDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateManualParameterDTO> mapFromJson(dynamic json) {
    final map = <String, CreateManualParameterDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateManualParameterDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateManualParameterDTO-objects as value to a dart map
  static Map<String, List<CreateManualParameterDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateManualParameterDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateManualParameterDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

