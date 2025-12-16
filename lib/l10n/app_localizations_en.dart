// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ReefLife';

  @override
  String get aquariums => 'Aquariums';

  @override
  String get aquarium => 'Aquarium';

  @override
  String get parameters => 'Parameters';

  @override
  String get fish => 'Fish';

  @override
  String get fishes => 'Fish';

  @override
  String get corals => 'Corals';

  @override
  String get coral => 'Coral';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get alerts => 'Alerts';

  @override
  String get settings => 'Settings';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get charts => 'Charts';

  @override
  String get profile => 'Profile';

  @override
  String get myAquarium => 'My Aquarium';

  @override
  String get noAquarium => 'No Aquarium';

  @override
  String get noAquariumDescription =>
      'Start by creating your first aquarium to monitor water parameters and the health of your fish.';

  @override
  String get createAquarium => 'Create Aquarium';

  @override
  String get noFish => 'No Fish';

  @override
  String get noFishDescription =>
      'Add your fish to track your aquarium\'s population.';

  @override
  String get addFish => 'Add Fish';

  @override
  String get noCoral => 'No Coral';

  @override
  String get noCoralDescription =>
      'Document the corals in your marine aquarium.';

  @override
  String get addCoral => 'Add Coral';

  @override
  String get noHistory => 'No History';

  @override
  String get noHistoryDescription =>
      'No historical data available yet. Parameters will be automatically recorded.';

  @override
  String get noTasks => 'No Tasks';

  @override
  String get noTasksDescription =>
      'Create reminders for your aquarium maintenance activities.';

  @override
  String get createTask => 'Create Task';

  @override
  String get allOk => 'ALL OK';

  @override
  String get allOkDescription =>
      'No active alerts. All parameters are within normal range.';

  @override
  String get noResults => 'No Results';

  @override
  String noResultsDescription(String query) {
    return 'We couldn\'t find results for \"$query\".\nTry different keywords.';
  }

  @override
  String get errorTitle => 'Oops!';

  @override
  String get errorDescription => 'An error occurred';

  @override
  String get retry => 'Retry';

  @override
  String get offline => 'You\'re Offline';

  @override
  String get offlineDescription =>
      'Check your internet connection and try again.';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String edit(String name) {
    return 'Edit $name';
  }

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get name => 'Name';

  @override
  String get species => 'Species';

  @override
  String get size => 'Size';

  @override
  String get notes => 'Notes';

  @override
  String get date => 'Date';

  @override
  String get quantity => 'Quantity';

  @override
  String get addFishTitle => 'Add Fish';

  @override
  String get editFishTitle => 'Edit Fish';

  @override
  String get fishNameLabel => 'Name *';

  @override
  String get fishNameHint => 'e.g.: Nemo';

  @override
  String get fishSpeciesLabel => 'Species *';

  @override
  String get fishSpeciesHint => 'e.g.: Amphiprion ocellaris';

  @override
  String get fishSizeLabel => 'Size (cm) *';

  @override
  String get fishSizeHint => 'e.g.: 8.5';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get quantityHint => 'Number of specimens to add';

  @override
  String get quantityInfo =>
      'If you add multiple specimens, they will be automatically numbered';

  @override
  String get notesLabel => 'Notes';

  @override
  String get notesHint => 'Add optional notes';

  @override
  String get selectFromList => 'Select from list';

  @override
  String get orEnterManually => 'or enter manually';

  @override
  String noCompatibleFish(String waterType) {
    return 'No fish compatible with $waterType aquarium';
  }

  @override
  String get noDatabaseFish => 'No fish available in database';

  @override
  String get addCoralTitle => 'Add Coral';

  @override
  String get editCoralTitle => 'Edit Coral';

  @override
  String get coralNameLabel => 'Name *';

  @override
  String get coralNameHint => 'e.g.: Orange Montipora';

  @override
  String get coralSpeciesLabel => 'Species *';

  @override
  String get coralSpeciesHint => 'e.g.: Montipora digitata';

  @override
  String get coralTypeLabel => 'Type *';

  @override
  String get coralSizeLabel => 'Size (cm) *';

  @override
  String get coralSizeHint => 'e.g.: 5.0';

  @override
  String get coralPlacementLabel => 'Placement *';

  @override
  String get coralTypeSPS => 'SPS';

  @override
  String get coralTypeLPS => 'LPS';

  @override
  String get coralTypeSoft => 'Soft';

  @override
  String get placementTop => 'Top';

  @override
  String get placementMiddle => 'Middle';

  @override
  String get placementBottom => 'Bottom';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyIntermediate => 'Intermediate';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyBeginner => 'Beginner';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get temperamentPeaceful => 'Peaceful';

  @override
  String get temperamentSemiAggressive => 'Semi-aggressive';

  @override
  String get temperamentAggressive => 'Aggressive';

  @override
  String get dietHerbivore => 'Herbivore';

  @override
  String get dietCarnivore => 'Carnivore';

  @override
  String get dietOmnivore => 'Omnivore';

  @override
  String get reefSafe => 'Reef-safe';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get minTankSize => 'Min tank size';

  @override
  String get temperament => 'Temperament';

  @override
  String get diet => 'Diet';

  @override
  String get filtersAndSearch => 'Filters and Search';

  @override
  String get clearAll => 'Clear all';

  @override
  String get searchByName => 'Search by name';

  @override
  String get searchPlaceholder => 'Search by name...';

  @override
  String get insertionDate => 'Tank insertion date';

  @override
  String get selectType => 'Select type';

  @override
  String get selectDate => 'Select date';

  @override
  String get removeDateFilter => 'Remove date filter';

  @override
  String get sorting => 'Sorting';

  @override
  String get ascendingOrder => 'Ascending order';

  @override
  String get fillAllFields => 'Fill in all required fields';

  @override
  String get invalidSize => 'Invalid size';

  @override
  String get invalidQuantity => 'Invalid quantity';

  @override
  String databaseLoadError(String error) {
    return 'Database loading error: $error';
  }

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get tools => 'Tools';

  @override
  String get calculators => 'Calculators';

  @override
  String get calculatorsSubtitle => 'Volume, additive dosing, water change';

  @override
  String get myInhabitants => 'My Inhabitants';

  @override
  String get myInhabitantsSubtitle => 'Manage fish and corals';

  @override
  String get aquariumInfo => 'Aquarium Info';

  @override
  String get aquariumInfoSubtitle => 'Name, volume, type';

  @override
  String get theme => 'Theme';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get lightMode => 'Light mode';

  @override
  String get appInfo => 'App Information';

  @override
  String get appInfoSubtitle => 'Version, credits';

  @override
  String get noAquariumSelected => 'No Aquarium';

  @override
  String unableToLoadInfo(String error) {
    return 'Unable to load information: $error';
  }

  @override
  String get errorLoadingParameters => 'Error loading parameters';

  @override
  String get warning => 'WARNING';

  @override
  String get critical => 'CRITICAL';

  @override
  String get aquariumStatus => 'Aquarium Status';

  @override
  String updatedNow(int okParams, int totalParams) {
    return 'Updated now • $okParams/$totalParams parameters OK';
  }

  @override
  String get temperature => 'Temperature';

  @override
  String get ph => 'pH';

  @override
  String get salinity => 'Salinity';

  @override
  String get orp => 'ORP';

  @override
  String get excellent => 'Excellent';

  @override
  String get good => 'Good';

  @override
  String get parametersOk => 'Parameters OK';

  @override
  String parametersNeedAttention(int count) {
    return '$count parameters need attention';
  }

  @override
  String get waterChange => 'Water Change';

  @override
  String get healthScore => 'Health Score';

  @override
  String parametersInOptimalRange(int okParams, int totalParams) {
    return '$okParams/$totalParams parameters in optimal range';
  }

  @override
  String get upcomingReminders => 'Upcoming Reminders';

  @override
  String get filterCleaning => 'Filter Cleaning';

  @override
  String get parameterTesting => 'Parameter Testing';

  @override
  String get days => 'days';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get checkOutOfRangeParameters => 'Check out-of-range parameters';

  @override
  String get checkSkimmer => 'Check skimmer';

  @override
  String get weeklyCleaningRecommended => 'Weekly cleaning recommended';

  @override
  String get khTest => 'KH Test';

  @override
  String get lastTest3DaysAgo => 'Last test: 3 days ago';

  @override
  String get parametersUpdated => 'Parameters updated';

  @override
  String get error => 'Error';

  @override
  String get noParametersAvailable => 'No parameters available';

  @override
  String get chemicalParameters => 'Chemical Parameters';

  @override
  String get calciumCa => 'Calcium (Ca)';

  @override
  String get magnesiumMg => 'Magnesium (Mg)';

  @override
  String get nitratesNO3 => 'Nitrates (NO3)';

  @override
  String get phosphatesPO4 => 'Phosphates (PO4)';

  @override
  String value(String unit) {
    return 'Value ($unit)';
  }

  @override
  String get low => 'Low';

  @override
  String get high => 'High';

  @override
  String get optimal => 'Optimal';

  @override
  String get attention => 'Attention';

  @override
  String get monitoring => 'Monitoring';

  @override
  String targetValue(String unit) {
    return 'Target value ($unit)';
  }

  @override
  String get current => 'Current';

  @override
  String get target => 'Target';

  @override
  String get volumeCalculation => 'Aquarium Volume Calculation';

  @override
  String get additivesDosageCalculation => 'Additives Dosage Calculation';

  @override
  String get waterChangeCalculation => 'Water Change Calculation';

  @override
  String get densitySalinityConversion => 'Density/Salinity Conversion';

  @override
  String get lightingCalculation => 'Lighting Calculation';

  @override
  String get enterAquariumDimensions =>
      'Enter aquarium dimensions in centimeters';

  @override
  String get length => 'Length (cm)';

  @override
  String get width => 'Width (cm)';

  @override
  String get height => 'Height (cm)';

  @override
  String get calculateVolume => 'Calculate Volume';

  @override
  String get totalVolume => 'Total Volume';

  @override
  String estimatedNetVolume(String volume) {
    return 'Estimated net volume: $volume L';
  }

  @override
  String get consideringRocksAndSubstrate =>
      '(considering rocks and substrate)';

  @override
  String get calculateAdditiveDosage =>
      'Calculate the amount of additive to dose';

  @override
  String get dosageSection => '── DOSING ──';

  @override
  String get reductionSection => '── REDUCTION ──';

  @override
  String get calcium => 'Calcium';

  @override
  String get magnesium => 'Magnesium';

  @override
  String get kh => 'KH';

  @override
  String get iodine => 'Iodine';

  @override
  String get strontium => 'Strontium';

  @override
  String get nitrates => 'Nitrates (NO3)';

  @override
  String get phosphates => 'Phosphates (PO4)';

  @override
  String get no3po4xRedSea => 'NO3:PO4-X (Red Sea)';

  @override
  String get activeCarbon => 'Active Carbon';

  @override
  String get aquariumVolume => 'Aquarium volume (L)';

  @override
  String currentValue(String unit) {
    return 'Current value ($unit)';
  }

  @override
  String get calculateDosage => 'Calculate Dosage';

  @override
  String get quantityToDose => 'Quantity to dose';

  @override
  String get quantityToDoseReduction => 'Quantity to dose (reduction)';

  @override
  String get indicativeValuesCheckManufacturer =>
      '⚠️ Indicative values: check manufacturer\'s instructions';

  @override
  String get toReduceNitrates =>
      'To reduce Nitrates:\\n• Regular water change (20% weekly)\\n• Efficient skimmer\\n• RO refill\\n• Liquid active carbon\\n• NO3:PO4-X (Red Sea)';

  @override
  String get toReducePhosphates =>
      'To reduce Phosphates:\\n• Anti-phosphate resins (GFO)\\n• Efficient skimmer\\n• Regular water change\\n• NO3:PO4-X (Red Sea)\\n• Avoid overfeeding';

  @override
  String get calculateLitersAndSalt =>
      'Calculate liters and salt needed for water change';

  @override
  String get percentageToChange => 'Percentage to change (%)';

  @override
  String get calculateWaterChange => 'Calculate Water Change';

  @override
  String get waterToChange => 'Water to change';

  @override
  String get saltNeeded => 'Salt needed';

  @override
  String get calculatedForSalinity => 'Calculated for salinity 1.025 (35g/L)';

  @override
  String get convertBetweenDensityAndSalinity =>
      'Convert between density and salinity';

  @override
  String get fromDensityToSalinity => 'From Density (g/cm³) to Salinity (ppt)';

  @override
  String get fromSalinityToDensity => 'From Salinity (ppt) to Density (g/cm³)';

  @override
  String get densityExample => 'Density (e.g.: 1.025)';

  @override
  String get salinityExample => 'Salinity (ppt, e.g.: 35)';

  @override
  String get temperatureCelsius => 'Temperature (°C)';

  @override
  String get salinityPPT => 'Salinity';

  @override
  String get salinityPPM => 'Salinity (ppm)';

  @override
  String get density => 'Density';

  @override
  String get convert => 'Convert';

  @override
  String get calculateLightingRequirements =>
      'Calculate lighting requirements for your aquarium';

  @override
  String get tankType => 'Tank type';

  @override
  String get fishOnly => 'Fish Only';

  @override
  String get fishAndSoftCorals => 'Fish + Soft Corals';

  @override
  String get spsCorals => 'SPS Corals';

  @override
  String get totalWatts => 'Total lighting watts';

  @override
  String get calculateLighting => 'Calculate Lighting';

  @override
  String get wattsPerLiter => 'Watts per liter';

  @override
  String get recommendation => 'Recommendation';

  @override
  String get insufficientMinimumFish =>
      'Insufficient - Minimum 0.25 W/L for fish';

  @override
  String get optimalForFishOnly => 'Optimal for fish-only tank';

  @override
  String get excessiveAlgaeRisk => 'Excessive - Algae risk';

  @override
  String get insufficientMinimumSoft => 'Insufficient - Minimum 0.5 W/L';

  @override
  String get optimalForSoftCorals => 'Optimal for soft corals (LPS)';

  @override
  String get veryGoodAlsoSPS => 'Very good - Also suitable for SPS';

  @override
  String get insufficientMinimumSPS => 'Insufficient - Minimum 1.0 W/L for SPS';

  @override
  String get optimalForSPS => 'Optimal for SPS corals';

  @override
  String get veryPowerfulExcellentSPS =>
      'Very powerful - Excellent for demanding SPS';

  @override
  String get acceptable => 'Acceptable';

  @override
  String get toCorrect => 'To be corrected';

  @override
  String get targetTemperature => 'Target Temperature';

  @override
  String get setDesiredTemperature => 'Set the desired temperature:';

  @override
  String get typicalRangeTemperature => 'Typical range: 24-26 °C';

  @override
  String get targetSalinity => 'Target Salinity';

  @override
  String get setDesiredSalinity => 'Set the desired salinity value:';

  @override
  String get typicalRangeSalinity => 'Typical range: 1020-1028';

  @override
  String get targetPh => 'Target pH';

  @override
  String get setDesiredPh => 'Set the desired pH value:';

  @override
  String get typicalRangePh => 'Typical range: 8.0-8.4';

  @override
  String get targetOrp => 'Target ORP';

  @override
  String get setDesiredOrp => 'Set the desired ORP value:';

  @override
  String get typicalRangeOrp => 'Typical range: 300-400 mV';

  @override
  String get newAquarium => 'New Aquarium';

  @override
  String get createNewAquarium => 'Create New Aquarium';

  @override
  String get fillTankDetails => 'Fill in the tank details';

  @override
  String get aquariumName => 'Aquarium Name';

  @override
  String get aquariumNameHint => 'e.g. My Tank';

  @override
  String get enterName => 'Enter a name';

  @override
  String get aquariumType => 'Aquarium Type';

  @override
  String get marine => 'Marine';

  @override
  String get freshwater => 'Freshwater';

  @override
  String get reef => 'Reef';

  @override
  String get volumeLiters => 'Volume (Liters)';

  @override
  String get volumeHint => 'e.g. 200';

  @override
  String get enterVolume => 'Enter the volume';

  @override
  String get saveAquarium => 'Save Aquarium';

  @override
  String aquariumCreatedSuccess(String name) {
    return 'Aquarium \"$name\" created successfully!';
  }

  @override
  String get deleteAquarium => 'Delete Aquarium';

  @override
  String errorLoading(String error) {
    return 'Loading error: $error';
  }

  @override
  String get cannotDeleteMissingId => 'Cannot delete: aquarium ID missing';

  @override
  String confirmDeleteAquarium(String name) {
    return 'Are you sure you want to delete \'$name\'?';
  }

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get aquariumDeletedSuccess => 'Aquarium deleted successfully';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get noAquariumsToDelete => 'No aquariums to delete';

  @override
  String get aquariumManagement => 'Aquarium Management';

  @override
  String get selectToDelete => 'Select an aquarium to delete';

  @override
  String get editAquarium => 'Edit Aquarium';

  @override
  String get selectAquarium => 'Select Aquarium';

  @override
  String get chooseAquariumToEdit => 'Choose an aquarium to edit';

  @override
  String get noAquariumsFound => 'No tanks found';

  @override
  String get editDetails => 'Edit Details';

  @override
  String updateAquarium(String name) {
    return 'Update $name';
  }

  @override
  String get saveChanges => 'Save Changes';

  @override
  String changesSavedFor(String name) {
    return 'Changes saved for \"$name\"';
  }

  @override
  String errorSavingChanges(String error) {
    return 'Error saving changes: $error';
  }

  @override
  String chartHistoryTitle(String parameter) {
    return 'History $parameter';
  }

  @override
  String get chartNoData => 'No data available';

  @override
  String get chartStatMin => 'Min';

  @override
  String get chartStatAvg => 'Avg';

  @override
  String get chartStatMax => 'Max';

  @override
  String get chartStatNow => 'Now';

  @override
  String get chartLegendIdeal => 'Ideal';

  @override
  String get chartLegendWarning => 'Warning';

  @override
  String get chartAdvancedAnalysis => 'Advanced Analysis';

  @override
  String get chartTrendLabel => 'Trend';

  @override
  String get chartStabilityLabel => 'Stability';

  @override
  String get chartTrendStable => 'Stable';

  @override
  String get chartTrendRising => 'Rising';

  @override
  String get chartTrendFalling => 'Falling';

  @override
  String get chartStabilityExcellent => 'Excellent';

  @override
  String get chartStabilityGood => 'Good';

  @override
  String get chartStabilityMedium => 'Medium';

  @override
  String get chartStabilityLow => 'Low';

  @override
  String chartAdviceOutOfRange(String parameter) {
    return 'Warning: $parameter out of range. Check immediately and correct.';
  }

  @override
  String get chartAdviceNotIdeal =>
      'Parameter acceptable but not ideal. Monitor carefully.';

  @override
  String get chartAdviceUnstable =>
      'Unstable parameter. Check water change and additive dosing.';

  @override
  String get chartAdviceTempRising =>
      'Temperature rising. Check cooling and ventilation.';

  @override
  String get chartAdviceOptimal => 'Optimal and stable parameter.';

  @override
  String get paramTemperature => 'Temperature';

  @override
  String get paramPH => 'pH';

  @override
  String get paramSalinity => 'Salinity';

  @override
  String get paramORP => 'ORP';

  @override
  String errorLoadingTasks(String error) {
    return 'Error loading tasks: $error';
  }

  @override
  String get addTask => 'Add Task';

  @override
  String inProgress(int count) {
    return 'In Progress ($count)';
  }

  @override
  String completed(int count) {
    return 'Completed ($count)';
  }

  @override
  String get overdue => 'Overdue';

  @override
  String get today => 'Today';

  @override
  String get week => 'Week';

  @override
  String get all => 'All';

  @override
  String get noCompletedTasks => 'No completed tasks';

  @override
  String get noTasksInProgress => 'No tasks in progress';

  @override
  String overdueDays(int days) {
    return 'Overdue by $days days';
  }

  @override
  String get dueToday => 'Due today';

  @override
  String inDays(int days) {
    return 'In $days days';
  }

  @override
  String completedOn(String date) {
    return 'Completed: $date';
  }

  @override
  String get newTask => 'New Task';

  @override
  String get taskTitle => 'Task Title';

  @override
  String get taskDescription => 'Description (optional)';

  @override
  String get category => 'Category';

  @override
  String get frequency => 'Frequency';

  @override
  String everyDays(int days) {
    return 'Every $days days';
  }

  @override
  String get reminder => 'Reminder';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get time => 'Time';

  @override
  String get enterTaskTitle => 'Enter a title';

  @override
  String get water => 'Water';

  @override
  String get cleaning => 'Cleaning';

  @override
  String get testing => 'Testing';

  @override
  String get feeding => 'Feeding';

  @override
  String get equipment => 'Equipment';

  @override
  String get other => 'Other';

  @override
  String get createCustomMaintenance => 'Create a custom maintenance';

  @override
  String get day => 'day';

  @override
  String get enableReminder => 'Enable reminder';

  @override
  String get at => 'At';

  @override
  String get noReminder => 'No reminder';

  @override
  String changeTime(String time) {
    return 'Change time ($time)';
  }

  @override
  String get notifications => 'Notifications';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get settingsTab => 'Settings';

  @override
  String get thresholdsTab => 'Thresholds';

  @override
  String get historyTab => 'History';

  @override
  String get alertParameters => 'Parameter Alerts';

  @override
  String get alertParametersSubtitle =>
      'Notifications when parameters are out of range';

  @override
  String get maintenanceReminders => 'Maintenance Reminders';

  @override
  String get maintenanceRemindersSubtitle =>
      'Notifications for water change, filter cleaning, etc.';

  @override
  String get dailySummary => 'Daily Summary';

  @override
  String get dailySummarySubtitle => 'Daily notification with aquarium status';

  @override
  String get maintenanceFrequency => 'Maintenance Frequency';

  @override
  String get resetDefaults => 'Reset to Defaults';

  @override
  String get parameterThresholds => 'Parameter Thresholds';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get alertHistory => 'Alert History';

  @override
  String recentNotifications(int count) {
    return '$count recent notifications';
  }

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get resetDefaultsQuestion => 'Reset to Defaults?';

  @override
  String get resetDefaultsMessage =>
      'This action will reset all customized thresholds to default values:';

  @override
  String get resetButton => 'Reset';
}
