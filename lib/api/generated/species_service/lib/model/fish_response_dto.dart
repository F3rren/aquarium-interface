//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FishResponseDTO {
  /// Returns a new [FishResponseDTO] instance.
  FishResponseDTO({
    this.id,
    this.commonName,
    this.scientificName,
    this.family,
    this.minTankSize,
    this.maxSize,
    this.difficulty,
    this.reefSafe,
    this.temperament,
    this.diet,
    this.imageUrl,
    this.description,
    this.waterType,
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
  String? family;

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
  bool? reefSafe;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? temperament;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? diet;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? imageUrl;

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
  String? waterType;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FishResponseDTO &&
    other.id == id &&
    other.commonName == commonName &&
    other.scientificName == scientificName &&
    other.family == family &&
    other.minTankSize == minTankSize &&
    other.maxSize == maxSize &&
    other.difficulty == difficulty &&
    other.reefSafe == reefSafe &&
    other.temperament == temperament &&
    other.diet == diet &&
    other.imageUrl == imageUrl &&
    other.description == description &&
    other.waterType == waterType;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (commonName == null ? 0 : commonName!.hashCode) +
    (scientificName == null ? 0 : scientificName!.hashCode) +
    (family == null ? 0 : family!.hashCode) +
    (minTankSize == null ? 0 : minTankSize!.hashCode) +
    (maxSize == null ? 0 : maxSize!.hashCode) +
    (difficulty == null ? 0 : difficulty!.hashCode) +
    (reefSafe == null ? 0 : reefSafe!.hashCode) +
    (temperament == null ? 0 : temperament!.hashCode) +
    (diet == null ? 0 : diet!.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (waterType == null ? 0 : waterType!.hashCode);

  @override
  String toString() => 'FishResponseDTO[id=$id, commonName=$commonName, scientificName=$scientificName, family=$family, minTankSize=$minTankSize, maxSize=$maxSize, difficulty=$difficulty, reefSafe=$reefSafe, temperament=$temperament, diet=$diet, imageUrl=$imageUrl, description=$description, waterType=$waterType]';

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
    if (this.family != null) {
      json[r'family'] = this.family;
    } else {
      json[r'family'] = null;
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
    if (this.reefSafe != null) {
      json[r'reefSafe'] = this.reefSafe;
    } else {
      json[r'reefSafe'] = null;
    }
    if (this.temperament != null) {
      json[r'temperament'] = this.temperament;
    } else {
      json[r'temperament'] = null;
    }
    if (this.diet != null) {
      json[r'diet'] = this.diet;
    } else {
      json[r'diet'] = null;
    }
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.waterType != null) {
      json[r'waterType'] = this.waterType;
    } else {
      json[r'waterType'] = null;
    }
    return json;
  }

  /// Returns a new [FishResponseDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FishResponseDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return FishResponseDTO(
        id: mapValueOfType<int>(json, r'id'),
        commonName: mapValueOfType<String>(json, r'commonName'),
        scientificName: mapValueOfType<String>(json, r'scientificName'),
        family: mapValueOfType<String>(json, r'family'),
        minTankSize: mapValueOfType<int>(json, r'minTankSize'),
        maxSize: mapValueOfType<int>(json, r'maxSize'),
        difficulty: mapValueOfType<String>(json, r'difficulty'),
        reefSafe: mapValueOfType<bool>(json, r'reefSafe'),
        temperament: mapValueOfType<String>(json, r'temperament'),
        diet: mapValueOfType<String>(json, r'diet'),
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
        description: mapValueOfType<String>(json, r'description'),
        waterType: mapValueOfType<String>(json, r'waterType'),
      );
    }
    return null;
  }

  static List<FishResponseDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FishResponseDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FishResponseDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FishResponseDTO> mapFromJson(dynamic json) {
    final map = <String, FishResponseDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FishResponseDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FishResponseDTO-objects as value to a dart map
  static Map<String, List<FishResponseDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FishResponseDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FishResponseDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

