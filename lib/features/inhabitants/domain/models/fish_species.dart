/// Model for a fish species entry in the ReefLife species catalogue.
library;

import 'package:species_service/api.dart';

/// Represents one fish species as returned by the backend species catalogue.
///
/// Instances are read-only catalogue entries used to pre-fill the "Add Fish"
/// form. When the user adds a fish to their tank, the relevant fields are
/// copied into a [Fish] instance.
///
/// **JSON key aliases:** the parser accepts both camelCase (`'commonName'`) and
/// snake_case (`'common_name'`) keys to handle older backend versions.
class FishSpecies {
  /// Backend-assigned unique identifier.
  final String id;

  /// Common trade name (e.g. `"Clownfish"`).
  final String commonName;

  /// Binomial scientific name (e.g. `"Amphiprion ocellaris"`).
  final String scientificName;

  /// Taxonomic family (e.g. `"Pomacentridae"`).
  final String family;

  /// Minimum recommended tank volume in litres.
  final int minTankSize;

  /// Maximum expected adult size in centimetres.
  final double maxSize;

  /// Keeper difficulty: `'beginner'`, `'intermediate'`, or `'expert'`.
  final String difficulty;

  /// Whether this species is safe to keep in a reef tank with corals.
  final bool reefSafe;

  /// Behaviour toward other fish: `'peaceful'`, `'semi-aggressive'`,
  /// or `'aggressive'`.
  final String temperament;

  /// Dietary category: `'herbivore'`, `'carnivore'`, or `'omnivore'`.
  final String diet;

  /// Optional URL to a representative image of the species.
  final String? imageUrl;

  /// Human-readable description of the species.
  final String? description;

  /// Water type this species inhabits (e.g. `'Marino'`, `'Dolce'`).
  final String? waterType;

  FishSpecies({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.family,
    required this.minTankSize,
    required this.maxSize,
    required this.difficulty,
    required this.reefSafe,
    required this.temperament,
    required this.diet,
    this.imageUrl,
    this.description,
    this.waterType,
  });

  /// Creates a [FishSpecies] from a generated [FishResponseDTO].
  factory FishSpecies.fromDto(FishResponseDTO dto) {
    return FishSpecies(
      id: dto.id?.toString() ?? '',
      commonName: dto.commonName ?? '',
      scientificName: dto.scientificName ?? '',
      family: dto.family ?? '',
      minTankSize: dto.minTankSize ?? 0,
      maxSize: (dto.maxSize ?? 0).toDouble(),
      difficulty: dto.difficulty ?? 'intermediate',
      reefSafe: dto.reefSafe ?? true,
      temperament: dto.temperament ?? 'peaceful',
      diet: dto.diet ?? 'omnivore',
      imageUrl: dto.imageUrl,
      description: dto.description,
      waterType: dto.waterType,
    );
  }

  /// Deserialises a [FishSpecies] from a backend JSON map.
  ///
  /// Accepts both camelCase and snake_case key names for compatibility with
  /// multiple backend API versions.
  factory FishSpecies.fromJson(Map<String, dynamic> json) {
    return FishSpecies(
      id: json['id'].toString(),
      commonName: json['commonName'] ?? json['common_name'] ?? '',
      scientificName: json['scientificName'] ?? json['scientific_name'] ?? '',
      family: json['family'] ?? '',
      minTankSize: (json['minTankSize'] ?? json['min_tank_size'] ?? 0) as int,
      maxSize: ((json['maxSize'] ?? json['max_size'] ?? 0) as num).toDouble(),
      difficulty: json['difficulty'] ?? 'intermediate',
      reefSafe: json['reefSafe'] ?? json['reef_safe'] ?? true,
      temperament: json['temperament'] ?? 'peaceful',
      diet: json['diet'] ?? 'omnivore',
      imageUrl: json['imageUrl'] ?? json['image_url'],
      description: json['description'],
      waterType: json['waterType'] ?? json['water_type'],
    );
  }

  /// Serialises this species entry to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commonName': commonName,
      'scientificName': scientificName,
      'family': family,
      'minTankSize': minTankSize,
      'maxSize': maxSize,
      'difficulty': difficulty,
      'reefSafe': reefSafe,
      'temperament': temperament,
      'diet': diet,
      'imageUrl': imageUrl,
      'description': description,
      'waterType': waterType,
    };
  }

  /// Returns a hex colour string for the difficulty badge.
  ///
  /// | Value            | Hex       |
  /// |------------------|-----------|
  /// | `'beginner'`     | `#34d399` (green)  |
  /// | `'intermediate'` | `#fbbf24` (amber)  |
  /// | `'expert'`       | `#ef4444` (red)    |
  /// | (other)          | `#6b7280` (grey)   |
  String get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return '#34d399';
      case 'intermediate':
        return '#fbbf24';
      case 'expert':
        return '#ef4444';
      default:
        return '#6b7280';
    }
  }
}
