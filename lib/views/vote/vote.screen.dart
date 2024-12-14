import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/progress_indicator.dart';
import '../../utils/widgets/text_button.common.dart';
import 'view/create_vote.sheet.dart';
import 'view/vote.item.dart';
import 'vote.controller.dart';

class VoteScreen extends GetView<VoteController> {
  VoteScreen({super.key});

  final DashboardController dashboardController = Get.find();

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
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.delete<CreateVoteController>();
      });
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const ProgressIndicatorComponent();
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await controller.getAllVoteSession();
                },
                child: Obx(() {
                  final voteSessions = controller.voteSessions;

                  if (voteSessions.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: Get.height * 0.5,
                          child: Center(
                            child: Text(
                              'Không có biểu quyết nào',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount:
                        voteSessions.length + 1, // +1 for spacing at bottom
                    itemBuilder: (context, index) {
                      if (index == voteSessions.length) {
                        return SizedBox(height: 40.h); // Spacing at bottom
                      }

                      final voteSession = voteSessions[index];
                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSize.kPadding),
                        child: VoteItem(
                          voteSession: voteSession,
                          controller: controller,
                        ),
                      );
                    },
                  );
                }),
              );
            }),
          ),
          if (dashboardController.myInfo.value.role == 'LEADER' ||
              dashboardController.myInfo.value.role == 'ADMIN')
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
    );
  }
}
