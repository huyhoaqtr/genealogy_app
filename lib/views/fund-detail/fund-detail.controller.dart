import 'package:get/get.dart';

import '../../resources/api/fund.api.dart';
import '../../resources/models/fund.model.dart';

class FundDetailController extends GetxController {
  Rx<Fund> fund = Rx<Fund>(Fund());

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
    final response = await FundApi().createTransaction(
      fundId: fund.value.sId!,
      type: type,
      desc: desc,
      amount: amount,
    );
    if (response.statusCode == 200) {
      await getFundDetail(fund.value.sId!);
    }
  }
}
