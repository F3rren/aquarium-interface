import 'package:flutter/material.dart';

/// Modello per le specie di coralli disponibili nel database
class CoralSpecies {
  final String id;
  final String commonName;
  final String scientificName;
  final String type; // SPS, LPS, soft, etc.
  final int minTankSize; // Litri
  final int maxSize; // cm
  final String difficulty; // beginner, intermediate, expert
  final String lightRequirement; // low, medium, high
  final String flowRequirement; // low, medium, high
  final String placement; // bottom, middle, top
  final bool aggressive;
  final String feeding; // photosynthetic, filter_feeder, both
  final String? imageUrl;
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

  factory CoralSpecies.fromJson(Map<String, dynamic> json) {
    return CoralSpecies(
      id: json['id'].toString(),
      commonName: json['commonName'] as String,
      scientificName: json['scientificName'] as String,
      type: json['type'] as String,
      minTankSize: json['minTankSize'] as int,
      maxSize: json['maxSize'] as int,
      difficulty: json['difficulty'] as String,
      lightRequirement: json['lightRequirement'] as String,
      flowRequirement: json['flowRequirement'] as String,
      placement: json['placement'] as String,
      aggressive: json['aggressive'] as bool,
      feeding: json['feeding'] as String,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String,
    );
  }

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

  // Helper per colore basato su difficoltà
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

  // Helper per label difficoltà in italiano
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

  // Helper per label tipo in italiano
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
