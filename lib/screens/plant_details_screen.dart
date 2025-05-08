import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:plantyze/models/plant.dart';

class PlantDetailsScreen extends StatelessWidget {
  final Plant plant;

  const PlantDetailsScreen({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          plant.commonName,
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
          tag: 'plant_image_${plant.id}',
          child:
              plant.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                    imageUrl: plant.imageUrl,
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
            plant.scientificName,
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
          Text(plant.family, style: const TextStyle(fontSize: 18)),

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
            value: plant.probability,
            backgroundColor: Colors.grey[200],
            color: _getConfidenceColor(plant.probability),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 8),
          Text(
            '${(plant.probability * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _getConfidenceColor(plant.probability),
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
            plant.description.isNotEmpty
                ? plant.description
                : 'No additional information available for this plant. You can search online for more details about ${plant.commonName} (${plant.scientificName}).',
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 32),

          // Similar images if available
          if (plant.similarImages.isNotEmpty) ...[
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
                itemCount: plant.similarImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: plant.similarImages[index],
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
