import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/dialog/dialog.helper.dart';
import '../../constants/app_colors.dart';
import '../../resources/models/tree_member.model.dart';
import '../../utils/string/string.dart';
import '../../utils/widgets/common/network_image.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/progress_indicator.dart';
import 'contact.controller.dart';

class ContactScreen extends GetView<ContactController> {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text("Danh bạ"),
        leading: IconButtonComponent(
            iconPath: 'assets/icons/arrow-left.svg',
            onPressed: () => Get.back()),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildSearchInput(context),
          ),
          Positioned(
            top: 50,
            bottom: 0,
            left: 0,
            right: 0,
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Expanded(child: ProgressIndicatorComponent());
              }
              if (controller.filteredBlocks.value.isEmpty &&
                  !controller.isLoading.value) {
                return Expanded(
                  child: Center(
                    child: Text(
                      'Chưa có thành viên nào',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: AppSize.kPadding / 2),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Obx(() => Column(
                        children: controller.filteredBlocks
                            .map((item) => _buildContentItem(context, item))
                            .toList(),
                      )),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding / 2),
      margin: const EdgeInsets.symmetric(
        vertical: AppSize.kPadding / 2,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.kRadius),
        child: AnimatedContainer(
          width: Get.width,
          height: 35,
          duration: const Duration(milliseconds: 200),
          color: Colors.black.withOpacity(0.1),
          child: Obx(() => TextField(
                controller: controller.searchController.value,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                cursorColor: AppColors.primaryColor,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                decoration: InputDecoration(
                  hintText: "Tìm kiếm",
                  hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.textColor.withOpacity(0.5),
                      ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSize.kRadius),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSize.kRadius),
                      borderSide: BorderSide.none),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSize.kPadding / 2),
                    child: SvgPicture.asset(
                      "assets/icons/search-normal.svg",
                      fit: BoxFit.contain,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSize.kPadding,
                    vertical: AppSize.kPadding / 4,
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget _buildContentItem(BuildContext context, TreeMember data) {
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
            padding: const EdgeInsets.all(AppSize.kPadding / 2),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(AppSize.kRadius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.kRadius),
                    child: CustomNetworkImage(imageUrl: "${data.avatar}"),
                  ),
                ),
                const SizedBox(width: 12),
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
                      const SizedBox(height: 1),
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
            padding: const EdgeInsets.all(AppSize.kPadding / 2),
            child: Row(children: [
              const IconButtonComponent(
                iconPath: "assets/icons/call.svg",
                iconSize: 32,
              ),
              const SizedBox(width: AppSize.kPadding / 2),
              Expanded(
                child: Text(
                  data.phoneNumber ?? "Chưa có",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: AppSize.kPadding / 2),
              InkWell(
                onTap: () {
                  if (data.phoneNumber != null) {
                    callPhone(data.phoneNumber!);
                  } else {
                    DialogHelper.showToast(
                      "Chưa có số điện thoại",
                      ToastType.warning,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(AppSize.kRadius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.kPadding / 2,
                    vertical: AppSize.kPadding / 6,
                  ),
                  child: Row(children: [
                    const IconButtonComponent(
                      iconPath: "assets/icons/call-out-going.svg",
                      iconSize: 28,
                      iconPadding: 4,
                    ),
                    Text("Gọi điện",
                        style: Theme.of(context).textTheme.bodySmall),
                  ]),
                ),
              ),
              const SizedBox(width: AppSize.kPadding / 2),
              InkWell(
                onTap: () {
                  if (data.phoneNumber != null) {
                    sendMessage(data.phoneNumber!);
                  } else {
                    DialogHelper.showToast(
                      "Chưa có số điện thoại",
                      ToastType.warning,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(AppSize.kRadius),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.kPadding / 2,
                    vertical: AppSize.kPadding / 6,
                  ),
                  child: Row(children: [
                    const IconButtonComponent(
                      iconPath: "assets/icons/comment.svg",
                      iconSize: 28,
                      iconPadding: 4,
                    ),
                    Text("Nhắn tin",
                        style: Theme.of(context).textTheme.bodySmall),
                  ]),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
