import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';

import '../../../constants/app_colors.dart';
import '../../../resources/models/user.model.dart';
import '../../../utils/widgets/common/network_image.dart';

class VoteUserDetail extends StatelessWidget {
  const VoteUserDetail({super.key, required this.users});
  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.5,
      padding: const EdgeInsets.all(AppSize.kPadding / 2),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: AppSize.kPadding),
              physics: const BouncingScrollPhysics(),
              child: Wrap(
                direction: Axis.vertical,
                spacing: AppSize.kPadding / 4,
                children: [
                  SizedBox(
                    width: Get.width - AppSize.kPadding * 2,
                    child: Text(
                      "Danh sách người bình chọn",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...users.map((item) => _buildVoteUserItem(context, item)),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 50.w,
                height: 5.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoteUserItem(BuildContext context, User user) {
    return Container(
      width: Get.width - AppSize.kPadding,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.kPadding, vertical: AppSize.kPadding / 2),
      child: Row(
        children: [
          SizedBox(
            width: 32.w,
            height: 32.w,
            child: CustomNetworkImage(
              width: 32.w,
              height: 32.w,
              imageUrl: "${user.info?.avatar}",
            ),
          ),
          const SizedBox(
            width: AppSize.kPadding / 2,
          ),
          Text(
            "${user.info?.fullName}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
