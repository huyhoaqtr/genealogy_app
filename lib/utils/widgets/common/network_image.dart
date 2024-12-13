import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:getx_app/utils/widgets/progress_indicator.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget? placeholder;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
    this.placeholder = const ProgressIndicatorComponent(size: 30),
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl.isNotEmpty
          ? imageUrl
          : 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Center(child: placeholder),
      errorWidget: (context, url, error) => Center(
        child: Image.network(
          'https://cdn-icons-png.flaticon.com/512/149/149071.png',
        ),
      ),
    );
  }
}
