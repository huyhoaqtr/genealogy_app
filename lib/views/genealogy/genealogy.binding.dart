import 'package:get/get.dart';

import 'genealogy.controller.dart';

class GenealogyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenealogyController>(() => GenealogyController());
  }
}
