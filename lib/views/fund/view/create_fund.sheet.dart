import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:getx_app/views/fund/fund.controller.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/widgets/text_button.common.dart';
import '../../../utils/widgets/textfield.common.dart';

class CreateFundController extends GetxController {
  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> descController = TextEditingController().obs;
  Rx<TextEditingController> amountController = TextEditingController().obs;

  final LoadingController loadingController = Get.find();
  final FundController fundController = Get.find();

  RxString titleError = "".obs;
  RxString descError = "".obs;
  RxString amountError = "".obs;

  bool validateFields() {
    bool isValid = true;

    if (titleController.value.text.trim().isEmpty) {
      titleError.value = 'Tiêu đề là bắt buộc';
      isValid = false;
    } else {
      titleError.value = "";
    }

    if (descController.value.text.trim().isEmpty) {
      descError.value = 'Mô tả là bắt buộc';
      isValid = false;
    } else {
      descError.value = "";
    }

    if (amountController.value.text.trim().isEmpty) {
      amountError.value = "Vui lòng nhập số tiền";
      isValid = false;
    } else {
      amountError.value = "";
    }

    return isValid;
  }

  Future<void> createFund() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (validateFields()) {
      loadingController.show();
      await fundController.createFund(
        title: titleController.value.text,
        desc: descController.value.text,
        amount: amountController.value.text,
      );
      Get.back();
      loadingController.hide();
    }
  }
}

class CreateFundSheetUI extends GetView<CreateFundController> {
  const CreateFundSheetUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.75,
      padding: const EdgeInsets.only(top: AppSize.kPadding / 2),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
              child: SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                child: Wrap(
                    direction: Axis.vertical,
                    spacing: AppSize.kPadding / 2,
                    children: [
                      _buildSheetItem(
                        context,
                        "Tiêu đề",
                        Obx(() => TextFieldComponent(
                              controller: controller.titleController.value,
                              hintText: "Nhập tiêu đề quỹ",
                              radius: AppSize.kRadius,
                              textInputAction: TextInputAction.next,
                              errorText: controller.titleError.value.isNotEmpty
                                  ? controller.titleError.value
                                  : null,
                            )),
                      ),
                      _buildSheetItem(
                        context,
                        "Mô tả",
                        Obx(() => TextFieldComponent(
                              controller: controller.descController.value,
                              hintText: "Nhập mô tả",
                              radius: AppSize.kRadius,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              maxLines: 5,
                              minLines: 2,
                              maxLength: 500,
                              errorText: controller.descError.value.isNotEmpty
                                  ? controller.descError.value
                                  : null,
                            )),
                      ),
                      _buildSheetItem(
                        context,
                        "Số tiền thu",
                        Obx(() => TextFieldComponent(
                              controller: controller.amountController.value,
                              hintText: "Nhập số tiền thu",
                              radius: AppSize.kRadius,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              errorText: controller.amountError.value.isNotEmpty
                                  ? controller.amountError.value
                                  : null,
                            )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom + 40.h,
                      )
                    ])),
          )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 50.w,
                height: 5.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).viewInsets.bottom +
                AppSize.kPadding * 1.5,
            left: 16,
            right: 16,
            child: CustomButton(
              text: "Xong",
              onPressed: () => controller.createFund(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetItem(BuildContext context, String label, Widget child) {
    return Container(
      width: Get.width - 32.w,
      margin: const EdgeInsets.only(bottom: AppSize.kPadding / 2),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 8.h),
            child,
          ]),
    );
  }
}
