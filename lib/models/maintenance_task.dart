/// Task di manutenzione ricorrente
class MaintenanceTask {
  final String id;
  final String aquariumId; // ID della vasca associata
  final String title;
  final String? description;
  final MaintenanceCategory category;
  final int frequencyDays; // Ogni quanti giorni si ripete (retrocompatibilità)
  final String?
  frequency; // Frequenza come string (daily, weekly, monthly, custom)
  final String? priority; // Priorità (low, medium, high)
  final DateTime? dueDate; // Data/ora scadenza specifica
  final String? notes; // Note aggiuntive
  final bool isCompleted; // Se il task è completato
  final DateTime? completedAt; // Quando è stato completato
  final DateTime? lastCompleted; // Retrocompatibilità
  final String? status; // Status dal backend (completed, pending, overdue)
  final bool? overdue; // Se è in ritardo
  final bool enabled;
  final int? reminderHour; // Ora notifica (0-23)
  final int? reminderMinute; // Minuto notifica (0-59)
  final bool isCustom; // true se creato dall'utente, false se predefinito

  MaintenanceTask({
    required this.id,
    required this.aquariumId,
    required this.title,
    this.description,
    required this.category,
    this.frequencyDays = 7,
    this.frequency,
    this.priority,
    this.dueDate,
    this.notes,
    this.isCompleted = false,
    this.completedAt,
    this.lastCompleted,
    this.status,
    this.overdue,
    this.enabled = true,
    this.reminderHour = 9,
    this.reminderMinute = 0,
    this.isCustom = false,
  });

  /// Data prossimo completamento previsto
  DateTime get nextDue {
    // Se c'è una dueDate specifica, usa quella
    if (dueDate != null) {
      return dueDate!;
    }

    if (lastCompleted == null) {
      return DateTime.now();
    }
    return lastCompleted!.add(Duration(days: frequencyDays));
  }

  /// Giorni rimanenti al prossimo completamento
  int get daysUntilDue {
    final now = DateTime.now();
    final next = nextDue;
    return next.difference(now).inDays;
  }

  /// È in ritardo?
  bool get isOverdue {
    final now = DateTime.now();
    final next = nextDue;
    // In ritardo se nextDue è prima di oggi (midnight)
    return next.isBefore(DateTime(now.year, now.month, now.day));
  }

  /// È dovuto oggi?
  bool get isDueToday {
    final now = DateTime.now();
    final next = nextDue;
    final today = DateTime(now.year, now.month, now.day);
    final nextDay = DateTime(next.year, next.month, next.day);
    // Dovuto oggi solo se nextDue è esattamente oggi
    return nextDay.isAtSameMomentAs(today);
  }

  /// È dovuto questa settimana?
  bool get isDueThisWeek {
    return daysUntilDue >= 0 && daysUntilDue <= 7;
  }

  /// Segna come completato
  MaintenanceTask markCompleted([DateTime? completionDate]) {
    return copyWith(lastCompleted: completionDate ?? DateTime.now());
  }

  MaintenanceTask copyWith({
    String? id,
    String? aquariumId,
    String? title,
    String? description,
    MaintenanceCategory? category,
    int? frequencyDays,
    String? frequency,
    String? priority,
    DateTime? dueDate,
    String? notes,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? lastCompleted,
    String? status,
    bool? overdue,
    bool? enabled,
    int? reminderHour,
    int? reminderMinute,
    bool? isCustom,
  }) {
    return MaintenanceTask(
      id: id ?? this.id,
      aquariumId: aquariumId ?? this.aquariumId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      frequency: frequency ?? this.frequency,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      lastCompleted: lastCompleted ?? this.lastCompleted,
      status: status ?? this.status,
      overdue: overdue ?? this.overdue,
      enabled: enabled ?? this.enabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aquariumId': aquariumId,
      'title': title,
      'description': description,
      'frequency': frequency,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
      'notes': notes,
      'category': category.name,
      'frequencyDays': frequencyDays,
      'lastCompleted': lastCompleted?.toIso8601String(),
      'enabled': enabled,
      'reminderHour': reminderHour,
      'reminderMinute': reminderMinute,
      'isCustom': isCustom,
    };
  }

