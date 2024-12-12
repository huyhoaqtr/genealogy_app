import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/icon_button.common.dart';

import '../../constants/app_colors.dart';
import '../../utils/widgets/passwordfield.common.dart';
import '../../utils/widgets/text_button.common.dart';
import '../../utils/widgets/textfield.common.dart';
import 'login.controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200.w,
                  width: 200.w,
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    semanticsLabel: 'App Logo',
                  ),
                ),
                Obx(() => (TextFieldComponent(
                      controller: controller.phoneNumberController,
                      hintText: 'enterPhoneNumber'.tr,
                      labelText: 'phoneNumber'.tr,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      errorText: controller.phoneNumberError.value.isNotEmpty
                          ? controller.phoneNumberError.value
                          : null,
                    ))),
                SizedBox(height: 16.h),
                Obx(() => (PasswordFieldComponent(
                      textEditingController: controller.passwordController,
                      hintText: 'enterPassword'.tr,
                      labelText: 'password'.tr,
                      textInputAction: TextInputAction.done,
                      errorText: controller.passwordError.value.isNotEmpty
                          ? controller.passwordError.value
                          : null,
                    ))),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'forgotPassword'.tr,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                CustomButton(
                  text: 'login'.tr,
                  onPressed: controller.handleLogin,
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
