import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/gemini.dart';

class GeminiApi {
  Future<GeminiModel> getGeminiData({
    required String prompt,
  }) async {
    try {
      final response = await Dio().post(
        dotenv.env['GEMINI_API']!,
        queryParameters: {
          'key': dotenv.env['GEMINI_API_KEY']!,
        },
        data: {
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "Bạn là một trợ lý thông minh. Hãy trả lời chính xác và rõ ràng bằng tiếng Việt - ${prompt}"
                }
              ]
            }
          ]
        },
      );

      return GeminiModel.fromJson(response.data);
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}
