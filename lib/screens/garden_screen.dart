import 'package:flutter/material.dart';
import 'package:plantyze/models/saved_plant.dart';
import 'package:plantyze/services/garden_service.dart';
import 'package:plantyze/services/dialog_service.dart';
import 'package:plantyze/services/snackbar_service.dart';
import 'package:plantyze/services/navigation_service.dart';
import 'package:plantyze/screens/plant_details_screen.dart';
import 'package:plantyze/screens/base_screen.dart';
import 'package:plantyze/widgets/plant_image_widget.dart';
import 'package:plantyze/widgets/empty_state_widget.dart';

class GardenScreen extends StatefulWidget {
  final GardenService gardenService;

  const GardenScreen({super.key, required this.gardenService});

  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    widget.gardenService.addListener(_onGardenChanged);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    widget.gardenService.removeListener(_onGardenChanged);
    super.dispose();
  }

  void _onGardenChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

   void _showDeleteDialog(SavedPlant savedPlant) {
    DialogService.showConfirmDialog(
      context,
      title: 'Remove Plant',
      message:
          'Are you sure you want to remove "${savedPlant.plant.commonName}" from your garden?',
      confirmLabel: 'Remove',
      cancelLabel: 'Cancel',
    ).then((confirmed) async {
      if (!confirmed || !mounted) return;
      final success = await widget.gardenService.removePlant(savedPlant.id);
      if (mounted && success) {
        SnackBarService.showSuccess(
          context,
          '${savedPlant.plant.commonName} removed from garden',
        );
      }
    });
  }

   void _showClearGardenDialog() {
    DialogService.showConfirmDialog(
      context,
      title: 'Clear Garden',
      message:
          'Are you sure you want to remove all plants from your garden? This action cannot be undone.',
      confirmLabel: 'Clear All',
      cancelLabel: 'Cancel',
    ).then((confirmed) async {
      if (!confirmed || !mounted) return;
      await widget.gardenService.clearGarden();
      if (mounted) {
        SnackBarService.showSuccess(context, 'Garden cleared');
      }
    });
  }

  void _navigateToPlantDetails(SavedPlant savedPlant) {
    NavigationService.push(
      context,
      PlantDetailsScreen(
        plant: savedPlant.plant,
        gardenService: widget.gardenService,
      ),
    );
  }

  List<SavedPlant> _getFilteredPlants(List<SavedPlant> plants) {
    if (_searchQuery.isEmpty) {
      return plants;
    }
    return plants.where((plant) {
      return plant.plant.commonName.toLowerCase().contains(_searchQuery) ||
          plant.plant.scientificName.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final savedPlants = widget.gardenService.savedPlants;
    final filteredPlants = _getFilteredPlants(savedPlants);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Garden'),
        centerTitle: false,
        actions: [
          if (savedPlants.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _showClearGardenDialog,
              tooltip: 'Clear Garden',
            ),
        ],
      ),
      body: savedPlants.isEmpty
          ? _buildEmptyState(theme)
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search plants...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _searchController.clear,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                if (filteredPlants.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        'No plants found',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredPlants.length,
                      itemBuilder: (context, index) {
                        return _buildListPlantItem(
                          theme,
                          filteredPlants[index],
                        );
                      },
                    ),
                  ),
              ],
            ),
    );
  }

   Widget _buildEmptyState(ThemeData theme) {
    return EmptyStateWidget(
      icon: Icons.eco_outlined,
      iconColor: theme.colorScheme.primary,
      backgroundColor:
          theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
      title: 'Your Garden is Empty',
      description:
          'Start identifying plants and save them to your garden to build your personal plant collection.',
      buttonLabel: 'Identify Plants',
      buttonIcon: Icons.camera_alt,
      onButtonPressed: () => context.navigateToTab(1),
    );
  }

   Widget _buildListPlantItem(ThemeData theme, SavedPlant savedPlant) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _navigateToPlantDetails(savedPlant),
          onLongPress: () => _showDeleteDialog(savedPlant),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                PlantImageWidget(
                  imageUrl: savedPlant.plant.images.isNotEmpty
                      ? savedPlant.plant.images.first
                      : '',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        savedPlant.plant.commonName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        savedPlant.plant.scientificName,
                        style: theme.textTheme.bodySmall?.copyWith(
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
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
