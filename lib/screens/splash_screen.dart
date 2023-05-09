import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:jocards/model/app_version_model.dart';
import 'package:jocards/provider/app_provider.dart';
import 'package:jocards/screens/main_screen/shared_bottom_nav_bar.dart';
import 'package:jocards/screens/update_screen.dart';
import 'package:jocards/utill/utitlities.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../generated/assets.dart';
import '../main.dart';
import 'auth/sign_in_screen.dart';
import 'main_screen/main_screen.dart';

class SplashScreen extends StatefulWidget {
  State<StatefulWidget> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  void _initState() async {
    if (await Provider.of<AppProvider>(context, listen: false)
        .checkInternet()) {
      SchedulerBinding.instance!.addPostFrameCallback((_) async {
        context.read<AppProvider>().getTerritories();
        // fetch data

        // fetch data
        try {
          startTime();
        } catch (e) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: new Text("حدث خطأ تقني"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(
                    "موافق",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    exit(0);
                  },
                )
              ],
            ),
          );
        }
      });
    } else {
      showAlertDialog(context);
    }
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("لايوجد اتصال بالانترنت"),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
              "موافق",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              exit(0);
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    _initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: transparentStatusBarAndTransparentSystemBar,
      child: Image.asset(
        Assets.imgNewSplash,
        fit: BoxFit.cover,
      ),
    );
  }

  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  bool _isNeedToUpdate = true;

  void navigationPage() async {
    await context.read<AppProvider>().getUtilities();
    await context.read<AppProvider>().getAppVersion();
    if (Platform.isAndroid) {
      if (context.read<AppProvider>().getBluetoothDevice() != null &&
          !androidInfo.model!.contains("TPS")) {
        connect(context.read<AppProvider>().getBluetoothDevice());
      }
    }
    AppVersionModel? appVersionModel = context.read<AppProvider>().appVersionModel;
    if(appVersionModel != null){
      await _checkAppVersion(appVersionModel);
      if(_isNeedToUpdate){
        await Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.leftToRight,
            child: UpdateScreen(appVersionModel: appVersionModel),
          ),
        );
      }
      await _navigate();
    }
  }

  Future<void> _checkAppVersion(AppVersionModel appVersionModel) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    if(Platform.isAndroid){
      _compareVersions(appVersionModel.androidApiVersion!, version);
    }
    if(Platform.isIOS){
      _compareVersions(appVersionModel.iosApiVersion!, version);
    }
  }

  void _compareVersions(String apiVersion, String appVersion){
    if(kDebugMode){
      print('apiVersion: $apiVersion');
      print('appVersion: $appVersion');
    }
    if(apiVersion.versionToInt > appVersion.versionToInt){
      _isNeedToUpdate = true;
    }
    else{
      _isNeedToUpdate = false;
    }
  }

  Future<void> _navigate() async {
    if (await Provider.of<AppProvider>(context, listen: false).isUserSigned()) {
      await context.read<AppProvider>().getAgentCustomers();
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: SharedBottomNavigationBar(widget: MainScreen()),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: SignInScreen(),
        ),
      );
    }
  }
}

extension StringExtension on String{
  int get versionToInt {
    if(contains('.')){
      final version = split('.');
      if(version.length == 3){
        return int.parse(version.join());
      }
      else{
        return int.parse('${version.join()}0');
      }
    }
    else{
      return int.parse('${this}00');
    }
  }
}
