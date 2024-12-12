import 'package:get/get.dart';
import 'package:getx_app/views/feed-detail/feed.detail.controller.dart';

class FeedDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedDetailController>(() => FeedDetailController());
  }
}
