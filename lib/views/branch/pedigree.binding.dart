import 'package:get/get.dart';

import 'pedigree.controller.dart';

class PedigreeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PedigreeController>(() => PedigreeController());
  }
}
