import 'dart:io';
import 'package:getx_app/utils/widgets/common/network_image.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_size.dart';
import '../../utils/lunar/lunar_solar_utils.dart';
import '../../utils/string/string.dart';
import '../../utils/widgets/icon_button.common.dart';
import '../../utils/widgets/media/media_picker.dart';
import '../../utils/widgets/picker/picker.dart';
import '../../utils/widgets/text_button.common.dart';
import '../../utils/widgets/textfield.common.dart';
import 'user-info.controller.dart';

class UserInfoScreen extends GetView<UserInfoController> {
  const UserInfoScreen({super.key});

  void _showMediaPickerBottomSheet() {
    if (Get.isRegistered<MediaPickerController>()) {
      Get.put(() => MediaPickerController(
            requestType: RequestType.image,
            maxSelectedCount: 1,
          ));
    }
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => MediaPicker(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    ).whenComplete(() async {
      final mediaPickerController = Get.find<MediaPickerController>();
      final files = mediaPickerController.selectedAssets;
      if (files.isNotEmpty) {
        File? file = await files.first.file;
        controller.cropImage(file!.path);
      }
    }).then((value) {
      Future.delayed(const Duration(milliseconds: 200), () {
        Get.delete<MediaPickerController>();
      });
    });
  }

  void showGenderPicker(BuildContext context) {
    // Dữ liệu giới tính

    int selectedGenderIndex = 0;

    var genderPicker = Picker(
      adapter: PickerDataAdapter<String>(data: [
        ...genderOptions.map((gender) {
          return PickerItem<String>(
            text: Text(
              gender['name']!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }),
      ]),
      selecteds: [selectedGenderIndex],
    );

    // Hiển thị Dialog với Picker
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            height: 250,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Chọn giới tính',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 150,
                    child: genderPicker.makePicker(),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  CustomButton(
                    text: "Xác nhận",
                    height: 40,
                    onPressed: () {
                      dynamic selectedGender =
                          genderOptions[genderPicker.selecteds[0]]['value']!;
                      controller.gender.value = selectedGender;
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Thông tin cá nhân'),
          leading: IconButtonComponent(
            iconPath: 'assets/icons/arrow-left.svg',
            onPressed: () => Get.back(),
          ),
          actions: [
            Obx(() => controller.isEdit.value
                ? TextButton(
                    onPressed: () => controller.isEdit.value = false,
                    child: Text(
                      "Huỷ",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                    ))
                : IconButtonComponent(
                    iconPath: 'assets/icons/pen.svg',
                    iconSize: 32,
                    iconPadding: 6,
                    onPressed: () => controller.isEdit.value = true,
                  )),
            const SizedBox(width: AppSize.kPadding),
          ]),
      body: SizedBox(
        width: Get.width,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSize.kPadding),
                child: Column(
                  children: [
                    _buildSheetItem(
                      context,
                      "Ảnh đại diện",
                      _buildImagePicker(context),
                    ),
                    _buildSheetItem(
                      context,
                      "Họ và tên",
                      Obx(() => TextFieldComponent(
                            enabled: controller.isEdit.value,
                            controller: controller.fullNameController.value,
                            hintText: "Nguyen Van A",
                            radius: AppSize.kRadius,
                            textInputAction: TextInputAction.next,
                            errorText: controller.fullNameError.value.isNotEmpty
                                ? controller.fullNameError.value
                                : null,
                          )),
                    ),
                    _buildSheetItem(
                      context,
                      "Giới tính",
                      SizedBox(
                        child: GestureDetector(
                          onTap: () => controller.isEdit.value
                              ? showGenderPicker(context)
                              : null,
                          child: Obx(() => Container(
                                height: AppSize.kButtonHeight,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.kPadding),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    AppSize.kRadius,
                                  ),
                                  border: Border.all(
                                    color: controller.isEdit.value
                                        ? AppColors.textColor.withOpacity(0.6)
                                        : AppColors.borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        controller.gender.value != ""
                                            ? genderOptions
                                                    .where(
                                                      (item) =>
                                                          item['value'] ==
                                                          controller
                                                              .gender.value,
                                                    )
                                                    .first['name'] ??
                                                "Chọn giới tính"
                                            : "Chọn giới tính",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: AppColors.textColor
                                                  .withOpacity(
                                                      controller.gender.value !=
                                                              ""
                                                          ? 1
                                                          : 0.6),
                                            ),
                                      );
                                    }),
                                    SvgPicture.asset(
                                      "assets/icons/arrow-bottom.svg",
                                      width: 24,
                                      colorFilter: ColorFilter.mode(
                                          AppColors.textColor.withOpacity(0.5),
                                          BlendMode.srcIn),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                    _buildSheetItem(
                      context,
                      "Số điện thoại",
                      Obx(() => TextFieldComponent(
                            enabled: false,
                            controller: controller.phoneNumberController.value,
                            hintText: "Nhập số điện thoại",
                            radius: AppSize.kRadius,
                            textInputAction: TextInputAction.next,
                          )),
                    ),
                    _buildSheetItem(
                      context,
                      "Ngày sinh",
                      Obx(() => _buildDatePicker(
                          context,
                          "Chọn ngày sinh",
                          controller.birthday.value,
                          controller.showBirthdayPickerDialog)),
                    ),
                    _buildSheetItem(
                      context,
                      "Email",
                      Obx(() => TextFieldComponent(
                            enabled: controller.isEdit.value,
                            controller: controller.emailController.value,
                            hintText: "Nhập email",
                            radius: AppSize.kRadius,
                            textInputAction: TextInputAction.next,
                          )),
                    ),
                    _buildSheetItem(
                      context,
                      "Địa chỉ",
                      Obx(() => TextFieldComponent(
                            enabled: controller.isEdit.value,
                            controller: controller.addressController.value,
                            hintText: "Nhập địa chỉ",
                            radius: AppSize.kRadius,
                            textInputAction: TextInputAction.next,
                          )),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: AppSize.kPadding,
              left: 16,
              right: 16,
              child: Obx(() => controller.isEdit.value
                  ? Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "Huỷ",
                            isOutlined: true,
                            onPressed: () => controller.isEdit.value = false,
                          ),
                        ),
                        const SizedBox(width: AppSize.kPadding / 2),
                        Expanded(
                          child: CustomButton(
                            text: "Cập nhật",
                            onPressed: () => controller.updateUserInfo(),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink()),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildDatePicker(
      BuildContext context, String hintText, DateTime? date, Function() onTap) {
    final lunarDates = date != null
        ? convertSolar2Lunar(date.day, date.month, date.year, 7)
        : null;

    return GestureDetector(
      onTap: controller.isEdit.value ? onTap : null,
      child: Container(
        width: Get.width - AppSize.kPadding * 2,
        height: AppSize.kButtonHeight,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.kRadius),
          border: Border.all(
            color: controller.isEdit.value
                ? AppColors.textColor.withOpacity(0.6)
                : AppColors.borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null
                  ? "DL: ${DateFormat('dd-MM-yyyy').format(date)} / ÂL: ${lunarDates![0]}-${lunarDates[1]}-${lunarDates[2]}"
                  : hintText,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.textColor.withOpacity(
                      date != null ? 1 : 0.5,
                    ),
                  ),
            ),
            SvgPicture.asset(
              "assets/icons/calendar-2.svg",
              width: 24,
              colorFilter: ColorFilter.mode(
                AppColors.textColor.withOpacity(
                  date != null ? 1 : 0.5,
                ),
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildImagePicker(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          controller.isEdit.value ? _showMediaPickerBottomSheet() : null,
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSize.kRadius),
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 1,
                  ),
                ),
                child: Obx(() => ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.kRadius),
                      child: controller.croppedData.value != null
                          ? Image.file(
                              File(controller.croppedData.value!.path),
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            )
                          : controller.user.value.info!.avatar != null
                              ? CustomNetworkImage(
                                  imageUrl:
                                      "${controller.user.value.info!.avatar}",
                                  width: 80,
                                  height: 80,
                                )
                              : Image.asset(
                                  "assets/images/default-avatar.webp",
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                    ))),
            const SizedBox(width: AppSize.kPadding),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Text("+ Thêm ảnh đại diện",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.textColor.withOpacity(0.5))),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSheetItem(BuildContext context, String label, Widget child,
      {double? width}) {
    width ??= Get.width - 32;
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: AppSize.kPadding / 2),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppSize.kPadding / 2),
            child,
          ]),
    );
  }
}
