// import 'dart:io';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

// class NotificationSetup {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   Future<void> initializeNotification() async {
//     AwesomeNotifications().initialize('resource://drawable/res_launcher_icon', [
//       NotificationChannel(
//           channelKey: 'high_importance_channel',
//           channelName: 'Chat Notifications',
//           importance: NotificationImportance.Max,
//           vibrationPattern: highVibrationPattern,
//           channelShowBadge: true,
//           channelDescription: "Chat")
//     ]);

//     // Check if notifications are enabled
//     AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
//       if (!isAllowed) {
//         AwesomeNotifications().requestPermissionToSendNotifications();
//       }
//     });
//   }

//   void configurePushNotifications(BuildContext context) async {
//     initializeNotification();

//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//             alert: true, badge: true, sound: true);

//     if (Platform.isIOS) getIOSPermission();

//     FirebaseMessaging.onBackgroundMessage(myBackgroundMessagingHandler);

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       print("==========");
//       print("=====${message.notification!.body}=====");
//       print("==========");
//       if (message.notification != null) {
//         createOrderNotifications(
//             title: message.notification!.title,
//             body: message.notification!.body);
//       }
//     });
//   }

//   Future<void> createOrderNotifications({String? title, String? body}) async {
//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: 0,
//             channelKey: 'high_importance_channel',
//             title: title,
//             body: body));
//   }

//   void getIOSPermission() {
//     _firebaseMessaging.requestPermission(
//         alert: true, badge: true, sound: true, provisional: true);
//   }
// }

// Future<dynamic> myBackgroundMessagingHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

// class NotificationController {
//   @pragma("vm:entry-point")
//   static Future<void> onActionReceivedMethos(
//       ReceivedNotification receivedNotification) async {
//     // TOOD: Implement notification
//   }
// }
