import 'package:get/get.dart';

import 'feed.controller.dart';

class FeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedController>(() => FeedController());
  }
}
