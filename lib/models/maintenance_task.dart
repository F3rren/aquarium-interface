/// Domain model for recurring aquarium maintenance tasks.
library;

import 'package:maintenance_service/api.dart';

/// A recurring maintenance task associated with a specific aquarium.
///
/// Tasks can be **system-defined** (shipped with the app, [isCustom] == `false`)
/// or **user-created** ([isCustom] == `true`). System tasks have well-known
/// [id] values (e.g. `'water_change'`) used for localisation lookup; custom
/// tasks use arbitrary UUIDs.
///
/// **Frequency:** [frequency] (string: `'daily'`, `'weekly'`, `'monthly'`,
/// `'custom'`) is the canonical field; [frequencyDays] is a legacy integer
/// kept for backwards compatibility with older backend responses.
class MaintenanceTask {
  /// Unique identifier. System tasks use descriptive IDs (e.g. `'water_change'`);
  /// custom tasks use UUIDs.
  final String id;

  /// ID of the aquarium this task belongs to.
  final String aquariumId;

  /// Display title shown in the task list.
  final String title;

  /// Optional longer description of what the task involves.
  final String? description;

  /// Functional category used for grouping and colour coding.
  final MaintenanceCategory category;

  /// Legacy recurrence interval in days. Superseded by [frequency] for new
  /// tasks but retained for backward compatibility.
  final int frequencyDays;

  /// Canonical frequency string: `'daily'`, `'weekly'`, `'monthly'`,
  /// or `'custom'`. May be `null` for legacy records that only carry
  /// [frequencyDays].
  final String? frequency;

  /// Task priority level: `'low'`, `'medium'`, or `'high'`.
  final String? priority;

  /// Explicit deadline for one-off or custom-scheduled tasks. When set,
  /// [nextDue] returns this value directly instead of computing from
  /// [lastCompleted].
  final DateTime? dueDate;

  /// Additional notes for this task.
  final String? notes;

  /// Whether the task has been completed in the current cycle.
  final bool isCompleted;

  /// Timestamp of the most recent completion (current API field name).
  final DateTime? completedAt;

  /// Alias for [completedAt] kept for backward compatibility with older code.
  final DateTime? lastCompleted;

  /// Backend status string: `'completed'`, `'pending'`, or `'overdue'`.
  final String? status;

  /// Explicit overdue flag from the backend. When `null`, use [isOverdue]
  /// computed from dates instead.
  final bool? overdue;

  /// Whether this task is active and should appear in the due-task list.
  final bool enabled;

  /// Hour of the day (0–23) at which the reminder notification fires.
  final int? reminderHour;

  /// Minute (0–59) at which the reminder notification fires.
  final int? reminderMinute;

  /// `true` for tasks created by the user; `false` for system-defined tasks.
  final bool isCustom;

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

  // ── Computed properties ───────────────────────────────────────────────────

  /// The next time this task should be completed.
  ///
  /// Returns [dueDate] if set, otherwise computes
  /// `lastCompleted + frequencyDays`. Falls back to [DateTime.now] when no
  /// prior completion is recorded.
  DateTime get nextDue {
    if (dueDate != null) {
      return dueDate!;
    }
    if (lastCompleted == null) {
      return DateTime.now();
    }
    return lastCompleted!.add(Duration(days: frequencyDays));
  }

  /// Number of calendar days until [nextDue]. Negative when overdue.
  int get daysUntilDue {
    final now = DateTime.now();
    final next = nextDue;
    return next.difference(now).inDays;
  }

  /// Returns `true` if [nextDue] falls before today's midnight — i.e. the
  /// task was not completed in time.
  bool get isOverdue {
    final now = DateTime.now();
    final next = nextDue;
    return next.isBefore(DateTime(now.year, now.month, now.day));
  }

  /// Returns `true` if [nextDue] is exactly today (ignoring time-of-day).
  bool get isDueToday {
    final now = DateTime.now();
    final next = nextDue;
    final today = DateTime(now.year, now.month, now.day);
    final nextDay = DateTime(next.year, next.month, next.day);
    return nextDay.isAtSameMomentAs(today);
  }

  /// Returns `true` if the task is due within the next 7 days (inclusive).
  bool get isDueThisWeek {
    return daysUntilDue >= 0 && daysUntilDue <= 7;
  }

  // ── Mutating helpers ──────────────────────────────────────────────────────

  /// Returns a copy of this task with [lastCompleted] set to
  /// [completionDate] (defaults to [DateTime.now]).
  MaintenanceTask markCompleted([DateTime? completionDate]) {
    return copyWith(lastCompleted: completionDate ?? DateTime.now());
  }

