import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_routes.dart';
import 'package:getx_app/views/notification/notification.controller.dart';

import '../../../resources/models/notification.model.dart';
import '../../../utils/string/string.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';

class NotificationItem extends StatelessWidget {
  NotificationItem({super.key, required this.notification});
  final NotificationModel notification;

  final NotificationController controller = Get.find();
  Future<void> onNavigate() async {
    switch (notification.type) {
      case "EVENT":
        Get.toNamed(AppRoutes.eventDetail,
            arguments: {"eventId": notification.screenId});
        break;
      case "VOTE":
        Get.toNamed(AppRoutes.voteDetail,
            arguments: {"voteId": notification.screenId});
        break;
      case "FEED":
        Get.toNamed(AppRoutes.feedDetail,
            arguments: {"feedId": notification.screenId});
        break;
      case "FUND":
        Get.toNamed(AppRoutes.fundDetail,
            arguments: {"fundId": notification.screenId});
        break;
      case "DEFAULT":
        Get.toNamed(AppRoutes.feedDetail,
            arguments: {"feedId": notification.screenId});
        break;
      default:
        Get.toNamed(AppRoutes.feedDetail,
            arguments: {"feedId": notification.screenId});
    }
    await controller.isReadNotification(notification);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSize.kPadding / 2,
        left: AppSize.kPadding,
        right: AppSize.kPadding,
      ),
      child: InkWell(
        onTap: () => onNavigate(),
        borderRadius: BorderRadius.circular(AppSize.kRadius),
        child: Container(
          width: Get.width - AppSize.kPadding * 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.kRadius),
            color: AppColors.textColor
                .withOpacity(notification.isRead == false ? 0.05 : 0.025),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: AppSize.kPadding / 2,
            horizontal: AppSize.kPadding / 2,
          ),
          child: Stack(
            children: [
              if (notification.isRead == false)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.kPadding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          formatDateTimeFromString(
                              notification.createdAt ?? ""),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(
                                  color: AppColors.textColor.withOpacity(0.5)),
                        ),
                        const Spacer(),
                        // IconButtonComponent(
                        //   iconPath: "assets/icons/more.svg",
                        //   onPressed: () {},
                        //   iconSize: 20.w,
                        //   iconPadding: 4,
                        // )
                      ],
                    ),
                    const SizedBox(height: AppSize.kPadding / 4),
                    SizedBox(
                      width: Get.width - AppSize.kPadding * 2,
                      child: Text(
                        "${notification.title}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      width: Get.width - AppSize.kPadding * 2,
                      child: Text(
                        "${notification.desc}",
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
      ),
    );
  }
}
