import 'package:get/get.dart';

import 'archive-detail.controller.dart';

class ArchiveDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArchiveDetailController>(() => ArchiveDetailController());
  }
}
