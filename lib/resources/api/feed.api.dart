import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../utils/widgets/dialog/dialog.helper.dart';
import '../dio/dio_client.dart';
import '../models/comment.model.dart';
import '../models/feed.model.dart';
import '../models/api_response.dart';

class FeedApi {
  Future<PagingResponse<Feed>> getAllFeed({
    required int page,
    required int limit,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().get(
        '/feed/get-all-feed',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return PagingResponse<Feed>.fromJson(
        response.data,
        (json) => Feed.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return PagingResponse<Feed>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<PagingResponse<Feed>> getAllFeedByUserId({
    required int page,
    required int limit,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().get(
        '/feed/get-all-feed-by-user',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return PagingResponse<Feed>.fromJson(
        response.data,
        (json) => Feed.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return PagingResponse<Feed>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<Feed>> toggleLikeFeed({
    required String feedId,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().put(
        '/feed/toggle-like-feed',
        data: {'feedId': feedId},
      );

      return ApiResponse<Feed>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<Feed>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<Feed>> getFeedById({
    required String id,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().get('/feed/get-feed/$id');

      return ApiResponse(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
        data: Feed.fromJson(response.data['data']),
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
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse> toggleLikeComment({
    required String commentId,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().put(
        '/feed/toggle-like-comment',
        data: {'commentId': commentId},
      );

      return ApiResponse(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
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
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<Feed>> createNewFeed({
    String? content,
    List<File>? files,
  }) async {
    try {
      final fields = {
        if (content != null && content.isNotEmpty) 'content': content,
      };

      // Chuyển Map thành FormData
      final formData = FormData.fromMap(fields);

      // Thêm file (nếu có)
      if (files != null) {
        for (final file in files) {
          formData.files.add(MapEntry(
            'images',
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
              contentType: MediaType('image', file.path.split('.').last),
            ),
          ));
        }
      }

      // Gửi request đến API
      final response = await DioClient().post(
        '/feed/create-feed',
        data: formData,
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      );

      // Parse dữ liệu response
      return ApiResponse<Feed>.fromJson(
        response.data,
        (json) => Feed.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<Feed>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<Feed>> updateFeed({
    required String feedId,
    String? content,
    List<File>? files,
    List<String>? deleteImages,
  }) async {
    try {
      final fields = {
        if (content != null && content.isNotEmpty) 'content': content,
        if (deleteImages != null && deleteImages.isNotEmpty)
          'removeImages': deleteImages,
        'feedId': feedId,
      };

      // Chuyển Map thành FormData
      final formData = FormData.fromMap(fields);

      // Thêm file (nếu có)
      if (files != null) {
        for (final file in files) {
          formData.files.add(MapEntry(
            'images',
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
              contentType: MediaType('image', file.path.split('.').last),
            ),
          ));
        }
      }

      // Gửi request đến API
      final response = await DioClient().put(
        '/feed/update-feed/$feedId',
        data: formData,
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      );

      // Parse dữ liệu response
      return ApiResponse<Feed>.fromJson(
        response.data,
        (json) => Feed.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<Feed>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<PagingResponse<CommentFeed>> getAllFeedComment({
    required int page,
    required int limit,
    required String feedId,
  }) async {
    try {
      // Gửi request đến API
      final response = await DioClient().get(
        '/feed/get-all-comment',
        queryParameters: {
          'page': page,
          'limit': limit,
          'feedId': feedId,
        },
      );

      return PagingResponse<CommentFeed>.fromJson(
        response.data,
        (json) => CommentFeed.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return PagingResponse<CommentFeed>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow; // Quăng lỗi nếu không phải lỗi từ API
    }
  }

  Future<ApiResponse<CommentFeed>> createNewComment(
      {required String content,
      required String feedId,
      String? parentCommentId}) async {
    try {
      final fields = {
        'content': content,
        'feedId': feedId,
        if (parentCommentId != null) 'parentCommentId': parentCommentId,
      };

      // Gửi request đến API
      final response = await DioClient().post(
        '/feed/create-comment',
        data: fields,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Parse dữ liệu response
      return ApiResponse<CommentFeed>.fromJson(
        response.data,
        (json) => CommentFeed.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<CommentFeed>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse> deleteFeed({required String feedId}) async {
    try {
      // Gửi request đến API
      final response = await DioClient().delete('/feed/delete-feed/$feedId');

      // Parse dữ liệu response
      return ApiResponse.fromJson(
        response.data,
        (json) => CommentFeed.fromJson(json),
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
}
