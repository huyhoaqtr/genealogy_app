import 'package:dio/dio.dart';

import '../dio/dio_client.dart';
import '../models/api_response.dart';
import '../models/auth.model.dart';

class AuthApi {
  Future<ApiResponse<LoginResponse>> login({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await DioClient().post('/auth/login', data: {
        'phoneNumber': phoneNumber,
        'password': password,
      });
      return ApiResponse<LoginResponse>(
        statusCode: response.statusCode,
        message: response.data['message'],
        data: LoginResponse.fromJson(response.data['data']),
      );
    } catch (e) {
      if (e is DioException && e.response != null) {
        return ApiResponse<LoginResponse>(
          statusCode: e.response!.statusCode,
          message: e.response!.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<LoginResponse>> register({
    required String phoneNumber,
    required String password,
    required String fullName,
    required String role,
    String? tribeCode,
    String? tribeName,
  }) async {
    try {
      final response = await DioClient().post('/auth/register', data: {
        'phoneNumber': phoneNumber,
        'password': password,
        'fullName': fullName,
        'role': role,
        'tribeCode': tribeCode,
        'tribeName': tribeName
      });
      return ApiResponse<LoginResponse>(
        statusCode: response.statusCode,
        message: response.data['message'],
        data: LoginResponse.fromJson(response.data['data']),
      );
    } catch (e) {
      if (e is DioException && e.response != null) {
        return ApiResponse<LoginResponse>(
          statusCode: e.response!.statusCode,
          message: e.response!.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<LoginResponse>> updateFcm({
    required String newFcmKey,
  }) async {
    try {
      final response = await DioClient().put('/auth/update-fcm', data: {
        'newFcmKey': newFcmKey,
      });
      return ApiResponse<LoginResponse>(
        statusCode: response.statusCode,
        message: response.data['message'],
        data: LoginResponse.fromJson(response.data['data']),
      );
    } catch (e) {
      if (e is DioException && e.response != null) {
        return ApiResponse<LoginResponse>(
          statusCode: e.response!.statusCode,
          message: e.response!.data['message'],
        );
      }
      rethrow;
    }
  }
}
