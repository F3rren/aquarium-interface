/// Domain model representing a single user-owned aquarium.
library;

/// Represents a registered aquarium.
///
/// This is the primary domain entity of the app. Every aquarium owns its own
/// water-parameter readings, maintenance tasks, fish, and corals. The [id] is
/// assigned by the backend on first save; until then it is `null`.
class Aquarium {
  /// Backend-assigned unique identifier. `null` before the first save.
  final int? id;

  /// Display name shown throughout the UI (e.g. `"Coral Reef Tank"`).
  final String name;

  /// Total water volume in litres.
  final double volume;

  /// Water type key used by the backend (e.g. `'saltwater'`, `'freshwater'`).
  final String type;

  /// Timestamp of when the aquarium was created on the backend. May be `null`
  /// for locally constructed instances not yet persisted.
  final DateTime? createdAt;

  /// Optional free-text description entered by the user.
  final String? description;

  /// Optional URL pointing to a representative photo of the aquarium.
  final String? imageUrl;

  /// Creates an [Aquarium].
  ///
  /// [name], [volume], and [type] are required; all other fields are optional.
  Aquarium({
    this.id,
    required this.name,
    required this.volume,
    required this.type,
    this.createdAt,
    this.description,
    this.imageUrl,
  });

  /// Serialises this aquarium to a JSON map for API requests.
  ///
  /// Optional fields ([id], [createdAt], [description], [imageUrl]) are only
  /// included when non-null, preventing accidental `null` overwrites on the
  /// backend.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'name': name,
      'volume': volume,
      'type': type,
    };

    if (id != null) json['id'] = id;
    if (createdAt != null) json['createdAt'] = createdAt!.toIso8601String();
    if (description != null) json['description'] = description;
    if (imageUrl != null) json['imageUrl'] = imageUrl;

    return json;
  }

  /// Deserialises an [Aquarium] from a backend JSON map.
  ///
  /// Provides safe fallbacks for every field: name defaults to `'Senza nome'`,
  /// volume to `0.0`, type to `'Marino'`. [createdAt] uses [DateTime.tryParse]
  /// so an invalid date string does not crash the parser.
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

  /// Returns a copy of this aquarium with the specified fields replaced.
  ///
  /// Fields not provided retain their current values.
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
