import 'dart:math';

import 'package:flutter_compass/flutter_compass.dart';
import 'package:get/get.dart';

class CompassController extends GetxController {
  RxDouble direction = 0.0.obs;
  RxDouble currentAngle = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    FlutterCompass.events!.listen((event) {
      double newHeading = event.heading ?? 0.0;

      if ((newHeading - direction.value).abs() > 1.0) {
        direction.value = newHeading;
      }
    });
  }

  String getDirection(double degree) {
    if (degree >= 0 && degree < 22.5) {
      return "Bắc (KHẢM) ${degree.toStringAsFixed(1)}°";
    } else if (degree >= 22.5 && degree < 67.5) {
      return "Đông Bắc (CẤN) ${degree.toStringAsFixed(1)}°";
    } else if (degree >= 67.5 && degree < 112.5) {
      return "Đông (CHẤN) ${degree.toStringAsFixed(1)}°";
    } else if (degree >= 112.5 && degree < 157.5) {
      return "Đông Nam (TỐN) ${degree.toStringAsFixed(1)}°";
    } else if (degree >= 157.5 && degree < 202.5) {
      return "Nam (LY) ${degree.toStringAsFixed(1)}°";
    } else if (degree >= 202.5 && degree < 247.5) {
      return "Tây Nam (KHÔN) ${degree.toStringAsFixed(1)}°";
    } else if (degree >= 247.5 && degree < 292.5) {
      return "Tây (ĐOÀI) ${degree.toStringAsFixed(1)}°";
    } else if (degree >= 292.5 && degree < 337.5) {
      return "Tây Bắc (CÀN) ${degree.toStringAsFixed(1)}°";
    } else {
      return "Bắc (KHẢM) ${degree.toStringAsFixed(1)}°";
    }
  }

  double getShortestRotation(double currentAngle, double targetAngle) {
    double difference = (targetAngle - currentAngle) % (2 * pi);
    if (difference > pi) {
      difference -= 2 * pi; // Quay ngược lại nếu góc lớn hơn 180°
    } else if (difference < -pi) {
      difference += 2 * pi; // Quay ngược lại nếu góc nhỏ hơn -180°
    }
    return currentAngle + difference; // Trả về góc ngắn nhất
  }
}
