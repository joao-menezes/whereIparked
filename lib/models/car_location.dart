typedef Coordinates = ({double latitude, double longitude});

class CarLocation {
  const CarLocation({
    required this.id,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.photoFileName,
    this.note,
    this.visited = false,
  });

  final String id;

  final double? latitude;
  final double? longitude;

  final String? photoFileName;
  final String? note;
  final DateTime timestamp;
  final bool visited;

  bool get hasCoordinates => latitude != null && longitude != null;

  Coordinates? get coordinates =>
      hasCoordinates ? (latitude: latitude!, longitude: longitude!) : null;

  CarLocation copyWith({bool? visited}) => CarLocation(
    id: id,
    timestamp: timestamp,
    latitude: latitude,
    longitude: longitude,
    photoFileName: photoFileName,
    note: note,
    visited: visited ?? this.visited,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'latitude': latitude,
    'longitude': longitude,
    'photoFileName': photoFileName,
    'note': note,
    'timestamp': timestamp.toIso8601String(),
    'visited': visited,
  };

  factory CarLocation.fromJson(Map<String, dynamic> json) => CarLocation(
    id: json['id'] as String,
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    photoFileName: json['photoFileName'] as String?,
    note: json['note'] as String?,
    timestamp: DateTime.parse(json['timestamp'] as String),
    visited: json['visited'] as bool? ?? false,
  );
}
