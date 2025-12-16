/// Log di completamento di un task di manutenzione
class MaintenanceLog {
  final String id;
  final String taskId; // ID del task completato
  final DateTime completedAt;
  final String? notes; // Note facoltative dell'utente
  final Map<String, dynamic>?
  metadata; // Dati extra (es. litri cambiati, valori test)

  MaintenanceLog({
    required this.id,
    required this.taskId,
    required this.completedAt,
    this.notes,
    this.metadata,
  });

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'completedAt': completedAt.toIso8601String(),
      'notes': notes,
      'metadata': metadata,
    };
  }

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
