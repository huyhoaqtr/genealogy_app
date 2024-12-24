import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../resources/models/vote.model.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_size.dart';

class VoteItemBottomSheet extends StatelessWidget {
  final VoteSession voteSession;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const VoteItemBottomSheet(
      {super.key,
      required this.voteSession,
      required this.onEdit,
      required this.onRemove});

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
                onTap: onEdit,
                borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
                child: Container(
                  width: Get.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(AppSize.kPadding),
                  child: Text(
                    'Chỉnh sửa',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(AppSize.kRadius * 1.5),
                child: Container(
                  width: Get.width,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(AppSize.kPadding),
                  child: Text(
                    'Xoá',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.red,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: AppSize.kPadding / 2),
            ],
          ),
        ],
      ),
    );
  }
}
