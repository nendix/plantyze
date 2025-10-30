import 'package:flutter/material.dart';
import 'package:plantyze/config/theme_config.dart';

class ConfidenceBadgeWidget extends StatelessWidget {
  final double score;
  final double size;
  final bool showLabel;
  final bool showPercentage;
  final bool dotOnly;

  const ConfidenceBadgeWidget({
    super.key,
    required this.score,
    this.size = 56,
    this.showLabel = true,
    this.showPercentage = true,
    this.dotOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = ThemeConfig.getConfidenceColor(score);

    if (dotOnly) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Container(
            width: size * 0.35,
            height: size * 0.35,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    final label = ThemeConfig.getConfidenceLabel(score);
    final percentage = (score * 100).toStringAsFixed(0);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(size * 0.2),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showPercentage)
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: size * 0.25,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          const SizedBox(height: 2),
          Container(
            width: size * 0.1,
            height: size * 0.1,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: size * 0.12,
                color: color,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
