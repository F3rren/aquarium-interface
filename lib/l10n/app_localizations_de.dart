// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'ReefLife';

  @override
  String get aquariums => 'Aquarien';

  @override
  String get aquarium => 'Aquarium';

  @override
  String get parameters => 'Parameter';

  @override
  String get fish => 'Fische';

  @override
  String get fishes => 'Fische';

  @override
  String get corals => 'Korallen';

  @override
  String get coral => 'Koralle';

  @override
  String get maintenance => 'Wartung';

  @override
  String get alerts => 'Alarme';

  @override
  String get settings => 'Einstellungen';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get charts => 'Diagramme';

  @override
  String get profile => 'Profil';

  @override
  String get myAquarium => 'Mein Aquarium';

  @override
  String get noAquarium => 'Kein Aquarium';

  @override
  String get noAquariumDescription =>
      'Erstellen Sie Ihr erstes Aquarium, um Wasserparameter und die Gesundheit Ihrer Fische zu überwachen.';

  @override
  String get createAquarium => 'Aquarium erstellen';

  @override
  String get noFish => 'Keine Fische';

  @override
  String get noFishDescription =>
      'Fügen Sie Ihre Fische hinzu, um die Population Ihres Aquariums zu verfolgen.';

  @override
  String get addFish => 'Fisch hinzufügen';

  @override
  String get noCoral => 'Keine Koralle';

  @override
  String get noCoralDescription =>
      'Dokumentieren Sie die Korallen in Ihrem Meerwasseraquarium.';

  @override
  String get addCoral => 'Koralle hinzufügen';

  @override
  String get noHistory => 'Kein Verlauf';

  @override
  String get noHistoryDescription =>
      'Noch keine historischen Daten verfügbar. Parameter werden automatisch aufgezeichnet.';

  @override
  String get noTasks => 'Keine Aufgaben';

  @override
  String get noTasksDescription =>
      'Erstellen Sie Erinnerungen für Ihre Aquarienwartungsaktivitäten.';

  @override
  String get createTask => 'Aufgabe Erstellen';

  @override
  String get allOk => 'ALLES OK';

  @override
  String get allOkDescription =>
      'Keine aktiven Alarme. Alle Parameter liegen im Normalbereich.';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String noResultsDescription(String query) {
    return 'Wir konnten keine Ergebnisse für \"$query\" finden.\nVersuchen Sie es mit anderen Suchbegriffen.';
  }

  @override
  String get errorTitle => 'Hoppla!';

  @override
  String get errorDescription => 'Ein Fehler ist aufgetreten';

  @override
  String get retry => 'Wiederholen';

  @override
  String get offline => 'Sie sind offline';

  @override
  String get offlineDescription =>
      'Überprüfen Sie Ihre Internetverbindung und versuchen Sie es erneut.';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String edit(String name) {
    return '$name bearbeiten';
  }

  @override
  String get close => 'Schließen';

  @override
  String get ok => 'OK';

  @override
  String get name => 'Name';

  @override
  String get species => 'Art';

  @override
  String get size => 'Größe';

  @override
  String get notes => 'Notizen';

  @override
  String get date => 'Datum';

  @override
  String get quantity => 'Menge';

  @override
  String get addFishTitle => 'Fisch hinzufügen';

  @override
  String get editFishTitle => 'Fisch bearbeiten';

  @override
  String get fishNameLabel => 'Name *';

  @override
  String get fishNameHint => 'z.B.: Nemo';

  @override
  String get fishSpeciesLabel => 'Art *';

  @override
  String get fishSpeciesHint => 'z.B.: Amphiprion ocellaris';

  @override
  String get fishSizeLabel => 'Größe (cm) *';

  @override
  String get fishSizeHint => 'z.B.: 8.5';

  @override
  String get quantityLabel => 'Menge';

  @override
  String get quantityHint => 'Anzahl der hinzuzufügenden Exemplare';

  @override
  String get quantityInfo =>
      'Wenn Sie mehrere Exemplare hinzufügen, werden diese automatisch nummeriert';

  @override
  String get notesLabel => 'Notizen';

  @override
  String get notesHint => 'Optionale Notizen hinzufügen';

  @override
  String get selectFromList => 'Aus Liste auswählen';

  @override
  String get orEnterManually => 'oder manuell eingeben';

  @override
  String noCompatibleFish(String waterType) {
    return 'Keine Fische kompatibel mit $waterType-Aquarium';
  }

  @override
  String get noDatabaseFish => 'Keine Fische in der Datenbank verfügbar';

  @override
  String get addCoralTitle => 'Koralle hinzufügen';

  @override
  String get editCoralTitle => 'Koralle bearbeiten';

  @override
  String get coralNameLabel => 'Name *';

  @override
  String get coralNameHint => 'z.B.: Orange Montipora';

  @override
  String get coralSpeciesLabel => 'Art *';

  @override
  String get coralSpeciesHint => 'z.B.: Montipora digitata';

  @override
  String get coralTypeLabel => 'Typ *';

  @override
  String get coralSizeLabel => 'Größe (cm) *';

  @override
  String get coralSizeHint => 'z.B.: 5.0';

  @override
  String get coralPlacementLabel => 'Platzierung *';

  @override
  String get coralTypeSPS => 'SPS';

  @override
  String get coralTypeLPS => 'LPS';

  @override
  String get coralTypeSoft => 'Weich';

  @override
  String get placementTop => 'Oben';

  @override
  String get placementMiddle => 'Mitte';

  @override
  String get placementBottom => 'Unten';

  @override
  String get difficultyEasy => 'Einfach';

  @override
  String get difficultyIntermediate => 'Mittel';

  @override
  String get difficultyHard => 'Schwierig';

  @override
  String get difficultyBeginner => 'Anfänger';

  @override
  String get difficultyExpert => 'Experte';

  @override
  String get temperamentPeaceful => 'Friedlich';

  @override
  String get temperamentSemiAggressive => 'Semi-aggressiv';

  @override
  String get temperamentAggressive => 'Aggressiv';

  @override
  String get dietHerbivore => 'Pflanzenfresser';

  @override
  String get dietCarnivore => 'Fleischfresser';

  @override
  String get dietOmnivore => 'Allesfresser';

  @override
  String get reefSafe => 'Riffsicher';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get difficulty => 'Schwierigkeit';

  @override
  String get minTankSize => 'Mindestgröße Becken';

  @override
  String get temperament => 'Temperament';

  @override
  String get diet => 'Ernährung';

  @override
  String get filtersAndSearch => 'Filter und Suche';

  @override
  String get clearAll => 'Alles löschen';

  @override
  String get searchByName => 'Nach Name suchen';

  @override
  String get searchPlaceholder => 'Nach Name suchen...';

  @override
  String get insertionDate => 'Einsetzungsdatum ins Becken';

  @override
  String get selectType => 'Typ auswählen';

  @override
  String get selectDate => 'Datum auswählen';

  @override
  String get removeDateFilter => 'Datumsfilter entfernen';

  @override
  String get sorting => 'Sortierung';

  @override
  String get ascendingOrder => 'Aufsteigende Reihenfolge';

  @override
  String get fillAllFields => 'Füllen Sie alle Pflichtfelder aus';

  @override
  String get invalidSize => 'Ungültige Größe';

  @override
  String get invalidQuantity => 'Ungültige Menge';

  @override
  String databaseLoadError(String error) {
    return 'Datenbankladefehler: $error';
  }

  @override
  String get language => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get tools => 'Werkzeuge';

  @override
  String get calculators => 'Rechner';

  @override
  String get calculatorsSubtitle => 'Volumen, Additivdosierung, Wasserwechsel';

  @override
  String get myInhabitants => 'Meine Bewohner';

  @override
  String get myInhabitantsSubtitle => 'Fische und Korallen verwalten';

  @override
  String get aquariumInfo => 'Aquarium Info';

  @override
  String get aquariumInfoSubtitle => 'Name, Volumen, Typ';

  @override
  String get theme => 'Thema';

  @override
  String get darkMode => 'Dunkler Modus';

  @override
  String get lightMode => 'Heller Modus';

  @override
  String get appInfo => 'App-Informationen';

  @override
  String get appInfoSubtitle => 'Version, Credits';

  @override
  String get noAquariumSelected => 'Kein Aquarium';

  @override
  String unableToLoadInfo(String error) {
    return 'Informationen können nicht geladen werden: $error';
  }

  @override
  String get errorLoadingParameters => 'Fehler beim Laden der Parameter';

  @override
  String get warning => 'WARNUNG';

  @override
  String get critical => 'KRITISCH';

  @override
  String get aquariumStatus => 'Aquarium Status';

  @override
  String updatedNow(int okParams, int totalParams) {
    return 'Jetzt aktualisiert • $okParams/$totalParams Parameter OK';
  }

  @override
  String get temperature => 'Temperatur';

  @override
  String get ph => 'pH';

  @override
  String get salinity => 'Salzgehalt';

  @override
  String get orp => 'ORP';

  @override
  String get excellent => 'Ausgezeichnet';

  @override
  String get good => 'Gut';

  @override
  String get parametersOk => 'Parameter OK';

  @override
  String parametersNeedAttention(int count) {
    return '$count Parameter benötigen Aufmerksamkeit';
  }

  @override
  String get waterChange => 'Wasserwechsel';

  @override
  String get healthScore => 'Gesundheitswert';

  @override
  String parametersInOptimalRange(int okParams, int totalParams) {
    return '$okParams/$totalParams Parameter im optimalen Bereich';
  }

  @override
  String get upcomingReminders => 'Kommende Erinnerungen';

  @override
  String get filterCleaning => 'Filterreinigung';

  @override
  String get parameterTesting => 'Parametertests';

  @override
  String get days => 'Tage';

  @override
  String get recommendations => 'Empfehlungen';

  @override
  String get checkOutOfRangeParameters =>
      'Parameter außerhalb des Bereichs prüfen';

  @override
  String get checkSkimmer => 'Abschäumer prüfen';

  @override
  String get weeklyCleaningRecommended => 'Wöchentliche Reinigung empfohlen';

  @override
  String get khTest => 'KH-Test';

  @override
  String get lastTest3DaysAgo => 'Letzter Test: vor 3 Tagen';

  @override
  String get parametersUpdated => 'Parameter aktualisiert';

  @override
  String get error => 'Fehler';

  @override
  String get noParametersAvailable => 'Keine Parameter verfügbar';

  @override
  String get chemicalParameters => 'Chemische Parameter';

  @override
  String get calciumCa => 'Kalzium (Ca)';

  @override
  String get magnesiumMg => 'Magnesium (Mg)';

  @override
  String get nitratesNO3 => 'Nitrate (NO3)';

  @override
  String get phosphatesPO4 => 'Phosphate (PO4)';

  @override
  String value(String unit) {
    return 'Wert ($unit)';
  }

  @override
  String get low => 'Niedrig';

  @override
  String get high => 'Hoch';

  @override
  String get optimal => 'Optimal';

  @override
  String get attention => 'Achtung';

  @override
  String get monitoring => 'Überwachung';

  @override
  String targetValue(String unit) {
    return 'Zielwert ($unit)';
  }

  @override
  String get current => 'Aktuell';

  @override
  String get target => 'Ziel';

  @override
  String get volumeCalculation => 'Aquarienvolumen Berechnung';

  @override
  String get additivesDosageCalculation => 'Additivdosierung Berechnung';

  @override
  String get waterChangeCalculation => 'Wasserwechsel Berechnung';

  @override
  String get densitySalinityConversion => 'Dichte/Salzgehalt Umrechnung';

  @override
  String get lightingCalculation => 'Beleuchtung Berechnung';

  @override
  String get enterAquariumDimensions =>
      'Geben Sie die Aquarienabmessungen in Zentimetern ein';

  @override
  String get length => 'Länge (cm)';

  @override
  String get width => 'Breite (cm)';

  @override
  String get height => 'Höhe (cm)';

  @override
  String get calculateVolume => 'Volumen berechnen';

  @override
  String get totalVolume => 'Gesamtvolumen';

  @override
  String estimatedNetVolume(String volume) {
    return 'Geschätztes Nettovolumen: $volume L';
  }

  @override
  String get consideringRocksAndSubstrate =>
      '(unter Berücksichtigung von Steinen und Substrat)';

  @override
  String get calculateAdditiveDosage =>
      'Berechnen Sie die zu dosierende Additivmenge';

  @override
  String get dosageSection => '── DOSIERUNG ──';

  @override
  String get reductionSection => '── REDUZIERUNG ──';

  @override
  String get calcium => 'Kalzium';

  @override
  String get magnesium => 'Magnesium';

  @override
  String get kh => 'KH';

  @override
  String get iodine => 'Jod';

  @override
  String get strontium => 'Strontium';

  @override
  String get nitrates => 'Nitrate (NO3)';

  @override
  String get phosphates => 'Phosphate (PO4)';

  @override
  String get no3po4xRedSea => 'NO3:PO4-X (Red Sea)';

  @override
  String get activeCarbon => 'Aktivkohle';

  @override
  String get aquariumVolume => 'Aquarienvolumen (L)';

  @override
  String currentValue(String unit) {
    return 'Aktueller Wert ($unit)';
  }

  @override
  String get calculateDosage => 'Dosierung berechnen';

  @override
  String get quantityToDose => 'Zu dosierende Menge';

  @override
  String get quantityToDoseReduction => 'Zu dosierende Menge (Reduzierung)';

  @override
  String get indicativeValuesCheckManufacturer =>
      '⚠️ Richtwerte: Herstellerangaben prüfen';

  @override
  String get toReduceNitrates =>
      'Zur Reduzierung von Nitraten:\\n• Regelmäßiger Wasserwechsel (20% wöchentlich)\\n• Effizienter Abschäumer\\n• RO-Nachfüllung\\n• Flüssige Aktivkohle\\n• NO3:PO4-X (Red Sea)';

  @override
  String get toReducePhosphates =>
      'Zur Reduzierung von Phosphaten:\\n• Anti-Phosphat-Harze (GFO)\\n• Effizienter Abschäumer\\n• Regelmäßiger Wasserwechsel\\n• NO3:PO4-X (Red Sea)\\n• Überfütterung vermeiden';

  @override
  String get calculateLitersAndSalt =>
      'Berechnen Sie Liter und Salz für den Wasserwechsel';

  @override
  String get percentageToChange => 'Zu wechselnder Prozentsatz (%)';

  @override
  String get calculateWaterChange => 'Wasserwechsel berechnen';

  @override
  String get waterToChange => 'Zu wechselndes Wasser';

  @override
  String get saltNeeded => 'Benötigtes Salz';

  @override
  String get calculatedForSalinity => 'Berechnet für Salzgehalt 1.025 (35g/L)';

  @override
  String get convertBetweenDensityAndSalinity =>
      'Zwischen Dichte und Salzgehalt umrechnen';

  @override
  String get fromDensityToSalinity => 'Von Dichte (g/cm³) zu Salzgehalt (ppt)';

  @override
  String get fromSalinityToDensity => 'Von Salzgehalt (ppt) zu Dichte (g/cm³)';

  @override
  String get densityExample => 'Dichte (z.B.: 1.025)';

  @override
  String get salinityExample => 'Salzgehalt (ppt, z.B.: 35)';

  @override
  String get temperatureCelsius => 'Temperatur (°C)';

  @override
  String get salinityPPT => 'Salzgehalt';

  @override
  String get salinityPPM => 'Salzgehalt (ppm)';

  @override
  String get density => 'Dichte';

  @override
  String get convert => 'Umrechnen';

  @override
  String get calculateLightingRequirements =>
      'Berechnen Sie den Beleuchtungsbedarf für Ihr Aquarium';

  @override
  String get tankType => 'Beckentyp';

  @override
  String get fishOnly => 'Nur Fische';

  @override
  String get fishAndSoftCorals => 'Fische + Weichkorallen';

  @override
  String get spsCorals => 'SPS-Korallen';

  @override
  String get totalWatts => 'Gesamtleistung Beleuchtung (Watt)';

  @override
  String get calculateLighting => 'Beleuchtung berechnen';

  @override
  String get wattsPerLiter => 'Watt pro Liter';

  @override
  String get recommendation => 'Empfehlung';

  @override
  String get insufficientMinimumFish =>
      'Unzureichend - Minimum 0,25 W/L für Fische';

  @override
  String get optimalForFishOnly => 'Optimal für reines Fischbecken';

  @override
  String get excessiveAlgaeRisk => 'Übermäßig - Algenrisiko';

  @override
  String get insufficientMinimumSoft => 'Unzureichend - Minimum 0,5 W/L';

  @override
  String get optimalForSoftCorals => 'Optimal für Weichkorallen (LPS)';

  @override
  String get veryGoodAlsoSPS => 'Sehr gut - Auch für SPS geeignet';

  @override
  String get insufficientMinimumSPS => 'Unzureichend - Minimum 1,0 W/L für SPS';

  @override
  String get optimalForSPS => 'Optimal für SPS-Korallen';

  @override
  String get veryPowerfulExcellentSPS =>
      'Sehr leistungsstark - Ausgezeichnet für anspruchsvolle SPS';

  @override
  String get acceptable => 'Akzeptabel';

  @override
  String get toCorrect => 'Zu korrigieren';

  @override
  String get targetTemperature => 'Zieltemperatur';

  @override
  String get setDesiredTemperature => 'Gewünschte Temperatur einstellen:';

  @override
  String get typicalRangeTemperature => 'Typischer Bereich: 24-26 °C';

  @override
  String get targetSalinity => 'Zielsalzgehalt';

  @override
  String get setDesiredSalinity => 'Gewünschten Salzgehalt einstellen:';

  @override
  String get typicalRangeSalinity => 'Typischer Bereich: 1020-1028';

  @override
  String get targetPh => 'Ziel-pH';

  @override
  String get setDesiredPh => 'Gewünschten pH-Wert einstellen:';

  @override
  String get typicalRangePh => 'Typischer Bereich: 8.0-8.4';

  @override
  String get targetOrp => 'Ziel-ORP';

  @override
  String get setDesiredOrp => 'Gewünschten ORP-Wert einstellen:';

  @override
  String get typicalRangeOrp => 'Typischer Bereich: 300-400 mV';

  @override
  String get newAquarium => 'Neues Aquarium';

  @override
  String get createNewAquarium => 'Neues Aquarium Erstellen';

  @override
  String get fillTankDetails => 'Füllen Sie die Tank-Details aus';

  @override
  String get aquariumName => 'Aquarium Name';

  @override
  String get aquariumNameHint => 'z.B. Mein Tank';

  @override
  String get enterName => 'Geben Sie einen Namen ein';

  @override
  String get aquariumType => 'Aquarium Typ';

  @override
  String get marine => 'Meer';

  @override
  String get freshwater => 'Süßwasser';

  @override
  String get reef => 'Riff';

  @override
  String get volumeLiters => 'Volumen (Liter)';

  @override
  String get volumeHint => 'z.B. 200';

  @override
  String get enterVolume => 'Geben Sie das Volumen ein';

  @override
  String get saveAquarium => 'Aquarium Speichern';

  @override
  String aquariumCreatedSuccess(String name) {
    return 'Aquarium \"$name\" erfolgreich erstellt!';
  }

  @override
  String get deleteAquarium => 'Aquarium Löschen';

  @override
  String errorLoading(String error) {
    return 'Ladefehler: $error';
  }

  @override
  String get cannotDeleteMissingId =>
      'Löschen nicht möglich: Aquarium-ID fehlt';

  @override
  String confirmDeleteAquarium(String name) {
    return 'Sind Sie sicher, dass Sie \'$name\' löschen möchten?';
  }

  @override
  String get actionCannotBeUndone =>
      'Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get aquariumDeletedSuccess => 'Aquarium erfolgreich gelöscht';

  @override
  String errorWithMessage(String message) {
    return 'Fehler: $message';
  }

  @override
  String get noAquariumsToDelete => 'Keine Aquarien zum Löschen';

  @override
  String get aquariumManagement => 'Aquarienverwaltung';

  @override
  String get selectToDelete => 'Wählen Sie ein Aquarium zum Löschen aus';

  @override
  String get editAquarium => 'Aquarium bearbeiten';

  @override
  String get selectAquarium => 'Aquarium Auswählen';

  @override
  String get chooseAquariumToEdit => 'Wählen Sie ein Aquarium zum Bearbeiten';

  @override
  String get noAquariumsFound => 'Keine Tanks gefunden';

  @override
  String get editDetails => 'Details bearbeiten';

  @override
  String updateAquarium(String name) {
    return '$name aktualisieren';
  }

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String changesSavedFor(String name) {
    return 'Änderungen gespeichert für \"$name\"';
  }

  @override
  String errorSavingChanges(String error) {
    return 'Fehler beim Speichern der Änderungen: $error';
  }

  @override
  String chartHistoryTitle(String parameter) {
    return 'Historie $parameter';
  }

  @override
  String get chartNoData => 'Keine Daten verfügbar';

  @override
  String get chartStatMin => 'Min';

  @override
  String get chartStatAvg => 'Durchschn.';

  @override
  String get chartStatMax => 'Max';

  @override
  String get chartStatNow => 'Jetzt';

  @override
  String get chartLegendIdeal => 'Ideal';

  @override
  String get chartLegendWarning => 'Warnung';

  @override
  String get chartAdvancedAnalysis => 'Erweiterte Analyse';

  @override
  String get chartTrendLabel => 'Trend';

  @override
  String get chartStabilityLabel => 'Stabilität';

  @override
  String get chartTrendStable => 'Stabil';

  @override
  String get chartTrendRising => 'Steigend';

  @override
  String get chartTrendFalling => 'Fallend';

  @override
  String get chartStabilityExcellent => 'Ausgezeichnet';

  @override
  String get chartStabilityGood => 'Gut';

  @override
  String get chartStabilityMedium => 'Mittel';

  @override
  String get chartStabilityLow => 'Niedrig';

  @override
  String chartAdviceOutOfRange(String parameter) {
    return 'Achtung: $parameter außerhalb des Bereichs. Sofort überprüfen und korrigieren.';
  }

  @override
  String get chartAdviceNotIdeal =>
      'Parameter akzeptabel, aber nicht ideal. Sorgfältig überwachen.';

  @override
  String get chartAdviceUnstable =>
      'Parameter instabil. Wasserwechsel und Zusatzdosierung überprüfen.';

  @override
  String get chartAdviceTempRising =>
      'Temperatur steigt. Kühlung und Belüftung überprüfen.';

  @override
  String get chartAdviceOptimal => 'Optimaler und stabiler Parameter.';

  @override
  String get paramTemperature => 'Temperatur';

  @override
  String get paramPH => 'pH';

  @override
  String get paramSalinity => 'Salzgehalt';

  @override
  String get paramORP => 'ORP';

  @override
  String errorLoadingTasks(String error) {
    return 'Fehler beim Laden von Aufgaben: $error';
  }

  @override
  String get addTask => 'Aufgabe Hinzufügen';

  @override
  String inProgress(int count) {
    return 'In Bearbeitung ($count)';
  }

  @override
  String completed(int count) {
    return 'Abgeschlossen ($count)';
  }

  @override
  String get overdue => 'Überfällig';

  @override
  String get today => 'Heute';

  @override
  String get week => 'Woche';

  @override
  String get all => 'Alle';

  @override
  String get noCompletedTasks => 'Keine abgeschlossenen Aufgaben';

  @override
  String get noTasksInProgress => 'Keine Aufgaben in Bearbeitung';

  @override
  String overdueDays(int days) {
    return 'Überfällig um $days Tage';
  }

  @override
  String get dueToday => 'Heute fällig';

  @override
  String inDays(int days) {
    return 'In $days Tagen';
  }

  @override
  String completedOn(String date) {
    return 'Abgeschlossen: $date';
  }

  @override
  String get newTask => 'Neue Aufgabe';

  @override
  String get taskTitle => 'Aufgabentitel';

  @override
  String get taskDescription => 'Beschreibung (optional)';

  @override
  String get category => 'Kategorie';

  @override
  String get frequency => 'Häufigkeit';

  @override
  String everyDays(int days) {
    return 'Alle $days Tage';
  }

  @override
  String get reminder => 'Erinnerung';

  @override
  String get enabled => 'Aktiviert';

  @override
  String get disabled => 'Deaktiviert';

  @override
  String get time => 'Zeit';

  @override
  String get enterTaskTitle => 'Geben Sie einen Titel ein';

  @override
  String get water => 'Wasser';

  @override
  String get cleaning => 'Reinigung';

  @override
  String get testing => 'Testen';

  @override
  String get feeding => 'Fütterung';

  @override
  String get equipment => 'Ausrüstung';

  @override
  String get other => 'Andere';

  @override
  String get createCustomMaintenance =>
      'Erstellen Sie eine benutzerdefinierte Wartung';

  @override
  String get day => 'Tag';

  @override
  String get enableReminder => 'Erinnerung aktivieren';

  @override
  String get at => 'Um';

  @override
  String get noReminder => 'Keine Erinnerung';

  @override
  String changeTime(String time) {
    return 'Zeit ändern ($time)';
  }

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get settingsSaved => 'Einstellungen gespeichert';

  @override
  String get settingsTab => 'Einstellungen';

  @override
  String get thresholdsTab => 'Schwellenwerte';

  @override
  String get historyTab => 'Verlauf';

  @override
  String get alertParameters => 'Parameterwarnungen';

  @override
  String get alertParametersSubtitle =>
      'Benachrichtigungen, wenn Parameter außerhalb des Bereichs liegen';

  @override
  String get maintenanceReminders => 'Wartungserinnerungen';

  @override
  String get maintenanceRemindersSubtitle =>
      'Benachrichtigungen für Wasserwechsel, Filterreinigung usw.';

  @override
  String get dailySummary => 'Tägliche Zusammenfassung';

  @override
  String get dailySummarySubtitle =>
      'Tägliche Benachrichtigung mit Aquariumstatus';

  @override
  String get maintenanceFrequency => 'Wartungshäufigkeit';

  @override
  String get resetDefaults => 'Standardwerte Wiederherstellen';

  @override
  String get parameterThresholds => 'Parameterschwellenwerte';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get alertHistory => 'Warnungsverlauf';

  @override
  String recentNotifications(int count) {
    return '$count aktuelle Benachrichtigungen';
  }

  @override
  String get noNotificationsYet => 'Noch keine Benachrichtigungen';

  @override
  String get resetDefaultsQuestion => 'Auf Standardwerte zurücksetzen?';

  @override
  String get resetDefaultsMessage =>
      'Diese Aktion setzt alle benutzerdefinierten Schwellenwerte auf die Standardwerte zurück:';

  @override
  String get resetButton => 'Zurücksetzen';
}
