import 'dart:math';

/// Hàm tính số ngày Julius từ một ngày cụ thể.
int julianDay(int year, int month, int day) {
  int a = ((14 - month) ~/ 12);
  int y = year + 4800 - a;
  int m = month + 12 * a - 3;
  return day +
      ((153 * m + 2) ~/ 5) +
      365 * y +
      (y ~/ 4) -
      (y ~/ 100) +
      (y ~/ 400) -
      32045;
}

double julianDate(
    int year, int month, int day, int hour, int minute, int second,
    {int timeZoneOffset = 7}) {
  int JDN = julianDay(year, month, day);
  return JDN +
      (hour - 12) / 24 +
      minute / 1440 +
      second / 86400 -
      timeZoneOffset / 24;
}

double solarLongitude(double JD) {
  double T = (JD - 2451545.0) / 36525;
  double L0 = 280.46645 + 36000.76983 * T + 0.0003032 * pow(T, 2);
  double M = 357.52910 +
      35999.05030 * T -
      0.0001559 * pow(T, 2) -
      0.00000048 * pow(T, 3);
  double C =
      (1.914600 - 0.004817 * T - 0.000014 * pow(T, 2)) * sin(radians(M)) +
          (0.01993 - 0.000101 * T) * sin(radians(2 * M)) +
          0.000290 * sin(radians(3 * M));
  double theta = L0 + C;
  return (theta - 0.00569 - 0.00478 * sin(radians(125.04 - 1934.136 * T))) %
      360;
}

/// Hàm chuyển đổi từ độ sang radian.
double radians(double degree) => degree * pi / 180;

const List<Map<String, dynamic>> solarTerms = [
  {"name": "Lập Xuân", "longitude": 315.0},
  {"name": "Vũ Thủy", "longitude": 330.0},
  {"name": "Kinh Trập", "longitude": 345.0},
  {"name": "Xuân Phân", "longitude": 0.0},
  {"name": "Thanh Minh", "longitude": 15.0},
  {"name": "Cốc Vũ", "longitude": 30.0},
  {"name": "Lập Hạ", "longitude": 45.0},
  {"name": "Tiểu Mãn", "longitude": 60.0},
  {"name": "Mang Chủng", "longitude": 75.0},
  {"name": "Hạ Chí", "longitude": 90.0},
  {"name": "Tiểu Thử", "longitude": 105.0},
  {"name": "Đại Thử", "longitude": 120.0},
  {"name": "Lập Thu", "longitude": 135.0},
  {"name": "Xử Thử", "longitude": 150.0},
  {"name": "Bạch Lộ", "longitude": 165.0},
  {"name": "Thu Phân", "longitude": 180.0},
  {"name": "Hàn Lộ", "longitude": 195.0},
  {"name": "Sương Giáng", "longitude": 210.0},
  {"name": "Lập Đông", "longitude": 225.0},
  {"name": "Tiểu Tuyết", "longitude": 240.0},
  {"name": "Đại Tuyết", "longitude": 255.0},
  {"name": "Đông Chí", "longitude": 270.0},
  {"name": "Tiểu Hàn", "longitude": 285.0},
  {"name": "Đại Hàn", "longitude": 300.0}
];

/// Hàm xác định tiết khí hiện tại từ ngày truyền vào.
String getSolarTerm(int year, int month, int day) {
  double JD = julianDate(year, month, day, 12, 0, 0);
  double currentLongitude = solarLongitude(JD);

  for (int i = 0; i < solarTerms.length; i++) {
    double startLongitude = solarTerms[i]['longitude'];
    double endLongitude = solarTerms[(i + 1) % solarTerms.length]['longitude'];

    if (startLongitude > endLongitude) {
      endLongitude += 360.0;
    }

    if (currentLongitude >= startLongitude && currentLongitude < endLongitude) {
      return solarTerms[i]['name'];
    }
  }

  return "Không xác định";
}
