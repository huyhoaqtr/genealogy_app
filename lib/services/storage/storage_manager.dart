import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../resources/models/tribe.model.dart';
import '../../resources/models/user.model.dart';

class StorageManager {
  static const String user = 'user';
  static const String token = 'token';
  static const String fcmToken = 'fcmToken';
  static const String tribe = 'tribe';
  static const String remoteConfigKey = 'remoteConfigKey';

  static FlutterSecureStorage storage = const FlutterSecureStorage(
      iOptions: IOSOptions(),
      aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static Future<void> setUser(User value) async {
    final String userJson = jsonEncode(value.toJson());
    return storage.write(key: user, value: userJson);
  }

  static Future<User?> getUser() async {
    final String? userJson = await storage.read(key: user);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> setTribe(TribeModel value) async {
    final String tribeJson = jsonEncode(value.toJson());
    return storage.write(key: tribe, value: tribeJson);
  }

  static Future<TribeModel?> getTribe() async {
    final String? tribeJson = await storage.read(key: tribe);
    if (tribeJson != null) {
      return TribeModel.fromJson(jsonDecode(tribeJson));
    }
    return null;
  }

  static Future<void> setToken(String value) async {
    return storage.write(key: token, value: value);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: token);
  }

  static Future<void> setFcmToken(String value) async {
    return storage.write(key: fcmToken, value: value);
  }

  static Future<String?> getFcmToken() async {
    return await storage.read(key: fcmToken);
  }

  static Future<void> setLastRemoteConfigValue(String value) async {
    return storage.write(key: remoteConfigKey, value: value);
  }

  static Future<String> getLastRemoteConfigValue() async {
    final map = await storage.readAll();
    final String? rs = map[remoteConfigKey];
    return rs ?? '';
  }

  static Future<void> clearData() async {
    await storage.deleteAll();
  }
}
