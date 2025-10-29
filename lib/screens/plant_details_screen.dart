import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:plantyze/models/plant.dart';
import 'package:plantyze/services/garden_service.dart';

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.eco, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('${widget.plant.commonName} saved to your garden!'),
                  ),
                ],
              ),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.info, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${widget.plant.commonName} is already in your garden',
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.orange[600],
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save plant: ${e.toString()}'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildBody(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSaving ? null : _savePlantToGarden,
        icon: _isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.eco),
        label: Text(_isSaving ? 'Saving...' : 'Save to Garden'),
        backgroundColor: widget.gardenService.isPlantSaved(widget.plant)
            ? Colors.green[600]
            : null,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.plant.commonName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black54,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        background: Hero(
          tag: 'plant_image_${widget.plant.id}',
          child:
              widget.plant.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                    imageUrl: widget.plant.imageUrl,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                  )
                  : Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scientific name
          const Text(
            'Scientific Name',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.plant.scientificName,
            style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
          ),

          const Divider(height: 32),

          // Family
          const Text(
            'Family',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(widget.plant.family.scientificNameWithoutAuthor, style: const TextStyle(fontSize: 18)),

          const Divider(height: 32),

          // Confidence level
          const Text(
            'Identification Confidence',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: widget.plant.probability,
            backgroundColor: Colors.grey[200],
            color: _getConfidenceColor(widget.plant.probability),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 8),
          Text(
            '${(widget.plant.probability * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _getConfidenceColor(widget.plant.probability),
            ),
          ),

          const Divider(height: 32),

          // Description (if available) or alternative text
          const Text(
            'About',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.plant.description.isNotEmpty
                ? widget.plant.description
                : 'No additional information available for this plant. You can search online for more details about ${widget.plant.commonName} (${widget.plant.scientificName}).',
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 32),

          // Similar images if available
          if (widget.plant.similarImages.isNotEmpty) ...[
            const Text(
              'Similar Images',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.plant.similarImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: widget.plant.similarImages[index],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.75) {
      return Colors.green;
    } else if (confidence >= 0.5) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
