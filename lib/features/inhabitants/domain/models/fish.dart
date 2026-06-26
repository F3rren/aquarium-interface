/// Domain model representing a fish specimen kept in a user's aquarium.
library;

import 'package:acquariumfe/features/inhabitants/domain/models/filterable.dart';

/// A fish specimen added by the user to one of their aquariums.
///
/// Like [Coral], fields are split into two groups:
/// - **Core fields** — always present: [id], [name], [species], [size],
///   [addedDate].
/// - **Species-detail fields** — denormalised from [FishSpecies] at insertion
///   time so the record stays self-contained if the catalogue changes.
class Fish with Filterable {
  /// Client-generated UUID uniquely identifying this specimen.
  final String id;

  /// User-chosen display name (e.g. `"Nemo"`).
  @override
  final String name;

  /// Scientific or common species name (e.g. `"Amphiprioninae"`).
  @override
  final String species;

  /// Current size of the fish in centimetres.
  @override
  final double size;

  /// Date the fish was added to the aquarium.
  @override
  final DateTime addedDate;

  /// Optional free-text notes from the user.
  final String? notes;

  /// Optional URL to a photo of this specific fish.
  final String? imageUrl;

  // ── Species-detail fields (denormalised from FishSpecies) ─────────────────

  /// Taxonomic family name (e.g. `"Pomacentridae"`).
  final String? family;

  /// Minimum recommended tank size in litres.
  final int? minTankSize;

  /// Maximum expected adult size in centimetres.
  final double? maxSize;

  /// Care difficulty: `'beginner'`, `'intermediate'`, or `'expert'`.
  @override
  final String? difficulty;

  /// Behaviour toward tank mates: `'peaceful'`, `'semi-aggressive'`,
  /// or `'aggressive'`.
  final String? temperament;

  /// Dietary category: `'herbivore'`, `'carnivore'`, or `'omnivore'`.
  final String? diet;

  /// General description of the species.
  final String? description;

  /// Whether this species is considered safe for reef tanks with corals.
  final bool? reefSafe;

  Fish({
    required this.id,
    required this.name,
    required this.species,
    required this.size,
    required this.addedDate,
    this.notes,
    this.imageUrl,
    this.family,
    this.minTankSize,
    this.maxSize,
    this.difficulty,
    this.temperament,
    this.diet,
    this.description,
    this.reefSafe,
  });

  /// Creates a [Fish] from a backend inhabitants-API JSON record
  /// (`type == 'fish'`).
  ///
  /// Top-level keys carry the user's customisations; the nested `details`
  /// object carries the denormalised species data, which takes precedence.
  /// Size falls back through `details.size` -> `details.maxSize` ->
  /// `currentSize` -> 10.0 cm.
  factory Fish.fromInhabitantJson(Map<String, dynamic> json) {
    final details = json['details'] is Map
        ? (json['details'] as Map).cast<String, dynamic>()
        : <String, dynamic>{};
    final rawSize = details['size'] ?? details['maxSize'] ?? json['currentSize'];
    final size = rawSize is int
        ? rawSize.toDouble()
        : (rawSize as num?)?.toDouble() ?? 10.0;

    return Fish(
      id: json['id']?.toString() ?? '',
      name: json['customName'] ?? json['commonName'] ?? '',
      species: json['scientificName'] ?? json['commonName'] ?? '',
      size: size,
      addedDate:
          DateTime.tryParse(json['addedDate']?.toString() ?? '') ??
              DateTime.now(),
      notes: details['notes'] as String? ?? json['notes'] as String?,
      imageUrl: details['imageUrl'] as String?,
      family: details['family'] as String?,
      minTankSize:
          details['minTankSize'] as int? ?? json['customMinTankSize'] as int?,
      maxSize: (details['maxSize'] as num?)?.toDouble(),
      difficulty:
          details['difficulty'] as String? ?? json['customDifficulty'] as String?,
      temperament: details['temperament'] as String? ??
          json['customTemperament'] as String?,
      diet: details['diet'] as String? ?? json['customDiet'] as String?,
      description: details['description'] as String?,
      reefSafe: details['reefSafe'] as bool? ?? json['isReefSafe'] as bool?,
    );
  }

  /// Serialises this fish to a JSON map for local storage or API requests.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'size': size,
      'addedDate': addedDate.toIso8601String(),
      'notes': notes,
      'imageUrl': imageUrl,
      'family': family,
      'minTankSize': minTankSize,
      'maxSize': maxSize,
      'difficulty': difficulty,
      'temperament': temperament,
      'diet': diet,
      'description': description,
      'reefSafe': reefSafe,
    };
  }

  /// Deserialises a [Fish] from a JSON map.
  factory Fish.fromJson(Map<String, dynamic> json) {
    return Fish(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      size: json['size'].toDouble(),
      addedDate: DateTime.parse(json['addedDate']),
      notes: json['notes'],
      imageUrl: json['imageUrl'],
      family: json['family'],
      minTankSize: json['minTankSize'],
      maxSize: json['maxSize']?.toDouble(),
      difficulty: json['difficulty'],
      temperament: json['temperament'],
      diet: json['diet'],
      description: json['description'],
      reefSafe: json['reefSafe'],
    );
  }

  /// Returns a copy of this fish with the specified fields replaced.
  Fish copyWith({
    String? id,
    String? name,
    String? species,
    double? size,
    DateTime? addedDate,
    String? notes,
    String? imageUrl,
    String? family,
    int? minTankSize,
    double? maxSize,
    String? difficulty,
    String? temperament,
    String? diet,
    String? description,
    bool? reefSafe,
  }) {
    return Fish(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      size: size ?? this.size,
      addedDate: addedDate ?? this.addedDate,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      family: family ?? this.family,
      minTankSize: minTankSize ?? this.minTankSize,
      maxSize: maxSize ?? this.maxSize,
      difficulty: difficulty ?? this.difficulty,
      temperament: temperament ?? this.temperament,
      diet: diet ?? this.diet,
      description: description ?? this.description,
      reefSafe: reefSafe ?? this.reefSafe,
    );
  }
}