  factory MaintenanceTask.fromJson(Map<String, dynamic> json) {
    // Parse category - se non c'è, prova a dedurlo dal titolo o usa 'other'
    MaintenanceCategory parsedCategory = MaintenanceCategory.other;
    if (json['category'] != null) {
      parsedCategory = MaintenanceCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => MaintenanceCategory.other,
      );
    } else {
      // Deduzione categoria da titolo/descrizione
      final title = json['title']?.toString().toLowerCase() ?? '';
      final desc = json['description']?.toString().toLowerCase() ?? '';
      final text = '$title $desc';

      if (text.contains('acqua') ||
          text.contains('water') ||
          text.contains('cambio')) {
        parsedCategory = MaintenanceCategory.water;
      } else if (text.contains('vetri') ||
          text.contains('pulizia') ||
          text.contains('clean') ||
          text.contains('glass')) {
        parsedCategory = MaintenanceCategory.cleaning;
      } else if (text.contains('filtro') ||
          text.contains('pompa') ||
          text.contains('schiumatoio') ||
          text.contains('filter') ||
          text.contains('pump')) {
        parsedCategory = MaintenanceCategory.equipment;
      } else if (text.contains('test') || text.contains('parametr')) {
        parsedCategory = MaintenanceCategory.testing;
      } else if (text.contains('dosaggio') ||
          text.contains('calcio') ||
          text.contains('magnesio') ||
          text.contains('kh')) {
        parsedCategory = MaintenanceCategory.dosing;
      } else if (text.contains('cibo') ||
          text.contains('alimenta') ||
          text.contains('feed')) {
        parsedCategory = MaintenanceCategory.feeding;
      }
    }

