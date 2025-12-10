import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

// Top-level function for background messages (Must be outside the class)
@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("👉 Handling a background message: ${message.messageId}");

  // If the message is a data message (no notification block), or if you want to override system behavior
  // Note: If 'notification' key is present in payload, Android system usually shows it automatically.
  // If only 'data' key is present, we must show it manually.

  // Check if we need to show a notification manually
  // (e.g. if message.notification is null, it's a data message)
  if (message.notification == null) {
      final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();
      
      const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
      
      await localNotifications.initialize(initSettings);

      // Extract title/body from data if available
      String title = message.data['title'] ?? 'New Notification';
      String body = message.data['body'] ?? 'You have a new message';

      await localNotifications.show(
        message.hashCode,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // Channel ID
            'High Importance Notifications', // Channel Name
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
  }
}

class NotificationService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    // 1. Request Permissions
    await _requestPermission();

    // 2. Initialize Local Notifications (For Foreground)
    await _initLocalNotifications();

    // 3. Set up Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 4. Handle Incoming Messages (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showForegroundNotification(message);
    });

    // 5. Handle Notification Taps (When app opens from notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("👉 Notification Clicked: ${message.data}");
      // Navigate to specific screen if needed
      // Get.toNamed(Routes.orders);
    });

    // 6. Get Token
    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $token");
    // TODO: Send this token to your backend (ProfileService) to link it with the user
    return this;
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher'); // Ensure this icon exists

    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(initSettings);
  }

  void _showForegroundNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // Use notification block if available, otherwise try data
    String? title = notification?.title ?? message.data['title'];
    String? body = notification?.body ?? message.data['body'];

    if (title != null || body != null) {
      _localNotifications.show(
        message.hashCode,
        title ?? 'New Notification',
        body ?? '',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel', // Channel ID
            'High Importance Notifications', // Channel Name
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }
}
