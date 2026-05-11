/// Domain model representing a coral specimen kept in a user's aquarium.
library;

import 'package:inhabitants_service/api.dart';

/// A coral specimen added by the user to one of their aquariums.
///
/// Fields are split into two groups:
/// - **Core fields** — always present: [id], [name], [species], [type],
///   [size], [addedDate], [placement].
/// - **Species-detail fields** — denormalised from [CoralSpecies] at insertion
///   time so the record remains self-contained even if the species catalogue
///   changes later.
class Coral {
  /// Client-generated UUID uniquely identifying this specimen.
  final String id;

  /// User-chosen display name for this coral (e.g. `"Elegance"`).
  final String name;

  /// Scientific or common species name (e.g. `"Catalaphyllia jardinei"`).
  final String species;

  /// Coral classification: `'SPS'`, `'LPS'`, or `'Molle'` (soft).
  final String type;

  /// Current size of the specimen in centimetres.
  final double size;

  /// Date the coral was added to the aquarium.
  final DateTime addedDate;

  /// Preferred placement zone in the tank: `'Alto'`, `'Medio'`, or `'Basso'`.
  final String placement;

  /// Optional free-text notes from the user.
  final String? notes;

  /// Optional URL to a photo of this specific specimen.
  final String? imageUrl;

  // ── Species-detail fields (denormalised from CoralSpecies) ──────────────

  /// Care difficulty: `'beginner'`, `'intermediate'`, or `'expert'`.
  final String? difficulty;

  /// Required light intensity: `'low'`, `'medium'`, or `'high'`.
  final String? lightRequirement;

  /// Required water flow: `'low'`, `'medium'`, or `'high'`.
  final String? flowRequirement;

  /// Feeding mode: `'photosynthetic'`, `'filter_feeder'`, or `'both'`.
  final String? feeding;

  /// General description of the species from the catalogue.
  final String? description;

  /// Whether this coral is aggressive toward tank mates.
  final bool? aggressive;

  /// Minimum recommended tank size in litres.
  final int? minTankSize;

  /// Maximum expected growth size in centimetres.
  final int? maxSize;

  Coral({
    required this.id,
    required this.name,
    required this.species,
    required this.type,
    required this.size,
    required this.addedDate,
    required this.placement,
    this.notes,
    this.imageUrl,
    this.difficulty,
    this.lightRequirement,
    this.flowRequirement,
    this.feeding,
    this.description,
    this.aggressive,
    this.minTankSize,
    this.maxSize,
  });

  /// Creates a [Coral] from a generated [InhabitantDetailsDTO] with type `'coral'`.
  ///
  /// [type] and [placement] are not present in the DTO and default to empty
  /// strings; they should be enriched from the species catalogue if needed.
  factory Coral.fromInhabitantDto(InhabitantDetailsDTO dto) {
    return Coral(
      id: dto.id?.toString() ?? '',
      name: dto.customName ?? dto.commonName ?? '',
      species: dto.scientificName ?? dto.commonName ?? '',
      type: '',
      size: (dto.currentSize ?? 0).toDouble(),
      addedDate: dto.addedDate ?? DateTime.now(),
      placement: '',
      notes: dto.notes,
      difficulty: dto.customDifficulty,
      minTankSize: dto.customMinTankSize,
    );
  }

  /// Serialises this coral to a JSON map for local storage or API requests.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'type': type,
      'size': size,
      'addedDate': addedDate.toIso8601String(),
      'placement': placement,
      'notes': notes,
      'imageUrl': imageUrl,
      'difficulty': difficulty,
      'lightRequirement': lightRequirement,
      'flowRequirement': flowRequirement,
      'feeding': feeding,
      'description': description,
      'aggressive': aggressive,
      'minTankSize': minTankSize,
      'maxSize': maxSize,
    };
  }

  /// Deserialises a [Coral] from a JSON map.
  factory Coral.fromJson(Map<String, dynamic> json) {
    return Coral(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      type: json['type'],
      size: json['size'].toDouble(),
      addedDate: DateTime.parse(json['addedDate']),
      placement: json['placement'],
      notes: json['notes'],
      imageUrl: json['imageUrl'],
      difficulty: json['difficulty'],
      lightRequirement: json['lightRequirement'],
      flowRequirement: json['flowRequirement'],
      feeding: json['feeding'],
      description: json['description'],
      aggressive: json['aggressive'],
      minTankSize: json['minTankSize'],
      maxSize: json['maxSize'],
    );
  }

  /// Returns a copy of this coral with the specified fields replaced.
  Coral copyWith({
    String? id,
    String? name,
    String? species,
    String? type,
    double? size,
    DateTime? addedDate,
    String? placement,
    String? notes,
    String? imageUrl,
    String? difficulty,
    String? lightRequirement,
    String? flowRequirement,
    String? feeding,
    String? description,
    bool? aggressive,
    int? minTankSize,
    int? maxSize,
  }) {
    return Coral(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      type: type ?? this.type,
      size: size ?? this.size,
      addedDate: addedDate ?? this.addedDate,
      placement: placement ?? this.placement,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
      difficulty: difficulty ?? this.difficulty,
      lightRequirement: lightRequirement ?? this.lightRequirement,
      flowRequirement: flowRequirement ?? this.flowRequirement,
      feeding: feeding ?? this.feeding,
      description: description ?? this.description,
      aggressive: aggressive ?? this.aggressive,
      minTankSize: minTankSize ?? this.minTankSize,
      maxSize: maxSize ?? this.maxSize,
    );
  }
}
