import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/icon_button.common.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';
import 'package:getx_app/views/feed/feed.controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../constants/app_colors.dart';
import '../../../resources/api/feed.api.dart';
import '../../../utils/widgets/media/media_picker.dart';

class CreateFormController extends GetxController {
  final Rx<TextEditingController> contentController =
      TextEditingController().obs;
  RxList<File> tempImages = RxList<File>([]);
  final ImagePicker _picker = ImagePicker();

  final LoadingController loadingController = Get.find();
  final FeedController feedController = Get.find();

  Future<void> openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      tempImages.add(File(photo.path));
    } else {
      print('Camera closed without taking a photo.');
    }
  }

  Future<void> createNewFeed() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingController.show();
    final response = await FeedApi().createNewFeed(
      content: contentController.value.text,
      files: tempImages,
    );
    if (response.statusCode == 201) {
      Get.back();
      feedController.feeds.insert(0, response.data!);
    }
    loadingController.hide();
  }
}

class CreateFeedForm extends GetView<CreateFormController> {
  const CreateFeedForm({super.key});
  final int maxImages = 3;

  void _showMediaPickerBottomSheet() {
    Get.lazyPut(() => MediaPickerController(
          requestType: RequestType.image,
          maxSelectedCount: maxImages - controller.tempImages.length,
        ));
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

      for (final asset in mediaPickerController.selectedAssets) {
        final file = await asset.file;
        if (file != null) {
          controller.tempImages.value.add(file);
          controller.tempImages.refresh();
        }
      }
    }).then((value) {
      Get.delete<MediaPickerController>();
    });
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
        top: 5.h,
        bottom: 16 - MediaQuery.of(context).viewInsets.bottom * 0.05,
      ),
      child: Stack(children: [
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
        Positioned(
          top: 10.h,
          left: 0,
          right: 0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(context),
                Obx(() => Container(
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.kPadding,
                        vertical: AppSize.kPadding / 2,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Wrap(
                            spacing: AppSize.kPadding / 2,
                            children: controller.tempImages
                                .map((e) => _buildTempImage(e))
                                .toList()),
                      ),
                    )),
                _buildPickerGroup(),
                SizedBox(
                  height:
                      MediaQuery.of(context).viewInsets.bottom > 0 ? 60.h : 0,
                )
              ],
            ),
          ),
        ),
        _buildBottomGroupButton(context),
      ]),
    );
  }

  Widget _buildPickerGroup() {
    return Obx(() => controller.tempImages.length < maxImages
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
            child: Row(children: [
              IconButtonComponent(
                iconPath: 'assets/icons/gallery.svg',
                onPressed: () => _showMediaPickerBottomSheet(),
                iconSize: 28,
                iconPadding: 4,
              ),
              const SizedBox(width: AppSize.kPadding),
              IconButtonComponent(
                iconPath: 'assets/icons/camera.svg',
                onPressed: () => controller.openCamera(),
                iconSize: 28,
                iconPadding: 4,
              ),
            ]),
          )
        : Container());
  }

  SizedBox _buildTextField(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: TextField(
        controller: controller.contentController.value,
        cursorHeight: 16,
        cursorColor: AppColors.primaryColor,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        maxLines: 13,
        minLines: 1,
        maxLength: 1000,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: const EdgeInsets.all(AppSize.kPadding),
          hintText: "Bạn đang nghĩ gì?",
          hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.textColor.withOpacity(0.5),
              ),
        ),
      ),
    );
  }

  Positioned _buildBottomGroupButton(BuildContext context) {
    return Positioned(
      left: AppSize.kPadding,
      right: AppSize.kPadding,
      bottom: MediaQuery.of(context).viewInsets.bottom + AppSize.kPadding,
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width:
                  (Get.width - AppSize.kPadding * 2) / 2 - AppSize.kPadding / 2,
              child: CustomButton(
                text: "Huỷ",
                onPressed: () => Get.back(),
                isOutlined: true,
              ),
            ),
            SizedBox(
              width:
                  (Get.width - AppSize.kPadding * 2) / 2 - AppSize.kPadding / 2,
              child: CustomButton(
                text: "Đăng bài",
                onPressed: () => controller.createNewFeed(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTempImage(File e) {
    return Container(
      width: 100.w,
      height: 150.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.kRadius),
          color: Colors.grey.withOpacity(0.1),
          border: Border.all(
            width: 0.5,
            color: AppColors.borderColor,
          )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.kRadius),
        child: Stack(
          children: [
            Positioned.fill(child: Image.file(e, fit: BoxFit.cover)),
            Positioned(
              top: 0,
              right: 0,
              child: IconButtonComponent(
                iconPath: 'assets/icons/cross.svg',
                iconSize: 20,
                iconPadding: 2,
                onPressed: () => controller.tempImages.remove(e),
              ),
            )
          ],
        ),
      ),
    );
  }
}
