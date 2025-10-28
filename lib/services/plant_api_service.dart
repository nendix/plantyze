import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plantyze/config/api_config.dart';
import 'package:plantyze/models/identification_result.dart';
import 'package:plantyze/constants/app_constants.dart';
import 'package:plantyze/utils/validators.dart';
import 'package:plantyze/services/connectivity_service.dart';

class PlantApiService {
  final ConnectivityService _connectivityService;

  PlantApiService({ConnectivityService? connectivityService})
      : _connectivityService = connectivityService ?? ConnectivityService();

  /// Identifies a single plant from an image using auto-detection
  Future<IdentificationResult> identifyPlant(
    String imagePath, {
    String project = AppConstants.defaultProject,
    int maxResults = AppConstants.defaultNbResults,
    String language = AppConstants.defaultLang,
    bool includeRelatedImages = false,
    bool noReject = false,
    bool detailed = false,
  }) async {
    try {
      // Check internet connectivity first
      final hasConnection = await _connectivityService.hasInternetConnection();
      if (!hasConnection) {
        return IdentificationResult.error(
          'No internet connection. Please check your network and try again.',
          imagePath,
        );
      }

      // Validate inputs
      final validationResult = _validateInputs(imagePath);
      if (!validationResult.isValid) {
        return IdentificationResult.error(
          validationResult.errorMessage!,
          imagePath,
        );
      }

      // Check API key
      if (ApiConfig.plantNetApiKey.isEmpty) {
        return IdentificationResult.error(
          'API key not found. Please add your Pl@ntNet API key to the .env file.',
          imagePath,
        );
      }

      // Validate image file exists
      final file = File(imagePath);
      if (!await file.exists()) {
        return IdentificationResult.error(
          'Image file not found: $imagePath',
          imagePath,
        );
      }

      // Build the request URL
      final baseUrl = ApiConfig.getPlantNetUrl(project: project);
      final queryParams = ApiConfig.buildQueryParameters(
        includeRelatedImages: includeRelatedImages,
        noReject: noReject,
        nbResults: maxResults,
        lang: language,
        detailed: detailed,
      );
      
      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

      // Create multipart request
      final request = http.MultipartRequest('POST', uri);

      // Add single image
      final fileSize = await file.length();
      
      // Validate file size
      if (fileSize > AppConstants.maxFileSizeBytes) {
        return IdentificationResult.error(
          'Image file too large (${(fileSize / 1024 / 1024).toStringAsFixed(1)}MB). Maximum size is ${(AppConstants.maxFileSizeBytes / 1024 / 1024).toStringAsFixed(1)}MB.',
          imagePath,
        );
      }

      // Add image file
      final imageStream = http.ByteStream(file.openRead());
      final multipartFile = http.MultipartFile(
        'images',
        imageStream,
        fileSize,
        filename: 'plant_image.jpg',
      );
      request.files.add(multipartFile);



      // Set request headers
      request.headers.addAll({
        'User-Agent': 'Plantyze/1.0.0',
        'Accept': 'application/json',
      });

      // Send request with timeout
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: AppConstants.requestTimeoutSeconds),
        onTimeout: () {
          throw Exception('Request timeout after ${AppConstants.requestTimeoutSeconds} seconds');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      // Handle response
      return _handleResponse(response, imagePath);

    } catch (e) {
      String errorMessage;
      if (e.toString().contains('timeout')) {
        errorMessage = 'Request timed out. Please check your internet connection and try again.';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else {
        errorMessage = 'Unexpected error: ${e.toString()}';
      }
      
      return IdentificationResult.error(
        errorMessage,
        imagePath,
      );
    }
  }

  /// Validates input parameters
  ValidationResult _validateInputs(String imagePath) {
    // Check if image path is provided
    if (imagePath.isEmpty) {
      return ValidationResult.error('Image path is required');
    }

    return ValidationResult.success();
  }

  /// Handles API response and parses result
  IdentificationResult _handleResponse(http.Response response, String imagePath) {
    try {
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return IdentificationResult.fromJson(data, imagePath);
      } else {
        // Handle specific error status codes
        String errorMessage;
        switch (response.statusCode) {
          case 400:
            errorMessage = 'Bad request. Please check your input parameters.';
            break;
          case 401:
            errorMessage = 'Invalid API key. Please check your Pl@ntNet API key.';
            break;
          case 403:
            errorMessage = 'Access forbidden. Your API key may not have permission.';
            break;
          case 404:
            errorMessage = 'API endpoint not found. Please check the project name.';
            break;
          case 413:
            errorMessage = 'Image file too large. Please reduce the image size.';
            break;
          case 429:
            errorMessage = 'Too many requests. You have exceeded your API quota.';
            break;
          case 500:
            errorMessage = 'Server error. Please try again later.';
            break;
          case 503:
            errorMessage = 'Service unavailable. The API is temporarily down.';
            break;
          default:
            errorMessage = 'API Error (${response.statusCode})';
        }

        // Try to extract more specific error message from response body
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          if (errorData.containsKey('message')) {
            errorMessage += ': ${errorData['message']}';
          } else if (errorData.containsKey('error')) {
            errorMessage += ': ${errorData['error']}';
          }
        } catch (e) {
          // If response body is not valid JSON, use the default error message
        }

        return IdentificationResult.error(errorMessage, imagePath);
      }
    } catch (e) {
      return IdentificationResult.error(
        'Failed to parse API response: ${e.toString()}',
        imagePath,
      );
    }
  }
}
