class Aquarium {
  final int? id;
  final String name;
  final double volume; // litri
  final String type; // Marino, Dolce, etc.
  final DateTime? createdAt;
  final String? description;
  final String? imageUrl;

  Aquarium({
    this.id,
    required this.name,
    required this.volume,
    required this.type,
    this.createdAt,
    this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'volume': volume,
      'type': type,
    };

    // Aggiungi campi opzionali solo se presenti
    if (id != null) json['id'] = id;
    if (createdAt != null) json['createdAt'] = createdAt!.toIso8601String();
    if (description != null) json['description'] = description;
    if (imageUrl != null) json['imageUrl'] = imageUrl;

    return json;
  }

  factory Aquarium.fromJson(Map<String, dynamic> json) {
    return Aquarium(
      id: json['id'] as int?,
      name: json['name']?.toString() ?? 'Senza nome',
      volume: (json['volume'] as num?)?.toDouble() ?? 0.0,
      type: json['type']?.toString() ?? 'Marino',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      description: json['description']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  Aquarium copyWith({
    int? id,
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
