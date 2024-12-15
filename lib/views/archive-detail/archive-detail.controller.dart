import 'package:get/get.dart';

import '../../resources/models/web3-transaction.model.dart';

class ArchiveDetailController extends GetxController {
  Rx<Web3Transaction> transaction = Rx<Web3Transaction>(Web3Transaction());

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['transaction'] != null) {
      print(Get.arguments['transaction']);
      transaction.value =
          Web3Transaction.fromJson(Get.arguments['transaction']);
    }
  }
}
