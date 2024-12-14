import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../message_detail/views/message_item.dart';
import 'chatbot.controller.dart';

class ChatBotScreen extends GetView<ChatBotController> {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trợ lý AI'),
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          _buildMessageListView(context),
          _buildMessageInputView(context)
        ],
      ),
    );
  }

  Widget _buildMessageListView(BuildContext context) {
    return Expanded(
      child: Obx(() => ListView.builder(
            itemCount: controller.messages.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: AppSize.kPadding / 2),
            itemBuilder: (context, index) {
              return MessageItem(
                message: controller.messages[index],
                isSameUser: controller.myId.value ==
                    controller.messages[index].sender?.sId,
                isReply: false,
                conversationType: "CHATBOT",
              );
            },
          )),
    );
  }

  Padding _buildMessageInputView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSize.kPadding,
        right: AppSize.kPadding,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? AppSize.kPadding
            : AppSize.kPadding * 2,
        top: AppSize.kPadding / 2,
      ),
      child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.isChatBotTyping.value)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.kPadding / 2,
                  ),
                  child: Text("Đang soạn câu trả lời ...",
                      style: Theme.of(context).textTheme.bodySmall),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: Get.width,
                      height: 35.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSize.kRadius),
                        color: Colors.black.withOpacity(0.075),
                      ),
                      child: TextField(
                        controller: controller.promptController,
                        textInputAction: TextInputAction.send,
                        cursorColor: AppColors.primaryColor,
                        maxLines: 5,
                        minLines: 1,
                        style:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(),
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
                    onPressed: () => controller
                        .sendPromptToChatBot(controller.promptController.text),
                    iconSize: 36,
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
