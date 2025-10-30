import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlantImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final double borderRadius;

  const PlantImageWidget({
    super.key,
    required this.imageUrl,
    this.width = 70,
    this.height = 70,
    this.fit = BoxFit.cover,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: theme.colorScheme.surfaceContainerHighest,
        child: imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: fit,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.local_florist,
                  color: theme.colorScheme.primary,
                  size: width * 0.4,
                ),
              )
            : Icon(
                Icons.local_florist,
                color: theme.colorScheme.primary,
                size: width * 0.4,
              ),
      ),
    );
  }
}
