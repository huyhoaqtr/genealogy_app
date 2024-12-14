// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Node;
import 'package:getx_app/constants/app_size.dart';
import 'package:getx_app/resources/api/tribe.api.dart';
import 'package:getx_app/resources/models/tree_member.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../utils/widgets/loading/loading.controller.dart';

enum ScreenMode { VIEW, EDIT }

class FamilyTreeController extends GetxController {
  RxBool isLoading = false.obs;
  late TransformationController transformationController;
  RxList<TreeMember> blocks = <TreeMember>[].obs;
  Rx<List<TreeMember>> tree = Rx<List<TreeMember>>([]);
  Rx<List<Map<String, dynamic>>> lines = Rx<List<Map<String, dynamic>>>([]);
  Rx<List<Map<String, dynamic>>> updatedLines =
      Rx<List<Map<String, dynamic>>>([]);
  final LoadingController loadingController = Get.find<LoadingController>();
  Rx<ScreenMode> isScreenMode = ScreenMode.VIEW.obs;
  RxBool isRotate = false.obs;

  double frameWidth = 360 - AppSize.kPadding * 3;
  double frameHeight = (360 - AppSize.kPadding) * (2 / 3) - 360 * (0.8 / 4.5);

  @override
  Future<void> onInit() async {
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    transformationController = TransformationController();
    transformationController.value = Matrix4.identity()..scale(1.0);
    await fetchBlocks();
  }

