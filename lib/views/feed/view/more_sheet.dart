import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';

class FeedMoreBottomSheet extends StatelessWidget {
  const FeedMoreBottomSheet(
      {super.key,
      required this.isSameUser,
      required this.onEditFeed,
      required this.onReportFeed,
      required this.onDeleteFeed});
  final bool isSameUser;
  final VoidCallback onEditFeed;
  final VoidCallback onDeleteFeed;
  final VoidCallback onReportFeed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(
        top: AppSize.kPadding / 2,
        bottom: AppSize.kPadding,
        left: AppSize.kPadding,
        right: AppSize.kPadding,
      ),
      child: Stack(
        children: [
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
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSize.kPadding),
              if (!isSameUser)
                InkWell(
                  onTap: onReportFeed,
                  borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
                  child: Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(AppSize.kPadding),
                    child: Text(
                      'Báo cáo',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              if (isSameUser)
                InkWell(
                  onTap: onEditFeed,
                  borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
                  child: Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(AppSize.kPadding),
                    child: Text(
                      'Chỉnh sửa bài viết',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              if (isSameUser)
                InkWell(
                  borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
                  onTap: onDeleteFeed,
                  child: Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(AppSize.kPadding),
                    child: Text(
                      'Xoá bài viết',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ),
                ),
              const SizedBox(height: AppSize.kPadding / 2),
            ],
          ),
        ],
      ),
    );
  }
}
