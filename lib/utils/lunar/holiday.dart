Map<String, String> holidays = {
  "1-1": "Mùng 1 - Tết Nguyên Đán",
  "2-1": "Mùng 2 - Tết Nguyên Đán",
  "3-1": "Mùng 3 - Tết Nguyên Đán",
  "15-1": "Tết Nguyên Tiêu",
  "3-3": "Tết Hàn Thực",
  "10-3": "Giỗ Tổ Hùng Vương",
  "15-4": "Tết Thanh Minh",
  "1-5": "Tết Đoan Ngọ",
  "15-7": "Lễ Vu Lan",
  "15-8": "Tết Trung Thu",
  "23-12": "Tết Ông Công, Ông Táo",
};

String? getHoliday(String lunarDate) {
  var parts = lunarDate.split('/');
  String formattedDate = '${parts[0]}-${parts[1]}';
  return holidays[formattedDate];
}
