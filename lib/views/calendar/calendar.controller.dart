import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:getx_app/resources/api/weather.api.dart';
import 'package:getx_app/resources/models/weather.dart';

import '../../utils/geolocator/geolocator.dart';

class CalendarController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<WeatherModel> weather = WeatherModel().obs;
  Rx<Placemark> location = const Placemark().obs;

  @override
  void onInit() {
    super.onInit();
    loadWeatherData();
  }

  Future<void> loadWeatherData() async {
    Position position = await determinePosition();

    final response = await WeatherApi().getWeatherData(
      lat: position.latitude.toString(),
      lon: position.longitude.toString(),
    );
    location.value =
        await getLocationData(position.latitude, position.longitude);
    weather.value = response;
  }

  String getDayOfWeek(DateTime dateTime) {
    const days = {
      1: "Thứ Hai",
      2: "Thứ Ba",
      3: "Thứ Tư",
      4: "Thứ Năm",
      5: "Thứ Sáu",
      6: "Thứ Bảy",
      7: "Chủ Nhật",
    };

    return days[dateTime.weekday] ?? "Không xác định";
  }
}
