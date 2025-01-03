import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/api/tribe.api.dart';
import 'package:getx_app/resources/models/tree_member.model.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../constants/app_size.dart';
import '../../../resources/models/province.dart';
import '../../../utils/widgets/dialog/dialog.helper.dart';
import '../../../utils/widgets/loading/loading.controller.dart';
import '../family-tree.controller.dart';

enum AddUserMode { ROOT, CHILD, COUPLE }

enum SheetMode { EDIT, ADD }

class AddUserController extends GetxController {
  late Rx<CroppedFile?> croppedData;
  late Rx<DateTime?> birthday;
  late Rx<DateTime?> deathday;
  RxBool editRole = false.obs;
  RxBool isDead = false.obs;
  RxString gender = "".obs;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController positionXController = TextEditingController();
  TextEditingController positionYController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController burialController = TextEditingController();
  TextEditingController personInChargeController = TextEditingController();
  TextEditingController placeOfWorshipController = TextEditingController();

  RxString fullNameError = "".obs;
  RxString genderError = "".obs;

  Rx<Province> selectedProvince = Rx<Province>(Province());
  Rx<TreeMember> selectedUser = Rx<TreeMember>(TreeMember());
  Rx<Districts> selectedDistrict = Rx<Districts>(Districts());
  Rx<Wards> selectedWards = Rx<Wards>(Wards());

  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final LoadingController loadingController = Get.find<LoadingController>();

  final AddUserMode mode;
  final SheetMode sheetMode;
  final TreeMember? selectedTreeMember;
  AddUserController(
      {required this.sheetMode, required this.mode, this.selectedTreeMember});

  double frameWidth = 360 - AppSize.kPadding * 3;
  double frameHeight = (360 - AppSize.kPadding) * (2 / 3) - 360 * (0.8 / 4.5);

  @override
  void onInit() {
    super.onInit();
    croppedData = Rx<CroppedFile?>(null);
    birthday = Rx<DateTime?>(null);
    deathday = Rx<DateTime?>(null);

    if (selectedTreeMember != null && sheetMode == SheetMode.EDIT) {
      fullNameController.text = selectedTreeMember!.fullName ?? "";
      titleController.text = selectedTreeMember!.title ?? "";
      positionXController.text = selectedTreeMember!.positionX.toString();
      positionYController.text = selectedTreeMember!.positionY.toString();
      phoneNumberController.text = selectedTreeMember!.phoneNumber ?? "";
      descController.text = selectedTreeMember!.description ?? "";
      isDead.value = selectedTreeMember!.isDead ?? false;
      burialController.text = selectedTreeMember!.burial ?? "";
      personInChargeController.text = selectedTreeMember!.personInCharge ?? "";
      placeOfWorshipController.text = selectedTreeMember!.placeOfWorship ?? "";
      if (selectedTreeMember!.dateOfBirth != null) {
        birthday.value = DateTime.parse(selectedTreeMember!.dateOfBirth!);
      }
      if (selectedTreeMember!.dateOfDeath != null) {
        deathday.value = DateTime.parse(selectedTreeMember!.dateOfDeath!);
      }
      if (selectedTreeMember!.parent != null) {
        if (Get.isRegistered<FamilyTreeController>()) {
          final FamilyTreeController familyTreeController =
              Get.find<FamilyTreeController>();
          selectedUser.value = familyTreeController.blocks.firstWhere(
            (block) => block.sId == selectedTreeMember!.parent,
          );
        }
      }

      if (selectedTreeMember?.address != null) {
        final address = selectedTreeMember?.address!.split(",");

        if (address!.isNotEmpty) {
          selectedProvince.value = Province(name: address[0].trim());
        }
        if (address.length > 1) {
          selectedDistrict.value = Districts(name: address[1].trim());
        }
        if (address.length > 2) {
          selectedWards.value = Wards(name: address[2].trim());
        }
      }

      gender.value = selectedTreeMember!.gender ?? "";
    }

    editRole.value = dashboardController.myInfo.value.role == "ADMIN" ||
        dashboardController.myInfo.value.role == "LEADER";
  }

  void cropImage(String filePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    );

