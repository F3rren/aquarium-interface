import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
  ];

  /// Il titolo dell'applicazione
  ///
  /// In it, this message translates to:
  /// **'ReefLife'**
  String get appTitle;

  /// No description provided for @aquariums.
  ///
  /// In it, this message translates to:
  /// **'Acquari'**
  String get aquariums;

  /// No description provided for @aquarium.
  ///
  /// In it, this message translates to:
  /// **'Acquario'**
  String get aquarium;

  /// No description provided for @parameters.
  ///
  /// In it, this message translates to:
  /// **'Parametri'**
  String get parameters;

  /// No description provided for @fish.
  ///
  /// In it, this message translates to:
  /// **'Pesci'**
  String get fish;

  /// No description provided for @fishes.
  ///
  /// In it, this message translates to:
  /// **'Pesci'**
  String get fishes;

  /// No description provided for @corals.
  ///
  /// In it, this message translates to:
  /// **'Coralli'**
  String get corals;

  /// No description provided for @coral.
  ///
  /// In it, this message translates to:
  /// **'Corallo'**
  String get coral;

  /// No description provided for @maintenance.
  ///
  /// In it, this message translates to:
  /// **'Manutenzione'**
  String get maintenance;

  /// No description provided for @alerts.
  ///
  /// In it, this message translates to:
  /// **'Alert'**
  String get alerts;

  /// No description provided for @settings.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get settings;

  /// No description provided for @dashboard.
  ///
  /// In it, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @charts.
  ///
  /// In it, this message translates to:
  /// **'Grafici'**
  String get charts;

  /// No description provided for @profile.
  ///
  /// In it, this message translates to:
  /// **'Profilo'**
  String get profile;

  /// No description provided for @myAquarium.
  ///
  /// In it, this message translates to:
  /// **'La Mia Vasca'**
  String get myAquarium;

  /// No description provided for @noAquarium.
  ///
  /// In it, this message translates to:
  /// **'Nessun Acquario'**
  String get noAquarium;

  /// No description provided for @noAquariumDescription.
  ///
  /// In it, this message translates to:
  /// **'Inizia creando il tuo primo acquario per monitorare i parametri dell\'acqua e la salute dei tuoi pesci.'**
  String get noAquariumDescription;

  /// No description provided for @createAquarium.
  ///
  /// In it, this message translates to:
  /// **'Crea Acquario'**
  String get createAquarium;

  /// No description provided for @noFish.
  ///
  /// In it, this message translates to:
  /// **'Nessun Pesce'**
  String get noFish;

  /// No description provided for @noFishDescription.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi i tuoi pesci per tenere traccia della popolazione del tuo acquario.'**
  String get noFishDescription;

  /// No description provided for @addFish.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi Pesce'**
  String get addFish;

  /// No description provided for @noCoral.
  ///
  /// In it, this message translates to:
  /// **'Nessun Corallo'**
  String get noCoral;

  /// No description provided for @noCoralDescription.
  ///
  /// In it, this message translates to:
  /// **'Documenta i coralli presenti nel tuo acquario marino.'**
  String get noCoralDescription;

  /// No description provided for @addCoral.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi Corallo'**
  String get addCoral;

  /// No description provided for @noHistory.
  ///
  /// In it, this message translates to:
  /// **'Nessuno Storico'**
  String get noHistory;

  /// No description provided for @noHistoryDescription.
  ///
  /// In it, this message translates to:
  /// **'Non ci sono ancora dati storici disponibili. I parametri verranno registrati automaticamente.'**
  String get noHistoryDescription;

  /// No description provided for @noTasks.
  ///
  /// In it, this message translates to:
  /// **'Nessun Task'**
  String get noTasks;

  /// No description provided for @noTasksDescription.
  ///
  /// In it, this message translates to:
  /// **'Crea promemoria per le attività di manutenzione del tuo acquario.'**
  String get noTasksDescription;

  /// No description provided for @createTask.
  ///
  /// In it, this message translates to:
  /// **'Crea Task'**
  String get createTask;

  /// No description provided for @allOk.
  ///
  /// In it, this message translates to:
  /// **'TUTTO OK'**
  String get allOk;

  /// No description provided for @allOkDescription.
  ///
  /// In it, this message translates to:
  /// **'Non ci sono alert attivi. Tutti i parametri sono nella norma.'**
  String get allOkDescription;

  /// No description provided for @noResults.
  ///
  /// In it, this message translates to:
  /// **'Nessun Risultato'**
  String get noResults;

  /// No description provided for @noResultsDescription.
  ///
  /// In it, this message translates to:
  /// **'Non abbiamo trovato risultati per \"{query}\".\nProva con parole chiave diverse.'**
  String noResultsDescription(String query);

  /// No description provided for @errorTitle.
  ///
  /// In it, this message translates to:
  /// **'Ops!'**
  String get errorTitle;

  /// No description provided for @errorDescription.
  ///
  /// In it, this message translates to:
  /// **'Si è verificato un errore'**
  String get errorDescription;

  /// No description provided for @retry.
  ///
  /// In it, this message translates to:
  /// **'Riprova'**
  String get retry;

  /// No description provided for @offline.
  ///
  /// In it, this message translates to:
  /// **'Sei Offline'**
  String get offline;

  /// No description provided for @offlineDescription.
  ///
  /// In it, this message translates to:
  /// **'Verifica la tua connessione internet e riprova.'**
  String get offlineDescription;

  /// No description provided for @save.
  ///
  /// In it, this message translates to:
  /// **'Salva'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In it, this message translates to:
  /// **'Elimina'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In it, this message translates to:
  /// **'Modifica {name}'**
  String edit(String name);

  /// No description provided for @close.
  ///
  /// In it, this message translates to:
  /// **'Chiudi'**
  String get close;

  /// No description provided for @ok.
  ///
  /// In it, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @name.
  ///
  /// In it, this message translates to:
  /// **'Nome'**
  String get name;

  /// No description provided for @species.
  ///
  /// In it, this message translates to:
  /// **'Specie'**
  String get species;

  /// No description provided for @size.
  ///
  /// In it, this message translates to:
  /// **'Dimensione'**
  String get size;

  /// No description provided for @notes.
  ///
  /// In it, this message translates to:
  /// **'Note'**
  String get notes;

  /// No description provided for @date.
  ///
  /// In it, this message translates to:
  /// **'Data'**
  String get date;

  /// No description provided for @quantity.
  ///
  /// In it, this message translates to:
  /// **'Quantità'**
  String get quantity;

  /// No description provided for @addFishTitle.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi Pesce'**
  String get addFishTitle;

  /// No description provided for @editFishTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica Pesce'**
  String get editFishTitle;

  /// No description provided for @fishNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome *'**
  String get fishNameLabel;

  /// No description provided for @fishNameHint.
  ///
  /// In it, this message translates to:
  /// **'es: Nemo'**
  String get fishNameHint;

  /// No description provided for @fishSpeciesLabel.
  ///
  /// In it, this message translates to:
  /// **'Specie *'**
  String get fishSpeciesLabel;

  /// No description provided for @fishSpeciesHint.
  ///
  /// In it, this message translates to:
  /// **'es: Amphiprion ocellaris'**
  String get fishSpeciesHint;

  /// No description provided for @fishSizeLabel.
  ///
  /// In it, this message translates to:
  /// **'Dimensione (cm) *'**
  String get fishSizeLabel;

  /// No description provided for @fishSizeHint.
  ///
  /// In it, this message translates to:
  /// **'es: 8.5'**
  String get fishSizeHint;

  /// No description provided for @quantityLabel.
  ///
  /// In it, this message translates to:
  /// **'Quantità'**
  String get quantityLabel;

  /// No description provided for @quantityHint.
  ///
  /// In it, this message translates to:
  /// **'Numero di esemplari da aggiungere'**
  String get quantityHint;

  /// No description provided for @quantityInfo.
  ///
  /// In it, this message translates to:
  /// **'Se aggiungi più esemplari, verranno numerati automaticamente'**
  String get quantityInfo;

  /// No description provided for @notesLabel.
  ///
  /// In it, this message translates to:
  /// **'Note'**
  String get notesLabel;

  /// No description provided for @notesHint.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi note opzionali'**
  String get notesHint;

  /// No description provided for @selectFromList.
  ///
  /// In it, this message translates to:
  /// **'Seleziona dalla lista'**
  String get selectFromList;

  /// No description provided for @orEnterManually.
  ///
  /// In it, this message translates to:
  /// **'oppure inserisci manualmente'**
  String get orEnterManually;

  /// No description provided for @noCompatibleFish.
  ///
  /// In it, this message translates to:
  /// **'Nessun pesce compatibile con acquario {waterType}'**
  String noCompatibleFish(String waterType);

  /// No description provided for @noDatabaseFish.
  ///
  /// In it, this message translates to:
  /// **'Nessun pesce disponibile nel database'**
  String get noDatabaseFish;

  /// No description provided for @addCoralTitle.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi Corallo'**
  String get addCoralTitle;

  /// No description provided for @editCoralTitle.
  ///
  /// In it, this message translates to:
  /// **'Modifica Corallo'**
  String get editCoralTitle;

  /// No description provided for @coralNameLabel.
  ///
  /// In it, this message translates to:
  /// **'Nome *'**
  String get coralNameLabel;

  /// No description provided for @coralNameHint.
  ///
  /// In it, this message translates to:
  /// **'es: Montipora arancione'**
  String get coralNameHint;

  /// No description provided for @coralSpeciesLabel.
  ///
  /// In it, this message translates to:
  /// **'Specie *'**
  String get coralSpeciesLabel;

  /// No description provided for @coralSpeciesHint.
  ///
  /// In it, this message translates to:
  /// **'es: Montipora digitata'**
  String get coralSpeciesHint;

  /// No description provided for @coralTypeLabel.
  ///
  /// In it, this message translates to:
  /// **'Tipo *'**
  String get coralTypeLabel;

  /// No description provided for @coralSizeLabel.
  ///
  /// In it, this message translates to:
  /// **'Dimensione (cm) *'**
  String get coralSizeLabel;

  /// No description provided for @coralSizeHint.
  ///
  /// In it, this message translates to:
  /// **'es: 5.0'**
  String get coralSizeHint;

  /// No description provided for @coralPlacementLabel.
  ///
  /// In it, this message translates to:
  /// **'Posizionamento *'**
  String get coralPlacementLabel;

  /// No description provided for @coralTypeSPS.
  ///
  /// In it, this message translates to:
  /// **'SPS'**
  String get coralTypeSPS;

  /// No description provided for @coralTypeLPS.
  ///
  /// In it, this message translates to:
  /// **'LPS'**
  String get coralTypeLPS;

  /// No description provided for @coralTypeSoft.
  ///
  /// In it, this message translates to:
  /// **'Molle'**
  String get coralTypeSoft;

  /// No description provided for @placementTop.
  ///
  /// In it, this message translates to:
  /// **'Alto'**
  String get placementTop;

  /// No description provided for @placementMiddle.
  ///
  /// In it, this message translates to:
  /// **'Medio'**
  String get placementMiddle;

  /// No description provided for @placementBottom.
  ///
  /// In it, this message translates to:
  /// **'Basso'**
  String get placementBottom;

  /// No description provided for @difficultyEasy.
  ///
  /// In it, this message translates to:
  /// **'Facile'**
  String get difficultyEasy;

  /// No description provided for @difficultyIntermediate.
  ///
  /// In it, this message translates to:
  /// **'Intermedio'**
  String get difficultyIntermediate;

  /// No description provided for @difficultyHard.
  ///
  /// In it, this message translates to:
  /// **'Difficile'**
  String get difficultyHard;

  /// No description provided for @difficultyBeginner.
  ///
  /// In it, this message translates to:
  /// **'Principiante'**
  String get difficultyBeginner;

  /// No description provided for @difficultyExpert.
  ///
  /// In it, this message translates to:
  /// **'Esperto'**
  String get difficultyExpert;

  /// No description provided for @temperamentPeaceful.
  ///
  /// In it, this message translates to:
  /// **'Pacifico'**
  String get temperamentPeaceful;

  /// No description provided for @temperamentSemiAggressive.
  ///
  /// In it, this message translates to:
  /// **'Semi-aggressivo'**
  String get temperamentSemiAggressive;

  /// No description provided for @temperamentAggressive.
  ///
  /// In it, this message translates to:
  /// **'Aggressivo'**
  String get temperamentAggressive;

  /// No description provided for @dietHerbivore.
  ///
  /// In it, this message translates to:
  /// **'Erbivoro'**
  String get dietHerbivore;

  /// No description provided for @dietCarnivore.
  ///
  /// In it, this message translates to:
  /// **'Carnivoro'**
  String get dietCarnivore;

  /// No description provided for @dietOmnivore.
  ///
  /// In it, this message translates to:
  /// **'Onnivoro'**
  String get dietOmnivore;

  /// No description provided for @reefSafe.
  ///
  /// In it, this message translates to:
  /// **'Reef-safe'**
  String get reefSafe;

  /// No description provided for @yes.
  ///
  /// In it, this message translates to:
  /// **'Sì'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In it, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @difficulty.
  ///
  /// In it, this message translates to:
  /// **'Difficoltà'**
  String get difficulty;

  /// No description provided for @minTankSize.
  ///
  /// In it, this message translates to:
  /// **'Vasca minima'**
  String get minTankSize;

  /// No description provided for @temperament.
  ///
  /// In it, this message translates to:
  /// **'Temperamento'**
  String get temperament;

  /// No description provided for @diet.
  ///
  /// In it, this message translates to:
  /// **'Dieta'**
  String get diet;

  /// No description provided for @filtersAndSearch.
  ///
  /// In it, this message translates to:
  /// **'Filtri e Ricerca'**
  String get filtersAndSearch;

  /// No description provided for @clearAll.
  ///
  /// In it, this message translates to:
  /// **'Cancella tutto'**
  String get clearAll;

  /// No description provided for @searchByName.
  ///
  /// In it, this message translates to:
  /// **'Ricerca per nome'**
  String get searchByName;

  /// No description provided for @searchPlaceholder.
  ///
  /// In it, this message translates to:
  /// **'Cerca per nome...'**
  String get searchPlaceholder;

  /// No description provided for @insertionDate.
  ///
  /// In it, this message translates to:
  /// **'Data inserimento in vasca'**
  String get insertionDate;

  /// No description provided for @selectType.
  ///
  /// In it, this message translates to:
  /// **'Seleziona tipo'**
  String get selectType;

  /// No description provided for @selectDate.
  ///
  /// In it, this message translates to:
  /// **'Seleziona data'**
  String get selectDate;

  /// No description provided for @removeDateFilter.
  ///
  /// In it, this message translates to:
  /// **'Rimuovi filtro data'**
  String get removeDateFilter;

  /// No description provided for @sorting.
  ///
  /// In it, this message translates to:
  /// **'Ordinamento'**
  String get sorting;

  /// No description provided for @ascendingOrder.
  ///
  /// In it, this message translates to:
  /// **'Ordine crescente'**
  String get ascendingOrder;

  /// No description provided for @fillAllFields.
  ///
  /// In it, this message translates to:
  /// **'Compila tutti i campi obbligatori'**
  String get fillAllFields;

  /// No description provided for @invalidSize.
  ///
  /// In it, this message translates to:
  /// **'Dimensione non valida'**
  String get invalidSize;

  /// No description provided for @invalidQuantity.
  ///
  /// In it, this message translates to:
  /// **'Quantità non valida'**
  String get invalidQuantity;

  /// No description provided for @databaseLoadError.
  ///
  /// In it, this message translates to:
  /// **'Errore caricamento database: {error}'**
  String databaseLoadError(String error);

  /// No description provided for @language.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In it, this message translates to:
  /// **'Seleziona lingua'**
  String get selectLanguage;

  /// No description provided for @tools.
  ///
  /// In it, this message translates to:
  /// **'Strumenti'**
  String get tools;

  /// No description provided for @calculators.
  ///
  /// In it, this message translates to:
  /// **'Calcolatori'**
  String get calculators;

  /// No description provided for @calculatorsSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Volume, dosaggio additivi, cambio acqua'**
  String get calculatorsSubtitle;

  /// No description provided for @myInhabitants.
  ///
  /// In it, this message translates to:
  /// **'I Miei Abitanti'**
  String get myInhabitants;

  /// No description provided for @myInhabitantsSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Gestisci pesci e coralli'**
  String get myInhabitantsSubtitle;

  /// No description provided for @aquariumInfo.
  ///
  /// In it, this message translates to:
  /// **'Info Acquario'**
  String get aquariumInfo;

  /// No description provided for @aquariumInfoSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Nome, volume, tipo'**
  String get aquariumInfoSubtitle;

  /// No description provided for @theme.
  ///
  /// In it, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @darkMode.
  ///
  /// In it, this message translates to:
  /// **'Modalità scura'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In it, this message translates to:
  /// **'Modalità chiara'**
  String get lightMode;

  /// No description provided for @appInfo.
  ///
  /// In it, this message translates to:
  /// **'Informazioni App'**
  String get appInfo;

  /// No description provided for @appInfoSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Versione, crediti'**
  String get appInfoSubtitle;

  /// No description provided for @noAquariumSelected.
  ///
  /// In it, this message translates to:
  /// **'Nessun Acquario'**
  String get noAquariumSelected;

  /// No description provided for @unableToLoadInfo.
  ///
  /// In it, this message translates to:
  /// **'Impossibile caricare le informazioni: {error}'**
  String unableToLoadInfo(String error);

  /// No description provided for @errorLoadingParameters.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento parametri'**
  String get errorLoadingParameters;

  /// No description provided for @warning.
  ///
  /// In it, this message translates to:
  /// **'ATTENZIONE'**
  String get warning;

  /// No description provided for @critical.
  ///
  /// In it, this message translates to:
  /// **'CRITICO'**
  String get critical;

  /// No description provided for @aquariumStatus.
  ///
  /// In it, this message translates to:
  /// **'Stato Acquario'**
  String get aquariumStatus;

  /// No description provided for @updatedNow.
  ///
  /// In it, this message translates to:
  /// **'Aggiornato ora • {okParams}/{totalParams} parametri OK'**
  String updatedNow(int okParams, int totalParams);

  /// No description provided for @temperature.
  ///
  /// In it, this message translates to:
  /// **'Temperatura'**
  String get temperature;

  /// No description provided for @ph.
  ///
  /// In it, this message translates to:
  /// **'pH'**
  String get ph;

  /// No description provided for @salinity.
  ///
  /// In it, this message translates to:
  /// **'Salinità'**
  String get salinity;

  /// No description provided for @orp.
  ///
  /// In it, this message translates to:
  /// **'ORP'**
  String get orp;

  /// No description provided for @excellent.
  ///
  /// In it, this message translates to:
  /// **'Eccellente'**
  String get excellent;

  /// No description provided for @good.
  ///
  /// In it, this message translates to:
  /// **'Buono'**
  String get good;

  /// No description provided for @parametersOk.
  ///
  /// In it, this message translates to:
  /// **'Parametri OK'**
  String get parametersOk;

  /// No description provided for @parametersNeedAttention.
  ///
  /// In it, this message translates to:
  /// **'{count} parametri necessitano attenzione'**
  String parametersNeedAttention(int count);

  /// No description provided for @waterChange.
  ///
  /// In it, this message translates to:
  /// **'Cambio Acqua'**
  String get waterChange;

  /// No description provided for @healthScore.
  ///
  /// In it, this message translates to:
  /// **'Health Score'**
  String get healthScore;

  /// No description provided for @parametersInOptimalRange.
  ///
  /// In it, this message translates to:
  /// **'{okParams}/{totalParams} parametri nel range ottimale'**
  String parametersInOptimalRange(int okParams, int totalParams);

  /// No description provided for @upcomingReminders.
  ///
  /// In it, this message translates to:
  /// **'Prossimi Promemoria'**
  String get upcomingReminders;

  /// No description provided for @filterCleaning.
  ///
  /// In it, this message translates to:
  /// **'Pulizia Filtro'**
  String get filterCleaning;

  /// No description provided for @parameterTesting.
  ///
  /// In it, this message translates to:
  /// **'Test Parametri'**
  String get parameterTesting;

  /// No description provided for @days.
  ///
  /// In it, this message translates to:
  /// **'giorni'**
  String get days;

  /// No description provided for @recommendations.
  ///
  /// In it, this message translates to:
  /// **'Raccomandazioni'**
  String get recommendations;

  /// No description provided for @checkOutOfRangeParameters.
  ///
  /// In it, this message translates to:
  /// **'Controllare parametri fuori range'**
  String get checkOutOfRangeParameters;

  /// No description provided for @checkSkimmer.
  ///
  /// In it, this message translates to:
  /// **'Controllare skimmer'**
  String get checkSkimmer;

  /// No description provided for @weeklyCleaningRecommended.
  ///
  /// In it, this message translates to:
  /// **'Pulizia settimanale consigliata'**
  String get weeklyCleaningRecommended;

  /// No description provided for @khTest.
  ///
  /// In it, this message translates to:
  /// **'Test KH'**
  String get khTest;

  /// No description provided for @lastTest3DaysAgo.
  ///
  /// In it, this message translates to:
  /// **'Ultimo test: 3 giorni fa'**
  String get lastTest3DaysAgo;

  /// No description provided for @parametersUpdated.
  ///
  /// In it, this message translates to:
  /// **'Parametri aggiornati'**
  String get parametersUpdated;

  /// No description provided for @error.
  ///
  /// In it, this message translates to:
  /// **'Errore'**
  String get error;

  /// No description provided for @noParametersAvailable.
  ///
  /// In it, this message translates to:
  /// **'Nessun parametro disponibile'**
  String get noParametersAvailable;

  /// No description provided for @chemicalParameters.
  ///
  /// In it, this message translates to:
  /// **'Parametri Chimici'**
  String get chemicalParameters;

  /// No description provided for @calciumCa.
  ///
  /// In it, this message translates to:
  /// **'Calcio (Ca)'**
  String get calciumCa;

  /// No description provided for @magnesiumMg.
  ///
  /// In it, this message translates to:
  /// **'Magnesio (Mg)'**
  String get magnesiumMg;

  /// No description provided for @nitratesNO3.
  ///
  /// In it, this message translates to:
  /// **'Nitrati (NO3)'**
  String get nitratesNO3;

  /// No description provided for @phosphatesPO4.
  ///
  /// In it, this message translates to:
  /// **'Fosfati (PO4)'**
  String get phosphatesPO4;

  /// No description provided for @value.
  ///
  /// In it, this message translates to:
  /// **'Valore ({unit})'**
  String value(String unit);

  /// No description provided for @low.
  ///
  /// In it, this message translates to:
  /// **'Bassa'**
  String get low;

  /// No description provided for @high.
  ///
  /// In it, this message translates to:
  /// **'Alta'**
  String get high;

  /// No description provided for @optimal.
  ///
  /// In it, this message translates to:
  /// **'Ottimale'**
  String get optimal;

  /// No description provided for @attention.
  ///
  /// In it, this message translates to:
  /// **'Attenzione'**
  String get attention;

  /// No description provided for @monitoring.
  ///
  /// In it, this message translates to:
  /// **'Monitoraggio'**
  String get monitoring;

  /// No description provided for @targetValue.
  ///
  /// In it, this message translates to:
  /// **'Valore target ({unit})'**
  String targetValue(String unit);

  /// No description provided for @current.
  ///
  /// In it, this message translates to:
  /// **'Attuale'**
  String get current;

  /// No description provided for @target.
  ///
  /// In it, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @volumeCalculation.
  ///
  /// In it, this message translates to:
  /// **'Calcolo Volume Acquario'**
  String get volumeCalculation;

  /// No description provided for @additivesDosageCalculation.
  ///
  /// In it, this message translates to:
  /// **'Calcolo Dosaggio Additivi'**
  String get additivesDosageCalculation;

  /// No description provided for @waterChangeCalculation.
  ///
  /// In it, this message translates to:
  /// **'Calcolo Cambio Acqua'**
  String get waterChangeCalculation;

  /// No description provided for @densitySalinityConversion.
  ///
  /// In it, this message translates to:
  /// **'Conversione Densità/Salinità'**
  String get densitySalinityConversion;

  /// No description provided for @lightingCalculation.
  ///
  /// In it, this message translates to:
  /// **'Calcolo Illuminazione'**
  String get lightingCalculation;

  /// No description provided for @enterAquariumDimensions.
  ///
  /// In it, this message translates to:
  /// **'Inserisci le dimensioni dell\'acquario in centimetri'**
  String get enterAquariumDimensions;

  /// No description provided for @length.
  ///
  /// In it, this message translates to:
  /// **'Lunghezza (cm)'**
  String get length;

  /// No description provided for @width.
  ///
  /// In it, this message translates to:
  /// **'Larghezza (cm)'**
  String get width;

  /// No description provided for @height.
  ///
  /// In it, this message translates to:
  /// **'Altezza (cm)'**
  String get height;

  /// No description provided for @calculateVolume.
  ///
  /// In it, this message translates to:
  /// **'Calcola Volume'**
  String get calculateVolume;

  /// No description provided for @totalVolume.
  ///
  /// In it, this message translates to:
  /// **'Volume Totale'**
  String get totalVolume;

  /// No description provided for @estimatedNetVolume.
  ///
  /// In it, this message translates to:
  /// **'Volume netto stimato: {volume} L'**
  String estimatedNetVolume(String volume);

  /// No description provided for @consideringRocksAndSubstrate.
  ///
  /// In it, this message translates to:
  /// **'(considerando rocce e substrato)'**
  String get consideringRocksAndSubstrate;

  /// No description provided for @calculateAdditiveDosage.
  ///
  /// In it, this message translates to:
  /// **'Calcola la quantità di additivo da dosare'**
  String get calculateAdditiveDosage;

  /// No description provided for @dosageSection.
  ///
  /// In it, this message translates to:
  /// **'── DOSAGGIO ──'**
  String get dosageSection;

  /// No description provided for @reductionSection.
  ///
  /// In it, this message translates to:
  /// **'── RIDUZIONE ──'**
  String get reductionSection;

  /// No description provided for @calcium.
  ///
  /// In it, this message translates to:
  /// **'Calcio'**
  String get calcium;

  /// No description provided for @magnesium.
  ///
  /// In it, this message translates to:
  /// **'Magnesio'**
  String get magnesium;

  /// No description provided for @kh.
  ///
  /// In it, this message translates to:
  /// **'KH'**
  String get kh;

  /// No description provided for @iodine.
  ///
  /// In it, this message translates to:
  /// **'Iodio'**
  String get iodine;

  /// No description provided for @strontium.
  ///
  /// In it, this message translates to:
  /// **'Stronzio'**
  String get strontium;

  /// No description provided for @nitrates.
  ///
  /// In it, this message translates to:
  /// **'Nitrati (NO3)'**
  String get nitrates;

  /// No description provided for @phosphates.
  ///
  /// In it, this message translates to:
  /// **'Fosfati (PO4)'**
  String get phosphates;

  /// No description provided for @no3po4xRedSea.
  ///
  /// In it, this message translates to:
  /// **'NO3:PO4-X (Red Sea)'**
  String get no3po4xRedSea;

  /// No description provided for @activeCarbon.
  ///
  /// In it, this message translates to:
  /// **'Carbonio Attivo'**
  String get activeCarbon;

  /// No description provided for @aquariumVolume.
  ///
  /// In it, this message translates to:
  /// **'Volume acquario (L)'**
  String get aquariumVolume;

  /// No description provided for @currentValue.
  ///
  /// In it, this message translates to:
  /// **'Valore attuale ({unit})'**
  String currentValue(String unit);

  /// No description provided for @calculateDosage.
  ///
  /// In it, this message translates to:
  /// **'Calcola Dosaggio'**
  String get calculateDosage;

  /// No description provided for @quantityToDose.
  ///
  /// In it, this message translates to:
  /// **'Quantità da dosare'**
  String get quantityToDose;

  /// No description provided for @quantityToDoseReduction.
  ///
  /// In it, this message translates to:
  /// **'Quantità da dosare (riduzione)'**
  String get quantityToDoseReduction;

  /// No description provided for @indicativeValuesCheckManufacturer.
  ///
  /// In it, this message translates to:
  /// **'⚠️ Valori indicativi: verifica le istruzioni del produttore'**
  String get indicativeValuesCheckManufacturer;

  /// No description provided for @toReduceNitrates.
  ///
  /// In it, this message translates to:
  /// **'Per ridurre i Nitrati:\\n• Cambio acqua regolare (20% settimanale)\\n• Skimmer efficiente\\n• Refill osmosi\\n• Carbonio attivo liquido\\n• NO3:PO4-X (Red Sea)'**
  String get toReduceNitrates;

  /// No description provided for @toReducePhosphates.
  ///
  /// In it, this message translates to:
  /// **'Per ridurre i Fosfati:\\n• Resine anti-fosfati (GFO)\\n• Skimmer efficiente\\n• Cambio acqua regolare\\n• NO3:PO4-X (Red Sea)\\n• Evitare sovralimentazione'**
  String get toReducePhosphates;

  /// No description provided for @calculateLitersAndSalt.
  ///
  /// In it, this message translates to:
  /// **'Calcola litri e sale necessario per il cambio acqua'**
  String get calculateLitersAndSalt;

  /// No description provided for @percentageToChange.
  ///
  /// In it, this message translates to:
  /// **'Percentuale da cambiare (%)'**
  String get percentageToChange;

  /// No description provided for @calculateWaterChange.
  ///
  /// In it, this message translates to:
  /// **'Calcola Cambio Acqua'**
  String get calculateWaterChange;

  /// No description provided for @waterToChange.
  ///
  /// In it, this message translates to:
  /// **'Acqua da cambiare'**
  String get waterToChange;

  /// No description provided for @saltNeeded.
  ///
  /// In it, this message translates to:
  /// **'Sale necessario'**
  String get saltNeeded;

  /// No description provided for @calculatedForSalinity.
  ///
  /// In it, this message translates to:
  /// **'Calcolato per salinità 1.025 (35g/L)'**
  String get calculatedForSalinity;

  /// No description provided for @convertBetweenDensityAndSalinity.
  ///
  /// In it, this message translates to:
  /// **'Converti tra densità e salinità'**
  String get convertBetweenDensityAndSalinity;

  /// No description provided for @fromDensityToSalinity.
  ///
  /// In it, this message translates to:
  /// **'Da Densità (g/cm³) a Salinità (ppt)'**
  String get fromDensityToSalinity;

  /// No description provided for @fromSalinityToDensity.
  ///
  /// In it, this message translates to:
  /// **'Da Salinità (ppt) a Densità (g/cm³)'**
  String get fromSalinityToDensity;

  /// No description provided for @densityExample.
  ///
  /// In it, this message translates to:
  /// **'Densità (es: 1.025)'**
  String get densityExample;

  /// No description provided for @salinityExample.
  ///
  /// In it, this message translates to:
  /// **'Salinità (ppt, es: 35)'**
  String get salinityExample;

  /// No description provided for @temperatureCelsius.
  ///
  /// In it, this message translates to:
  /// **'Temperatura (°C)'**
  String get temperatureCelsius;

  /// No description provided for @salinityPPT.
  ///
  /// In it, this message translates to:
  /// **'Salinità'**
  String get salinityPPT;

  /// No description provided for @salinityPPM.
  ///
  /// In it, this message translates to:
  /// **'Salinità (ppm)'**
  String get salinityPPM;

  /// No description provided for @density.
  ///
  /// In it, this message translates to:
  /// **'Densità'**
  String get density;

  /// No description provided for @convert.
  ///
  /// In it, this message translates to:
  /// **'Converti'**
  String get convert;

  /// No description provided for @calculateLightingRequirements.
  ///
  /// In it, this message translates to:
  /// **'Calcola il fabbisogno di illuminazione per il tuo acquario'**
  String get calculateLightingRequirements;

  /// No description provided for @tankType.
  ///
  /// In it, this message translates to:
  /// **'Tipo di vasca'**
  String get tankType;

  /// No description provided for @fishOnly.
  ///
  /// In it, this message translates to:
  /// **'Solo Pesci'**
  String get fishOnly;

  /// No description provided for @fishAndSoftCorals.
  ///
  /// In it, this message translates to:
  /// **'Pesci + Coralli Molli'**
  String get fishAndSoftCorals;

  /// No description provided for @spsCorals.
  ///
  /// In it, this message translates to:
  /// **'Coralli SPS'**
  String get spsCorals;

  /// No description provided for @totalWatts.
  ///
  /// In it, this message translates to:
  /// **'Watt totali illuminazione'**
  String get totalWatts;

  /// No description provided for @calculateLighting.
  ///
  /// In it, this message translates to:
  /// **'Calcola Illuminazione'**
  String get calculateLighting;

  /// No description provided for @wattsPerLiter.
  ///
  /// In it, this message translates to:
  /// **'Watt per litro'**
  String get wattsPerLiter;

  /// No description provided for @recommendation.
  ///
  /// In it, this message translates to:
  /// **'Raccomandazione'**
  String get recommendation;

  /// No description provided for @insufficientMinimumFish.
  ///
  /// In it, this message translates to:
  /// **'Insufficiente - Minimo 0.25 W/L per pesci'**
  String get insufficientMinimumFish;

  /// No description provided for @optimalForFishOnly.
  ///
  /// In it, this message translates to:
  /// **'Ottimale per vasca di soli pesci'**
  String get optimalForFishOnly;

  /// No description provided for @excessiveAlgaeRisk.
  ///
  /// In it, this message translates to:
  /// **'Eccessivo - Rischio alghe'**
  String get excessiveAlgaeRisk;

  /// No description provided for @insufficientMinimumSoft.
  ///
  /// In it, this message translates to:
  /// **'Insufficiente - Minimo 0.5 W/L'**
  String get insufficientMinimumSoft;

  /// No description provided for @optimalForSoftCorals.
  ///
  /// In it, this message translates to:
  /// **'Ottimale per coralli molli (LPS)'**
  String get optimalForSoftCorals;

  /// No description provided for @veryGoodAlsoSPS.
  ///
  /// In it, this message translates to:
  /// **'Molto buono - Adatto anche SPS'**
  String get veryGoodAlsoSPS;

  /// No description provided for @insufficientMinimumSPS.
  ///
  /// In it, this message translates to:
  /// **'Insufficiente - Minimo 1.0 W/L per SPS'**
  String get insufficientMinimumSPS;

  /// No description provided for @optimalForSPS.
  ///
  /// In it, this message translates to:
  /// **'Ottimale per coralli SPS'**
  String get optimalForSPS;

  /// No description provided for @veryPowerfulExcellentSPS.
  ///
  /// In it, this message translates to:
  /// **'Molto potente - Ottimo per SPS esigenti'**
  String get veryPowerfulExcellentSPS;

  /// No description provided for @acceptable.
  ///
  /// In it, this message translates to:
  /// **'Accettabile'**
  String get acceptable;

  /// No description provided for @toCorrect.
  ///
  /// In it, this message translates to:
  /// **'Da correggere'**
  String get toCorrect;

  /// No description provided for @targetTemperature.
  ///
  /// In it, this message translates to:
  /// **'Target Temperatura'**
  String get targetTemperature;

  /// No description provided for @setDesiredTemperature.
  ///
  /// In it, this message translates to:
  /// **'Imposta la temperatura desiderata:'**
  String get setDesiredTemperature;

  /// No description provided for @typicalRangeTemperature.
  ///
  /// In it, this message translates to:
  /// **'Range tipico: 24-26 °C'**
  String get typicalRangeTemperature;

  /// No description provided for @targetSalinity.
  ///
  /// In it, this message translates to:
  /// **'Target Salinità'**
  String get targetSalinity;

  /// No description provided for @setDesiredSalinity.
  ///
  /// In it, this message translates to:
  /// **'Imposta il valore di salinità desiderato:'**
  String get setDesiredSalinity;

  /// No description provided for @typicalRangeSalinity.
  ///
  /// In it, this message translates to:
  /// **'Range tipico: 1020-1028'**
  String get typicalRangeSalinity;

  /// No description provided for @targetPh.
  ///
  /// In it, this message translates to:
  /// **'Target pH'**
  String get targetPh;

  /// No description provided for @setDesiredPh.
  ///
  /// In it, this message translates to:
  /// **'Imposta il valore pH desiderato:'**
  String get setDesiredPh;

  /// No description provided for @typicalRangePh.
  ///
  /// In it, this message translates to:
  /// **'Range tipico: 8.0-8.4'**
  String get typicalRangePh;

  /// No description provided for @targetOrp.
  ///
  /// In it, this message translates to:
  /// **'Target ORP'**
  String get targetOrp;

  /// No description provided for @setDesiredOrp.
  ///
  /// In it, this message translates to:
  /// **'Imposta il valore ORP desiderato:'**
  String get setDesiredOrp;

  /// No description provided for @typicalRangeOrp.
  ///
  /// In it, this message translates to:
  /// **'Range tipico: 300-400 mV'**
  String get typicalRangeOrp;

  /// No description provided for @newAquarium.
  ///
  /// In it, this message translates to:
  /// **'Nuovo Acquario'**
  String get newAquarium;

  /// No description provided for @createNewAquarium.
  ///
  /// In it, this message translates to:
  /// **'Crea Nuovo Acquario'**
  String get createNewAquarium;

  /// No description provided for @fillTankDetails.
  ///
  /// In it, this message translates to:
  /// **'Compila i dettagli della vasca'**
  String get fillTankDetails;

  /// No description provided for @aquariumName.
  ///
  /// In it, this message translates to:
  /// **'Nome Acquario'**
  String get aquariumName;

  /// No description provided for @aquariumNameHint.
  ///
  /// In it, this message translates to:
  /// **'es. La Mia Vasca'**
  String get aquariumNameHint;

  /// No description provided for @enterName.
  ///
  /// In it, this message translates to:
  /// **'Inserisci un nome'**
  String get enterName;

  /// No description provided for @aquariumType.
  ///
  /// In it, this message translates to:
  /// **'Tipo Acquario'**
  String get aquariumType;

  /// No description provided for @marine.
  ///
  /// In it, this message translates to:
  /// **'Marino'**
  String get marine;

  /// No description provided for @freshwater.
  ///
  /// In it, this message translates to:
  /// **'Dolce'**
  String get freshwater;

  /// No description provided for @reef.
  ///
  /// In it, this message translates to:
  /// **'Reef'**
  String get reef;

  /// No description provided for @volumeLiters.
  ///
  /// In it, this message translates to:
  /// **'Volume (Litri)'**
  String get volumeLiters;

  /// No description provided for @volumeHint.
  ///
  /// In it, this message translates to:
  /// **'es. 200'**
  String get volumeHint;

  /// No description provided for @enterVolume.
  ///
  /// In it, this message translates to:
  /// **'Inserisci il volume'**
  String get enterVolume;

  /// No description provided for @saveAquarium.
  ///
  /// In it, this message translates to:
  /// **'Salva Acquario'**
  String get saveAquarium;

  /// No description provided for @aquariumCreatedSuccess.
  ///
  /// In it, this message translates to:
  /// **'Acquario \"{name}\" creato con successo!'**
  String aquariumCreatedSuccess(String name);

  /// No description provided for @deleteAquarium.
  ///
  /// In it, this message translates to:
  /// **'Elimina Acquario'**
  String get deleteAquarium;

  /// No description provided for @errorLoading.
  ///
  /// In it, this message translates to:
  /// **'Errore nel caricamento: {error}'**
  String errorLoading(String error);

  /// No description provided for @cannotDeleteMissingId.
  ///
  /// In it, this message translates to:
  /// **'Impossibile eliminare: ID acquario mancante'**
  String get cannotDeleteMissingId;

  /// No description provided for @confirmDeleteAquarium.
  ///
  /// In it, this message translates to:
  /// **'Sei sicuro di voler eliminare \'{name}\'?'**
  String confirmDeleteAquarium(String name);

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In it, this message translates to:
  /// **'Questa azione non può essere annullata.'**
  String get actionCannotBeUndone;

  /// No description provided for @aquariumDeletedSuccess.
  ///
  /// In it, this message translates to:
  /// **'Acquario eliminato con successo'**
  String get aquariumDeletedSuccess;

  /// No description provided for @errorWithMessage.
  ///
  /// In it, this message translates to:
  /// **'Errore: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @noAquariumsToDelete.
  ///
  /// In it, this message translates to:
  /// **'Nessun acquario da eliminare'**
  String get noAquariumsToDelete;

  /// No description provided for @aquariumManagement.
  ///
  /// In it, this message translates to:
  /// **'Gestione Acquari'**
  String get aquariumManagement;

  /// No description provided for @selectToDelete.
  ///
  /// In it, this message translates to:
  /// **'Seleziona un acquario da eliminare'**
  String get selectToDelete;

  /// No description provided for @editAquarium.
  ///
  /// In it, this message translates to:
  /// **'Modifica Acquario'**
  String get editAquarium;

  /// No description provided for @selectAquarium.
  ///
  /// In it, this message translates to:
  /// **'Seleziona Acquario'**
  String get selectAquarium;

  /// No description provided for @chooseAquariumToEdit.
  ///
  /// In it, this message translates to:
  /// **'Scegli un acquario da modificare'**
  String get chooseAquariumToEdit;

  /// No description provided for @noAquariumsFound.
  ///
  /// In it, this message translates to:
  /// **'Nessuna vasca trovata'**
  String get noAquariumsFound;

  /// No description provided for @editDetails.
  ///
  /// In it, this message translates to:
  /// **'Modifica Dettagli'**
  String get editDetails;

  /// No description provided for @updateAquarium.
  ///
  /// In it, this message translates to:
  /// **'Aggiorna {name}'**
  String updateAquarium(String name);

  /// No description provided for @saveChanges.
  ///
  /// In it, this message translates to:
  /// **'Salva Modifiche'**
  String get saveChanges;

  /// No description provided for @changesSavedFor.
  ///
  /// In it, this message translates to:
  /// **'Modifiche salvate per \"{name}\"'**
  String changesSavedFor(String name);

  /// No description provided for @errorSavingChanges.
  ///
  /// In it, this message translates to:
  /// **'Errore nel salvare le modifiche: {error}'**
  String errorSavingChanges(String error);

  /// No description provided for @chartHistoryTitle.
  ///
  /// In it, this message translates to:
  /// **'Storico {parameter}'**
  String chartHistoryTitle(String parameter);

  /// No description provided for @chartNoData.
  ///
  /// In it, this message translates to:
  /// **'Nessun dato disponibile'**
  String get chartNoData;

  /// No description provided for @chartStatMin.
  ///
  /// In it, this message translates to:
  /// **'Min'**
  String get chartStatMin;

  /// No description provided for @chartStatAvg.
  ///
  /// In it, this message translates to:
  /// **'Avg'**
  String get chartStatAvg;

  /// No description provided for @chartStatMax.
  ///
  /// In it, this message translates to:
  /// **'Max'**
  String get chartStatMax;

  /// No description provided for @chartStatNow.
  ///
  /// In it, this message translates to:
  /// **'Now'**
  String get chartStatNow;

  /// No description provided for @chartLegendIdeal.
  ///
  /// In it, this message translates to:
  /// **'Ideale'**
  String get chartLegendIdeal;

  /// No description provided for @chartLegendWarning.
  ///
  /// In it, this message translates to:
  /// **'Avviso'**
  String get chartLegendWarning;

  /// No description provided for @chartAdvancedAnalysis.
  ///
  /// In it, this message translates to:
  /// **'Analisi Avanzata'**
  String get chartAdvancedAnalysis;

  /// No description provided for @chartTrendLabel.
  ///
  /// In it, this message translates to:
  /// **'Trend'**
  String get chartTrendLabel;

  /// No description provided for @chartStabilityLabel.
  ///
  /// In it, this message translates to:
  /// **'Stabilità'**
  String get chartStabilityLabel;

  /// No description provided for @chartTrendStable.
  ///
  /// In it, this message translates to:
  /// **'Stabile'**
  String get chartTrendStable;

  /// No description provided for @chartTrendRising.
  ///
  /// In it, this message translates to:
  /// **'In aumento'**
  String get chartTrendRising;

  /// No description provided for @chartTrendFalling.
  ///
  /// In it, this message translates to:
  /// **'In calo'**
  String get chartTrendFalling;

  /// No description provided for @chartStabilityExcellent.
  ///
  /// In it, this message translates to:
  /// **'Ottima'**
  String get chartStabilityExcellent;

  /// No description provided for @chartStabilityGood.
  ///
  /// In it, this message translates to:
  /// **'Buona'**
  String get chartStabilityGood;

  /// No description provided for @chartStabilityMedium.
  ///
  /// In it, this message translates to:
  /// **'Media'**
  String get chartStabilityMedium;

  /// No description provided for @chartStabilityLow.
  ///
  /// In it, this message translates to:
  /// **'Bassa'**
  String get chartStabilityLow;

  /// No description provided for @chartAdviceOutOfRange.
  ///
  /// In it, this message translates to:
  /// **'Attenzione: {parameter} fuori range. Controlla subito e correggi.'**
  String chartAdviceOutOfRange(String parameter);

  /// No description provided for @chartAdviceNotIdeal.
  ///
  /// In it, this message translates to:
  /// **'Parametro accettabile ma non ideale. Monitora attentamente.'**
  String get chartAdviceNotIdeal;

  /// No description provided for @chartAdviceUnstable.
  ///
  /// In it, this message translates to:
  /// **'Parametro instabile. Verifica cambio acqua e dosaggi additivi.'**
  String get chartAdviceUnstable;

  /// No description provided for @chartAdviceTempRising.
  ///
  /// In it, this message translates to:
  /// **'Temperatura in aumento. Verifica raffreddamento e ventilazione.'**
  String get chartAdviceTempRising;

  /// No description provided for @chartAdviceOptimal.
  ///
  /// In it, this message translates to:
  /// **'Parametro ottimale e stabile.'**
  String get chartAdviceOptimal;

  /// No description provided for @paramTemperature.
  ///
  /// In it, this message translates to:
  /// **'Temperatura'**
  String get paramTemperature;

  /// No description provided for @paramPH.
  ///
  /// In it, this message translates to:
  /// **'pH'**
  String get paramPH;

  /// No description provided for @paramSalinity.
  ///
  /// In it, this message translates to:
  /// **'Salinità'**
  String get paramSalinity;

  /// No description provided for @paramORP.
  ///
  /// In it, this message translates to:
  /// **'ORP'**
  String get paramORP;

  /// No description provided for @errorLoadingTasks.
  ///
  /// In it, this message translates to:
  /// **'Errore caricamento task: {error}'**
  String errorLoadingTasks(String error);

  /// No description provided for @addTask.
  ///
  /// In it, this message translates to:
  /// **'Aggiungi Task'**
  String get addTask;

  /// No description provided for @inProgress.
  ///
  /// In it, this message translates to:
  /// **'In Corso ({count})'**
  String inProgress(int count);

  /// No description provided for @completed.
  ///
  /// In it, this message translates to:
  /// **'Completati ({count})'**
  String completed(int count);

  /// No description provided for @overdue.
  ///
  /// In it, this message translates to:
  /// **'In Ritardo'**
  String get overdue;

  /// No description provided for @today.
  ///
  /// In it, this message translates to:
  /// **'Oggi'**
  String get today;

  /// No description provided for @week.
  ///
  /// In it, this message translates to:
  /// **'Settimana'**
  String get week;

  /// No description provided for @all.
  ///
  /// In it, this message translates to:
  /// **'Tutti'**
  String get all;

  /// No description provided for @noCompletedTasks.
  ///
  /// In it, this message translates to:
  /// **'Nessun task completato'**
  String get noCompletedTasks;

  /// No description provided for @noTasksInProgress.
  ///
  /// In it, this message translates to:
  /// **'Nessun task in corso'**
  String get noTasksInProgress;

  /// No description provided for @overdueDays.
  ///
  /// In it, this message translates to:
  /// **'In ritardo di {days} giorni'**
  String overdueDays(int days);

  /// No description provided for @dueToday.
  ///
  /// In it, this message translates to:
  /// **'Scade oggi'**
  String get dueToday;

  /// No description provided for @inDays.
  ///
  /// In it, this message translates to:
  /// **'Tra {days} giorni'**
  String inDays(int days);

  /// No description provided for @completedOn.
  ///
  /// In it, this message translates to:
  /// **'Completato: {date}'**
  String completedOn(String date);

  /// No description provided for @newTask.
  ///
  /// In it, this message translates to:
  /// **'Nuovo Task'**
  String get newTask;

  /// No description provided for @taskTitle.
  ///
  /// In it, this message translates to:
  /// **'Titolo Task'**
  String get taskTitle;

  /// No description provided for @taskDescription.
  ///
  /// In it, this message translates to:
  /// **'Descrizione (opzionale)'**
  String get taskDescription;

  /// No description provided for @category.
  ///
  /// In it, this message translates to:
  /// **'Categoria'**
  String get category;

  /// No description provided for @frequency.
  ///
  /// In it, this message translates to:
  /// **'Frequenza'**
  String get frequency;

  /// No description provided for @everyDays.
  ///
  /// In it, this message translates to:
  /// **'Ogni {days} giorni'**
  String everyDays(int days);

  /// No description provided for @reminder.
  ///
  /// In it, this message translates to:
  /// **'Promemoria'**
  String get reminder;

  /// No description provided for @enabled.
  ///
  /// In it, this message translates to:
  /// **'Abilitato'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In it, this message translates to:
  /// **'Disabilitato'**
  String get disabled;

  /// No description provided for @time.
  ///
  /// In it, this message translates to:
  /// **'Orario'**
  String get time;

  /// No description provided for @enterTaskTitle.
  ///
  /// In it, this message translates to:
  /// **'Inserisci un titolo'**
  String get enterTaskTitle;

  /// No description provided for @water.
  ///
  /// In it, this message translates to:
  /// **'Acqua'**
  String get water;

  /// No description provided for @cleaning.
  ///
  /// In it, this message translates to:
  /// **'Pulizia'**
  String get cleaning;

  /// No description provided for @testing.
  ///
  /// In it, this message translates to:
  /// **'Test'**
  String get testing;

  /// No description provided for @feeding.
  ///
  /// In it, this message translates to:
  /// **'Alimentazione'**
  String get feeding;

  /// No description provided for @equipment.
  ///
  /// In it, this message translates to:
  /// **'Attrezzatura'**
  String get equipment;

  /// No description provided for @other.
  ///
  /// In it, this message translates to:
  /// **'Altro'**
  String get other;

  /// No description provided for @createCustomMaintenance.
  ///
  /// In it, this message translates to:
  /// **'Crea una manutenzione personalizzata'**
  String get createCustomMaintenance;

  /// No description provided for @day.
  ///
  /// In it, this message translates to:
  /// **'giorno'**
  String get day;

  /// No description provided for @enableReminder.
  ///
  /// In it, this message translates to:
  /// **'Abilita promemoria'**
  String get enableReminder;

  /// No description provided for @at.
  ///
  /// In it, this message translates to:
  /// **'Alle'**
  String get at;

  /// No description provided for @noReminder.
  ///
  /// In it, this message translates to:
  /// **'Nessun promemoria'**
  String get noReminder;

  /// No description provided for @changeTime.
  ///
  /// In it, this message translates to:
  /// **'Cambia orario ({time})'**
  String changeTime(String time);

  /// No description provided for @notifications.
  ///
  /// In it, this message translates to:
  /// **'Notifiche'**
  String get notifications;

  /// No description provided for @settingsSaved.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni salvate'**
  String get settingsSaved;

  /// No description provided for @settingsTab.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get settingsTab;

  /// No description provided for @thresholdsTab.
  ///
  /// In it, this message translates to:
  /// **'Soglie'**
  String get thresholdsTab;

  /// No description provided for @historyTab.
  ///
  /// In it, this message translates to:
  /// **'Storico'**
  String get historyTab;

  /// No description provided for @alertParameters.
  ///
  /// In it, this message translates to:
  /// **'Alert Parametri'**
  String get alertParameters;

  /// No description provided for @alertParametersSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Notifiche quando i parametri sono fuori range'**
  String get alertParametersSubtitle;

  /// No description provided for @maintenanceReminders.
  ///
  /// In it, this message translates to:
  /// **'Promemoria Manutenzione'**
  String get maintenanceReminders;

  /// No description provided for @maintenanceRemindersSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Notifiche per cambio acqua, pulizia filtro, ecc.'**
  String get maintenanceRemindersSubtitle;

  /// No description provided for @dailySummary.
  ///
  /// In it, this message translates to:
  /// **'Riepilogo Giornaliero'**
  String get dailySummary;

  /// No description provided for @dailySummarySubtitle.
  ///
  /// In it, this message translates to:
  /// **'Notifica giornaliera con stato acquario'**
  String get dailySummarySubtitle;

  /// No description provided for @maintenanceFrequency.
  ///
  /// In it, this message translates to:
  /// **'Frequenza Manutenzione'**
  String get maintenanceFrequency;

  /// No description provided for @resetDefaults.
  ///
  /// In it, this message translates to:
  /// **'Ripristina Valori Predefiniti'**
  String get resetDefaults;

  /// No description provided for @parameterThresholds.
  ///
  /// In it, this message translates to:
  /// **'Soglie Parametri'**
  String get parameterThresholds;

  /// No description provided for @min.
  ///
  /// In it, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @max.
  ///
  /// In it, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @alertHistory.
  ///
  /// In it, this message translates to:
  /// **'Storico Alert'**
  String get alertHistory;

  /// No description provided for @recentNotifications.
  ///
  /// In it, this message translates to:
  /// **'{count} notifiche recenti'**
  String recentNotifications(int count);

  /// No description provided for @noNotificationsYet.
  ///
  /// In it, this message translates to:
  /// **'Nessuna notifica ancora'**
  String get noNotificationsYet;

  /// No description provided for @resetDefaultsQuestion.
  ///
  /// In it, this message translates to:
  /// **'Ripristinare Predefiniti?'**
  String get resetDefaultsQuestion;

  /// No description provided for @resetDefaultsMessage.
  ///
  /// In it, this message translates to:
  /// **'Questa azione resetterà tutte le soglie personalizzate ai valori di default:'**
  String get resetDefaultsMessage;

  /// No description provided for @resetButton.
  ///
  /// In it, this message translates to:
  /// **'Ripristina'**
  String get resetButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
