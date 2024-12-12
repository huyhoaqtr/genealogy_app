import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'loading.controller.dart';

class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoadingOverlayState createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  final LoadingController loadingController = Get.put(LoadingController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (loadingController.isLoading.value) {
        return Container(
          color: Colors.black.withOpacity(0.45),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const LoadingIcon(size: 50),
                Text(
                  "Đang xử lý...",
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }
}

class LoadingIcon extends StatefulWidget {
  const LoadingIcon({super.key, required this.size});
  final double size;

  @override
  State<LoadingIcon> createState() => _LoadingIconState();
}

class _LoadingIconState extends State<LoadingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 2 * 3.141,
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.rotate(
          angle: -_animation.value,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Image.asset(
              'assets/images/loader.png',
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
