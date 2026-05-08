//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ManualParameterDTO {
  /// Returns a new [ManualParameterDTO] instance.
  ManualParameterDTO({
    this.id,
    this.aquariumId,
    this.calcium,
    this.magnesium,
    this.kh,
    this.nitrate,
    this.phosphate,
    this.measuredAt,
    this.notes,
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
  DateTime? measuredAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? notes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ManualParameterDTO &&
    other.id == id &&
    other.aquariumId == aquariumId &&
    other.calcium == calcium &&
    other.magnesium == magnesium &&
    other.kh == kh &&
    other.nitrate == nitrate &&
    other.phosphate == phosphate &&
    other.measuredAt == measuredAt &&
    other.notes == notes;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (aquariumId == null ? 0 : aquariumId!.hashCode) +
    (calcium == null ? 0 : calcium!.hashCode) +
    (magnesium == null ? 0 : magnesium!.hashCode) +
    (kh == null ? 0 : kh!.hashCode) +
    (nitrate == null ? 0 : nitrate!.hashCode) +
    (phosphate == null ? 0 : phosphate!.hashCode) +
    (measuredAt == null ? 0 : measuredAt!.hashCode) +
    (notes == null ? 0 : notes!.hashCode);

  @override
  String toString() => 'ManualParameterDTO[id=$id, aquariumId=$aquariumId, calcium=$calcium, magnesium=$magnesium, kh=$kh, nitrate=$nitrate, phosphate=$phosphate, measuredAt=$measuredAt, notes=$notes]';

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
    if (this.measuredAt != null) {
      json[r'measuredAt'] = this.measuredAt!.toUtc().toIso8601String();
    } else {
      json[r'measuredAt'] = null;
    }
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
    }
    return json;
  }

  /// Returns a new [ManualParameterDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ManualParameterDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return ManualParameterDTO(
        id: mapValueOfType<int>(json, r'id'),
        aquariumId: mapValueOfType<int>(json, r'aquariumId'),
        calcium: mapValueOfType<double>(json, r'calcium'),
        magnesium: mapValueOfType<double>(json, r'magnesium'),
        kh: mapValueOfType<double>(json, r'kh'),
        nitrate: mapValueOfType<double>(json, r'nitrate'),
        phosphate: mapValueOfType<double>(json, r'phosphate'),
        measuredAt: mapDateTime(json, r'measuredAt', r''),
        notes: mapValueOfType<String>(json, r'notes'),
      );
    }
    return null;
  }

  static List<ManualParameterDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ManualParameterDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ManualParameterDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ManualParameterDTO> mapFromJson(dynamic json) {
    final map = <String, ManualParameterDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ManualParameterDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ManualParameterDTO-objects as value to a dart map
  static Map<String, List<ManualParameterDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ManualParameterDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ManualParameterDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

