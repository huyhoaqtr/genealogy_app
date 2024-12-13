import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getx_app/utils/widgets/progress_indicator.dart';

class AvatarImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final BoxFit fit;
  final Widget? placeholder;
  final double radius;

  const AvatarImage({
    super.key,
    required this.imageUrl,
    this.size = double.infinity,
    this.fit = BoxFit.cover,
    this.radius = 100,
    this.placeholder = const ProgressIndicatorComponent(size: 30),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: imageUrl.isNotEmpty
            ? imageUrl
            : 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
        width: size,
        height: size,
        fit: fit,
        placeholder: (context, url) => Center(child: placeholder),
        errorWidget: (context, url, error) => Center(
          child: Image.network(
            'https://cdn-icons-png.flaticon.com/512/149/149071.png',
          ),
        ),
      ),
    );
  }
}
