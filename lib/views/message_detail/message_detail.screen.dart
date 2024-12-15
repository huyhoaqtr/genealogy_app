import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/common/network_image.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';
import '../../constants/app_colors.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/media/media_picker.dart';
import '../message/model/conversation.model.dart';
import 'message_detail.controller.dart';
import 'views/message_item.dart';
import 'package:photo_manager/photo_manager.dart';

class MessageDetailScreen extends GetView<MessageDetailController> {
  const MessageDetailScreen({super.key});

  void _showMediaPickerBottomSheet() {
    if (!Get.isRegistered<MediaPickerController>()) {
      Get.put(MediaPickerController(
        requestType: RequestType.image,
        maxSelectedCount: 1,
      ));
    }
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => MediaPicker(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    ).whenComplete(() async {
      final mediaPickerController = Get.find<MediaPickerController>();
      final files = mediaPickerController.selectedAssets;
      if (files.isNotEmpty) {
        controller.tempImage.value = await files.first.file;
        controller.sendMessage(MessageType.IMAGE);
      }
    }).then((value) async {
      Future.delayed(const Duration(milliseconds: 200), () {
        Get.delete<MediaPickerController>();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SizedBox(
            width: Get.width,
            child: Column(
              children: [
                _buildMessageListView(context),
                _buildInputMessageView(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButtonComponent(
        iconPath: 'assets/icons/arrow-left.svg',
        onPressed: () => Get.back(),
      ),
      title: Obx(() {
        String? conversationType = controller.conversation.value.type;
        Info? info;

        if (conversationType != 'GROUP') {
          info = controller.conversation.value.members
                      ?.where((element) => element.sId != controller.myId.value)
                      .isNotEmpty ==
                  true
              ? controller.conversation.value.members!
                  .where((element) => element.sId != controller.myId.value)
                  .first
                  .info
              : controller.receiver.value.info;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 32.w,
              height: 32.w,
              child: ClipOval(
                child: CustomNetworkImage(
                  imageUrl: conversationType == 'GROUP'
                      ? 'https://cdn-icons-png.flaticon.com/512/149/149071.png'
                      : "${info?.avatar ?? 'https://cdn-icons-png.flaticon.com/512/149/149071.png'}", // Avatar mặc định
                ),
              ),
            ),
            const SizedBox(width: AppSize.kPadding),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  conversationType == 'GROUP'
                      ? 'Gia Toc'
                      : info?.fullName ?? 'Unknown User',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (conversationType != "GROUP")
                  GetBuilder<DashboardController>(
                    init: DashboardController(),
                    builder: (dashboardController) {
                      String? memberId = controller.conversation.value.members
                                  ?.where((element) =>
                                      element.sId != controller.myId.value)
                                  .isNotEmpty ==
                              true
                          ? controller.conversation.value.members
                              ?.firstWhere((element) =>
                                  element.sId != controller.myId.value)
                              .sId
                          : controller.conversation.value.members?.first.sId ??
                              controller.receiver.value.sId;

                      bool isOnline = memberId != null &&
                          dashboardController.onlineUsers.contains(memberId);
                      return Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: BoxDecoration(
                              color: isOnline ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                          ),
                          const SizedBox(width: AppSize.kPadding / 3),
                          Text(isOnline ? 'Online' : 'Offline',
                              style: Theme.of(context).textTheme.labelSmall),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ],
        );
      }),
      centerTitle: false,
    );
  }

  Widget _buildMessageListView(BuildContext context) {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          controller: controller.scrollController,
          itemCount: controller.messages.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding / 2),
          itemBuilder: (context, index) {
            bool isSameUser =
                controller.myId.value == controller.messages[index].sender?.sId;
            if (index == controller.messages.length - 1) {
              return Center(
                child: Column(
                  children: [
                    Obx(() => controller.isLoadMore.value
                        ? Container(
                            width: 20.w,
                            height: 20.w,
                            margin: const EdgeInsets.symmetric(
                              vertical: AppSize.kPadding,
                            ),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryColor,
                            ),
                          )
                        : Container()),
                    MessageItem(
                      // key: controller.itemKeys[index],
                      isSameUser: isSameUser,
                      message: controller.messages[index],
                      conversationType:
                          controller.conversation.value.type ?? "SINGLE",
                    ),
                  ],
                ),
              );
            }
            return MessageItem(
              // key: controller.itemKeys[index],
              isSameUser: isSameUser,
              message: controller.messages[index],
              conversationType: controller.conversation.value.type ?? "SINGLE",
            );
          },
        );
      }),
    );
  }

  Widget _buildInputMessageView(BuildContext context) {
    return Container(
      width: Get.width,
      color: Colors.white.withOpacity(0.5),
      child: Column(
        children: [
          Obx(() {
            bool isReply = controller.replyMessage.value.sId != null;
            bool isImage = controller.replyMessage.value.file != null;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: isReply ? 50.h : 0,
              padding: const EdgeInsets.symmetric(
                vertical: AppSize.kPadding / 2,
                horizontal: AppSize.kPadding,
              ),
              margin: const EdgeInsets.only(
                bottom: AppSize.kPadding / 2,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isReply ? AppColors.borderColor : Colors.transparent,
                    width: 0.5,
                  ),
                ),
              ),
              child: isReply
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Đang trả lời ${controller.replyMessage.value.sender?.sId == controller.myId.value ? 'chính bạn' : controller.replyMessage.value.sender?.info?.fullName}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: AppSize.kPadding / 4),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  isImage
                                      ? 'Hình ảnh'
                                      : "${controller.replyMessage.value.content}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontSize: 12.sp),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isImage)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4.w),
                            child: SizedBox(
                              width: 36.w,
                              height: 36.w,
                              child: CustomNetworkImage(
                                imageUrl:
                                    "${controller.replyMessage.value.file}",
                              ),
                            ),
                          ),
                        const SizedBox(width: AppSize.kPadding / 2),
                        IconButtonComponent(
                          iconPath: 'assets/icons/cross.svg',
                          onPressed: () => controller.closeReplyMessage(),
                          iconSize: 28,
                          iconPadding: AppSize.kPadding / 4,
                        ),
                      ],
                    )
                  : Container(),
            );
          }),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSize.kPadding / 2,
              right: AppSize.kPadding / 2,
              bottom: AppSize.kPadding / 2,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButtonComponent(
                  iconPath: 'assets/icons/gallery.svg',
                  onPressed: () => _showMediaPickerBottomSheet(),
                  iconSize: 36,
                ),
                const SizedBox(width: AppSize.kPadding / 2),
                Expanded(
                  child: Container(
                    width: Get.width,
                    height: 35.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSize.kRadius),
                      color: Colors.black.withOpacity(0.075),
                    ),
                    child: TextField(
                      controller: controller.messageController,
                      textInputAction: TextInputAction.send,
                      cursorColor: AppColors.primaryColor,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                      decoration: InputDecoration(
                        hintText: "Aa",
                        hintStyle:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: AppColors.textColor.withOpacity(0.5),
                                ),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSize.kRadius),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSize.kRadius),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSize.kPadding / 1.5,
                          vertical: AppSize.kPadding / 3,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSize.kPadding / 2),
                IconButtonComponent(
                  iconPath: 'assets/icons/send.svg',
                  onPressed: () => controller.sendMessage(MessageType.TEXT),
                  iconSize: 36,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
