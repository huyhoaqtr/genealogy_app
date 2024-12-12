import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/dialog/dialog.helper.dart';

import '../../views/dashboard/dashboard.controller.dart';

class IntroduceController extends GetxController {
  final DashboardController dashboardController = Get.find();

  void copyTribeCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    DialogHelper.showToast(
      "Mã gia tộc đã được sao chép vào clipboard.",
      ToastType.success,
    );
  }
}
