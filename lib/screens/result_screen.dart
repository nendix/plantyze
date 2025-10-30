import 'dart:io';
import 'package:flutter/material.dart';
import 'package:plantyze/models/identification_result.dart';
import 'package:plantyze/models/plant.dart';
import 'package:plantyze/screens/plant_details_screen.dart';
import 'package:plantyze/services/garden_service.dart';
import 'package:plantyze/services/navigation_service.dart';
import 'package:plantyze/widgets/plant_image_widget.dart';
import 'package:plantyze/widgets/empty_state_widget.dart';
import 'package:plantyze/widgets/confidence_badge_widget.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => NavigationService.pop(context),
        ),
      ),
      body: widget.result.isSuccessful
          ? _buildSuccessfulResult(context, theme)
          : _buildFailedResult(context, theme),
    );
  }

  Widget _buildSuccessfulResult(BuildContext context, ThemeData theme) {
    if (widget.result.plants.isEmpty) {
      return _buildNoResultsFound(context, theme);
    }

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.32,
          width: double.infinity,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(widget.result.capturedImagePath),
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Badge(
                  label: Text(
                    widget.result.plants.length.toString(),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: theme.colorScheme.primary,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${widget.result.plants.length == 1 ? 'match' : 'matches'} found',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            itemCount: widget.result.plants.length,
            itemBuilder: (context, index) {
              final plant = widget.result.plants[index];
              return _buildPlantItem(context, theme, plant, index);
            },
          ),
        ),
      ],
    );
  }

   Widget _buildPlantItem(
    BuildContext context,
    ThemeData theme,
    Plant plant,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _navigateToPlantDetails(context, plant),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              PlantImageWidget(
                imageUrl: plant.imageUrl,
                width: 70,
                height: 70,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Best Match',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    Text(
                      plant.commonName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      plant.scientificName,
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ConfidenceBadgeWidget(
                score: plant.score,
                size: 56,
                showLabel: false,
                showPercentage: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

   Widget _buildFailedResult(BuildContext context, ThemeData theme) {
    return EmptyStateWidget(
      icon: Icons.error_outline,
      iconColor: theme.colorScheme.error,
      backgroundColor: theme.colorScheme.errorContainer,
      title: 'Identification Failed',
      description:
          widget.result.errorMessage ?? 'Unknown error occurred',
      buttonLabel: 'Try Again',
      buttonIcon: Icons.camera_alt,
      onButtonPressed: () => NavigationService.pop(context),
    );
  }

   Widget _buildNoResultsFound(BuildContext context, ThemeData theme) {
    return EmptyStateWidget(
      icon: Icons.search_off,
      iconColor: theme.colorScheme.tertiary,
      backgroundColor: theme.colorScheme.tertiaryContainer,
      title: 'No Plants Identified',
      description:
          'We couldn\'t identify any plants in this image. Try taking a clearer photo or from a different angle.',
      buttonLabel: 'Try Again',
      buttonIcon: Icons.camera_alt,
      onButtonPressed: () => NavigationService.pop(context),
    );
  }

  void _navigateToPlantDetails(BuildContext context, Plant plant) {
    NavigationService.push(
      context,
      PlantDetailsScreen(
        plant: plant,
        gardenService: widget.gardenService,
      ),
    );
  }
}
