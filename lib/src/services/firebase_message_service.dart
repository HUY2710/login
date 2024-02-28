import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../config/di/di.dart';
import '../config/navigation/app_router.dart';
import '../global/global.dart';
import '../shared/extension/context_extension.dart';
import '../shared/helpers/env_params.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.',
  importance: Importance.max,
);

abstract class NotificationService {
  /// When send a message.
  Future<void> sendChatNotification(String groupId, String groupName);

  /// When enter or left place.
  Future<void> sendPlaceNotification(
      {required String groupId,
      required bool enter,
      required String message,
      BuildContext? context});

  /// When check in any location.
  Future<void> sendCheckInNotification(
      String groupId, String address, BuildContext? context);
}

@singleton
class FirebaseMessageService implements NotificationService {
  FirebaseMessageService();

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  //First we need to create an instance for the FlutterLocalNotificationPlugin.
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {},
    );
  }

  Future<void> startService() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    final NotificationSettings settings = await messaging.requestPermission();

    debugPrint('User granted permission: ${settings.authorizationStatus}');

    // Show notification when application in foreground.
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    } else {
      // Android: Use local notification to present notification in foreground.
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          ?.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');
      debugPrint(
          'Notification from you: ${message.data['key'] == Global.instance.user?.code}');
      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');
      }

      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;

      //kiểm tra nếu thông báo đó là từ mình thì không cần show
      //&&message.data['key'] != Global.instance.user?.code
      if (notification != null &&
              android != null &&
              message.data['key'] != Global.instance.user?.code
          //comment lại đoạn trên để test
          ) {
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

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    debugPrint('Handling a background message: ${message.messageId}');
  }

  void listenBackgroundMessage() {
    try {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (error) {
      debugPrint('error:$error');
    }
  }

  Future<void> subscribeTopics(List<String> topics) async {
    debugPrint('Subscribe list topics: $topics');
    await Future.wait(topics
        .map((e) => FirebaseMessaging.instance.subscribeToTopic(e))
        .toList());
  }

  Future<void> unSubscribeTopics(List<String> topics) async {
    debugPrint('UnSubscribe list topics: $topics');
    await Future.wait(topics
        .map((e) => FirebaseMessaging.instance.unsubscribeFromTopic(e))
        .toList());
  }

  @override
  Future<void> sendChatNotification(String groupId, String groupName) async {
    final message =
        '${Global.instance.user?.userName} ${getIt<AppRouter>().navigatorKey.currentContext!.l10n.sendMessageNoti} $groupName';
    await _sendMessage(groupId,
        Global.instance.packageInfo?.appName ?? 'Cycle Sharing', message);
  }

  @override
  Future<void> sendPlaceNotification(
      {required String groupId,
      required bool enter,
      required String message,
      BuildContext? context}) async {
    await _sendMessage(groupId,
        Global.instance.packageInfo?.appName ?? 'Cycle Sharing', message);
  }

  @override
  Future<void> sendCheckInNotification(
      String groupId, String address, BuildContext? context) async {
    final message =
        '${Global.instance.user?.userName} ${context?.l10n.checkInNoti} $address';
    await _sendMessage(groupId,
        Global.instance.packageInfo?.appName ?? 'Cycle Sharing', message);
  }
}

extension FirebaseMessageServiceExt on FirebaseMessageService {
  Future<void> _sendMessage(String topic, String title, String message,
      {String? dataId}) async {
    final url = Uri.https(EnvParams.apiUrlNotification,
        'group-location-sharing/send-notification');
    final headers = {
      'Content-Type': 'application/json',
    };
    final params = {
      'title': title,
      'message': message,
      'topic': topic,
      'data': {'key': dataId ?? Global.instance.user?.code}
    };
    final response =
        await http.post(url, headers: headers, body: json.encode(params));
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
  }
}
