import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/common/network_image.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';
import '../../../resources/api/home.api.dart';
import '../../../utils/string/string.dart';
import '../../../utils/widgets/dialog/dialog.helper.dart';
import '../message_detail.controller.dart';
import '../model/message.model.dart';
import 'message_bottom_sheet.dart';
import '../../../utils/widgets/overlay/image.overlay.dart';

class MessageItem extends StatelessWidget {
  final Message message;
  final RxBool hasRung = false.obs;
  final Rx<OverlayEntry?> overlayEntry = Rx<OverlayEntry?>(null);
  final Rx<Offset> overlayPosition = Rx<Offset>(const Offset(0, 0));
  final Rx<Offset> initialPosition = Rx<Offset>(const Offset(0, 0));
  final RxDouble dragPosition = 0.0.obs;
  final RxDouble dragStartPosition = 0.0.obs;
  final bool? isReply;
  final bool isSameUser;
  final String conversationType;

  MessageItem(
      {super.key,
      required this.message,
      this.isReply = true,
      required this.isSameUser,
      required this.conversationType});

  void replyMessage() {
    Get.find<MessageDetailController>().replyMessageTo(message);
  }

  void unSendMessage() {
    Get.find<MessageDetailController>().unSendMessage(message.sId!);
  }

  void scrollToMessage(Message replyMessage) {
    Get.find<MessageDetailController>().scrollToMessage(replyMessage);
  }

  void copyMessage() {
    Clipboard.setData(ClipboardData(text: message.content!));
    DialogHelper.showToast("Đã sao chép nội dung", ToastType.success);
  }

  void showOverlay(BuildContext context) {
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
            url: "${message.file}",
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

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(minWidth: Get.width),
      builder: (context) => MessageBottomSheet(
        message: message,
        isSameUser: isSameUser,
        onCopyMessage: () => copyMessage(),
        onUnSendMessage: () => unSendMessage(),
        onSaveImage: () async => saveImage(),
        onReplyMessage: () => replyMessage(),
      ),
    );
  }

  Future<void> saveImage() async {
    Get.find<LoadingController>().show();
    try {
      await HomeApi.saveImageFromUrl("${message.file}");
    } catch (e) {
      rethrow;
    } finally {
      Get.find<LoadingController>().hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isTextMessage = message.content != null && message.file == null;
    bool isReplyTextMessage = message.replyMessage?.content != null &&
        message.replyMessage?.file == null;
    return IntrinsicWidth(
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.symmetric(vertical: AppSize.kPadding / 2),
        alignment: isSameUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Obx(() {
          double difference = dragPosition.value - dragStartPosition.value;
          return GestureDetector(
            onLongPress: () => (isReply == true && message.tempId == null)
                ? showBottomSheet(context)
                : null,
            onTap: () => isTextMessage
                ? null
                : message.tempImage == null && message.tempId == null
                    ? showOverlay(context)
                    : null,
            onHorizontalDragStart: (details) {
              if (isReply != true || message.tempId != null) return;
              dragStartPosition.value = dragPosition.value;
            },
            onHorizontalDragUpdate: (details) {
              if (isReply != true || message.tempId != null) return;
              if (dragPosition.value + details.delta.dx <= 0) {
                dragPosition.value += details.delta.dx / 2.5;
                if (dragPosition.value.abs() >= 50 && !hasRung.value) {
                  HapticFeedback.mediumImpact();
                  hasRung.value = true;
                } else if (dragPosition.value.abs() < 50 && hasRung.value) {
                  hasRung.value = false;
                }
              }
            },
            onHorizontalDragEnd: (_) {
              if (isReply != true || message.tempId != null) return;

              if (difference.abs() > 50) {
                replyMessage();
              }
              hasRung.value = false;
              dragPosition.value = dragStartPosition.value;
            },
            child: Transform.translate(
              offset: Offset(dragPosition.value, 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isSameUser)
                    Container(
                      margin:
                          const EdgeInsets.only(right: AppSize.kPadding / 2),
                      child: ClipOval(
                        child: SizedBox(
                          height: 16,
                          width: 16,
                          child: CustomNetworkImage(
                              imageUrl: "${message.sender?.info?.avatar}"),
                        ),
                      ),
                    ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: !isSameUser
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      if (message.replyMessage?.sId != null)
                        GestureDetector(
                          onTap: () => scrollToMessage(message.replyMessage!),
                          child: Opacity(
                            opacity: 0.45,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: AppSize.kPadding / 8),
                              padding: EdgeInsets.all(
                                  AppSize.kPadding / (isTextMessage ? 2 : 4)),
                              constraints: BoxConstraints(
                                maxWidth: Get.width * 0.35,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.25),
                                borderRadius:
                                    BorderRadius.circular(AppSize.kRadius),
                              ),
                              child: isReplyTextMessage
                                  ? Text(
                                      message.replyMessage?.content ?? '',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        AppSize.kRadius,
                                      ),
                                      child: SizedBox(
                                        width: 75,
                                        height: 75,
                                        child: CustomNetworkImage(
                                            imageUrl:
                                                "${message.replyMessage?.file}"),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: Get.width * 0.65,
                            ),
                            padding: EdgeInsets.all(
                                AppSize.kPadding / (isTextMessage ? 2 : 4)),
                            decoration: BoxDecoration(
                              color: !isSameUser
                                  ? Colors.grey.withOpacity(0.25)
                                  : AppColors.primaryColor.withOpacity(0.75),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(
                                    AppSize.kRadius * 1.5),
                                topRight: const Radius.circular(
                                    AppSize.kRadius * 1.5),
                                bottomRight: Radius.circular(
                                    !isSameUser ? AppSize.kRadius * 1.5 : 0),
                                bottomLeft: Radius.circular(
                                    !isSameUser ? 0 : AppSize.kRadius * 1.5),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: !isSameUser
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                isTextMessage
                                    ? Text(
                                        message.content ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )
                                    : _buildImage(),
                                _buildBottomText(context),
                              ],
                            ),
                          ),
                          Container(
                            width: dragPosition.value > 0 ? 0 : 0,
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.reply,
                              color: AppColors.primaryColor.withOpacity(
                                min(difference.abs() / 50, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Container _buildBottomText(BuildContext context) {
    String text = formatDateTimeFromString(message.createdAt ?? '') +
        (conversationType != 'GROUP' || isSameUser
            ? ""
            : " - ${message.sender?.info?.fullName}");
    return Container(
      margin: const EdgeInsets.only(top: AppSize.kPadding / 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 8),
      ),
    );
  }

  ClipRRect _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        AppSize.kRadius,
      ),
      child: message.tempImage != null
          ? Stack(
              children: [
                SizedBox(
                  width: 175,
                  height: 175,
                  child: Image.file(
                    message.tempImage!,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child: Container(
                      width: 175,
                      height: 175,
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                              strokeWidth: 1.5, color: AppColors.primaryColor),
                        ),
                      )),
                ),
              ],
            )
          : SizedBox(
              width: 175,
              height: 175,
              child: Image.network(
                "${message.file}",
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: AppColors.primaryColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
              ),
            ),
    );
  }
}
