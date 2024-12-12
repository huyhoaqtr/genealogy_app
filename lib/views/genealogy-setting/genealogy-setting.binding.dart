import 'package:get/get.dart';

import 'genealogy-setting.controller.dart';

class GenealogySettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenealogySettingController>(() => GenealogySettingController());
  }
}