    if (croppedFile != null) {
      croppedData.value = croppedFile;
    }
  }

  void showBirthdayPickerDialog() {
    DialogHelper.showDatePickerDialog(
        initialDate: birthday.value,
        onSelectedDate: (value) {
          birthday.value = value;
        });
  }

  void showDeathdayPickerDialog() {
    DialogHelper.showDatePickerDialog(
        initialDate: deathday.value,
        onSelectedDate: (value) {
          deathday.value = value;
        });
  }

  bool validateFields() {
    bool isValid = true;

    if (fullNameController.text.trim().isEmpty) {
      fullNameError.value = 'Họ và tên là bắt buộc';
      isValid = false;
    } else {
      fullNameError.value = "";
    }

    if (gender.value.isEmpty) {
      genderError.value = 'Vui lòng chọn giới tính';
      isValid = false;
    } else {
      genderError.value = "";
    }

    return isValid;
  }

  double calculatePositionX(TreeMember? parentMember) {
    if (parentMember != null && parentMember.sId != null) {
      double parentX = parentMember.positionX ?? 0.0;
      int childrenCount = parentMember.children?.length ?? 0;

      double positionX;
      if (childrenCount == 0) {
        positionX = parentX;
      } else if (childrenCount == 1) {
        positionX = min(parentX + 35, frameWidth);
      } else if ((childrenCount + 1) % 2 == 1) {
        positionX = max(parentX - ((childrenCount - 1) * 35), 0);
      } else {
        positionX = min(parentX + ((childrenCount - 1) * 35), frameWidth);
      }
      return double.parse(positionX.toStringAsFixed(1));
    }

    return (frameWidth / 2);
  }

  double calculatePositionY(TreeMember? parentMember) {
    if (parentMember != null && parentMember.sId != null) {
      double parentY = parentMember.positionY ?? 0;
      double positionY =
          min(parentY + (25.0 - min(parentMember.level!, 5) * 2), frameHeight);
      return double.parse(positionY.toStringAsFixed(1));
    }

    return 15.0;
  }

  String getFullAddress() {
    List<String> addressParts = [];

    if (selectedProvince.value.name != null) {
      addressParts.add(selectedProvince.value.name!);
    }
    if (selectedDistrict.value.name != null) {
      addressParts.add(selectedDistrict.value.name!);
    }
    if (selectedWards.value.name != null) {
      addressParts.add(selectedWards.value.name!);
    }

    return addressParts.join(', ');
  }

  Future<void> addTreeMember() async {
    loadingController.show();
    try {
      if (validateFields()) {
        final response = await TribeAPi().createTreeMember(
          fullName: fullNameController.text,
          gender: gender.value,
          title: titleController.text != "" ? titleController.text : null,
          positionX: double.tryParse(positionXController.text != ""
              ? positionXController.text
              : (calculatePositionX(selectedUser.value)).toString()),
          positionY: double.tryParse(
            positionYController.text != ""
                ? positionYController.text
                : calculatePositionY(selectedUser.value).toString(),
          ),
          isDead: isDead.value,
          placeOfWorship: placeOfWorshipController.text != ""
              ? placeOfWorshipController.text
              : null,
          personInCharge: personInChargeController.text != ""
              ? personInChargeController.text
              : null,
          burial: burialController.text != "" ? burialController.text : null,
          address:
              selectedProvince.value != Province() ? getFullAddress() : null,
          dateOfBirth: birthday.value?.toIso8601String(),
          dateOfDeath: deathday.value?.toIso8601String(),
          description: descController.text != "" ? descController.text : null,
          parent: (mode == AddUserMode.CHILD && selectedUser.value.sId != "")
              ? selectedUser.value.sId
              : null,
          couple: (mode == AddUserMode.COUPLE && selectedUser.value.sId != "")
              ? selectedUser.value.sId
              : null,
          phoneNumber: phoneNumberController.text != ""
              ? phoneNumberController.text
              : null,
          avatar:
              croppedData.value != null ? File(croppedData.value!.path) : null,
        );

        if (response.statusCode == 200) {
          Get.back();
          DialogHelper.showToast(
            "Tạo thành viên thành công",
            ToastType.success,
          );

          if (Get.isRegistered<FamilyTreeController>()) {
            final FamilyTreeController familyTreeController =
                Get.find<FamilyTreeController>();
            familyTreeController.fetchBlocks();
          }
        }
      }
    } catch (e) {
      print(e);
      DialogHelper.showToast(
        "Có lỗi xây ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      loadingController.hide();
    }
  }

  Future<void> updateTreeMember() async {
    loadingController.show();
    try {
      if (validateFields() && selectedTreeMember?.sId != null) {
        final response = await TribeAPi().updateTreeMember(
          id: selectedTreeMember!.sId!,
          fullName: fullNameController.text,
          gender: gender.value,
          title: titleController.text != "" ? titleController.text : null,
          positionX: double.tryParse(positionXController.text != ""
              ? positionXController.text
              : (calculatePositionX(selectedUser.value)).toString()),
          positionY: double.tryParse(
            positionYController.text != ""
                ? positionYController.text
                : calculatePositionY(selectedUser.value).toString(),
          ),
          isDead: isDead.value,
          placeOfWorship: placeOfWorshipController.text != ""
              ? placeOfWorshipController.text
              : null,
          personInCharge: personInChargeController.text != ""
              ? personInChargeController.text
              : null,
          burial: burialController.text != "" ? burialController.text : null,
          address:
              selectedProvince.value != Province() ? getFullAddress() : null,
          dateOfBirth: birthday.value?.toIso8601String(),
          dateOfDeath: deathday.value?.toIso8601String(),
          description: descController.text != "" ? descController.text : null,
          parent: (mode == AddUserMode.CHILD && selectedUser.value.sId != "")
              ? selectedUser.value.sId
              : null,
          couple: (mode == AddUserMode.COUPLE && selectedUser.value.sId != "")
              ? selectedUser.value.sId
              : null,
          phoneNumber: phoneNumberController.text != ""
              ? phoneNumberController.text
              : null,
          avatar:
              croppedData.value != null ? File(croppedData.value!.path) : null,
        );

        if (response.statusCode == 200) {
          Get.back();

          DialogHelper.showToast(
            "Câp nhật thành công",
            ToastType.success,
          );
          if (Get.isRegistered<FamilyTreeController>()) {
            final FamilyTreeController familyTreeController =
                Get.find<FamilyTreeController>();
            familyTreeController.fetchBlocks();
          }
        }
      }
    } catch (e) {
      print(e);
      DialogHelper.showToast(
        "Có lỗi xây ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      loadingController.hide();
    }
  }

  Future<void> deleteTreeMember() async {
    loadingController.show();
    try {
      final response =
          await TribeAPi().deleteTreeMember(id: selectedTreeMember!.sId!);
      if (response.statusCode == 200) {
        Get.back();
        DialogHelper.showToast(
          "Xóa thành viên thành công",
          ToastType.success,
        );
        if (Get.isRegistered<FamilyTreeController>()) {
          final FamilyTreeController familyTreeController =
              Get.find<FamilyTreeController>();
          familyTreeController.fetchBlocks();
        }
      }
    } catch (e) {
      print(e);
      DialogHelper.showToast(
        "Có lỗi xây ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      loadingController.hide();
    }
  }

  void toggleIsDead() {
    isDead.value = !isDead.value;
  }
}
