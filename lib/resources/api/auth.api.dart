import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:getx_app/resources/models/user.model.dart';

import '../../utils/widgets/dialog/dialog.helper.dart';
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
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
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
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
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
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<LoginResponse>(
          statusCode: e.response!.statusCode,
          message: e.response!.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<User>> updateUserInfo({
    required String id,
    String? fullName,
    String? gender,
    String? email,
    String? dateOfBirth,
    String? address,
    File? avatar,
  }) async {
    try {
      final fields = {
        if (fullName != null) 'fullName': fullName,
        if (gender != null) 'gender': gender,
        if (address != null) 'address': address,
        if (email != null) 'email': email,
      };

      // Chuyển Map thành FormData
      final formData = FormData.fromMap(fields);

      // Thêm file (nếu có)
      if (avatar != null) {
        formData.files.add(MapEntry(
          'avatar',
          await MultipartFile.fromFile(avatar.path,
              filename: avatar.path.split('/').last,
              contentType: MediaType('image', avatar.path.split('.').last)),
        ));
      }
      final response = await DioClient().put(
        '/auth/update-info',
        data: formData,
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      );
      return ApiResponse<User>(
        statusCode: response.statusCode,
        message: response.data['message'],
        data: User.fromJson(response.data['data']),
      );
    } catch (e) {
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<User>(
          statusCode: e.response!.statusCode,
          message: e.response!.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await DioClient().put('/auth/update-password', data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });
      return ApiResponse(
        statusCode: response.statusCode,
        message: response.data['message'],
      );
    } catch (e) {
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse(
          statusCode: e.response!.statusCode,
          message: e.response!.data['message'],
        );
      }
      rethrow;
    }
  }
}
