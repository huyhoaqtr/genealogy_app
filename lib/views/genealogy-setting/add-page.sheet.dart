import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:getx_app/resources/api/tribe.api.dart';
import 'package:getx_app/resources/models/genealogy.model.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:getx_app/views/genealogy/genealogy.controller.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/text_button.common.dart';
import '../../utils/widgets/textfield.common.dart';
import '../event/create_event.sheet.dart';

class AddPdfPageController extends GetxController {
  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> contentController = TextEditingController().obs;

  Rx<String> titleError = "".obs;

  final SheetMode sheetMode;
  final PageData? pageData;

  AddPdfPageController({required this.sheetMode, this.pageData});

  final LoadingController loadingController = Get.find();
  final GenealogyController genealogyController = Get.find();

  @override
  void onInit() {
    super.onInit();
    if (pageData != null) {
      titleController.value.text = pageData!.title ?? "";
      contentController.value.text = pageData!.text ?? "";
    }
  }

  bool validateFields() {
    bool isValid = true;

    if (titleController.value.text.trim().isEmpty) {
      titleError.value = 'Vui lòng nhập tiêu đề';
      isValid = false;
    } else {
      titleError.value = "";
    }

    return isValid;
  }

  Future<void> createNewPdfPage() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (validateFields()) {
      loadingController.show();
      final response = await TribeAPi().addPageDataToGenealogy(
        title: titleController.value.text,
        text: contentController.value.text,
        id: genealogyController.genealogyData.value.sId ?? "",
      );
      if (response.statusCode == 200) {
        genealogyController.genealogyData.value.data!.add(response.data!);
        genealogyController.genealogyData.refresh();
        await genealogyController.rerenderPdf();
        genealogyController.pdfData.refresh();
        Get.back();
      }

      loadingController.hide();
    }
  }

  Future<void> updatePdfPage() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (validateFields()) {
      loadingController.show();
      final response = await TribeAPi().updatePageDataToGenealogy(
        title: titleController.value.text,
        text: contentController.value.text,
        genealogyId: genealogyController.genealogyData.value.sId ?? "",
        pageDataId: pageData!.sId ?? "",
      );
      if (response.statusCode == 200) {
        final dataList = genealogyController.genealogyData.value.data!;
        final index =
            dataList.indexWhere((item) => item.sId == response.data!.sId);

        if (index != -1) {
          dataList[index] = response.data!;
        } else {
          dataList.add(response.data!);
        }
        genealogyController.genealogyData.refresh();
        await genealogyController.rerenderPdf();
        genealogyController.pdfData.refresh();
        Get.back();
      }

      loadingController.hide();
    }
  }
}

class AddPdfPageSheetUI extends GetView<AddPdfPageController> {
  const AddPdfPageSheetUI({super.key});

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
                              enabled: controller.sheetMode == SheetMode.ADD
                                  ? true
                                  : controller.pageData?.isDelete == true,
                              controller: controller.titleController.value,
                              hintText: "Nhập tiêu đề",
                              radius: AppSize.kRadius,
                              textInputAction: TextInputAction.next,
                              errorText: controller.titleError.value.isNotEmpty
                                  ? controller.titleError.value
                                  : null,
                            )),
                      ),
                      _buildSheetItem(
                        context,
                        "Nội dung",
                        Obx(() => TextFieldComponent(
                              controller: controller.contentController.value,
                              hintText: "Nhập nội dung",
                              radius: AppSize.kRadius,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              maxLines: 30,
                              minLines: 20,
                              maxLength: 10000,
                            )),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom + 45.h,
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
              text: controller.sheetMode == SheetMode.ADD ? "Xong" : "Cập nhật",
              onPressed: () => controller.sheetMode == SheetMode.ADD
                  ? controller.createNewPdfPage()
                  : controller.updatePdfPage(),
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
