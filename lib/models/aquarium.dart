class Aquarium {
  final String id;
  final String name;
  final double volume; // litri
  final String type; // Marino, Dolce, etc.
  final DateTime? createdAt;
  final String? description;
  final String? imageUrl;

  Aquarium({
    required this.id,
    required this.name,
    required this.volume,
    required this.type,
    this.createdAt,
    this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'volume': volume,
      'type': type,
      'createdAt': createdAt?.toIso8601String(),
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Aquarium.fromJson(Map<String, dynamic> json) {
    return Aquarium(
      id: json['id'].toString(),
      name: json['name'],
      volume: (json['volume'] ?? 0).toDouble(),
      type: json['type'] ?? 'Marino',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Aquarium copyWith({
    String? id,
    String? name,
    double? volume,
    String? type,
    DateTime? createdAt,
    String? description,
    String? imageUrl,
  }) {
    return Aquarium(
      id: id ?? this.id,
      name: name ?? this.name,
      volume: volume ?? this.volume,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
