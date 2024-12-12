import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/views/feed/view/create_feed.sheet.dart';
import 'package:getx_app/views/feed/view/feed.item.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'feed.controller.dart';

class FeedScreen extends GetView<FeedController> {
  const FeedScreen({super.key});

  void _showCreateNewPostBottomSheet(BuildContext context) {
    Get.lazyPut(() => CreateFormController());
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        controller: controller.scrollController,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: Get.width,
          child: Obx(() => Column(
                children: [
                  _buildCreateNewPostView(context),
                  ...controller.feeds.value.map((item) => FeedItem(
                        isDetail: false,
                        controller: FeedItemController(initialFeed: item),
                      ))
                ],
              )),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Bảng tin'),
      leading: IconButtonComponent(
        iconPath: 'assets/icons/arrow-left.svg',
        onPressed: () => Get.back(),
      ),
    );
  }

  Widget _buildCreateNewPostView(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(
        bottom: AppSize.kPadding,
        top: AppSize.kPadding / 2,
        left: AppSize.kPadding / 2,
        right: AppSize.kPadding / 2,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            color: AppColors.borderColor,
            width: 1,
          ))),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            radius: 16.w,
            backgroundImage: const NetworkImage(
              "https://images.unsplash.com/photo-1499714608240-22fc6ad53fb2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=880&q=80",
            ),
          ),
          const SizedBox(
            width: AppSize.kPadding / 2,
          ),
          GestureDetector(
            onTap: () => _showCreateNewPostBottomSheet(context),
            child: Container(
              width: Get.width - AppSize.kPadding * 2 - 32.w,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tran Ngoc Phong",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: AppSize.kPadding / 4,
                  ),
                  Text(
                    "Bạn có gì mới?",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: AppColors.textColor.withOpacity(0.5)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
