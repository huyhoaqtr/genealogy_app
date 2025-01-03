import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';
import '../model/message.model.dart';

class MessageBottomSheet extends StatelessWidget {
  final Message message;
  final bool isSameUser;
  final VoidCallback onSaveImage;
  final VoidCallback onReplyMessage;
  final VoidCallback? onUnSendMessage;
  final VoidCallback? onCopyMessage;

  const MessageBottomSheet(
      {super.key,
      required this.message,
      required this.onSaveImage,
      required this.onReplyMessage,
      this.onCopyMessage,
      this.onUnSendMessage,
      required this.isSameUser});

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
              InkWell(
                borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
                child: Container(
                  width: Get.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(AppSize.kPadding),
                  child: Text(
                    'Trả lời',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                onTap: () => {Get.back(), onReplyMessage()},
              ),
              InkWell(
                borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
                child: Container(
                  width: Get.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(AppSize.kPadding),
                  child: Text(
                    'Sao chép',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                onTap: () => {
                  Get.back(),
                  if (onCopyMessage != null) {onCopyMessage!()}
                },
              ),
              if (message.file != null)
                InkWell(
                  borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
                  child: Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(AppSize.kPadding),
                    child: Text(
                      'Lưu ảnh',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  onTap: () => {
                    Get.back(),
                    onSaveImage()
                    // Get.back()
                  },
                ),
              if (isSameUser)
                InkWell(
                  borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
                  child: Container(
                    width: Get.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(AppSize.kPadding),
                    child: Text(
                      'Thu hồi',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ),
                  onTap: () => {
                    Get.back(),
                    if (onUnSendMessage != null) {onUnSendMessage!()}
                  },
                ),
              const SizedBox(height: AppSize.kPadding / 2),
            ],
          ),
        ],
      ),
    );
  }
}
