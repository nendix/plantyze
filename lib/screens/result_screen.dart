import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plantyze/models/identification_result.dart';
import 'package:plantyze/models/plant.dart';
import 'package:plantyze/screens/plant_details_screen.dart';
import 'package:plantyze/services/garden_service.dart';
import 'package:plantyze/widgets/plant_card_widget.dart';

class ResultScreen extends StatefulWidget {
  final IdentificationResult result;
  final GardenService gardenService;

  const ResultScreen({
    super.key,
    required this.result,
    required this.gardenService,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: widget.result.isSuccessful
          ? _buildSuccessfulResult(context)
          : _buildFailedResult(context),
    );
  }

  Widget _buildSuccessfulResult(BuildContext context) {
    if (widget.result.plants.isEmpty) {
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
              image: FileImage(File(widget.result.capturedImagePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Results list
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: widget.result.plants.length,
              itemBuilder: (context, index) {
                final plant = widget.result.plants[index];

                return PlantCardWidget(
                  plant: plant,
                  confidenceScore: plant.score,
                  onTap: () => _navigateToPlantDetails(context, plant),
                );
              },
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
              widget.result.errorMessage ?? 'Unknown error occurred',
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
      MaterialPageRoute(
        builder: (context) => PlantDetailsScreen(
          plant: plant,
          gardenService: widget.gardenService,
        ),
      ),
    );
  }
}
