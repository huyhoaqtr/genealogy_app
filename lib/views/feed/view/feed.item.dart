import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/common/avatar_image.dart';
import 'package:getx_app/utils/widgets/common/network_image.dart';
import 'package:getx_app/utils/widgets/dialog/dialog.helper.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';
import 'package:getx_app/views/feed/feed.controller.dart';
import 'package:getx_app/views/my-post/my-post.controller.dart';
import 'package:readmore/readmore.dart';

import '../../../constants/app_size.dart';
import '../../../resources/api/feed.api.dart';
import '../../../resources/models/feed.model.dart';
import '../../../utils/string/string.dart';
import '../../../utils/widgets/icon_button.common.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/widgets/overlay/image.overlay.dart';
import '../../event/create_event.sheet.dart';
import 'create_feed.sheet.dart';
import 'more_sheet.dart';

class FeedItemController extends GetxController {
  final Rx<Feed> feed;
  FeedItemController({required Feed initialFeed})
      : feed = Rx<Feed>(initialFeed);
  final DashboardController dashboardController = Get.find();
  final LoadingController loadingController = Get.find();

  Future<void> toggleLike(String feedId) async {
    if (feed.value.sId == null || feed.value.likes == null) {
      return;
    }

    if (feed.value.likes!.contains(dashboardController.myInfo.value.sId)) {
      feed.value.likes!.remove(dashboardController.myInfo.value.sId);
    } else {
      feed.value.likes!.add(dashboardController.myInfo.value.sId!);
    }
    feed.refresh();

    if (Get.isRegistered<FeedController>()) {
      final feedController = Get.find<FeedController>();
      feedController.feeds.refresh();
    }

    // Gọi API (nếu cần)
    await FeedApi().toggleLikeFeed(feedId: feedId);
  }

  bool isLikedFeed() {
    if (feed.value.sId == null || feed.value.likes == null) {
      return false;
    }
    return feed.value.likes!.contains(dashboardController.myInfo.value.sId);
  }

  Future<void> deleteFeed(String feedId) async {
    loadingController.show();
    try {
      final response = await FeedApi().deleteFeed(feedId: feedId);

      if (response.statusCode == 200) {
        if (Get.isRegistered<FeedController>()) {
          final feedController = Get.find<FeedController>();
          feedController.feeds.removeWhere((element) => element.sId == feedId);
          feedController.feeds.refresh();
        }
        if (Get.isRegistered<MyPostController>()) {
          final myPostController = Get.find<MyPostController>();
          myPostController.feeds
              .removeWhere((element) => element.sId == feedId);
          myPostController.feeds.refresh();
        }
        DialogHelper.showToast(
          "Xoá bài viết thành công",
          ToastType.success,
        );
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      loadingController.hide();
    }
  }
}

class FeedItem extends StatelessWidget {
  FeedItem({super.key, required this.isDetail, required this.controller});
  final bool isDetail;
  final FeedItemController controller;
  final Rx<OverlayEntry?> overlayEntry = Rx<OverlayEntry?>(null);
  final Rx<Offset> overlayPosition = Rx<Offset>(const Offset(0, 0));
  final Rx<Offset> initialPosition = Rx<Offset>(const Offset(0, 0));
  final DashboardController dashboardController = Get.find();

  void showOverlay(BuildContext context, String url) {
    final overlayState = Overlay.of(context);
    final AnimationController animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: Navigator.of(context),
    );

    final animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    overlayPosition.value = initialPosition.value;

    OverlayEntry entry = OverlayEntry(
      builder: (_) {
        return FadeTransition(
          opacity: animation,
          child: ImageOverlay(
            position: overlayPosition,
            initialPosition: initialPosition,
            url: url,
            onHideTooltip: () {
              animationController.reverse().then((_) => hideTooltip());
            },
          ),
        );
      },
    );

    overlayEntry.value = entry;
    overlayState.insert(entry);
    animationController.forward();
  }

  void hideTooltip() {
    final entry = overlayEntry.value;
    if (entry != null) {
      entry.remove();
      overlayEntry.value = null;
    }
  }

