class Coral {
  final String id;
  final String name;
  final String species;
  final String type; // SPS, LPS, Molle
  final double size; // cm
  final DateTime addedDate;
  final String placement; // Alto, Medio, Basso
  final String? notes;
  final String? imageUrl;

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
  });

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
    };
  }

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
    );
  }

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
    );
  }
}
