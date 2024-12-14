import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:getx_app/constants/app_colors.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/common/avatar_image.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';

import '../../../utils/string/string.dart';
import '../model/conversation.model.dart';
import 'conversation_item.controller.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    super.key,
    required this.conversation,
    required this.isSameUser,
  });

  final Conversation conversation;
  final bool isSameUser;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConversationItemController>(
      init: ConversationItemController(),
      initState: (_) {},
      builder: (controller) {
        String? senderName =
            "${conversation.lastMessage?.sender?.info?.fullName}: ";
        Info? info;

        if (conversation.type != 'GROUP') {
          info = conversation.members
                      ?.where(
                          (element) => element.sId != controller.user.value.sId)
                      .isNotEmpty ==
                  true
              ? conversation.members
                  ?.firstWhere(
                      (element) => element.sId != controller.user.value.sId)
                  .info
              : conversation.members?.first.info;
        }
        return InkWell(
            onTap: () => Get.toNamed("/message-detail", arguments: {
                  "conversation": conversation.toJson(),
                  "receiver": conversation.type == "SINGLE"
                      ? conversation.members
                                  ?.where((element) =>
                                      element.sId != controller.user.value.sId)
                                  .isNotEmpty ==
                              true
                          ? conversation.members
                              ?.where((item) =>
                                  item.sId != controller.user.value.sId)
                              .first
                              .toJson()
                          : conversation.members?.first.toJson()
                      : null
                }),
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.only(left: AppSize.kPadding),
              child: Slidable(
                key: ValueKey(conversation.sId),
                // endActionPane: ActionPane(
                //   motion: const ScrollMotion(),
                //   dismissible: DismissiblePane(onDismissed: () {}),
                //   children: [
                //     SlidableAction(
                //       onPressed: (context) {},
                //       backgroundColor: Colors.red,
                //       foregroundColor: Colors.white,
                //       icon: Icons.delete,
                //       label: 'Delete',
                //     ),
                //     SlidableAction(
                //       onPressed: (context) {},
                //       backgroundColor: Colors.blue,
                //       foregroundColor: Colors.white,
                //       icon: Icons.share,
                //       label: 'Share',
                //     ),
                //   ],
                // ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: AppSize.kPadding / 2,
                    bottom: AppSize.kPadding / 2,
                    right: AppSize.kPadding,
                  ),
                  child: Row(
                    children: [
                      _buildStatusAvatar(controller),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conversation.type == "GROUP"
                                  ? "Gia tộc"
                                  : info?.fullName ?? "",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            if (conversation.lastMessage != null)
                              _buildLastMessageText(senderName, context),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }

  CircleAvatar _buildStatusAvatar(ConversationItemController controller) {
    return CircleAvatar(
      radius: 24,
      child: SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            children: [
              Positioned.fill(
                child: AvatarImage(
                  imageUrl: conversation.members?.first.info?.avatar ?? "",
                ),
              ),
              if (conversation.type == "SINGLE")
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: GetBuilder<DashboardController>(
                    init: DashboardController(),
                    builder: (dashboardController) {
                      String? memberId = conversation.members
                                  ?.where((element) =>
                                      element.sId != controller.user.value.sId)
                                  .isNotEmpty ==
                              true
                          ? conversation.members
                              ?.firstWhere((element) =>
                                  element.sId != controller.user.value.sId)
                              .sId
                          : conversation.members?.first.sId;

                      bool isOnline = memberId != null &&
                          dashboardController.onlineUsers.contains(memberId);

                      return Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                )
            ],
          )),
    );
  }

  Row _buildLastMessageText(String senderName, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            conversation.lastMessage?.content != null &&
                    conversation.lastMessage?.file == null
                ? "${isSameUser ? "Bạn:" : senderName} ${conversation.lastMessage!.content}"
                : "${isSameUser ? "Bạn" : senderName} đã gủi một ảnh",
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: AppColors.textColor.withOpacity(0.75)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          formatDateTimeFromString(conversation.lastMessage?.updatedAt ?? ""),
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                fontSize: 10.sp,
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}
