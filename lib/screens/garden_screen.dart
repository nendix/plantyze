import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantyze/models/saved_plant.dart';
import 'package:plantyze/services/garden_service.dart';
import 'package:plantyze/screens/plant_details_screen.dart';
import 'package:plantyze/screens/base_screen.dart';
import 'package:plantyze/widgets/plant_card_widget.dart';

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
  @override
  void initState() {
    super.initState();
    // Listen to garden service changes
    widget.gardenService.addListener(_onGardenChanged);
  }

  @override
  void dispose() {
    widget.gardenService.removeListener(_onGardenChanged);
    super.dispose();
  }

  void _onGardenChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _showDeleteDialog(SavedPlant savedPlant) {
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
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              final success = await widget.gardenService.removePlant(savedPlant.id);
              if (mounted && success) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('${savedPlant.plant.commonName} removed from garden'),
                    backgroundColor: Colors.red[600],
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showClearGardenDialog() {
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
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              navigator.pop();
              await widget.gardenService.clearGarden();
              if (mounted) {
                messenger.showSnackBar(
                  SnackBar(
                    content: const Text('Garden cleared'),
                    backgroundColor: Colors.red[600],
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
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

  @override
  Widget build(BuildContext context) {
    final savedPlants = widget.gardenService.savedPlants;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Garden',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          if (savedPlants.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _showClearGardenDialog,
              tooltip: 'Clear Garden',
            ),
        ],
      ),
      body: savedPlants.isEmpty ? _buildEmptyState() : _buildPlantsList(savedPlants),
    );
  }

  Widget _buildEmptyState() {
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
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              ),
              child: Icon(
                Icons.eco_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Your Garden is Empty',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Start identifying plants and save them to your garden to build your personal plant collection.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
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

  Widget _buildPlantsList(List<SavedPlant> savedPlants) {
    return Column(
      children: [
        // Stats header
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${savedPlants.length} Plants',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    'in your garden',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.eco,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),

        // Plants list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: savedPlants.length,
            itemBuilder: (context, index) {
              final savedPlant = savedPlants[index];

              return Dismissible(
                key: Key(savedPlant.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                confirmDismiss: (direction) async {
                  _showDeleteDialog(savedPlant);
                  return false; // Don't dismiss automatically, let dialog handle it
                },
                child: Column(
                  children: [
                    PlantCardWidget(
                      plant: savedPlant.plant,
                      confidenceScore: savedPlant.plant.score,
                      onTap: () => _navigateToPlantDetails(savedPlant),
                    ),
                    // Add saved date info
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Saved ${DateFormat('MMM d, yyyy').format(savedPlant.savedAt)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}