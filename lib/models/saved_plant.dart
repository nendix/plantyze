import 'package:plantyze/models/plant.dart';

class SavedPlant {
  final String id;
  final Plant plant;

  SavedPlant({
    required this.id,
    required this.plant,
  });

  factory SavedPlant.fromPlant(Plant plant) {
    return SavedPlant(
      id: '${plant.id}_${DateTime.now().millisecondsSinceEpoch}',
      plant: plant,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plant': plant.toJson(),
    };
  }

  factory SavedPlant.fromJson(Map<String, dynamic> json) {
    return SavedPlant(
      id: json['id'] as String,
      plant: Plant.fromJson(json['plant'] as Map<String, dynamic>),
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
    return 'SavedPlant{id: $id, plant: ${plant.commonName}}';
  }
}
