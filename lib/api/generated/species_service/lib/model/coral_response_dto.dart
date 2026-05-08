//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class CoralResponseDTO {
  /// Returns a new [CoralResponseDTO] instance.
  CoralResponseDTO({
    this.id,
    this.commonName,
    this.scientificName,
    this.type,
    this.minTankSize,
    this.maxSize,
    this.difficulty,
    this.lightRequirement,
    this.flowRequirement,
    this.placement,
    this.aggressive,
    this.feeding,
    this.description,
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
  String? commonName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? scientificName;

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
  int? minTankSize;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? maxSize;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? difficulty;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? lightRequirement;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? flowRequirement;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? placement;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? aggressive;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? feeding;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  @override
  bool operator ==(Object other) => identical(this, other) || other is CoralResponseDTO &&
    other.id == id &&
    other.commonName == commonName &&
    other.scientificName == scientificName &&
    other.type == type &&
    other.minTankSize == minTankSize &&
    other.maxSize == maxSize &&
    other.difficulty == difficulty &&
    other.lightRequirement == lightRequirement &&
    other.flowRequirement == flowRequirement &&
    other.placement == placement &&
    other.aggressive == aggressive &&
    other.feeding == feeding &&
    other.description == description;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (commonName == null ? 0 : commonName!.hashCode) +
    (scientificName == null ? 0 : scientificName!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (minTankSize == null ? 0 : minTankSize!.hashCode) +
    (maxSize == null ? 0 : maxSize!.hashCode) +
    (difficulty == null ? 0 : difficulty!.hashCode) +
    (lightRequirement == null ? 0 : lightRequirement!.hashCode) +
    (flowRequirement == null ? 0 : flowRequirement!.hashCode) +
    (placement == null ? 0 : placement!.hashCode) +
    (aggressive == null ? 0 : aggressive!.hashCode) +
    (feeding == null ? 0 : feeding!.hashCode) +
    (description == null ? 0 : description!.hashCode);

  @override
  String toString() => 'CoralResponseDTO[id=$id, commonName=$commonName, scientificName=$scientificName, type=$type, minTankSize=$minTankSize, maxSize=$maxSize, difficulty=$difficulty, lightRequirement=$lightRequirement, flowRequirement=$flowRequirement, placement=$placement, aggressive=$aggressive, feeding=$feeding, description=$description]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.commonName != null) {
      json[r'commonName'] = this.commonName;
    } else {
      json[r'commonName'] = null;
    }
    if (this.scientificName != null) {
      json[r'scientificName'] = this.scientificName;
    } else {
      json[r'scientificName'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    if (this.minTankSize != null) {
      json[r'minTankSize'] = this.minTankSize;
    } else {
      json[r'minTankSize'] = null;
    }
    if (this.maxSize != null) {
      json[r'maxSize'] = this.maxSize;
    } else {
      json[r'maxSize'] = null;
    }
    if (this.difficulty != null) {
      json[r'difficulty'] = this.difficulty;
    } else {
      json[r'difficulty'] = null;
    }
    if (this.lightRequirement != null) {
      json[r'lightRequirement'] = this.lightRequirement;
    } else {
      json[r'lightRequirement'] = null;
    }
    if (this.flowRequirement != null) {
      json[r'flowRequirement'] = this.flowRequirement;
    } else {
      json[r'flowRequirement'] = null;
    }
    if (this.placement != null) {
      json[r'placement'] = this.placement;
    } else {
      json[r'placement'] = null;
    }
    if (this.aggressive != null) {
      json[r'aggressive'] = this.aggressive;
    } else {
      json[r'aggressive'] = null;
    }
    if (this.feeding != null) {
      json[r'feeding'] = this.feeding;
    } else {
      json[r'feeding'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    return json;
  }

  /// Returns a new [CoralResponseDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static CoralResponseDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return CoralResponseDTO(
        id: mapValueOfType<int>(json, r'id'),
        commonName: mapValueOfType<String>(json, r'commonName'),
        scientificName: mapValueOfType<String>(json, r'scientificName'),
        type: mapValueOfType<String>(json, r'type'),
        minTankSize: mapValueOfType<int>(json, r'minTankSize'),
        maxSize: mapValueOfType<int>(json, r'maxSize'),
        difficulty: mapValueOfType<String>(json, r'difficulty'),
        lightRequirement: mapValueOfType<String>(json, r'lightRequirement'),
        flowRequirement: mapValueOfType<String>(json, r'flowRequirement'),
        placement: mapValueOfType<String>(json, r'placement'),
        aggressive: mapValueOfType<bool>(json, r'aggressive'),
        feeding: mapValueOfType<String>(json, r'feeding'),
        description: mapValueOfType<String>(json, r'description'),
      );
    }
    return null;
  }

  static List<CoralResponseDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <CoralResponseDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = CoralResponseDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, CoralResponseDTO> mapFromJson(dynamic json) {
    final map = <String, CoralResponseDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = CoralResponseDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of CoralResponseDTO-objects as value to a dart map
  static Map<String, List<CoralResponseDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<CoralResponseDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = CoralResponseDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

