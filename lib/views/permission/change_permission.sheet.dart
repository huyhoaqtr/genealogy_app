import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/string/string.dart';
import 'package:getx_app/utils/widgets/dialog/dialog.helper.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/text_button.common.dart';
import 'permission.item.dart';

class ChangePermissionSheet extends StatelessWidget {
  const ChangePermissionSheet({super.key, required this.controller});

  final PermissionItemController controller;

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
                            // Obx(() => _buildFilterItem(
                            //       context,
                            //       "Tộc trưởng",
                            //       () => controller.changePermission('LEADER'),
                            //       isSelected:
                            //           controller.permission.value == 'LEADER',
                            //     )),
                            Obx(() => _buildFilterItem(
                                  context,
                                  "Trưởng lão",
                                  () => controller.changePermission('ADMIN'),
                                  isSelected:
                                      controller.permission.value == 'ADMIN',
                                )),
                            Obx(() => _buildFilterItem(
                                  context,
                                  "Thành viên",
                                  () => controller.changePermission('MEMBER'),
                                  isSelected:
                                      controller.permission.value == 'MEMBER',
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
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: "Huỷ",
                    isOutlined: true,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(width: AppSize.kPadding / 2),
                Expanded(
                  child: CustomButton(
                    text: "Xong",
                    onPressed: () => {
                      Get.back(),
                      controller.isDone.value = true,
                      DialogHelper.showConfirmDialog(
                        "Xác nhận",
                        "Bạn chắc chắn thay đổi quyền của ${controller.user.info?.fullName} từ ${getRole(controller.user.role!)} sang ${getRole(controller.permission.value)}?",
                        onConfirm: () => controller.onChangePermission(),
                      )
                    },
                  ),
                ),
              ],
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
      borderRadius: BorderRadius.circular(AppSize.kRadius * 2),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSize.kPadding,
          horizontal: AppSize.kPadding * 3,
        ),
        margin: const EdgeInsets.only(bottom: AppSize.kPadding / 2),
        decoration: BoxDecoration(
          color:
              isSelected ? AppColors.primaryColor : AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
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
