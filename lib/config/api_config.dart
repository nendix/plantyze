import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:plantyze/constants/app_constants.dart';

/// Configuration for PlantNet API integration
class ApiConfig {
  // Base URL for PlantNet API (without project path parameter)
  static const String _plantNetBaseUrl = 'https://my-api.plantnet.org/v2/identify';

  /// Get API key from .env file
  static String get plantNetApiKey => dotenv.env['PLANTNET_API_KEY'] ?? '';

  /// Get full URL for a request with specified project
  static String getPlantNetUrl({String project = AppConstants.defaultProject}) {
    return '$_plantNetBaseUrl/$project';
  }
  
  /// Build query parameters for API request
  static Map<String, String> buildQueryParameters({
    bool includeRelatedImages = false,
    bool noReject = false,
    int nbResults = AppConstants.defaultNbResults,
    String lang = AppConstants.defaultLang,
    String? type,
    bool detailed = false,
  }) {
    final params = <String, String>{
      'api-key': plantNetApiKey,
      'include-related-images': includeRelatedImages.toString(),
      'no-reject': noReject.toString(),
      'nb-results': nbResults.toString(),
      'lang': lang,
    };
    
    if (type != null && type.isNotEmpty) {
      params['type'] = type;
    }
    
    if (detailed) {
      params['detailed'] = detailed.toString();
    }
    
    return params;
  }
}
