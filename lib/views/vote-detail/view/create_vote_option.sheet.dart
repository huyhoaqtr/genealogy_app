import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/resources/models/vote.model.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:getx_app/views/vote-detail/vote-detail.controller.dart';
import 'package:getx_app/views/vote/vote.controller.dart';

import '../../../constants/app_colors.dart';
import '../../../resources/api/vote.api.dart';
import '../../../utils/widgets/dialog/dialog.helper.dart';
import '../../../utils/widgets/text_button.common.dart';
import '../../../utils/widgets/textfield.common.dart';

class CreateVoteOptionController extends GetxController {
  Rx<TextEditingController> optionController = TextEditingController().obs;
  RxString optionError = "".obs;
  final LoadingController loadingController = Get.find();

  final VoteSession voteSession;

  CreateVoteOptionController({required this.voteSession});

  bool validateFields() {
    bool isValid = true;

    if (optionController.value.text.trim().isEmpty) {
      optionError.value = 'Nội dung không được bỏ trống';
      isValid = false;
    } else {
      optionError.value = "";
    }

    return isValid;
  }

  Future<void> addOptionToVote() async {
    loadingController.show();

    try {
      if (validateFields()) {
        final response = await VoteApi().addOptionToVote(
          id: voteSession.sId!,
          optionString: optionController.value.text,
        );
        if (response.statusCode == 200) {
          final VoteController voteController = Get.find();

          final index = voteController.voteSessions
              .indexWhere((item) => item.sId == voteSession.sId);
          if (index != -1) {
            voteController.voteSessions[index] = response.data!;
          }

          final VoteDetailController voteDetailController = Get.find();
          voteDetailController.voteSession.value = response.data!;

          DialogHelper.showToast(
            "Thêm ý kiến thành công",
            ToastType.success,
          );
          Get.back();
        }
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      loadingController.hide();
    }
  }
}

class CreateVoteOptionSheetUI extends GetView<CreateVoteOptionController> {
  const CreateVoteOptionSheetUI({super.key});

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
                        "Ý kiến của bạn",
                        Obx(() => TextFieldComponent(
                              controller: controller.optionController.value,
                              hintText: "Nhập ý kiến của bạn",
                              radius: AppSize.kRadius,
                              textInputAction: TextInputAction.next,
                              errorText: controller.optionError.value.isNotEmpty
                                  ? controller.optionError.value
                                  : null,
                            )),
                      ),
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
              text: "Thêm ý kiến",
              onPressed: () => controller.addOptionToVote(),
            ),
          ),
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
