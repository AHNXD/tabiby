import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Assuming your CacheHelper is here
import '../utils/cache_helper.dart';

// 1. ADD THIS ANNOTATION
// This is critical for Android release mode to prevent tree-shaking
@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log("Handling a background message: ${message.messageId}");

  // NOTE: If your message contains a 'notification' block (title/body),
  // Android handles it automatically. We generally do NOT need to show
  // a LocalNotification here unless it is a "Data Only" message.
  // I have commented this out to prevent DUPLICATE notifications.

  /* if (message.notification != null) {
     // Only un-comment this if you are strictly sending Data-Only messages
     // and want to construct the notification manually in the background.
  }
  */
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'Highly Important Notifications',
    description: 'This Channel is used for important notifications',
    importance: Importance.max,
    playSound: true,
  );

  Future<void> initNotifications() async {
    await requestNotificationPermission();
    await _initLocalNotifications(); // Initialize local settings first
    await _initPushNotifications(); // Then listeners
  }

  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    log('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> _initLocalNotifications() async {
    // 2. USE PROPER ICONS
    // Ensure 'ic_launcher' exists in android/app/src/main/res/drawable
    // It is safer to use @mipmap/ic_launcher for initialization
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotifications.initialize(
      settings,
      // 3. HANDLE FOREGROUND NOTIFICATION CLICKS
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log("Foreground Local Notification Clicked");
        if (response.payload != null) {
          final messageData = jsonDecode(response.payload!);
          handleMessageData(messageData);
        }
      },
    );

    final platform = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> _initPushNotifications() async {
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // Handle standard foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      final android = message.notification?.android;

      // If we are in the foreground, standard Firebase notifications
      // are NOT shown by the OS. We use Local Notifications to show them.
      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@mipmap/ic_launcher', // Consistent icon
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          // Pass data payload so we can handle clicks
          payload: jsonEncode(message.data),
        );
      }
    });

    // Handle Notification Click (App in Background / Terminated)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("Background Notification Clicked (onMessageOpenedApp)");
      handleMessageData(message.data);
    });

    // Handle Notification Click (App Terminated -> Launched)
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      log("Terminated Notification Clicked (getInitialMessage)");
      handleMessageData(initialMessage.data);
    }

    await saveToken();
  }

  // Centralized handler for navigation logic
  void handleMessageData(Map<String, dynamic> data) {
    log("Handling Message Data: $data");
    // TODO: Add your context-free navigation here (e.g., Get.to, GlobalKey, GoRouter)
  }

  Future<void> saveToken() async {
    if (Platform.isIOS) {
      String? apnsToken = await _firebaseMessaging.getAPNSToken();

      if (apnsToken == null) {
        await Future.delayed(const Duration(seconds: 3));
        apnsToken = await _firebaseMessaging.getAPNSToken();
      }

      if (apnsToken == null) {
        log(
          "Failed to get APNS token. If you are on the Simulator, this is normal. Push notifications only work on real iOS devices.",
        );
        return;
      }
    }
    String? token = await _firebaseMessaging.getToken();

    log("FCM Token: $token");

    if (token != null) {
      await CacheHelper.setString(key: "fcm_token", value: token);
    }

    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      log("FCM Token Refreshed: $newToken");
      CacheHelper.setString(key: "fcm_token", value: newToken);
      // TODO: Send new token to backend
    });
  }
}
