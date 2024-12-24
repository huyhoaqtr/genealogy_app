import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/resources/models/vote.model.dart';
import 'package:getx_app/utils/widgets/icon_button.common.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:getx_app/views/family_tree/view/add_user.controller.dart';
import 'package:getx_app/views/vote/vote.controller.dart';

import '../../../constants/app_colors.dart';
import '../../../resources/api/vote.api.dart';
import '../../../utils/widgets/dialog/dialog.helper.dart';
import '../../../utils/widgets/text_button.common.dart';
import '../../../utils/widgets/textfield.common.dart';

class CreateVoteController extends GetxController {
  final Rx<TextEditingController> titleController = TextEditingController().obs;
  final Rx<TextEditingController> descController = TextEditingController().obs;
  RxList<String> options = <String>[].obs;

  final VoteController voteController = Get.find<VoteController>();
  final LoadingController loadingController = Get.find<LoadingController>();

  RxString titleError = "".obs;
  RxString descError = "".obs;
  RxString optionError = "".obs;
  RxList<String> optionsError = <String>[].obs;

  final SheetMode sheetMode;
  final VoteSession? voteSession;

  CreateVoteController({required this.sheetMode, this.voteSession});

  @override
  void onInit() {
    super.onInit();
    if (sheetMode == SheetMode.EDIT) {
      titleController.value.text = voteSession!.title!;
      descController.value.text = voteSession!.desc!;
    }
  }

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

    if (sheetMode == SheetMode.ADD) {
      if (options.isEmpty) {
        optionError.value = "Không thể bỏ trống";
        isValid = false;
      } else {
        optionError.value = "";
      }

      for (int i = 0; i < options.length; i++) {
        if (options[i].trim().isEmpty) {
          optionsError[i] = "Không thể bỏ trống";
          isValid = false;
        } else {
          optionsError[i] = "";
        }
      }
    }

    return isValid;
  }

  void addOption() {
    options.add("");
    optionsError.add("");
  }

  void removeOption(int index) {
    options.removeAt(index);
    optionsError.removeAt(index);
  }

  void changeInputOption(int index, String value) {
    options[index] = value;
  }

  Future<void> createVote() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      if (validateFields()) {
        loadingController.show();
        final response = await VoteApi().createVoteSession(
          title: titleController.value.text,
          desc: descController.value.text,
          options: options,
        );
        if (response.statusCode == 201) {
          Get.back();
          voteController.voteSessions.insert(0, response.data!);
          DialogHelper.showToast(
            "Tạo biểu quyết thành công",
            ToastType.success,
          );
        }
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      loadingController.hide();
    }
  }

  Future<void> updateVoteSession() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      if (validateFields()) {
        loadingController.show();
        final response = await VoteApi().updateVoteSession(
          id: voteSession!.sId!,
          title: titleController.value.text,
          desc: descController.value.text,
        );
        if (response.statusCode == 200) {
          Get.back();
          int index = voteController.voteSessions.indexWhere(
            (session) => session.sId == voteSession!.sId!,
          );

          if (index != -1) {
            voteController.voteSessions[index] = response.data!;
          }
          DialogHelper.showToast(
            "Cập nhật thành công",
            ToastType.success,
          );
        }
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      loadingController.hide();
    }
  }
}

class CreateVoteSheetUI extends GetView<CreateVoteController> {
  const CreateVoteSheetUI({super.key});

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
                              hintText: "Nhập tiêu biểu quyết",
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
                      if (controller.sheetMode == SheetMode.ADD)
                        _buildOptionInput(context),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom + 45,
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
              text: controller.sheetMode == SheetMode.ADD ? "Xong" : "Cập nhật",
              onPressed: () => controller.sheetMode == SheetMode.ADD
                  ? controller.createVote()
                  : controller.updateVoteSession(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionInput(BuildContext context) {
    return SizedBox(
      width: Get.width - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "Thêm lựa chọn",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              IconButtonComponent(
                iconPath: "assets/icons/element-plus.svg",
                onPressed: () => controller.addOption(),
                iconSize: 32,
                iconPadding: 6,
              ),
            ],
          ),
          Obx(() => controller.optionError.value.isNotEmpty
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
                  child: Text(controller.optionError.value,
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.errorColor,
                          )),
                )
              : Container()),
          const SizedBox(height: AppSize.kPadding / 2),
          Obx(() => Wrap(
                spacing: AppSize.kPadding / 2,
                direction: Axis.vertical,
                children: controller.options
                    .asMap()
                    .entries
                    .map(
                      (entry) => SizedBox(
                        width: Get.width - AppSize.kPadding * 2,
                        child: TextFieldComponent(
                          onChanged: (value) =>
                              controller.changeInputOption(entry.key, value),
                          hintText: "Nhập nội dung",
                          radius: AppSize.kRadius,
                          textInputAction: TextInputAction.next,
                          errorText:
                              controller.optionsError[entry.key].isNotEmpty
                                  ? controller.optionsError[entry.key]
                                  : null,
                          suffixIcon: SizedBox(
                            height: 18,
                            width: 18,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  "assets/icons/minus-square.svg",
                                  height: 18,
                                  width: 18,
                                  fit: BoxFit.scaleDown,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.textColor.withOpacity(0.6),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                onPressed: () =>
                                    controller.removeOption(entry.key),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ))
        ],
      ),
    );
  }

  Widget _buildSheetItem(BuildContext context, String label, Widget child) {
    return Container(
      width: Get.width - 32,
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
            const SizedBox(height: 8),
            child,
          ]),
    );
  }
}
