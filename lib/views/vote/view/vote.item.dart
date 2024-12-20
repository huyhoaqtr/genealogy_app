import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_routes.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';
import 'package:getx_app/views/vote/vote.controller.dart';

import '../../../constants/app_colors.dart';
import '../../../resources/models/vote.model.dart';
import '../../../utils/string/string.dart';
import 'vote_progress.dart';

class VoteItem extends StatelessWidget {
  const VoteItem(
      {super.key, required this.voteSession, required this.controller});

  final VoteSession voteSession;
  final VoteController controller;

  @override
  Widget build(BuildContext context) {
    final int totalVotes = calculateTotalVotes(voteSession.options!);
    return Container(
      width: Get.width - AppSize.kPadding * 2,
      decoration: BoxDecoration(
        color: AppColors.textColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSize.kRadius),
      ),
      child: GestureDetector(
        onTap: () => Get.toNamed(
          AppRoutes.voteDetail,
          arguments: {"voteSession": voteSession},
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.kPadding / 2,
            vertical: AppSize.kPadding / 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${voteSession.title}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                "${voteSession.desc}",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(
                width: Get.width - AppSize.kPadding * 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tạo bởi ${voteSession.creator?.info?.fullName}",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      formatDateTimeFromString(voteSession.createdAt!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSize.kPadding / 4),
              Text(
                "$totalVotes người đã bình chọn",
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Colors.blue),
              ),
              const SizedBox(height: AppSize.kPadding / 4),
              if (voteSession.options?.isNotEmpty ?? false)
                ...controller.filterOptions(voteSession.options!).take(3).map(
                      (option) => VoteProgressItem(
                        text: option.text ?? "",
                        votePerson: option.votes ?? [],
                        percent: totalVotes == 0
                            ? 0
                            : (option.votes!.length / totalVotes),
                      ),
                    ),
              if ((voteSession.options?.isNotEmpty ?? false) &&
                  voteSession.options!.length > 3)
                _buildMoreVotePerson(context),
              const SizedBox(height: AppSize.kPadding / 2),
              Container(
                alignment: Alignment.center,
                color: Colors.transparent,
                child: CustomButton(
                  text: "Bình chọn",
                  onPressed: () => Get.toNamed(
                    AppRoutes.voteDetail,
                    arguments: {"voteSession": voteSession},
                  ),
                  isOutlined: true,
                  height: 30,
                  width: Get.width / 2,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoreVotePerson(BuildContext context) {
    return Container(
      width: Get.width - AppSize.kPadding * 2,
      height: 28,
      margin: const EdgeInsets.only(top: AppSize.kPadding / 4),
      decoration: BoxDecoration(
        color: AppColors.textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSize.kRadius),
      ),
      child: Center(
        child: Text(
          "+${voteSession.options!.length - 3} mục khác",
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}
