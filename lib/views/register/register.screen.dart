import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';

import '../../constants/app_colors.dart';
import '../../utils/types/type.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/passwordfield.common.dart';
import '../../utils/widgets/qr_scanner/qr_code_scanner.dart';
import '../../utils/widgets/text_button.common.dart';
import '../../utils/widgets/textfield.common.dart';
import 'register.controller.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButtonComponent(
            iconPath: 'assets/icons/arrow-left.svg',
            onPressed: () => Get.back()),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150.w,
                  width: 150.w,
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    semanticsLabel: 'App Logo',
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() => (TextFieldComponent(
                          controller: controller.fullNameController,
                          hintText: 'enterFullName'.tr,
                          labelText: 'fullName'.tr,
                          textInputAction: TextInputAction.next,
                          errorText: controller.fullNameError.value.isNotEmpty
                              ? controller.fullNameError.value
                              : null,
                        ))),
                    SizedBox(height: 16.h),
                    controller.role == UserRole.MEMBER
                        ? Obx(() => (TextFieldComponent(
                              controller: controller.tribeCodeController,
                              hintText: 'enterTribeCode'.tr,
                              labelText: 'tribeCode'.tr,
                              textInputAction: TextInputAction.next,
                              errorText:
                                  controller.tribeCodeError.value.isNotEmpty
                                      ? controller.tribeCodeError.value
                                      : null,
                            )))
                        : Obx(() => (TextFieldComponent(
                              controller: controller.tribeNameController,
                              hintText: 'enterTribeName'.tr,
                              labelText: 'tribeName'.tr,
                              textInputAction: TextInputAction.next,
                              errorText:
                                  controller.tribeNameError.value.isNotEmpty
                                      ? controller.tribeNameError.value
                                      : null,
                            ))),
                    SizedBox(height: 16.h),
                    Obx(() => (TextFieldComponent(
                          controller: controller.phoneNumberController,
                          hintText: 'enterPhoneNumber'.tr,
                          labelText: 'phoneNumber'.tr,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          errorText:
                              controller.phoneNumberError.value.isNotEmpty
                                  ? controller.phoneNumberError.value
                                  : null,
                        ))),
                    SizedBox(height: 16.h),
                    Obx(() => (PasswordFieldComponent(
                          textEditingController: controller.passwordController,
                          hintText: 'enterPassword'.tr,
                          labelText: 'password'.tr,
                          textInputAction: TextInputAction.next,
                          errorText: controller.passwordError.value.isNotEmpty
                              ? controller.passwordError.value
                              : null,
                        ))),
                    SizedBox(height: 16.h),
                    Obx(() => (PasswordFieldComponent(
                          textEditingController:
                              controller.confirmPasswordController,
                          hintText: 'enterRePassword'.tr,
                          labelText: 'rePassword'.tr,
                          textInputAction: TextInputAction.done,
                          errorText:
                              controller.confirmPasswordError.value.isNotEmpty
                                  ? controller.confirmPasswordError.value
                                  : null,
                        ))),
                    SizedBox(height: 16.h),
                    CustomButton(
                      text: 'register'.tr,
                      onPressed: controller.handleRegister,
                    ),
                    SizedBox(height: 16.h),
                    if (controller.role == UserRole.MEMBER)
                      CustomButton(
                        text: 'Quét mã',
                        isOutlined: true,
                        onPressed: () => Get.to(() => const QRCodeScanner()),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
