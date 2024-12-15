import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/icon_button.common.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';

class PasswordFieldController extends GetxController {
  // Dùng RxBool để theo dõi trạng thái của obscureText
  RxBool obscureText = true.obs;

  // Hàm để toggle trạng thái obscureText
  void toggleObscureText() {
    obscureText.value = !obscureText.value;
  }
}

class PasswordFieldComponent extends StatelessWidget {
  PasswordFieldComponent({
    super.key,
    required this.textEditingController,
    this.hintText,
    this.labelText,
    this.enabled = true,
    this.errorText,
    this.textInputAction = TextInputAction.done,
  });

  final TextEditingController textEditingController;
  final String? hintText;
  final String? labelText;
  final bool enabled;
  final String? errorText;
  final TextInputAction textInputAction;

  // Khởi tạo controller cho PasswordFieldComponent mỗi lần gọi widget

  @override
  Widget build(BuildContext context) {
    Get.create(() => PasswordFieldController());
    PasswordFieldController controller = Get.find<PasswordFieldController>();
    return Obx(() {
      return TextField(
        controller: textEditingController,
        obscureText: controller.obscureText.value,
        enabled: enabled,
        cursorColor: AppColors.primaryColor,
        textInputAction: textInputAction,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          errorText: errorText,
          errorStyle: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: AppColors.errorColor,
              ),
          labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(),
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.textColor.withOpacity(0.5),
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.kRadius * 2),
            borderSide: BorderSide(
              color: enabled ? AppColors.primaryColor : AppColors.borderColor,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.kRadius * 2),
            borderSide: BorderSide(
              color: AppColors.errorColor,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.kRadius * 2),
            borderSide: BorderSide(
              color: AppColors.errorColor,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.kRadius * 2),
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 1.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSize.kRadius * 2),
            borderSide: BorderSide(
              color: AppColors.borderColor,
              width: 1.0,
            ),
          ),
          suffixIcon: IconButtonComponent(
            iconPath: controller.obscureText.value
                ? "assets/icons/eye.svg"
                : "assets/icons/eye-slash.svg",
            onPressed: controller.toggleObscureText,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSize.kPadding,
            vertical: AppSize.kPadding / 2,
          ),
        ),
      );
    });
  }
}
