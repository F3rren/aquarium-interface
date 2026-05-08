//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateParameterDTO {
  /// Returns a new [CreateParameterDTO] instance.
  CreateParameterDTO({
    required this.temperature,
    required this.ph,
    required this.salinity,
    required this.orp,
  });

  double temperature;

  double ph;

  int salinity;

  int orp;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateParameterDTO &&
    other.temperature == temperature &&
    other.ph == ph &&
    other.salinity == salinity &&
    other.orp == orp;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (temperature.hashCode) +
    (ph.hashCode) +
    (salinity.hashCode) +
    (orp.hashCode);

  @override
  String toString() => 'CreateParameterDTO[temperature=$temperature, ph=$ph, salinity=$salinity, orp=$orp]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'temperature'] = this.temperature;
      json[r'ph'] = this.ph;
      json[r'salinity'] = this.salinity;
      json[r'orp'] = this.orp;
    return json;
  }

  /// Returns a new [CreateParameterDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateParameterDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'temperature'), 'Required key "CreateParameterDTO[temperature]" is missing from JSON.');
        assert(json[r'temperature'] != null, 'Required key "CreateParameterDTO[temperature]" has a null value in JSON.');
        assert(json.containsKey(r'ph'), 'Required key "CreateParameterDTO[ph]" is missing from JSON.');
        assert(json[r'ph'] != null, 'Required key "CreateParameterDTO[ph]" has a null value in JSON.');
        assert(json.containsKey(r'salinity'), 'Required key "CreateParameterDTO[salinity]" is missing from JSON.');
        assert(json[r'salinity'] != null, 'Required key "CreateParameterDTO[salinity]" has a null value in JSON.');
        assert(json.containsKey(r'orp'), 'Required key "CreateParameterDTO[orp]" is missing from JSON.');
        assert(json[r'orp'] != null, 'Required key "CreateParameterDTO[orp]" has a null value in JSON.');
        return true;
      }());

      return CreateParameterDTO(
        temperature: mapValueOfType<double>(json, r'temperature')!,
        ph: mapValueOfType<double>(json, r'ph')!,
        salinity: mapValueOfType<int>(json, r'salinity')!,
        orp: mapValueOfType<int>(json, r'orp')!,
      );
    }
    return null;
  }

  static List<CreateParameterDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateParameterDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateParameterDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateParameterDTO> mapFromJson(dynamic json) {
    final map = <String, CreateParameterDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateParameterDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateParameterDTO-objects as value to a dart map
  static Map<String, List<CreateParameterDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateParameterDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateParameterDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'temperature',
    'ph',
    'salinity',
    'orp',
  };
}

