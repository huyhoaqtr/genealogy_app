import 'package:dio/dio.dart';
import 'package:getx_app/resources/models/api_response.dart';
import 'package:getx_app/resources/models/fund.model.dart';
import 'package:getx_app/resources/models/transaction.model.dart';

import '../dio/dio_client.dart';

class FundApi {
  Future<ApiResponse<List<Fund>>> getAllFund() async {
    try {
      // Gửi request đến API
      final response = await DioClient().get('/fund/get-all-fund');

      // Parse dữ liệu response
      final List<dynamic> data = response.data['data'] ?? [];
      final funds = data.map((json) => Fund.fromJson(json)).toList();

      return ApiResponse<List<Fund>>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
        data: funds,
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        return ApiResponse<List<Fund>>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<Fund>> getFundDetail({
    required String id,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().get('/fund/get-fund/$id');

      return ApiResponse<Fund>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
        data: Fund.fromJson(response.data['data']),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        return ApiResponse<Fund>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<Fund>> createFund({
    required String title,
    required String desc,
    required String amount,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().post(
        '/fund/create-fund',
        data: {
          'title': title,
          'desc': desc,
          'amount': amount,
        },
      );

      return ApiResponse<Fund>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
        data: Fund.fromJson(response.data['data']),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        return ApiResponse<Fund>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<Transaction>> createTransaction({
    required String fundId,
    required String type,
    required String desc,
    required String amount,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().post(
        '/fund/create-transaction',
        data: {
          'fundId': fundId,
          'type': type,
          'desc': desc,
          'amount': amount,
        },
      );

      return ApiResponse<Transaction>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
        data: Transaction.fromJson(response.data['data']),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        return ApiResponse<Transaction>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }
}
