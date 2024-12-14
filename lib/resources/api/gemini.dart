import 'package:dio/dio.dart';
import 'package:getx_app/resources/models/api_response.dart';

import '../../utils/widgets/dialog/dialog.helper.dart';
import '../dio/dio_client.dart';

class GeminiApi {
  Future<ApiResponse<String>> getGeminiData({
    required String prompt,
  }) async {
    try {
      final response = await DioClient().post(
        '/chatbot/query',
        data: {
          'prompt': prompt,
        },
      );

      return ApiResponse<String>(
        statusCode: response.statusCode,
        message: response.data['message'],
        data: response.data['data'],
      );
    } catch (e) {
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<String>(
          statusCode: e.response!.statusCode,
          message: e.response!.data['message'] ?? "Đã có lỗi xảy ra",
          data: e.response!.data['data'] ?? "Đã có lỗi xảy ra",
        );
      }
      rethrow;
    }
  }
}
