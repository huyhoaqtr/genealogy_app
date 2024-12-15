import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/constants/app_size.dart';
import '../../utils/widgets/icon_button.common.dart';
import 'archive.controller.dart';

class ArchiveScreen extends GetView<ArchiveController> {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kho lưu trữ"),
        leading: IconButtonComponent(
            iconPath: 'assets/icons/arrow-left.svg',
            onPressed: () => Get.back()),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.kPadding),
      ),
    );
  }
}
