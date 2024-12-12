import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:getx_app/resources/models/weather.dart';

class WeatherApi {
  Future<WeatherModel> getWeatherData({
    required String lat,
    required String lon,
  }) async {
    try {
      final response = await Dio().get(
        dotenv.env['OPEN_WEATHER_API']!,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': dotenv.env['OPEN_WEATHER_API_KEY']!,
          'lang': 'vi',
        },
      );
      return WeatherModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
