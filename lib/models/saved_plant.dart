import 'package:plantyze/models/plant.dart';

class SavedPlant {
  final String id;
  final Plant plant;
  final DateTime savedAt;

  SavedPlant({
    required this.id,
    required this.plant,
    required this.savedAt,
  });

  // Create a SavedPlant from a Plant
  factory SavedPlant.fromPlant(Plant plant) {
    return SavedPlant(
      id: '${plant.id}_${DateTime.now().millisecondsSinceEpoch}',
      plant: plant,
      savedAt: DateTime.now(),
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plant': plant.toJson(),
      'savedAt': savedAt.toIso8601String(),
    };
  }

  // JSON deserialization
  factory SavedPlant.fromJson(Map<String, dynamic> json) {
    return SavedPlant(
      id: json['id'] as String,
      plant: Plant.fromJson(json['plant'] as Map<String, dynamic>),
      savedAt: DateTime.parse(json['savedAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SavedPlant && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'SavedPlant{id: $id, plant: ${plant.commonName}, savedAt: $savedAt}';
  }
}