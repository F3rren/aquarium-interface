//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class InhabitantDetailsDTO {
  /// Returns a new [InhabitantDetailsDTO] instance.
  InhabitantDetailsDTO({
    this.id,
    this.type,
    this.commonName,
    this.scientificName,
    this.quantity,
    this.addedDate,
    this.notes,
    this.details,
    this.customName,
    this.currentSize,
    this.customDifficulty,
    this.customTemperament,
    this.customDiet,
    this.isReefSafe,
    this.customMinTankSize,
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
  String? type;

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
  int? quantity;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? addedDate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? notes;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Object? details;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? customName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? currentSize;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? customDifficulty;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? customTemperament;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? customDiet;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isReefSafe;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? customMinTankSize;

  @override
  bool operator ==(Object other) => identical(this, other) || other is InhabitantDetailsDTO &&
    other.id == id &&
    other.type == type &&
    other.commonName == commonName &&
    other.scientificName == scientificName &&
    other.quantity == quantity &&
    other.addedDate == addedDate &&
    other.notes == notes &&
    other.details == details &&
    other.customName == customName &&
    other.currentSize == currentSize &&
    other.customDifficulty == customDifficulty &&
    other.customTemperament == customTemperament &&
    other.customDiet == customDiet &&
    other.isReefSafe == isReefSafe &&
    other.customMinTankSize == customMinTankSize;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (commonName == null ? 0 : commonName!.hashCode) +
    (scientificName == null ? 0 : scientificName!.hashCode) +
    (quantity == null ? 0 : quantity!.hashCode) +
    (addedDate == null ? 0 : addedDate!.hashCode) +
    (notes == null ? 0 : notes!.hashCode) +
    (details == null ? 0 : details!.hashCode) +
    (customName == null ? 0 : customName!.hashCode) +
    (currentSize == null ? 0 : currentSize!.hashCode) +
    (customDifficulty == null ? 0 : customDifficulty!.hashCode) +
    (customTemperament == null ? 0 : customTemperament!.hashCode) +
    (customDiet == null ? 0 : customDiet!.hashCode) +
    (isReefSafe == null ? 0 : isReefSafe!.hashCode) +
    (customMinTankSize == null ? 0 : customMinTankSize!.hashCode);

  @override
  String toString() => 'InhabitantDetailsDTO[id=$id, type=$type, commonName=$commonName, scientificName=$scientificName, quantity=$quantity, addedDate=$addedDate, notes=$notes, details=$details, customName=$customName, currentSize=$currentSize, customDifficulty=$customDifficulty, customTemperament=$customTemperament, customDiet=$customDiet, isReefSafe=$isReefSafe, customMinTankSize=$customMinTankSize]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
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
    if (this.quantity != null) {
      json[r'quantity'] = this.quantity;
    } else {
      json[r'quantity'] = null;
    }
    if (this.addedDate != null) {
      json[r'addedDate'] = this.addedDate!.toUtc().toIso8601String();
    } else {
      json[r'addedDate'] = null;
    }
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
    }
    if (this.details != null) {
      json[r'details'] = this.details;
    } else {
      json[r'details'] = null;
    }
    if (this.customName != null) {
      json[r'customName'] = this.customName;
    } else {
      json[r'customName'] = null;
    }
    if (this.currentSize != null) {
      json[r'currentSize'] = this.currentSize;
    } else {
      json[r'currentSize'] = null;
    }
    if (this.customDifficulty != null) {
      json[r'customDifficulty'] = this.customDifficulty;
    } else {
      json[r'customDifficulty'] = null;
    }
    if (this.customTemperament != null) {
      json[r'customTemperament'] = this.customTemperament;
    } else {
      json[r'customTemperament'] = null;
    }
    if (this.customDiet != null) {
      json[r'customDiet'] = this.customDiet;
    } else {
      json[r'customDiet'] = null;
    }
    if (this.isReefSafe != null) {
      json[r'isReefSafe'] = this.isReefSafe;
    } else {
      json[r'isReefSafe'] = null;
    }
    if (this.customMinTankSize != null) {
      json[r'customMinTankSize'] = this.customMinTankSize;
    } else {
      json[r'customMinTankSize'] = null;
    }
    return json;
  }

  /// Returns a new [InhabitantDetailsDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static InhabitantDetailsDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return InhabitantDetailsDTO(
        id: mapValueOfType<int>(json, r'id'),
        type: mapValueOfType<String>(json, r'type'),
        commonName: mapValueOfType<String>(json, r'commonName'),
        scientificName: mapValueOfType<String>(json, r'scientificName'),
        quantity: mapValueOfType<int>(json, r'quantity'),
        addedDate: mapDateTime(json, r'addedDate', r''),
        notes: mapValueOfType<String>(json, r'notes'),
        details: mapValueOfType<Object>(json, r'details'),
        customName: mapValueOfType<String>(json, r'customName'),
        currentSize: mapValueOfType<int>(json, r'currentSize'),
        customDifficulty: mapValueOfType<String>(json, r'customDifficulty'),
        customTemperament: mapValueOfType<String>(json, r'customTemperament'),
        customDiet: mapValueOfType<String>(json, r'customDiet'),
        isReefSafe: mapValueOfType<bool>(json, r'isReefSafe'),
        customMinTankSize: mapValueOfType<int>(json, r'customMinTankSize'),
      );
    }
    return null;
  }

  static List<InhabitantDetailsDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <InhabitantDetailsDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = InhabitantDetailsDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, InhabitantDetailsDTO> mapFromJson(dynamic json) {
    final map = <String, InhabitantDetailsDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = InhabitantDetailsDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of InhabitantDetailsDTO-objects as value to a dart map
  static Map<String, List<InhabitantDetailsDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<InhabitantDetailsDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = InhabitantDetailsDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

