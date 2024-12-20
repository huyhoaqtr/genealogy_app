import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/api/tribe.api.dart';
import 'package:getx_app/resources/models/tribe.model.dart';
import 'package:getx_app/services/storage/storage_manager.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/text_button.common.dart';
import '../../utils/widgets/textfield.common.dart';

class UpdateTribeSheetController extends GetxController {
  final DashboardController dashboardController = Get.find();
  final LoadingController loadingController = Get.find();
  Rx<TextEditingController> tribeNameController = TextEditingController().obs;
  Rx<TextEditingController> addressController = TextEditingController().obs;
  Rx<TextEditingController> descController = TextEditingController().obs;

  RxString tribeNameError = "".obs;
  RxString addressError = "".obs;
  RxString descError = "".obs;

  @override
  void onInit() {
    super.onInit();

    if (dashboardController.tribe.value != null) {
      final TribeModel? tribe = dashboardController.tribe.value;
      tribeNameController.value.text = tribe?.name ?? "";
      descController.value.text = tribe?.description ?? "";
      addressController.value.text = tribe?.address ?? "";
    }
  }

  bool validateFields() {
    bool isValid = true;

    if (tribeNameController.value.text.trim().isEmpty) {
      tribeNameError.value = 'Tên gia tộc là bắt buộc';
      isValid = false;
    } else {
      tribeNameError.value = "";
    }

    if (descController.value.text.trim().isEmpty) {
      descError.value = 'Mô tả là bắt buộc';
      isValid = false;
    } else {
      descError.value = "";
    }

    if (addressController.value.text.trim().isEmpty) {
      addressError.value = "Vui lòng nhập địa chỉ";
      isValid = false;
    } else {
      addressError.value = "";
    }

    return isValid;
  }

  Future<void> updateTribe() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingController.show();
    if (validateFields()) {
      final response = await TribeAPi().updateTribe(
        tribeName: tribeNameController.value.text,
        desc: descController.value.text,
        address: addressController.value.text,
      );

      if (response.statusCode == 200) {
        dashboardController.tribe.value = response.data;
        await StorageManager.setTribe(response.data!);
        dashboardController.tribe.refresh();
        Get.back();
      }
    }
    loadingController.hide();
  }
}

class UpdateTribeSheetUI extends GetView<UpdateTribeSheetController> {
  const UpdateTribeSheetUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.85,
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
                              controller: controller.tribeNameController.value,
                              hintText: "Nhập tên gia tộc",
                              radius: AppSize.kRadius,
                              textInputAction: TextInputAction.next,
                              errorText:
                                  controller.tribeNameError.value.isNotEmpty
                                      ? controller.tribeNameError.value
                                      : null,
                            )),
                      ),
                      _buildSheetItem(
                        context,
                        "Địa chỉ",
                        Obx(() => TextFieldComponent(
                              controller: controller.addressController.value,
                              hintText: "Nhập địa chỉ gia tộc",
                              radius: AppSize.kRadius,
                              textInputAction: TextInputAction.next,
                              errorText:
                                  controller.addressError.value.isNotEmpty
                                      ? controller.addressError.value
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
                              maxLines: 15,
                              minLines: 5,
                              maxLength: 10000,
                              errorText: controller.descError.value.isNotEmpty
                                  ? controller.descError.value
                                  : null,
                            )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom + 40,
                      )
                    ])),
          )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 50,
                height: 5,
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
              text: "Cập nhật",
              onPressed: () => controller.updateTribe(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetItem(BuildContext context, String label, Widget child) {
    return Container(
      width: Get.width - AppSize.kPadding * 2,
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
            const SizedBox(height: AppSize.kPadding / 2),
            child,
          ]),
    );
  }
}
