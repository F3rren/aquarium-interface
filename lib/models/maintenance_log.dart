/// Domain model representing a single maintenance task completion event.
library;

/// Records that a [MaintenanceTask] was completed at a specific point in time.
///
/// Logs are append-only: every time the user marks a task as done, a new
/// [MaintenanceLog] is created rather than mutating the task itself. This
/// provides a full audit trail of maintenance history.
///
/// The [metadata] map is intentionally open-ended: callers may store any
/// task-specific data (e.g. `{'litresChanged': 25}` for a water change, or
/// `{'testKit': 'Salifert', 'ph': 8.2}` for a parameter test).
class MaintenanceLog {
  /// Unique identifier for this log entry.
  final String id;

  /// ID of the [MaintenanceTask] that was completed.
  final String taskId;

  /// UTC timestamp of when the task was marked complete.
  final DateTime completedAt;

  /// Optional free-text notes entered by the user at completion time.
  final String? notes;

  /// Optional task-specific data. Schema varies per task type — consumers
  /// should check for key presence before reading.
  final Map<String, dynamic>? metadata;

  MaintenanceLog({
    required this.id,
    required this.taskId,
    required this.completedAt,
    this.notes,
    this.metadata,
  });

  /// Returns a copy of this log with the specified fields replaced.
  MaintenanceLog copyWith({
    String? id,
    String? taskId,
    DateTime? completedAt,
    String? notes,
    Map<String, dynamic>? metadata,
  }) {
    return MaintenanceLog(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Serialises this log entry to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'completedAt': completedAt.toIso8601String(),
      'notes': notes,
      'metadata': metadata,
    };
  }

  /// Deserialises a [MaintenanceLog] from a JSON map.
  factory MaintenanceLog.fromJson(Map<String, dynamic> json) {
    return MaintenanceLog(
      id: json['id'].toString(),
      taskId: json['taskId'].toString(),
      completedAt: DateTime.parse(json['completedAt']),
      notes: json['notes']?.toString(),
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }
}
