// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'ReefLife';

  @override
  String get aquariums => 'Acuarios';

  @override
  String get aquarium => 'Acuario';

  @override
  String get parameters => 'Parámetros';

  @override
  String get fish => 'Peces';

  @override
  String get fishes => 'Peces';

  @override
  String get corals => 'Corales';

  @override
  String get coral => 'Coral';

  @override
  String get maintenance => 'Mantenimiento';

  @override
  String get alerts => 'Alertas';

  @override
  String get settings => 'Configuración';

  @override
  String get dashboard => 'Panel';

  @override
  String get charts => 'Gráficos';

  @override
  String get profile => 'Perfil';

  @override
  String get myAquarium => 'Mi Acuario';

  @override
  String get noAquarium => 'Sin Acuario';

  @override
  String get noAquariumDescription =>
      'Comienza creando tu primer acuario para monitorear los parámetros del agua y la salud de tus peces.';

  @override
  String get createAquarium => 'Crear Acuario';

  @override
  String get noFish => 'Sin Peces';

  @override
  String get noFishDescription =>
      'Añade tus peces para hacer seguimiento de la población de tu acuario.';

  @override
  String get addFish => 'Añadir Pez';

  @override
  String get noCoral => 'Sin Coral';

  @override
  String get noCoralDescription =>
      'Documenta los corales presentes en tu acuario marino.';

  @override
  String get addCoral => 'Añadir Coral';

  @override
  String get noHistory => 'Sin Historial';

  @override
  String get noHistoryDescription =>
      'Todavía no hay datos históricos disponibles. Los parámetros se registrarán automáticamente.';

  @override
  String get noTasks => 'Sin Tareas';

  @override
  String get noTasksDescription =>
      'Crea recordatorios para las actividades de mantenimiento de tu acuario.';

  @override
  String get createTask => 'Crear Tarea';

  @override
  String get allOk => 'TODO OK';

  @override
  String get allOkDescription =>
      'No hay alertas activas. Todos los parámetros están dentro del rango normal.';

  @override
  String get noResults => 'Sin Resultados';

  @override
  String noResultsDescription(String query) {
    return 'No hemos encontrado resultados para \"$query\".\nPrueba con palabras clave diferentes.';
  }

  @override
  String get errorTitle => '¡Ups!';

  @override
  String get errorDescription => 'Se ha producido un error';

  @override
  String get retry => 'Reintentar';

  @override
  String get offline => 'Estás Sin Conexión';

  @override
  String get offlineDescription =>
      'Verifica tu conexión a internet e inténtalo de nuevo.';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String edit(String name) {
    return 'Editar $name';
  }

  @override
  String get close => 'Cerrar';

  @override
  String get ok => 'OK';

  @override
  String get name => 'Nombre';

  @override
  String get species => 'Especie';

  @override
  String get size => 'Tamaño';

  @override
  String get notes => 'Notas';

  @override
  String get date => 'Fecha';

  @override
  String get quantity => 'Cantidad';

  @override
  String get addFishTitle => 'Añadir Pez';

  @override
  String get editFishTitle => 'Editar Pez';

  @override
  String get fishNameLabel => 'Nombre *';

  @override
  String get fishNameHint => 'ej: Nemo';

  @override
  String get fishSpeciesLabel => 'Especie *';

  @override
  String get fishSpeciesHint => 'ej: Amphiprion ocellaris';

  @override
  String get fishSizeLabel => 'Tamaño (cm) *';

  @override
  String get fishSizeHint => 'ej: 8.5';

  @override
  String get quantityLabel => 'Cantidad';

  @override
  String get quantityHint => 'Número de ejemplares a añadir';

  @override
  String get quantityInfo =>
      'Si añades múltiples ejemplares, se numerarán automáticamente';

  @override
  String get notesLabel => 'Notas';

  @override
  String get notesHint => 'Añadir notas opcionales';

  @override
  String get selectFromList => 'Seleccionar de la lista';

  @override
  String get orEnterManually => 'o introducir manualmente';

  @override
  String noCompatibleFish(String waterType) {
    return 'Ningún pez compatible con acuario $waterType';
  }

  @override
  String get noDatabaseFish => 'No hay peces disponibles en la base de datos';

  @override
  String get addCoralTitle => 'Añadir Coral';

  @override
  String get editCoralTitle => 'Editar Coral';

  @override
  String get coralNameLabel => 'Nombre *';

  @override
  String get coralNameHint => 'ej: Montipora naranja';

  @override
  String get coralSpeciesLabel => 'Especie *';

  @override
  String get coralSpeciesHint => 'ej: Montipora digitata';

  @override
  String get coralTypeLabel => 'Tipo *';

  @override
  String get coralSizeLabel => 'Tamaño (cm) *';

  @override
  String get coralSizeHint => 'ej: 5.0';

  @override
  String get coralPlacementLabel => 'Ubicación *';

  @override
  String get coralTypeSPS => 'SPS';

  @override
  String get coralTypeLPS => 'LPS';

  @override
  String get coralTypeSoft => 'Blandos';

  @override
  String get placementTop => 'Alto';

  @override
  String get placementMiddle => 'Medio';

  @override
  String get placementBottom => 'Bajo';

  @override
  String get difficultyEasy => 'Fácil';

  @override
  String get difficultyIntermediate => 'Intermedio';

  @override
  String get difficultyHard => 'Difícil';

  @override
  String get difficultyBeginner => 'Principiante';

  @override
  String get difficultyExpert => 'Experto';

  @override
  String get temperamentPeaceful => 'Pacífico';

  @override
  String get temperamentSemiAggressive => 'Semi-agresivo';

  @override
  String get temperamentAggressive => 'Agresivo';

  @override
  String get dietHerbivore => 'Herbívoro';

  @override
  String get dietCarnivore => 'Carnívoro';

  @override
  String get dietOmnivore => 'Omnívoro';

  @override
  String get reefSafe => 'Seguro para arrecife';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get difficulty => 'Dificultad';

  @override
  String get minTankSize => 'Tanque mínimo';

  @override
  String get temperament => 'Temperamento';

  @override
  String get diet => 'Dieta';

  @override
  String get filtersAndSearch => 'Filtros y Búsqueda';

  @override
  String get clearAll => 'Borrar todo';

  @override
  String get searchByName => 'Buscar por nombre';

  @override
  String get searchPlaceholder => 'Buscar por nombre...';

  @override
  String get insertionDate => 'Fecha de introducción al tanque';

  @override
  String get selectType => 'Seleccionar tipo';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get removeDateFilter => 'Eliminar filtro de fecha';

  @override
  String get sorting => 'Ordenación';

  @override
  String get ascendingOrder => 'Orden ascendente';

  @override
  String get fillAllFields => 'Completa todos los campos obligatorios';

  @override
  String get invalidSize => 'Tamaño no válido';

  @override
  String get invalidQuantity => 'Cantidad no válida';

  @override
  String databaseLoadError(String error) {
    return 'Error al cargar la base de datos: $error';
  }

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get tools => 'Herramientas';

  @override
  String get calculators => 'Calculadoras';

  @override
  String get calculatorsSubtitle =>
      'Volumen, dosificación de aditivos, cambio de agua';

  @override
  String get myInhabitants => 'Mis Habitantes';

  @override
  String get myInhabitantsSubtitle => 'Gestionar peces y corales';

  @override
  String get aquariumInfo => 'Info Acuario';

  @override
  String get aquariumInfoSubtitle => 'Nombre, volumen, tipo';

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get appInfo => 'Información de la App';

  @override
  String get appInfoSubtitle => 'Versión, créditos';

  @override
  String get noAquariumSelected => 'Sin Acuario';

  @override
  String unableToLoadInfo(String error) {
    return 'No se puede cargar la información: $error';
  }

  @override
  String get errorLoadingParameters => 'Error al cargar parámetros';

  @override
  String get warning => 'ATENCIÓN';

  @override
  String get critical => 'CRÍTICO';

  @override
  String get aquariumStatus => 'Estado del Acuario';

  @override
  String updatedNow(int okParams, int totalParams) {
    return 'Actualizado ahora • $okParams/$totalParams parámetros OK';
  }

  @override
  String get temperature => 'Temperatura';

  @override
  String get ph => 'pH';

  @override
  String get salinity => 'Salinidad';

  @override
  String get orp => 'ORP';

  @override
  String get excellent => 'Excelente';

  @override
  String get good => 'Bueno';

  @override
  String get parametersOk => 'Parámetros OK';

  @override
  String parametersNeedAttention(int count) {
    return '$count parámetros necesitan atención';
  }

  @override
  String get waterChange => 'Cambio de Agua';

  @override
  String get healthScore => 'Puntuación de Salud';

  @override
  String parametersInOptimalRange(int okParams, int totalParams) {
    return '$okParams/$totalParams parámetros en rango óptimo';
  }

  @override
  String get upcomingReminders => 'Próximos Recordatorios';

  @override
  String get filterCleaning => 'Limpieza de Filtro';

  @override
  String get parameterTesting => 'Prueba de Parámetros';

  @override
  String get days => 'días';

  @override
  String get recommendations => 'Recomendaciones';

  @override
  String get checkOutOfRangeParameters => 'Verificar parámetros fuera de rango';

  @override
  String get checkSkimmer => 'Verificar skimmer';

  @override
  String get weeklyCleaningRecommended => 'Limpieza semanal recomendada';

  @override
  String get khTest => 'Prueba KH';

  @override
  String get lastTest3DaysAgo => 'Última prueba: hace 3 días';

  @override
  String get parametersUpdated => 'Parámetros actualizados';

  @override
  String get error => 'Error';

  @override
  String get noParametersAvailable => 'No hay parámetros disponibles';

  @override
  String get chemicalParameters => 'Parámetros Químicos';

  @override
  String get calciumCa => 'Calcio (Ca)';

  @override
  String get magnesiumMg => 'Magnesio (Mg)';

  @override
  String get nitratesNO3 => 'Nitratos (NO3)';

  @override
  String get phosphatesPO4 => 'Fosfatos (PO4)';

  @override
  String value(String unit) {
    return 'Valor ($unit)';
  }

  @override
  String get low => 'Baja';

  @override
  String get high => 'Alta';

  @override
  String get optimal => 'Óptimo';

  @override
  String get attention => 'Atención';

  @override
  String get monitoring => 'Monitoreo';

  @override
  String targetValue(String unit) {
    return 'Valor objetivo ($unit)';
  }

  @override
  String get current => 'Actual';

  @override
  String get target => 'Objetivo';

  @override
  String get volumeCalculation => 'Cálculo de Volumen del Acuario';

  @override
  String get additivesDosageCalculation =>
      'Cálculo de Dosificación de Aditivos';

  @override
  String get waterChangeCalculation => 'Cálculo de Cambio de Agua';

  @override
  String get densitySalinityConversion => 'Conversión Densidad/Salinidad';

  @override
  String get lightingCalculation => 'Cálculo de Iluminación';

  @override
  String get enterAquariumDimensions =>
      'Introduce las dimensiones del acuario en centímetros';

  @override
  String get length => 'Longitud (cm)';

  @override
  String get width => 'Anchura (cm)';

  @override
  String get height => 'Altura (cm)';

  @override
  String get calculateVolume => 'Calcular Volumen';

  @override
  String get totalVolume => 'Volumen Total';

  @override
  String estimatedNetVolume(String volume) {
    return 'Volumen neto estimado: $volume L';
  }

  @override
  String get consideringRocksAndSubstrate => '(considerando rocas y sustrato)';

  @override
  String get calculateAdditiveDosage =>
      'Calcular la cantidad de aditivo a dosificar';

  @override
  String get dosageSection => '── DOSIFICACIÓN ──';

  @override
  String get reductionSection => '── REDUCCIÓN ──';

  @override
  String get calcium => 'Calcio';

  @override
  String get magnesium => 'Magnesio';

  @override
  String get kh => 'KH';

  @override
  String get iodine => 'Yodo';

  @override
  String get strontium => 'Estroncio';

  @override
  String get nitrates => 'Nitratos (NO3)';

  @override
  String get phosphates => 'Fosfatos (PO4)';

  @override
  String get no3po4xRedSea => 'NO3:PO4-X (Red Sea)';

  @override
  String get activeCarbon => 'Carbono Activo';

  @override
  String get aquariumVolume => 'Volumen del acuario (L)';

  @override
  String currentValue(String unit) {
    return 'Valor actual ($unit)';
  }

  @override
  String get calculateDosage => 'Calcular Dosificación';

  @override
  String get quantityToDose => 'Cantidad a dosificar';

  @override
  String get quantityToDoseReduction => 'Cantidad a dosificar (reducción)';

  @override
  String get indicativeValuesCheckManufacturer =>
      '⚠️ Valores indicativos: verificar instrucciones del fabricante';

  @override
  String get toReduceNitrates =>
      'Para reducir los Nitratos:\\n• Cambio de agua regular (20% semanal)\\n• Skimmer eficiente\\n• Recambio de ósmosis\\n• Carbono activo líquido\\n• NO3:PO4-X (Red Sea)';

  @override
  String get toReducePhosphates =>
      'Para reducir los Fosfatos:\\n• Resinas anti-fosfatos (GFO)\\n• Skimmer eficiente\\n• Cambio de agua regular\\n• NO3:PO4-X (Red Sea)\\n• Evitar sobrealimentación';

  @override
  String get calculateLitersAndSalt =>
      'Calcular litros y sal necesaria para el cambio de agua';

  @override
  String get percentageToChange => 'Porcentaje a cambiar (%)';

  @override
  String get calculateWaterChange => 'Calcular Cambio de Agua';

  @override
  String get waterToChange => 'Agua a cambiar';

  @override
  String get saltNeeded => 'Sal necesaria';

  @override
  String get calculatedForSalinity => 'Calculado para salinidad 1.025 (35g/L)';

  @override
  String get convertBetweenDensityAndSalinity =>
      'Convertir entre densidad y salinidad';

  @override
  String get fromDensityToSalinity => 'De Densidad (g/cm³) a Salinidad (ppt)';

  @override
  String get fromSalinityToDensity => 'De Salinidad (ppt) a Densidad (g/cm³)';

  @override
  String get densityExample => 'Densidad (ej: 1.025)';

  @override
  String get salinityExample => 'Salinidad (ppt, ej: 35)';

  @override
  String get temperatureCelsius => 'Temperatura (°C)';

  @override
  String get salinityPPT => 'Salinidad';

  @override
  String get salinityPPM => 'Salinidad (ppm)';

  @override
  String get density => 'Densidad';

  @override
  String get convert => 'Convertir';

  @override
  String get calculateLightingRequirements =>
      'Calcular requisitos de iluminación para tu acuario';

  @override
  String get tankType => 'Tipo de tanque';

  @override
  String get fishOnly => 'Solo Peces';

  @override
  String get fishAndSoftCorals => 'Peces + Corales Blandos (LPS)';

  @override
  String get spsCorals => 'Corales SPS';

  @override
  String get totalWatts => 'Vatios totales de iluminación';

  @override
  String get calculateLighting => 'Calcular Iluminación';

  @override
  String get wattsPerLiter => 'Vatios por litro';

  @override
  String get recommendation => 'Recomendación';

  @override
  String get insufficientMinimumFish =>
      'Insuficiente - Mínimo 0.25 W/L para peces';

  @override
  String get optimalForFishOnly => 'Óptimo para tanque de solo peces';

  @override
  String get excessiveAlgaeRisk => 'Excesivo - Riesgo de algas';

  @override
  String get insufficientMinimumSoft => 'Insuficiente - Mínimo 0.5 W/L';

  @override
  String get optimalForSoftCorals => 'Óptimo para corales blandos (LPS)';

  @override
  String get veryGoodAlsoSPS => 'Muy bueno - También adecuado para SPS';

  @override
  String get insufficientMinimumSPS => 'Insuficiente - Mínimo 1.0 W/L para SPS';

  @override
  String get optimalForSPS => 'Óptimo para corales SPS';

  @override
  String get veryPowerfulExcellentSPS =>
      'Muy potente - Excelente para SPS exigentes';

  @override
  String get acceptable => 'Aceptable';

  @override
  String get toCorrect => 'A corregir';

  @override
  String get targetTemperature => 'Temperatura Objetivo';

  @override
  String get setDesiredTemperature => 'Establece la temperatura deseada:';

  @override
  String get typicalRangeTemperature => 'Rango típico: 24-26 °C';

  @override
  String get targetSalinity => 'Salinidad Objetivo';

  @override
  String get setDesiredSalinity => 'Establece el valor de salinidad deseado:';

  @override
  String get typicalRangeSalinity => 'Rango típico: 1020-1028';

  @override
  String get targetPh => 'pH Objetivo';

  @override
  String get setDesiredPh => 'Establece el valor de pH deseado:';

  @override
  String get typicalRangePh => 'Rango típico: 8.0-8.4';

  @override
  String get targetOrp => 'ORP Objetivo';

  @override
  String get setDesiredOrp => 'Establece el valor ORP deseado:';

  @override
  String get typicalRangeOrp => 'Rango típico: 300-400 mV';

  @override
  String get newAquarium => 'Nuevo Acuario';

  @override
  String get createNewAquarium => 'Crear Nuevo Acuario';

  @override
  String get fillTankDetails => 'Completa los detalles del tanque';

  @override
  String get aquariumName => 'Nombre del Acuario';

  @override
  String get aquariumNameHint => 'ej. Mi Tanque';

  @override
  String get enterName => 'Ingresa un nombre';

  @override
  String get aquariumType => 'Tipo de Acuario';

  @override
  String get marine => 'Marino';

  @override
  String get freshwater => 'Dulce';

  @override
  String get reef => 'Arrecife';

  @override
  String get volumeLiters => 'Volumen (Litros)';

  @override
  String get volumeHint => 'ej. 200';

  @override
  String get enterVolume => 'Ingresa el volumen';

  @override
  String get saveAquarium => 'Guardar Acuario';

  @override
  String aquariumCreatedSuccess(String name) {
    return 'Acuario \"$name\" creado con éxito!';
  }

  @override
  String get deleteAquarium => 'Eliminar Acuario';

  @override
  String errorLoading(String error) {
    return 'Error al cargar: $error';
  }

  @override
  String get cannotDeleteMissingId =>
      'No se puede eliminar: falta el ID del acuario';

  @override
  String confirmDeleteAquarium(String name) {
    return '¿Estás seguro de que quieres eliminar \'$name\'?';
  }

  @override
  String get actionCannotBeUndone => 'Esta acción no se puede deshacer.';

  @override
  String get aquariumDeletedSuccess => 'Acuario eliminado con éxito';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get noAquariumsToDelete => 'No hay acuarios para eliminar';

  @override
  String get aquariumManagement => 'Gestión de Acuarios';

  @override
  String get selectToDelete => 'Selecciona un acuario para eliminar';

  @override
  String get editAquarium => 'Editar Acuario';

  @override
  String get selectAquarium => 'Seleccionar Acuario';

  @override
  String get chooseAquariumToEdit => 'Elige un acuario para editar';

  @override
  String get noAquariumsFound => 'No se encontraron tanques';

  @override
  String get editDetails => 'Editar Detalles';

  @override
  String updateAquarium(String name) {
    return 'Actualizar $name';
  }

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String changesSavedFor(String name) {
    return 'Cambios guardados para \"$name\"';
  }

  @override
  String errorSavingChanges(String error) {
    return 'Error al guardar los cambios: $error';
  }

  @override
  String chartHistoryTitle(String parameter) {
    return 'Historial $parameter';
  }

  @override
  String get chartNoData => 'No hay datos disponibles';

  @override
  String get chartStatMin => 'Mín';

  @override
  String get chartStatAvg => 'Prom';

  @override
  String get chartStatMax => 'Máx';

  @override
  String get chartStatNow => 'Ahora';

  @override
  String get chartLegendIdeal => 'Ideal';

  @override
  String get chartLegendWarning => 'Aviso';

  @override
  String get chartAdvancedAnalysis => 'Análisis Avanzado';

  @override
  String get chartTrendLabel => 'Tendencia';

  @override
  String get chartStabilityLabel => 'Estabilidad';

  @override
  String get chartTrendStable => 'Estable';

  @override
  String get chartTrendRising => 'En aumento';

  @override
  String get chartTrendFalling => 'En descenso';

  @override
  String get chartStabilityExcellent => 'Excelente';

  @override
  String get chartStabilityGood => 'Buena';

  @override
  String get chartStabilityMedium => 'Media';

  @override
  String get chartStabilityLow => 'Baja';

  @override
  String chartAdviceOutOfRange(String parameter) {
    return 'Atención: $parameter fuera de rango. Verifica inmediatamente y corrige.';
  }

  @override
  String get chartAdviceNotIdeal =>
      'Parámetro aceptable pero no ideal. Monitoriza cuidadosamente.';

  @override
  String get chartAdviceUnstable =>
      'Parámetro inestable. Verifica cambio de agua y dosificación de aditivos.';

  @override
  String get chartAdviceTempRising =>
      'Temperatura en aumento. Verifica refrigeración y ventilación.';

  @override
  String get chartAdviceOptimal => 'Parámetro óptimo y estable.';

  @override
  String get paramTemperature => 'Temperatura';

  @override
  String get paramPH => 'pH';

  @override
  String get paramSalinity => 'Salinidad';

  @override
  String get paramORP => 'ORP';

  @override
  String errorLoadingTasks(String error) {
    return 'Error al cargar tareas: $error';
  }

  @override
  String get addTask => 'Agregar Tarea';

  @override
  String inProgress(int count) {
    return 'En Curso ($count)';
  }

  @override
  String completed(int count) {
    return 'Completados ($count)';
  }

  @override
  String get overdue => 'Atrasado';

  @override
  String get today => 'Hoy';

  @override
  String get week => 'Semana';

  @override
  String get all => 'Todos';

  @override
  String get noCompletedTasks => 'No hay tareas completadas';

  @override
  String get noTasksInProgress => 'No hay tareas en curso';

  @override
  String overdueDays(int days) {
    return 'Atrasado por $days días';
  }

  @override
  String get dueToday => 'Vence hoy';

  @override
  String inDays(int days) {
    return 'En $days días';
  }

  @override
  String completedOn(String date) {
    return 'Completado: $date';
  }

  @override
  String get newTask => 'Nueva Tarea';

  @override
  String get taskTitle => 'Título de la Tarea';

  @override
  String get taskDescription => 'Descripción (opcional)';

  @override
  String get category => 'Categoría';

  @override
  String get frequency => 'Frecuencia';

  @override
  String everyDays(int days) {
    return 'Cada $days días';
  }

  @override
  String get reminder => 'Recordatorio';

  @override
  String get enabled => 'Habilitado';

  @override
  String get disabled => 'Deshabilitado';

  @override
  String get time => 'Hora';

  @override
  String get enterTaskTitle => 'Ingresa un título';

  @override
  String get water => 'Agua';

  @override
  String get cleaning => 'Limpieza';

  @override
  String get testing => 'Pruebas';

  @override
  String get feeding => 'Alimentación';

  @override
  String get equipment => 'Equipo';

  @override
  String get other => 'Otro';

  @override
  String get createCustomMaintenance => 'Crear un mantenimiento personalizado';

  @override
  String get day => 'día';

  @override
  String get enableReminder => 'Habilitar recordatorio';

  @override
  String get at => 'A las';

  @override
  String get noReminder => 'Sin recordatorio';

  @override
  String changeTime(String time) {
    return 'Cambiar hora ($time)';
  }

  @override
  String get notifications => 'Notificaciones';

  @override
  String get settingsSaved => 'Configuración guardada';

  @override
  String get settingsTab => 'Configuración';

  @override
  String get thresholdsTab => 'Umbrales';

  @override
  String get historyTab => 'Historial';

  @override
  String get alertParameters => 'Alertas de Parámetros';

  @override
  String get alertParametersSubtitle =>
      'Notificaciones cuando los parámetros están fuera de rango';

  @override
  String get maintenanceReminders => 'Recordatorios de Mantenimiento';

  @override
  String get maintenanceRemindersSubtitle =>
      'Notificaciones para cambio de agua, limpieza de filtro, etc.';

  @override
  String get dailySummary => 'Resumen Diario';

  @override
  String get dailySummarySubtitle =>
      'Notificación diaria con el estado del acuario';

  @override
  String get maintenanceFrequency => 'Frecuencia de Mantenimiento';

  @override
  String get resetDefaults => 'Restablecer Valores Predeterminados';

  @override
  String get parameterThresholds => 'Umbrales de Parámetros';

  @override
  String get min => 'Mín';

  @override
  String get max => 'Máx';

  @override
  String get alertHistory => 'Historial de Alertas';

  @override
  String recentNotifications(int count) {
    return '$count notificaciones recientes';
  }

  @override
  String get noNotificationsYet => 'Aún no hay notificaciones';

  @override
  String get resetDefaultsQuestion => '¿Restablecer Predeterminados?';

  @override
  String get resetDefaultsMessage =>
      'Esta acción restablecerá todos los umbrales personalizados a los valores predeterminados:';

  @override
  String get resetButton => 'Restablecer';

  @override
  String get fillAllRequiredFields => 'Completa todos los campos obligatorios';

  @override
  String get inhabitantsUpdated => '¡Habitantes actualizados!';

  @override
  String get clearFilters => 'Borrar filtros';

  @override
  String get aquariumIdNotAvailable => 'Error: ID del acuario no disponible';

  @override
  String get daily => 'Diario';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensual';

  @override
  String get custom => 'Personalizado';

  @override
  String get medium => 'Media';

  @override
  String get dueDate => 'Fecha de vencimiento';

  @override
  String get add => 'Agregar';

  @override
  String get taskAddedSuccess => 'Tarea agregada con éxito';

  @override
  String get editTask => 'Editar Tarea';

  @override
  String get taskEditedSuccess => 'Tarea editada con éxito';

  @override
  String get completeTask => 'Completar Tarea';

  @override
  String markAsCompleted(String title) {
    return '¿Quieres marcar \"$title\" como completada?';
  }

  @override
  String get complete => 'Completar';

  @override
  String taskCompleted(String title) {
    return '¡$title completada!';
  }

  @override
  String get deleteTask => 'Eliminar Tarea';

  @override
  String confirmDeleteTask(String title) {
    return '¿Quieres eliminar \"$title\"?';
  }

  @override
  String get taskDeleted => 'Tarea eliminada';
}
