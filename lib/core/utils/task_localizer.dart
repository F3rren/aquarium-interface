/// Localisation helpers for maintenance task copy and related domain labels.
///
/// All functions accept an [AppLocalizations] instance rather than a
/// [BuildContext] so they can be called from service classes and outside
/// the widget tree.
library;

import 'package:acquariumfe/core/l10n/app_localizations.dart';
import 'package:acquariumfe/features/maintenance/domain/models/maintenance_task.dart';

/// Returns the localised display label for an aquarium water type.
///
/// Accepts both backend keys (`'saltwater'`, `'freshwater'`) and UI aliases
/// (`'marine'`, `'reef'`). Falls back to [type] unchanged for unknown values.
String localizedAquariumType(String type, AppLocalizations l10n) {
  switch (type) {
    case 'saltwater':
    case 'marine':
      return l10n.marine;
    case 'freshwater':
      return l10n.freshwater;
    case 'reef':
      return l10n.reef;
    default:
      return type;
  }
}

/// Returns the localised title for a maintenance [task].
///
/// For custom tasks ([MaintenanceTask.isCustom] == `true`) the raw
/// [MaintenanceTask.title] is returned as-is. For system-defined tasks the
/// title is looked up by [MaintenanceTask.id] in the ARB catalogue.
/// Falls back to [MaintenanceTask.title] for unknown IDs.
String localizedTaskTitle(MaintenanceTask task, AppLocalizations l10n) {
  if (task.isCustom) return task.title;
  switch (task.id) {
    case 'water_change':
      return l10n.taskWaterChangeTitle;
    case 'filter_cleaning':
      return l10n.taskFilterCleaningTitle;
    case 'parameter_testing':
      return l10n.taskParameterTestingTitle;
    case 'glass_cleaning':
      return l10n.taskGlassCleaningTitle;
    case 'substrate_cleaning':
      return l10n.taskSubstrateCleaningTitle;
    case 'pump_maintenance':
      return l10n.taskPumpMaintenanceTitle;
    case 'protein_skimmer':
      return l10n.taskProteinSkimmerTitle;
    case 'calcium_dosing':
      return l10n.taskCalciumDosingTitle;
    case 'trace_elements':
      return l10n.taskTraceElementsTitle;
    case 'light_maintenance':
      return l10n.taskLightMaintenanceTitle;
    default:
      return task.title;
  }
}

/// Returns the localised description for a maintenance [task], or `null` if
/// no description is defined.
///
/// Behaves like [localizedTaskTitle]: custom tasks return their raw
/// [MaintenanceTask.description]; system tasks are looked up by ID.
String? localizedTaskDescription(MaintenanceTask task, AppLocalizations l10n) {
  if (task.isCustom) return task.description;
  switch (task.id) {
    case 'water_change':
      return l10n.taskWaterChangeDesc;
    case 'filter_cleaning':
      return l10n.taskFilterCleaningDesc;
    case 'parameter_testing':
      return l10n.taskParameterTestingDesc;
    case 'glass_cleaning':
      return l10n.taskGlassCleaningDesc;
    case 'substrate_cleaning':
      return l10n.taskSubstrateCleaningDesc;
    case 'pump_maintenance':
      return l10n.taskPumpMaintenanceDesc;
    case 'protein_skimmer':
      return l10n.taskProteinSkimmerDesc;
    case 'calcium_dosing':
      return l10n.taskCalciumDosingDesc;
    case 'trace_elements':
      return l10n.taskTraceElementsDesc;
    case 'light_maintenance':
      return l10n.taskLightMaintenanceDesc;
    default:
      return task.description;
  }
}

/// Returns the localised display label for a [MaintenanceCategory] value.
String localizedCategoryLabel(
  MaintenanceCategory category,
  AppLocalizations l10n,
) {
  switch (category) {
    case MaintenanceCategory.water:
      return l10n.categoryWater;
    case MaintenanceCategory.equipment:
      return l10n.categoryEquipment;
    case MaintenanceCategory.testing:
      return l10n.categoryTesting;
    case MaintenanceCategory.cleaning:
      return l10n.categoryCleaning;
    case MaintenanceCategory.dosing:
      return l10n.categoryDosing;
    case MaintenanceCategory.feeding:
      return l10n.categoryFeeding;
    case MaintenanceCategory.other:
      return l10n.categoryOther;
  }
}
