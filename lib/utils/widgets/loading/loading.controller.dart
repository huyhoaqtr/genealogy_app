import 'package:get/get.dart';

class LoadingController extends GetxController {
  var isLoading = false.obs;

  void show() {
    isLoading.value = true;
  }

  void hide() {
    isLoading.value = false;
  }
}
