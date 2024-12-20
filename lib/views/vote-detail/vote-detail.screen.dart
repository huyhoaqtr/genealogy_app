import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/progress_indicator.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';
import 'package:getx_app/views/vote-detail/view/vote_user.sheet.dart';

import '../../constants/app_colors.dart';
import '../../resources/models/user.model.dart';
import '../../utils/string/string.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../vote/view/vote_progress.dart';
import 'vote-detail.controller.dart';

class VoteDetailScreen extends GetView<VoteDetailController> {
  const VoteDetailScreen({super.key});

  void _showVoteUserBottomSheet(List<User> users) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(minWidth: Get.width),
      builder: (context) => VoteUserDetail(users: users),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    ).whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết bình chọn'),
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
      ),
      body: SizedBox(
        width: Get.width,
        child: Stack(
          children: [
            _buildMainContentView(context),
            _buildFooterButtonGroup(context),
          ],
        ),
      ),
    );
  }

  Positioned _buildMainContentView(BuildContext context) {
    return Positioned.fill(child: Obx(() {
      if (controller.voteSession.value.sId == null) {
        return const ProgressIndicatorComponent();
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: Get.width - AppSize.kPadding,
          child: Wrap(
            spacing: AppSize.kPadding / 2,
            direction: Axis.vertical,
            children: [
              SizedBox(
                width: Get.width - AppSize.kPadding,
                child: Text(
                  "${controller.voteSession.value.title}",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              SizedBox(
                width: Get.width - AppSize.kPadding,
                child: Text(
                  "${controller.voteSession.value.desc}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              SizedBox(
                width: Get.width - AppSize.kPadding * 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tạo bởi ${controller.voteSession.value.creator?.info?.fullName}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      formatDateTimeFromString(
                          "${controller.voteSession.value.createdAt}"),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Obx(() {
                final int totalVotes = calculateTotalVotes(
                    controller.voteSession.value.options ?? []);

                return Text(
                  "$totalVotes người đã bình chọn",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.blue),
                );
              }),
              Obx(() {
                final int totalVotes = calculateTotalVotes(
                    controller.voteSession.value.options ?? []);
                return Column(
                    children: controller.voteSession.value.options!
                        .map((option) => Obx(() => VoteProgressItem(
                              votePerson: option.votes ?? [],
                              onTap: () => controller.chooseVote(option),
                              onShowUser: () => _showVoteUserBottomSheet(
                                option.votes ?? [],
                              ),
                              isSelect:
                                  controller.selectedVote.value == option.sId,
                              percent: totalVotes == 0
                                  ? 0
                                  : option.votes!.length / totalVotes,
                              text: "${option.text}",
                            )))
                        .toList());
              }),
              const SizedBox(height: 62),
            ],
          ),
        ),
      );
    }));
  }

  Positioned _buildFooterButtonGroup(BuildContext context) {
    return Positioned(
      bottom: AppSize.kPadding,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(AppSize.kPadding),
        child: CustomButton(
          text: "Bình chọn",
          onPressed: () => controller.castVote(),
        ),
      ),
    );
  }
}
