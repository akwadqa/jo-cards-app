import 'package:flutter/material.dart';
import 'package:jocards/utill/color_resources.dart';


ThemeData lightTheme() {
 return ThemeData(
visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: ColorResources.mainColor,
     fontFamily: 'DIN Next LT W23',
    brightness: Brightness.light,
   appBarTheme: const AppBarTheme(backgroundColor: ColorResources.mainColor,foregroundColor: Colors.white),

    focusColor: const Color(0xFFADC4C8),
    hintColor: const Color(0xFF52575C),
  pageTransitionsTheme: const PageTransitionsTheme(
  builders: {
  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  }




  ));
}