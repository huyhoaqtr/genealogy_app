import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/text_button.common.dart';
import 'view/create_vote.sheet.dart';
import 'view/vote.item.dart';
import 'vote.controller.dart';

class VoteScreen extends GetView<VoteController> {
  const VoteScreen({super.key});

  void _showCreateNewVoteBottomSheet() {
    Get.lazyPut(() => CreateVoteController());
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => const CreateVoteSheetUI(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    ).then((value) {
      Get.delete<CreateVoteController>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách bình chọn'),
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
      ),
      body: SizedBox(
        width: Get.width,
        child: Stack(
          children: [
            Positioned.fill(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.getAllVoteSession();
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: Get.width,
                    child: Obx(() => Wrap(
                          spacing: AppSize.kPadding,
                          direction: Axis.vertical,
                          children: [
                            ...controller.voteSessions.map(
                              (item) => VoteItem(
                                voteSession: item,
                                controller: controller,
                              ),
                            ),
                            SizedBox(height: 40.h),
                          ],
                        )),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: AppSize.kPadding * 1.5,
              left: 16,
              right: 16,
              child: CustomButton(
                text: "Tạo bình chọn mới",
                onPressed: () => _showCreateNewVoteBottomSheet(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