  /// Returns a copy with the specified fields replaced.
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

  /// Creates a [MaintenanceTask] from a generated [MaintenanceTaskDTO].
  ///
  /// Fields absent from the DTO ([frequencyDays], [enabled], [reminderHour],
  /// [reminderMinute], [isCustom]) fall back to their defaults. [category] is
  /// inferred from keywords in [title] and [description].
  factory MaintenanceTask.fromDto(MaintenanceTaskDTO dto) {
    MaintenanceCategory parsedCategory = MaintenanceCategory.other;
    final title = dto.title?.toLowerCase() ?? '';
    final desc = dto.description?.toLowerCase() ?? '';
    final text = '$title $desc';
    if (text.contains('acqua') || text.contains('water') || text.contains('cambio')) {
      parsedCategory = MaintenanceCategory.water;
    } else if (text.contains('vetri') || text.contains('pulizia') || text.contains('clean') || text.contains('glass')) {
      parsedCategory = MaintenanceCategory.cleaning;
    } else if (text.contains('filtro') || text.contains('pompa') || text.contains('schiumatoio') || text.contains('filter') || text.contains('pump')) {
      parsedCategory = MaintenanceCategory.equipment;
    } else if (text.contains('test') || text.contains('parametr')) {
      parsedCategory = MaintenanceCategory.testing;
    } else if (text.contains('dosaggio') || text.contains('calcio') || text.contains('magnesio') || text.contains('kh')) {
      parsedCategory = MaintenanceCategory.dosing;
    } else if (text.contains('cibo') || text.contains('alimenta') || text.contains('feed')) {
      parsedCategory = MaintenanceCategory.feeding;
    }

    return MaintenanceTask(
      id: dto.id?.toString() ?? '',
      aquariumId: dto.aquariumId?.toString() ?? '',
      title: dto.title ?? '',
      description: dto.description,
      category: parsedCategory,
      frequency: dto.frequency,
      priority: dto.priority,
      dueDate: dto.dueDate,
      notes: dto.notes,
      isCompleted: dto.isCompleted ?? false,
      completedAt: dto.completedAt,
      lastCompleted: dto.completedAt,
    );
  }

  /// Serialises this task to a JSON map for API requests.
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

  /// Deserialises a [MaintenanceTask] from a backend JSON map.
  ///
  /// **Category inference:** if `'category'` is absent or unrecognised, the
  /// parser attempts to deduce the category from keywords in [title] and
  /// [description] before falling back to [MaintenanceCategory.other].
  factory MaintenanceTask.fromJson(Map<String, dynamic> json) {
    MaintenanceCategory parsedCategory = MaintenanceCategory.other;
    if (json['category'] != null) {
      parsedCategory = MaintenanceCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => MaintenanceCategory.other,
      );
    } else {
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

  /// Returns the default set of maintenance tasks for a new aquarium.
  ///
  /// [aquariumId] is injected into every task. [type] must be either
  /// `'saltwater'` or `'freshwater'`:
  /// - **saltwater** — 6 common tasks + 4 saltwater-specific tasks
  ///   (protein skimmer, calcium/KH dosing, trace elements, light maintenance).
  /// - **freshwater** — 6 common tasks only (no reef-specific tasks).
  static List<MaintenanceTask> getDefaultTasks(
    String aquariumId, {
    String type = 'saltwater',
  }) {
    final bool isSaltwater = type == 'saltwater';

    final commonTasks = [
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

    final saltwaterTasks = [
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
    ];

    return [
      ...commonTasks,
      if (isSaltwater) ...saltwaterTasks,
    ];
  }
}

/// Functional category of a maintenance task, used for grouping and UI colour
/// coding.
enum MaintenanceCategory {
  /// Water-related tasks: water changes, top-off, evaporation checks.
  water,

  /// Equipment tasks: filters, pumps, protein skimmers, lights.
  equipment,

  /// Water-quality testing tasks.
  testing,

  /// Physical cleaning: glass, substrate, rocks.
  cleaning,

  /// Dosing tasks: calcium, alkalinity (KH), magnesium, trace elements.
  dosing,

  /// Fish and coral feeding.
  feeding,

  /// Catch-all for tasks that do not fit the above categories.
  other,
}

/// Adds display labels and brand colours to [MaintenanceCategory].
extension MaintenanceCategoryExtension on MaintenanceCategory {
  /// Italian display label for the category (used in the UI chip).
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

  /// ARGB colour value for the category badge.
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
        return 0xFF94a3b8; // Grey
    }
  }
}
