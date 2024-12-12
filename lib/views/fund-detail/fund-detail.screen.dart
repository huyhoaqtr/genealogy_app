import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';

import '../../constants/app_colors.dart';
import '../../utils/string/string.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'fund-detail.controller.dart';
import 'view/create.transaction.sheet.dart';
import 'view/fund.detail.item.dart';

enum TransactionType {
  DEPOSIT,
  WITHDRAW,
}

class FundDetailScreen extends GetView<FundDetailController> {
  const FundDetailScreen({super.key});

  void _showCreateNewTransactionBottomSheet(TransactionType type) {
    Get.lazyPut(() => CreateTransactionController(transactionType: type));
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => const CreateTransactionSheetUI(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        Get.delete<CreateTransactionController>();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết'),
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
      ),
      body: SizedBox(
        width: Get.width,
        child: Stack(
          children: [
            _buildMainContentView(context),
            _buildFooterButtonGroup(),
          ],
        ),
      ),
    );
  }

  Positioned _buildMainContentView(BuildContext context) {
    return Positioned.fill(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding / 2),
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: Get.width,
          child: Obx(
            () => controller.fund.value.sId != null
                ? Wrap(
                    spacing: AppSize.kPadding,
                    direction: Axis.vertical,
                    children: [
                      _buildHeaderContentView(context),
                      _buildFundDetailContentView(context),
                      _buildTransactionListView(context),
                      SizedBox(height: 50.h),
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderContentView(BuildContext context) {
    return Container(
      width: Get.width - AppSize.kPadding,
      padding: const EdgeInsets.all(AppSize.kPadding),
      decoration: BoxDecoration(
        color: AppColors.textColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSize.kRadius),
      ),
      child: Obx(() => Wrap(
            direction: Axis.vertical,
            spacing: AppSize.kPadding / 4,
            children: [
              SizedBox(
                width: Get.width - AppSize.kPadding * 4,
                child: Text(
                  "${controller.fund.value.title}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(
                width: Get.width - AppSize.kPadding * 4,
                child: Text(
                  "${controller.fund.value.desc}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Text(
                "Mục tiêu: ${formatCurrency(controller.fund.value.amount)}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                "Ngày tạo: ${formatDateTimeFromString(controller.fund.value.createdAt!)}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                "Người tạo: ${controller.fund.value.creator?.info?.fullName}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          )),
    );
  }

  Widget _buildFundDetailContentView(BuildContext context) {
    return Container(
      width: Get.width - AppSize.kPadding,
      padding: const EdgeInsets.all(AppSize.kPadding),
      decoration: BoxDecoration(
        color: AppColors.textColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSize.kRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: AppColors.textColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: Wrap(
                direction: Axis.vertical,
                spacing: AppSize.kPadding / 4,
                children: [
                  Text(
                    "Số dư quỹ:",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "Tổng đã thu:",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    "Tổng đã chi:",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() => Wrap(
                  direction: Axis.vertical,
                  spacing: AppSize.kPadding / 4,
                  runAlignment: WrapAlignment.end,
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: [
                    Text(
                      formatCurrency(
                        controller.fund.value.totalDeposit! -
                            controller.fund.value.totalWithdraw!,
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      formatCurrency(controller.fund.value.totalDeposit),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      formatCurrency(controller.fund.value.totalWithdraw),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionListView(BuildContext context) {
    return Container(
      width: Get.width - AppSize.kPadding,
      padding: const EdgeInsets.all(AppSize.kPadding / 2),
      decoration: BoxDecoration(
        color: AppColors.textColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSize.kRadius),
      ),
      child: Obx(() => Wrap(
            spacing: AppSize.kPadding / 4,
            direction: Axis.vertical,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: AppSize.kPadding / 2),
                child: Text(
                  "Lịch sử hoạt động",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              if (controller.fund.value.transactions != null &&
                  controller.fund.value.transactions!.isNotEmpty)
                ...controller.fund.value.transactions!.reversed.map(
                  (item) => TransactionItem(transaction: item),
                )
              else
                Container(
                  width: Get.width - AppSize.kPadding * 2,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSize.kPadding * 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.textColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(AppSize.kRadius),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Không có lịch sử hoạt động",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.textColor.withOpacity(0.5)),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          )),
    );
  }

  Positioned _buildFooterButtonGroup() {
    return Positioned(
      bottom: AppSize.kPadding,
      left: 16,
      right: 16,
      child: Row(
        children: [
          Expanded(
              child: CustomButton(
            text: "Chi",
            isOutlined: true,
            onPressed: () =>
                _showCreateNewTransactionBottomSheet(TransactionType.WITHDRAW),
          )),
          const SizedBox(width: AppSize.kPadding / 2),
          Expanded(
              child: CustomButton(
            text: "Thu",
            onPressed: () =>
                _showCreateNewTransactionBottomSheet(TransactionType.DEPOSIT),
          ))
        ],
      ),
    );
  }
}
