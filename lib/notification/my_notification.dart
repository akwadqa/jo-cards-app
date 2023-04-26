
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MyNotification {
  static Future<void> initialize(BuildContext context,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    try {
      var androidInitialize =
       const AndroidInitializationSettings('app_icon');
      var iOSInitialize =  const DarwinInitializationSettings(

      );

      var initializationsSettings =  InitializationSettings(
          android: androidInitialize, iOS: iOSInitialize);


      flutterLocalNotificationsPlugin.initialize(initializationsSettings,
          onDidReceiveNotificationResponse: (NotificationResponse ?payload) async {
            try {
              // if (payload != null && payload.isNotEmpty) {
                // MyApp.navigatorKey.currentState.push(MaterialPageRoute(
                //     builder: (context) => OrderDetailsScreen(
                //         orderModel: null, orderId: int.parse(payload))));
              // }
            } catch (e) {}

            return;
          });
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {

      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        MyNotification.showTextNotification(
            message ,flutterLocalNotificationsPlugin);





      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      });
    }
    catch(e){
      int w = 0;
    }
  }



  static Future<void> showTextNotification(
      RemoteMessage  message, FlutterLocalNotificationsPlugin fln) async {
    var nextRandomId = Random();


    String _title = message.notification?.title??"";
    String _body = message.notification?.body??"";

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel',
      'public',
      channelDescription: 'public',

      importance: Importance.max,
      priority: Priority.max,playSound: true
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(presentAlert: true,presentBadge: true,presentSound: true);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
    await fln.show(nextRandomId.nextInt(1000), _title, _body, platformChannelSpecifics,
        payload: "");
  }

  static Future<void> showBigTextNotification(
      Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String _title = message['title'];
    String _body = message['body'];
    String _orderID = message['order_id'];
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      _body,
      htmlFormatBigText: true,
      contentTitle: _title,
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
          channelDescription:
          'big text channel description',
      importance: Importance.max,
      styleInformation: bigTextStyleInformation,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, _title, _body, platformChannelSpecifics,
        payload: _orderID);
  }




}





