import 'dart:math';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_colors.dart';
import '../../resources/models/vote.model.dart';
import '../../services/contract/file-storage.dart';
import '../permission.dart';
import '../widgets/dialog/dialog.helper.dart';

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

String kelvinToCelsius(double kelvin) {
  return (kelvin - 273.15).toStringAsFixed(0);
}

String getWindDirection(deg) {
  if (deg >= 0 && deg < 22.5) {
    return 'Bắc';
  } else if (deg >= 22.5 && deg < 45) {
    return 'Bắc Đông Bắc';
  } else if (deg >= 45 && deg < 67.5) {
    return 'Đông Bắc';
  } else if (deg >= 67.5 && deg < 90) {
    return 'Đông';
  } else if (deg >= 90 && deg < 112.5) {
    return 'Đông Nam';
  } else if (deg >= 112.5 && deg < 135) {
    return 'Nam Đông Nam';
  } else if (deg >= 135 && deg < 157.5) {
    return 'Nam';
  } else if (deg >= 157.5 && deg < 180) {
    return 'Nam Tây Nam';
  } else if (deg >= 180 && deg < 202.5) {
    return 'Tây Nam';
  } else if (deg >= 202.5 && deg < 225) {
    return 'Tây';
  } else if (deg >= 225 && deg < 247.5) {
    return 'Tây Bắc';
  } else if (deg >= 247.5 && deg < 270) {
    return 'Bắc Tây Bắc';
  } else if (deg >= 270 && deg < 292.5) {
    return 'Bắc';
  } else if (deg >= 292.5 && deg < 315) {
    return 'Bắc Tây Bắc';
  } else if (deg >= 315 && deg < 337.5) {
    return 'Tây Bắc';
  } else {
    return 'Bắc';
  }
}

String formatDateTimeFromString(String dateTimeString) {
  List<String> monthsInVietnamese = [
    'Thg 1',
    'Thg 2',
    'Thg 3',
    'Thg 4',
    'Thg 5',
    'Thg 6',
    'Thg 7',
    'Thg 8',
    'Thg 9',
    'Thg 10',
    'Thg 11',
    'Thg 12'
  ];

  // Chuyển đổi sang múi giờ +7
  DateTime dateTime =
      DateTime.parse(dateTimeString).toUtc().add(const Duration(hours: 7));
  DateTime now = DateTime.now().toUtc().add(const Duration(hours: 7));

  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    return DateFormat('kk:mm').format(dateTime);
  } else if (dateTime.year == now.year) {
    String formattedDate = DateFormat('d MMMM').format(dateTime);
    String month = formattedDate.split(' ')[1];
    String vietnameseMonth = monthsInVietnamese[dateTime.month - 1];

    return formattedDate.replaceFirst(month, vietnameseMonth);
  } else {
    String formattedDate = DateFormat('d MMMM, yy').format(dateTime);
    String month = formattedDate.split(' ')[1];
    String vietnameseMonth = monthsInVietnamese[dateTime.month - 1];

    return formattedDate.replaceFirst(month, "$vietnameseMonth, ");
  }
}

//genarate random tempid string
String generateRandomString(int length) {
  var random = Random();
  var codeUnits = List.generate(length, (index) => 97 + random.nextInt(25));
  return String.fromCharCodes(codeUnits);
}

String formatCurrency(dynamic amount) {
  final format = NumberFormat.simpleCurrency(locale: 'vi_VN');
  return format.format(amount);
}

//generate date now + 10 char string id
String generateDateId() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyyMMdd').format(now);
  return formattedDate + generateRandomString(10);
}

void printLongData(String data) {
  const int chunkSize = 1024; // Kích thước mỗi phần in
  for (var i = 0; i < data.length; i += chunkSize) {
    print(data.substring(
        i, i + chunkSize > data.length ? data.length : i + chunkSize));
  }
}

