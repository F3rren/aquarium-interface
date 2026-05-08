//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CreateAquariumDTO {
  /// Returns a new [CreateAquariumDTO] instance.
  CreateAquariumDTO({
    required this.name,
    this.volume,
    this.type,
    this.description,
    this.imageUrl,
  });

  String name;

  /// Maximum value: 100000
  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? volume;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? type;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? imageUrl;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CreateAquariumDTO &&
    other.name == name &&
    other.volume == volume &&
    other.type == type &&
    other.description == description &&
    other.imageUrl == imageUrl;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name.hashCode) +
    (volume == null ? 0 : volume!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode);

  @override
  String toString() => 'CreateAquariumDTO[name=$name, volume=$volume, type=$type, description=$description, imageUrl=$imageUrl]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'name'] = this.name;
    if (this.volume != null) {
      json[r'volume'] = this.volume;
    } else {
      json[r'volume'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
    return json;
  }

  /// Returns a new [CreateAquariumDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CreateAquariumDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        assert(json.containsKey(r'name'), 'Required key "CreateAquariumDTO[name]" is missing from JSON.');
        assert(json[r'name'] != null, 'Required key "CreateAquariumDTO[name]" has a null value in JSON.');
        return true;
      }());

      return CreateAquariumDTO(
        name: mapValueOfType<String>(json, r'name')!,
        volume: mapValueOfType<int>(json, r'volume'),
        type: mapValueOfType<String>(json, r'type'),
        description: mapValueOfType<String>(json, r'description'),
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
      );
    }
    return null;
  }

  static List<CreateAquariumDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CreateAquariumDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CreateAquariumDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CreateAquariumDTO> mapFromJson(dynamic json) {
    final map = <String, CreateAquariumDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CreateAquariumDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CreateAquariumDTO-objects as value to a dart map
  static Map<String, List<CreateAquariumDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CreateAquariumDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CreateAquariumDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'name',
  };
}

