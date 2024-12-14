import 'package:get/get.dart';
import '../../utils/widgets/loading/loading.controller.dart';

import '../../resources/api/fund.api.dart';
import '../../resources/models/fund.model.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';

class FundController extends GetxController {
  RxList<Fund> funds = <Fund>[].obs;
  RxBool isLoading = true.obs;

  final LoadingController loadingController = Get.find();

  @override
  Future<void> onInit() async {
    super.onInit();
    await getFunds();
  }

  //call api
  Future<void> getFunds() async {
    try {
      isLoading.value = true;
      final response = await FundApi().getAllFund();
      if (response.statusCode == 200) {
        funds.value = response.data ?? [];
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  //create fund
  Future<void> createFund({
    required String title,
    required String desc,
    required String amount,
  }) async {
    loadingController.show();

    try {
      final response = await FundApi().createFund(
        title: title,
        desc: desc,
        amount: amount,
      );
      if (response.statusCode == 200) {
        funds.insert(0, response.data ?? Fund());
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      loadingController.hide();
    }
  }
}
