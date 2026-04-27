import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImages extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ColorFilter? colorFilter;

  const AppImages({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.colorFilter,
  });

  bool get isNetworkImage =>
      imagePath.startsWith('http') || imagePath.startsWith('https');

  @override
  Widget build(BuildContext context) {
    final extension = imagePath.split('.').last.toLowerCase();

    if (isNetworkImage) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image),
      );
    }

    switch (extension) {
      case 'svg':
        return SvgPicture.asset(
          'assets/icons${imagePath}',
          width: width,
          height: height,
          fit: fit,
          colorFilter: colorFilter,
        );

      case 'png':
      case 'jpg':
      case 'jpeg':
      case 'webp':
        return Image.asset(
          'assets/images${imagePath}',
          width: width,
          height: height,
          fit: fit,
        );

      default:
        return const Icon(Icons.image_not_supported);
    }
  }
}
