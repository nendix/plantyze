import 'package:flutter/material.dart';
import 'package:plantyze/models/plant.dart';
import 'package:plantyze/services/garden_service.dart';
import 'package:plantyze/services/snackbar_service.dart';
import 'package:plantyze/widgets/plant_image_widget.dart';

class PlantDetailsScreen extends StatefulWidget {
  final Plant plant;
  final GardenService gardenService;

  const PlantDetailsScreen({
    super.key,
    required this.plant,
    required this.gardenService,
  });

  @override
  State<PlantDetailsScreen> createState() => _PlantDetailsScreenState();
}

class _PlantDetailsScreenState extends State<PlantDetailsScreen> {
  bool _isSaving = false;

   Future<void> _savePlantToGarden() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final success = await widget.gardenService.savePlant(widget.plant);

      if (mounted) {
        if (success) {
          SnackBarService.showSuccess(
            context,
            '${widget.plant.commonName} saved to your garden!',
          );
        } else {
          SnackBarService.showInfo(
            context,
            '${widget.plant.commonName} is already in your garden',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        SnackBarService.showError(
          context,
          'Failed to save plant: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, theme),
          SliverToBoxAdapter(child: _buildBody(context, theme)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _savePlantToGarden,
        icon: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Icon(
                widget.gardenService.isPlantSaved(widget.plant)
                    ? Icons.check_circle
                    : Icons.add,
              ),
        label: Text(_isSaving ? 'Saving...' : widget.gardenService.isPlantSaved(widget.plant) ? 'Saved' : 'Save to Garden'),
        backgroundColor: widget.gardenService.isPlantSaved(widget.plant)
            ? theme.colorScheme.primary
            : theme.colorScheme.primary,
      ),
    );
  }

   Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.plant.commonName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 8.0,
                color: Colors.black87,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            PlantImageWidget(
              imageUrl: widget.plant.imageUrl,
              width: double.infinity,
              height: double.infinity,
              borderRadius: 0,
            ),
          ],
        ),
      ),
    );
  }

   Widget _buildBody(BuildContext context, ThemeData theme) {
     return Padding(
       padding: const EdgeInsets.all(16.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           _buildSection(
             theme,
             title: 'Scientific Classification',
             icon: Icons.science,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 _buildInfoRow('Scientific Name', widget.plant.scientificName, theme, isItalic: true),
                 const SizedBox(height: 16),
                 _buildInfoRow('Family', widget.plant.family, theme),
                 const SizedBox(height: 16),
                 _buildInfoRow('Common Names', widget.plant.commonNames.join(', '), theme),
               ],
             ),
           ),
            if (widget.plant.similarImages.isNotEmpty) ...[
             const SizedBox(height: 16),
             _buildSection(
               theme,
               title: 'Similar Images',
               icon: Icons.photo_library,
               child: SizedBox(
                 height: 100,
                 child: ListView.builder(
                   scrollDirection: Axis.horizontal,
                   itemCount: widget.plant.similarImages.length,
                   itemBuilder: (context, index) {
                     return Padding(
                       padding: const EdgeInsets.only(right: 8.0),
                       child: PlantImageWidget(
                         imageUrl: widget.plant.similarImages[index],
                         width: 100,
                         height: 100,
                         borderRadius: 12,
                       ),
                     );
                   },
                 ),
               ),
             ),
           ],
           const SizedBox(height: 80),
         ],
       ),
     );
   }

  Widget _buildSection(
    ThemeData theme, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme, {bool isItalic = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
