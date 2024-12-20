import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/common/network_image.dart';

class ImageOverlay extends StatelessWidget {
  final Rx<Offset> position;
  final Rx<Offset> initialPosition;
  final String url;
  final VoidCallback onHideTooltip;

  const ImageOverlay({
    super.key,
    required this.position,
    required this.initialPosition,
    required this.url,
    required this.onHideTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      double difference = (position.value - initialPosition.value).distance;
      return Container(
        width: Get.width,
        height: Get.height,
        alignment: Alignment.center,
        color: Colors.white.withOpacity(1 - (min(difference.abs(), 100) / 100)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: position.value.dy,
              left: position.value.dx,
              child: GestureDetector(
                onPanStart: (details) {
                  initialPosition.value = position.value;
                },
                onPanUpdate: (details) {
                  position.value += details.delta;
                },
                onPanEnd: (details) {
                  if (difference > 100) {
                    onHideTooltip();
                  } else {
                    position.value = initialPosition.value;
                  }
                },
                child: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: (1 - (min(difference.abs() / 2, 100) / 100)),
                        child: SizedBox(
                          width: Get.width *
                              (1 - (min(difference.abs() / 2, 50) / 100)),
                          height: (Get.height * 0.75) *
                              (1 - (min(difference.abs() / 2, 50) / 100)),
                          child: CustomNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
