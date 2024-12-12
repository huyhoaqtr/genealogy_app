import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherIcon extends StatelessWidget {
  final int weatherId;

  WeatherIcon({required this.weatherId});

  // Hàm trả về biểu tượng dựa trên weatherId
  IconData getWeatherIcon(int weatherId) {
    if (weatherId >= 200 && weatherId <= 232) {
      return WeatherIcons.thunderstorm; // Dông và sấm
    } else if (weatherId >= 300 && weatherId <= 321) {
      return WeatherIcons.sprinkle; // Mưa nhỏ
    } else if (weatherId >= 500 && weatherId <= 531) {
      return WeatherIcons.rain; // Mưa vừa đến lớn
    } else if (weatherId >= 600 && weatherId <= 622) {
      return WeatherIcons.snow; // Tuyết
    } else if (weatherId >= 701 && weatherId <= 781) {
      return WeatherIcons.fog; // Điều kiện đặc biệt (sương mù, bụi...)
    } else if (weatherId == 800) {
      return WeatherIcons.day_sunny; // Trời quang
    } else if (weatherId >= 801 && weatherId <= 804) {
      return WeatherIcons.cloudy; // Mây
    } else {
      return WeatherIcons.day_sunny; // Mặc định là trời quang
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      getWeatherIcon(weatherId), // Hiển thị icon theo weatherId
      color: Colors.blue,
      size: 30.w,
    );
  }
}
