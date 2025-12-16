// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'ReefLife';

  @override
  String get aquariums => 'Acquari';

  @override
  String get aquarium => 'Acquario';

  @override
  String get parameters => 'Parametri';

  @override
  String get fish => 'Pesci';

  @override
  String get fishes => 'Pesci';

  @override
  String get corals => 'Coralli';

  @override
  String get coral => 'Corallo';

  @override
  String get maintenance => 'Manutenzione';

  @override
  String get alerts => 'Alert';

  @override
  String get settings => 'Impostazioni';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get charts => 'Grafici';

  @override
  String get profile => 'Profilo';

  @override
  String get myAquarium => 'La Mia Vasca';

  @override
  String get noAquarium => 'Nessun Acquario';

  @override
  String get noAquariumDescription =>
      'Inizia creando il tuo primo acquario per monitorare i parametri dell\'acqua e la salute dei tuoi pesci.';

  @override
  String get createAquarium => 'Crea Acquario';

  @override
  String get noFish => 'Nessun Pesce';

  @override
  String get noFishDescription =>
      'Aggiungi i tuoi pesci per tenere traccia della popolazione del tuo acquario.';

  @override
  String get addFish => 'Aggiungi Pesce';

  @override
  String get noCoral => 'Nessun Corallo';

  @override
  String get noCoralDescription =>
      'Documenta i coralli presenti nel tuo acquario marino.';

  @override
  String get addCoral => 'Aggiungi Corallo';

  @override
  String get noHistory => 'Nessuno Storico';

  @override
  String get noHistoryDescription =>
      'Non ci sono ancora dati storici disponibili. I parametri verranno registrati automaticamente.';

  @override
  String get noTasks => 'Nessun Task';

  @override
  String get noTasksDescription =>
      'Crea promemoria per le attività di manutenzione del tuo acquario.';

  @override
  String get createTask => 'Crea Task';

  @override
  String get allOk => 'TUTTO OK';

  @override
  String get allOkDescription =>
      'Non ci sono alert attivi. Tutti i parametri sono nella norma.';

  @override
  String get noResults => 'Nessun Risultato';

  @override
  String noResultsDescription(String query) {
    return 'Non abbiamo trovato risultati per \"$query\".\nProva con parole chiave diverse.';
  }

  @override
  String get errorTitle => 'Ops!';

  @override
  String get errorDescription => 'Si è verificato un errore';

  @override
  String get retry => 'Riprova';

  @override
  String get offline => 'Sei Offline';

  @override
  String get offlineDescription =>
      'Verifica la tua connessione internet e riprova.';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get edit => 'Modifica';

  @override
  String get close => 'Chiudi';

  @override
  String get ok => 'OK';

  @override
  String get name => 'Nome';

  @override
  String get species => 'Specie';

  @override
  String get size => 'Dimensione';

  @override
  String get notes => 'Note';

  @override
  String get date => 'Data';

  @override
  String get quantity => 'Quantità';

  @override
  String get addFishTitle => 'Aggiungi Pesce';

  @override
  String get editFishTitle => 'Modifica Pesce';

  @override
  String get fishNameLabel => 'Nome *';

  @override
  String get fishNameHint => 'es: Nemo';

  @override
  String get fishSpeciesLabel => 'Specie *';

  @override
  String get fishSpeciesHint => 'es: Amphiprion ocellaris';

  @override
  String get fishSizeLabel => 'Dimensione (cm) *';

  @override
  String get fishSizeHint => 'es: 8.5';

  @override
  String get quantityLabel => 'Quantità';

  @override
  String get quantityHint => 'Numero di esemplari da aggiungere';

  @override
  String get quantityInfo =>
      'Se aggiungi più esemplari, verranno numerati automaticamente';

  @override
  String get notesLabel => 'Note';

  @override
  String get notesHint => 'Aggiungi note opzionali';

  @override
  String get selectFromList => 'Seleziona dalla lista';

  @override
  String get orEnterManually => 'oppure inserisci manualmente';

  @override
  String noCompatibleFish(String waterType) {
    return 'Nessun pesce compatibile con acquario $waterType';
  }

  @override
  String get noDatabaseFish => 'Nessun pesce disponibile nel database';

  @override
  String get addCoralTitle => 'Aggiungi Corallo';

  @override
  String get editCoralTitle => 'Modifica Corallo';

  @override
  String get coralNameLabel => 'Nome *';

  @override
  String get coralNameHint => 'es: Montipora arancione';

  @override
  String get coralSpeciesLabel => 'Specie *';

  @override
  String get coralSpeciesHint => 'es: Montipora digitata';

  @override
  String get coralTypeLabel => 'Tipo *';

  @override
  String get coralSizeLabel => 'Dimensione (cm) *';

  @override
  String get coralSizeHint => 'es: 5.0';

  @override
  String get coralPlacementLabel => 'Posizionamento *';

  @override
  String get coralTypeSPS => 'SPS';

  @override
  String get coralTypeLPS => 'LPS';

  @override
  String get coralTypeSoft => 'Molle';

  @override
  String get placementTop => 'Alto';

  @override
  String get placementMiddle => 'Medio';

  @override
  String get placementBottom => 'Basso';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyIntermediate => 'Intermedio';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String get difficultyBeginner => 'Principiante';

  @override
  String get difficultyExpert => 'Esperto';

  @override
  String get temperamentPeaceful => 'Pacifico';

  @override
  String get temperamentSemiAggressive => 'Semi-aggressivo';

  @override
  String get temperamentAggressive => 'Aggressivo';

  @override
  String get dietHerbivore => 'Erbivoro';

  @override
  String get dietCarnivore => 'Carnivoro';

  @override
  String get dietOmnivore => 'Onnivoro';

  @override
  String get reefSafe => 'Reef-safe';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get difficulty => 'Difficoltà';

  @override
  String get minTankSize => 'Vasca minima';

  @override
  String get temperament => 'Temperamento';

  @override
  String get diet => 'Dieta';

  @override
  String get filtersAndSearch => 'Filtri e Ricerca';

  @override
  String get clearAll => 'Cancella tutto';

  @override
  String get searchByName => 'Ricerca per nome';

  @override
  String get searchPlaceholder => 'Cerca per nome...';

  @override
  String get insertionDate => 'Data inserimento in vasca';

  @override
  String get selectType => 'Seleziona tipo';

  @override
  String get selectDate => 'Seleziona data';

  @override
  String get removeDateFilter => 'Rimuovi filtro data';

  @override
  String get sorting => 'Ordinamento';

  @override
  String get ascendingOrder => 'Ordine crescente';

  @override
  String get fillAllFields => 'Compila tutti i campi obbligatori';

  @override
  String get invalidSize => 'Dimensione non valida';

  @override
  String get invalidQuantity => 'Quantità non valida';

  @override
  String databaseLoadError(String error) {
    return 'Errore caricamento database: $error';
  }

  @override
  String get language => 'Lingua';

  @override
  String get selectLanguage => 'Seleziona lingua';

  @override
  String get tools => 'Strumenti';

  @override
  String get calculators => 'Calcolatori';

  @override
  String get calculatorsSubtitle => 'Volume, dosaggio additivi, cambio acqua';

  @override
  String get myInhabitants => 'I Miei Abitanti';

  @override
  String get myInhabitantsSubtitle => 'Gestisci pesci e coralli';

  @override
  String get inhabitantsSummary => 'Riepilogo Abitanti';

  @override
  String get aquariumInfo => 'Info Acquario';

  @override
  String get aquariumInfoSubtitle => 'Nome, volume, tipo';

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Modalità scura';

  @override
  String get lightMode => 'Modalità chiara';

  @override
  String get appInfo => 'Informazioni App';

  @override
  String get appInfoSubtitle => 'Versione, crediti';

  @override
  String get noAquariumSelected => 'Nessun Acquario';

  @override
  String unableToLoadInfo(String error) {
    return 'Impossibile caricare le informazioni: $error';
  }

  @override
  String get errorLoadingParameters => 'Errore nel caricamento parametri';

  @override
  String get warning => 'ATTENZIONE';

  @override
  String get critical => 'CRITICO';

  @override
  String get aquariumStatus => 'Stato Acquario';

  @override
  String updatedNow(int okParams, int totalParams) {
    return 'Aggiornato ora • $okParams/$totalParams parametri OK';
  }

  @override
  String get temperature => 'Temperatura';

  @override
  String get ph => 'pH';

  @override
  String get salinity => 'Salinità';

  @override
  String get orp => 'ORP';

  @override
  String get excellent => 'Eccellente';

  @override
  String get good => 'Buono';

  @override
  String get parametersOk => 'Parametri OK';

  @override
  String parametersNeedAttention(int count) {
    return '$count parametri necessitano attenzione';
  }

  @override
  String get waterChange => 'Cambio Acqua';

  @override
  String get healthScore => 'Health Score';

  @override
  String parametersInOptimalRange(int okParams, int totalParams) {
    return '$okParams/$totalParams parametri nel range ottimale';
  }

  @override
  String get upcomingReminders => 'Prossimi Promemoria';

  @override
  String get filterCleaning => 'Pulizia Filtro';

  @override
  String get parameterTesting => 'Test Parametri';

  @override
  String get days => 'giorni';

  @override
  String get recommendations => 'Raccomandazioni';

  @override
  String get checkOutOfRangeParameters => 'Controllare parametri fuori range';

  @override
  String get checkSkimmer => 'Controllare skimmer';

  @override
  String get weeklyCleaningRecommended => 'Pulizia settimanale consigliata';

  @override
  String get khTest => 'Test KH';

  @override
  String get lastTest3DaysAgo => 'Ultimo test: 3 giorni fa';

  @override
  String get parametersUpdated => 'Parametri aggiornati';

  @override
  String get error => 'Errore';

  @override
  String get noParametersAvailable => 'Nessun parametro disponibile';

  @override
  String get chemicalParameters => 'Parametri Chimici';

  @override
  String get calciumCa => 'Calcio (Ca)';

  @override
  String get magnesiumMg => 'Magnesio (Mg)';

  @override
  String get nitratesNO3 => 'Nitrati (NO3)';

  @override
  String get phosphatesPO4 => 'Fosfati (PO4)';

  @override
  String editParameter(String name) {
    return 'Modifica $name';
  }

  @override
  String value(String unit) {
    return 'Valore ($unit)';
  }

  @override
  String get low => 'Bassa';

  @override
  String get high => 'Alta';

  @override
  String get optimal => 'Ottimale';

  @override
  String get attention => 'Attenzione';

  @override
  String get monitoring => 'Monitoraggio';

  @override
  String targetValue(String unit) {
    return 'Valore target ($unit)';
  }

  @override
  String get current => 'Attuale';

  @override
  String get target => 'Target';

  @override
  String get volumeCalculation => 'Calcolo Volume Acquario';

  @override
  String get additivesDosageCalculation => 'Calcolo Dosaggio Additivi';

  @override
  String get waterChangeCalculation => 'Calcolo Cambio Acqua';

  @override
  String get densitySalinityConversion => 'Conversione Densità/Salinità';

  @override
  String get lightingCalculation => 'Calcolo Illuminazione';

  @override
  String get enterAquariumDimensions =>
      'Inserisci le dimensioni dell\'acquario in centimetri';

  @override
  String get length => 'Lunghezza (cm)';

  @override
  String get width => 'Larghezza (cm)';

  @override
  String get height => 'Altezza (cm)';

  @override
  String get calculateVolume => 'Calcola Volume';

  @override
  String get totalVolume => 'Volume Totale';

  @override
  String estimatedNetVolume(String volume) {
    return 'Volume netto stimato: $volume L';
  }

  @override
  String get consideringRocksAndSubstrate => '(considerando rocce e substrato)';

  @override
  String get calculateAdditiveDosage =>
      'Calcola la quantità di additivo da dosare';

  @override
  String get dosageSection => '── DOSAGGIO ──';

  @override
  String get reductionSection => '── RIDUZIONE ──';

  @override
  String get calcium => 'Calcio';

  @override
  String get magnesium => 'Magnesio';

  @override
  String get kh => 'KH';

  @override
  String get iodine => 'Iodio';

  @override
  String get strontium => 'Stronzio';

  @override
  String get nitrates => 'Nitrati (NO3)';

  @override
  String get phosphates => 'Fosfati (PO4)';

  @override
  String get no3po4xRedSea => 'NO3:PO4-X (Red Sea)';

  @override
  String get activeCarbon => 'Carbonio Attivo';

  @override
  String get aquariumVolume => 'Volume acquario (L)';

  @override
  String currentValue(String unit) {
    return 'Valore attuale ($unit)';
  }

  @override
  String get calculateDosage => 'Calcola Dosaggio';

  @override
  String get quantityToDose => 'Quantità da dosare';

  @override
  String get quantityToDoseReduction => 'Quantità da dosare (riduzione)';

  @override
  String get indicativeValuesCheckManufacturer =>
      '⚠️ Valori indicativi: verifica le istruzioni del produttore';

  @override
  String get toReduceNitrates =>
      'Per ridurre i Nitrati:\\n• Cambio acqua regolare (20% settimanale)\\n• Skimmer efficiente\\n• Refill osmosi\\n• Carbonio attivo liquido\\n• NO3:PO4-X (Red Sea)';

  @override
  String get toReducePhosphates =>
      'Per ridurre i Fosfati:\\n• Resine anti-fosfati (GFO)\\n• Skimmer efficiente\\n• Cambio acqua regolare\\n• NO3:PO4-X (Red Sea)\\n• Evitare sovralimentazione';

  @override
  String get calculateLitersAndSalt =>
      'Calcola litri e sale necessario per il cambio acqua';

  @override
  String get percentageToChange => 'Percentuale da cambiare (%)';

  @override
  String get calculateWaterChange => 'Calcola Cambio Acqua';

  @override
  String get waterToChange => 'Acqua da cambiare';

  @override
  String get saltNeeded => 'Sale necessario';

  @override
  String get calculatedForSalinity => 'Calcolato per salinità 1.025 (35g/L)';

  @override
  String get convertBetweenDensityAndSalinity =>
      'Converti tra densità e salinità';

  @override
  String get fromDensityToSalinity => 'Da Densità (g/cm³) a Salinità (ppt)';

  @override
  String get fromSalinityToDensity => 'Da Salinità (ppt) a Densità (g/cm³)';

  @override
  String get densityExample => 'Densità (es: 1.025)';

  @override
  String get salinityExample => 'Salinità (ppt, es: 35)';

  @override
  String get temperatureCelsius => 'Temperatura (°C)';

  @override
  String get salinityPPT => 'Salinità';

  @override
  String get salinityPPM => 'Salinità (ppm)';

  @override
  String get density => 'Densità';

  @override
  String get convert => 'Converti';

  @override
  String get calculateLightingRequirements =>
      'Calcola il fabbisogno di illuminazione per il tuo acquario';

  @override
  String get tankType => 'Tipo di vasca';

  @override
  String get fishOnly => 'Solo Pesci';

  @override
  String get fishAndSoftCorals => 'Pesci + Coralli Molli (LPS)';

  @override
  String get spsCorals => 'Coralli SPS';

  @override
  String get totalWatts => 'Watt totali illuminazione';

  @override
  String get calculateLighting => 'Calcola Illuminazione';

  @override
  String get wattsPerLiter => 'Watt per Litro';

  @override
  String get recommendation => 'Raccomandazione';

  @override
  String get insufficientMinimumFish =>
      'Insufficiente - Minimo 0.25 W/L per pesci';

  @override
  String get optimalForFishOnly => 'Ottimale per vasca di soli pesci';

  @override
  String get excessiveAlgaeRisk => 'Eccessivo - Rischio alghe';

  @override
  String get insufficientMinimumSoft => 'Insufficiente - Minimo 0.5 W/L';

  @override
  String get optimalForSoftCorals => 'Ottimale per coralli molli (LPS)';

  @override
  String get veryGoodAlsoSPS => 'Molto buono - Adatto anche SPS';

  @override
  String get insufficientMinimumSPS => 'Insufficiente - Minimo 1.0 W/L per SPS';

  @override
  String get optimalForSPS => 'Ottimale per coralli SPS';

  @override
  String get veryPowerfulExcellentSPS =>
      'Molto potente - Ottimo per SPS esigenti';

  @override
  String get acceptable => 'Accettabile';

  @override
  String get toCorrect => 'Da correggere';

  @override
  String get targetTemperature => 'Target Temperatura';

  @override
  String get setDesiredTemperature => 'Imposta la temperatura desiderata:';

  @override
  String get typicalRangeTemperature => 'Range tipico: 24-26 °C';

  @override
  String get targetSalinity => 'Target Salinità';

  @override
  String get setDesiredSalinity => 'Imposta il valore di salinità desiderato:';

  @override
  String get typicalRangeSalinity => 'Range tipico: 1020-1028';

  @override
  String get targetPh => 'Target pH';

  @override
  String get setDesiredPh => 'Imposta il valore pH desiderato:';

  @override
  String get typicalRangePh => 'Range tipico: 8.0-8.4';

  @override
  String get targetOrp => 'Target ORP';

  @override
  String get setDesiredOrp => 'Imposta il valore ORP desiderato:';

  @override
  String get typicalRangeOrp => 'Range tipico: 300-400 mV';

  @override
  String get newAquarium => 'Nuovo Acquario';

  @override
  String get createNewAquarium => 'Crea Nuovo Acquario';

  @override
  String get fillTankDetails => 'Compila i dettagli della vasca';

  @override
  String get aquariumName => 'Nome Acquario';

  @override
  String get aquariumNameHint => 'es. La Mia Vasca';

  @override
  String get enterName => 'Inserisci un nome';

  @override
  String get aquariumType => 'Tipo Acquario';

  @override
  String get marine => 'Marino';

  @override
  String get freshwater => 'Dolce';

  @override
  String get reef => 'Reef';

  @override
  String get volumeLiters => 'Volume (Litri)';

  @override
  String get volumeHint => 'es. 200';

  @override
  String get enterVolume => 'Inserisci il volume';

  @override
  String get saveAquarium => 'Salva Acquario';

  @override
  String aquariumCreatedSuccess(String name) {
    return 'Acquario \"$name\" creato con successo!';
  }

  @override
  String get deleteAquarium => 'Elimina Acquario';

  @override
  String errorLoading(String error) {
    return 'Errore nel caricamento: $error';
  }

  @override
  String get cannotDeleteMissingId =>
      'Impossibile eliminare: ID acquario mancante';

  @override
  String confirmDeleteAquarium(String name) {
    return 'Sei sicuro di voler eliminare \'$name\'?';
  }

  @override
  String get actionCannotBeUndone => 'Questa azione non può essere annullata.';

  @override
  String get aquariumDeletedSuccess => 'Acquario eliminato con successo';

  @override
  String errorWithMessage(String message) {
    return 'Errore: $message';
  }

  @override
  String get noAquariumsToDelete => 'Nessun acquario da eliminare';

  @override
  String get aquariumManagement => 'Gestione Acquari';

  @override
  String get selectToDelete => 'Seleziona un acquario da eliminare';

  @override
  String get editAquarium => 'Modifica Acquario';

  @override
  String get selectAquarium => 'Seleziona Acquario';

  @override
  String get chooseAquariumToEdit => 'Scegli un acquario da modificare';

  @override
  String get noAquariumsFound => 'Nessuna vasca trovata';

  @override
  String get editDetails => 'Modifica Dettagli';

  @override
  String updateAquarium(String name) {
    return 'Aggiorna $name';
  }

  @override
  String get saveChanges => 'Salva Modifiche';

  @override
  String changesSavedFor(String name) {
    return 'Modifiche salvate per \"$name\"';
  }

  @override
  String errorSavingChanges(String error) {
    return 'Errore nel salvare le modifiche: $error';
  }

  @override
  String chartHistoryTitle(String parameter) {
    return 'Storico $parameter';
  }

  @override
  String get chartNoData => 'Nessun dato disponibile';

  @override
  String get chartStatMin => 'Min';

  @override
  String get chartStatAvg => 'Avg';

  @override
  String get chartStatMax => 'Max';

  @override
  String get chartStatNow => 'Now';

  @override
  String get chartLegendIdeal => 'Ideale';

  @override
  String get chartLegendWarning => 'Avviso';

  @override
  String get chartAdvancedAnalysis => 'Analisi Avanzata';

  @override
  String get chartTrendLabel => 'Trend';

  @override
  String get chartStabilityLabel => 'Stabilità';

  @override
  String get chartTrendStable => 'Stabile';

  @override
  String get chartTrendRising => 'In aumento';

  @override
  String get chartTrendFalling => 'In calo';

  @override
  String get chartStabilityExcellent => 'Ottima';

  @override
  String get chartStabilityGood => 'Buona';

  @override
  String get chartStabilityMedium => 'Media';

  @override
  String get chartStabilityLow => 'Bassa';

  @override
  String chartAdviceOutOfRange(String parameter) {
    return 'Attenzione: $parameter fuori range. Controlla subito e correggi.';
  }

  @override
  String get chartAdviceNotIdeal =>
      'Parametro accettabile ma non ideale. Monitora attentamente.';

  @override
  String get chartAdviceUnstable =>
      'Parametro instabile. Verifica cambio acqua e dosaggi additivi.';

  @override
  String get chartAdviceTempRising =>
      'Temperatura in aumento. Verifica raffreddamento e ventilazione.';

  @override
  String get chartAdviceOptimal => 'Parametro ottimale e stabile.';

  @override
  String get paramTemperature => 'Temperatura';

  @override
  String get paramPH => 'pH';

  @override
  String get paramSalinity => 'Salinità';

  @override
  String get paramORP => 'ORP';

  @override
  String get warningIndicativeValues =>
      '⚠️ Valori indicativi: verifica le istruzioni del produttore';

  @override
  String get nitratesReductionAdvice =>
      'Per ridurre i Nitrati:\n• Cambio acqua regolare (20% settimanale)\n• Skimmer efficiente\n• Refill osmosi\n• Carbonio attivo liquido\n• NO3:PO4-X (Red Sea)';

  @override
  String get phosphatesReductionAdvice =>
      'Per ridurre i Fosfati:\n• Resine anti-fosfati (GFO)\n• Skimmer efficiente\n• Cambio acqua regolare\n• NO3:PO4-X (Red Sea)\n• Evitare sovralimentazione';

  @override
  String get calculateWaterAndSalt =>
      'Calcola litri e sale necessario per il cambio acqua';

  @override
  String get aquariumVolumeL => 'Volume acquario (L)';

  @override
  String get changePercentage => 'Percentuale cambio (%)';

  @override
  String get calculate => 'Calcola';

  @override
  String get salinityLabel => 'Salinità';

  @override
  String get densityLabel => 'Densità';

  @override
  String get indicativeValuesRefractometer =>
      'Valori indicativi - Usare rifrattometro per misure precise';

  @override
  String get calculateWattsPerLiter =>
      'Calcola il rapporto watt/litro ottimale';

  @override
  String get lightPowerW => 'Potenza luci (W)';

  @override
  String get recommendedPhotoperiod =>
      'Fotoperiodo consigliato: 8-10 ore/giorno';

  @override
  String get lightInsufficientFishOnly =>
      'Insufficiente - Minimo 0.25 W/L per pesci';

  @override
  String get lightOptimalFishOnly => 'Ottimale per vasca di soli pesci';

  @override
  String get lightExcessiveAlgaeRisk => 'Eccessivo - Rischio alghe';

  @override
  String get lightInsufficientSoftCorals => 'Insufficiente - Minimo 0.5 W/L';

  @override
  String get lightOptimalSoftCorals => 'Ottimale per coralli molli (LPS)';

  @override
  String get lightVeryGoodSPS => 'Molto buono - Adatto anche SPS';

  @override
  String get lightInsufficientSPS => 'Insufficiente - Minimo 1.0 W/L per SPS';

  @override
  String get lightOptimalSPS => 'Ottimale per coralli SPS';

  @override
  String get lightVeryPowerfulSPS => 'Molto potente - Ottimo per SPS esigenti';

  @override
  String errorLoadingTasks(String error) {
    return 'Errore caricamento task: $error';
  }

  @override
  String get addTask => 'Aggiungi Task';

  @override
  String inProgress(int count) {
    return 'In Corso ($count)';
  }

  @override
  String completed(int count) {
    return 'Completati ($count)';
  }

  @override
  String get overdue => 'In Ritardo';

  @override
  String get today => 'Oggi';

  @override
  String get week => 'Settimana';

  @override
  String get all => 'Tutti';

  @override
  String get noCompletedTasks => 'Nessun task completato';

  @override
  String get noTasksInProgress => 'Nessun task in corso';

  @override
  String overdueDays(int days) {
    return 'In ritardo di $days giorni';
  }

  @override
  String get dueToday => 'Scade oggi';

  @override
  String inDays(int days) {
    return 'Tra $days giorni';
  }

  @override
  String completedOn(String date) {
    return 'Completato: $date';
  }

  @override
  String get newTask => 'Nuovo Task';

  @override
  String get taskTitle => 'Titolo Task';

  @override
  String get taskDescription => 'Descrizione (opzionale)';

  @override
  String get category => 'Categoria';

  @override
  String get frequency => 'Frequenza';

  @override
  String everyDays(int days) {
    return 'Ogni $days giorni';
  }

  @override
  String get reminder => 'Promemoria';

  @override
  String get enabled => 'Abilitato';

  @override
  String get disabled => 'Disabilitato';

  @override
  String get time => 'Orario';

  @override
  String get enterTaskTitle => 'Inserisci un titolo';

  @override
  String get water => 'Acqua';

  @override
  String get cleaning => 'Pulizia';

  @override
  String get testing => 'Test';

  @override
  String get feeding => 'Alimentazione';

  @override
  String get equipment => 'Attrezzatura';

  @override
  String get other => 'Altro';

  @override
  String get createCustomMaintenance => 'Crea una manutenzione personalizzata';

  @override
  String get day => 'giorno';

  @override
  String get enableReminder => 'Abilita promemoria';

  @override
  String get at => 'Alle';

  @override
  String get noReminder => 'Nessun promemoria';

  @override
  String changeTime(String time) {
    return 'Cambia orario ($time)';
  }

  @override
  String get notifications => 'Notifiche';

  @override
  String get settingsSaved => 'Impostazioni salvate';

  @override
  String get settingsTab => 'Impostazioni';

  @override
  String get thresholdsTab => 'Soglie';

  @override
  String get historyTab => 'Storico';

  @override
  String get alertParameters => 'Alert Parametri';

  @override
  String get alertParametersSubtitle =>
      'Notifiche quando i parametri sono fuori range';

  @override
  String get maintenanceReminders => 'Promemoria Manutenzione';

  @override
  String get maintenanceRemindersSubtitle =>
      'Notifiche per cambio acqua, pulizia filtro, ecc.';

  @override
  String get dailySummary => 'Riepilogo Giornaliero';

  @override
  String get dailySummarySubtitle => 'Notifica giornaliera con stato acquario';

  @override
  String get maintenanceFrequency => 'Frequenza Manutenzione';

  @override
  String get resetDefaults => 'Ripristina Valori Predefiniti';

  @override
  String get parameterThresholds => 'Soglie Parametri';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get alertHistory => 'Storico Alert';

  @override
  String recentNotifications(int count) {
    return '$count notifiche recenti';
  }

  @override
  String get noNotificationsYet => 'Nessuna notifica ancora';

  @override
  String get resetDefaultsQuestion => 'Ripristinare Predefiniti?';

  @override
  String get resetDefaultsMessage =>
      'Questa azione resetterà tutte le soglie personalizzate ai valori di default:';

  @override
  String get resetButton => 'Ripristina';

  @override
  String get fillAllRequiredFields => 'Compila tutti i campi obbligatori';

  @override
  String get inhabitantsUpdated => 'Abitanti aggiornati!';

  @override
  String get clearFilters => 'Cancella filtri';

  @override
  String get confirmDeletion => 'Conferma eliminazione';

  @override
  String confirmDeleteFish(String name) {
    return 'Vuoi eliminare \"$name\"?';
  }

  @override
  String confirmDeleteCoral(String name) {
    return 'Vuoi eliminare \"$name\"?';
  }

  @override
  String get noFishAdded => 'Nessun pesce aggiunto';

  @override
  String get tapToAddFirstFish => 'Tocca + per aggiungere il tuo primo pesce';

  @override
  String get noResultsFound => 'Nessun risultato trovato';

  @override
  String get tryModifyingFilters => 'Prova a modificare i filtri';

  @override
  String get noCoralAdded => 'Nessun corallo aggiunto';

  @override
  String get tapToAddFirstCoral =>
      'Tocca + per aggiungere il tuo primo corallo';

  @override
  String get averageSize => 'Dim. media';

  @override
  String get totalBioLoad => 'Carico Biotico Totale';

  @override
  String get bioLoadFormula =>
      'Formula: (Σ dimensioni pesci) + (n° coralli × 2)';

  @override
  String get bioLoadOptimal =>
      'Carico biotico ottimale - acquario ben bilanciato';

  @override
  String get bioLoadModerate =>
      'Carico biotico moderato - monitora i parametri dell\'acqua';

  @override
  String get bioLoadHigh =>
      'Carico biotico elevato - considera un acquario più grande o riduci gli abitanti';

  @override
  String get aquariumIdNotAvailable => 'Errore: ID acquario non disponibile';

  @override
  String get daily => 'Giornaliero';

  @override
  String get weekly => 'Settimanale';

  @override
  String get monthly => 'Mensile';

  @override
  String get custom => 'Personalizzato';

  @override
  String get medium => 'Media';

  @override
  String get dueDate => 'Data scadenza';

  @override
  String get add => 'Aggiungi';

  @override
  String get taskAddedSuccess => 'Task aggiunto con successo';

  @override
  String get editTask => 'Modifica Task';

  @override
  String get taskEditedSuccess => 'Task modificato con successo';

  @override
  String get completeTask => 'Completa Task';

  @override
  String markAsCompleted(String title) {
    return 'Vuoi segnare \"$title\" come completato?';
  }

  @override
  String get complete => 'Completa';

  @override
  String taskCompleted(String title) {
    return '$title completato!';
  }

  @override
  String get deleteTask => 'Elimina Task';

  @override
  String confirmDeleteTask(String title) {
    return 'Vuoi eliminare \"$title\"?';
  }

  @override
  String get taskDeleted => 'Task eliminato';

  @override
  String get notSet => 'Non impostata';

  @override
  String taskCompletedSuccess(String title) {
    return '$title completato!';
  }

  @override
  String confirmCompleteTask(String title) {
    return 'Vuoi segnare \"$title\" come completato?';
  }

  @override
  String get temperatureAnomaly => 'Temperatura Anomala';

  @override
  String get phOutOfRange => 'pH Fuori Range';

  @override
  String get salinityAnomaly => 'Salinità Anomala';

  @override
  String get orpOutOfRange => 'ORP Fuori Range';

  @override
  String get calciumAnomaly => 'Calcio Anomalo';

  @override
  String get magnesiumAnomaly => 'Magnesio Anomalo';

  @override
  String get khOutOfRange => 'KH Fuori Range';

  @override
  String get nitratesHigh => 'Nitrati Elevati';

  @override
  String get phosphatesHigh => 'Fosfati Elevati';

  @override
  String get temperatureTooHigh => 'La temperatura è troppo alta.';

  @override
  String get phTooHigh => 'Il pH è troppo alto.';

  @override
  String get salinityTooHigh => 'La salinità è troppo alta.';

  @override
  String get orpTooHigh => 'L\'ORP è troppo alto.';

  @override
  String get calciumTooHigh => 'Il calcio è troppo alto.';

  @override
  String get magnesiumTooHigh => 'Il magnesio è troppo alto.';

  @override
  String get khTooHigh => 'Il KH è troppo alto.';

  @override
  String get nitratesTooHigh => 'I nitrati sono troppo alti.';

  @override
  String get phosphatesTooHigh => 'I fosfati sono troppo alti.';

  @override
  String get temperatureTooLow => 'La temperatura è troppo bassa.';

  @override
  String get phTooLow => 'Il pH è troppo basso.';

  @override
  String get salinityTooLow => 'La salinità è troppo bassa.';

  @override
  String get orpTooLow => 'L\'ORP è troppo basso.';

  @override
  String get calciumTooLow => 'Il calcio è troppo basso.';

  @override
  String get magnesiumTooLow => 'Il magnesio è troppo basso.';

  @override
  String get khTooLow => 'Il KH è troppo basso.';

  @override
  String get nitratesTooLow => 'I nitrati sono troppo bassi.';

  @override
  String get phosphatesTooLow => 'I fosfati sono troppo bassi.';

  @override
  String get suggestionTemperatureHigh =>
      'Verifica il riscaldatore e la temperatura ambiente.';

  @override
  String get suggestionPhHigh =>
      'Controlla l\'aerazione e riduci l\'illuminazione.';

  @override
  String get suggestionSalinityHigh => 'Aggiungi acqua osmotica per diluire.';

  @override
  String get suggestionOrpHigh =>
      'Riduci l\'ossigenazione o controlla l\'ozonizzatore.';

  @override
  String get suggestionCalciumHigh =>
      'Riduci il dosaggio di integratori al calcio.';

  @override
  String get suggestionMagnesiumHigh =>
      'Riduci il dosaggio di integratori al magnesio.';

  @override
  String get suggestionKhHigh => 'Riduci il dosaggio di buffer alcalini.';

  @override
  String get suggestionNitratesHigh =>
      'Effettua un cambio d\'acqua e verifica il filtro.';

  @override
  String get suggestionPhosphatesHigh =>
      'Effettua un cambio d\'acqua e usa resine anti-fosfati.';

  @override
  String get suggestionTemperatureLow =>
      'Verifica il funzionamento del riscaldatore.';

  @override
  String get suggestionPhLow => 'Aumenta l\'aerazione e controlla il KH.';

  @override
  String get suggestionSalinityLow => 'Aggiungi sale marino di qualità.';

  @override
  String get suggestionOrpLow =>
      'Aumenta l\'ossigenazione o controlla lo skimmer.';

  @override
  String get suggestionCalciumLow => 'Integra con soluzioni di calcio.';

  @override
  String get suggestionMagnesiumLow => 'Integra con soluzioni di magnesio.';

  @override
  String get suggestionKhLow => 'Aggiungi buffer alcalini gradualmente';

  @override
  String get suggestionNitratesLow => 'Normale per acquari ben bilanciati';

  @override
  String get suggestionPhosphatesLow => 'Normale per acquari ben bilanciati';

  @override
  String get maintenanceReminder => 'Promemoria Manutenzione';

  @override
  String get weeklyMaintenance => 'Manutenzione settimanale prevista';

  @override
  String get monthlyMaintenance => 'Manutenzione mensile prevista';

  @override
  String get waterChangeReminder => 'Promemoria: Cambio Acqua';

  @override
  String get waterChangeReminderBody =>
      'È tempo di cambiare l\'acqua dell\'acquario';

  @override
  String get filterCleaningReminder => 'Promemoria: Pulizia Filtro';

  @override
  String get filterCleaningReminderBody =>
      'Controlla e pulisci il filtro dell\'acquario';

  @override
  String get parameterTestingReminder => 'Promemoria: Test Parametri';

  @override
  String get parameterTestingReminderBody =>
      'Esegui i test dei parametri dell\'acqua';

  @override
  String get lightMaintenanceReminder => 'Promemoria: Manutenzione Luci';

  @override
  String get lightMaintenanceReminderBody =>
      'Controlla e pulisci le luci dell\'acquario';

  @override
  String get weeklyMaintenanceDetails =>
      'È ora di effettuare la manutenzione settimanale:\n• Cambio acqua 10-15%\n• Pulizia vetri\n• Test parametri\n• Controllo attrezzature';

  @override
  String get monthlyMaintenanceDetails =>
      'È ora di effettuare la manutenzione mensile:\n• Cambio acqua 20-25%\n• Pulizia filtro\n• Controllo pompe e riscaldatore\n• Verifica luci e timer\n• Test completo parametri';

  @override
  String get severityCritical => 'CRITICO';

  @override
  String get severityHigh => 'ALTO';

  @override
  String get severityMedium => 'MEDIO';

  @override
  String get severityLow => 'BASSO';

  @override
  String get severityCriticalDesc => 'Richiede intervento immediato';

  @override
  String get severityHighDesc => 'Richiede attenzione prioritaria';

  @override
  String get severityMediumDesc => 'Monitorare attentamente';

  @override
  String get severityLowDesc => 'Situazione sotto controllo';

  @override
  String parameterOutOfRange(String parameter) {
    return 'Il parametro $parameter è fuori range';
  }

  @override
  String get parameterAnomaly => 'Parametro Anomalo';

  @override
  String get checkParameterSettings =>
      'Controlla il parametro e verifica le impostazioni';

  @override
  String get alertsWillAppearHere => 'Gli alert appariranno qui';

  @override
  String get changesWillBeSavedImmediately =>
      'Le modifiche verranno salvate immediatamente.';

  @override
  String get networkError =>
      'Errore di connessione. Verifica la tua connessione internet.';

  @override
  String get serverError =>
      'Il server ha riscontrato un problema. Riprova più tardi.';

  @override
  String get sessionExpired =>
      'Sessione scaduta. Effettua nuovamente l\'accesso.';

  @override
  String get requestTimeout =>
      'La richiesta ha impiegato troppo tempo. Riprova.';

  @override
  String get invalidDataFormat =>
      'I dati ricevuti non sono nel formato atteso.';

  @override
  String get volumeMustBePositive => 'Il volume deve essere un numero positivo';

  @override
  String get sortAscending => 'A → Z / 0 → 9';

  @override
  String get sortDescending => 'Z → A / 9 → 0';

  @override
  String get trendRising => 'In Aumento';

  @override
  String get trendFalling => 'In Diminuzione';

  @override
  String get trendStable => 'Stabile';

  @override
  String get appSubtitle => 'Sistema di Gestione Acquari';

  @override
  String get appDescription =>
      'Piattaforma avanzata per il monitoraggio e la gestione degli acquari marini, progettata per gli appassionati di acquariofilia.';

  @override
  String get mitLicense => 'MIT License';

  @override
  String get copyright =>
      '© 2024-2025 ReefLife Project. Tutti i diritti riservati.';

  @override
  String get openSourceMessage =>
      'Software open source per la comunità acquariofila.';

  @override
  String get noAquariumCreated =>
      'Non hai ancora creato un acquario. Crea il tuo primo acquario per visualizzare le informazioni.';

  @override
  String get aquariumDetails => 'Dettagli Acquario';

  @override
  String get description => 'Descrizione';

  @override
  String get saveSettings => 'Salva Impostazioni';

  @override
  String get restoreDefaults => 'Ripristina Valori Predefiniti';

  @override
  String get noAlerts => 'Nessun Alert';

  @override
  String get every => 'Ogni';

  @override
  String get lowLabel => 'BASSO';

  @override
  String get highLabel => 'ALTO';

  @override
  String editThresholds(String name) {
    return 'Modifica Soglie - $name';
  }

  @override
  String get notificationWhenOutOfRange =>
      'Riceverai notifiche quando il valore esce da questo range';

  @override
  String get restoreDefaultsConfirm => 'Ripristinare Predefiniti?';

  @override
  String get restoreDefaultsMessage =>
      'Questa azione resetterà tutte le soglie personalizzate ai valori di default:';

  @override
  String get temperatureDefault => '• Temperatura: 24-26°C';

  @override
  String get phDefault => '• pH: 8.0-8.4';

  @override
  String get salinityDefault => '• Salinità: 1020-1028';

  @override
  String get andOtherParameters => '• E tutti gli altri parametri...';

  @override
  String updated(String time) {
    return 'Aggiornato $time';
  }

  @override
  String get sortAscendingLabel => 'Ordine crescente';

  @override
  String get orpRedox => 'ORP/Redox';

  @override
  String get addAquarium => 'Aggiungi Vasca';

  @override
  String get editAquariumTitle => 'Modifica Vasca';

  @override
  String get deleteAquariumTitle => 'Elimina Vasca';

  @override
  String get scientificName => 'Nome Scientifico';

  @override
  String get requirements => 'Requisiti';

  @override
  String get multipleSpecimensNote =>
      'Se aggiungi più esemplari, verranno numerati automaticamente';

  @override
  String get recentAlerts => 'Alert Recenti';

  @override
  String frequencyDays(String days) {
    return '${days}d';
  }

  @override
  String minMaxRange(String min, String max, String unit) {
    return '$min - $max$unit';
  }

  @override
  String minValueUnit(String min, String unit) {
    return '$min$unit';
  }

  @override
  String maxValueUnit(String max, String unit) {
    return '$max$unit';
  }

  @override
  String get notificationsActiveLabel => 'Notifiche Attive';

  @override
  String get notificationsDisabled => 'Notifiche Disattivate';

  @override
  String get alertHistoryCount => 'Storico Alert';

  @override
  String alertHistorySubtitle(String count) {
    return '$count notifiche recenti';
  }

  @override
  String get minimumValue => 'Valore Minimo';

  @override
  String get maximumValue => 'Valore Massimo';

  @override
  String get difficultyLabel => 'Difficoltà';

  @override
  String get minTankSizeLabel => 'Vasca minima';

  @override
  String get temperamentLabel => 'Temperamento';

  @override
  String get dietLabel => 'Dieta';

  @override
  String get reefSafeLabel => 'Reef-safe';

  @override
  String get loadingError => 'Errore nel caricamento';

  @override
  String get temperatureShort => 'Temp';

  @override
  String get salinityShort => 'Salinità';

  @override
  String get pptUnit => 'PPT';

  @override
  String get typeLabel => 'Tipo';

  @override
  String get volumeLabel => 'Volume';

  @override
  String get litersUnit => 'Litri';

  @override
  String get createdOn => 'Creato il';

  @override
  String get daysLabel => 'giorni';

  @override
  String get temperatureParam => 'Temperatura';

  @override
  String get phParam => 'pH';

  @override
  String get salinityParam => 'Salinità';

  @override
  String get orpParam => 'ORP';

  @override
  String get calciumParam => 'Calcio';

  @override
  String get magnesiumParam => 'Magnesio';

  @override
  String get khParam => 'KH';

  @override
  String get nitrateParam => 'Nitrati';

  @override
  String get phosphateParam => 'Fosfati';

  @override
  String get nowLabel => 'Ora';

  @override
  String minutesAgo(String minutes) {
    return '${minutes}m fa';
  }

  @override
  String hoursAgo(String hours) {
    return '${hours}h fa';
  }

  @override
  String daysAgo(String days) {
    return '${days}g fa';
  }

  @override
  String get temperatureAnomalous => 'Temperatura Anomala';

  @override
  String get salinityAnomalous => 'Salinità Anomala';

  @override
  String get calciumAnomalous => 'Calcio Anomalo';

  @override
  String get magnesiumAnomalous => 'Magnesio Anomalo';

  @override
  String get nitrateHigh => 'Nitrati Elevati';

  @override
  String get phosphateHigh => 'Fosfati Elevati';

  @override
  String get nitrateTooHigh => 'I nitrati sono troppo alti.';

  @override
  String get nitrateTooLow => 'I nitrati sono troppo bassi.';

  @override
  String get phosphateTooHigh => 'I fosfati sono troppo alti.';

  @override
  String get phosphateTooLow => 'I fosfati sono troppo bassi.';
}
