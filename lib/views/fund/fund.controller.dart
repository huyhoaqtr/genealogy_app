import 'package:get/get.dart';

import '../../resources/api/fund.api.dart';
import '../../resources/models/fund.model.dart';

class FundController extends GetxController {
  RxList<Fund> funds = <Fund>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getFunds();
  }

  //call api
  Future<void> getFunds() async {
    final response = await FundApi().getAllFund();
    if (response.statusCode == 200) {
      funds.value = response.data ?? [];
    }
  }

  //create fund
  Future<void> createFund({
    required String title,
    required String desc,
    required String amount,
  }) async {
    final response = await FundApi().createFund(
      title: title,
      desc: desc,
      amount: amount,
    );
    if (response.statusCode == 200) {
      funds.insert(0, response.data ?? Fund());
    }
  }
}
