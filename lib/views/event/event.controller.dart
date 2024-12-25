import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/api/event.api.dart';
import 'package:getx_app/utils/widgets/loading/loading.controller.dart';

import '../../resources/models/event.model.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';

enum FilterStatus {
  all,
  currentDay,
  thisWeek,
  thisMonth,
  previousMonth,
  nextMonth,
}

class EventController extends GetxController {
  RxList<Event> events = RxList<Event>([]);
  Rx<FilterStatus> selectedFilter = FilterStatus.all.obs;
  RxBool isLoading = true.obs;
  RxBool isLoadMore = true.obs;
  RxInt page = 1.obs;
  RxInt limit = 36.obs;
  RxInt totalPages = 0.obs;
  CancelToken? cancelToken;
  final LoadingController loadingController = Get.find();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getAllEvents(FilterStatus.all, null);
    scrollController.addListener(() async {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50) {
        await loadMoreEvents();
      }
    });
  }

  Future<void> loadMoreEvents() async {
    await Future.delayed(const Duration(seconds: 3));
    if (isLoadMore.value || page.value >= totalPages.value) return;
    isLoadMore.value = true;
    try {
      page.value++;
      final response = await EventApi().getAllEvent(
        page: page.value,
        limit: limit.value,
        filter: selectedFilter.value,
      );

      if (response.statusCode == 201) {
        events.value += response.data?.data ?? [];
        totalPages.value = response.data?.meta?.totalPages ?? 1;
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xảy ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      isLoadMore.value = false;
    }
  }

  Future<void> getAllEvents(
      FilterStatus filter, CancelToken? cancelToken) async {
    try {
      isLoading.value = true;
      final response = await EventApi().getAllEvent(
        page: page.value,
        limit: limit.value,
        filter: filter,
        cancelToken: cancelToken,
      );

      if (response.statusCode == 201) {
        events.value = response.data?.data ?? [];
        totalPages.value = response.data?.meta?.totalPages ?? 1;
      }
    } catch (e) {
      print("Error: $e");
      if (CancelToken.isCancel(e as DioException)) {
        return print("API call canceled: ${e.message}");
      }
      DialogHelper.showToast(
        "Có lỗi xây ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeFilter(FilterStatus filter) async {
    cancelToken?.cancel("Request canceled due to filter change.");
    selectedFilter.value = filter;
    page.value = 1;
    events.clear();
    isLoading.value = true;
    cancelToken = CancelToken();
    await getAllEvents(filter, cancelToken);
    isLoading.value = false;
  }

  Future<void> deleteEvent(String id) async {
    try {
      final response = await EventApi().deleteEvent(eventId: id);

      if (response.statusCode == 200) {
        events.removeWhere((event) => event.sId == id);
        events.refresh();
      }
    } catch (e) {
      print("Error: $e");
      DialogHelper.showToast(
        "Có lỗi xây ra, vui lòng thử lại sau",
        ToastType.warning,
      );
    }
  }
}
