import 'dart:io';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/provider/home_provider.dart';
import 'package:jocards/screens/splash_screen.dart';
import 'package:jocards/theme/light_theme.dart';
import 'package:jocards/utill/app_local.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Network/resit_api.dart';
import 'notification/my_notification.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:dio/dio.dart';

late SharedPreferences sharedPreferences;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late PackageInfo packageInfo;
late BlueThermalPrinter bluetooth ;
late DeviceInfoPlugin deviceInfo ;
late AndroidDeviceInfo androidInfo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 sharedPreferences = await SharedPreferences.getInstance();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  deviceInfo = DeviceInfoPlugin();
  if(Platform.isAndroid){
    androidInfo = await deviceInfo.androidInfo;
    if(!androidInfo.model!.contains("TPS")) {
      bluetooth = BlueThermalPrinter.instance;
    }

  }
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  if (kDebugMode) {
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(false);
  }
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  packageInfo = await PackageInfo.fromPlatform();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
    ),
    ChangeNotifierProvider(
      create: (_) => HomeProvider(),
    ),
  ], child:  const MyApp()));
}

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder:  (BuildContext context, Widget ?child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0, ), //set desired text scale factor here
          child: child!,
        );
      },
      navigatorKey: navigator,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'AR'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'AR'),
      ],
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: lightTheme(),
      home: SplashScreen(),
    );
  }

  @override
  void initState() {
    MyNotification.initialize(context, flutterLocalNotificationsPlugin);
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
