import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plantyze/models/identification_result.dart';
import 'package:plantyze/models/plant.dart';
import 'package:plantyze/screens/plant_details_screen.dart';
import 'package:plantyze/widgets/plant_card_widget.dart';

class ResultScreen extends StatelessWidget {
  final IdentificationResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identification Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:
              () => Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false),
        ),
      ),
      body:
          result.isSuccessful
              ? _buildSuccessfulResult(context)
              : _buildFailedResult(context),
    );
  }

  Widget _buildSuccessfulResult(BuildContext context) {
    if (result.plants.isEmpty) {
      return _buildNoResultsFound(context);
    }

    return Column(
      children: [
        // Captured image preview
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
              image: FileImage(File(result.queryCapturedImage)),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Results list
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Results',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'We found ${result.plants.length} potential matches',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: result.plants.length,
                    itemBuilder: (context, index) {
                      final plant = result.plants[index];
                      final confidence = (plant.probability * 100)
                          .toStringAsFixed(1);

                      return PlantCardWidget(
                        plant: plant,
                        confidence: confidence,
                        onTap: () => _navigateToPlantDetails(context, plant),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFailedResult(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 72, color: Colors.red),
            const SizedBox(height: 24),
            const Text(
              'Identification Failed',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              result.errorMessage ?? 'Unknown error occurred',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsFound(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 72, color: Colors.amber),
            const SizedBox(height: 24),
            const Text(
              'No Plants Identified',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'We couldn\'t identify any plants in this image. Try taking a clearer photo or from a different angle.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPlantDetails(BuildContext context, Plant plant) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PlantDetailsScreen(plant: plant)),
    );
  }
}
