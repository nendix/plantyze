import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:plantyze/config/api_config.dart';
import 'package:plantyze/models/identification_result.dart';

class PlantApiService {
  Future<IdentificationResult> identifyPlant(String imagePath) async {
    try {
      // Check if the API key is set
      if (ApiConfig.plantNetApiKey.isEmpty) {
        return IdentificationResult.error(
          'API key not found. Please add your Pl@ntNet API key to the .env file.',
          imagePath,
        );
      }

      // Get the image file
      final File imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        return IdentificationResult.error('Image file not found', imagePath);
      }

      // Prepare the multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.getPlantNetUrl()),
      );

      // Add the image file
      final imageStream = http.ByteStream(imageFile.openRead());
      final imageLength = await imageFile.length();
      final multipartFile = http.MultipartFile(
        'images',
        imageStream,
        imageLength,
        filename: 'plant_image.jpg',
      );
      request.files.add(multipartFile);

      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return IdentificationResult.fromJson(data, imagePath);
      } else {
        // Handle error responses
        try {
          final Map<String, dynamic> errorData = json.decode(response.body);
          final errorMessage = errorData['message'] ?? 'Unknown error occurred';
          return IdentificationResult.error(
            'API Error (${response.statusCode}): $errorMessage',
            imagePath,
          );
        } catch (e) {
          return IdentificationResult.error(
            'API Error (${response.statusCode})',
            imagePath,
          );
        }
      }
    } catch (e) {
      return IdentificationResult.error('Error: ${e.toString()}', imagePath);
    }
  }
}
