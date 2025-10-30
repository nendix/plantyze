import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantyze/models/saved_plant.dart';
import 'package:plantyze/services/garden_service.dart';
import 'package:plantyze/screens/plant_details_screen.dart';
import 'package:plantyze/screens/base_screen.dart';

class GardenScreen extends StatefulWidget {
  final GardenService gardenService;

  const GardenScreen({
    super.key, 
    required this.gardenService,
  });

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
    final errorColor = Theme.of(context).colorScheme.error;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Plant'),
        content: Text(
          'Are you sure you want to remove "${savedPlant.plant.commonName}" from your garden?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (!mounted) return;
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              final success = await widget.gardenService.removePlant(savedPlant.id);
              if (mounted && success) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('${savedPlant.plant.commonName} removed from garden'),
                    backgroundColor: errorColor,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: errorColor),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showClearGardenDialog() {
    final errorColor = Theme.of(context).colorScheme.error;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Garden'),
        content: const Text(
          'Are you sure you want to remove all plants from your garden? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (!mounted) return;
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              await widget.gardenService.clearGarden();
              if (mounted) {
                messenger.showSnackBar(
                  SnackBar(
                    content: const Text('Garden cleared'),
                    backgroundColor: errorColor,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: errorColor),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _navigateToPlantDetails(SavedPlant savedPlant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlantDetailsScreen(
          plant: savedPlant.plant,
          gardenService: widget.gardenService,
        ),
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
        title: const Text('My Garden'),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        return _buildListPlantItem(theme, filteredPlants[index]);
                      },
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
              ),
              child: Icon(
                Icons.eco_outlined,
                size: 80,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Your Garden is Empty',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Start identifying plants and save them to your garden to build your personal plant collection.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.navigateToTab(1),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Identify Plants'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: savedPlant.plant.images.isNotEmpty
                        ? Image.network(
                            savedPlant.plant.images.first,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.local_florist,
                                color: theme.colorScheme.primary,
                              );
                            },
                          )
                        : Icon(
                            Icons.local_florist,
                            color: theme.colorScheme.primary,
                          ),
                  ),
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
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM d, yyyy').format(savedPlant.savedAt),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
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