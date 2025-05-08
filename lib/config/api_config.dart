import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Base URL for Pl@ntNet API
  static String get plantNetBaseUrl =>
      'https://my-api.plantnet.org/v2/identify/all';

  // Get API key from .env file
  static String get plantNetApiKey => dotenv.env['PLANTNET_API_KEY'] ?? '';

  // Project that should be used for identification requests
  static String get plantNetProject => 'all';

  // Get full URL for a request with API key
  static String getPlantNetUrl() {
    return '$plantNetBaseUrl?api-key=$plantNetApiKey&include-related-images=true';
  }
}
