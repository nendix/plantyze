import 'package:plantyze/models/plant.dart';

/// Enhanced IdentificationResult model that fully supports PlantNet API response
class IdentificationResult {
  // Query information from API response
  final String project;
  final String image; // Path of submitted image
  final List<String> modifiers; // Any modifiers applied
  final String language;
  
  // Results from API
  final List<Plant> plants;
  final String? bestMatch; // The best matching result ID if provided
  final int remainingIdentificationRequests; // Quota information
  final String? preferedReferential; // API preferred referential
  
  // Local metadata
  final String queryCapturedImage; // Path to the main captured image (for UI)
  final DateTime identifiedAt;
  final bool isSuccessful;
  final String? errorMessage;

  IdentificationResult({
    required this.project,
    required this.image,
    required this.modifiers,
    required this.language,
    required this.plants,
    this.bestMatch,
    required this.remainingIdentificationRequests,
    this.preferedReferential,
    required this.queryCapturedImage,
    required this.identifiedAt,
    this.isSuccessful = true,
    this.errorMessage,
  });

  factory IdentificationResult.fromJson(
    Map<String, dynamic> json,
    String capturedImagePath,
  ) {
    // Parse query information
    final query = json['query'] as Map<String, dynamic>? ?? {};
    final project = query['project']?.toString() ?? 'unknown';
    final language = query['language']?.toString() ?? 'en';
    
    // Parse query image and modifiers
    final queryImage = (query['images'] as List<dynamic>?)?.isNotEmpty == true 
      ? (query['images'] as List<dynamic>).first.toString() 
      : capturedImagePath;
    final queryModifiers = (query['modifiers'] as List<dynamic>?)?.map((mod) => mod.toString()).toList() ?? <String>[];
    
    // Parse results
    List<Plant> plantResults = [];
    if (json['results'] != null) {
      plantResults = (json['results'] as List<dynamic>)
          .map((plantJson) => Plant.fromJson(plantJson as Map<String, dynamic>))
          .toList();
    }
    
    // Parse remaining quota
    final remainingRequests = json['remainingIdentificationRequests'] as int? ?? 0;
    
    // Parse best match
    final bestMatch = json['bestMatch']?.toString();
    
    // Parse preferred referential
    final preferedReferential = json['preferedReferential']?.toString();

    return IdentificationResult(
      project: project,
      image: queryImage,
      modifiers: queryModifiers,
      language: language,
      plants: plantResults,
      bestMatch: bestMatch,
      remainingIdentificationRequests: remainingRequests,
      preferedReferential: preferedReferential,
      queryCapturedImage: capturedImagePath,
      identifiedAt: DateTime.now(),
      isSuccessful: plantResults.isNotEmpty,
      errorMessage: null,
    );
  }

  factory IdentificationResult.error(String message, String capturedImagePath) {
    return IdentificationResult(
      project: 'unknown',
      image: capturedImagePath,
      modifiers: [],
      language: 'en',
      plants: [],
      remainingIdentificationRequests: 0,
      queryCapturedImage: capturedImagePath,
      identifiedAt: DateTime.now(),
      isSuccessful: false,
      errorMessage: message,
    );
  }

  /// Returns the top result (highest confidence plant)
  Plant? get topResult {
    if (plants.isNotEmpty) {
      return plants[0];
    }
    return null;
  }
  
  /// Returns the best match plant if specified, otherwise the top result
  Plant? get bestMatchPlant {
    if (bestMatch != null) {
      try {
        return plants.firstWhere((plant) => plant.id == bestMatch);
      } catch (e) {
        // Best match ID not found, fall back to top result
        return topResult;
      }
    }
    return topResult;
  }
  
  /// Returns results excluding the best match (for "other results" section)
  List<Plant> get otherResults {
    if (bestMatch != null && plants.isNotEmpty) {
      return plants.where((plant) => plant.id != bestMatch).toList();
    }
    // If no best match specified, return all but the first result
    return plants.skip(1).toList();
  }
  
  /// Returns true if the identification has high confidence
  bool get hasHighConfidence {
    final topScore = topResult?.score ?? 0.0;
    return topScore >= 0.75; // 75% confidence threshold
  }
  
  /// Returns a summary of the identification process
  String get identificationSummary {
    if (!isSuccessful) {
      return errorMessage ?? 'Identification failed';
    }
    
    final plantCount = plants.length;
    final topScore = topResult?.score ?? 0.0;
    final confidencePercent = (topScore * 100).toStringAsFixed(1);
    
    return 'Found $plantCount potential matches with top confidence of $confidencePercent%';
  }
  
  /// Returns information about API quota usage
  String get quotaInfo {
    return 'Remaining identification requests: $remainingIdentificationRequests';
  }
  
  Map<String, dynamic> toJson() {
    return {
      'query': {
        'project': project,
        'image': image,
        'modifiers': modifiers,
        'language': language,
      },
      'results': plants.map((plant) => plant.toJson()).toList(),
      if (bestMatch != null) 'bestMatch': bestMatch,
      'remainingIdentificationRequests': remainingIdentificationRequests,
      if (preferedReferential != null) 'preferedReferential': preferedReferential,
      'queryCapturedImage': queryCapturedImage,
      'identifiedAt': identifiedAt.toIso8601String(),
      'isSuccessful': isSuccessful,
      if (errorMessage != null) 'errorMessage': errorMessage,
    };
  }
  
  @override
  String toString() {
    return 'IdentificationResult(project: $project, plantsFound: ${plants.length}, isSuccessful: $isSuccessful)';
  }
}
