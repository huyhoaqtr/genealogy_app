import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/string/string.dart';
import 'package:getx_app/utils/widgets/icon_button.common.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(AppSize.kRadius),
      child: Container(
        width: Get.width - AppSize.kPadding * 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.kRadius),
          color: AppColors.textColor.withOpacity(0.05),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppSize.kPadding / 2,
          horizontal: AppSize.kPadding / 2,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSize.kPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        formatDateTimeFromString("2023-01-01 00:00:00"),
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: AppColors.textColor.withOpacity(0.5)),
                      ),
                      const Spacer(),
                      IconButtonComponent(
                        iconPath: "assets/icons/more.svg",
                        onPressed: () {},
                        iconSize: 20.w,
                        iconPadding: 4,
                      )
                    ],
                  ),
                  SizedBox(
                    width: Get.width - AppSize.kPadding * 2,
                    child: Text(
                      "Notification title",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(
                    width: Get.width - AppSize.kPadding * 2,
                    child: Text(
                      "Notification description",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
