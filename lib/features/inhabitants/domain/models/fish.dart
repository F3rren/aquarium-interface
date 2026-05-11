/// Domain model representing a fish specimen kept in a user's aquarium.
library;

import 'package:inhabitants_service/api.dart';

/// A fish specimen added by the user to one of their aquariums.
///
/// Like [Coral], fields are split into two groups:
/// - **Core fields** — always present: [id], [name], [species], [size],
///   [addedDate].
/// - **Species-detail fields** — denormalised from [FishSpecies] at insertion
///   time so the record stays self-contained if the catalogue changes.
class Fish {
  /// Client-generated UUID uniquely identifying this specimen.
  final String id;

  /// User-chosen display name (e.g. `"Nemo"`).
  final String name;

  /// Scientific or common species name (e.g. `"Amphiprioninae"`).
  final String species;

  /// Current size of the fish in centimetres.
  final double size;

  /// Date the fish was added to the aquarium.
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

  /// Creates a [Fish] from a generated [InhabitantDetailsDTO] with type `'fish'`.
  factory Fish.fromInhabitantDto(InhabitantDetailsDTO dto) {
    return Fish(
      id: dto.id?.toString() ?? '',
      name: dto.customName ?? dto.commonName ?? '',
      species: dto.scientificName ?? dto.commonName ?? '',
      size: (dto.currentSize ?? 0).toDouble(),
      addedDate: dto.addedDate ?? DateTime.now(),
      notes: dto.notes,
      difficulty: dto.customDifficulty,
      temperament: dto.customTemperament,
      diet: dto.customDiet,
      reefSafe: dto.isReefSafe,
      minTankSize: dto.customMinTankSize,
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
