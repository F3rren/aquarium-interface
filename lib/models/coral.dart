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

  // Dettagli aggiuntivi dalla specie
  final String? difficulty;
  final String? lightRequirement;
  final String? flowRequirement;
  final String? feeding;
  final String? description;
  final bool? aggressive;
  final int? minTankSize;
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
