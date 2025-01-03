import 'dart:io';

import 'package:dio/dio.dart';
import 'package:getx_app/resources/models/api_response.dart';
import 'package:getx_app/resources/models/user.model.dart';
import 'package:getx_app/views/message/model/conversation.model.dart';
import 'package:getx_app/views/message_detail/model/message.model.dart';
import 'package:http_parser/http_parser.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../dio/dio_client.dart';

class MessageApi {
  Future<PagingResponse<Conversation>> getConversation({
    required int page,
    required int limit,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().get(
        '/message/get-conversation',
        queryParameters: {'page': page, 'limit': limit},
      );

      // Parse dữ liệu response
      return PagingResponse<Conversation>.fromJson(
        response.data,
        (json) => Conversation.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return PagingResponse<Conversation>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<PagingResponse<Message>> getMessage({
    required int page,
    required int limit,
    String? conversationId,
    String? receiverId,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {'page': page, 'limit': limit};

      if (conversationId != null) {
        queryParameters['conversationId'] = conversationId;
      }
      if (receiverId != null) queryParameters['receiverId'] = receiverId;

      // Gửi request đến API
      final response = await DioClient().get(
        '/message/get-message',
        queryParameters: queryParameters,
      );

      // Parse dữ liệu response
      return PagingResponse<Message>.fromJson(
        response.data,
        (json) => Message.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return PagingResponse<Message>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<Message>> sendMessage({
    required String messageType,
    String? receiverId,
    String? conversationId,
    String? replyMessageId,
    String? content,
    File? file,
    String? tempId,
  }) async {
    try {
      final fields = {
        'messageType': messageType,
        if (receiverId != null) 'receiverId': receiverId,
        if (conversationId != null) 'conversationId': conversationId,
        if (replyMessageId != null) 'replyMessageId': replyMessageId,
        if (content != null) 'content': content,
        if (tempId != null) 'tempId': tempId,
      };

      // Chuyển Map thành FormData
      final formData = FormData.fromMap(fields);

      // Thêm file (nếu có)
      if (file != null) {
        formData.files.add(MapEntry(
          'file',
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
            contentType: MediaType('image', file.path.split('.').last),
          ),
        ));

        print("fileName: ${file.path.split('/').last}");
        print("fileSize: ${file.lengthSync()}");
      }

      // Gửi request đến API
      final response = await DioClient().post(
        '/message/create-message',
        data: formData,
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      );

      // Parse dữ liệu response
      return ApiResponse<Message>.fromJson(
        response.data,
        (json) => Message.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<Message>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse> unSendMessage({
    required String id,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().delete(
        '/message/delete-message/$id',
      );

      // Parse dữ liệu response
      return ApiResponse.fromJson(
        response.data,
        (json) => Message.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<PagingResponse<User>> searchUser({
    required int page,
    required int limit,
    required String keyword,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().get(
        '/message/search-conversation',
        queryParameters: {'page': page, 'limit': limit, 'keyword': keyword},
      );

      // Parse dữ liệu response
      return PagingResponse<User>.fromJson(
        response.data,
        (json) => User.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return PagingResponse<User>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }
}
