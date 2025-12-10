import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseMessagingService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<FirebaseMessagingService> init() async {
    // Request permission for iOS and Android 13+
    await requestPermission();

    // Get FCM Token
    await getToken();

    // Handle messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
        // Show a local notification or snackbar
        Get.snackbar(
          message.notification!.title ?? 'Notification',
          message.notification!.body ?? '',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
      }
    });

    // Handle messages when the app is opened from a background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      // Navigate to specific screen based on message data
    });

    return this;
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  Future<String?> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $token");
    // You might want to save this token to your backend
    return token;
  }
}

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint("Handling a background message: ${message.messageId}");
}
