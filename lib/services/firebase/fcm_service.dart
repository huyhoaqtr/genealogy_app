import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:getx_app/services/storage/storage_manager.dart';
import '../../constants/app_routes.dart';

class FCMService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> initializeFCM() async {
    // Request notification permissions
    await messaging.requestPermission();

    // Get the device token
    String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      StorageManager.setFcmToken(fcmToken);
    }

    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received notification: ${message.notification?.title}");
      print("Received message body: ${message.notification?.body}");
    });

    // Handle notification click when app is in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['screen'] == 'message') {
        var conversationData = jsonDecode(message.data['conversation']);
        Get.toNamed(AppRoutes.messageDetail, arguments: {
          "conversation": conversationData,
        });
      }
    });

    // Handle initial notification when app is launched from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null && message.data['screen'] == 'message') {
        var conversationData = jsonDecode(message.data['conversation']);
        Get.offNamed(AppRoutes.messageDetail, arguments: {
          "conversation": conversationData,
        });
      }
    });
  }

  // Background message handler - should be static
  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    // You can handle background notifications here if needed
    if (message.data['screen'] == 'message') {
      var conversationData = jsonDecode(message.data['conversation']);
      Get.toNamed(AppRoutes.messageDetail, arguments: {
        "conversation": conversationData,
      });
    }
  }
}