Future<File?> compressImage(File file,
    {int quality = 90, int maxSizeMB = 2}) async {
  // Yêu cầu quyền truy cập bộ nhớ
  if (!await requestStoragePermission()) {
    throw Exception("Không có quyền truy cập bộ nhớ");
  }

  // Lấy thư mục tạm của ứng dụng
  final tempDir = await getTemporaryDirectory();
  final compressedFilePath =
      "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_compressed.jpg";
  File compressedFile = File(compressedFilePath);

  try {
    // Kiểm tra nếu tệp đầu vào tồn tại
    if (!await file.exists()) {
      throw Exception("Tệp nguồn không tồn tại");
    }

    // Đọc file gốc
    final originalImage = img.decodeImage(await file.readAsBytes());
    if (originalImage == null) throw Exception("Không thể đọc file ảnh");

    // Lấy kích thước của tệp ban đầu
    int currentSize = await file.length();

    // Nén ảnh cho đến khi đạt dung lượng mong muốn
    while (currentSize > maxSizeMB * 1024 * 1024) {
      final resizedImage = img.copyResize(originalImage,
          width: (originalImage.width * 0.9).toInt(),
          height: (originalImage.height * 0.9).toInt());
      final compressedBytes = img.encodeJpg(resizedImage, quality: quality);

      // Ghi dữ liệu vào tệp nén
      await compressedFile.writeAsBytes(compressedBytes);

      // Kiểm tra nếu tệp đã được tạo ra đúng
      if (await compressedFile.exists()) {
        print('File nén đã được tạo tại: ${compressedFile.path}');
      } else {
        throw Exception('Không thể tạo file nén');
      }

      // Kiểm tra lại kích thước của tệp sau khi ghi
      currentSize = await compressedFile.length();
    }

    return compressedFile;
  } catch (e) {
    print("Lỗi nén ảnh: $e");
    throw Exception("Lỗi nén ảnh: $e");
  }
}

List<Map<String, dynamic>> genderOptions = [
  {
    'name': 'Nữ',
    'value': "FEMALE",
  },
  {
    'name': 'Nam',
    'value': "MALE",
  },
  {
    'name': 'Khác',
    'value': "OTHER",
  },
];

int calculateAge(String birthDateString, {String? deathDateString}) {
  try {
    // Chuyển đổi chuỗi thành đối tượng DateTime
    DateTime birthDate = DateTime.parse(birthDateString);
    DateTime endDate = deathDateString != null
        ? DateTime.parse(deathDateString)
        : DateTime.now();

    // Tính số tuổi
    int age = endDate.year - birthDate.year;

    // Kiểm tra nếu chưa đến ngày sinh trong năm kết thúc thì giảm 1 tuổi
    if (endDate.month < birthDate.month ||
        (endDate.month == birthDate.month && endDate.day < birthDate.day)) {
      age--;
    }

    return age;
  } catch (e) {
    // Xử lý lỗi nếu chuỗi ngày không đúng định dạng
    print("Invalid date format: $e");
    return -1; // Trả về -1 để biểu thị lỗi
  }
}

int calculateTotalVotes(List<Options> options) {
  int totalVotes = options.fold(
    0,
    (sum, option) => sum + (option.votes?.length ?? 0),
  );

  return totalVotes;
}

String formatRelativeOrAbsolute(String dateTimeString) {
  List<String> monthsInVietnamese = [
    'Thg 1',
    'Thg 2',
    'Thg 3',
    'Thg 4',
    'Thg 5',
    'Thg 6',
    'Thg 7',
    'Thg 8',
    'Thg 9',
    'Thg 10',
    'Thg 11',
    'Thg 12'
  ];

  // Chuyển đổi sang múi giờ +7
  DateTime dateTime =
      DateTime.parse(dateTimeString).toUtc().add(const Duration(hours: 7));
  DateTime now = DateTime.now().toUtc().add(const Duration(hours: 7));

  Duration difference = now.difference(dateTime);

  if (difference.inDays <= 30) {
    if (difference.inSeconds < 5) {
      return "vừa xong";
    } else if (difference.inSeconds < 60) {
      return "${difference.inSeconds} giây trước";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} phút trước";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} giờ trước";
    } else {
      return "${difference.inDays} ngày trước";
    }
  } else {
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return DateFormat('kk:mm').format(dateTime);
    } else if (dateTime.year == now.year) {
      String formattedDate = DateFormat('d MMMM').format(dateTime);
      String month = formattedDate.split(' ')[1];
      String vietnameseMonth = monthsInVietnamese[dateTime.month - 1];

      return formattedDate.replaceFirst(month, vietnameseMonth);
    } else {
      String formattedDate = DateFormat('d MMMM, yy').format(dateTime);
      String month = formattedDate.split(' ')[1];
      String vietnameseMonth = monthsInVietnamese[dateTime.month - 1];

      return formattedDate.replaceFirst(month, "$vietnameseMonth, ");
    }
  }
}

