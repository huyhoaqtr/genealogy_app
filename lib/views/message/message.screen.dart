import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/views/message/views/search_user_item.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'message.controller.dart';
import 'views/message_item.dart';

class MessageScreen extends GetView<MessageController> {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        width: Get.width,
        padding: EdgeInsets.only(
          top: AppSize.kPadding,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSearchConversation(context),
                controller.searchText.value.isNotEmpty
                    ? _buildSearchUserList()
                    : _buildConversationList(),
              ],
            )),
      ),
    );
  }

  Expanded _buildConversationList() {
    return Expanded(
      child: SlidableAutoCloseBehavior(
          child: RefreshIndicator(
        onRefresh: () async {
          await controller.loadConversations();
        },
        child: ListView.builder(
          itemCount: controller.conversations.length,
          itemBuilder: (context, index) {
            final lastMessage = controller.conversations[index].lastMessage;
            bool isSameUser = lastMessage != null
                ? lastMessage.sender?.sId == controller.myId.value
                : false;

            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: AppSize.kPadding / 2),
                child: MessageItem(
                  isSameUser: isSameUser,
                  conversation: controller.conversations[index],
                ),
              );
            }
            return MessageItem(
              isSameUser: isSameUser,
              conversation: controller.conversations[index],
            );
          },
        ),
      )),
    );
  }

  Expanded _buildSearchUserList() {
    return Expanded(
      child: ListView.builder(
        itemCount: controller.searchUsers.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(top: AppSize.kPadding / 2),
              child: SearchUserItem(
                user: controller.searchUsers[index],
              ),
            );
          }
          return SearchUserItem(
            user: controller.searchUsers[index],
          );
        },
      ),
    );
  }

  Widget _buildSearchConversation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
      child: Row(
        children: [
          Obx(() {
            return AnimatedContainer(
              width: controller.searchText.value.isNotEmpty ? 32 : 0,
              duration: const Duration(milliseconds: 200),
              child: IconButtonComponent(
                iconPath: "assets/icons/arrow-left.svg",
                iconSize: 32,
                iconPadding: 4,
                onPressed: () => controller.searchController.value.text = "",
              ),
            );
          }),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.kRadius),
              child: AnimatedContainer(
                width: Get.width,
                height: 35,
                duration: const Duration(milliseconds: 200),
                color: Colors.black.withOpacity(0.1),
                child: Obx(() => TextField(
                      controller: controller.searchController.value,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      cursorColor: AppColors.primaryColor,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm",
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
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSize.kPadding / 2),
                          child: SvgPicture.asset(
                            "assets/icons/search-normal.svg",
                            fit: BoxFit.contain,
                            width: 24,
                            colorFilter: ColorFilter.mode(
                              AppColors.primaryColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSize.kPadding,
                          vertical: AppSize.kPadding / 4,
                        ),
                      ),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
