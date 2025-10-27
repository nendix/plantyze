import 'dart:io';
import 'package:plantyze/constants/app_constants.dart';

/// Validation utilities for input data and app state
class Validators {
  /// Validates if the provided file path points to a valid image file
  static bool isValidImagePath(String path) {
    if (path.isEmpty) return false;
    
    final file = File(path);
    if (!file.existsSync()) return false;
    
    final extension = path.toLowerCase();
    return AppConstants.supportedImageFormats
        .any((format) => extension.endsWith(format));
  }
  

  

  
  /// Validates image file size
  static Future<ValidationResult> validateImageSize(String imagePath) async {
    try {
      final file = File(imagePath);
      final sizeBytes = await file.length();
      
      if (sizeBytes > AppConstants.maxFileSizeBytes) {
        final sizeMB = (sizeBytes / (1024 * 1024)).toStringAsFixed(1);
        final maxMB = (AppConstants.maxFileSizeBytes / (1024 * 1024)).toStringAsFixed(1);
        return ValidationResult.error(
          'Image size ($sizeMB MB) exceeds maximum allowed size ($maxMB MB)'
        );
      }
      
      return ValidationResult.success();
    } catch (e) {
      return ValidationResult.error('Error checking image size: $e');
    }
  }
  
  /// Validates API key format (basic check)
  static bool isValidApiKey(String apiKey) {
    // PlantNet API keys are typically alphanumeric with specific length
    return apiKey.isNotEmpty && 
           apiKey.length >= 10 && 
           RegExp(r'^[a-zA-Z0-9]+$').hasMatch(apiKey);
  }
  
  /// Validates project name for PlantNet API
  static bool isValidProject(String project) {
    return AppConstants.supportedProjects.contains(project);
  }
  
  /// Validates language code (basic ISO 639-1 check)
  static bool isValidLanguageCode(String lang) {
    return lang.length == 2 && RegExp(r'^[a-z]{2}$').hasMatch(lang);
  }
  
  /// Validates number of results parameter
  static bool isValidNbResults(int nbResults) {
    return nbResults > 0 && nbResults <= 30; // PlantNet typical limit
  }
}

/// Result of validation operations
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  
  const ValidationResult._({required this.isValid, this.errorMessage});
  
  factory ValidationResult.success() => const ValidationResult._(isValid: true);
  
  factory ValidationResult.error(String message) => ValidationResult._(
    isValid: false, 
    errorMessage: message
  );
}