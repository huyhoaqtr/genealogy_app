import 'package:get/get.dart';

import 'my-post.controller.dart';

class MyPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyPostController>(() => MyPostController());
  }
}
