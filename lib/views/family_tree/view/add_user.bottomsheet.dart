import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:getx_app/utils/types/type.dart';
import 'package:getx_app/utils/widgets/province/province.controller.dart';
import 'package:getx_app/utils/widgets/province/province.picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';
import 'package:getx_app/utils/widgets/textfield.common.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/lunar/lunar_solar_utils.dart';
import '../../../utils/string/string.dart';
import '../../../utils/widgets/media/media_picker.dart';
import '../../../utils/widgets/picker/picker.dart';
import 'add_user.controller.dart';
import 'user_picker.dart';

class AddUserBottomSheetUI extends StatelessWidget {
  final AddUserController controller = Get.find<AddUserController>();
  AddUserBottomSheetUI({super.key});

  void _showProvincePickerSheet(ProvinceLevel level) {
    Get.lazyPut(() => ProvincePickerController(level));
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(minWidth: Get.width),
      builder: (context) => const ProvincePickerSheetUI(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    ).then((value) {
      Get.delete<ProvincePickerController>();
    });
  }

  void _showUserPickerSheet(AddUserMode mode) {
    Get.lazyPut(() => UserPickerController(mode: mode));
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(minWidth: Get.width),
      builder: (context) => const UserPickerSheetUI(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    ).then((value) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.delete<UserPickerController>();
      });
    });
  }

  void _showMediaPickerBottomSheet() {
    Get.lazyPut(() => MediaPickerController(
          requestType: RequestType.image,
          maxSelectedCount: 1,
        ));
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(minWidth: Get.width),
      builder: (context) => MediaPicker(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    ).whenComplete(() async {
      File? filePath =
          await Get.find<MediaPickerController>().selectedAssets.first.file;
      controller.cropImage(filePath!.path);
    }).then((value) {
      Get.delete<MediaPickerController>();
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
    return Container(
      width: Get.width,
      height: Get.height * 0.85,
      decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          )),
      padding: EdgeInsets.only(
        top: 5,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
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
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSheetItem(
                      context,
                      "Ảnh đại diện",
                      _buildImagePicker(context),
                    ),
                    SizedBox(
                      width: Get.width - 32,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSheetItem(
                              context,
                              "Họ và tên",
                              Obx(() => TextFieldComponent(
                                    enabled: controller.editRole.value,
                                    controller: controller.fullNameController,
                                    hintText: "Nguyen Van A",
                                    radius: AppSize.kRadius,
                                    textInputAction: TextInputAction.next,
                                    errorText: controller
                                            .fullNameError.value.isNotEmpty
                                        ? controller.fullNameError.value
                                        : null,
                                  )),
                              width: (Get.width - 40) / 2,
                            ),
                            _buildSheetItem(
                              context,
                              "Danh xưng",
                              TextFieldComponent(
                                enabled: controller.editRole.value,
                                controller: controller.titleController,
                                hintText: "Thuỷ tổ",
                                radius: AppSize.kRadius,
                                textInputAction: TextInputAction.next,
                              ),
                              width: (Get.width - 40) / 2,
                            ),
                          ]),
                    ),
                    _buildSheetItem(
                      context,
                      "Giới tính",
                      SizedBox(
                        child: GestureDetector(
                          onTap: () => controller.editRole.value
                              ? showGenderPicker(context)
                              : null,
                          child: Obx(() => Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: AppSize.kButtonHeight,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppSize.kPadding),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        AppSize.kRadius,
                                      ),
                                      border: Border.all(
                                        color: controller
                                                .genderError.value.isNotEmpty
                                            ? AppColors.errorColor
                                            : controller.editRole.value
                                                ? AppColors.textColor
                                                    .withOpacity(0.6)
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
                                                      .withOpacity(controller
                                                                  .gender
                                                                  .value !=
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
                                              AppColors.textColor
                                                  .withOpacity(0.5),
                                              BlendMode.srcIn),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (controller.genderError.value.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: AppSize.kPadding / 2,
                                        left: AppSize.kPadding,
                                      ),
                                      child: Text(
                                        controller.genderError.value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                              color: AppColors.errorColor,
                                            ),
                                      ),
                                    ),
                                ],
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width - 32,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSheetItem(
                              context,
                              "Toạ độ X",
                              TextFieldComponent(
                                hintText: "X",
                                enabled: controller.editRole.value,
                                controller: controller.positionXController,
                                radius: AppSize.kRadius,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                              ),
                              width: (Get.width - 40) / 2,
                            ),
                            _buildSheetItem(
                              context,
                              "Toạ độ Y",
                              TextFieldComponent(
                                hintText: "Y",
                                enabled: controller.editRole.value,
                                controller: controller.positionYController,
                                radius: AppSize.kRadius,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                              ),
                              width: (Get.width - 40) / 2,
                            ),
                          ]),
                    ),
                    if (controller.mode != AddUserMode.ROOT)
                      Obx(() {
                        final isSelectedUserValid =
                            controller.selectedUser.value.fullName != null &&
                                controller
                                    .selectedUser.value.fullName!.isNotEmpty;
                        return _buildSheetItem(
                          context,
                          controller.mode == AddUserMode.CHILD
                              ? "Chọn bố / mẹ"
                              : "Chọn chồng / vợ",
                          SizedBox(
                            width: Get.width - 32,
                            child: GestureDetector(
                              onTap: () => controller.editRole.value
                                  ? _showUserPickerSheet(controller.mode)
                                  : null,
                              child: Container(
                                width: Get.width - 32,
                                height: AppSize.kButtonHeight,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSize.kPadding),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(AppSize.kRadius),
                                  border: Border.all(
                                    color: controller.editRole.value
                                        ? AppColors.textColor.withOpacity(0.6)
                                        : AppColors.borderColor,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isSelectedUserValid
                                          ? controller
                                              .selectedUser.value.fullName!
                                          : controller.mode == AddUserMode.CHILD
                                              ? "Chọn bố / mẹ"
                                              : "Chọn chồng",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: AppColors.textColor
                                                .withOpacity(isSelectedUserValid
                                                    ? 1
                                                    : 0.5),
                                          ),
                                    ),
                                    SvgPicture.asset(
                                      "assets/icons/arrow-bottom.svg",
                                      width: 24,
                                      colorFilter: ColorFilter.mode(
                                          AppColors.textColor.withOpacity(0.5),
                                          BlendMode.srcIn),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    _buildSheetItem(
                      context,
                      "Ngày sinh",
                      Obx(() => _buildDatePicker(
                          context,
                          "Chọn ngày sinh",
                          controller.birthday.value,
                          controller.showBirthdayPickerDialog)),
                    ),
                    Obx(() {
                      final isProvinceValid =
                          controller.selectedProvince.value.name != null &&
                              controller
                                  .selectedProvince.value.name!.isNotEmpty;
                      final isDistrictValid =
                          controller.selectedDistrict.value.name != null &&
                              controller
                                  .selectedDistrict.value.name!.isNotEmpty;
                      final isWardValid =
                          controller.selectedWards.value.name != null &&
                              controller.selectedWards.value.name!.isNotEmpty;
                      return _buildSheetItem(
                        context,
                        "Địa chỉ",
                        SizedBox(
                          width: Get.width - 32,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => controller.editRole.value
                                    ? _showProvincePickerSheet(
                                        ProvinceLevel.PROVINCE)
                                    : null,
                                child: Container(
                                  width: Get.width - 32,
                                  height: AppSize.kButtonHeight,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSize.kPadding),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(AppSize.kRadius),
                                    border: Border.all(
                                      color: controller.editRole.value
                                          ? AppColors.textColor.withOpacity(0.6)
                                          : AppColors.borderColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        isProvinceValid
                                            ? controller
                                                .selectedProvince.value.name!
                                            : "Chọn Tỉnh / Thành phố",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: AppColors.textColor
                                                  .withOpacity(isProvinceValid
                                                      ? 1
                                                      : 0.5),
                                            ),
                                      ),
                                      SvgPicture.asset(
                                        "assets/icons/arrow-bottom.svg",
                                        width: 24,
                                        colorFilter: ColorFilter.mode(
                                            AppColors.textColor
                                                .withOpacity(0.5),
                                            BlendMode.srcIn),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (isProvinceValid)
                                GestureDetector(
                                  onTap: () => controller.editRole.value
                                      ? _showProvincePickerSheet(
                                          ProvinceLevel.DISTRICT)
                                      : null,
                                  child: Container(
                                    width: Get.width - 32,
                                    height: AppSize.kButtonHeight,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppSize.kPadding),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppSize.kRadius),
                                      border: Border.all(
                                        color: controller.editRole.value
                                            ? AppColors.textColor
                                                .withOpacity(0.6)
                                            : AppColors.borderColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          isDistrictValid
                                              ? controller
                                                  .selectedDistrict.value.name!
                                              : "Chọn Quận / Huyện",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: AppColors.textColor
                                                    .withOpacity(isProvinceValid
                                                        ? 1
                                                        : 0.5),
                                              ),
                                        ),
                                        SvgPicture.asset(
                                          "assets/icons/arrow-bottom.svg",
                                          width: 24,
                                          colorFilter: ColorFilter.mode(
                                              AppColors.textColor
                                                  .withOpacity(0.5),
                                              BlendMode.srcIn),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              if (isProvinceValid) const SizedBox(height: 10),
                              if (isDistrictValid)
                                GestureDetector(
                                  onTap: () => controller.editRole.value
                                      ? _showProvincePickerSheet(
                                          ProvinceLevel.WARD)
                                      : null,
                                  child: Container(
                                    width: Get.width - 32,
                                    height: AppSize.kButtonHeight,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppSize.kPadding),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppSize.kRadius),
                                      border: Border.all(
                                        color: controller.editRole.value
                                            ? AppColors.textColor
                                                .withOpacity(0.6)
                                            : AppColors.borderColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          isWardValid
                                              ? controller
                                                  .selectedWards.value.name!
                                              : "Chọn Phường / Xã",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: AppColors.textColor
                                                    .withOpacity(isProvinceValid
                                                        ? 1
                                                        : 0.5),
                                              ),
                                        ),
                                        SvgPicture.asset(
                                          "assets/icons/arrow-bottom.svg",
                                          width: 24,
                                          colorFilter: ColorFilter.mode(
                                              AppColors.textColor
                                                  .withOpacity(0.5),
                                              BlendMode.srcIn),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                    _buildSheetItem(
                      context,
                      "Số điện thoại",
                      TextFieldComponent(
                        enabled: controller.editRole.value,
                        controller: controller.phoneNumberController,
                        hintText: "Nhập số điện thoại",
                        radius: AppSize.kRadius,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    _buildSheetItem(
                      context,
                      "Tiểu sử",
                      TextFieldComponent(
                        enabled: controller.editRole.value,
                        controller: controller.descController,
                        hintText: "Nhập tiểu sử",
                        radius: AppSize.kRadius,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: 100,
                        minLines: 5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.kPadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Đã mất?",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Obx(() => Transform.scale(
                                scale: 0.75,
                                child: CupertinoSwitch(
                                  value: controller.isDead.value,
                                  onChanged: (value) {
                                    if (controller.editRole.value) {
                                      controller.isDead.value = value;
                                    }
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                              )),
                        ],
                      ),
                    ),
                    _buildIsDeadComponent(context, controller),
                    const SizedBox(height: 75),
                  ],
                ),
              ),
            ),
          ),
          if (controller.editRole.value)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSize.kPadding),
                color: AppColors.backgroundColor,
                child: CustomButton(
                  text: controller.sheetMode == SheetMode.ADD
                      ? "Thêm thành viên"
                      : "Cập nhật",
                  onPressed: () => controller.sheetMode == SheetMode.ADD
                      ? controller.addTreeMember()
                      : controller.updateTreeMember(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildIsDeadComponent(
      BuildContext context, AddUserController controller) {
    return Obx(() => controller.isDead.value
        ? Column(
            children: [
              _buildSheetItem(
                context,
                "Ngày mất",
                Obx(() => _buildDatePicker(
                    context,
                    "Chọn ngày mất ",
                    controller.deathday.value,
                    controller.showDeathdayPickerDialog)),
              ),
              _buildSheetItem(
                context,
                "Thờ cúng tại",
                TextFieldComponent(
                  enabled: controller.editRole.value,
                  controller: controller.placeOfWorshipController,
                  hintText: "Nhập nơi thờ cúng",
                  radius: AppSize.kRadius,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
              ),
              _buildSheetItem(
                context,
                "Người phụ trách",
                TextFieldComponent(
                  enabled: controller.editRole.value,
                  controller: controller.personInChargeController,
                  hintText: "Nhập tên người phụ trách",
                  radius: AppSize.kRadius,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
              ),
              _buildSheetItem(
                context,
                "Mộ táng",
                TextFieldComponent(
                  enabled: controller.editRole.value,
                  controller: controller.burialController,
                  hintText: "Nhập nơi an lạc (chôn cất)",
                  radius: AppSize.kRadius,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                ),
              ),
            ],
          )
        : Container());
  }

  GestureDetector _buildDatePicker(
      BuildContext context, String hintText, DateTime? date, Function() onTap) {
    // Only calculate lunarDates if date is not null
    final lunarDates = date != null
        ? convertSolar2Lunar(date.day, date.month, date.year, 7)
        : null;

    return GestureDetector(
      onTap: controller.editRole.value ? onTap : null,
      child: Container(
        width: Get.width - 32,
        height: AppSize.kButtonHeight,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.kRadius),
          border: Border.all(
            color: controller.editRole.value
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
          controller.editRole.value ? _showMediaPickerBottomSheet() : null,
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
              child: controller.sheetMode == SheetMode.ADD ||
                      controller.croppedData.value != null
                  ? Obx(() => ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.kRadius),
                        child: controller.croppedData.value != null
                            ? Image.file(
                                File(controller.croppedData.value!.path),
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              )
                            : Image.asset(
                                "assets/images/default-avatar.webp",
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                      ))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.kRadius),
                      child: controller.selectedTreeMember?.avatar != null
                          ? Image.network(
                              "${controller.selectedTreeMember!.avatar}",
                              fit: BoxFit.cover,
                              width: 80,
                              height: 80,
                            )
                          : Image.asset(
                              "assets/images/default-avatar.webp",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                    ),
            ),
            const SizedBox(width: 16),
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
            const SizedBox(height: 8),
            child,
          ]),
    );
  }
}