  void _showUpdatePostBottomSheet(BuildContext context) {
    Get.lazyPut(() => CreateFormController(
          sheetMode: SheetMode.EDIT,
          feed: controller.feed.value,
        ));
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(minWidth: Get.width),
      builder: (context) => const CreateFeedForm(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.delete<CreateFormController>();
      });
    });
  }

  void _showMoreBottomSheet(BuildContext context, bool isSameUser) {
    showModalBottomSheet(
      context: context,
      builder: (context) => FeedMoreBottomSheet(
        isSameUser: isSameUser,
        onDeleteFeed: () {
          Get.back();
          DialogHelper.showConfirmDialog(
            "Xác nhận",
            "Bạn có muốn xoá bài viết này?",
            onConfirm: () {
              controller.deleteFeed(controller.feed.value.sId!);
            },
          );
        },
        onEditFeed: () {
          Get.back();
          _showUpdatePostBottomSheet(context);
        },
        onReportFeed: () {
          Get.back();
          DialogHelper.showConfirmDialog(
            "Xác nhận",
            "Bạn có muốn báo cáo bài viết này?",
            onConfirm: () {
              DialogHelper.showToast(
                "Báo cáo thành công",
                ToastType.success,
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.kPadding,
        horizontal: AppSize.kPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isDetail)
            Obx(() => AvatarImage(
                  size: 32,
                  imageUrl: "${controller.feed.value.user?.info?.avatar}",
                )),
          if (!isDetail)
            const SizedBox(
              width: AppSize.kPadding / 2,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (isDetail)
                          Obx(() => AvatarImage(
                                size: 32,
                                imageUrl:
                                    "${controller.feed.value.user?.info?.avatar}",
                              )),
                        if (isDetail)
                          const SizedBox(
                            width: AppSize.kPadding / 2,
                          ),
                        Obx(() => Text(
                              "${controller.feed.value.user?.info?.fullName}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            )),
                        const SizedBox(width: AppSize.kPadding / 2),
                        Obx(() => Text(
                              formatDateTimeFromString(
                                  "${controller.feed.value.createdAt}"),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                      color:
                                          AppColors.textColor.withOpacity(0.5)),
                            )),
                      ],
                    ),
                    IconButtonComponent(
                      iconPath: 'assets/icons/more.svg',
                      iconPadding: 3,
                      onPressed: () => _showMoreBottomSheet(
                          context,
                          controller.feed.value.user?.sId ==
                              dashboardController.myInfo.value.sId),
                      iconSize: 20,
                    ),
                  ],
                ),
                if (controller.feed.value.content != null)
                  const SizedBox(height: AppSize.kPadding / 4),
                if (controller.feed.value.content != null)
                  Obx(() => ReadMoreText(
                        "${controller.feed.value.content}",
                        trimLines: 5,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Xem thêm',
                        trimExpandedText: 'Ẩn bớt',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                        ),
                        lessStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                color: AppColors.textColor.withOpacity(0.5)),
                        moreStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                color: AppColors.textColor.withOpacity(0.5)),
                      )),
                const SizedBox(height: AppSize.kPadding / 4),
                if (controller.feed.value.images!.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        spacing: AppSize.kPadding / 2,
                        children: [
                          ...controller.feed.value.images!.map(
                            (image) => GestureDetector(
                              onTap: () => showOverlay(context, image),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(AppSize.kRadius),
                                child: CustomNetworkImage(
                                  imageUrl: image,
                                  height: 200,
                                  width: 150,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: AppSize.kPadding / 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => IconButtonComponent(
                              iconPath: 'assets/icons/heart.svg',
                              iconColor: controller.isLikedFeed()
                                  ? AppColors.primaryColor
                                  : AppColors.textColor,
                              iconPadding: 4,
                              onPressed: () => controller
                                  .toggleLike(controller.feed.value.sId!),
                              iconSize: 24,
                            )),
                        Obx(() => Text(
                              formatNumberWithSuffix(
                                  controller.feed.value.likes!.length),
                              style: Theme.of(context).textTheme.labelSmall,
                            ))
                      ],
                    ),
                    const SizedBox(width: AppSize.kPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButtonComponent(
                          iconPath: 'assets/icons/comment.svg',
                          iconPadding: 4,
                          onPressed: () => isDetail
                              ? null
                              : Get.toNamed('/feed-detail', arguments: {
                                  'feed': controller.feed.toJson(),
                                }),
                          iconSize: 24,
                        ),
                        Text(
                          formatNumberWithSuffix(
                            controller.feed.value.commentCount,
                          ),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
