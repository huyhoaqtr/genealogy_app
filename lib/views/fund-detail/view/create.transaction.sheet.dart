import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/string/string.dart';
import 'package:getx_app/utils/widgets/dialog/dialog.helper.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:getx_app/views/fund-detail/fund-detail.controller.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/widgets/text_button.common.dart';
import '../../../utils/widgets/textfield.common.dart';
import '../fund-detail.screen.dart';

class CreateTransactionController extends GetxController {
  final TransactionType transactionType;
  Rx<TextEditingController> amountController = TextEditingController().obs;
  Rx<TextEditingController> contentController = TextEditingController().obs;

  CreateTransactionController({required this.transactionType});
  final FundDetailController fundDetailController = Get.find();
  final LoadingController loadingController = Get.find();

  RxString contentError = "".obs;
  RxString amountError = "".obs;

  bool validateFields() {
    bool isValid = true;
    if (amountController.value.text.isEmpty ||
        double.tryParse(amountController.value.text) != null &&
            double.tryParse(amountController.value.text)! <= 0) {
      isValid = false;
      amountError.value = "Vui lòng nhập số tiền";
    } else {
      amountError.value = "";
    }
    if (contentController.value.text.isEmpty) {
      isValid = false;
      contentError.value = "Vui lòng nhập nội dung giao dịch";
    } else {
      contentError.value = "";
    }
    return isValid;
  }

  @override
  void onInit() {
    super.onInit();
    amountController.value.text = "0";
  }

  void createTransaction() {
    if (validateFields()) {
      DialogHelper.showConfirmDialog(
        "Xác nhận",
        "Bạn có muốn tạo giao dịch ${transactionType == TransactionType.DEPOSIT ? "NẠP QUỸ" : "CHI QUỸ"} với số tiền là ${formatCurrency(double.tryParse(amountController.value.text) ?? 0)} ?",
        onConfirm: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          loadingController.show();
          await fundDetailController.createTransaction(
            type: transactionType.name,
            desc: contentController.value.text,
            amount: amountController.value.text,
          );
          Get.back();

          loadingController.hide();
        },
      );
    }
  }

  void cancelSheet() {
    FocusManager.instance.primaryFocus?.unfocus();
    //show dialog
    DialogHelper.showConfirmDialog(
      "Xác nhận",
      "Giao dịch chưa được tạo, bạn có chắc muốn thoát không?",
      onConfirm: () {
        Get.back();
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    amountController.close();
    contentController.close();
  }
}

class CreateTransactionSheetUI extends GetView<CreateTransactionController> {
  const CreateTransactionSheetUI({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDeposit = controller.transactionType == TransactionType.DEPOSIT;
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
                      SizedBox(
                        width: Get.width - AppSize.kPadding * 2,
                        child: Row(
                          children: [
                            Text("Loại giao dịch:",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                    )),
                            const Spacer(),
                            Text(
                              isDeposit ? "Nạp quỹ" : "Chi quỹ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isDeposit ? Colors.green : Colors.red,
                                  ),
                            )
                          ],
                        ),
                      ),
                      _buildSheetItem(
                        context,
                        "Nhập số tiền",
                        Obx(() => TextFieldComponent(
                              controller: controller.amountController.value,
                              hintText: "Nhập số tiền",
                              radius: AppSize.kRadius,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              errorText: controller.amountError.value.isNotEmpty
                                  ? controller.amountError.value
                                  : null,
                            )),
                      ),
                      _buildSheetItem(
                        context,
                        "Nhập nội dung",
                        Obx(() => TextFieldComponent(
                              controller: controller.contentController.value,
                              hintText: "Nhập nội dung",
                              radius: AppSize.kRadius,
                              textInputAction: TextInputAction.newline,
                              keyboardType: TextInputType.multiline,
                              maxLines: 3,
                              minLines: 1,
                              maxLength: 300,
                              errorText:
                                  controller.contentError.value.isNotEmpty
                                      ? controller.contentError.value
                                      : null,
                            )),
                      ),
                      Container(
                        width: Get.width - AppSize.kPadding * 2,
                        margin: const EdgeInsets.only(bottom: AppSize.kPadding),
                        child: Text(
                            "LƯU Ý: Sau khi tạo giao dịch thành công sẽ không thể CHỈNH SỬA hoặc XOÁ, hãy chắc chắn nhập đúng nội dung.",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
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
              onPressed: () => controller.createTransaction(),
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
