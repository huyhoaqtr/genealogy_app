import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:getx_app/resources/models/genealogy.model.dart';
import 'package:http_parser/http_parser.dart';

import '../../resources/models/tree_member.model.dart';
import '../../resources/models/tribe.model.dart';
import '../../utils/widgets/dialog/dialog.helper.dart';
import '../dio/dio_client.dart';
import '../models/api_response.dart';
import '../models/web3-transaction.model.dart';

class TribeAPi {
  Future<ApiResponse<TreeMember>> createTreeMember({
    required String fullName,
    required String gender,
    String? title,
    double? positionX,
    double? positionY,
    String? address,
    String? dateOfBirth,
    String? dateOfDeath,
    String? description,
    String? parent,
    String? couple,
    String? phoneNumber,
    String? burial,
    String? placeOfWorship,
    String? personInCharge,
    bool? isDead,
    File? avatar,
  }) async {
    try {
      final fields = {
        'fullName': fullName,
        'gender': gender,
        if (title != null) 'title': title,
        if (positionX != null) 'positionX': positionX,
        if (positionY != null) 'positionY': positionY,
        if (address != null) 'address': address,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
        if (dateOfDeath != null) 'dateOfDeath': dateOfDeath,
        if (description != null) 'description': description,
        if (parent != null) 'parent': parent,
        if (couple != null) 'couple': couple,
        if (burial != null) 'burial': burial,
        if (isDead != null) 'isDead': isDead,
        if (placeOfWorship != null) 'placeOfWorship': placeOfWorship,
        if (personInCharge != null) 'personInCharge': personInCharge,
        if (phoneNumber != null) 'phoneNumber': phoneNumber
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

      // Gửi request đến API
      final response = await DioClient().post(
        '/tribe/create-tribe-tree',
        data: formData,
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      );

      // Parse dữ liệu response
      return ApiResponse<TreeMember>.fromJson(
        response.data,
        (json) => TreeMember.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<TreeMember>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<TreeMember>> updateTreeMember({
    required String id,
    String? fullName,
    String? gender,
    String? title,
    double? positionX,
    double? positionY,
    String? address,
    String? dateOfBirth,
    String? dateOfDeath,
    String? description,
    String? parent,
    String? couple,
    String? phoneNumber,
    String? burial,
    String? placeOfWorship,
    String? personInCharge,
    bool? isDead,
    File? avatar,
  }) async {
    try {
      final fields = {
        if (fullName != null) 'fullName': fullName,
        if (gender != null) 'gender': gender,
        if (title != null) 'title': title,
        if (positionX != null) 'positionX': positionX,
        if (positionY != null) 'positionY': positionY,
        if (address != null) 'address': address,
        if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
        if (dateOfDeath != null) 'dateOfDeath': dateOfDeath,
        if (description != null) 'description': description,
        if (parent != null) 'parent': parent,
        if (couple != null) 'couple': couple,
        if (burial != null) 'burial': burial,
        if (isDead != null) 'isDead': isDead,
        if (placeOfWorship != null) 'placeOfWorship': placeOfWorship,
        if (personInCharge != null) 'personInCharge': personInCharge,
        if (phoneNumber != null) 'phoneNumber': phoneNumber
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

      // Gửi request đến API
      final response = await DioClient().put(
        '/tribe/update-tribe-tree-member/$id',
        data: formData,
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      );

      // Parse dữ liệu response
      return ApiResponse<TreeMember>.fromJson(
        response.data,
        (json) => TreeMember.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<TreeMember>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<List<TreeMember>>> getTribeTree() async {
    try {
      // Gửi request đến API
      final response = await DioClient().get(
        '/tribe/get-tribe-tree',
      );

      // Parse dữ liệu response
      final data = response.data['data'] as List<dynamic>;
      final members = data.map((item) => TreeMember.fromJson(item)).toList();

      return ApiResponse<List<TreeMember>>(
        statusCode: response.statusCode,
        message: response.data['message'],
        data: members,
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<List<TreeMember>>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse> updateAllTribePosition({
    required String payload,
  }) async {
    try {
      final response =
          await DioClient().put('/tribe/update-all-tribe-position', data: {
        'payload': payload,
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

  Future<ApiResponse<TribeModel>> updateTribe({
    String? tribeName,
    String? desc,
    String? address,
  }) async {
    try {
      final fields = {
        if (tribeName != null) 'name': tribeName,
        if (address != null) 'address': address,
        if (desc != null) 'description': desc
      };

      // Gửi request đến API
      final response =
          await DioClient().put('/tribe/update-tribe', data: fields);

      // Parse dữ liệu response
      return ApiResponse<TribeModel>.fromJson(
        response.data,
        (json) => TribeModel.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<TribeModel>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<GenealogyModel>> getGenealogyData() async {
    try {
      final response = await DioClient().get('/tribe/get-tribe-genealogy');
      return ApiResponse<GenealogyModel>.fromJson(
        response.data,
        (json) => GenealogyModel.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<GenealogyModel>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<PageData>> addPageDataToGenealogy({
    required String title,
    String? text,
    required String id,
  }) async {
    try {
      final fields = {
        'title': title,
        if (text != null) 'text': text,
        'id': id,
      };
      final response =
          await DioClient().post('/tribe/add-tribe-genealogy', data: fields);
      return ApiResponse<PageData>.fromJson(
        response.data,
        (json) => PageData.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<PageData>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<PageData>> updatePageDataToGenealogy({
    required String title,
    String? text,
    required String genealogyId,
    required String pageDataId,
  }) async {
    try {
      final fields = {
        'title': title,
        if (text != null) 'text': text,
        'genealogyId': genealogyId,
        'pageDataId': pageDataId,
      };
      final response = await DioClient().put(
        '/tribe/update-tribe-genealogy',
        data: fields,
      );
      return ApiResponse<PageData>.fromJson(
        response.data,
        (json) => PageData.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<PageData>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<PageData>> deletePageDataToGenealogy({
    required String genealogyId,
    required String pageDataId,
  }) async {
    try {
      final response = await DioClient().delete(
        '/tribe/delete-tribe-genealogy/$genealogyId/$pageDataId',
      );
      return ApiResponse<PageData>.fromJson(
        response.data,
        (json) => PageData.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        return ApiResponse<PageData>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<ApiResponse<Web3Transaction>> uploadPdfFileToWeb3({
    required Uint8List file,
  }) async {
    try {
      final response = await DioClient().post(
        '/web3/upload-file-to-web3',
        data: FormData.fromMap({
          'file': MultipartFile.fromBytes(file, filename: 'uploaded-file.pdf'),
        }),
      );

      return ApiResponse<Web3Transaction>.fromJson(
        response.data,
        (json) => Web3Transaction.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return ApiResponse<Web3Transaction>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }

  Future<PagingResponse<Web3Transaction>> getAllTransactionByTribe({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await DioClient()
          .get('/web3/get-all-transaction-by-tribe', queryParameters: {
        'page': page,
        'limit': limit,
      });

      return PagingResponse<Web3Transaction>.fromJson(
        response.data,
        (json) => Web3Transaction.fromJson(json),
      );
    } catch (e) {
      // Xử lý lỗi nếu có
      if (e is DioException && e.response != null) {
        DialogHelper.showToastDialog(
          "Thông báo",
          e.response?.data['message'] ?? 'An error occurred',
        );
        return PagingResponse<Web3Transaction>(
          statusCode: e.response?.statusCode,
          message: e.response?.data['message'],
        );
      }
      rethrow;
    }
  }
}
