import 'package:dio/dio.dart';

import '../dio/dio_client.dart';
import '../models/api_response.dart';
import '../models/event.model.dart';

class EventApi {
  Future<PagingResponse<Event>> getAllEvent({
    required int page,
    required int limit,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().get(
        '/event/get-all-event',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return PagingResponse<Event>.fromJson(
        response.data,
        (json) => Event.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
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
        return ApiResponse<Event>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }
}
