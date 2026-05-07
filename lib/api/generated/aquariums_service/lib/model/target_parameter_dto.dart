//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class TargetParameterDTO {
  /// Returns a new [TargetParameterDTO] instance.
  TargetParameterDTO({
    this.id,
    this.aquariumId,
    this.temperature,
    this.ph,
    this.salinity,
    this.orp,
    this.calcium,
    this.magnesium,
    this.kh,
    this.nitrate,
    this.phosphate,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? aquariumId;

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

  @override
  bool operator ==(Object other) => identical(this, other) || other is TargetParameterDTO &&
    other.id == id &&
    other.aquariumId == aquariumId &&
    other.temperature == temperature &&
    other.ph == ph &&
    other.salinity == salinity &&
    other.orp == orp &&
    other.calcium == calcium &&
    other.magnesium == magnesium &&
    other.kh == kh &&
    other.nitrate == nitrate &&
    other.phosphate == phosphate;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (aquariumId == null ? 0 : aquariumId!.hashCode) +
    (temperature == null ? 0 : temperature!.hashCode) +
    (ph == null ? 0 : ph!.hashCode) +
    (salinity == null ? 0 : salinity!.hashCode) +
    (orp == null ? 0 : orp!.hashCode) +
    (calcium == null ? 0 : calcium!.hashCode) +
    (magnesium == null ? 0 : magnesium!.hashCode) +
    (kh == null ? 0 : kh!.hashCode) +
    (nitrate == null ? 0 : nitrate!.hashCode) +
    (phosphate == null ? 0 : phosphate!.hashCode);

  @override
  String toString() => 'TargetParameterDTO[id=$id, aquariumId=$aquariumId, temperature=$temperature, ph=$ph, salinity=$salinity, orp=$orp, calcium=$calcium, magnesium=$magnesium, kh=$kh, nitrate=$nitrate, phosphate=$phosphate]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.aquariumId != null) {
      json[r'aquariumId'] = this.aquariumId;
    } else {
      json[r'aquariumId'] = null;
    }
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
    return json;
  }

  /// Returns a new [TargetParameterDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static TargetParameterDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return TargetParameterDTO(
        id: mapValueOfType<int>(json, r'id'),
        aquariumId: mapValueOfType<int>(json, r'aquariumId'),
        temperature: mapValueOfType<double>(json, r'temperature'),
        ph: mapValueOfType<double>(json, r'ph'),
        salinity: mapValueOfType<double>(json, r'salinity'),
        orp: mapValueOfType<double>(json, r'orp'),
        calcium: mapValueOfType<double>(json, r'calcium'),
        magnesium: mapValueOfType<double>(json, r'magnesium'),
        kh: mapValueOfType<double>(json, r'kh'),
        nitrate: mapValueOfType<double>(json, r'nitrate'),
        phosphate: mapValueOfType<double>(json, r'phosphate'),
      );
    }
    return null;
  }

  static List<TargetParameterDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <TargetParameterDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = TargetParameterDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, TargetParameterDTO> mapFromJson(dynamic json) {
    final map = <String, TargetParameterDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = TargetParameterDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of TargetParameterDTO-objects as value to a dart map
  static Map<String, List<TargetParameterDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<TargetParameterDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = TargetParameterDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

