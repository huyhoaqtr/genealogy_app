import 'package:get/get.dart';

import 'archive.controller.dart';

class ArchiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArchiveController>(() => ArchiveController());
  }
}
