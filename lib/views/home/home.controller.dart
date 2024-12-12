import 'package:get/get.dart';
import 'package:getx_app/views/dashboard/dashboard.controller.dart';

class HomeController extends GetxController {
  final DashboardController dashboardController = Get.find();
  @override
  Future<void> onInit() async {
    super.onInit();
  }
}
