import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/widgets/icon_button.common.dart';
import 'pedigree.controller.dart';

class PedigreeScreen extends GetView<PedigreeController> {
  const PedigreeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PedigreeScreen'),
        leading: IconButtonComponent(
          iconPath: 'assets/icons/arrow-left.svg',
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: Get.width,
            child: const Column(
              children: [
                Text('PedigreeScreen'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
