import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';

class PermissionSheetComponent extends StatelessWidget {
  const PermissionSheetComponent({super.key, required this.onChangePermission});

  final VoidCallback onChangePermission;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: 160,
      padding: const EdgeInsets.only(top: AppSize.kPadding / 2),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSize.kPadding),
                  InkWell(
                    borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
                    child: Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(AppSize.kPadding),
                      child: Text(
                        'Thay đổi vai trò',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    onTap: () => {
                      Get.back(),
                      onChangePermission(),
                    },
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
                    child: Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(AppSize.kPadding),
                      child: Text(
                        'Huỷ',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ),
                    onTap: () => Get.back(),
                  ),
                  const SizedBox(height: AppSize.kPadding / 2),
                ],
              ),
            ),
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
        ],
      ),
    );
  }
}
