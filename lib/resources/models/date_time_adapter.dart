import 'package:hive/hive.dart';

class DateTimeAdapter extends TypeAdapter<DateTime> {
  @override
  DateTime read(BinaryReader reader) {
    return DateTime.fromMillisecondsSinceEpoch(reader.readInt32());
  }

  @override
  void write(BinaryWriter writer, DateTime obj) {
    writer.writeInt32(obj.millisecondsSinceEpoch);
  }

  @override
  int get typeId => 5; // Định danh duy nhất cho DateTimeAdapter
}
