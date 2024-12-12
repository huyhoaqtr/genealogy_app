import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../resources/models/tree_member.model.dart';
import '../../utils/lunar/lunar_solar_utils.dart';
import '../../utils/string/string.dart';
import '../../utils/widgets/common/network_image.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'church.controller.dart';

class ChurchScreen extends GetView<ChurchController> {
  const ChurchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChurchScreen'),
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: Get.width,
          child: Obx(() => Column(
                children: controller
                    .filterMembers()
                    .map((item) => _buildContentItem(context, item))
                    .toList(),
              )),
        ),
      ),
    );
  }

  Widget _buildContentItem(BuildContext context, TreeMember data) {
    final DateTime itemDate = data.dateOfDeath != null
        ? DateTime.parse(data.dateOfDeath!)
        : DateTime.now();
    final lunarDates =
        convertSolar2Lunar(itemDate.day, itemDate.month, itemDate.year, 7);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSize.kPadding / 2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.kRadius),
          border: Border.all(
            color: AppColors.borderColor,
            width: 1,
          )),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(AppSize.kRadius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.w,
                  width: 40.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.kRadius),
                    child: CustomNetworkImage(imageUrl: "${data.avatar}"),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${data.fullName}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                  textAlign: TextAlign.left,
                                ),
                                if (data.title != null)
                                  Text(
                                    "${data.title}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                    textAlign: TextAlign.left,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "GT: ${genderOptions.where(
                                  (item) => item['value'] == data.gender,
                                ).first['name']}",
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Đời: ${data.level}",
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Tuổi: ${data.dateOfBirth != null ? calculateAge(
                                data.dateOfBirth!,
                                deathDateString: data.dateOfDeath,
                              ) : "?"}",
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Con: ${data.children?.length ?? 0}",
                            style: Theme.of(context).textTheme.labelSmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(AppSize.kRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ngày mất: ${data.dateOfDeath != null ? "${formatDate(data.dateOfDeath!)} (DL) - ${lunarDates[0]}/${lunarDates[1]}/${lunarDates[2]} (ÂL)" : ""}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  "Mộ táng tại: ${data.burial ?? ""}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  "Thờ cúng tại: ${data.placeOfWorship ?? ""}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  "Người phụ trách: ${data.personInCharge ?? ""}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
