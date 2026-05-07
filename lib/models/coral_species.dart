/// Model for a coral species entry in the ReefLife species catalogue.
library;

import 'package:flutter/material.dart';
import 'package:species_service/api.dart';

/// Represents one coral species as returned by the backend species catalogue.
///
/// Instances are read-only catalogue entries used to pre-fill the "Add Coral"
/// form. When the user adds a coral to their tank, the relevant fields are
/// copied into a [Coral] instance.
///
/// **Accepted string values for key fields:**
/// - [type]: `'sps'`, `'lps'`, `'soft'`, `'zoa'`
/// - [difficulty]: `'beginner'`, `'intermediate'`, `'expert'`
/// - [lightRequirement] / [flowRequirement]: `'low'`, `'medium'`, `'high'`
/// - [placement]: `'bottom'`, `'middle'`, `'top'`
/// - [feeding]: `'photosynthetic'`, `'filter_feeder'`, `'both'`
class CoralSpecies {
  /// Backend-assigned unique identifier (string to handle both int and UUID).
  final String id;

  /// Common trade name (e.g. `"Hammer Coral"`).
  final String commonName;

  /// Binomial scientific name (e.g. `"Euphyllia ancora"`).
  final String scientificName;

  /// Coral classification: `'sps'`, `'lps'`, `'soft'`, or `'zoa'`.
  final String type;

  /// Minimum recommended tank volume in litres.
  final int minTankSize;

  /// Maximum expected colony size in centimetres.
  final int maxSize;

  /// Keeper difficulty: `'beginner'`, `'intermediate'`, or `'expert'`.
  final String difficulty;

  /// Lighting intensity requirement: `'low'`, `'medium'`, or `'high'`.
  final String lightRequirement;

  /// Water-flow requirement: `'low'`, `'medium'`, or `'high'`.
  final String flowRequirement;

  /// Recommended placement in the tank: `'bottom'`, `'middle'`, or `'top'`.
  final String placement;

  /// Whether this species exhibits aggressive behaviour toward neighbours.
  final bool aggressive;

  /// Primary nutrition source: `'photosynthetic'`, `'filter_feeder'`, or `'both'`.
  final String feeding;

  /// Optional URL to a representative image of the species.
  final String? imageUrl;

  /// Human-readable description of the species from the catalogue.
  final String description;

  CoralSpecies({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.type,
    required this.minTankSize,
    required this.maxSize,
    required this.difficulty,
    required this.lightRequirement,
    required this.flowRequirement,
    required this.placement,
    required this.aggressive,
    required this.feeding,
    this.imageUrl,
    required this.description,
  });

  /// Creates a [CoralSpecies] from a generated [CoralResponseDTO].
  factory CoralSpecies.fromDto(CoralResponseDTO dto) {
    return CoralSpecies(
      id: dto.id?.toString() ?? '',
      commonName: dto.commonName ?? '',
      scientificName: dto.scientificName ?? '',
      type: dto.type ?? '',
      minTankSize: dto.minTankSize ?? 0,
      maxSize: dto.maxSize ?? 0,
      difficulty: dto.difficulty ?? '',
      lightRequirement: dto.lightRequirement ?? '',
      flowRequirement: dto.flowRequirement ?? '',
      placement: dto.placement ?? '',
      aggressive: dto.aggressive ?? false,
      feeding: dto.feeding ?? '',
      description: dto.description ?? '',
    );
  }

  /// Deserialises a [CoralSpecies] from a backend JSON map.
  ///
  /// [minTankSize] and [maxSize] accept both `int` and numeric-string values
  /// to handle inconsistent backend serialisation across API versions.
  factory CoralSpecies.fromJson(Map<String, dynamic> json) {
    return CoralSpecies(
      id: json['id'].toString(),
      commonName: json['commonName'] as String? ?? '',
      scientificName: json['scientificName'] as String? ?? '',
      type: json['type'] as String? ?? '',
      minTankSize: (json['minTankSize'] is int)
          ? json['minTankSize'] as int
          : int.tryParse(json['minTankSize'].toString()) ?? 0,
      maxSize: (json['maxSize'] is int)
          ? json['maxSize'] as int
          : int.tryParse(json['maxSize'].toString()) ?? 0,
      difficulty: json['difficulty'] as String? ?? '',
      lightRequirement: json['lightRequirement'] as String? ?? '',
      flowRequirement: json['flowRequirement'] as String? ?? '',
      placement: json['placement'] as String? ?? '',
      aggressive: json['aggressive'] == true || json['aggressive'] == 'true',
      feeding: json['feeding'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String? ?? '',
    );
  }

  /// Serialises this species entry to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'commonName': commonName,
      'scientificName': scientificName,
      'type': type,
      'minTankSize': minTankSize,
      'maxSize': maxSize,
      'difficulty': difficulty,
      'lightRequirement': lightRequirement,
      'flowRequirement': flowRequirement,
      'placement': placement,
      'aggressive': aggressive,
      'feeding': feeding,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  /// Returns a [Color] for the difficulty badge.
  ///
  /// | Value          | Colour  |
  /// |----------------|---------|
  /// | `'beginner'`   | Green   |
  /// | `'intermediate'` | Amber |
  /// | `'expert'`     | Red     |
  /// | (other)        | Blue    |
  Color get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF34d399);
      case 'intermediate':
        return const Color(0xFFfbbf24);
      case 'expert':
        return const Color(0xFFef4444);
      default:
        return const Color(0xFF60a5fa);
    }
  }

  /// Returns the Italian display label for [difficulty].
  String get difficultyLabel {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 'Principiante';
      case 'intermediate':
        return 'Intermedio';
      case 'expert':
        return 'Esperto';
      default:
        return difficulty;
    }
  }

  /// Returns a human-readable Italian label for the coral [type].
  String get typeLabel {
    switch (type.toLowerCase()) {
      case 'sps':
        return 'SPS (Piccoli Polipi Pietrosi)';
      case 'lps':
        return 'LPS (Grandi Polipi Pietrosi)';
      case 'soft':
        return 'Molli';
      case 'zoa':
        return 'Zoanthus';
      default:
        return type;
    }
  }
}
