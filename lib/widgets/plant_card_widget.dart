import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:plantyze/models/plant.dart';

class PlantCardWidget extends StatelessWidget {
  final Plant plant;
  final String confidence;
  final VoidCallback onTap;

  const PlantCardWidget({
    super.key,
    required this.plant,
    required this.confidence,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Hero(
                tag: 'plant_image_${plant.id}',
                child:
                    plant.imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                          imageUrl: plant.imageUrl,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                color: Colors.grey[200],
                                height: 120,
                                width: 120,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color: Colors.grey[200],
                                height: 120,
                                width: 120,
                                child: const Icon(Icons.error),
                              ),
                        )
                        : Container(
                          color: Colors.grey[200],
                          height: 120,
                          width: 120,
                          child: const Icon(Icons.local_florist),
                        ),
              ),
            ),

            // Plant information
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant.commonName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plant.scientificName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildConfidenceBadge(context),
                        const SizedBox(width: 8),
                        Text(
                          'Family: ${plant.family}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Arrow indicator
            Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceBadge(BuildContext context) {
    final double confidenceValue = double.parse(confidence) / 100;
    Color badgeColor;

    if (confidenceValue >= 0.75) {
      badgeColor = Colors.green;
    } else if (confidenceValue >= 0.5) {
      badgeColor = Colors.orange;
    } else {
      badgeColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        border: Border.all(color: badgeColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$confidence%',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: badgeColor,
        ),
      ),
    );
  }
}
