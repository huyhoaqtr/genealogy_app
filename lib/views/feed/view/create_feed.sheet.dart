import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/common/network_image.dart';
import 'package:getx_app/utils/widgets/icon_button.common.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';
import 'package:getx_app/views/event/create_event.sheet.dart';
import 'package:getx_app/views/feed/feed.controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../constants/app_colors.dart';
import '../../../resources/api/feed.api.dart';
import '../../../resources/models/feed.model.dart';
import '../../../utils/widgets/dialog/dialog.helper.dart';
import '../../../utils/widgets/media/media_picker.dart';
import '../../my-post/my-post.controller.dart';

class CreateFormController extends GetxController {
  final Rx<TextEditingController> contentController =
      TextEditingController().obs;
  RxList<File> tempImages = RxList<File>([]);
  RxList<String> tempImageUrls = RxList<String>([]);
  RxList<String> removeImageUrls = RxList<String>([]);
  final ImagePicker _picker = ImagePicker();

  final LoadingController loadingController = Get.find();

  final SheetMode sheetMode;
  final Feed? feed;

  CreateFormController({
    required this.sheetMode,
    this.feed,
  });
  @override
  void onInit() {
    super.onInit();
    if (sheetMode == SheetMode.EDIT) {
      contentController.value.text = feed!.content ?? "";
      tempImageUrls.addAll(feed!.images ?? []);
    }
  }

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
    try {
      final response = await FeedApi().createNewFeed(
        content: contentController.value.text,
        files: tempImages,
      );
      if (response.statusCode == 201) {
        Get.back();
        if (Get.isRegistered<FeedController>()) {
          final FeedController feedController = Get.find();

          feedController.feeds.insert(0, response.data!);
        }
      }
    } catch (e) {
      print(e);
      DialogHelper.showToast(
          "Có lỗi xảy ra, vui lòng thử lại sau", ToastType.warning);
    } finally {
      loadingController.hide();
    }
  }

  Future<void> updateFeed() async {
    FocusManager.instance.primaryFocus?.unfocus();
    loadingController.show();
    try {
      final response = await FeedApi().updateFeed(
        feedId: feed!.sId!,
        content: contentController.value.text,
        files: tempImages,
        deleteImages: removeImageUrls,
      );

      if (response.statusCode == 200) {
        Get.back();

        if (Get.isRegistered<FeedController>()) {
          final FeedController feedController = Get.find();
          int index = feedController.feeds
              .indexWhere((element) => element.sId == feed!.sId);
          if (index != -1) {
            feedController.feeds[index] = response.data!;
          }
          feedController.feeds.refresh();
        }

        if (Get.isRegistered<MyPostController>()) {
          final MyPostController myPostController = Get.find();
          int index = myPostController.feeds
              .indexWhere((element) => element.sId == feed!.sId);
          if (index != -1) {
            myPostController.feeds[index] = response.data!;
          }
          myPostController.feeds.refresh();
        }
      }
    } catch (e) {
      print(e);
      DialogHelper.showToast(
          "Có lỗi xảy ra, vui lòng thử lại sau", ToastType.warning);
    } finally {
      loadingController.hide();
    }
  }

  void removeOldImage(String image) {
    tempImageUrls.remove(image);
    removeImageUrls.add(image);
  }
}

class CreateFeedForm extends GetView<CreateFormController> {
  const CreateFeedForm({super.key});
  final int maxImages = 3;

  void _showMediaPickerBottomSheet() {
    if (Get.isRegistered<MediaPickerController>()) {
      Get.put(() => MediaPickerController(
            requestType: RequestType.image,
            maxSelectedCount: maxImages -
                (controller.tempImages.length +
                    controller.tempImageUrls.length),
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

      for (final asset in mediaPickerController.selectedAssets) {
        final file = await asset.file;
        if (file != null) {
          controller.tempImages.value.add(file);
          controller.tempImages.refresh();
        }
      }
    }).then((value) {
      Future.delayed(const Duration(milliseconds: 200), () {
        Get.delete<MediaPickerController>();
      });
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
                        child: Wrap(spacing: AppSize.kPadding / 2, children: [
                          ...controller.tempImages.map(
                              (e) => _buildTempImage(e)) // Xử lý tempImages
                          ,
                          ...controller.tempImageUrls.map(
                              (e) => _buildTempImage(e)) // Xử lý tempImagePath
                          ,
                        ]),
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
    return Obx(() => (controller.tempImages.length +
                controller.tempImageUrls.length) <
            maxImages
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
                text: controller.sheetMode == SheetMode.ADD
                    ? "Đăng bài"
                    : "Cập nhật",
                onPressed: () => controller.sheetMode == SheetMode.ADD
                    ? controller.createNewFeed()
                    : controller.updateFeed(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTempImage(dynamic image) {
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
            Positioned.fill(child: imageWidget(image)),
            Positioned(
              top: 0,
              right: 0,
              child: IconButtonComponent(
                iconPath: 'assets/icons/cross.svg',
                iconSize: 20,
                iconPadding: 2,
                onPressed: () => image is File
                    ? controller.tempImages.remove(image)
                    : controller.removeOldImage(image),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget imageWidget(dynamic image) {
    if (image is File) {
      return Positioned.fill(child: Image.file(image, fit: BoxFit.cover));
    } else if (image is String) {
      return Positioned.fill(child: CustomNetworkImage(imageUrl: image));
    } else {
      return Positioned.fill(child: Container(color: Colors.grey));
    }
  }
}
