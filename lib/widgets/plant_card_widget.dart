import 'package:flutter/material.dart';
import 'package:plantyze/models/plant.dart';

class PlantCardWidget extends StatelessWidget {
  final Plant plant;
  final double confidenceScore;
  final VoidCallback onTap;

  const PlantCardWidget({
    super.key,
    required this.plant,
    required this.confidenceScore,
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Positioned(top: 0, right: 0, child: _buildConfidenceCircle()),
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.commonName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            plant.scientificName,
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfidenceCircle() {
    Color circleColor;

    if (confidenceScore >= 0.6) {
      circleColor = Colors.green;
    } else if (confidenceScore >= 0.3) {
      circleColor = Colors.amber;
    } else {
      circleColor = Colors.red;
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
    );
  }
}