String formatNumberWithSuffix(dynamic number) {
  if (number == null) return '0';

  double num = number is int ? number.toDouble() : number;

  if (num >= 1000000000) {
    return '${(num / 1000000000).toStringAsFixed(1)}B'; // Tỷ (Billion)
  } else if (num >= 1000000) {
    return '${(num / 1000000).toStringAsFixed(1)}M'; // Triệu (Million)
  } else if (num >= 1000) {
    return '${(num / 1000).toStringAsFixed(1)}k'; // Nghìn (Thousand)
  } else {
    return num.toStringAsFixed(0); // Số nhỏ hơn 1000, giữ nguyên
  }
}

void copyTribeCode(String code) {
  Clipboard.setData(ClipboardData(text: code));
  DialogHelper.showToast(
    "Đã sao chép vào clipboard.",
    ToastType.success,
  );
}

String formatDate(String isoDate, {String format = 'dd/MM/yyyy'}) {
  try {
    // Parse chuỗi ISO 8601
    DateTime parsedDate = DateTime.parse(isoDate);

    // Định dạng ngày thành dd/MM/yyyy
    String formattedDate = DateFormat(format).format(parsedDate);

    return formattedDate;
  } catch (e) {
    // Nếu có lỗi, trả về chuỗi rỗng hoặc thông báo lỗi
    return 'Invalid date format';
  }
}

Color getToastColor(ToastType type) {
  switch (type) {
    case ToastType.success:
      return AppColors.successColor;
    case ToastType.error:
      return AppColors.errorColor;
    case ToastType.warning:
      return AppColors.warningColor;
    case ToastType.info:
      return AppColors.infoColor;
  }
}

String obfuscateHash(String hash, int length) {
  if (hash.length <= length * 2) return hash;
  return '${hash.substring(0, length)}**************${hash.substring(hash.length - length)}';
}

Future<void> openUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw Exception('Could not launch $uri');
  }
}

Future<String> getFileInfo(String? blockId) async {
  if (blockId == null) return "";
  final fileStorage = FileStorageContract(
    rpcUrl: dotenv.env['CHAIN_NET'] ?? '',
    contractAddress: dotenv.env['CONTRACT_ADDRESS'] ?? '',
    privateKey: dotenv.env['PRIVATE_KEY'] ?? '',
  );
  await fileStorage.initializeContract();
  final file = await fileStorage.getFile(int.parse(blockId));
  return file["ipfsAddress"] ?? "";
}

void callPhone(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    DialogHelper.showToast(
      'Không thể gọi số điện thoại: $phoneNumber',
      ToastType.error,
    );
    throw 'Không thể gọi số điện thoại: $phoneNumber';
  }
}

void sendMessage(String phoneNumber) async {
  final Uri smsUri = Uri(
    scheme: 'sms',
    path: phoneNumber,
  );

  if (await canLaunchUrl(smsUri)) {
    await launchUrl(smsUri);
  } else {
    DialogHelper.showToast(
      'Không thể nhắn tin số điện thoại: $phoneNumber',
      ToastType.error,
    );
    throw 'Không thể nhắn tin số điện thoại: $phoneNumber';
  }
}

String getRole(String role) {
  switch (role) {
    case 'ADMIN':
      return 'Tộc lão';
    case 'LEADER':
      return 'Tộc trưởng';
    default:
      return 'Thành viên';
  }
}
