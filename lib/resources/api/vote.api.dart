import 'package:dio/dio.dart';
import 'package:getx_app/resources/models/api_response.dart';
import 'package:getx_app/resources/models/vote.model.dart';

import '../../utils/widgets/dialog/dialog.helper.dart';
import '../dio/dio_client.dart';

class VoteApi {
  Future<ApiResponse<List<VoteSession>>> getAllVoteSession() async {
    try {
      // Gửi request đến API
      final response = await DioClient().get('/vote/get-vote-session');

      // Parse dữ liệu response
      final List<dynamic> data = response.data['data'] ?? [];
      final funds = data.map((json) => VoteSession.fromJson(json)).toList();

      return ApiResponse<List<VoteSession>>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
        data: funds,
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        return ApiResponse<List<VoteSession>>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<VoteSession>> getVoteSessionById({
    required String id,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().get(
        '/vote/get-vote-session-by-id/$id',
      );

      // Parse dữ liệu response

      return ApiResponse<VoteSession>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
        data: VoteSession.fromJson(response.data['data']),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<VoteSession>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<VoteSession>> createVoteSession({
    required String title,
    required String desc,
    required List<String> options,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().post(
        '/vote/create-vote-session',
        data: {
          'title': title,
          'desc': desc,
          'options': options,
        },
      );

      return ApiResponse<VoteSession>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
        data: VoteSession.fromJson(response.data['data']),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<VoteSession>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<VoteSession>> updateVoteSession({
    required String id,
    required String title,
    required String desc,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().put(
        '/vote/update-vote-session/$id',
        data: {
          'title': title,
          'desc': desc,
        },
      );

      return ApiResponse<VoteSession>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
        data: VoteSession.fromJson(response.data['data']),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<VoteSession>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse> deleteVoteSession({
    required String id,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().delete(
        '/vote/delete-vote-session-by-id/$id',
      );

      return ApiResponse<VoteSession>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
      );
    } catch (e) {
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<VoteSession>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<VoteSession>> castVote({
    required String voteSessionId,
    String? oldOptionId,
    required String newOptionId,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().post('/vote/cast-vote', data: {
        'voteSessionId': voteSessionId,
        'oldOptionId': oldOptionId,
        'newOptionId': newOptionId
      });

      return ApiResponse<VoteSession>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
        data: VoteSession.fromJson(response.data['data']),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<VoteSession>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<VoteSession>> addOptionToVote({
    required String id,
    required String optionString,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().put(
        '/vote/add-option-to-vote/$id',
        data: {
          'optionString': optionString,
        },
      );

      return ApiResponse<VoteSession>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
        data: VoteSession.fromJson(response.data['data']),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<VoteSession>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow;
    }
  }
}
