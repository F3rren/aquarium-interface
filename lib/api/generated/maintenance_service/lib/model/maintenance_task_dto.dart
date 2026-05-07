//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MaintenanceTaskDTO {
  /// Returns a new [MaintenanceTaskDTO] instance.
  MaintenanceTaskDTO({
    this.id,
    this.aquariumId,
    this.title,
    this.description,
    this.frequency,
    this.priority,
    this.isCompleted,
    this.dueDate,
    this.completedAt,
    this.createdAt,
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
  String? title;

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
  String? frequency;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? priority;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isCompleted;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? dueDate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? completedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? notes;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MaintenanceTaskDTO &&
    other.id == id &&
    other.aquariumId == aquariumId &&
    other.title == title &&
    other.description == description &&
    other.frequency == frequency &&
    other.priority == priority &&
    other.isCompleted == isCompleted &&
    other.dueDate == dueDate &&
    other.completedAt == completedAt &&
    other.createdAt == createdAt &&
    other.notes == notes;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (aquariumId == null ? 0 : aquariumId!.hashCode) +
    (title == null ? 0 : title!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (frequency == null ? 0 : frequency!.hashCode) +
    (priority == null ? 0 : priority!.hashCode) +
    (isCompleted == null ? 0 : isCompleted!.hashCode) +
    (dueDate == null ? 0 : dueDate!.hashCode) +
    (completedAt == null ? 0 : completedAt!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (notes == null ? 0 : notes!.hashCode);

  @override
  String toString() => 'MaintenanceTaskDTO[id=$id, aquariumId=$aquariumId, title=$title, description=$description, frequency=$frequency, priority=$priority, isCompleted=$isCompleted, dueDate=$dueDate, completedAt=$completedAt, createdAt=$createdAt, notes=$notes]';

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
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.frequency != null) {
      json[r'frequency'] = this.frequency;
    } else {
      json[r'frequency'] = null;
    }
    if (this.priority != null) {
      json[r'priority'] = this.priority;
    } else {
      json[r'priority'] = null;
    }
    if (this.isCompleted != null) {
      json[r'isCompleted'] = this.isCompleted;
    } else {
      json[r'isCompleted'] = null;
    }
    if (this.dueDate != null) {
      json[r'dueDate'] = this.dueDate!.toUtc().toIso8601String();
    } else {
      json[r'dueDate'] = null;
    }
    if (this.completedAt != null) {
      json[r'completedAt'] = this.completedAt!.toUtc().toIso8601String();
    } else {
      json[r'completedAt'] = null;
    }
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'createdAt'] = null;
    }
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
    }
    return json;
  }

  /// Returns a new [MaintenanceTaskDTO] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MaintenanceTaskDTO? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        return true;
      }());

      return MaintenanceTaskDTO(
        id: mapValueOfType<int>(json, r'id'),
        aquariumId: mapValueOfType<int>(json, r'aquariumId'),
        title: mapValueOfType<String>(json, r'title'),
        description: mapValueOfType<String>(json, r'description'),
        frequency: mapValueOfType<String>(json, r'frequency'),
        priority: mapValueOfType<String>(json, r'priority'),
        isCompleted: mapValueOfType<bool>(json, r'isCompleted'),
        dueDate: mapDateTime(json, r'dueDate', r''),
        completedAt: mapDateTime(json, r'completedAt', r''),
        createdAt: mapDateTime(json, r'createdAt', r''),
        notes: mapValueOfType<String>(json, r'notes'),
      );
    }
    return null;
  }

  static List<MaintenanceTaskDTO> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MaintenanceTaskDTO>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MaintenanceTaskDTO.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MaintenanceTaskDTO> mapFromJson(dynamic json) {
    final map = <String, MaintenanceTaskDTO>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MaintenanceTaskDTO.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MaintenanceTaskDTO-objects as value to a dart map
  static Map<String, List<MaintenanceTaskDTO>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MaintenanceTaskDTO>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MaintenanceTaskDTO.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

