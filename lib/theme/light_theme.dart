import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jocards/utill/color_resources.dart';


ThemeData lightTheme() {
 return ThemeData(
visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: ColorResources.mainColor,
     fontFamily: 'DIN Next LT W23',
    brightness: Brightness.light,
   appBarTheme: const AppBarTheme(backgroundColor: ColorResources.mainColor,foregroundColor: Colors.white),

    focusColor: Color(0xFFADC4C8),
    hintColor: Color(0xFF52575C),
  pageTransitionsTheme: PageTransitionsTheme(
  builders: {
  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  }




  ));
}