import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:getx_app/services/storage/storage_manager.dart';

import '../../utils/string/string.dart';

class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: "${dotenv.env['API_URL']}/api",
            connectTimeout: const Duration(seconds: 180),
            receiveTimeout: const Duration(seconds: 180),
          ),
        ) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Thêm token từ StorageManager
        final token = await StorageManager.getToken();
        options.headers['Content-Type'] = 'application/json';
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // Log request
        print("REQUEST[${options.method}] => PATH: ${options.path}");
        print("Headers: ${options.headers}");
        print("Query Params: ${options.queryParameters}");
        if (options.data is FormData) {
          final formData = options.data as FormData;
          final fields =
              formData.fields.map((e) => '${e.key}: ${e.value}').join(', ');
          final files = formData.files
              .map((e) => '${e.key}: ${e.value.filename}')
              .join(', ');

          print("Body (FormData Fields): $fields");
          print("Body (FormData Files): $files");
        } else {
          print("Body: ${options.data}");
        }

        return handler.next(options); // Tiếp tục
      },
      onResponse: (response, handler) {
        // Log response
        print(
            "RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}");
        final jsonString =
            const JsonEncoder.withIndent('  ').convert(response.data);
        printLongData("BODY: $jsonString");
        return handler.next(response); // Tiếp tục
      },
      onError: (DioException e, handler) {
        // Log lỗi
        print(
            "ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}");
        print("Message: ${e.message}");
        // Xử lý lỗi Timeout
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          print("Connection timed out. Please try again.");
        }
        return handler.next(e); // Tiếp tục
      },
    ));
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await dio.post(
        path,
        data: data,
        options: Options(headers: headers),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await dio.put(
        path,
        data: data,
        options: Options(headers: headers),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      return await dio.delete(
        path,
        options: Options(headers: headers),
      );
    } catch (e) {
      rethrow;
    }
  }
}
