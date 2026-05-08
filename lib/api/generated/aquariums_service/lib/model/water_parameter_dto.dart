//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WaterParameterDTO {
  /// Returns a new [WaterParameterDTO] instance.
  WaterParameterDTO({
    this.id,
    this.aquariumId,
    this.temperature,
    this.ph,
    this.salinity,
    this.measuredAt,
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
  DateTime? measuredAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WaterParameterDTO &&
    other.id == id &&
    other.aquariumId == aquariumId &&
    other.temperature == temperature &&
    other.ph == ph &&
    other.salinity == salinity &&
    other.measuredAt == measuredAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (aquariumId == null ? 0 : aquariumId!.hashCode) +
    (temperature == null ? 0 : temperature!.hashCode) +
    (ph == null ? 0 : ph!.hashCode) +
    (salinity == null ? 0 : salinity!.hashCode) +
    (measuredAt == null ? 0 : measuredAt!.hashCode);

  @override
  String toString() => 'WaterParameterDTO[id=$id, aquariumId=$aquariumId, temperature=$temperature, ph=$ph, salinity=$salinity, measuredAt=$measuredAt]';

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
    if (this.measuredAt != null) {
      json[r'measuredAt'] = this.measuredAt!.toUtc().toIso8601String();
    } else {
      json[r'measuredAt'] = null;
    }
    return json;
  }

  /// Returns a new [WaterParameterDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WaterParameterDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return WaterParameterDTO(
        id: mapValueOfType<int>(json, r'id'),
        aquariumId: mapValueOfType<int>(json, r'aquariumId'),
        temperature: mapValueOfType<double>(json, r'temperature'),
        ph: mapValueOfType<double>(json, r'ph'),
        salinity: mapValueOfType<double>(json, r'salinity'),
        measuredAt: mapDateTime(json, r'measuredAt', r''),
      );
    }
    return null;
  }

  static List<WaterParameterDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WaterParameterDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WaterParameterDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WaterParameterDTO> mapFromJson(dynamic json) {
    final map = <String, WaterParameterDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WaterParameterDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WaterParameterDTO-objects as value to a dart map
  static Map<String, List<WaterParameterDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WaterParameterDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WaterParameterDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

