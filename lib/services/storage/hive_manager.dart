import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveManager {
  factory HiveManager() {
    return _singleton;
  }

  HiveManager._internal();

  static final HiveManager _singleton = HiveManager._internal();

  static final HiveManager shared = HiveManager();

  // app language
  static String appLanguageBoxName = 'App Language Box';
  static Box<String> appLanguageBox = Hive.box<String>(appLanguageBoxName);
  static String appLanguageBoxKey = 'App Language Box Key';

  // current language scan & solve
  static String scanAndSolveLanguageBoxName = 'Scan And Solve Language Box';
  static Box<String> scanAndSolveLanguageBox =
      Hive.box<String>(scanAndSolveLanguageBoxName);
  static String scanAndSolveLanguageBoxKey = 'Scan And Solve Language Box Key';

  Future<void> initHive() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await Hive.openBox<String>(appLanguageBoxName);
    await Hive.openBox<String>(scanAndSolveLanguageBoxName);
  }

  void saveAppLanguage(String value) =>
      appLanguageBox.put(appLanguageBoxKey, value);

  String getCurrentAppLanguage() =>
      appLanguageBox.get(appLanguageBoxKey) ?? 'vi';
}
