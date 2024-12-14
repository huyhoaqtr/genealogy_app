import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/widgets/dialog/dialog.helper.dart';
import '../dio/dio_client.dart';
import '../models/api_response.dart';
import '../models/tribe.model.dart';

class HomeApi {
  static Future<String> saveImageFromUrl(String url) async {
    try {
      // Perform a GET request with Dio
      final dynamic response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      if (response.statusCode == 200) {
        Uint8List bytes = response.data; // Access the data as bytes directly

        final directory = await getTemporaryDirectory();
        final fileName = url.split('/').last;
        final filePath = '${directory.path}/$fileName';

        final file = File(filePath);
        await file.writeAsBytes(bytes);
        final result = await ImageGallerySaver.saveFile(filePath);
        if (result['isSuccess']) {
          DialogHelper.showToastDialog(
              "Thông báo", "Tải xuống hình ảnh thành công!");
        }
        return filePath;
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      if (e is DioException) {
        DialogHelper.showToastDialog(
            "Tải xuống thất bại", "Có lỗi xảy ra, vui lòng thử lại sau!");
      }
      print('Error capturing image: $e');
      throw e;
    }
  }

  Future<ApiResponse<TribeModel>> getMyTribe() async {
    try {
      // Gửi request đến API
      final response = await DioClient().get('/tribe/get-my-tribe');

      return ApiResponse<TribeModel>(
        statusCode: response.statusCode,
        message: response.data['message'] ?? 'Success',
        data: TribeModel.fromJson(response.data['data']),
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
          message: e.response?.data['message'] ?? 'An error occurred',
        );
      }
      rethrow;
    }
  }
}
