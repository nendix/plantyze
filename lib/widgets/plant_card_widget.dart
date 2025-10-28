import 'package:flutter/material.dart';
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
                    Row(children: [_buildConfidenceBadge(context)]),
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
        color: badgeColor.withValues(alpha: 0.1),
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