    return MaintenanceTask(
      id: json['id'].toString(),
      aquariumId: json['aquariumId'].toString(),
      title: json['title'].toString(),
      description: json['description']?.toString(),
      frequency: json['frequency']?.toString(),
      priority: json['priority']?.toString(),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      notes: json['notes']?.toString(),
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      status: json['status']?.toString(),
      overdue: json['overdue'] as bool?,
      category: parsedCategory,
      frequencyDays: json['frequencyDays'] is int
          ? json['frequencyDays']
          : int.tryParse(json['frequencyDays']?.toString() ?? '') ?? 7,
      lastCompleted: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : (json['lastCompleted'] != null
                ? DateTime.parse(json['lastCompleted'])
                : null),
      enabled: json['enabled'] ?? true,
      reminderHour: json['reminderHour'],
      reminderMinute: json['reminderMinute'],
      isCustom: json['isCustom'] ?? false,
    );
  }

  /// Task predefiniti comuni
  static List<MaintenanceTask> getDefaultTasks(String aquariumId) {
    return [
      MaintenanceTask(
        id: 'water_change',
        aquariumId: aquariumId,
        title: 'Cambio Acqua',
        description: 'Cambio acqua settimanale (10-20%)',
        category: MaintenanceCategory.water,
        frequencyDays: 7,
        reminderHour: 9,
        reminderMinute: 0,
      ),
      MaintenanceTask(
        id: 'filter_cleaning',
        aquariumId: aquariumId,
        title: 'Pulizia Filtri',
        description: 'Pulizia meccanica filtri e spugne',
        category: MaintenanceCategory.equipment,
        frequencyDays: 30,
        reminderHour: 10,
        reminderMinute: 0,
      ),
      MaintenanceTask(
        id: 'parameter_testing',
        aquariumId: aquariumId,
        title: 'Test Parametri',
        description: 'Controllo parametri acqua principali',
        category: MaintenanceCategory.testing,
        frequencyDays: 3,
        reminderHour: 18,
        reminderMinute: 0,
      ),
      MaintenanceTask(
        id: 'glass_cleaning',
        aquariumId: aquariumId,
        title: 'Pulizia Vetri',
        description: 'Rimozione alghe dai vetri',
        category: MaintenanceCategory.cleaning,
        frequencyDays: 7,
        reminderHour: 9,
        reminderMinute: 30,
      ),
      MaintenanceTask(
        id: 'protein_skimmer',
        aquariumId: aquariumId,
        title: 'Svuota Schiumatoio',
        description: 'Svuotare e pulire bicchiere schiumatoio',
        category: MaintenanceCategory.equipment,
        frequencyDays: 3,
        reminderHour: 8,
        reminderMinute: 0,
      ),
      MaintenanceTask(
        id: 'substrate_cleaning',
        aquariumId: aquariumId,
        title: 'Sifonatura Fondo',
        description: 'Pulizia detriti dal substrato',
        category: MaintenanceCategory.cleaning,
        frequencyDays: 14,
        reminderHour: 9,
        reminderMinute: 0,
      ),
      MaintenanceTask(
        id: 'calcium_dosing',
        aquariumId: aquariumId,
        title: 'Reintegro Calcio/KH',
        description: 'Controllo e dosaggio calcio/alcalinità',
        category: MaintenanceCategory.dosing,
        frequencyDays: 1,
        reminderHour: 20,
        reminderMinute: 0,
      ),
      MaintenanceTask(
        id: 'trace_elements',
        aquariumId: aquariumId,
        title: 'Oligoelementi',
        description: 'Dosaggio oligoelementi e additivi',
        category: MaintenanceCategory.dosing,
        frequencyDays: 7,
        reminderHour: 20,
        reminderMinute: 30,
      ),
      MaintenanceTask(
        id: 'light_maintenance',
        aquariumId: aquariumId,
        title: 'Manutenzione Luci',
        description: 'Pulizia LED e controllo funzionamento',
        category: MaintenanceCategory.equipment,
        frequencyDays: 180,
        reminderHour: 10,
        reminderMinute: 0,
        enabled: false,
      ),
      MaintenanceTask(
        id: 'pump_maintenance',
        aquariumId: aquariumId,
        title: 'Pulizia Pompe',
        description: 'Pulizia rotori e giranti pompe',
        category: MaintenanceCategory.equipment,
        frequencyDays: 90,
        reminderHour: 10,
        reminderMinute: 0,
      ),
    ];
  }
}

/// Categorie task di manutenzione
enum MaintenanceCategory {
  water, // Acqua (cambio, rabbocco)
  equipment, // Attrezzatura (filtri, pompe, luci)
  testing, // Test parametri
  cleaning, // Pulizia (vetri, fondo)
  dosing, // Dosaggio (calcio, oligoelementi)
  feeding, // Alimentazione
  other, // Altro
}

/// Extension per icone e colori categorie
extension MaintenanceCategoryExtension on MaintenanceCategory {
  String get label {
    switch (this) {
      case MaintenanceCategory.water:
        return 'Acqua';
      case MaintenanceCategory.equipment:
        return 'Attrezzatura';
      case MaintenanceCategory.testing:
        return 'Test';
      case MaintenanceCategory.cleaning:
        return 'Pulizia';
      case MaintenanceCategory.dosing:
        return 'Dosaggio';
      case MaintenanceCategory.feeding:
        return 'Alimentazione';
      case MaintenanceCategory.other:
        return 'Altro';
    }
  }

  int get colorValue {
    switch (this) {
      case MaintenanceCategory.water:
        return 0xFF60a5fa; // Blue
      case MaintenanceCategory.equipment:
        return 0xFF8b5cf6; // Purple
      case MaintenanceCategory.testing:
        return 0xFFf59e0b; // Amber
      case MaintenanceCategory.cleaning:
        return 0xFF34d399; // Green
      case MaintenanceCategory.dosing:
        return 0xFFec4899; // Pink
      case MaintenanceCategory.feeding:
        return 0xFFfbbf24; // Yellow
      case MaintenanceCategory.other:
        return 0xFF94a3b8; // Gray
    }
  }
}
