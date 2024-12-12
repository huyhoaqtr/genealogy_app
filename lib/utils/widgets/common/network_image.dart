import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl; // URL của hình ảnh cần hiển thị
  final double width; // Chiều rộng của hình ảnh
  final double height; // Chiều cao của hình ảnh
  final BoxFit fit; // Cách căn chỉnh hình ảnh
  final Widget? placeholder; // Widget hiển thị khi hình ảnh đang tải

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
    this.placeholder = const CircularProgressIndicator(),
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl.isNotEmpty
          ? imageUrl
          : 'https://cdn-icons-png.flaticon.com/512/149/149071.png', // Kiểm tra imageUrl trống
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child; // Trả về hình ảnh khi đã tải xong
        } else {
          return Center(child: placeholder); // Hiển thị khi đang tải
        }
      },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        return Center(
            child: Image.network(
                'https://cdn-icons-png.flaticon.com/512/149/149071.png'));
      },
    );
  }
}
