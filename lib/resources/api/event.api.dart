import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

import '../../utils/widgets/dialog/dialog.helper.dart';
import '../../views/event/event.controller.dart';
import '../dio/dio_client.dart';
import '../models/api_response.dart';
import '../models/event.model.dart';

class EventApi {
  Future<PagingResponse<Event>> getAllEvent({
    required int page,
    required int limit,
    required FilterStatus filter,
    CancelToken? cancelToken,
  }) async {
    try {
      final DateTime now = DateTime.now();
      final Map<String, String> queryParameters = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      switch (filter) {
        case FilterStatus.all:
          break;

        case FilterStatus.currentDay:
          queryParameters['startDate'] = DateFormat('yyyy-MM-dd').format(now);
          queryParameters['endDate'] = DateFormat('yyyy-MM-dd').format(now);
          break;

        case FilterStatus.thisWeek:
          final DateTime startOfWeek =
              now.subtract(Duration(days: now.weekday - 1));
          final DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
          queryParameters['startDate'] =
              DateFormat('yyyy-MM-dd').format(startOfWeek);
          queryParameters['endDate'] =
              DateFormat('yyyy-MM-dd').format(endOfWeek);
          break;

        case FilterStatus.thisMonth:
          final DateTime startOfMonth = DateTime(now.year, now.month, 1);
          final DateTime endOfMonth = DateTime(now.year, now.month + 1, 0);
          queryParameters['startDate'] =
              DateFormat('yyyy-MM-dd').format(startOfMonth);
          queryParameters['endDate'] =
              DateFormat('yyyy-MM-dd').format(endOfMonth);
          break;

        case FilterStatus.nextMonth:
          final DateTime startOfNextMonth =
              DateTime(now.year, now.month + 1, 1);
          final DateTime endOfNextMonth = DateTime(now.year, now.month + 2, 0);
          queryParameters['startDate'] =
              DateFormat('yyyy-MM-dd').format(startOfNextMonth);
          queryParameters['endDate'] =
              DateFormat('yyyy-MM-dd').format(endOfNextMonth);
          break;
        case FilterStatus.previousMonth:
          final DateTime startOfNextMonth =
              DateTime(now.year, now.month - 1, 1);
          final DateTime endOfNextMonth = DateTime(now.year, now.month, 0);
          queryParameters['startDate'] =
              DateFormat('yyyy-MM-dd').format(startOfNextMonth);
          queryParameters['endDate'] =
              DateFormat('yyyy-MM-dd').format(endOfNextMonth);
          break;
      }

      // Gửi request đến API
      final response = await DioClient().get('/event/get-all-event',
          queryParameters: queryParameters, cancelToken: cancelToken);

      return PagingResponse<Event>.fromJson(
        response.data,
        (json) => Event.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return PagingResponse<Event>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<Event>> getEventById({
    required String eventId,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().get('/event/get-event/$eventId');

      return ApiResponse<Event>.fromJson(
        response.data,
        (json) => Event.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<Event>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<Event>> createEvent({
    required String title,
    required String desc,
    required String startTime,
    required String startDate,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().post(
        '/event/create-event',
        data: {
          'title': title,
          'desc': desc,
          'startTime': startTime,
          'startDate': startDate,
        },
      );

      return ApiResponse<Event>.fromJson(
        response.data,
        (json) => Event.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<Event>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<Event>> updateEvent({
    required String eventId,
    String? title,
    String? desc,
    String? startTime,
    String? startDate,
  }) async {
    try {
      final fields = {
        if (title != null) 'title': title,
        if (desc != null) 'desc': desc,
        if (startTime != null) 'startTime': startTime,
        if (startDate != null) 'startDate': startDate,
      };

      final response = await DioClient().put(
        '/event/update-event/$eventId',
        data: fields,
      );

      return ApiResponse<Event>.fromJson(
        response.data,
        (json) => Event.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<Event>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<Event>> deleteEvent({required String eventId}) async {
    try {
      final response = await DioClient().delete(
        '/event/delete-event/$eventId',
      );

      return ApiResponse<Event>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'An error occurred',
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<Event>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }
}
