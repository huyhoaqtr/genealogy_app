import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/progress_indicator.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';
import 'package:getx_app/views/feed-detail/feed.detail.controller.dart';
import 'package:getx_app/views/feed/view/feed.item.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'view/comment.item.dart';

class FeedDetailScreen extends GetView<FeedDetailController> {
  FeedDetailScreen({super.key});

  final DashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SizedBox(
            width: Get.width,
            child: Stack(
              children: [
                Positioned.fill(child: Obx(() {
                  if (controller.feed.value.sId == null) {
                    return const ProgressIndicatorComponent();
                  }
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Obx(() => controller.feed.value.sId != null
                            ? FeedItem(
                                isDetail: true,
                                controller: FeedItemController(
                                  initialFeed: controller.feed.value,
                                ),
                              )
                            : const SizedBox()),
                        Obx(() {
                          if (controller.feed.value.sId == null) {
                            return const SizedBox();
                          }
                          return Column(
                            children: [
                              _buildCommentContentView(context),
                              ...controller.comments.map((item) => CommentItem(
                                    commentFeed: item,
                                  ))
                            ],
                          );
                        }),
                        const SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  );
                })),
                _buildCommentInputView(context),
              ],
            )),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Chi tiết'),
      leading: IconButtonComponent(
        iconPath: 'assets/icons/arrow-left.svg',
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildCommentContentView(BuildContext context) {
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
      child: const Text("Bình luận"),
    );
  }

  Widget _buildCommentInputView(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: AppColors.backgroundColor,
        padding: const EdgeInsets.only(
          left: AppSize.kPadding,
          right: AppSize.kPadding,
          bottom: AppSize.kPadding / 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => controller.parentComment.value != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: AppSize.kPadding / 2,
                      right: AppSize.kPadding / 2,
                      bottom: AppSize.kPadding / 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: 'Đang trả lời',
                              style: Theme.of(context).textTheme.labelSmall,
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        " ${controller.parentComment.value!.user!.info!.fullName}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(fontWeight: FontWeight.w600))
                              ]),
                        ),
                        GestureDetector(
                          onTap: () => controller.onRemoveReplyTap(),
                          child: Text(
                            "Huỷ",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  )
                : Container()),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(
                vertical: AppSize.kPadding / 4,
                horizontal: AppSize.kPadding / 2,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.075),
                borderRadius: BorderRadius.circular(AppSize.kRadius * 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    radius: 14,
                    backgroundImage: NetworkImage(
                      "${dashboardController.myInfo.value.info?.avatar}",
                    ),
                  ),
                  const SizedBox(width: AppSize.kPadding / 2),
                  Expanded(
                    child: TextField(
                      focusNode: controller.commentInputFocusNode.value,
                      controller: controller.commentInputController.value,
                      cursorColor: AppColors.primaryColor,
                      cursorHeight: 15,
                      textInputAction: TextInputAction.done,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                      decoration: InputDecoration(
                        hintText: "Viết bình luận...",
                        hintStyle:
                            Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: AppColors.textColor.withOpacity(0.75),
                                ),
                        labelStyle:
                            Theme.of(context).textTheme.bodySmall!.copyWith(),
                        suffixIcon: IconButtonComponent(
                          iconPath: 'assets/icons/send.svg',
                          iconPadding: 4,
                          onPressed: () => controller.onSendCommentTap(),
                          iconSize: 20,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppSize.kPadding,
                        ),
                        border: InputBorder.none,
                      ),
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
