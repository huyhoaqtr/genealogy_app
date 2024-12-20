import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/utils/widgets/progress_indicator.dart';
import 'package:getx_app/utils/widgets/text_button.common.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../constants/app_colors.dart';
import '../../../services/media/media_services.dart';

class MediaPickerController extends GetxController {
  RxList<AssetEntity> assets = <AssetEntity>[].obs;
  RxList<AssetEntity> selectedAssets = <AssetEntity>[].obs;
  RxBool isLoading = false.obs;
  final cache = <String, Uint8List>{}.obs;

  final RequestType requestType;
  final int maxSelectedCount;

  MediaPickerController(
      {required this.requestType, required this.maxSelectedCount});

  @override
  void onInit() {
    super.onInit();
    _loadAlbums();
  }

  Future<Uint8List?> getImage(AssetEntity assetEntity) async {
    final key = assetEntity.id;
    if (cache.containsKey(key)) {
      return cache[key];
    } else {
      final data = await assetEntity.thumbnailDataWithSize(
        const ThumbnailSize.square(500),
      );
      if (data != null) {
        cache[key] = data;
      }
      return data;
    }
  }

  void _loadAlbums() async {
    isLoading.value = true;
    final albumList = await MediaServices().loadAlbum(requestType);
    if (albumList.isNotEmpty) {
      _loadAssets(albumList[0]);
    }
    isLoading.value = false;
  }

  void _loadAssets(AssetPathEntity album) async {
    final assetList = await MediaServices().loadAssets(album);
    assets.assignAll(assetList);
  }

  void toggleSelection(AssetEntity asset) {
    if (selectedAssets.contains(asset)) {
      selectedAssets.remove(asset);
    } else {
      if (selectedAssets.length < maxSelectedCount) {
        selectedAssets.add(asset);
      }
    }
  }
}

class MediaPicker extends StatelessWidget {
  final MediaPickerController controller = Get.find<MediaPickerController>();
  MediaPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height * 0.85,
      padding: const EdgeInsets.symmetric(
          vertical: AppSize.kPadding / 2, horizontal: AppSize.kPadding / 2),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.kRadius * 2),
          topRight: Radius.circular(AppSize.kRadius * 2),
        ),
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.kRadius * 2),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const ProgressIndicatorComponent();
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.assets.length,
                  itemBuilder: (context, index) {
                    AssetEntity assetEntity = controller.assets[index];
                    return Padding(
                      padding: const EdgeInsets.all(0.5),
                      child: KeyedSubtree(
                          key: ValueKey(assetEntity.id),
                          child: _buildAssetWidget(assetEntity, controller)),
                    );
                  },
                );
              }),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Obx(() => CustomButton(
                  text: "Xong",
                  onPressed: () => Get.back(),
                  disabled: controller.selectedAssets.isEmpty,
                )),
          )
        ],
      ),
    );
  }

  Widget _buildAssetWidget(
      AssetEntity assetEntity, MediaPickerController controller) {
    return GestureDetector(
      onTap: () => controller.toggleSelection(assetEntity),
      child: Stack(
        children: [
          FutureBuilder<Uint8List?>(
            future: controller.getImage(assetEntity),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  ),
                );
              }
              return Center(
                  child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryColor,
                ),
              ));
            },
          ),
          Obx(() {
            bool isSelected = controller.selectedAssets.contains(assetEntity);
            bool maxSelected =
                controller.selectedAssets.length >= controller.maxSelectedCount;
            return isSelected
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.25),
                  )
                : maxSelected
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white.withOpacity(0.45),
                      )
                    : Container();
          }),
          Positioned(
            top: 5,
            right: 5,
            child: Obx(() {
              final isSelected =
                  controller.selectedAssets.contains(assetEntity);
              return Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isSelected
                      ? Text(
                          (controller.selectedAssets.indexOf(assetEntity) + 1)
                              .toString(),
                          style: Theme.of(Get.context!)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        )
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
