import 'package:get/get.dart';

import 'church.controller.dart';

class ChurchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChurchController>(() => ChurchController());
  }
}
