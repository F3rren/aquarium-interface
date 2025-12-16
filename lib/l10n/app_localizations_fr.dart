// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ReefLife';

  @override
  String get aquariums => 'Aquariums';

  @override
  String get aquarium => 'Aquarium';

  @override
  String get parameters => 'Paramètres';

  @override
  String get fish => 'Poissons';

  @override
  String get fishes => 'Poissons';

  @override
  String get corals => 'Coraux';

  @override
  String get coral => 'Corail';

  @override
  String get maintenance => 'Entretien';

  @override
  String get alerts => 'Alertes';

  @override
  String get settings => 'Paramètres';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get charts => 'Graphiques';

  @override
  String get profile => 'Profil';

  @override
  String get myAquarium => 'Mon Aquarium';

  @override
  String get noAquarium => 'Aucun Aquarium';

  @override
  String get noAquariumDescription =>
      'Commencez par créer votre premier aquarium pour surveiller les paramètres de l\'eau et la santé de vos poissons.';

  @override
  String get createAquarium => 'Créer Aquarium';

  @override
  String get noFish => 'Aucun Poisson';

  @override
  String get noFishDescription =>
      'Ajoutez vos poissons pour suivre la population de votre aquarium.';

  @override
  String get addFish => 'Ajouter Poisson';

  @override
  String get noCoral => 'Aucun Corail';

  @override
  String get noCoralDescription =>
      'Documentez les coraux présents dans votre aquarium marin.';

  @override
  String get addCoral => 'Ajouter Corail';

  @override
  String get noHistory => 'Aucun Historique';

  @override
  String get noHistoryDescription =>
      'Aucune donnée historique disponible pour le moment. Les paramètres seront enregistrés automatiquement.';

  @override
  String get noTasks => 'Aucune Tâche';

  @override
  String get noTasksDescription =>
      'Créez des rappels pour les activités d\'entretien de votre aquarium.';

  @override
  String get createTask => 'Créer Tâche';

  @override
  String get allOk => 'TOUT OK';

  @override
  String get allOkDescription =>
      'Aucune alerte active. Tous les paramètres sont dans la plage normale.';

  @override
  String get noResults => 'Aucun Résultat';

  @override
  String noResultsDescription(String query) {
    return 'Nous n\'avons trouvé aucun résultat pour \"$query\".\nEssayez avec des mots-clés différents.';
  }

  @override
  String get errorTitle => 'Oups!';

  @override
  String get errorDescription => 'Une erreur s\'est produite';

  @override
  String get retry => 'Réessayer';

  @override
  String get offline => 'Vous êtes hors ligne';

  @override
  String get offlineDescription =>
      'Vérifiez votre connexion Internet et réessayez.';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String edit(String name) {
    return 'Modifier $name';
  }

  @override
  String get close => 'Fermer';

  @override
  String get ok => 'OK';

  @override
  String get name => 'Nom';

  @override
  String get species => 'Espèce';

  @override
  String get size => 'Taille';

  @override
  String get notes => 'Notes';

  @override
  String get date => 'Date';

  @override
  String get quantity => 'Quantité';

  @override
  String get addFishTitle => 'Ajouter Poisson';

  @override
  String get editFishTitle => 'Modifier Poisson';

  @override
  String get fishNameLabel => 'Nom *';

  @override
  String get fishNameHint => 'ex: Nemo';

  @override
  String get fishSpeciesLabel => 'Espèce *';

  @override
  String get fishSpeciesHint => 'ex: Amphiprion ocellaris';

  @override
  String get fishSizeLabel => 'Taille (cm) *';

  @override
  String get fishSizeHint => 'ex: 8.5';

  @override
  String get quantityLabel => 'Quantité';

  @override
  String get quantityHint => 'Nombre de spécimens à ajouter';

  @override
  String get quantityInfo =>
      'Si vous ajoutez plusieurs spécimens, ils seront automatiquement numérotés';

  @override
  String get notesLabel => 'Notes';

  @override
  String get notesHint => 'Ajouter des notes facultatives';

  @override
  String get selectFromList => 'Sélectionner dans la liste';

  @override
  String get orEnterManually => 'ou saisir manuellement';

  @override
  String noCompatibleFish(String waterType) {
    return 'Aucun poisson compatible avec aquarium $waterType';
  }

  @override
  String get noDatabaseFish =>
      'Aucun poisson disponible dans la base de données';

  @override
  String get addCoralTitle => 'Ajouter Corail';

  @override
  String get editCoralTitle => 'Modifier Corail';

  @override
  String get coralNameLabel => 'Nom *';

  @override
  String get coralNameHint => 'ex: Montipora orange';

  @override
  String get coralSpeciesLabel => 'Espèce *';

  @override
  String get coralSpeciesHint => 'ex: Montipora digitata';

  @override
  String get coralTypeLabel => 'Type *';

  @override
  String get coralSizeLabel => 'Taille (cm) *';

  @override
  String get coralSizeHint => 'ex: 5.0';

  @override
  String get coralPlacementLabel => 'Placement *';

  @override
  String get coralTypeSPS => 'SPS';

  @override
  String get coralTypeLPS => 'LPS';

  @override
  String get coralTypeSoft => 'Mous';

  @override
  String get placementTop => 'Haut';

  @override
  String get placementMiddle => 'Milieu';

  @override
  String get placementBottom => 'Bas';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyIntermediate => 'Intermédiaire';

  @override
  String get difficultyHard => 'Difficile';

  @override
  String get difficultyBeginner => 'Débutant';

  @override
  String get difficultyExpert => 'Expert';

  @override
  String get temperamentPeaceful => 'Pacifique';

  @override
  String get temperamentSemiAggressive => 'Semi-agressif';

  @override
  String get temperamentAggressive => 'Agressif';

  @override
  String get dietHerbivore => 'Herbivore';

  @override
  String get dietCarnivore => 'Carnivore';

  @override
  String get dietOmnivore => 'Omnivore';

  @override
  String get reefSafe => 'Sûr pour récif';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get difficulty => 'Difficulté';

  @override
  String get minTankSize => 'Taille min. aquarium';

  @override
  String get temperament => 'Tempérament';

  @override
  String get diet => 'Régime';

  @override
  String get filtersAndSearch => 'Filtres et Recherche';

  @override
  String get clearAll => 'Tout effacer';

  @override
  String get searchByName => 'Rechercher par nom';

  @override
  String get searchPlaceholder => 'Rechercher par nom...';

  @override
  String get insertionDate => 'Date d\'introduction dans l\'aquarium';

  @override
  String get selectType => 'Sélectionner type';

  @override
  String get selectDate => 'Sélectionner date';

  @override
  String get removeDateFilter => 'Retirer filtre de date';

  @override
  String get sorting => 'Tri';

  @override
  String get ascendingOrder => 'Ordre croissant';

  @override
  String get fillAllFields => 'Remplissez tous les champs obligatoires';

  @override
  String get invalidSize => 'Taille invalide';

  @override
  String get invalidQuantity => 'Quantité invalide';

  @override
  String databaseLoadError(String error) {
    return 'Erreur de chargement de la base de données: $error';
  }

  @override
  String get language => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get tools => 'Outils';

  @override
  String get calculators => 'Calculatrices';

  @override
  String get calculatorsSubtitle =>
      'Volume, dosage d\'additifs, changement d\'eau';

  @override
  String get myInhabitants => 'Mes Habitants';

  @override
  String get myInhabitantsSubtitle => 'Gérer poissons et coraux';

  @override
  String get aquariumInfo => 'Info Aquarium';

  @override
  String get aquariumInfoSubtitle => 'Nom, volume, type';

  @override
  String get theme => 'Thème';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get appInfo => 'Informations App';

  @override
  String get appInfoSubtitle => 'Version, crédits';

  @override
  String get noAquariumSelected => 'Aucun Aquarium';

  @override
  String unableToLoadInfo(String error) {
    return 'Impossible de charger les informations: $error';
  }

  @override
  String get errorLoadingParameters =>
      'Erreur lors du chargement des paramètres';

  @override
  String get warning => 'ATTENTION';

  @override
  String get critical => 'CRITIQUE';

  @override
  String get aquariumStatus => 'État de l\'Aquarium';

  @override
  String updatedNow(int okParams, int totalParams) {
    return 'Mis à jour maintenant • $okParams/$totalParams paramètres OK';
  }

  @override
  String get temperature => 'Température';

  @override
  String get ph => 'pH';

  @override
  String get salinity => 'Salinité';

  @override
  String get orp => 'ORP';

  @override
  String get excellent => 'Excellent';

  @override
  String get good => 'Bon';

  @override
  String get parametersOk => 'Paramètres OK';

  @override
  String parametersNeedAttention(int count) {
    return '$count paramètres nécessitent attention';
  }

  @override
  String get waterChange => 'Changement d\'Eau';

  @override
  String get healthScore => 'Score de Santé';

  @override
  String parametersInOptimalRange(int okParams, int totalParams) {
    return '$okParams/$totalParams paramètres dans la plage optimale';
  }

  @override
  String get upcomingReminders => 'Rappels à Venir';

  @override
  String get filterCleaning => 'Nettoyage du Filtre';

  @override
  String get parameterTesting => 'Test des Paramètres';

  @override
  String get days => 'jours';

  @override
  String get recommendations => 'Recommandations';

  @override
  String get checkOutOfRangeParameters => 'Vérifier les paramètres hors plage';

  @override
  String get checkSkimmer => 'Vérifier l\'écumeur';

  @override
  String get weeklyCleaningRecommended => 'Nettoyage hebdomadaire recommandé';

  @override
  String get khTest => 'Test KH';

  @override
  String get lastTest3DaysAgo => 'Dernier test: il y a 3 jours';

  @override
  String get parametersUpdated => 'Paramètres mis à jour';

  @override
  String get error => 'Erreur';

  @override
  String get noParametersAvailable => 'Aucun paramètre disponible';

  @override
  String get chemicalParameters => 'Paramètres Chimiques';

  @override
  String get calciumCa => 'Calcium (Ca)';

  @override
  String get magnesiumMg => 'Magnésium (Mg)';

  @override
  String get nitratesNO3 => 'Nitrates (NO3)';

  @override
  String get phosphatesPO4 => 'Phosphates (PO4)';

  @override
  String value(String unit) {
    return 'Valeur ($unit)';
  }

  @override
  String get low => 'Bas';

  @override
  String get high => 'Élevé';

  @override
  String get optimal => 'Optimal';

  @override
  String get attention => 'Attention';

  @override
  String get monitoring => 'Surveillance';

  @override
  String targetValue(String unit) {
    return 'Valeur cible ($unit)';
  }

  @override
  String get current => 'Actuel';

  @override
  String get target => 'Cible';

  @override
  String get volumeCalculation => 'Calcul du Volume de l\'Aquarium';

  @override
  String get additivesDosageCalculation => 'Calcul du Dosage d\'Additifs';

  @override
  String get waterChangeCalculation => 'Calcul du Changement d\'Eau';

  @override
  String get densitySalinityConversion => 'Conversion Densité/Salinité';

  @override
  String get lightingCalculation => 'Calcul de l\'Éclairage';

  @override
  String get enterAquariumDimensions =>
      'Entrez les dimensions de l\'aquarium en centimètres';

  @override
  String get length => 'Longueur (cm)';

  @override
  String get width => 'Largeur (cm)';

  @override
  String get height => 'Hauteur (cm)';

  @override
  String get calculateVolume => 'Calculer le Volume';

  @override
  String get totalVolume => 'Volume Total';

  @override
  String estimatedNetVolume(String volume) {
    return 'Volume net estimé: $volume L';
  }

  @override
  String get consideringRocksAndSubstrate =>
      '(en tenant compte des roches et du substrat)';

  @override
  String get calculateAdditiveDosage =>
      'Calculer la quantité d\'additif à doser';

  @override
  String get dosageSection => '── DOSAGE ──';

  @override
  String get reductionSection => '── RÉDUCTION ──';

  @override
  String get calcium => 'Calcium';

  @override
  String get magnesium => 'Magnésium';

  @override
  String get kh => 'KH';

  @override
  String get iodine => 'Iode';

  @override
  String get strontium => 'Strontium';

  @override
  String get nitrates => 'Nitrates (NO3)';

  @override
  String get phosphates => 'Phosphates (PO4)';

  @override
  String get no3po4xRedSea => 'NO3:PO4-X (Red Sea)';

  @override
  String get activeCarbon => 'Charbon Actif';

  @override
  String get aquariumVolume => 'Volume de l\'aquarium (L)';

  @override
  String currentValue(String unit) {
    return 'Valeur actuelle ($unit)';
  }

  @override
  String get calculateDosage => 'Calculer le Dosage';

  @override
  String get quantityToDose => 'Quantité à doser';

  @override
  String get quantityToDoseReduction => 'Quantité à doser (réduction)';

  @override
  String get indicativeValuesCheckManufacturer =>
      '⚠️ Valeurs indicatives: vérifier les instructions du fabricant';

  @override
  String get toReduceNitrates =>
      'Pour réduire les Nitrates:\\n• Changement d\'eau régulier (20% hebdomadaire)\\n• Écumeur efficace\\n• Recharge osmosée\\n• Charbon actif liquide\\n• NO3:PO4-X (Red Sea)';

  @override
  String get toReducePhosphates =>
      'Pour réduire les Phosphates:\\n• Résines anti-phosphates (GFO)\\n• Écumeur efficace\\n• Changement d\'eau régulier\\n• NO3:PO4-X (Red Sea)\\n• Éviter la suralimentation';

  @override
  String get calculateLitersAndSalt =>
      'Calculer les litres et le sel nécessaires pour le changement d\'eau';

  @override
  String get percentageToChange => 'Pourcentage à changer (%)';

  @override
  String get calculateWaterChange => 'Calculer le Changement d\'Eau';

  @override
  String get waterToChange => 'Eau à changer';

  @override
  String get saltNeeded => 'Sel nécessaire';

  @override
  String get calculatedForSalinity => 'Calculé pour salinité 1.025 (35g/L)';

  @override
  String get convertBetweenDensityAndSalinity =>
      'Convertir entre densité et salinité';

  @override
  String get fromDensityToSalinity => 'De Densité (g/cm³) à Salinité (ppt)';

  @override
  String get fromSalinityToDensity => 'De Salinité (ppt) à Densité (g/cm³)';

  @override
  String get densityExample => 'Densité (ex: 1.025)';

  @override
  String get salinityExample => 'Salinité (ppt, ex: 35)';

  @override
  String get temperatureCelsius => 'Température (°C)';

  @override
  String get salinityPPT => 'Salinité';

  @override
  String get salinityPPM => 'Salinité (ppm)';

  @override
  String get density => 'Densité';

  @override
  String get convert => 'Convertir';

  @override
  String get calculateLightingRequirements =>
      'Calculer les besoins en éclairage pour votre aquarium';

  @override
  String get tankType => 'Type de bac';

  @override
  String get fishOnly => 'Poissons Seulement';

  @override
  String get fishAndSoftCorals => 'Poissons + Coraux Mous';

  @override
  String get spsCorals => 'Coraux SPS';

  @override
  String get totalWatts => 'Watts totaux d\'éclairage';

  @override
  String get calculateLighting => 'Calculer l\'Éclairage';

  @override
  String get wattsPerLiter => 'Watts par litre';

  @override
  String get recommendation => 'Recommandation';

  @override
  String get insufficientMinimumFish =>
      'Insuffisant - Minimum 0,25 W/L pour poissons';

  @override
  String get optimalForFishOnly => 'Optimal pour bac de poissons uniquement';

  @override
  String get excessiveAlgaeRisk => 'Excessif - Risque d\'algues';

  @override
  String get insufficientMinimumSoft => 'Insuffisant - Minimum 0,5 W/L';

  @override
  String get optimalForSoftCorals => 'Optimal pour coraux mous (LPS)';

  @override
  String get veryGoodAlsoSPS => 'Très bon - Convient aussi pour SPS';

  @override
  String get insufficientMinimumSPS => 'Insuffisant - Minimum 1,0 W/L pour SPS';

  @override
  String get optimalForSPS => 'Optimal pour coraux SPS';

  @override
  String get veryPowerfulExcellentSPS =>
      'Très puissant - Excellent pour les SPS exigeants';

  @override
  String get acceptable => 'Acceptable';

  @override
  String get toCorrect => 'À corriger';

  @override
  String get targetTemperature => 'Température Cible';

  @override
  String get setDesiredTemperature => 'Définir la température souhaitée:';

  @override
  String get typicalRangeTemperature => 'Plage typique: 24-26 °C';

  @override
  String get targetSalinity => 'Salinité Cible';

  @override
  String get setDesiredSalinity => 'Définir la valeur de salinité souhaitée:';

  @override
  String get typicalRangeSalinity => 'Plage typique: 1020-1028';

  @override
  String get targetPh => 'pH Cible';

  @override
  String get setDesiredPh => 'Définir la valeur de pH souhaitée:';

  @override
  String get typicalRangePh => 'Plage typique: 8.0-8.4';

  @override
  String get targetOrp => 'ORP Cible';

  @override
  String get setDesiredOrp => 'Définir la valeur ORP souhaitée:';

  @override
  String get typicalRangeOrp => 'Plage typique: 300-400 mV';

  @override
  String get newAquarium => 'Nouvel Aquarium';

  @override
  String get createNewAquarium => 'Créer un Nouvel Aquarium';

  @override
  String get fillTankDetails => 'Remplissez les détails du réservoir';

  @override
  String get aquariumName => 'Nom de l\'Aquarium';

  @override
  String get aquariumNameHint => 'ex. Mon Aquarium';

  @override
  String get enterName => 'Entrez un nom';

  @override
  String get aquariumType => 'Type d\'Aquarium';

  @override
  String get marine => 'Marin';

  @override
  String get freshwater => 'Eau Douce';

  @override
  String get reef => 'Récifal';

  @override
  String get volumeLiters => 'Volume (Litres)';

  @override
  String get volumeHint => 'ex. 200';

  @override
  String get enterVolume => 'Entrez le volume';

  @override
  String get saveAquarium => 'Enregistrer l\'Aquarium';

  @override
  String aquariumCreatedSuccess(String name) {
    return 'Aquarium \"$name\" créé avec succès!';
  }

  @override
  String get deleteAquarium => 'Supprimer Aquarium';

  @override
  String errorLoading(String error) {
    return 'Erreur de chargement: $error';
  }

  @override
  String get cannotDeleteMissingId =>
      'Impossible de supprimer: ID de l\'aquarium manquant';

  @override
  String confirmDeleteAquarium(String name) {
    return 'Êtes-vous sûr de vouloir supprimer \"$name\"?';
  }

  @override
  String get actionCannotBeUndone => 'Cette action ne peut pas être annulée.';

  @override
  String get aquariumDeletedSuccess => 'Aquarium supprimé avec succès';

  @override
  String errorWithMessage(String error) {
    return 'Erreur: $error';
  }

  @override
  String get noAquariumsToDelete => 'Aucun aquarium à supprimer';

  @override
  String get aquariumManagement => 'Gestion des Aquariums';

  @override
  String get selectToDelete => 'Sélectionner pour supprimer';

  @override
  String get editAquarium => 'Modifier l\'Aquarium';

  @override
  String get selectAquarium => 'Sélectionner Aquarium';

  @override
  String get chooseAquariumToEdit => 'Choisissez quel réservoir modifier';

  @override
  String get noAquariumsFound => 'Aucun réservoir trouvé';

  @override
  String get editDetails => 'Modifier les Détails';

  @override
  String updateAquarium(String name) {
    return 'Mettre à jour $name';
  }

  @override
  String get saveChanges => 'Enregistrer les Modifications';

  @override
  String changesSavedFor(String name) {
    return 'Modifications enregistrées pour \"$name\"';
  }

  @override
  String errorSavingChanges(String error) {
    return 'Erreur lors de l\'enregistrement des modifications: $error';
  }

  @override
  String chartHistoryTitle(String parameter) {
    return 'Historique $parameter';
  }

  @override
  String get chartNoData => 'Aucune donnée disponible';

  @override
  String get chartStatMin => 'Min';

  @override
  String get chartStatAvg => 'Moy';

  @override
  String get chartStatMax => 'Max';

  @override
  String get chartStatNow => 'Maint.';

  @override
  String get chartLegendIdeal => 'Idéal';

  @override
  String get chartLegendWarning => 'Avertissement';

  @override
  String get chartAdvancedAnalysis => 'Analyse Avancée';

  @override
  String get chartTrendLabel => 'Tendance';

  @override
  String get chartStabilityLabel => 'Stabilité';

  @override
  String get chartTrendStable => 'Stable';

  @override
  String get chartTrendRising => 'En hausse';

  @override
  String get chartTrendFalling => 'En baisse';

  @override
  String get chartStabilityExcellent => 'Excellente';

  @override
  String get chartStabilityGood => 'Bonne';

  @override
  String get chartStabilityMedium => 'Moyenne';

  @override
  String get chartStabilityLow => 'Basse';

  @override
  String chartAdviceOutOfRange(String parameter) {
    return 'Attention: $parameter hors plage. Vérifiez immédiatement et corrigez.';
  }

  @override
  String get chartAdviceNotIdeal =>
      'Paramètre acceptable mais pas idéal. Surveillez attentivement.';

  @override
  String get chartAdviceUnstable =>
      'Paramètre instable. Vérifiez le changement d\'eau et le dosage des additifs.';

  @override
  String get chartAdviceTempRising =>
      'Température en hausse. Vérifiez le refroidissement et la ventilation.';

  @override
  String get chartAdviceOptimal => 'Paramètre optimal et stable.';

  @override
  String get paramTemperature => 'Température';

  @override
  String get paramPH => 'pH';

  @override
  String get paramSalinity => 'Salinité';

  @override
  String get paramORP => 'ORP';

  @override
  String errorLoadingTasks(String error) {
    return 'Erreur de chargement des tâches: $error';
  }

  @override
  String get addTask => 'Ajouter une Tâche';

  @override
  String inProgress(int count) {
    return 'En Cours ($count)';
  }

  @override
  String completed(int count) {
    return 'Terminés ($count)';
  }

  @override
  String get overdue => 'En Retard';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get week => 'Semaine';

  @override
  String get all => 'Tous';

  @override
  String get noCompletedTasks => 'Aucune tâche terminée';

  @override
  String get noTasksInProgress => 'Aucune tâche en cours';

  @override
  String overdueDays(int days) {
    return 'En retard de $days jours';
  }

  @override
  String get dueToday => 'Échéance aujourd\'hui';

  @override
  String inDays(int days) {
    return 'Dans $days jours';
  }

  @override
  String completedOn(String date) {
    return 'Terminé: $date';
  }

  @override
  String get newTask => 'Nouvelle Tâche';

  @override
  String get taskTitle => 'Titre de la Tâche';

  @override
  String get taskDescription => 'Description (optionnelle)';

  @override
  String get category => 'Catégorie';

  @override
  String get frequency => 'Fréquence';

  @override
  String everyDays(int days) {
    return 'Tous les $days jours';
  }

  @override
  String get reminder => 'Rappel';

  @override
  String get enabled => 'Activé';

  @override
  String get disabled => 'Désactivé';

  @override
  String get time => 'Heure';

  @override
  String get enterTaskTitle => 'Entrez un titre';

  @override
  String get water => 'Eau';

  @override
  String get cleaning => 'Nettoyage';

  @override
  String get testing => 'Tests';

  @override
  String get feeding => 'Alimentation';

  @override
  String get equipment => 'Équipement';

  @override
  String get other => 'Autre';
}
