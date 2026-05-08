//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UpdateInhabitantDTO {
  /// Returns a new [UpdateInhabitantDTO] instance.
  UpdateInhabitantDTO({
    this.quantity,
    this.notes,
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
  int? quantity;

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
  bool operator ==(Object other) => identical(this, other) || other is UpdateInhabitantDTO &&
    other.quantity == quantity &&
    other.notes == notes &&
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
    (quantity == null ? 0 : quantity!.hashCode) +
    (notes == null ? 0 : notes!.hashCode) +
    (customName == null ? 0 : customName!.hashCode) +
    (currentSize == null ? 0 : currentSize!.hashCode) +
    (customDifficulty == null ? 0 : customDifficulty!.hashCode) +
    (customTemperament == null ? 0 : customTemperament!.hashCode) +
    (customDiet == null ? 0 : customDiet!.hashCode) +
    (isReefSafe == null ? 0 : isReefSafe!.hashCode) +
    (customMinTankSize == null ? 0 : customMinTankSize!.hashCode);

  @override
  String toString() => 'UpdateInhabitantDTO[quantity=$quantity, notes=$notes, customName=$customName, currentSize=$currentSize, customDifficulty=$customDifficulty, customTemperament=$customTemperament, customDiet=$customDiet, isReefSafe=$isReefSafe, customMinTankSize=$customMinTankSize]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.quantity != null) {
      json[r'quantity'] = this.quantity;
    } else {
      json[r'quantity'] = null;
    }
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
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

  /// Returns a new [UpdateInhabitantDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UpdateInhabitantDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return UpdateInhabitantDTO(
        quantity: mapValueOfType<int>(json, r'quantity'),
        notes: mapValueOfType<String>(json, r'notes'),
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

  static List<UpdateInhabitantDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UpdateInhabitantDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UpdateInhabitantDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UpdateInhabitantDTO> mapFromJson(dynamic json) {
    final map = <String, UpdateInhabitantDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UpdateInhabitantDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UpdateInhabitantDTO-objects as value to a dart map
  static Map<String, List<UpdateInhabitantDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UpdateInhabitantDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UpdateInhabitantDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

