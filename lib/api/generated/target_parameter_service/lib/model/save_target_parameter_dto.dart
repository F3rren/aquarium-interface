//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SaveTargetParameterDTO {
  /// Returns a new [SaveTargetParameterDTO] instance.
  SaveTargetParameterDTO({
    this.temperature,
    this.ph,
    this.salinity,
    this.orp,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? temperature;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? ph;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? salinity;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? orp;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SaveTargetParameterDTO &&
    other.temperature == temperature &&
    other.ph == ph &&
    other.salinity == salinity &&
    other.orp == orp;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (temperature == null ? 0 : temperature!.hashCode) +
    (ph == null ? 0 : ph!.hashCode) +
    (salinity == null ? 0 : salinity!.hashCode) +
    (orp == null ? 0 : orp!.hashCode);

  @override
  String toString() => 'SaveTargetParameterDTO[temperature=$temperature, ph=$ph, salinity=$salinity, orp=$orp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.temperature != null) {
      json[r'temperature'] = this.temperature;
    } else {
      json[r'temperature'] = null;
    }
    if (this.ph != null) {
      json[r'ph'] = this.ph;
    } else {
      json[r'ph'] = null;
    }
    if (this.salinity != null) {
      json[r'salinity'] = this.salinity;
    } else {
      json[r'salinity'] = null;
    }
    if (this.orp != null) {
      json[r'orp'] = this.orp;
    } else {
      json[r'orp'] = null;
    }
    return json;
  }

  /// Returns a new [SaveTargetParameterDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SaveTargetParameterDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return SaveTargetParameterDTO(
        temperature: mapValueOfType<double>(json, r'temperature'),
        ph: mapValueOfType<double>(json, r'ph'),
        salinity: mapValueOfType<double>(json, r'salinity'),
        orp: mapValueOfType<double>(json, r'orp'),
      );
    }
    return null;
  }

  static List<SaveTargetParameterDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SaveTargetParameterDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SaveTargetParameterDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SaveTargetParameterDTO> mapFromJson(dynamic json) {
    final map = <String, SaveTargetParameterDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SaveTargetParameterDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SaveTargetParameterDTO-objects as value to a dart map
  static Map<String, List<SaveTargetParameterDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SaveTargetParameterDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SaveTargetParameterDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

