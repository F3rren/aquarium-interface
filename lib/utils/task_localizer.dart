import 'package:acquariumfe/l10n/app_localizations.dart';
import 'package:acquariumfe/models/maintenance_task.dart';

/// Restituisce la label localizzata per il tipo di vasca.
/// Accetta le chiavi backend ('saltwater', 'freshwater') o UI ('marine', 'reef').
String localizedAquariumType(String type, AppLocalizations l10n) {
  switch (type) {
    case 'saltwater':
    case 'marine':  return l10n.marine;
    case 'freshwater': return l10n.freshwater;
    case 'reef':    return l10n.reef;
    default:        return type;
  }
}

/// Restituisce il titolo localizzato per un task predefinito.
/// Per task custom (isCustom = true) usa direttamente task.title.
String localizedTaskTitle(MaintenanceTask task, AppLocalizations l10n) {
  if (task.isCustom) return task.title;
  switch (task.id) {
    case 'water_change':      return l10n.taskWaterChangeTitle;
    case 'filter_cleaning':   return l10n.taskFilterCleaningTitle;
    case 'parameter_testing': return l10n.taskParameterTestingTitle;
    case 'glass_cleaning':    return l10n.taskGlassCleaningTitle;
    case 'substrate_cleaning':return l10n.taskSubstrateCleaningTitle;
    case 'pump_maintenance':  return l10n.taskPumpMaintenanceTitle;
    case 'protein_skimmer':   return l10n.taskProteinSkimmerTitle;
    case 'calcium_dosing':    return l10n.taskCalciumDosingTitle;
    case 'trace_elements':    return l10n.taskTraceElementsTitle;
    case 'light_maintenance': return l10n.taskLightMaintenanceTitle;
    default:                  return task.title;
  }
}

/// Restituisce la descrizione localizzata per un task predefinito.
/// Per task custom usa direttamente task.description.
String? localizedTaskDescription(MaintenanceTask task, AppLocalizations l10n) {
  if (task.isCustom) return task.description;
  switch (task.id) {
    case 'water_change':      return l10n.taskWaterChangeDesc;
    case 'filter_cleaning':   return l10n.taskFilterCleaningDesc;
    case 'parameter_testing': return l10n.taskParameterTestingDesc;
    case 'glass_cleaning':    return l10n.taskGlassCleaningDesc;
    case 'substrate_cleaning':return l10n.taskSubstrateCleaningDesc;
    case 'pump_maintenance':  return l10n.taskPumpMaintenanceDesc;
    case 'protein_skimmer':   return l10n.taskProteinSkimmerDesc;
    case 'calcium_dosing':    return l10n.taskCalciumDosingDesc;
    case 'trace_elements':    return l10n.taskTraceElementsDesc;
    case 'light_maintenance': return l10n.taskLightMaintenanceDesc;
    default:                  return task.description;
  }
}

/// Restituisce la label localizzata per una categoria di manutenzione.
String localizedCategoryLabel(MaintenanceCategory category, AppLocalizations l10n) {
  switch (category) {
    case MaintenanceCategory.water:     return l10n.categoryWater;
    case MaintenanceCategory.equipment: return l10n.categoryEquipment;
    case MaintenanceCategory.testing:   return l10n.categoryTesting;
    case MaintenanceCategory.cleaning:  return l10n.categoryCleaning;
    case MaintenanceCategory.dosing:    return l10n.categoryDosing;
    case MaintenanceCategory.feeding:   return l10n.categoryFeeding;
    case MaintenanceCategory.other:     return l10n.categoryOther;
  }
}
