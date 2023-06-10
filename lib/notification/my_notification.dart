
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jocards/main.dart';
import 'package:jocards/model/login_response_model.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:provider/provider.dart';

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

      FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      ).then((value) async{
        if(value.authorizationStatus.name == "authorized" ) {
          Provider.of<AppProvider>(context, listen: false).setAgreeNotification(true);
          await Provider.of<AppProvider>(context, listen: false).getFirebaseToken() == "" ? getTokenFromFirebase(context): getRefreshTokenFromFirebase(context);

        }
        else{
          Provider.of<AppProvider>(context, listen: false).setAgreeNotification(false);
        }
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

  static Future<void> getTokenFromFirebase(BuildContext context) async{
    FirebaseMessaging.instance.getToken().then((value) async {
      await Provider.of<AppProvider>(context, listen: false).setFirebaseToken(value!);
    });
  }

  static Future<void> getRefreshTokenFromFirebase(BuildContext context) async{
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      Provider.of<AppProvider>(context, listen: false).setFirebaseToken(newToken);
      if(await Provider.of<AppProvider>(context, listen: false).isUserSigned()){
      LoginResponseModel? userInfo = Provider.of<AppProvider>(context, listen: false).getUserInfo();
      Provider.of<AppProvider>(context, listen: false).sendUpdateToken(newToken, userInfo!.user!, Platform.isAndroid ? "android" : "ios" , androidInfo.device);
      }
      // Save newToken
    });
  }

  static Future<void> showTextNotification(
      RemoteMessage  message, FlutterLocalNotificationsPlugin fln) async {
    var nextRandomId = Random();


    String title = message.notification?.title??"";
    String body = message.notification?.body??"";

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
    await fln.show(nextRandomId.nextInt(1000), title, body, platformChannelSpecifics,
        payload: "");
  }

  static Future<void> showBigTextNotification(
      Map<String, dynamic> message, FlutterLocalNotificationsPlugin fln) async {
    String title = message['title'];
    String body = message['body'];
    String orderID = message['order_id'];
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: title,
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
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(0, title, body, platformChannelSpecifics,
        payload: orderID);
  }




}





