import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.only(
            left: AppSize.kPadding,
            right: AppSize.kPadding,
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
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
                    const SizedBox(height: AppSize.kPadding),
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
                    const SizedBox(height: AppSize.kPadding),
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
                    const SizedBox(height: AppSize.kPadding),
                    Obx(() => (PasswordFieldComponent(
                          key: const Key('password'),
                          textEditingController: controller.passwordController,
                          hintText: 'enterPassword'.tr,
                          labelText: 'password'.tr,
                          textInputAction: TextInputAction.next,
                          errorText: controller.passwordError.value.isNotEmpty
                              ? controller.passwordError.value
                              : null,
                        ))),
                    const SizedBox(height: AppSize.kPadding),
                    Obx(() => (PasswordFieldComponent(
                          key: const Key('confirmPassword'),
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
                    const SizedBox(height: AppSize.kPadding),
                    Row(
                      children: [
                        if (controller.role == UserRole.MEMBER)
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppSize.kRadius * 2),
                            child: Container(
                              color: AppColors.backgroundColor,
                              child: OutlinedButton(
                                onPressed: () => Get.to(const QRCodeScanner()),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 1, color: AppColors.primaryColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppSize.kRadius * 2),
                                  ),
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  minimumSize: const Size(48, 48),
                                  padding: const EdgeInsets.all(0),
                                ),
                                child: SvgPicture.asset(
                                  'assets/icons/scanner.svg',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                          ),
                        if (controller.role == UserRole.MEMBER)
                          const SizedBox(width: AppSize.kPadding / 2),
                        Expanded(
                          child: CustomButton(
                            text: 'register'.tr,
                            onPressed: controller.handleRegister,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSize.kPadding * 2)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
