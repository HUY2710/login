
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
);

abstract class NotificationService {
  /// When send a message.
  Future<void> sendChatNotification();

  /// When enter or left place.
  Future<void> sendPlaceNotification();

  /// When check in any location.
  Future<void> sendCheckInNotification();
}

@singleton
class FirebaseMessageService implements NotificationService {
  FirebaseMessageService();

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  Future<void> startService() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    final NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');

    // Show notification when application in foreground.
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    } else {
      // Android: Use local notification to present notification in foreground.
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin?.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
      }

      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin?.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                // other properties...
              ),
            ));
      }
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    debugPrint('Handling a background message: ${message.messageId}');
  }

  void listenBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> subscribeTopics(List<String> topics) async {
    await Future.wait(topics.map((e) => FirebaseMessaging.instance.subscribeToTopic(e)).toList());
  }

  Future<void> unSubscribeTopics(List<String> topics) async {
    await Future.wait(topics.map((e) => FirebaseMessaging.instance.unsubscribeFromTopic(e)).toList());
  }

  @override
  Future<void> sendChatNotification() {
    // TODO: implement sendChatNotification
    throw UnimplementedError();
  }

  @override
  Future<void> sendPlaceNotification() {
    // TODO: implement sendPlaceNotification
    throw UnimplementedError();
  }

  @override
  Future<void> sendCheckInNotification() {
    // TODO: implement sendCheckInNotification
    throw UnimplementedError();
  }
}

extension FirebaseMessageServiceExt on FirebaseMessageService {
  Future<void> _sendMessage(String topic, String title, String message, String dataId) async {
    final url = Uri.https('cs-dev.aicloud.vn', 'send-notification');
    final headers = {
      'Content-Type': 'application/json',
    };
    final params = {
      'title': title,
      'message': message,
      'topic': topic,
      'data': {
        'key': dataId
      }
    };
    final response = await http.post(url, headers: headers, body: json.encode(params));
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
  }
}