  Future<void> fetchBlocks() async {
    isLoading.value = true;
    try {
      final response = await TribeAPi().getTribeTree();

      if (response.statusCode == 200) {
        blocks.value = response.data ?? [];
        generateTree();
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xây ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generateTree() async {
    final Map<String?, TreeMember> mapById = {
      for (var block in blocks) block.sId: block
    };

    final List<TreeMember> roots = [];

    for (var block in blocks) {
      if (block.parent == null) {
        roots.add(block);
      } else {
        final parent = mapById[block.parent];
        if (parent != null) {
          parent.children ??= [];
          parent.children?.add(block);
        }
      }
    }

    tree.value = roots;
    _generateLines();
  }

  void _generateLines() {
    lines.value = [];
    updatedLines.value = [];
    for (var block in blocks) {
      if (block.parent != null) {
        final parentBlock = blocks.firstWhere((b) => b.sId == block.parent);
        lines.value.add({
          'start': Offset(
            parentBlock.positionX ?? 0.0,
            parentBlock.positionY ?? 0.0,
          ),
          'end': Offset(
            block.positionX ?? 0.0,
            block.positionY ?? 0.0,
          ),
        });
      }

      if (block.children != null) {
        for (var child in block.children!) {
          lines.value.add({
            'start': Offset(block.positionX ?? 0.0, block.positionY ?? 0.0),
            'end': Offset(child.positionX ?? 0.0, child.positionY ?? 0.0),
          });
        }
      }
    }
  }

  void updatePosition(String id, Offset offset) {
    if (isScreenMode.value == ScreenMode.VIEW) return;

    final block = blocks.firstWhere((b) => b.sId == id);

    if ((block.positionX ?? 0.0) + offset.dx >= 0 &&
        (block.positionX ?? 0.0) + offset.dx <= frameWidth &&
        (block.positionY ?? 0.0) + offset.dy >= 0 &&
        (block.positionY ?? 0.0) + offset.dy <= frameHeight) {
      lines.value.removeWhere((line) {
        final start = line['start'] as Offset;
        final end = line['end'] as Offset;

        return (start ==
                Offset(block.positionX ?? 0.0, block.positionY ?? 0.0) ||
            end == Offset(block.positionX ?? 0.0, block.positionY ?? 0.0));
      });

      block.positionX = (block.positionX ?? 0) + offset.dx;
      // block.positionY = (block.positionY ?? 0) + offset.dy;

      _updateLinesAffectedByBlock(id);
    }
  }

  void _updateLinesAffectedByBlock(String blockId) {
    updatedLines.value = [];
    final updatedBlock = blocks.firstWhere((b) => b.sId == blockId);

    if (updatedBlock.parent != null) {
      final parentBlock =
          blocks.firstWhere((b) => b.sId == updatedBlock.parent);
      updatedLines.value.add({
        'start': Offset(
          parentBlock.positionX ?? 0.0,
          parentBlock.positionY ?? 0.0,
        ),
        'end': Offset(
          updatedBlock.positionX ?? 0.0,
          updatedBlock.positionY ?? 0.0,
        ),
      });
    }

    if (updatedBlock.children != null) {
      for (var child in updatedBlock.children!) {
        updatedLines.value.add({
          'start': Offset(
            updatedBlock.positionX ?? 0.0,
            updatedBlock.positionY ?? 0.0,
          ),
          'end': Offset(
            child.positionX ?? 0.0,
            child.positionY ?? 0.0,
          ),
        });
      }
    }
  }

  final GlobalKey boundaryKey = GlobalKey();

  Future<void> capturePng() async {
    loadingController.show();
    try {
      final boundaryContext = boundaryKey.currentContext;
      if (boundaryContext != null) {
        RenderRepaintBoundary boundary =
            boundaryContext.findRenderObject() as RenderRepaintBoundary;

        ui.Image image = await boundary.toImage(pixelRatio: 10.0);

        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData != null) {
          Uint8List pngBytes = byteData.buffer.asUint8List();

          final directory = await getApplicationDocumentsDirectory();
          final imagePath =
              File('${directory.path}/family_tree_image_high_quality.png');

          await imagePath.writeAsBytes(pngBytes);

          final result = await ImageGallerySaver.saveFile(imagePath.path);

          if (result['isSuccess']) {
            DialogHelper.showToastDialog(
                "Thông báo", "Tải xuống ảnh thành công!");
          }
        } else {
          throw Exception('Failed to capture image.');
        }
      } else {
        throw Exception('Boundary key not found.');
      }
    } catch (e) {
      if (e is Exception) {
        DialogHelper.showToastDialog("Tải xuống thất bại", e.toString());
      }
      print('Error capturing image: $e');
    } finally {
      loadingController.hide();
    }
  }

  double calculateSize(int level) {
    const double baseSize = 35.0;
    const double minSize = 15.0;
    double size = baseSize - (level > 5 ? 5 : level) * 3.0;

    return size < minSize ? minSize : size;
  }

  Future<void> saveTribeTree() async {
    if (isScreenMode.value == ScreenMode.VIEW) {
      isScreenMode.value = ScreenMode.EDIT;
    } else {
      try {
        isScreenMode.value = ScreenMode.VIEW;
        loadingController.show();
        final List<Map<String, dynamic>> data = blocks
            .map((item) => {
                  'id': item.sId,
                  'positionX': item.positionX,
                  'positionY': item.positionY,
                })
            .toList();

        String payload = jsonEncode(data);
        await TribeAPi().updateAllTribePosition(payload: payload);
        // await fetchBlocks();
      } catch (e) {
        print("Error: $e");
        DialogHelper.showToast(
            "Có lỗi xảy ra, vui lòng thử lại sau", ToastType.warning);
      } finally {
        loadingController.hide();
      }
    }
  }

  void rotateFrame() {
    isRotate.value = !isRotate.value;
  }

  void allowLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void cancelEditTribeTree() {
    isScreenMode.value = ScreenMode.VIEW;
    fetchBlocks();
  }

  @override
  void onClose() {
    transformationController.dispose();
    blocks.clear();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.onClose();
  }

  void resetTransformation() {
    transformationController.value = Matrix4.identity()..scale(1.0);
    blocks.clear();
    tree.value = [];
    lines.value = [];
    updatedLines.value = [];
    fetchBlocks();
  }
}
