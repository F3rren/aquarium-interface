/// Modello per le specie di pesci disponibili nel database
class FishSpecies {
  final String id;
  final String commonName;
  final String scientificName;
  final String family;
  final int minTankSize; // litri
  final double maxSize; // cm
  final String difficulty; // beginner, intermediate, expert
  final bool reefSafe;
  final String temperament; // peaceful, semi-aggressive, aggressive
  final String diet; // herbivore, carnivore, omnivore
  final String? imageUrl;
  final String? description;
  final String? waterType; // Marino, Dolce, etc.

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

  /// Colore badge difficoltà
  String get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return '#34d399'; // verde
      case 'intermediate':
        return '#fbbf24'; // giallo
      case 'expert':
        return '#ef4444'; // rosso
      default:
        return '#6b7280'; // grigio
    }
  }
}
