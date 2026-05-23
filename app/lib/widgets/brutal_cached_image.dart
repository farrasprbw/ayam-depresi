import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Cached network image with brutalist placeholder/error states
/// Supports optional grayscale and opacity for performance
class BrutalCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final bool grayscale;
  final double opacity;

  const BrutalCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.memCacheWidth,
    this.memCacheHeight,
    this.grayscale = false,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (context, url) => Container(
        color: AppColors.surfaceContainerLowest,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.surfaceContainerLowest,
        child: const Center(
          child: Icon(Icons.broken_image, color: AppColors.secondary, size: 32),
        ),
      ),
      // Use color blend for grayscale instead of ColorFiltered widget
      color: grayscale ? Colors.grey : null,
      colorBlendMode: grayscale ? BlendMode.saturation : null,
    );

    // Use color-based opacity instead of Opacity widget
    if (opacity < 1.0) {
      image = Opacity(
        alwaysIncludeSemantics: true,
        opacity: opacity,
        child: image,
      );
    }

    return image;
  }
}
