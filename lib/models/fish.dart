class Fish {
  final String id;
  final String name;
  final String species;
  final double size; // cm
  final DateTime addedDate;
  final String? notes;
  final String? imageUrl;

  // Dettagli specie
  final String? family;
  final int? minTankSize;
  final double? maxSize;
  final String? difficulty;
  final String? temperament;
  final String? diet;
  final String? description;
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
