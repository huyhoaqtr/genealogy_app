import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'compass.controller.dart';

class CompassScreen extends GetView<CompassController> {
  const CompassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("La bàn phong thuỷ"),
        leading: IconButtonComponent(
            iconPath: 'assets/icons/arrow-left.svg',
            onPressed: () => Get.back()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
        child: Center(
          child: SizedBox(
            width: min(Get.width - AppSize.kPadding, 350),
            height: min(Get.width - AppSize.kPadding, 350) + 300,
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Obx(() => Text(
                          controller.getDirection(controller.direction.value),
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        )),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: IconButtonComponent(
                      iconColor: AppColors.primaryColor,
                      iconPath: "assets/icons/arrow-bottom-2.svg",
                      iconSize: 40,
                      iconPadding: 0,
                    ),
                  ),
                ),
                Center(
                  child: Obx(
                    () {
                      final double containerSize =
                          min(Get.width - AppSize.kPadding, 350);
                      final double targetAngle =
                          -(controller.direction.value * pi / 180);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: controller.currentAngle.value,
                              end: targetAngle,
                            ),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.linear,
                            onEnd: () {
                              controller.currentAngle.value = targetAngle;
                            },
                            builder: (context, angle, child) {
                              return Transform.rotate(
                                angle: angle,
                                child: Container(
                                  width: containerSize,
                                  height: containerSize,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(containerSize),
                                  ),
                                  child: Image.asset(
                                    "assets/images/laban.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Obx(() => Text(
                          controller.getDirection(
                              (controller.direction.value - 180).abs()),
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
