import 'package:dio/dio.dart';
import '../../resources/models/api_response.dart';
import '../../resources/models/notification.model.dart';
import '../dio/dio_client.dart';

class NotificationApi {
  Future<PagingResponse<NotificationModel>> getAllNotification({
    required int page,
    required int limit,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().get(
        '/notification/get-all-notification-by-user',
        queryParameters: {'page': page, 'limit': limit},
      );

      // Parse dữ liệu response
      return PagingResponse<NotificationModel>.fromJson(
        response.data,
        (json) => NotificationModel.fromJson(json),
      );
    } catch (e) {
      if (e is DioException && e.response != null) {
        return PagingResponse<NotificationModel>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse> isRead({
    required String id,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().put(
        '/notification/update-is-read/$id',
      );

      return ApiResponse(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        return ApiResponse(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }
}
