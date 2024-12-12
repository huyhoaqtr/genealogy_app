enum DayType { hoangDao, hacDao, binhThuong }

List<String> NENLAM = [
  "Khai trương, mở cửa hàng",
  "Cưới hỏi, lễ tân",
  "Mua sắm tài sản lớn",
  "Đầu tư, ký kết hợp đồng",
  "Thi cử, học hành",
  "Khai phá thị trường mới",
  "Tổ chức sự kiện",
  "Chuyển nhà, sửa chữa nhà cửa",
  "Mở rộng mạng lưới kinh doanh",
  "Tổ chức hội thảo, đào tạo",
  "Lập kế hoạch tài chính dài hạn",
  "Khởi nghiệp, sáng lập công ty",
  "Đầu tư vào dự án lớn",
  "Khám sức khỏe định kỳ",
  "Mua xe, tài sản cá nhân",
  "Đầu tư vào cổ phiếu, chứng khoán",
  "Phát triển mối quan hệ đối tác",
  "Mở rộng sản xuất, nhà máy",
  "Chuyển đổi công việc hoặc nghề nghiệp",
  "Thực hiện các kế hoạch nghề nghiệp",
  "Lên kế hoạch cho dự án mới",
  "Đề xuất cải tiến quy trình làm việc",
  "Đưa ra các quyết định quan trọng về công ty",
  "Tổ chức cuộc họp lớn, thương thảo hợp đồng",
  "Phát triển sản phẩm mới",
  "Mua sắm thiết bị, công nghệ mới",
  "Tổ chức các chuyến đi công tác, hợp tác quốc tế",
  "Khởi động các chiến dịch quảng bá sản phẩm",
  "Đầu tư vào bất động sản",
  "Làm việc với các chuyên gia, cố vấn",
  "Mua sắm, trang trí nhà cửa",
  "Sắp xếp lại kế hoạch công việc dài hạn",
  "Cúng giỗ tổ tiên, gia tiên",
  "Làm lễ cầu an, cúng bái",
  "Xây dựng, sửa chữa mồ mả tổ tiên",
  "Tổ chức lễ mừng thọ cho người cao tuổi",
  "Tổ chức đám cưới, lễ ăn hỏi trong gia đình",
  "Họp mặt gia đình, tộc họ",
  "Thăm hỏi, chăm sóc ông bà, cha mẹ",
  "Tổ chức lễ cúng đất, nhà cửa",
  "Tổ chức lễ thọ, lễ vu quy",
  "Cúng đầy tháng, thôi nôi cho con cái",
  "Xây dựng mối quan hệ với bà con trong họ",
  "Mở tiệc ăn mừng, lễ tạ ơn sau một sự kiện trọng đại",
  "Tổ chức mừng lễ cưới của các thành viên trong gia đình",
  "Lễ hội đền, chùa, thăm các địa danh lịch sử",
  "Đọc sách gia phả, tìm hiểu về nguồn gốc dòng họ",
  "Cúng lễ vào dịp tết Nguyên Đán",
  "Phân chia tài sản trong gia đình",
  "Bồi dưỡng nhân tài cho dòng họ, gia đình",
  "Phát triển các mối quan hệ giao thương với các họ hàng xa",
  "Tổ chức sinh nhật hoặc lễ kỷ niệm trong gia đình",
  "Lên kế hoạch tổ chức các chuyến du lịch, họp mặt gia đình",
];

List<String> KHONGNENLAM = [
  "Không làm việc vội vã",
  "Tránh tranh cãi, xung đột",
  "Không khai trương cửa hàng",
  "Không cưới hỏi, tổ chức lễ tân",
  "Không đầu tư tài sản lớn",
  "Không thay đổi công việc",
  "Tránh quyết định tài chính quan trọng",
  "Không mua sắm bất động sản lớn",
  "Không ký kết hợp đồng quan trọng",
  "Tránh ra mắt sản phẩm mới",
  "Không tổ chức các cuộc họp quan trọng",
  "Không làm việc dưới áp lực cao",
  "Tránh quyết định về mối quan hệ cá nhân",
  "Không thực hiện công việc sáng tạo mới",
  "Tránh tham gia dự án cộng đồng",
  "Không lập kế hoạch tài chính",
  "Tránh gặp gỡ đối tác quan trọng",
  "Không làm việc trong môi trường căng thẳng",
  "Không ký kết hợp đồng quan trọng",
  "Tránh quyết định đột xuất",
  "Không thay đổi chiến lược kinh doanh",
  "Không ký kết thỏa thuận mơ hồ",
  "Không làm việc khẩn cấp không có kế hoạch",
  "Tránh quyết định khi thiếu thông tin",
  "Không làm việc ngoài giờ",
  "Không làm việc ảnh hưởng đến sức khỏe",
  "Tránh tạo dựng quan hệ đối tác mới",
];

List<String> THAP_NHI_TRUC = [
  "Kiến",
  "Trừ",
  "Mãn",
  "Bình",
  "Định",
  "Chấp",
  "Phá",
  "Nguy",
  "Thành",
  "Thu",
  "Khai",
  "Bế"
];

