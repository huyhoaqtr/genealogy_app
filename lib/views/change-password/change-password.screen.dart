import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/textfield.common.dart';
import 'change-password.controller.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Thay đổi mật khẩu"),
          leading: IconButtonComponent(
            iconPath: 'assets/icons/arrow-left.svg',
            onPressed: () => Get.back(),
          )),
      body: SizedBox(
        width: Get.width,
        child: Stack(
          children: [
            _buildMainContentView(context),
            _buildFooterButtonGroup(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContentView(BuildContext context) {
    return Positioned.fill(
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSize.kPadding),
            child: Column(children: [
              Obx(() => (TextFieldComponent(
                    controller: controller.oldPasswordController.value,
                    hintText: "Nhập mật khẩu hiện tại",
                    labelText: "Mật khẩu hiện tại",
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    errorText: controller.oldPasswordError.value.isNotEmpty
                        ? controller.oldPasswordError.value
                        : null,
                  ))),
              const SizedBox(height: AppSize.kPadding),
              Obx(() => (TextFieldComponent(
                    controller: controller.newPasswordController.value,
                    hintText: "Nhập mật khẩu mới",
                    labelText: "Mật khẩu mới",
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    errorText: controller.newPasswordError.value.isNotEmpty
                        ? controller.newPasswordError.value
                        : null,
                  ))),
              const SizedBox(height: AppSize.kPadding),
              Obx(() => (TextFieldComponent(
                    controller: controller.confirmPasswordController.value,
                    hintText: "Nhập mật lại khẩu mới",
                    labelText: "Xác nhận mật khẩu",
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    errorText: controller.confirmPasswordError.value.isNotEmpty
                        ? controller.confirmPasswordError.value
                        : null,
                  ))),
            ])));
  }

  Widget _buildFooterButtonGroup(BuildContext context) {
    return Positioned(
        bottom: AppSize.kPadding,
        left: AppSize.kPadding,
        right: AppSize.kPadding,
        child: CustomButton(
          text: "Cập nhât",
          onPressed: () => controller.changePassword(),
        ));
  }
}
