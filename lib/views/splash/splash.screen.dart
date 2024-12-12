import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';
import '../../../constants/app_colors.dart';
import 'splash.controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Obx(
          () {
            double scale = controller.splashLoadingAnimated.value ? 0.75 : 1.0;
            double topPosition = controller.splashLoadingAnimated.value
                ? 75.h
                : (Get.height - 200.w) / 2;
            double bottomPosition =
                controller.splashLoadingAnimated.value ? 32.h : -250.h;

            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  top: controller.splashLoadingAnimated.value ? 56.w : -56.w,
                  right: controller.splashLoadingAnimated.value ? 16.w : -120.w,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: controller.splashLoadingAnimated.value ? 1.0 : 0.0,
                    child: SizedBox(
                      width: 120.w,
                      child: Image.asset(
                        'assets/images/img_6.png',
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  top: controller.splashLoadingAnimated.value ? 56.w : -56.w,
                  left: controller.splashLoadingAnimated.value ? 16.w : -120.w,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: controller.splashLoadingAnimated.value ? 1.0 : 0.0,
                    child: SizedBox(
                      width: 120.w,
                      child: Image.asset(
                        'assets/images/img_7.png',
                      ),
                    ),
                  ),
                ),
                Center(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: controller.splashLoadingAnimated.value ? 1.0 : 0.0,
                    child: SizedBox(
                      width: Get.width - AppSize.kPadding,
                      child: Image.asset(
                        'assets/images/img_1.png',
                      ),
                    ),
                  ),
                ),
                // Center the logo
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  top: topPosition,
                  left: Get.width / 2 - (200.w / 2),
                  child: AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 500),
                    child: SizedBox(
                      height: 200.w,
                      width: 200.w,
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        semanticsLabel: 'App Logo',
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  bottom: bottomPosition,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: controller.splashLoadingAnimated.value ? 1.0 : 0.0,
                    child: _buildGroupButtonView(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  SizedBox _buildGroupButtonView() {
    return SizedBox(
      width: Get.width - AppSize.kPadding,
      child: Center(
        child: Wrap(
          direction: Axis.vertical,
          spacing: AppSize.kPadding / 2,
          children: [
            SizedBox(
              width: Get.width - AppSize.kPadding * 2,
              child: CustomButton(
                text: 'existingAccount'.tr,
                onPressed: controller.navigateToLogin,
              ),
            ),
            SizedBox(
              width: Get.width - AppSize.kPadding * 2,
              child: CustomButton(
                text: 'registerMember'.tr,
                onPressed: controller.navigateToRegisterAsMember,
                isOutlined: true,
                disabled: false,
              ),
            ),
            SizedBox(
              width: Get.width - AppSize.kPadding * 2,
              child: CustomButton(
                text: 'registerLeader'.tr,
                onPressed: controller.navigateToRegisterAsLeader,
                isOutlined: true,
                disabled: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
