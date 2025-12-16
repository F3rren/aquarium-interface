// QUESTO È UN FILE TEMPORANEO
// Verrà sostituito automaticamente da Flutter quando esegui il primo build
// Non modificare questo file manualmente

// ignore_for_file: unused_import, implementation_imports
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_it.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_de.dart';
import 'app_localizations_fr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('it'),
    Locale('en'),
    Locale('es'),
    Locale('de'),
    Locale('fr'),
  ];

  String get appTitle;
  String get aquariums;
  String get aquarium;
  String get parameters;
  String get fish;
  String get fishes;
  String get corals;
  String get coral;
  String get maintenance;
  String get alerts;
  String get settings;
  String get noAquarium;
  String get noAquariumDescription;
  String get createAquarium;
  String get noFish;
  String get noFishDescription;
  String get addFish;
  String get noCoral;
  String get noCoralDescription;
  String get addCoral;
  String get noHistory;
  String get noHistoryDescription;
  String get noTasks;
  String get noTasksDescription;
  String get createTask;
  String get allOk;
  String get allOkDescription;
  String get noResults;
  String noResultsDescription(String query);
  String get errorTitle;
  String get errorDescription;
  String get retry;
  String get offline;
  String get offlineDescription;
  String get save;
  String get cancel;
  String get delete;
  String get edit;
  String get close;
  String get ok;
  String get name;
  String get species;
  String get size;
  String get notes;
  String get date;
  String get quantity;
  String get addFishTitle;
  String get editFishTitle;
  String get fishNameLabel;
  String get fishNameHint;
  String get fishSpeciesLabel;
  String get fishSpeciesHint;
  String get fishSizeLabel;
  String get fishSizeHint;
  String get quantityLabel;
  String get quantityHint;
  String get quantityInfo;
  String get notesLabel;
  String get notesHint;
  String get selectFromList;
  String get orEnterManually;
  String noCompatibleFish(String waterType);
  String get noDatabaseFish;
  String get addCoralTitle;
  String get editCoralTitle;
  String get coralNameLabel;
  String get coralNameHint;
  String get coralSpeciesLabel;
  String get coralSpeciesHint;
  String get coralTypeLabel;
  String get coralSizeLabel;
  String get coralSizeHint;
  String get coralPlacementLabel;
  String get coralTypeSPS;
  String get coralTypeLPS;
  String get coralTypeSoft;
  String get placementTop;
  String get placementMiddle;
  String get placementBottom;
  String get difficultyEasy;
  String get difficultyIntermediate;
  String get difficultyHard;
  String get difficultyBeginner;
  String get difficultyExpert;
  String get temperamentPeaceful;
  String get temperamentSemiAggressive;
  String get temperamentAggressive;
  String get dietHerbivore;
  String get dietCarnivore;
  String get dietOmnivore;
  String get reefSafe;
  String get yes;
  String get no;
  String get difficulty;
  String get minTankSize;
  String get temperament;
  String get diet;
  String get filtersAndSearch;
  String get clearAll;
  String get searchByName;
  String get searchPlaceholder;
  String get insertionDate;
  String get selectType;
  String get selectDate;
  String get removeDateFilter;
  String get sorting;
  String get ascendingOrder;
  String get fillAllFields;
  String get invalidSize;
  String get invalidQuantity;
  String databaseLoadError(String error);
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
      <String>['it', 'en', 'es', 'de', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
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