List<String> THAP_NHI_TRUC_DESC = [
  "Đứng đầu Thập Nhị Trực, Trực Kiến thuộc nhóm thứ cát, là ngày tốt có ý nghĩa tráng kiện, vạn vật sinh sôi nảy nở. Đây là ngày phù hợp để: Xuất hành, ký kết, nhập học, kết hôn, thương lượng, phá thổ, cầu phúc, an sàng, khảo thí… Không nên đón xe mới, hạ thủy thuyền mới hay đào giếng, mở kho.",
  "Cũng thuộc nhóm ngày thứ cát, Trực Trừ mang ý nghĩa tống cựu nghênh tân, tẩy trừ điềm rủi. Vì thế, đây là ngày tốt để: Động thổ, giao dịch, xuất hành, té phúc, mở bếp mới, cầu thầy thuốc chữa bệnh hoặc bán hàng. Dù vậy, các sự kiện như ký thỏa ước, kết hôn, đi xa, phó nhậm nên dời lại.",
  "Cùng nhóm thứ cát, Trực Mãn là Trực thứ 3 của 12 Trực trong tháng, mang nghĩa đầy đủ, mỹ mãn nên thường được chọn làm ngày: Cầu tài, dời đồ, tế tự, chăn nuôi, giá thú, khai thị, lập khế ước… Tuy nhiên, nên kiêng cầu y, nhậm chức, kiện tụng trong ngày này.",
  "Là ngày bình thường, Trực Bình phù hợp để cầu tự, động thổ, tu tạo, chăn nuôi… Song không tốt để an táng, khai thị hay nhậm chức.",
  "Nối tiếp chuỗi ngày bình thường, Trực Định có ý nghĩa ổn định nhưng không phù hợp để: Xuất hành xa, kiện tụng hay giao thiệp. Tuy nhiên, nên chọn làm ngày: Sửa đường, nhập học, mở bếp mới, làm chuồng gia súc… ",
  "Trực Chấp là ngày xấu, còn gọi là Tiểu Hao, tức hơi kém, xếp vị trí thứ 6 trong 12 Trực. Đã là ngày không tốt thì không nên làm việc gì trọng đại, nhất là hỉ sự. Đặc biệt không nên: Dời nhà, cầu tài, khai thị, xuất hành. Một số công việc có thể miễn cưỡng làm trong ngày này, gồm: Tế tự, tu tạo, lập khế ước.",
  "Tương tự Trực Chấp, đây cũng là ngày xấu, không nên tiến hành đại sự. Vì Trực Phá có nghĩa là Đại Hao, xung giữa ngày và tháng, nên tránh chọn làm ngày: Mở hàng, cưới hỏi, dời nhà, xuất hành, ký ước, giao thiệp. Song có thể chọn làm ngày cầu y, phá thổ vì đây là thời điểm phù hợp để phá bỏ những thứ đã cũ kỹ, lỗi thời.",
  "Đứng thứ 8 trong 12 Trực, Trực Nguy thuộc nhóm ngày xấu, mang ý nghĩa nguy kịch, hiểm họa. Trong ngày này, nên tránh: Đi thuyền, tạo táng, leo núi, dời nhà, xuất hành. Miễn cưỡng có thể: Phá thổ, an sàng, cầu phúc.",
  "Mang ý nghĩa thành công, Trực Thành là ngày thượng cát, thích hợp tổ chức: Lễ động thổ, khai trương, thành hôn, dời nhà, xuất hành, chăn nuôi, trồng trọt, an sàng, an táng, giao dịch, cầu tài, phá thổ, lập ước, dựng cột… Không nên kiện tụng vào ngày Trực Thành.",
  "Vị trí thứ 10 trong 12 Trực là Trực Thu. Đây cũng là ngày tốt để làm lễ cầu tự, động thổ, mua bán, giao dịch, tế phúc, lập kế ước, tu tạo, khai thị… vì thuộc nhóm ngày thượng cát. Tuy nhiên, ngày này không nên: An sàng, chạy thử xe mới, cho vay, phá thổ hoặc hạ thủy tàu thuyền mới.",
  "Thuộc ngày thượng cát, Trực Khai mang ý nghĩa của sự khởi đầu. Ngày này thường được chọn để: Dựng cột, giao dịch, tu tạo, cầu phúc, thượng nhậm, khai thị, động thổ, xuất hành… Không nên cho vay, tố tụng trong ngày Trực Khai.",
  "Là ngày cuối cùng của 12 Trực trong tháng, Trực Bế còn thuộc nhóm ngày xấu. Trong ngày này, không nên: Cầu y, xuất hành, khai thị, phẫu thuật. Có thể: Lấp vá, đào ao, đào huyệt, tư tế… "
];

List<String> NHI_THAP_BAT_TU = [
  "Giác",
  "Cang",
  "Đê",
  "Phòng",
  "Tâm",
  "Vĩ",
  "Cơ",
  "Tỉnh",
  "Quỷ",
  "Liễu",
  "Tinh",
  "Trương",
  "Dực",
  "Chẩn",
  "Khuê",
  "Lâu",
  "Vị",
  "Mão",
  "Tất",
  "Chủy",
  "Sâm",
  "Đẩu",
  "Ngưu",
  "Nữ",
  "Hư",
  "Nguy",
  "Thất",
  "Bích"
];

