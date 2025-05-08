import 'package:plantyze/models/plant.dart';

class IdentificationResult {
  final List<Plant> plants;
  final String queryCapturedImage;
  final String language;
  final DateTime identifiedAt;
  final bool isSuccessful;
  final String? errorMessage;

  IdentificationResult({
    required this.plants,
    required this.queryCapturedImage,
    required this.language,
    required this.identifiedAt,
    this.isSuccessful = true,
    this.errorMessage,
  });

  factory IdentificationResult.fromJson(
    Map<String, dynamic> json,
    String capturedImagePath,
  ) {
    List<Plant> plantResults = [];

    if (json['results'] != null) {
      plantResults =
          (json['results'] as List<dynamic>)
              .map((plantJson) => Plant.fromJson(plantJson))
              .toList();
    }

    return IdentificationResult(
      plants: plantResults,
      queryCapturedImage: capturedImagePath,
      language: json['language'] ?? 'en',
      identifiedAt: DateTime.now(),
      isSuccessful: plantResults.isNotEmpty, // More accurate check
      errorMessage: null, // Your API response doesn't include error messages
    );
  }

  factory IdentificationResult.error(String message, String capturedImagePath) {
    return IdentificationResult(
      plants: [],
      queryCapturedImage: capturedImagePath,
      language: 'en',
      identifiedAt: DateTime.now(),
      isSuccessful: false,
      errorMessage: message,
    );
  }

  Plant? get topResult {
    if (plants.isNotEmpty) {
      return plants[0];
    }
    return null;
  }
}
