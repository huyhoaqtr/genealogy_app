import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/string/string.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';
import 'package:getx_app/views/feed-detail/feed.detail.controller.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';
import '../../../resources/api/feed.api.dart';
import '../../../resources/models/comment.model.dart';
import '../../../utils/widgets/icon_button.common.dart';

class CommentItemController extends GetxController {
  RxList<String> likes;

  CommentItemController({required List<String> likesData})
      : likes = RxList<String>(likesData);
  final FeedDetailController feedDetailController = Get.find();
  final DashboardController dashboardController = Get.find();

  Future<void> toggleLike(String commentId) async {
    if (likes.value.contains(dashboardController.myInfo.value.sId)) {
      likes.value.remove(dashboardController.myInfo.value.sId);
    } else {
      likes.value.add(dashboardController.myInfo.value.sId!);
    }
    likes.refresh();
    await FeedApi().toggleLikeComment(commentId: commentId);
  }

  bool isLikedComment() {
    return likes.value.contains(dashboardController.myInfo.value.sId);
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({super.key, required this.commentFeed, this.level = 1});

  final CommentFeed commentFeed;
  final int level;

  @override
  Widget build(BuildContext context) {
    final CommentItemController commentItemController = Get.put(
        CommentItemController(likesData: commentFeed.likes ?? []),
        tag: commentFeed.sId);
    final String parentFullName = commentItemController.feedDetailController
        .getCommentParentFullName(commentFeed.parent);
    return SizedBox(
      width: Get.width,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: AppSize.kPadding / 2,
              bottom: AppSize.kPadding / 2,
              left: level > 1 ? 38.w : AppSize.kPadding / 2,
              right: AppSize.kPadding / 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    backgroundColor: AppColors.primaryColor,
                    radius: 12.w,
                    backgroundImage: NetworkImage(
                      "${commentFeed.user?.info?.avatar}",
                    )),
                const SizedBox(
                  width: AppSize.kPadding / 2,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${commentFeed.user?.info?.fullName}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: AppSize.kPadding / 2),
                            Text(
                              formatRelativeOrAbsolute(
                                  "${commentFeed.createdAt}"),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall!
                                  .copyWith(
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSize.kPadding / 3),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                if (parentFullName != "")
                                  TextSpan(
                                    text: "@$parentFullName ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                // Nội dung bình luận
                                TextSpan(
                                  text: commentFeed.content,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(() => IconButtonComponent(
                                      iconColor:
                                          commentItemController.isLikedComment()
                                              ? AppColors.primaryColor
                                              : AppColors.textColor,
                                      iconPath: 'assets/icons/heart.svg',
                                      iconPadding: 3,
                                      onPressed: () => commentItemController
                                          .toggleLike(commentFeed.sId!),
                                      iconSize: 20,
                                    )),
                                Obx(() => Text(
                                      formatNumberWithSuffix(
                                          commentItemController.likes.length),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                    )),
                              ],
                            ),
                            const SizedBox(width: AppSize.kPadding / 2),
                            GestureDetector(
                              onTap: () => commentItemController
                                  .feedDetailController
                                  .onReplyTap(commentFeed),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const IconButtonComponent(
                                    iconPath: 'assets/icons/pen.svg',
                                    iconPadding: 3,
                                    iconSize: 20,
                                  ),
                                  Text(
                                    "Trả lời",
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Chỉ render replies nếu cấp độ <= 2
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (commentFeed.replies!.isNotEmpty)
            ...commentFeed.replies!.map((item) => CommentItem(
                  commentFeed: item,
                  level: level + 1, // Tăng cấp độ khi đệ quy
                ))
        ],
      ),
    );
  }
}