// Hàm xác định trực
List<String> getThapNhiTruc(int dayOfMonth, int month) {
  Map<int, String> THANG_BAT_DAU = {
    1: "Dần", // Tháng Giêng (Dần)
    2: "Mão",
    3: "Thìn",
    4: "Tỵ",
    5: "Ngọ",
    6: "Mùi",
    7: "Thân",
    8: "Dậu",
    9: "Tuất",
    10: "Hợi",
    11: "Tý",
    12: "Sửu",
  };

  List<String> DIA_CHI = [
    "Tý",
    "Sửu",
    "Dần",
    "Mão",
    "Thìn",
    "Tỵ",
    "Ngọ",
    "Mùi",
    "Thân",
    "Dậu",
    "Tuất",
    "Hợi"
  ];

  String ngayTrucKien = THANG_BAT_DAU[month] ?? "Dần";

  int indexTrucKien = DIA_CHI.indexOf(ngayTrucKien);

  int indexNgay = (indexTrucKien + dayOfMonth - 1) % 12;

  int indexTruc = (indexNgay) % 12;

  return [THAP_NHI_TRUC[indexTruc], THAP_NHI_TRUC_DESC[indexTruc]];
}

// Hàm tính Nhị thập bát tú
String getNhiThapBatTu(int dayOfMonth) {
  int index = dayOfMonth % 28;
  return NHI_THAP_BAT_TU[index];
}

Map<String, List<String>> getTasksForDay(String canChi, DayType dayType,
    {int dayOfMonth = 1}) {
  int nenLamCount = 2;
  int khongNenLamCount = 2;

  if (dayType == DayType.hoangDao) {
    nenLamCount = 4; // Nên làm nhiều việc
    khongNenLamCount = 1; // Ít việc không nên làm
  } else if (dayType == DayType.hacDao) {
    nenLamCount = 1;
    khongNenLamCount = 4;
  } else {
    nenLamCount = 3;
    khongNenLamCount = 3;
  }

  int additionalNenLam = _getAdditionalTasksForCanChi(canChi);
  nenLamCount += additionalNenLam;

  if (dayOfMonth % 2 == 0) {
    nenLamCount++; // Ngày chẵn, thêm công việc cần làm
  }

  List<String> nenLam = _selectTasks(NENLAM, nenLamCount, canChi);
  List<String> khongNenLam =
      _selectTasks(KHONGNENLAM, khongNenLamCount, canChi);

  return {
    'shouldDo': nenLam,
    'shouldNotDo': khongNenLam,
  };
}

List<String> _selectTasks(List<String> tasks, int count, String canChi) {
  List<String> selectedTasks = [];

  int baseIndex = _calculateBaseIndex(canChi);

  for (int i = 0; i < count; i++) {
    selectedTasks.add(tasks[(baseIndex + i) % tasks.length]);
  }

  return selectedTasks;
}

int _calculateBaseIndex(String canChi) {
  int canIndex = _getCanIndex(canChi);
  int chiIndex = _getChiIndex(canChi);

  return (canIndex + chiIndex) % 10;
}

int _getCanIndex(String canChi) {
  Map<String, int> canIndexMap = {
    'Giáp': 0,
    'Ất': 1,
    'Bính': 2,
    'Đinh': 3,
    'Mậu': 4,
    'Kỷ': 5,
    'Canh': 6,
    'Tân': 7,
    'Nhâm': 8,
    'Quý': 9,
  };

  // Lấy chỉ số của Can từ CanChi
  String can = canChi.split(' ')[0];
  return canIndexMap[can] ?? 0;
}

int _getChiIndex(String canChi) {
  Map<String, int> chiIndexMap = {
    'Tý': 0,
    'Sửu': 1,
    'Dần': 2,
    'Mão': 3,
    'Thìn': 4,
    'Tỵ': 5,
    'Ngọ': 6,
    'Mùi': 7,
    'Thân': 8,
    'Dậu': 9,
    'Tuất': 10,
    'Hợi': 11,
  };

  // Lấy chỉ số của Chi từ CanChi
  String chi = canChi.split(' ')[1];
  return chiIndexMap[chi] ?? 0;
}

int _getAdditionalTasksForCanChi(String canChi) {
  // Chỉ số tác động của từng CanChi đối với số lượng công việc cần làm
  Map<String, int> canChiEffect = {
    'Giáp Tý': 2,
    'Ất Sửu': 3,
    'Bính Dần': 1,
    'Đinh Mão': 2,
    'Mậu Thìn': 1,
    'Kỷ Tỵ': 2,
    'Canh Ngọ': 3,
    'Tân Mùi': 1,
    'Nhâm Thân': 2,
    'Quý Dậu': 1,
    'Giáp Tuất': 2,
    'Ất Hợi': 3,
  };

  return canChiEffect[canChi] ?? 0;
}
