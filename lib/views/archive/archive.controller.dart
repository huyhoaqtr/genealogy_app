import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../resources/api/tribe.api.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../resources/models/web3-transaction.model.dart';

class ArchiveController extends GetxController {
  RxList<Web3Transaction> transactions = <Web3Transaction>[].obs;
  final ScrollController scrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt limit = 36.obs;
  RxInt totalPage = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    getTransactions();
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        await getMoreTransactions();
      }
    });
  }

  Future<void> getTransactions() async {
    isLoading.value = true;
    try {
      final response = await TribeAPi().getAllTransactionByTribe(
        page: page.value,
        limit: limit.value,
      );
      if (response.statusCode == 200) {
        transactions.value = response.data!.data!;
        totalPage.value = response.data!.meta!.totalPages!;
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getMoreTransactions() async {
    if (isLoadMore.value || page.value >= totalPage.value) return;
    page.value++;
    isLoadMore.value = true;

    await getTransactions();

    isLoadMore.value = false;
  }
}
