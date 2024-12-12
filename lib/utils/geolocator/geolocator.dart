import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Kiểm tra nếu dịch vụ vị trí được bật
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Dịch vụ vị trí không bật
    return Future.error('Location services are disabled.');
  }

  // Kiểm tra quyền truy cập vị trí
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Quyền truy cập bị từ chối
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Quyền bị từ chối vĩnh viễn
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // Lấy tọa độ hiện tại
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

getLocationData(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      return placemarks[0];
    }
  } catch (e) {
    print("Error: $e");
  }
}
