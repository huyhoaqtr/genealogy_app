import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/models/user.model.dart';

import '../../../constants/app_size.dart';
import '../../../utils/widgets/common/network_image.dart';
import '../../dashboard/dashboard.controller.dart';

class SearchUserItem extends StatelessWidget {
  const SearchUserItem({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed("/message-detail",
          arguments: {"receiver": user.toJson()}),
      child: Container(
          width: Get.width,
          padding: const EdgeInsets.only(
            top: AppSize.kPadding / 2,
            bottom: AppSize.kPadding / 2,
            right: AppSize.kPadding,
            left: AppSize.kPadding,
          ),
          child: Row(
            children: [
              _buildStatusAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Text(user.info?.fullName ?? "",
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ],
          )),
    );
  }

  CircleAvatar _buildStatusAvatar() {
    return CircleAvatar(
      radius: 24,
      child: SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomNetworkImage(
                  imageUrl: user.info?.avatar ?? "",
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: GetBuilder<DashboardController>(
                  init: DashboardController(),
                  builder: (dashboardController) {
                    String? memberId = user.sId;

                    bool isOnline = memberId != null &&
                        dashboardController.onlineUsers.contains(memberId);

                    return Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              )
            ],
          )),
    );
  }
}
