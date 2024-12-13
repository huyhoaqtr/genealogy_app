import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';

import '../../constants/app_colors.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'fund.controller.dart';
import 'view/create_fund.sheet.dart';
import 'view/fund.item.dart';

class FundScreen extends GetView<FundController> {
  FundScreen({super.key});

  final DashboardController dashboardController = Get.find();

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
      body: Stack(
        children: [
          Positioned.fill(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.getFunds();
              },
              child: Obx(() {
                final funds = controller.funds.value;

                if (funds.isEmpty) {
                  return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: Get.height * 0.5,
                          child: Center(
                            child: Text(
                              'Không có quỹ nào',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ]);
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: funds.length + 1, // +1 for spacing at the bottom
                  itemBuilder: (context, index) {
                    if (index == funds.length) {
                      return SizedBox(height: 40.h); // Spacing at the bottom
                    }
                    final fund = funds[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppSize.kPadding),
                      child: FundItem(fund: fund),
                    );
                  },
                );
              }),
            ),
          ),
          if (dashboardController.myInfo.value.role == 'LEADER' ||
              dashboardController.myInfo.value.role == 'ADMIN')
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
    );
  }
}
