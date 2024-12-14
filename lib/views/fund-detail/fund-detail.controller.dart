import 'package:get/get.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';

import '../../resources/api/fund.api.dart';
import '../../resources/models/fund.model.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';

class FundDetailController extends GetxController {
  Rx<Fund> fund = Rx<Fund>(Fund());
  final LoadingController loadingController = Get.find();

  @override
  Future<void> onInit() async {
    super.onInit();

    final fundId = Get.arguments['fundId'];
    if (fundId != null) {
      await getFundDetail(fundId);
    }
  }

  Future<void> getFundDetail(String fundId) async {
    final response = await FundApi().getFundDetail(id: fundId);
    if (response.statusCode == 200) {
      fund.value = response.data ?? Fund();
    }
  }

  Future<void> createTransaction({
    required String type,
    required String desc,
    required String amount,
  }) async {
    loadingController.show();
    try {
      final response = await FundApi().createTransaction(
        fundId: fund.value.sId!,
        type: type,
        desc: desc,
        amount: amount,
      );
      if (response.statusCode == 200) {
        await getFundDetail(fund.value.sId!);
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
