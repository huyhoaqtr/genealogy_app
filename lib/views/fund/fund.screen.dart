import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';

import '../../constants/app_colors.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'fund.controller.dart';
import 'view/create_fund.sheet.dart';
import 'view/fund.item.dart';

class FundScreen extends GetView<FundController> {
  const FundScreen({super.key});

  void _showCreateNewFundBottomSheet() {
    Get.lazyPut(() => CreateFundController());
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => const CreateFundSheetUI(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.delete<CreateFundController>();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quỹ gia tộc'),
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
      ),
      body: SizedBox(
        width: Get.width,
        child: Stack(
          children: [
            Positioned.fill(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.getFunds();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: Obx(() => Wrap(
                          spacing: AppSize.kPadding,
                          direction: Axis.vertical,
                          children: [
                            if (controller.funds.value.isNotEmpty)
                              ...controller.funds.value
                                  .map((fund) => FundItem(fund: fund))
                            else
                              Container(
                                width: Get.width - AppSize.kPadding * 2,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSize.kPadding * 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.textColor.withOpacity(0.05),
                                  borderRadius:
                                      BorderRadius.circular(AppSize.kRadius),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Chưa có quỹ nào được tạo",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: AppColors.textColor
                                              .withOpacity(0.5)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            SizedBox(height: 40.h),
                          ],
                        )),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: AppSize.kPadding,
              left: 16,
              right: 16,
              child: CustomButton(
                text: "Tạo quỹ mới",
                onPressed: () => _showCreateNewFundBottomSheet(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
