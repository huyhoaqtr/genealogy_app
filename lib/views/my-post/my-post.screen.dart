import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/progress_indicator.dart';
import '../feed/view/feed.item.dart';
import 'my-post.controller.dart';

class MyPostScreen extends GetView<MyPostController> {
  const MyPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SizedBox(
        width: Get.width,
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value &&
                    controller.feeds.value.isEmpty) {
                  return const ProgressIndicatorComponent();
                }

                if (controller.feeds.value.isEmpty) {
                  return SizedBox(
                    child: Center(
                      child: Text(
                        "Chưa có bài viết",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  controller: controller.scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.feeds.value.length +
                      (controller.isLoadMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.feeds.value.length) {
                      return const SizedBox(
                        height: 50,
                        child: Center(
                          child: ProgressIndicatorComponent(size: 30),
                        ),
                      );
                    }

                    final item = controller.feeds.value[index];
                    return FeedItem(
                      isDetail: false,
                      controller: FeedItemController(initialFeed: item),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Bài viết của bạn'),
      leading: IconButtonComponent(
        iconPath: 'assets/icons/arrow-left.svg',
        onPressed: () => Get.back(),
      ),
    );
  }
}
