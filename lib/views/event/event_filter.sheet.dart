import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/views/event/event.controller.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/text_button.common.dart';

class EventFilterComponent extends StatelessWidget {
  EventFilterComponent({super.key});

  final EventController eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.35,
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: AppSize.kPadding / 2,
                          alignment: WrapAlignment.center,
                          children: [
                            Obx(() => _buildFilterItem(
                                  context,
                                  "Tất cả",
                                  () => eventController
                                      .changeFilter(FilterStatus.all),
                                  isSelected:
                                      eventController.selectedFilter.value ==
                                          FilterStatus.all,
                                )),
                            Obx(() => _buildFilterItem(
                                  context,
                                  "Ngày hiện tại",
                                  () => eventController
                                      .changeFilter(FilterStatus.currentDay),
                                  isSelected:
                                      eventController.selectedFilter.value ==
                                          FilterStatus.currentDay,
                                )),
                            Obx(() => _buildFilterItem(
                                  context,
                                  "Trong tuần",
                                  () => eventController
                                      .changeFilter(FilterStatus.thisWeek),
                                  isSelected:
                                      eventController.selectedFilter.value ==
                                          FilterStatus.thisWeek,
                                )),
                            Obx(() => _buildFilterItem(
                                  context,
                                  "Trong tháng",
                                  () => eventController
                                      .changeFilter(FilterStatus.thisMonth),
                                  isSelected:
                                      eventController.selectedFilter.value ==
                                          FilterStatus.thisMonth,
                                )),
                            Obx(() => _buildFilterItem(
                                  context,
                                  "Tháng trước",
                                  () => eventController
                                      .changeFilter(FilterStatus.previousMonth),
                                  isSelected:
                                      eventController.selectedFilter.value ==
                                          FilterStatus.previousMonth,
                                )),
                            Obx(() => _buildFilterItem(
                                  context,
                                  "Tháng sau",
                                  () => eventController
                                      .changeFilter(FilterStatus.nextMonth),
                                  isSelected:
                                      eventController.selectedFilter.value ==
                                          FilterStatus.nextMonth,
                                )),
                          ],
                        )
                      ],
                    ))),
          ),
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
              text: "Xong",
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterItem(
      BuildContext context, String label, VoidCallback onTap,
      {bool isSelected = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.kRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSize.kPadding / 2,
          horizontal: AppSize.kPadding,
        ),
        margin: const EdgeInsets.only(bottom: AppSize.kPadding / 2),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primaryColor : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(AppSize.kRadius),
          border: Border.all(color: AppColors.primaryColor),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
