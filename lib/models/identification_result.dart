import 'package:plantyze/models/plant.dart';

class IdentificationResult {
  final List<Plant> plants;
  final String capturedImagePath;
  final bool isSuccessful;
  final String? errorMessage;

  IdentificationResult({
    required this.plants,
    required this.capturedImagePath,
    this.isSuccessful = true,
    this.errorMessage,
  });

  factory IdentificationResult.fromJson(
    Map<String, dynamic> json,
    String capturedImagePath,
  ) {
    List<Plant> plantResults = [];
    if (json['results'] != null) {
      plantResults = (json['results'] as List<dynamic>)
          .map((plantJson) => Plant.fromJson(plantJson as Map<String, dynamic>))
          .toList();
    }

    return IdentificationResult(
      plants: plantResults,
      capturedImagePath: capturedImagePath,
      isSuccessful: plantResults.isNotEmpty,
      errorMessage: null,
    );
  }

  factory IdentificationResult.error(String message, String capturedImagePath) {
    return IdentificationResult(
      plants: [],
      capturedImagePath: capturedImagePath,
      isSuccessful: false,
      errorMessage: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': plants.map((plant) => plant.toJson()).toList(),
      'capturedImagePath': capturedImagePath,
      'isSuccessful': isSuccessful,
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }

  @override
  String toString() {
    return 'IdentificationResult(plantsFound: ${plants.length}, isSuccessful: $isSuccessful)';
  }
}
