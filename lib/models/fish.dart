class Fish {
  final String id;
  final String name;
  final String species;
  final double size; // cm
  final DateTime addedDate;
  final String? notes;
  final String? imageUrl;

  Fish({
    required this.id,
    required this.name,
    required this.species,
    required this.size,
    required this.addedDate,
    this.notes,
    this.imageUrl,
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
  }) {
    return Fish(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      size: size ?? this.size,
      addedDate: addedDate ?? this.addedDate,
      notes: notes ?? this.notes,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
